
//
// Multiply 2 3x3 integer matrices
//
// Registers:
//	W1 - Row index
//	W2 - Column index
//	X4 - Address of row
//	X5 - Address of column
//	X7 - 64 bit accumulated sum 
//	W9 - Cell of A
//	W10 - Cell of B
//	X19 - Position in C
//	X20 - Loop counter for printing
//	X12 - row in dotloop
//	X6 - col in dotloop

.global main // Provide program starting address
.align 4

	.equ	N, 3	// Matrix dimensions
	.equ	WDSIZE, 4 // Size of element
main:	
	STR	LR, [SP, #-16]!	// Save required regs
	STP	X19, X20, [SP, #-16]!	// Save required regs

	MOV	W1, #N		// Row index
	ADRP	X4, A@PAGE	// Address of current row
	ADD	X4, X4, A@PAGEOFF
	ADRP	X19, C@PAGE	// Address of results matrix
	ADD	X19, X19, C@PAGEOFF 
rowloop:
	ADRP	X5, B@PAGE	// first column in B
	ADD	X5, X5, B@PAGEOFF
	MOV	W2, #N		// Column index (will count down to 0)

colloop:	
	// Zero accumulator registers
	MOV	X7, #0

	MOV	W0, #N		// dot product loop counter
	MOV	X12, X4		// row for dot product
	MOV	X6, X5		// column for dot product
dotloop:
	// Do dot product of a row of A with column of B
	LDR	W9, [X12], #WDSIZE	// load A[row, i] and incr
	LDR	W10, [X6], #(N*WDSIZE)	// load B[i, col]
	SMADDL	X7, W9, W10, X7 // Do multiply and accumulate
	SUBS	W0, W0, #1		// Dec loop counter
	B.NE	dotloop		// If not zero loop

	STR	W7, [X19], #4	// C[row, col] = dotprod
	ADD	X5, X5, #WDSIZE	// Increment current col
	SUBS	W2, W2, #1	// Dec col loop counter
	B.NE	colloop		// If not zero loop
	
	ADD	X4, X4, #(N*WDSIZE)	// Increment to next row
	SUBS	W1, W1, #1		// Dec row loop counter
	B.NE	rowloop		// If not zero loop

// Print out matrix C
// Loop through 3 rows printing 3 cols each time.
	MOV	W20, #3		// Print 3 rows
	ADRP	X19, C@PAGE	// Addr of results matrix
	ADD	X19, X19, C@PAGEOFF
printloop:
		
	ADRP	X0, prtstr@PAGE	// printf format string
	ADD	X0, X0, prtstr@PAGEOFF
	LDR	W1, [X19], #WDSIZE 	// first element in current row
	LDR	W2, [X19], #WDSIZE	// second element in current row
	LDR	W3, [X19], #WDSIZE	// third element in curent row
	STR	W1, [SP, #-32]!	// Push W1 onto the stack, leaving room for W2 and W3
	STR	W2, [SP, #8]
	STR	W3, [SP, #16]	// Push X3 onto the stack
	BL	_printf		// Call printf
	ADD	SP, SP, #32	// Clean up stack
	SUBS	W20, W20, #1		// Dec loop counter
	B.NE	printloop	// If not zero loop

	MOV	X0, #0		// return code
	LDP	X19, X20, [SP], #16	// Restore Regs
	LDR	LR, [SP], #16	// Restore LR
	RET

.data
// First matrix
A:	.word	1, 2, 3
	.word	4, 5, 6
	.word	7, 8, 9
// Second matrix
B:	.word	9, 8, 7
	.word	6, 5, 4
	.word	3, 2, 1
// Result matix
C:	.fill	9, 4, 0

prtstr: .asciz  "%3d  %3d  %3d\n"
