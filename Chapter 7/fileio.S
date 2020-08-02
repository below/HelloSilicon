// Various macros to perform file I/O

// The fd parameter needs to be a register.
// Uses X0, X1, X8.
// Return code is in X0.

// #include <asm/unistd.h>

.equ	O_RDONLY, 0
.equ	O_WRONLY, 1
.equ	O_CREAT,  0100
.equ	S_RDWR,   0666
.equ	AT_FDCWD, -2

.macro  openFile    fileName, flags
	mov         X0, #AT_FDCWD
        adrp        X1, \fileName@PAGE
	add	    X1, X1, \fileName@PAGEOFF 
        mov         X2, #\flags
	mov	    X3, #S_RDWR		// RW access rights
        mov	    X16, #463	// openat, see bsd/kern/syscalls.master
        svc         #0x80
.endm
.macro  readFile   fd, buffer, length
        mov         X0, \fd      // file descriptor
        adrp        X1, \buffer@PAGE
	add	    X1, X1, \buffer@PAGEOFF
        mov         X2, #\length
        mov         X16, #3
        svc         #0x80
.endm
.macro  writeFile   fd, buffer, length
        mov         X0, \fd      // file descriptor
        adrp        X1, \buffer@PAGE
	add	    X1, X1, \buffer@PAGEOFF
        mov         X2, \length
        mov         X16, #4
        svc         #0x80
.endm
.macro  flushClose  fd
//fsync syscall
        mov         X0, \fd
        mov         X16, #95	//__NR_fsync
        svc         #0x80

//close syscall
        mov         X0, \fd
        mov         X16, #6 // __NR_close
        svc         #0x80
.endm
