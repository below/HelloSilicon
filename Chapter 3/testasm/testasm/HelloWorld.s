//
// Assembler program to print "Hello World!"
// to stdout.
//
// X0-X2 - parameters to linux function services
// X16 - Mach function number
//

.global _start	            // Provide program starting address to linker

// Setup the parameters to print hello world
// and then call Linux to do it.
_start: mov	X0, #1	    // 1 = StdOut
    adr	X1, helloworld // string to print
	mov	X2, #13	    // length of our string
	mov	X16, #4	    // linux write system call
    svc	#0x80 	    // Call linux to output the string

// Setup the parameters to exit the program
// and then call Linux to do it.
	mov     X0, #0      // Use 0 return code
    mov     X16, #1      // Service command code 93 terminates this program
    svc     #0x80           // Call linux to terminate the program

helloworld:      .ascii  "Hello World!\n"

