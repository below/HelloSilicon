// AArch64 Assembly Code
// Programming with 64-Bit ARM Assembly Language
// Chapter #4: Excercise #2 (Page 81)
// Jeff Rosengarden 08/27/20

//
// Create assembly code to emulate a switch/case statement

// REGISTERS USED IN CODE
// w11 	- 	holds switch variable (1 thru 3 for this case statement)
// w12 	-	holds the exit value that can be queried at the OS level with: echo $?
//			NOTE:  w12 is transferred to w0 just before program exit so the
//				   user can query the value with $?
// w13 	-	work register used during calculation of mesg length

// X0 - X2  hold parameters for Darwin/kernel system call
// X0	-	holds FD (file device) for output (stdout in this case)
// X1	-	holds address of mesg
// X2 	-	holds length of mesg 

// X16	-	used to hold Darwin/Kernel system call ID
// X9	-	holds calculated length of mesg




.global _start	 							// Provide program starting address
.align 2

_start:		// this is the switch portion of the case statement
			// branching to select1, select2, select3 or default
			// labels based on value in w11
			
			
			// set "select" value (1 thru 3) in w11
				
			mov w12, 0xff	// Prepare for error case 
			cmp x0, #2	// Make sure we have precisely two arguments
			bne endit	// If it is not: exit
			ldr x11, [x1, #8]	// Get the pointer at x1 + 8
			ldrb w11, [x11]	// Load the Byte pointed to by that pointer into w11
			sub w11, w11, #'0' // Subtract the ascii value for '0'

			cmp w11, #1			// will set Z flag to 1 if w11 - 1 == 0
			b.eq select1		// Z Flag == 1 ?
			cmp w11, #2			// will set Z flag to 1 if w11 - 2 == 0
			b.eq select2		// Z Flag == 1 ?
			cmp w11, #3			// will set Z flag to 1 if w11 - 3 == 0
			b.eq select3		// Z Flag == 1 ?
			
			// if w11 contains anything other than 1 thru 3 the program
			// will fall thru to the default label here
			
			// each label is a switch/case target based on the above select code
			
default:	mov w12, #99					// Use 99 return code for os query ($?)
			b break							// same as switch/case break statement

select1:	mov w12, #1						// Use 1 return code for os query ($?)
			b break							// same as switch/case break statement
			
select2:	mov w12, #2						// Use 2 return code for os query ($?)
			b break							// same as switch/case break statement

select3:	mov w12, #3						// Use 3 return code for os query ($?)
											// b break not necessary here as it will
											// fall thru when done executing the
											// select3: case
		
break:		nop								// nop here just to prove we actually 
											// wind up here from each case statement
											// when debugging with lldb
											
											// code after the select/case would go 
											// here
											
			ADRP	X1, mesg@PAGE 			// start of message to display at OS level
			ADD	X1, X1, mesg@PAGEOFF
			
			// calculate length of mesg (store it in x9)

			mov x9, #0						// zero out x9 before starting
cloop:
			ldrb w13, [x1,x9]				// get the next digit in mesg
			cmp  w13, #255					// is it equal to 255 (0xFF)
			b.eq  cend						// yes - jump to cend
			add x9, x9, #1					// no  - increase x9 count by 1
			b cloop							// do it again
cend:	
	

											// Setup the parameters to print string
											// and then call Darwin/kernel to do it.
			MOV	X0, #1	    				// 1 = StdOut

	

			MOV	X2, X9	    				// length of our string
			MOV	X16, #4	    				// Darwin write system call
			SVC	#0x80 	    				// Call Darwin/kernel to output the string


// Setup the parameters to exit the program
// and then call the kernel to do it.
endit:
			mov		W0, W12					// move return code into X0 so it can be
											// queried at OS level
    		MOV     X16, #1     			// System call number 1 terminates this program
    		SVC     #0x80           		// Call Darwin/kernel to terminate the program
		
			// return 0


.data
mesg:	.byte 0x1B												// clear screen 
		.byte 'c'												// and start msg at
		.byte 0													// top of screen
		.asciz	"Chapter 4; Excercise #2\n"
		.asciz	" - Emulate switch/case in assembly code\n\n"
		.asciz	" -By Jeff Rosengarden\n"
		.asciz	" -Created on Apple DTK\n\n" 
		.asciz	" Use: echo $? to see result of program\n"
		.asciz	"\n\n\n"										// 3 add'l blank lines
		.byte	255	
		

//		alternative clear screen command (clears screen and starts msg @ bottom)
//		.asciz 	"\33[2J"			
	
			
			
