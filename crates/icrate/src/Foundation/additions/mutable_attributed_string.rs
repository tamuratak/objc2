use objc2::rc::{DefaultId, Id, Owned, Shared};
use objc2::{extern_methods, msg_send_id, ClassType};

use crate::Foundation::{
    NSAttributedString, NSCopying, NSMutableAttributedString, NSMutableCopying, NSString,
};

extern_methods!(
    /// Creating mutable attributed strings.
    unsafe impl NSMutableAttributedString {
        /// Construct an empty mutable attributed string.
        #[method_id(new)]
        pub fn new() -> Id<Self, Owned>;

        // TODO: new_with_attributes

        #[doc(alias = "initWithString:")]
        pub fn from_nsstring(string: &NSString) -> Id<Self, Owned> {
            unsafe { msg_send_id![Self::alloc(), initWithString: string] }
        }

        #[doc(alias = "initWithAttributedString:")]
        pub fn from_attributed_nsstring(attributed_string: &NSAttributedString) -> Id<Self, Owned> {
            unsafe { msg_send_id![Self::alloc(), initWithAttributedString: attributed_string] }
        }
    }
);

impl DefaultId for NSMutableAttributedString {
    type Ownership = Owned;

    #[inline]
    fn default_id() -> Id<Self, Self::Ownership> {
        Self::new()
    }
}

unsafe impl NSCopying for NSMutableAttributedString {
    type Ownership = Shared;
    type Output = NSAttributedString;
}

unsafe impl NSMutableCopying for NSMutableAttributedString {
    type Output = NSMutableAttributedString;
}

impl alloc::borrow::ToOwned for NSMutableAttributedString {
    type Owned = Id<NSMutableAttributedString, Owned>;
    fn to_owned(&self) -> Self::Owned {
        self.mutable_copy()
    }
}

#[cfg(test)]
mod tests {
    use alloc::string::ToString;

    use super::*;

    #[test]
    fn test_new() {
        let s = NSAttributedString::new();
        assert_eq!(&s.string().to_string(), "");
    }

    #[test]
    fn test_copy() {
        let s1 = NSMutableAttributedString::from_nsstring(&NSString::from_str("abc"));
        let s2 = s1.copy();
        assert_ne!(Id::as_ptr(&s1).cast(), Id::as_ptr(&s2));
        assert!(s2.is_kind_of::<NSAttributedString>());

        let s3 = s1.mutable_copy();
        assert_ne!(Id::as_ptr(&s1), Id::as_ptr(&s3));
        assert!(s3.is_kind_of::<NSMutableAttributedString>());
    }
}