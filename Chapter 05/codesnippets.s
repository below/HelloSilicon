//
// This file contains the various code
// snippets from Chapter 5. This ensures
// they compile and gives you a chance
// to single step through them.
// They are labeled, so you can set a
// breakpoint at the one you are interested in.

.global _start
.global _l9

.data
l1: .byte 74, 0112, 0b00101010, 0x4A, 0X4a, 'J', 'H' + 2
	.word	0x1234ABCD, -1434
	.quad	0x123456789ABCDEF0
	.ascii	"Hello World\n"

l2:	.byte	-0x45, -33, ~0b00111001

l3:	.fill	10, 4, 0

l4:	.rept 3
	.byte	0, 1, 2
	.endr

	.byte	0, 1, 2
	.byte	0, 1, 2
	.byte	0, 1, 2

l5:	.byte		0x3F
	.align	4
	.word		0x12345678

.text

_start: 
l6:	ADRP	X1, helloworld@PAGE
	ADD	X1, X1, helloworld@PAGEOFF
	ADR	X1, helloworld2

l7:	LDR	X1, =0x1234ABCD1234ABCD

l8:
// load the address of mynumber into X1
	ADRP	X1, mynumber@PAGE
	ADD	X1, X1, mynumber@PAGEOFF
// load the word stored at mynumber into X2
	LDR	X2, [X1]


_l9:	ADRP	X1, arr1@PAGE
	ADD	X1, X1, arr1@PAGEOFF

l10:	// Load the first element
	LDR	W2, [X1]
	// Load element 3
	// The elements count from 0, so 2 is
	// the third one. Each word is 4 bytes,
	// so we need to multiply by 4
	LDR	W2, [X1, #(2 * 4)]


l11:	// The 3rd element is still number 2
	MOV	X3, #(2 * 4)
	// Add the offset in X3 to X1 to get our element.
	LDR	W2, [X1, X3]

l12:	LDR	W2, [X1, #-(2 * 4)]
	MOV	X3, #(-2 * 4)
	LDR	W2, [X1, X3]

l13: 	// Our array is of WORDs. 2 is the index
	MOV	X3, #2
	// Shift X3 left by 2 positions to multiply
	// by 4 to get the correct address.
	LDR	W2, [X1, X3, LSL #2]


l14:	LDR W2, [X1, #(2 * 4)]!

	ADRP X2, arr1@PAGE
	ADD  X2, X2, arr1@PAGEOFF
l15:	// Load X1 with the memory pointed to by X2
	// Then do X2 = X2 + 2
	LDR	X1, [X2], #2

l16: 	ADRP	X1, myoctaword@PAGE
	ADD	X1, X1, myoctaword@PAGEOFF
	LDP	X2, X3, [X1]
	STP	X2, X3, [X1]

// Setup the parameters to exit the program
// and then call the kernel to do it.
	mov     X0, #0		// Use 0 return code
	mov     X16, #1		// System call number 1 terminates this program
	svc     #0x80		// Call kernel to terminate the program
helloworld2:	.ascii "Hello World!"

.data
helloworld:	.ascii "Hello World!"
.align 4
mynumber:	.quad	0x123456789ABCDEF0
arr1:	.fill	10, 4, 0
myoctaword:	.octa 0x12345678876543211234567887654321
