// Test for printf on OS X


.global _main	            // Provide program starting address
.align 4

_main:	
	stp	x29, LR, [sp, #16]!     ; 16-byte Folded Spill
        adrp  	    X0, ptfStr@PAGE // printf format str
	add	X0, X0, ptfStr@PAGEOFF
	mov	x9, sp	// Move the stack pointer into X9
	mov	x10, #'b'
	str	x10, [x9]
        bl	    _printf	// call printf

	MOV	X0, #0		// return code
	ldp	x29, LR, [sp], #16     ; 16-byte Folded Reload
	RET
.data
ptfStr: .asciz	"X%c\n"
.align 4
.text
