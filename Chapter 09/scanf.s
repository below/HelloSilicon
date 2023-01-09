//
// Assembler program to read an integer using scanf
// to stdout.
//
// X0-X1 - parameters to scanf
// X16 - Mach System Call function number
//

.global _start			// Provide program starting address to linker
.align 2			// Make sure everything is aligned properly

// Setup the parameters to print hello world
// and then call the Kernel to do it.
_start:
	add	x1, sp, #20             // Add 20 bytes to the stack pointer address and store it in x1
	str	x1, [sp]                // Store x8 at on the stack pointer. I.e. the stack pointer now contains a pointer  
	adrp	x0, fmtStr@PAGE     // Load the format string into x0
	add	x0, x0, fmtStr@PAGEOFF  // Add the offset 
    bl	_scanf                  // Call scanf
    ldr	x1, sp, #20]            // Read the result from its position on the stack

// Setup the parameters to exit the program
// and then call the kernel to do it.
	mov     X0, x1		// For easy debugging, return the number we read
	mov     X16, #1		// System call number 1 terminates this program
	svc     #0x80		// Call kernel to terminate the program

.data
fmtStr: .asciz	"%d"

