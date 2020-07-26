//
// Main program to test our distance function
//
// W19 - loop counter
// X20 - address to current set of points

.global main // Provide program starting address to linker

//

	.equ	N, 3	// Number of points.
 
main:	
	STP	X19, X20, [SP, #-16]!
	STR	LR, [SP, #-16]!

	LDR	X20, =points	// pointer to current points
	
	MOV	W19, #N		// number of loop iterations

loop:	MOV	X0, X20		// move pointer to parameter 1 (X0)

	BL	distance	// call distance function

// need to take the single precision return value
// and convert it to a double, because the C printf
// function can only print doubles.
	FMOV	S2, W0		// move back to fpu for conversion
	FCVT	D0, S2	// convert single to double
	FMOV	X1, D0		// return double to X1
	LDR	X0, =prtstr	// load print string
	BL	printf		// print the distance

	ADD	X20, X20, #(4*4) 	// 4 points each 4 bytes
	SUBS	W19, W19, #1	// decrement loop counter
	B.NE	loop		// loop if more points

	MOV	X0, #0		// return code
	LDR	LR, [SP], #16
	LDP	X19, X20, [SP], #16
	RET

.data
points:	.single	0.0, 0.0, 3.0, 4.0
	.single	1.3, 5.4, 3.1, -1.5
	.single 1.323e10, -1.2e-4, 34.55, 5454.234
prtstr:	.asciz "Distance = %f\n"


