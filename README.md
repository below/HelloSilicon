# HelloSilicon
An attempt with assembly on the machine we must not speak about

So this is a little attempt to invoke syscalls on a machine running a Mach Kernel on an ARM64-like architecture.

But when I run it, all I get is: ´zsh: killed     ./HelloWorld`

Any hints are appreciated

```
//
// Assembler program to print "Hello World!"
// to stdout.
//
// X0-X2 - parameters to Mach System Call
// X16 - Mach System Call Number
//

.global start	            // Provide program starting address to linker

// Setup the parameters to print hello world
// and then the Kernel to do it.
start: mov	X0, #1	    // 1 = StdOut
	ldr	 X1, =helloworld // string to print
	mov	 X2, #13	    // length of our string
	mov	X16, #4	    // Mach write system call
	svc	80 	    // System Call to output the string

// Setup the parameters to exit the program
// and then the Kernel to do it.
	mov     X0, #0      // Use 0 return code
        mov     X8, #1      // Service command code 1 terminates this program
        svc     80           // System Call to terminate the program

.data
helloworld:      .ascii  "Hello World!\n"
```
