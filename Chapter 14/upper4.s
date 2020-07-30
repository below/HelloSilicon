//
// Assembler program to convert a string to
// all upper case.
//
// X0 - address of input string
// X1 - address of output string
// X2 - use as indirection to load data
// Q0 - 8 characters to be processed
// V1 - contains all a's for comparison
// V2 - result of comparison with 'a's
// Q3 - all 25's for comp
// Q8 - spaces for bic operation

.global toupper	     // Allow other files to call this routine

	.EQU	N, 4
toupper:
	LDR X2, =aaas
	LDR	Q1, [X2]   // Load Q1 with all as
	LDR X2, =endch
	LDR	Q3, [X2]  // Load Q3 with all 25's
	LDR X2, =spaces
	LDR	Q8, [X2] // Load Q8 with all spaces
	MOV	W3, #N
// The loop is until byte pointed to by R1 is non-zero
loop:	LDR	Q0, [X0], #16 // load 16 characters and increment pointer
	SUB	V2.16B, V0.16B, V1.16B	// Subtract 'a's
	CMHI	V2.16B, V2.16B, V3.16B	// compare chars to 25's
	NOT     V2.16B, V2.16B          // no CMLO so need to not
	AND V2.16B, V2.16B, V8.16B 	// and result with spaces
	BIC	V0.16B, V0.16B, V2.16B	// kill the bit that makes it lowercase
	STR	Q0, [X1], #16	    // store character to output str
	SUBS	W3, W3, #1		// decrement loop counter and set flags
	B.NE	loop		// loop if character isn't null
	MOV	X0, #(N*16)	// get the length by subtracting the pointers
	RET		// Return to caller

.data
aaas:    .fill  16, 1, 'a'	// 16 a's
endch:  .fill	16, 1, 25  	// after shift, chars are 0-25
spaces:	.fill	16, 1, 0x20     // spaces for bic

