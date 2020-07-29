// Test for printf on OS X


.global _main	            // Provide program starting address
.align 4

_main:	
	// Setup
	stp	x29, LR, [sp, #-16]!     ; Save LR, FR
	adrp  	    X0, ptfStr@PAGE // printf format str
	add	X0, X0, ptfStr@PAGEOFF
	mov	x2, #4711
	mov	x3, #3845
	mov     x10, #65
	str	x3, [SP, #-16]!
	stp     x10, x2, [SP, #-16]!

	bl	    _printf	// call printf

	ldr	x10, [SP], #32

	MOV	X0, #0		// return code
	ldp	x29, LR, [sp], #16     ; Restore FR, LR
	RET
.data
ptfStr: .asciz	"Hello World %c %ld %ld\n"
.align 4
.text
