//
// Assembler program to print "Hello World!"
// to stdout.
//
// X0-X2 - parameters to linux function services
// X8 - linux function number
//

.global start	            // Provide program starting address to linker

// Setup the parameters to print hello world
// and then call Linux to do it.
start: mov	X0, #1	    // 1 = StdOut
	ldr	 X1, =helloworld // string to print
	mov	 X2, #13	    // length of our string
	mov	X16, #4	    // Mach write system call
	svc	80 	    // Call Mach to output the string

// Setup the parameters to exit the program
// and then call Linux to do it.
	mov     X0, #0      // Use 0 return code
        mov     X8, #1      // Service command code 1 terminates this program
        svc     80           // Call Mach to terminate the program

.data
helloworld:      .ascii  "Hello World!\n"

