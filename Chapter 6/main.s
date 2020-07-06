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

_start: LDR	X0, =instr // start of input string
	LDR	X1, =outstr // address of output string

	BL	toupper

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
        MOV     X8, #93     // Service command code 93 terminates
        SVC     0           // Call linux to terminate the program

.data
instr:  .asciz  "This is our Test String that we will convert.\n"
outstr:	.fill	255, 1, 0

