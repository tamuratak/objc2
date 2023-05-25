	.section	__TEXT,__text,regular,pure_instructions
	.syntax unified
	.globl	_iter_create
	.p2align	2
	.code	32
_iter_create:
	vmov.i32	q8, #0x0
	mov	r2, #0
	str	r1, [r0]
	add	r1, r0, #80
	str	r2, [r0, #100]
	str	r2, [r0, #104]
	str	r2, [r0, #72]
	str	r2, [r0, #76]
	add	r0, r0, #4
	vst1.32	{d16, d17}, [r0]!
	vst1.32	{d16, d17}, [r0]!
	vst1.32	{d16, d17}, [r0]!
	vst1.32	{d16, d17}, [r1]!
	vst1.32	{d16, d17}, [r0]!
	str	r2, [r1]
	str	r2, [r0]
	bx	lr

	.globl	_iter_once
	.p2align	2
	.code	32
_iter_once:
	push	{r4, r5, r6, r7, lr}
	add	r7, sp, #12
	push	{r8, r10}
	sub	sp, sp, #4
	mov	r4, r0
	ldrd	r0, r1, [r0, #100]
	cmp	r0, r1
	blo	LBB1_4
	ldr	r6, [r4]
	movw	r10, :lower16:(L__ZN6icrate10Foundation9generated14__NSEnumerator17NSFastEnumeration41countByEnumeratingWithState_objects_count10CACHED_SEL17h37ea10daa3c347f7E$non_lazy_ptr-(LPC1_0+8))
	movt	r10, :upper16:(L__ZN6icrate10Foundation9generated14__NSEnumerator17NSFastEnumeration41countByEnumeratingWithState_objects_count10CACHED_SEL17h37ea10daa3c347f7E$non_lazy_ptr-(LPC1_0+8))
	add	r8, r4, #4
LPC1_0:
	ldr	r10, [pc, r10]
	add	r5, r4, #68
	ldr	r1, [r10]
	cmp	r1, #0
	bne	LBB1_3
	movw	r0, :lower16:(l_anon.[ID].0-(LPC1_1+8))
	movt	r0, :upper16:(l_anon.[ID].0-(LPC1_1+8))
LPC1_1:
	add	r0, pc, r0
	bl	SYM(objc2::runtime::Sel::register_unchecked::GENERATED_ID, 0)
	mov	r1, r0
	str	r0, [r10]
LBB1_3:
	mov	r0, #16
	mov	r2, r5
	str	r0, [sp]
	mov	r0, r6
	mov	r3, r8
	bl	_objc_msgSend
	mov	r1, r0
	mov	r0, #0
	cmp	r1, #0
	strd	r0, r1, [r4, #100]
	beq	LBB1_5
LBB1_4:
	ldr	r1, [r4, #72]
	add	r2, r0, #1
	str	r2, [r4, #100]
	ldr	r0, [r1, r0, lsl #2]
LBB1_5:
	sub	sp, r7, #20
	pop	{r8, r10}
	pop	{r4, r5, r6, r7, pc}

	.globl	_use_obj
	.p2align	2
	.code	32
_use_obj:
	sub	sp, sp, #4
	str	r0, [sp]
	mov	r0, sp
	@ InlineAsm Start
	@ InlineAsm End
	add	sp, sp, #4
	bx	lr

	.globl	_iter
	.p2align	2
	.code	32
_iter:
	push	{r4, r5, r6, r7, lr}
	add	r7, sp, #12
	push	{r8, r10, r11}
	sub	sp, sp, #120
	bfc	sp, #0, #3
	add	r1, sp, #8
	vmov.i32	q8, #0x0
	orr	r4, r1, #4
	add	r2, r1, #80
	mov	r6, r0
	mov	r0, #0
	mov	r5, r4
	vst1.64	{d16, d17}, [r2]!
	mov	r11, #16
	mov	r1, #0
	vst1.32	{d16, d17}, [r5]!
	vst1.32	{d16, d17}, [r5]!
	vst1.32	{d16, d17}, [r5]!
	vst1.32	{d16, d17}, [r5]!
	str	r0, [r2]
	str	r0, [r5]
	str	r0, [sp, #112]
	str	r0, [sp, #108]
	str	r0, [sp, #84]
	str	r0, [sp, #80]
	str	r6, [sp, #8]
	movw	r10, :lower16:(L__ZN6icrate10Foundation9generated14__NSEnumerator17NSFastEnumeration41countByEnumeratingWithState_objects_count10CACHED_SEL17h37ea10daa3c347f7E$non_lazy_ptr-(LPC3_0+8))
	movt	r10, :upper16:(L__ZN6icrate10Foundation9generated14__NSEnumerator17NSFastEnumeration41countByEnumeratingWithState_objects_count10CACHED_SEL17h37ea10daa3c347f7E$non_lazy_ptr-(LPC3_0+8))
	movw	r8, :lower16:(l_anon.[ID].0-(LPC3_1+8))
	movt	r8, :upper16:(l_anon.[ID].0-(LPC3_1+8))
LPC3_0:
	ldr	r10, [pc, r10]
LPC3_1:
	add	r8, pc, r8
	b	LBB3_3
LBB3_1:
	mov	r0, r6
	mov	r2, r5
	mov	r3, r4
	str	r11, [sp]
	bl	_objc_msgSend
	mov	r1, #0
	cmp	r0, #0
	str	r0, [sp, #112]
	beq	LBB3_6
LBB3_2:
	ldr	r0, [sp, #80]
	add	r2, r1, #1
	str	r2, [sp, #108]
	ldr	r0, [r0, r1, lsl #2]
	bl	_use_obj
	ldr	r6, [sp, #8]
	ldr	r1, [sp, #108]
	ldr	r0, [sp, #112]
LBB3_3:
	cmp	r1, r0
	blo	LBB3_2
	ldr	r1, [r10]
	cmp	r1, #0
	bne	LBB3_1
	mov	r0, r8
	bl	SYM(objc2::runtime::Sel::register_unchecked::GENERATED_ID, 0)
	mov	r1, r0
	str	r0, [r10]
	b	LBB3_1
LBB3_6:
	sub	sp, r7, #24
	pop	{r8, r10, r11}
	pop	{r4, r5, r6, r7, pc}

	.globl	_iter_noop
	.p2align	2
	.code	32
_iter_noop:
	push	{r4, r5, r6, r7, lr}
	add	r7, sp, #12
	push	{r8, r10, r11}
	sub	sp, sp, #120
	bfc	sp, #0, #3
	add	r1, sp, #8
	vmov.i32	q8, #0x0
	orr	r4, r1, #4
	add	r2, r1, #80
	mov	r6, r0
	mov	r0, #0
	mov	r5, r4
	vst1.64	{d16, d17}, [r2]!
	mov	r11, #16
	mov	r1, #0
	vst1.32	{d16, d17}, [r5]!
	vst1.32	{d16, d17}, [r5]!
	vst1.32	{d16, d17}, [r5]!
	vst1.32	{d16, d17}, [r5]!
	str	r0, [r2]
	str	r0, [r5]
	str	r0, [sp, #112]
	str	r0, [sp, #108]
	str	r0, [sp, #84]
	str	r0, [sp, #80]
	str	r6, [sp, #8]
	movw	r10, :lower16:(L__ZN6icrate10Foundation9generated14__NSEnumerator17NSFastEnumeration41countByEnumeratingWithState_objects_count10CACHED_SEL17h37ea10daa3c347f7E$non_lazy_ptr-(LPC4_0+8))
	movt	r10, :upper16:(L__ZN6icrate10Foundation9generated14__NSEnumerator17NSFastEnumeration41countByEnumeratingWithState_objects_count10CACHED_SEL17h37ea10daa3c347f7E$non_lazy_ptr-(LPC4_0+8))
	movw	r8, :lower16:(l_anon.[ID].0-(LPC4_1+8))
	movt	r8, :upper16:(l_anon.[ID].0-(LPC4_1+8))
LPC4_0:
	ldr	r10, [pc, r10]
LPC4_1:
	add	r8, pc, r8
	b	LBB4_2
LBB4_1:
	add	r1, r1, #1
	str	r1, [sp, #108]
LBB4_2:
	cmp	r1, r0
	blo	LBB4_1
	ldr	r1, [r10]
	cmp	r1, #0
	bne	LBB4_5
	mov	r0, r8
	bl	SYM(objc2::runtime::Sel::register_unchecked::GENERATED_ID, 0)
	mov	r1, r0
	str	r0, [r10]
LBB4_5:
	mov	r0, r6
	mov	r2, r5
	mov	r3, r4
	str	r11, [sp]
	bl	_objc_msgSend
	cmp	r0, #0
	str	r0, [sp, #112]
	beq	LBB4_7
	ldr	r6, [sp, #8]
	mov	r1, #0
	b	LBB4_1
LBB4_7:
	sub	sp, r7, #24
	pop	{r8, r10, r11}
	pop	{r4, r5, r6, r7, pc}

	.globl	_iter_retained
	.p2align	2
	.code	32
_iter_retained:
	push	{r4, r5, r6, r7, lr}
	add	r7, sp, #12
	push	{r8, r10, r11}
	sub	sp, sp, #120
	bfc	sp, #0, #3
	add	r1, sp, #8
	vmov.i32	q8, #0x0
	orr	r4, r1, #4
	add	r2, r1, #80
	mov	r6, r0
	mov	r0, #0
	mov	r5, r4
	vst1.64	{d16, d17}, [r2]!
	mov	r11, #16
	mov	r1, #0
	vst1.32	{d16, d17}, [r5]!
	vst1.32	{d16, d17}, [r5]!
	vst1.32	{d16, d17}, [r5]!
	vst1.32	{d16, d17}, [r5]!
	str	r0, [r2]
	str	r0, [r5]
	str	r0, [sp, #112]
	str	r0, [sp, #108]
	str	r0, [sp, #84]
	str	r0, [sp, #80]
	str	r6, [sp, #8]
	movw	r10, :lower16:(L__ZN6icrate10Foundation9generated14__NSEnumerator17NSFastEnumeration41countByEnumeratingWithState_objects_count10CACHED_SEL17h37ea10daa3c347f7E$non_lazy_ptr-(LPC5_0+8))
	movt	r10, :upper16:(L__ZN6icrate10Foundation9generated14__NSEnumerator17NSFastEnumeration41countByEnumeratingWithState_objects_count10CACHED_SEL17h37ea10daa3c347f7E$non_lazy_ptr-(LPC5_0+8))
	movw	r8, :lower16:(l_anon.[ID].0-(LPC5_1+8))
	movt	r8, :upper16:(l_anon.[ID].0-(LPC5_1+8))
LPC5_0:
	ldr	r10, [pc, r10]
LPC5_1:
	add	r8, pc, r8
	b	LBB5_3
LBB5_1:
	mov	r0, r6
	mov	r2, r5
	mov	r3, r4
	str	r11, [sp]
	bl	_objc_msgSend
	mov	r1, #0
	cmp	r0, #0
	str	r0, [sp, #112]
	beq	LBB5_6
LBB5_2:
	ldr	r0, [sp, #80]
	add	r2, r1, #1
	str	r2, [sp, #108]
	ldr	r0, [r0, r1, lsl #2]
	bl	_objc_retain
	mov	r6, r0
	bl	_use_obj
	mov	r0, r6
	bl	_objc_release
	ldr	r6, [sp, #8]
	ldr	r1, [sp, #108]
	ldr	r0, [sp, #112]
LBB5_3:
	cmp	r1, r0
	blo	LBB5_2
	ldr	r1, [r10]
	cmp	r1, #0
	bne	LBB5_1
	mov	r0, r8
	bl	SYM(objc2::runtime::Sel::register_unchecked::GENERATED_ID, 0)
	mov	r1, r0
	str	r0, [r10]
	b	LBB5_1
LBB5_6:
	sub	sp, r7, #24
	pop	{r8, r10, r11}
	pop	{r4, r5, r6, r7, pc}

	.section	__TEXT,__const
l_anon.[ID].0:
	.asciz	"countByEnumeratingWithState:objects:count:"

	.section	__DATA,__nl_symbol_ptr,non_lazy_symbol_pointers
	.p2align	2, 0x0
L__ZN6icrate10Foundation9generated14__NSEnumerator17NSFastEnumeration41countByEnumeratingWithState_objects_count10CACHED_SEL17h37ea10daa3c347f7E$non_lazy_ptr:
	.indirect_symbol	SYM(icrate::Foundation::generated::__NSEnumerator::NSFastEnumeration::countByEnumeratingWithState_objects_count::CACHED_SEL::GENERATED_ID, 0)
	.long	0

.subsections_via_symbols
