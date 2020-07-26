//
// Function to compare to floating point numbers
// the parameters are a pointer to the two numbers
// and an error epsilon.
//
// Inputs:
//	X0 - pointer to the 3 FP numbers
//		they are x1, x2, e
// Outputs:
//	X0 - 1 if they are equal, else 0

.global fpcomp // Allow function to be called by others

// 
fpcomp:	// load the 3 numbers
	LDP	S0, S1, [X0], #8
	LDR	S2, [X0]

	// calc s3 = x2 - x1
	FSUB	S3, S1, S0
	FABS	S3, S3
	FCMP	S3, S2	
	B.LE		notequal
	MOV		X0, #1
	B		done	
	
notequal:MOV		X0, #0
 	
done:	RET
