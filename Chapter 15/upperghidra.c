#include <stdio.h>

#define BUFFERSIZE 250

char *tstStr = "This is a test!";
char outStr[BUFFERSIZE];

typedef unsigned char byte;

#define true 1

int main(void)

{
  char cVar1;
  char *pcVar2;
  char *pcVar3;
  char *pcVar4;
  char *pcVar5;
 
  pcVar2 = tstStr;
  pcVar3 = outStr;
  pcVar5 = tstStr;
  do {
    cVar1 = *pcVar5;
    pcVar4 = pcVar3;
    while( true ) {
      pcVar3 = pcVar4 + 1;
      pcVar5 = pcVar5 + 1;
      if (0x19 < (byte)(cVar1 + 0x9fU)) break;
      *pcVar4 = cVar1 + -0x20;
      cVar1 = *pcVar5;
      pcVar4 = pcVar3;
    }
    *pcVar4 = cVar1;
  } while (cVar1 != '\0');
  printf("Input: %s\nOutput: %s\n",pcVar2,outStr);
  return 0;
}

