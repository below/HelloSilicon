//
// Example of 32 & 64-Bit Multiplication
//

.include "debug.s"

.global main // Provide program starting address

// Load the registers with some data
// Use small positive numbers that will work for all
// multiply instructions.
main:	
	MOV	X2, #25
	MOV	X3, #4


	printStr "Inputs:"
	printReg 2
	printReg 3

	MUL	X4, X2, X3
	printStr "MUL X4=X2*X3:"
	printReg 4

	MNEG	X4, X2, X3
	printStr "MNEG X4=-X2*X3:"
	printReg 4

	SMULL	X4, W2, W3
	printStr "SMULL X4=W2*W3:"
	printReg 4

	SMNEGL	X4, W2, W3
	printStr "SMNEGL X4=-W2*W3:"
	printReg 4

	UMULL	X4, W2, W3
	printStr "UMULL X4=W2*W3:"
	printReg 4

	UMNEGL	X4, W2, W3
	printStr "UMNEGL X4=-W2*W3:"
	printReg 4

	LDR	X2, =A
	LDR	X2, [X2]
	LDR	X3, =B
	LDR	X3, [X3]
	MUL	X4, X2, X3
	printStr "Inputs:"
	printReg 2
	printReg 3
	MUL	X4, X2, X3
	printStr "MUL X4 = bottom 64 bits of X2*X3:"
	printReg 4
	SMULH	X4, X2, X3
	printStr "SMULH X4 = top 64 bits of X2*X3 (signed):"
	printReg 4

	UMULH	X4, X2, X3
	printStr "UMULH X4 = top 64 bits of X2*X3 (unsigned):"
	printReg 4

	MOV	X0, #0		// return code
	RET

.data
A:	.dword		0x7812345678
B:	.dword		0xFABCD12345678901

