//
// Assembler program to convert a string to
// all upper case.
//
// X1 - address of output string
// X0 - address of input string
// X4 - original output string for length calc.
// W5 - current character being processed
//

.global _mytoupper         // Allow other files to call this routine

_mytoupper: MOV    X4, X1
// The loop is until byte pointed to by X1 is non-zero
loop:    LDRB    W5, [X0], #1    // load character and increment pointer
// If W5 > 'z' then goto cont
    CMP    W5, #'z'        // is letter > 'z'?
    B.GT    cont
// Else if W5 < 'a' then goto end if
    CMP    W5, #'a'
    B.LT    cont    // goto to end if
// if we got here then the letter is lower case, so convert it.
    SUB    W5, W5, #('a'-'A')
cont:    // end if
    STRB    W5, [X1], #1    // store character to output str
    CMP    W5, #0        // stop on hitting a null character
    B.NE    loop        // loop if character isn't null
    SUB    X0, X1, X4  // get the length by subtracting the pointers
    RET        // Return to caller

