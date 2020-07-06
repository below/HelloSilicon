//
// This file contains the various code
// snippets from Chapter 6. This ensures
// they compile and gives you a chance
// to single step through them.
// They are labeled, so you can set a
// breakpoint at the one you are interested in.

.global _start

_start: 
l1:	STR	X0, [SP, #-16]!
	LDR	X0, [SP], #16
	STP	X0, X1, [SP, #-16]!
	LDP	X0, X1, [SP], #16

l2:	// … other code ...
	BL	myfunc
	MOV	X1, #4
	// … more code …

	B	l3

myfunc:	// do some work
	RET

l3:	// … other code ...
	BL	myfuncb
	MOV	X1, #4
	// … more code …

	B 	l4

myfuncb: STR	LR, [SP, #-16]!  // PUSH LR
	// do some work …
	BL	myfuncb2
	// do some more work...
	LDR	LR, [SP], #16    // POP LR
	RET 
myfuncb2:	// do some work ....
	RET

l4:	SUB	SP, SP, #16

l5:	STR	W0, [SP]	// Store a
	STR	W1, [SP, #4]	// Store b
	STR	W2, [SP, #8]	// Store c 

l6:	ADD	SP, SP, #16

l7:	SUB	FP, SP, #16
	SUB	SP, SP, #16

l8:	STR	W0, [FP]		// Store a
	STR	W1, [FP, #-4]	// Store b
	STR	W2, [FP, #-8]	// Store c

	ADD	SP, SP, #16

l9:	BL	SUMFN
	B	l10

// Simple function that takes 2 parameters
// VAR1 and VAR2. The function adds them,
// storing the result in a variable SUM.
// The function returns the sum.
// It is assumed this function does other work,
// including other functions.

// Define our variables
		.EQU	VAR1, 0
		.EQU	VAR2, 4
		.EQU	SUM,  8

SUMFN:		STP	LR, FP, [SP, #-16]!
		SUB	FP, SP, #16
		SUB	SP, SP, #16	// room for 3 32-bit values
		STR	W0, [FP, #VAR1]	// save first param.
		STR	W1, [FP, #VAR2]	// save second param.

// Do a bunch of other work, but don’t change SP.

		LDR	W4, [FP, #VAR1]
		LDR	W5, [FP, #VAR2]
		ADD	W6, W4, W5
		STR	W6, [FP, #SUM]

// Do other work

// Function Epilog
		LDR	W0, [FP, #SUM]	// load sum to return
		ADD	SP, SP, #16	 // Release local vars
		LDP	LR, FP, [SP], #16 // Restore LR, FP
		RET
 	
.MACRO	PUSH1 register
		STR	\register, [SP, #-16]!
.ENDM
.MACRO	POP1 	register
		LDR	\register, [SP], #16
.ENDM
.MACRO 	PUSH2 register1, register2
		STP	\register1, \register2, [SP, #-16]!
.ENDM
.MACRO 	POP2	register1, register2
		LDP	\register1, \register2, [SP], #16
.ENDM

Myfunction:
	PUSH1	LR
	PUSH2	X20, X23
// function body …
	POP2	X20, X23
	POP1	LR
	RET

l10:

// Setup the parameters to exit the program
// and then call Linux to do it.
	MOV     X0, #0      // Use 0 return code
        MOV     X8, #93      // Service command code 93 terminates
        SVC     0           // Call linux to terminate the program
