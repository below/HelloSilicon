//
// Assembler program to convert a string to
// all upper case. Assumes only alphabetic
// characters. Uses bit clear blindly without
// checking if character is alphabetic or not.
//
// X0 - address of input string
// X1 - address of output string
// X2 - original output string for length calc.
// W3 - current character being processed
//

.global _start	 // Provide program starting address
.align 4

.macro toupper inputstr, outputstr
	ADRP	X0, \inputstr@PAGE	// start of input string
	ADD	X0, X0, \inputstr@PAGEOFF
	ADRP	X1, \outputstr@PAGE	// address of output string
	ADD	X1, X1, \outputstr@PAGEOFF
	MOV	X2, X1
// The loop is until byte pointed to by R1 is non-zero
loop:	LDRB	W3, [X0], #1	// load character and increment pointer
	BIC	W3, W3, #0x20	// kill the bit that makes it lower case
	STRB	W3, [X1], #1	// store character to output str
	CMP	W3, #0		// stop on hitting a null charactser
	B.NE	loop		// loop if character isn't null
	SUB	X0, X1, X2	// get the length by subtracting the pointers
.endm

_start:
	toupper	instr, outstr

// Setup the parameters to print our hex number
// and then call the Kernel to do it.
	MOV	X2,X0	// return code is the length of the string

	MOV	X0, #1	    // 1 = StdOut
	ADRP	X1, outstr@PAGE // string to print
	ADD	X1, X1, outstr@PAGEOFF
	MOV	X16, #4	    // Unix write system call
	SVC	#0x80 	    // Call kernel to output the string

// Setup the parameters to exit the program
// and then call the Kernel to do it.
	MOV     X0, #0      // Use 0 return code
        MOV     X16, #1     // System call number 1 terminates
        SVC     #0x80           // Call kernel to terminate the program

.data
instr:  .asciz  "ThisIsRatherALargeVariableNameAaZz//[`{\n"
	.align 4
outstr:	.fill	255, 1, 0
