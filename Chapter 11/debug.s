// Various macros to help with debugging

// These macros preseve all registers.
// Beware they will change the condition flags.

.macro  printReg    reg
	stp	    X0, X1, [SP, #-16]!
	stp	    X2, X3, [SP, #-16]!
	stp	    X4, X5, [SP, #-16]!	
	stp	    X6, X7, [SP, #-16]!	
	stp	    X8, X9, [SP, #-16]!	
	stp	    X10, X11, [SP, #-16]!	
	stp	    X12, X13, [SP, #-16]!	
	stp	    X14, X15, [SP, #-16]!	
	stp	    X16, X17, [SP, #-16]!	
	stp	    X18, LR, [SP, #-16]!	
	mov	    X2, X\reg	// for the %d
	mov	    X3, X\reg	// for the %x
	mov	    X1, #\reg	
	add	    X1, X1, #'0'	// for %c
    str     X1, [SP, #-32]! // Move the stack pointer four doublewords (32 bytes) down and push X1 onto the stack
    str     X2, [SP, #8]    // Push X2 to one doubleword above the current stack pointer
    str     X3, [SP, #16]   // Push X3 to two doublewords above the current stack pointer
	adrp  	    X0, ptfStr@PAGE // printf format str
	add	    X0, X0, ptfStr@PAGEOFF	// add offset for format str
	bl	    _printf	// call printf
	add	    SP, SP, #32	// Clean up stack
	ldp	    X18, LR, [SP], #16
	ldp	    X16, X17, [SP], #16
	ldp	    X14, X15, [SP], #16
	ldp	    X12, X13, [SP], #16
	ldp	    X10, X11, [SP], #16
	ldp	    X8, X9, [SP], #16
	ldp	    X6, X7, [SP], #16
	ldp	    X4, X5, [SP], #16
	ldp	    X2, X3, [SP], #16
	ldp	    X0, X1, [SP], #16
.endm

.macro	printStr    str
	stp	    X0, X1, [SP, #-16]!
	stp	    X2, X3, [SP, #-16]!
	stp	    X4, X5, [SP, #-16]!	
	stp	    X6, X7, [SP, #-16]!	
	stp	    X8, X9, [SP, #-16]!	
	stp	    X10, X11, [SP, #-16]!	
	stp	    X12, X13, [SP, #-16]!	
	stp	    X14, X15, [SP, #-16]!	
	stp	    X16, X17, [SP, #-16]!	
	stp	    X18, LR, [SP, #-16]!	
	adr	    X0, 1f	// load print str
	bl	    _printf	// call printf
	ldp	    X18, LR, [SP], #16
	ldp	    X16, X17, [SP], #16
	ldp	    X14, X15, [SP], #16
	ldp	    X12, X13, [SP], #16
	ldp	    X10, X11, [SP], #16
	ldp	    X8, X9, [SP], #16
	ldp	    X6, X7, [SP], #16
	ldp	    X4, X5, [SP], #16
	ldp	    X2, X3, [SP], #16
	ldp	    X0, X1, [SP], #16
	b	    2f		// branch around str
1:	.asciz	    "\str\n"
	.align	    4
2:
.endm

.data
ptfStr: .asciz	"X%c = %32ld, 0x%016lx\n"
.align 4
.text
