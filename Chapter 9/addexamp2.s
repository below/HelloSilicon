
//
// Example of 128-Bit addition with the ADD/ADC instructions.
//

.include "debug.s"

.global main	            // Provide program starting address

// Load the registers with some data
// First 64-bit number is 0x0000000000000003FFFFFFFFFFFFFFFF
main:	
	STR	LR,[SP,#-16]!
	MOV	X2, #0x0000000000000003
	MOV	X3, #0xFFFFFFFFFFFFFFFF	//Assembler will change to MOVN
// Second 64-bit number is 0x00000000000000050000000000000001
	MOV	X4, #0x0000000000000005
	MOV	X5, #0x0000000000000001

	printStr "Inputs:"
	printReg 2
	printReg 3
	printReg 4
	printReg 5
	ADDS	X1, X3, X5	// Lower order word
	ADC	X0, X2, X4	// Higher order word


	printStr "Outputs:"
	printReg 1
	printReg 0
	MOV	X0, #0		// return code
	LDR	LR, [SP], #16
	RET

