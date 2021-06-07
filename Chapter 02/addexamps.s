
@
@ Examples of the ADD/ADC instructions.
@
.global _start	            @ Provide program starting address to linker

@ Multiply 2 by -1 by using MVN and then adding 1
_start:	MVN	R0, #2
	ADD	R0, #1


@ Setup the parameters to exit the program
@ and then call Linux to do it.
@	MOV     R0, #0      @ Use 0 return code
        mov     R7, #1      @ Service command code 1 terminates this program
        svc     0           @ Call linux to terminate the program


