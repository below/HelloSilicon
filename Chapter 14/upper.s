//
// Assembler program to convert a string to
// all upper case.
//
// X1 - address of output string
// X0 - address of input string
// X4 - original output string for length calc.
// W5 - current character being processed
// W6 - minus 'a' to compare < 26.
//

.global toupper	     // Allow other files to call this routine

toupper: MOV	X4, X1
// The loop is until byte pointed to by X1 is non-zero
loop:	LDRB	W5, [X0], #1	// load character and increment pointer
// Want to know if 'a' <= W5 <= 'z'
// First subtract 'a'
	SUB	W6, W5, #'a'
// Now want to know if W6 <= 25
	CMP	W6, #25	    // chars are 0-25 after shift
	B.HI	cont
// if we got here then the letter is lowercase, so convert it.
	SUB	W5, W5, #('a'-'A')
cont:	// end if
	STRB	W5, [X1], #1	// store character to output str
	CMP	W5, #0		// stop on hitting a null character
	B.NE	loop		// loop if character isn't null
	SUB	X0, X1, X4  // get the length by subtracting the pointers	
	RET			// Return to caller
