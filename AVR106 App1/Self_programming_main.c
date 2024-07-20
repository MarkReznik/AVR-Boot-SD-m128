// This file has been prepared for Doxygen automatic documentation generation.
/*! \file ********************************************************************
*
* Atmel Corporation
*
* - File              : Self_programming_main.c
* - Compiler          : IAR EWAVR 2.28a / 3.10c and newer
*
* - Support mail      : avr@atmel.com
*
* - Supported devices : This example is written for ATmega128.
*
* - AppNote           : AVR106 - C functions for reading and writing
*                       to flash memory.
*
* - Description       : The file contains an example program using the Flash R/W
*                       functions provided with the files Self_programming.h /
*                       Self_programming.c . The program should be compiled using
*                       a linker file (*.xcl) that is configured to place the
*                       entire program code into the Boot section of the Flash memory.
*                       Please refer to the application note document for more
*                       information.
*
* $Revision: 2.0 $
* $Date: Wednesday, January 18, 2006 15:18:52 UTC $
*
*****************************************************************************/
#include <io.h>
#include <delay.h>
#include "Self_programming.h"

void main( void ){
  unsigned char testBuffer1[PAGESIZE];      // Declares variables for testing
  //unsigned char testBuffer2[PAGESIZE];      // Note. Each array uses PAGESIZE bytes of
                                            // code stack
  static unsigned char testChar; // A warning will come saying that this var is set but never used. Ignore it.
  int index;       
  DDRC=0xFF;
  PORTC=0xFF;
  do
    {
      PORTC.0=0;
      PORTC.1=0;
      delay_ms(500);
      PORTC.1=1;
      PORTC.0=1;
      delay_ms(500);
      PORTC=0xFC;
    }
  while(1); 
  for(index=0; index<PAGESIZE; index++){
    testBuffer1[index]=index;//(unsigned char)0xFF; // Fills testBuffer1 with values FF 
  }
  if(WriteFlashBytes(0x2, testBuffer1,PAGESIZE)){     // Writes testbuffer1 to Flash page 2
    PORTC.2=0;
  }                                            // Same as byte 4 on page 2
  //MCUCR &= ~(1<<IVSEL);
  ReadFlashBytes(0x2,&testChar,1);        // Reads back value from address 0x204
  if(testChar==0x00)
  {
      ReadFlashBytes(0x3,&testChar,1);        // Reads back value from address 0x204
      if(testChar==0x01)
        ReadFlashBytes(0x100,&testChar,1);        // Reads back value from address 0x204
        if(testChar==0xFE)
            ReadFlashBytes(0x101,&testChar,1);        // Reads back value from address 0x204
            if(testChar==0xFF)
              while(1)
              {
                  PORTC.0=0;
                  delay_ms(500);
                  PORTC.0=1;
                  delay_ms(500);
              }
  }                                          
  
  while(1)
  {
      PORTC.1=0;
      delay_ms(500);
      PORTC.1=1;
      delay_ms(500);
  }  
  //}
}
