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
/* FAT on MMC/SD/SD HC card support */
//Petit fat api
#include <pff_rn.h>
#include "diskio.h"		/* Declarations of low level disk I/O functions */
/* printf */
#include <stdio.h>
#include <stdlib.h>
/* string functions */
#include <string.h>
#include <alcd.h>

/*Globals*/
int retry;
/* FAT function result */
FRESULT res;
/* number of bytes written/read to the file */
unsigned int nbytes;
/* will hold the information for logical drive 0: */
FATFS fat;
/* will hold the file information */
//FIL file;
/* will hold file attributes, time stamp information */
FILINFO finfo;
/* root directory path */
char path[64];//="/0/unittest.txt";
/* text to be written to the file */
char text[]="Unit Test 1";
/* file read buffer */
char buffer[256];

/* error message list */
flash char * flash error_msg[]=
{
"", /* not used */
"FR_DISK_ERR",
"FR_INT_ERR",
"FR_INT_ERR",
"FR_NOT_READY",
"FR_NO_FILE",
"FR_NO_PATH",
"FR_INVALID_NAME",
"FR_DENIED",
"FR_EXIST",
"FR_INVALID_OBJECT",
"FR_WRITE_PROTECTED",
"FR_INVALID_DRIVE",
"FR_NOT_ENABLED",
"FR_NO_FILESYSTEM",
"FR_MKFS_ABORTED",
"FR_TIMEOUT"
};
/* display error message and stop */
void error(FRESULT res, unsigned char num)
{
    char strnum[5];
    if(num>100){
       num=100;
    }
    itoa(num,strnum);
    do{
    if ((res>=0) && (res<=FR_NO_FILESYSTEM)){//FR_NO_FILESYSTEM  FR_TIMEOUT
       lcd_gotoxy(0,0);
       printf("ERROR: %p\r\n",error_msg[res]);
       if(res==0){
        lcd_putsf("SD OK: ");
       }
       else{
        lcd_putsf("SD ERROR: "); 
       }
       delay_ms(100);
       lcd_puts(strnum);
       lcd_putsf(",");
       itoa(res,strnum);
       lcd_puts(strnum);
       lcd_gotoxy(0,1);
       lcd_putsf(error_msg[res]);
    }
    /* stop here */
    //do
        //{
          PORTC.0=0;
          PORTC.1=0;
          delay_ms(150);
          PORTC.1=1;
          PORTC.0=1;
          delay_ms(150);
          PORTC=0xFC;
        }
      while(1);
}
unsigned char rn(char *newname, char *oldname){
    strcpy(path,"/0/unittest.txt");
    
}
unsigned char RenameTest(){
   int retry;
   strcpy(path,"/0/unittest.txt");
   
}

FRESULT rename (const char* dirname, const char* oldname, char* newname)
{
    FRESULT res;
    FILINFO fno;
    DIR dir;
    int i;
    BYTE rwbuf[512];
        
    res = pf_opendir(&dir, path);
    if (res == FR_OK) {
        i = strlen(path);
        for (;;) {
            res = pf_readdir(&dir, &fno);
            if (res != FR_OK || fno.fname[0] == 0) break;
            if(fno.fname[0] == 'U'){
               res = disk_readp(rwbuf,dir.sect,0,512);
               if (res != FR_OK) break;
               rwbuf[((dir.index-1)*32)+6]='5';
               res = disk_writep(0,dir.sect);
               if (res != FR_OK) break;
               res = disk_writep(rwbuf,512);
               if (res != FR_OK) break;
               res = disk_writep(0,0);
               break;
            }
            /*
            if (fno.fattrib & AM_DIR) {
                sprintf(&path[i], "/%s", fno.fname);
                res = scan_files(path);
                if (res != FR_OK) break;
                path[i] = 0;
            } else {
                printf("%s/%s\n", path, fno.fname);
            }
            */
        }
    }

    return res;
}

unsigned char UnitTest1(){
    
    BYTE testbuf[10]={'5','5','A','A','6','6','B','B','C','C'};
    strcpy(path,"/0/UPDATE3.DAT");
    /* mount logical drive 0: */
    //if ((res=f_mount(0,&fat))==FR_OK)
    /*
    for(retry=0;retry<5;retry++){
        res=pf_mount(&fat);
        if (res==FR_OK){
            break;
        }
        else{
          delay_ms(500);
        }
    }
    */
    res=pf_mount(&fat);
    if (res==FR_OK)
       printf("Logical drive 0: mounted OK\r\n");
    else
       /* an error occured, display it and stop */
       error(res,1);
    //scan_files("/0");
    res=pf_rename11("","UNIT","TUNY    TX");
    res=pf_rename11("/0","UPDATE","DONE000");
    res=pf_rename11("/0","DONE","UPDATE1 DAT");
    if(res)
        error(res,22);
    
    
    
    
    
    /*this line will remove READ_ONLY attribute*/
    //f_chmod(path, AM_ARC, AM_ARC|AM_RDO);
    /* create a new file in the root of drive 0:
       and set write access mode */
    //if ((res=f_open(&file,path,FA_CREATE_ALWAYS | FA_WRITE))==FR_OK)
    if ((res=pf_open("data4K.bin"))==FR_OK)
       printf("File %s created OK\r\n",path);
    else{
       /* an error occured, display it and stop */
       if(res!=3)
            error(res,2);
    }

    /* write some text to the file,
       without the NULL string terminator sizeof(data)-1 */
    //if ((res=f_write(&file,text,sizeof(text)-1,&nbytes))==FR_OK)
    if ((res=pf_write512(testbuf,0,sizeof(testbuf),&nbytes))==FR_OK)
       printf("%u bytes written of %u\r\n",nbytes,sizeof(text)-1);
    else
       ///* an error occured, display it and stop */
       error(res,93);
    if ((res=pf_write512(testbuf,20,sizeof(testbuf),&nbytes))==FR_OK)
       printf("%u bytes written of %u\r\n",nbytes,sizeof(text)-1);
    else
       ///* an error occured, display it and stop */
       error(res,93);   
    if ((res=pf_write512(testbuf,510,sizeof(testbuf),&nbytes))==FR_OK)
       printf("%u bytes written of %u\r\n",nbytes,sizeof(text)-1);
    else
       ///* an error occured, display it and stop */
       error(res,93);
    if ((res=pf_write512(testbuf,521,sizeof(testbuf),&nbytes))==FR_OK)
       printf("%u bytes written of %u\r\n",nbytes,sizeof(text)-1);
    else
       ///* an error occured, display it and stop */
       error(res,93);   
    if ((res=pf_write512(testbuf,1020,sizeof(testbuf),&nbytes))==FR_OK)
       printf("%u bytes written of %u\r\n",nbytes,sizeof(text)-1);
    else
       ///* an error occured, display it and stop */
       error(res,93);
    if ((res=pf_write512(testbuf,1031,sizeof(testbuf),&nbytes))==FR_OK)
       printf("%u bytes written of %u\r\n",nbytes,sizeof(text)-1);
    else
       ///* an error occured, display it and stop */
       error(res,93);   
    if ((res=pf_write(text,sizeof(text)-1,&nbytes))==FR_OK)
       printf("%u bytes written of %u\r\n",nbytes,sizeof(text)-1);
    else
       ///* an error occured, display it and stop */
       error(res,3);

        /* close the file */
    /*
    if ((res=f_close(&file))==FR_OK)
       printf("File %s closed OK\r\n",path);
    else
       // an error occured, display it and stop 
       error(res,4);
    */

    /* open the file in read mode */
    
    //if ((res=f_open(&file,path,FA_READ|FA_WRITE))==FR_OK)
    if ((res=pf_open(path))==FR_OK)
       printf("File %s opened OK\r\n",path);
    else
       ///* an error occured, display it and stop */
       error(res,7);



    /* read and display the file's content.
       make sure to leave space for a NULL terminator
       in the buffer, so maximum sizeof(buffer)-1 bytes can be read */
    //if ((res=f_read(&file,buffer,sizeof(buffer)-1,&nbytes))==FR_OK)
    if ((res=pf_read(buffer,sizeof(buffer)-1,&nbytes))==FR_OK)
       {
       printf("%u bytes read\r\n",nbytes);
       /* NULL terminate the char string in the buffer */
       buffer[nbytes+1]=NULL;
       /* display the buffer contents */
       printf("Read text: \"%s\"\r\n",buffer);
       }
    else
       /* an error occured, display it and stop */
       error(res,6);


    /* close the file */
    /*
    if ((res=f_close(&file))==FR_OK)
       printf("File %s closed OK\r\n",path);
    else
       // an error occured, display it and stop 
       error(res,6);
    */

    /* display file's attribute, size and time stamp */
    //display_status(path);


    /* change file's attributes, set the file to be Read-Only */
    /*
    if ((res=f_chmod(path,AM_RDO,AM_RDO))==FR_OK)
       printf("Read-Only attribute set OK\r\n",path);
    else
       // an error occured, display it and stop 
       error(res,7);
    */
  return 1;
}
void main( void ){
  unsigned char testBuffer1[PAGESIZE];      // Declares variables for testing
  //unsigned char testBuffer2[PAGESIZE];      // Note. Each array uses PAGESIZE bytes of
                                            // code stack
  static unsigned char testChar; // A warning will come saying that this var is set but never used. Ignore it.
  int index;       

  /* globally enable interrupts */
    #asm("sei")
   
  DDRC=0xFF;
  PORTC=0xFF; 
  /* initialize the LCD for 2 lines & 16 columns */
    lcd_init(16);
  /* switch to writing in Display RAM */
    //lcd_gotoxy(0,0);
    lcd_clear();
    //lcd_putsf("User char 0:");
  
  //disk_timerproc();
  lcd_clear();
  lcd_putsf("pff Test3.");
  delay_ms(200);
  UnitTest1();
  
  //RenameTest();
  //UpdateTest();
  //WriteDataTest();
  //ReadDataTest();
  
  /* switch to writing in Display RAM */
    lcd_gotoxy(0,0);
    lcd_putsf("Test3 done.");
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
