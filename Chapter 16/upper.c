#include <stdio.h>

int dummy()
{
	return(2);
}

int mytoupper(char *instr, char *outstr)
{
	char cur;
	char *orig_outstr = outstr;
	
	dummy();
	do
	{
		cur = *instr;
		if ((cur >= 'a') && (cur <='z')) 
		{
			cur = cur - ('a'-'A');
		}	
label:		*outstr++ = cur;
		instr++;	
	} while (cur != '\0');
	return( outstr - orig_outstr );
}

#define BUFFERSIZE 10

int main()
{
        char *tstStr = "This is a test!xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxyyyyyyandevenlongerandlongerandlonger";
	char outStr[BUFFERSIZE];

	mytoupper(tstStr, outStr);
	printf("Input: %s\nOutput: %s\n", tstStr, outStr);
	
	return(0);
}
