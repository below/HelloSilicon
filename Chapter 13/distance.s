//
// Example function to calculate the distance
// between 4D two points in single precision
// floating point using the NEON Processor
//
// Inputs:
//	X0 - pointer to the 8 FP numbers
//		they are (x1, x2, x3, x4),
//			 (y1, y2, y3, y4)
// Outputs:
//	W0 - the length (as single precision FP)

.global distance // Allow function to be called by others

//
distance:	
	// load all 4 numbers at once
	LDP	Q2, Q3, [X0]	

	// calc V1 = V2 - V3
	FSUB	V1.4S, V2.4S, V3.4S
	// calc V1 = V1 * V1 = (xi-yi)^2
	FMUL	V1.4S, V1.4S, V1.4S
	// calc S0 = S0 + S1 + S2 + S3
	FADDP	V0.4S, V1.4S, V1.4S
	FADDP	V0.4S, V0.4S, V0.4S
	// calc sqrt(S0)
	FSQRT	S4, S0 
	// move result to W0 to be returned
	FMOV	W0, S4

	RET

