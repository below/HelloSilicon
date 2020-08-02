//
// Multiply 2 3x3 integer matrices
// Uses the NEON Coprocessor to do
// some operations in parallel.
//
// Registers:
//	D0 - first column of matrix A
//	D1 - second column of matrix A
//	D2 - third column of matrix A
//	D3 - first column of matrix B
//	D4 - second column of matrix B
//	D5 - third column of matrix B
//	D6 - first column of matrix C
//	D7 - second column of matrix C
//	D8 - third column of matrix C

.global main // Provide program starting address to linker
.align 4

main:	
	STP	X19, X20, [SP, #-16]!
	STR	LR, [SP, #-16]!

// load matrix A into Neon registers D0, D1, D2
	ADRP	X0, A@PAGE	// Address of A
	ADD	X0, X0, A@PAGEOFF
	LDP	D0, D1, [X0], #16
	LDR	D2, [X0]

// load matrix B into Neon registers D3, D4, D5
	ADRP	X0, B@PAGE	// Address of B
	ADD	X0, X0, B@PAGEOFF
	LDP	D3, D4, [X0], #16
	LDR	D5, [X0]

.macro mulcol ccol bcol
	MUL.4H	\ccol\(), V0, \bcol\()[0]
	MLA.4H	\ccol\(), V1, \bcol\()[1]
	MLA.4H	\ccol\(), V2, \bcol\()[2]
.endm

	mulcol	V6, V3	// process first column
	mulcol	V7, V4	// process second column
	mulcol	V8, V5	// process third column

	ADRP	X1, C@PAGE	// Address of C
	ADD	X1, X1, C@PAGEOFF
	STP	D6, D7, [X1], #16
	STR	D8, [X1]

// Print out matrix C
// Loop through 3 rows printing 3 cols each time.
	MOV	W19, #3		// Print 3 rows
	ADRP	X20, C@PAGE	// Addr of results matrix
	ADD	X20, X20, C@PAGEOFF
printloop:
		
	ADRP	X0, prtstr@PAGE	// printf format string
	ADD	X0, X0, prtstr@PAGEOFF
// print transpose so matrix is in usual row column order.
// first ldrh post-indexes by 2 for next row
// so second ldrh adds 6, so is ahead by 2+6=8=row size
// simlarly for third ldh ahead by 2+14=16 = 2 x row size
	LDRH	W1, [X20], #2 	// first element in current row
	LDRH	W2, [X20,#6]	// second element in current row
	LDRH	W3, [X20,#14]	// third element in curent row
	STR	W1, [SP, #-32]!	// Push W1 onto the stack, leaving room for W2 and W3
	STR	W2, [SP, #8]
	STR	W3, [SP, #16]	// Push X3 onto the stack
	BL	_printf		// Call printf
	ADD	SP, SP, #32	// Clean up stack
	SUBS	W19, W19, #1		// Dec loop counter
	B.NE	printloop	// If not zero loop

	MOV	X0, #0		// return code
	LDR	LR, [SP], #16
	LDP	X19, X20, [SP], #16
	RET

.data
// First matrix in column major order
A:	.short	1, 4, 7, 0
	.short	2, 5, 8, 0
	.short	3, 6, 9, 0
// Second matrix in column major order
B:	.short	9, 6, 3, 0
	.short	8, 5, 2, 0
	.short	7, 4, 1, 0
// Result matix in column major order
C:	.fill	12, 2, 0

prtstr: .asciz  "%3d  %3d  %3d\n"
