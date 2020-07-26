//
// This file contains the various code
// snippets from Chapter 11. This ensures
// they compile and gives you a chance
// to single step through them.
// They are labeled, so you can set a
// breakpoint at the one you are interested in.

.global _start

_start: 
l1:	STP	Q8, Q9, [SP, #-32]!
	STR	Q10, [SP, #-16]!
	LDP	Q8, Q9, [SP], #32
	LDR	Q10, [SP], #16

l2:	LDR	X1, =fp1
	LDR	S4, [X1]
	LDR	D5, [X1, #4]
	STR	S4, [X1]
	STR	D5, [X1, #4]

l3:	FMOV	H1, W2
	FMOV	W2, H1
	FMOV	S1, W2
	FMOV	X1, D2
	FMOV	D2, D3

l4:	FADD	H1, H2, H3	// H1 = H2 + H3
	FADD	S1, S2, S3	// S1 = S2 + S3
	FADD	D1, D2, D3	// D1 = D2 + D3
	FSUB	D1, D2, D3	// D1 = D2 - D3
	FMUL	D1, D2, D3	// D1 = D2 * D3
	FDIV	D1, D2, D3	// D1 = D2 / D3
	FMADD	D1, D2, D3, D4	// D1 = D4 + D2 * D3
	FMSUB	D1, D2, D3, D4	// D1 = D4 – D2 *D3
	FNEG	D1, D2		// D1 = - D2
	FABS	D1, D2		// D1 = Absolute Value( D2 )
	FMAX	D1, D2, D3	// D1 = Max( D2, D3 )
	FMIN	D1, D2, D3	// D1 = Min( D2, D3 )
	FSQRT	D1, D2		// D1 = Square Root( D2 )

l5:	FCVT	D1, S2
	FCVT	S1, D2
	FCVT	S1, H2
	FCVT	H1, S2

l6:	SCVTF	D1, X2	// D1 = signed integer from X2
	UCVTF	S1, W2	// S1 = unsigned integer from W2

l7:	FCVTAS	W1, H2	// signed, round to nearest
	FCVTAU	W1, S2	// unsigned, round to nearest
	FCVTMS	X1, D2	// signed, round towards minus infinity
	FCVTMU	X1, D2	// unsigned, round towards minus infinity
	FCVTPS	X1, D2	// signed, round towards positive infinity
	FCVTPU	X1, D2	// unsigned, round towards positive infinity
	FCVTZS	X1, D2	// signed, round towards zero
	FCVTZU	X1, D2	// unsigned, round towards zero

l8:	FCMP	H1, H2
	FCMP	H1, #0.0
	FCMP	S1, S2
	FCMP	S1, #0.0
	FCMP	D1, D2
	FCMP	D1, #0.0

// Setup the parameters to exit the program
// and then call Linux to do it.
	MOV     X0, #0      // Use 0 return code
        MOV     X8, #93     // Service command code 93 terminates
        SVC     0           // Call linux to terminate the program

.data
.single	1.343, 4.343e20, -0.4343, -0.4444e-10
.double	-4.24322322332e-10, 3.141592653589793
fp1:	.single	3.14159
fp2:	.double	4.3341
fp3:	.single    0.0
fp4:	.double	0.0

