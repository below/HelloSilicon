@ Various macros to help with debugging

@ These macros preseve all registers.
@ Beware they will change cpsr.

.macro  printReg    reg
	push	    {r0-r4, lr} @ save regs
	mov	    r2, R\reg	@ for the %d
	mov	    r3, R\reg	@ for the %x
	mov	    r1, #\reg	
	add	    r1, #'0'	@ for %c
        ldr  	    r0, =ptfStr @ printf format str
        bl	    printf	@ call printf
	pop	    {r0-r4, lr} @ restore regs
.endm

.macro	printStr    str
	push	    {r0-r4, lr}	@ save regs
	ldr	    r0, =1f	@ load print str
	bl	    printf	@ call printf
	pop	    {r0-r4, lr}	@ restore regs
	b	    2f		@ branch around str
1:	.asciz	    "\str\n"
	.align	    4
2:
.endm

.data
ptfStr: .asciz	"R%c = %16d, 0x%08x\n"
.align 4
.text
