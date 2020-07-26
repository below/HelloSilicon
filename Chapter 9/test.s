// Test for printf on OS X


.global _main	            // Provide program starting address
.align 4

_main:	
	// Setup
	mov	x2, #4711
	stp	x29, LR, [sp, #48]     ; 16-byte Folded Spill
	adrp  	    X0, ptfStr@PAGE // printf format str
	add	X0, X0, ptfStr@PAGEOFF
	mov     x9, sp
	mov	x10, #'2'
	str     x10, [x9]
        mov     x10, #4711
        str     x10, [x9, #8]
	str	x10, [x9, #16]

        bl	    _printf	// call printf

	MOV	X0, #0		// return code
	ldp	x29, LR, [sp, #48]     ; 16-byte Folded Reload
	RET
.data
ptfStr: .asciz	"X%c = %32ld, 0x%016lx\n"
.align 4
.text
