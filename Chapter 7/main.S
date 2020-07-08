//
// Assembler program to convert a string to
// all upper case by calling a function.
//
// X0-X2, X8 - used by macros to call linux
// X11 - input file descriptor
// X9 - output file descriptor
// X10 - number of characters read
//

#include <asm/unistd.h>
#include "fileio.S"

.equ	BUFFERLEN, 250

.global _start	            // Provide program starting address to linker

_start:	openFile	inFile, O_RDONLY
	ADDS		X11, XZR, X0	// save file descriptor
	B.PL		nxtfil  // pos number file opened ok
	MOV		X1, #1  // stdout
	LDR		X2, =inpErrsz	// Error msg
	LDR		W2, [X2]
	writeFile	X1, inpErr, X2 // print the error
	B		exit

nxtfil: openFile	outFile, O_CREAT+O_WRONLY
	ADDS		X9, XZR, X0	// save file descriptor
	B.PL		loop    // pos number file opened ok
	MOV		X1, #1
	LDR		X2, =outErrsz
	LDR		W2, [X2]
	writeFile	X1, outErr, X2
	B		exit

// loop through file until done.
loop:	readFile	X11, buffer, BUFFERLEN
	MOV		X10, X0	// Keep the length read
	MOV		X1, #0	// Null terminator for string

	// setup call to toupper and call function
	LDR		X0, =buffer	// first param for toupper
	STRB		W1, [X0, X10]	// put null at end of string.
	LDR		X1, =outBuf
	BL		toupper		

	writeFile	X9, outBuf, X10

	CMP		X10, #BUFFERLEN
	B.EQ		loop

	flushClose	X11
	flushClose	X9

// Setup the parameters to exit the program
// and then call Linux to do it.
exit:	MOV     X0, #0      // Use 0 return code
        MOV     X8, #__NR_exit
        SVC     0           // Call Linux to terminate the program

.data
inFile:  .asciz  "main.S"
outFile: .asciz	 "upper.txt"
buffer:	.fill	BUFFERLEN + 1, 1, 0
outBuf:	.fill	BUFFERLEN + 1, 1, 0
inpErr: .asciz	"Failed to open input file.\n"
inpErrsz: .word  .-inpErr 
outErr:	.asciz	"Failed to open output file.\n"
outErrsz: .word	.-outErr

