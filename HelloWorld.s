//
// Assembler program to print "Hello World!"
// to stdout.
//
// X0-X2 - parameters to linux function services
// X8 - linux function number
//

.global _start	            // Provide program starting address to linker

// Setup the parameters to print hello world
// and then call Linux to do it.
_start: mov	X0, #1	    // 1 = StdOut
	ldr	X1, =helloworld // string to print
	mov	X2, #13	    // length of our string
	mov	X8, #64	    // linux write system call
	svc	0 	    // Call linux to output the string

// Setup the parameters to exit the program
// and then call Linux to do it.
	mov     X0, #0      // Use 0 return code
        mov     X8, #93      // Service command code 93 terminates this program
        svc     0           // Call linux to terminate the program

.data
helloworld:      .ascii  "Hello World!\n"

