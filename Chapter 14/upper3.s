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

.MACRO toupper inputstr, outputstr
	LDR	X0, =\inputstr	// start of input string
	LDR	X1, =\outputstr	// address of output string
	MOV	X2, X1
// The loop is until byte pointed to by R1 is non-zero
loop:	LDRB	W3, [X0], #1	// load character and increment pointer
	BIC	W3, W3, #0x20	// kill the bit that makes it lower case
	STRB	W3, [X1], #1	// store character to output str
	CMP	W3, #0		// stop on hitting a null charactser
	B.NE	loop		// loop if character isn't null
	SUB	X0, X1, X2	// get the length by subtracting the pointers
.ENDM

_start:
	toupper	instr, outstr

// Setup the parameters to print our hex number
// and then call Linux to do it.
	MOV	X2,X0	// return code is the length of the string

	MOV	X0, #1	    // 1 = StdOut
	LDR	X1, =outstr // string to print
	MOV	X8, #64	    // linux write system call
	SVC	0 	    // Call linux to output the string

// Setup the parameters to exit the program
// and then call Linux to do it.
	MOV     X0, #0      // Use 0 return code
	MOV     X8, #93      // Service command code 96 terminates
	SVC     0           // Call linux to terminate the program

.data
instr:  .asciz  "ThisIsRatherALargeVariableNameAaZz//[`{\n"
	.align 4
outstr:	.fill	255, 1, 0
