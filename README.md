# HelloSilicon
An attempt with assembly on the machine we must not speak about

So this is a little attempt to invoke syscalls on a machine running a Mach Kernel on an ARM64-like architecture.

The code is taken from the book _Programming with 64-Bit ARM Assembly Language_

But when I run it, all I get is: ´zsh: killed     ./HelloWorld`

Any hints are appreciated

```
//
// Assembler program to print "Hello World!"
// to stdout.
//
// X0-X2 - parameters to Unix System Call
// X16 - Unix System Call Number
//

.global start	            // Provide program starting address to linker

// Setup the parameters to print hello world
// and then the Kernel to do it.
start:	mov	X0, #1	    // 1 = StdOut
 	ldr	X1, =helloworld // string to print
 	mov	X2, #13	    // length of our string
 	mov     X16, #0x0004
    	movk 	X16, #0x0200, LSL #16	    // Unix write system call
  	svc	0x80 	    // System Call to output the string

// Setup the parameters to exit the program
// and then the Kernel to do it.
	mov     X0, #0      // Use 0 return code
	mov     X16, #0x0001   // Service command code 1 terminates this program
     	movk 	X16, #0x0200, LSL #16
        svc     0x80           // System Call to terminate the program

helloworld:
.ascii  "Hello World!\n"
```
