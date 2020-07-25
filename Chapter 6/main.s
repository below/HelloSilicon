//
// Assembler program to convert a string to
// all upper case by calling a function.
//
// X0-X2 - parameters to linux function services
// X1 - address of output string
// X0 - address of input string
// X8 - linux function number
//

.global _start	            // Provide program starting address to linker
.p2align 2

_start: ADRP	X0, instr@PAGE	// start of input string
	ADD	X0, X0, instr@PAGEOFF
	ADRP	X1, outstr@PAGE	// address of output string
	ADD	X1, X1, outstr@PAGEOFF

	BL	toupper

// Setup the parameters to print our hex number
// and then call the kernel to do it.
	MOV	X2,X0	// return code is the length of the string

	MOV	X0, #1	    // 1 = StdOut
	ADRP	X1, outstr@PAGE // start of string
	ADD	X1, X1, outstr@PAGEOFF
	MOV	X16, #4	    // Unix write system call
	SVC	#0x80 	    // Call kernel to output the string

// Setup the parameters to exit the program
// and then call the kernel to do it.
	MOV     X0, #0		// Use 0 return code
	MOV     X16, #1		// System call number 1 terminates this program
	SVC     #0x80		// Call kernel to terminate the program

.data
instr:  .asciz  "This is our Test String that we will convert.\n"
outstr:	.fill	255, 1, 0

