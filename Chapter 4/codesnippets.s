//
// This file contains the various code
// snippets from Chapter 4. This ensures
// they compile and gives you a chance
// to single step through them.
// They are labeled, so you can set a
// breakpoint at the one you are interested in.

.global _start

_start: 
// uncomment the next 2 lines if you want to see
// an infinite loop
l1:	// MOV X1, #1
	//B _start

l2:	CMP X4, #45
	B.EQ _start

	CMP W4, #45
	B.EQ _start


	MOV W2, #1	// W2 holds I
loop:	// body of the loop goes here.

	// Most of the logic is at the end
	ADD W2, W2, #1		// I = I + 1
	CMP W2, #10
	B.LE loop		// IF I <= 10 goto loop

l4:		MOV W2, #10	// R2 holds I
loop2:	// body of the loop goes here.

	// The CMP is redundant since we
	// are doing SUBS.
	SUBS	W2, W2, #1	// I = I - 1
	B.NE	loop2		// branch until I = 0

l5:	// W4 is X and has been initialized
loop3:	CMP	W4, #5
	B.GE	loopdone
	// … other statements in the loop body …
	B	loop3
loopdone: // program continues

l6:	CMP W5, #10
	B.GE elseclause

	// … if statements …

	B endif
elseclause:

	// … else statements …

endif:	// continue on after the /then/else …

	// mask off the high order byte
	AND	W6, W6, #0xFF000000

// shift the byte down to the
// low order position.
	LSR	W6, W6, #24

l8:	ORR	X6, X6, #0xFF

l9:	BIC	X6, X6, #0xFF

// Setup the parameters to exit the program
// and then call Linux to do it.
	MOV     W0, #0      // Use 0 return code
        MOV     X8, #93      // Service command code 93 terminates this program
        SVC     0           // Call linux to terminate the program

.data
helloworld:	.ascii "Hello World!"
