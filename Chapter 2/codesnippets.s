//
// This file contains the various code
// snippets from Chapter 2. This ensures
// they compile and gives you a chance
// to single step through them.
// They are labeled, so you can set a
// breakpoint at the one you are interested in.

.global _start

_start: 
l1:	ADD	X0, XZR, X1
	MOV	X0, X1
	ORR	X0, XZR, X1 
// Load X2 with 0x1234FEDC4F5D6E3A first using MOV and MOVK
l2:	MOV	X2, #0x6E3A
	MOVK	X2, #0x4F5D, LSL #16
	MOVK	X2, #0xFEDC, LSL #32
	MOVK	X2, #0x1234, LSL #48
l3:	MOV	X1, X2, LSL #1	// Logical shift left
	MOV	X1, X2, LSR #1	// Logical shift right
	MOV	X1, X2, ASR #1	// Arithmetic shift right
	MOV	X1, X2, ROR #1	// Rotate right

l4:	LSL	X1, X2, #1	// Logical shift left
	LSR	X1, X2, #1	// Logical shift right
	ASR	X1, X2, #1	// Arithmetic shift right
	ROR	X1, X2, #1	// Rotate right

l5:	// Too big for #imm16
	MOV	X1, #0xAB000000

// Uncomment the next line if you want to see the 
// Assembler error for a constant that can't be
// represented.
	// MOV	X1, #0xABCDEF11 // Too big for #imm16 and can’t  be represented.

l6:	// the immediate value can be 12-bits, so 0-4095
	// X2 = X1 + 4000
	ADD	X2, X1, #4000
	// the shift on an immediate can be 0 or 12
	// X2 = X1 + 0x20000
	ADD	X2, X1, #0x20, LSL 12
	// simple addition of two registers
	// X2 = X1 + X0
	ADD	X2, X1, X0
	// addition of a register with a shifted register
	// X2 = X1 + (X0 * 4)
	ADD	X2, X1, X0, LSL 2
	// With register extension options
	// X2 = X1 + signed extended byte(X0)
	ADD	X2, X1, X0, SXTB
	// X2 = X1 + zero extended halfword(X0) * 4
	ADD	X2, X1, X0, UXTH 2


l8:	ADDS	X0, X0, #1

l9:	ADDS	X1, X3, X5	// Lower order 64-bits
	ADC	X0, X2, X4	// Higher order 64-bits

// Setup the parameters to exit the program
// and then call Linux to do it.
	MOV     X0, #0      // Use 0 return code
        MOV     X8, #93     // Service command code 93 terminates this program
        SVC     0           // Call linux to terminate the program

.data
helloworld:	.ascii "Hello World!"
