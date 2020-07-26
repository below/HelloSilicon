//
// Example function to calculate the distance
// between two points in single precision
// floating point.
//
// Inputs:
//	X0 - pointer to the 4 FP numbers
//		they are x1, y1, x2, y2
// Outputs:
//	X0 - the length (as single precision FP)

.global distance // Allow function to be called by others

// 
distance:	
	// push all registers to be safe, we don't really
	// need to push so many.
	STR	LR, [SP, #-16]!

	// load all 4 numbers at once
	LDP	S0, S1, [X0], #8
	LDP	S2, S3, [X0]

	// calc s4 = x2 - x1
	FSUB	S4, S2, S0
	// calc s5 = y2 - y1
	FSUB	S5, S3, S1
	// calc s4 = S4 * S4 (x2-X1)^2
	FMUL	S4, S4, S4
	// calc s5 = s5 * s5 (Y2-Y1)^2
	FMUL	S5, S5, S5
	// calc S4 = S4 + S5
	FADD	S4, S4, S5
	// calc sqrt(S4)
	FSQRT	S4, S4 
	// move result to X0 to be returned
	FMOV	W0, S4

	// restore what we preserved.
	LDR	LR, [SP], #16
	RET

