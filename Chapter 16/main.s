//
// Assembler program to demonstate a buffer
// overrun hacking attack.
//
// X0-X2 - parameters to linux function services
// X1 - address of output string
// X0 - address of input string
// X8 - linux function number
//

.global _start	            // Provide program starting address to linker

DownloadCreditCardNumbers:
// Setup the parameters to print hello world
// and then call Linux to do it.
	mov	X0, #1	    // 1 = StdOut
	ldr	X1, =getcreditcards // string to print
	mov	X2, #30	    // length of our string
	mov	X8, #64	    // Linux write system call
	svc	0 	    // Call linux to output the string	
	ret

calltoupper:	
	STR	LR, [SP, #-16]!	// Put LR on the stack
	SUB	SP, SP, #16	// 16 bytes for outstr
	LDR	X0, =instr // start of input string
	MOV	X1, SP     // address of output string

	BL	toupper

aftertoupper:	// convenient label to use as a breakpoint
	ADD	SP, SP, #16	// Free outstr
	LDR	LR, [SP], #16
	RET

_start:

	BL	calltoupper


// Setup the parameters to exit the program
// and then call Linux to do it.
	MOV     X0, #0      // Use 0 return code
        MOV     X8, #93     // Service command code 93 terminates
        SVC     0           // Call Linux to terminate

.data
instr:  .ascii  "This is our Test"	// Correct length string
	.dword 0x00000000004000b0		// overwrite for LR
getcreditcards:	.asciz  "Downloading Credit Card Data!\n"
	.align 4


