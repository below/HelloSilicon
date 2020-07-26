//
// Examples of 64-Bit Integer Division
//

.include "debug.s"

.global main // Provide program starting address

// Load the registers with some data
// Perform various division instructions
main:		
	MOV	X2, #100
	MOV	X3, #4

	printStr "Inputs:"
	printReg 2
	printReg 3

	SDIV	X4, X2, X3
	printStr "Outputs:"
	printReg 4

	UDIV	X4, X2, X3
	printStr "Outputs:"
	printReg 4 

	// Division by zero
	printStr "Division by zero:"
	MOV	X3, #0
	SDIV	X4, X2, X3	
	printStr "Outputs:"
	printReg 4

	MOV	X0, #0		// return code
	RET

