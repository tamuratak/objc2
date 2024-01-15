use core::ffi::c_void;
use core::fmt;
use core::marker::PhantomData;
use core::mem::{self, ManuallyDrop, MaybeUninit};
use core::ops::Deref;
use core::ptr;
use std::os::raw::c_ulong;

use objc2::encode::{EncodeArgument, EncodeReturn, Encoding, RefEncode};

use crate::abi::{BlockDescriptorCopyDispose, BlockDescriptorPtr, BlockFlags, BlockHeader};
use crate::debug::debug_block_header;
use crate::{ffi, Block, BlockArguments, RcBlock};

mod private {
    pub trait Sealed<A> {}
}

/// Types that may be converted into a block.
///
/// This is implemented for [`Fn`] closures of up to 12 arguments, where each
/// argument implements [`EncodeArgument`] and the return type implements
/// [`EncodeReturn`].
///
///
/// # Safety
///
/// This is a sealed trait, and should not need to be implemented. Open an
/// issue if you know a use-case where this restrition should be lifted!
pub unsafe trait IntoBlock<A: BlockArguments>: private::Sealed<A> + Sized {
    /// The return type of the resulting `StackBlock`.
    type Output: EncodeReturn;

    #[doc(hidden)]
    fn __get_invoke_stack_block() -> unsafe extern "C" fn();
}

macro_rules! into_block_impl {
    ($($a:ident : $t:ident),*) => (
        impl<$($t: EncodeArgument,)* R: EncodeReturn, X> private::Sealed<($($t,)*)> for X
        where
            X: Fn($($t,)*) -> R,
        {}

        unsafe impl<$($t: EncodeArgument,)* R: EncodeReturn, X> IntoBlock<($($t,)*)> for X
        where
            X: Fn($($t,)*) -> R,
        {
            type Output = R;

            fn __get_invoke_stack_block() -> unsafe extern "C" fn() {
                unsafe extern "C" fn invoke<$($t,)* R, X>(
                    block: &StackBlock<($($t,)*), R, X>,
                    $($a: $t,)*
                ) -> R
                where
                    X: Fn($($t,)*) -> R,
                {
                    (block.closure)($($a),*)
                }

                unsafe {
                    mem::transmute::<
                        unsafe extern "C" fn(&StackBlock<($($t,)*), R, X>, $($a: $t,)*) -> R,
                        unsafe extern "C" fn(),
                    >(invoke)
                }
            }
        }
    );
}

into_block_impl!();
into_block_impl!(a: A);
into_block_impl!(a: A, b: B);
into_block_impl!(a: A, b: B, c: C);
into_block_impl!(a: A, b: B, c: C, d: D);
into_block_impl!(a: A, b: B, c: C, d: D, e: E);
into_block_impl!(
    a: A,
    b: B,
    c: C,
    d: D,
    e: E,
    f: F
);
into_block_impl!(
    a: A,
    b: B,
    c: C,
    d: D,
    e: E,
    f: F,
    g: G
);
into_block_impl!(
    a: A,
    b: B,
    c: C,
    d: D,
    e: E,
    f: F,
    g: G,
    h: H
);
into_block_impl!(
    a: A,
    b: B,
    c: C,
    d: D,
    e: E,
    f: F,
    g: G,
    h: H,
    i: I
);
into_block_impl!(
    a: A,
    b: B,
    c: C,
    d: D,
    e: E,
    f: F,
    g: G,
    h: H,
    i: I,
    j: J
);
into_block_impl!(
    a: A,
    b: B,
    c: C,
    d: D,
    e: E,
    f: F,
    g: G,
    h: H,
    i: I,
    j: J,
    k: K
);
into_block_impl!(
    a: A,
    b: B,
    c: C,
    d: D,
    e: E,
    f: F,
    g: G,
    h: H,
    i: I,
    j: J,
    k: K,
    l: L
);

/// An Objective-C block whose size is known at compile time and may be
/// constructed on the stack.
#[repr(C)]
pub struct StackBlock<A, R, F> {
    p: PhantomData<Block<A, R>>,
    pub(crate) header: BlockHeader,
    pub(crate) closure: F,
}

unsafe impl<A: BlockArguments, R: EncodeReturn, F> RefEncode for StackBlock<A, R, F> {
    const ENCODING_REF: Encoding = Encoding::Block;
}

impl<A, R, F> StackBlock<A, R, F>
where
    A: BlockArguments,
    R: EncodeReturn,
    F: IntoBlock<A, Output = R>,
{
    /// Constructs a `StackBlock` with the given closure.
    /// When the block is called, it will return the value that results from
    /// calling the closure.
    pub fn new(closure: F) -> Self {
        unsafe { Self::with_invoke(F::__get_invoke_stack_block(), closure) }
    }
}

impl<A, R, F> StackBlock<A, R, F> {
    // TODO: Use new ABI with BLOCK_HAS_SIGNATURE
    const FLAGS: BlockFlags = if mem::needs_drop::<Self>() {
        BlockFlags::BLOCK_HAS_COPY_DISPOSE
    } else {
        BlockFlags::EMPTY
    };

    const DESCRIPTOR: BlockDescriptorCopyDispose = BlockDescriptorCopyDispose {
        reserved: 0,
        size: mem::size_of::<Self>() as c_ulong,
        copy: if mem::needs_drop::<Self>() {
            Some(block_context_copy::<Self>)
        } else {
            None
        },
        dispose: if mem::needs_drop::<Self>() {
            Some(block_context_dispose::<Self>)
        } else {
            None
        },
    };

    /// Constructs a `StackBlock` with the given invoke function and closure.
    /// Unsafe because the caller must ensure the invoke function takes the
    /// correct arguments.
    unsafe fn with_invoke(invoke: unsafe extern "C" fn(), closure: F) -> Self {
        let header = BlockHeader {
            isa: unsafe { ptr::addr_of!(ffi::_NSConcreteStackBlock) },
            flags: Self::FLAGS,
            reserved: MaybeUninit::new(0),
            invoke: Some(invoke),
            descriptor: BlockDescriptorPtr {
                with_copy_dispose: &Self::DESCRIPTOR,
            },
        };
        Self {
            p: PhantomData,
            header,
            closure,
        }
    }
}

impl<A, R, F: 'static> StackBlock<A, R, F> {
    /// Copy self onto the heap as an `RcBlock`.
    pub fn copy(self) -> RcBlock<A, R> {
        // Our copy helper will run so the block will be moved to the heap
        // and we can forget the original block because the heap block will
        // drop in our dispose helper. TODO: Verify this.
        let mut block = ManuallyDrop::new(self);
        let ptr: *mut Self = &mut *block;
        unsafe { RcBlock::copy(ptr.cast()) }
    }
}

impl<A, R, F: Clone> Clone for StackBlock<A, R, F> {
    fn clone(&self) -> Self {
        unsafe { Self::with_invoke(self.header.invoke.unwrap(), self.closure.clone()) }
    }
}

impl<A, R, F> Deref for StackBlock<A, R, F> {
    type Target = Block<A, R>;

    fn deref(&self) -> &Self::Target {
        let ptr: *const Self = self;
        let ptr: *const Block<A, R> = ptr.cast();
        // TODO: SAFETY
        unsafe { ptr.as_ref().unwrap_unchecked() }
    }
}

unsafe extern "C" fn block_context_dispose<B>(block: *mut c_void) {
    unsafe { ptr::drop_in_place(block.cast::<B>()) };
}

unsafe extern "C" fn block_context_copy<B>(_dst: *mut c_void, _src: *mut c_void) {
    // The runtime memmoves the src block into the dst block, nothing to do
}

impl<A, R, F> fmt::Debug for StackBlock<A, R, F> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut f = f.debug_struct("StackBlock");
        debug_block_header(&self.header, &mut f);
        f.finish_non_exhaustive()
    }
}
