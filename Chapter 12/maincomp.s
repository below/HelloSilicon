
//
// Main program to test our distance function
//
// W19 - loop counter
// X20 - address to current set of points

.global main // Provide program starting address

//

	.equ	N, 100	// Number of additions.
 
main:	
	STP	X19, X20, [SP, #-16]!
	STR	LR, [SP, #-16]!
	
// Add up one hundred cents and test if they equal $1.00

	MOV	W19, #N		// number of loop iterations

// load cents, running sum and real sum to FPU
	LDR	X0, =cent
	LDP	S0, S1, [X0], #8
	LDR	S2, [X0]
loop:
	// add cent to running sum
	FADD	S1, S1, S0
	SUBS	W19, W19, #1	// decrement loop counter
	B.NE	loop		// loop if more points

	// compare running sum to real sum
	FCMP	S1, S2	
	// print if the numbers are equal or not
	B.EQ	equal
	LDR	X0, =notequalstr
	BL 	printf
	B	next
equal:  LDR	X0, =equalstr
	BL	printf	

next:
// load pointer to running sum, real sum and epsilon
	LDR	X0, =runsum
	
// call comparison function
	BL	fpcomp 		// call comparison function
// compare return code to 1 and print if the numbers
// are equal or not (within epsilon).
	CMP	X0, #1
	B.EQ	equal2
	LDR	X0, =notequalstr
	BL 	printf
	B	done
equal2: LDR	X0, =equalstr
	BL	printf	

done:	MOV	X0, #0		// return code
	LDR	LR, [SP], #16
	LDP	X19, X20, [SP], #16
	RET

.data
cent:	.single	0.01
runsum: .single 0.0
sum:	.single 1.00
epsilon:.single 0.00001
equalstr:	.asciz "equal\n"
notequalstr: .asciz "not equal\n"


