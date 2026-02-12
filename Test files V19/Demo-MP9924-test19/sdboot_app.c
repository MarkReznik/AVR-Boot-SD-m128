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
* Version: 0.0.0.10     1.Added TEMPDATA fill/rename functions
* Version: 0.0.0.11     1.Updated UnitTest to check UPDATE 4,3,2
* Version: 0.0.0.12     1.Added function SdRenameFile
* Version: 0.0.0.13     1.Fixed LCD strings in Unittest
* Version: 0.0.0.17     1. Changed tests to TRY -> DONE added FACTORY file
* Version: 0.0.0.18     1. Rename function fixed (const char* from,const char* to)
*                       2. Added defines for UPDATE BACKUP FACTOR and VER
*                       3. All defines moved to sdboot.h
* Version: 0.0.0.19     1. New try count for UPDATE try8,7,6 BACKUP try5 FACTOR try 4,3,2,1,0    
*****************************************************************************/
#include <io.h>
#include <delay.h>
#include "sdboot.h"
//#include "Self_programming.h"
/* FAT on MMC/SD/SD HC card support */
//Petit fat api
#include <pff_rn.h>
#include "diskio.h"		/* Declarations of low level disk I/O functions */

/* printf */
//#define DEBUG_PRINT
#ifdef DEBUG_PRINT
#include <stdio.h>
#endif
#include <stdlib.h>

/* string functions */
#include <string.h>

/*Globals*/
int retry;
/* FAT function result */
FRESULT res;
/* number of bytes written/read to the file */
unsigned int nbytes;
/* offset to the file */
unsigned long u32_offset;
/* will hold the information for logical drive 0: */
FATFS fat;
/* will hold the file information */
//FIL file;
/* will hold file attributes, time stamp information */
//FILINFO finfo;
/* root directory path */
//char s_Sd_File_Path[64];//="/0/unittest.txt";
/* text to be written to the file */
//char s_Sd_File_Text[]="Unit Test 1";
/* file read buffer */
#define COPY_BUFF_SIZE  512
char u8_Sd_File_Buffer[COPY_BUFF_SIZE];

/* error message list */
//#ifdef DEBUG_PRINT
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
//#endif

void DebugBlinkLed(unsigned char u8_led_0_7, unsigned char u8_blink_times)
{
#ifdef DEBUG_LED    
    do
    {
      PORTC |= (1<<u8_led_0_7);
      delay_ms(500);
      PORTC &= ~(1<<u8_led_0_7);
      delay_ms(500);
      if(u8_blink_times == 1)
        break;
      else if(u8_blink_times)
        u8_blink_times--;    
    }
    while(1); 
#endif    
}

void DebugPrintString(char *str1, char *str2)
{
#ifdef DEBUG_PRINT
    printf(str1);
#endif    
}

/* display error message and stop */
void error(FRESULT res, unsigned char num)
{
#ifdef DEBUG_LCD    
    char strnum[5];
    if(num>100){
       num=100;
    }
    itoa(num,strnum);
    do{
    if ((res>=0) && (res<=FR_NO_FILESYSTEM)){//FR_NO_FILESYSTEM  FR_TIMEOUT
       lcd_gotoxy(0,0);
       DebugPrintString("ERROR:","");//printf("ERROR: %p\r\n",error_msg[res]);
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
#ifdef DEBUG_LED       
          PORTC.0=0;
          PORTC.1=0;
          delay_ms(150);
          PORTC.1=1;
          PORTC.0=1;
          delay_ms(150);
          PORTC=0xFC; 
#endif          
        }
      while(1);
#endif      
}


// This function get 3 parameters
// 1. Path
// 2. Filename
// 3. Bool is exact filename to compare.
//Return 0: File not found
//Return 1: File found
unsigned char FindFileName(char *path, char *filename, unsigned char u8_is_exact)
{
    //BRIEF
    //open root dir, try find *filename  as partial filename 
    FRESULT res;
    FILINFO fno;
    DIR dir;
    
    res = pf_opendir(&dir, path);//open root or dir
    if(res != FR_OK)
        error(res,21);
    for (;;) {
        res = pf_readdir(&dir, &fno);
        if (res != FR_OK || fno.fname[0] == 0) break;
        if (fno.fattrib & AM_DIR) {
            continue;
        } else {
            //printf("%s/%s\n", path, fno.fname);    
            //check the filename begin with "UPDATE"
            if(u8_is_exact)
            {
                if(strcmp(filename,fno.fname)==0)
                {
                    return 1;//filename found inside dir
                }
            }
            else if(strncmp(filename,fno.fname,6)==0)
            {
                return 1;//filename found inside dir
            }
        }
    }
    return 0;//filename not found inside dir
}

// This function get 3 parameters
// 1. Path
// 2. Filename
// 3. Bool is exact filename to compare
//Return 0: File not found or size 0
//Return File found size
unsigned long FindFileNameSize(char *path, char *filename, unsigned char u8_is_exact)
{
    //BRIEF
    //open root dir, try find *filename  as partial filename 
    FRESULT res;
    FILINFO fno;
    DIR dir;
    
    res = pf_opendir(&dir, path);//open root or dir
    if(res != FR_OK)
        error(res,21);
    for (;;) {
        res = pf_readdir(&dir, &fno);
        if (res != FR_OK || fno.fname[0] == 0) break;
        if (fno.fattrib & AM_DIR) {
            continue;
        } else {
            //printf("%s/%s\n", path, fno.fname);    
            //check the filename begin with "UPDATE"
            if(u8_is_exact)
            {
                if(strcmp(filename,fno.fname)==0)
                {
                    return fno.fsize;
                    //return 1;//filename found inside dir
                }
            }
            else if(strncmp(filename,fno.fname,6)==0)
            {
                return fno.fsize;
                //return 1;//filename found inside dir
            }
        }
    }
    return 0;//filename not found inside dir
}
//Check that file "DATA4K" is exist on SD card
//Return 0: File OK
//Return 1: Failed to find the file
unsigned char SdDataFileStatus()
{
    unsigned char u8_data_file_flag = 0;
    
    res=pf_mount(&fat);
    if (res==FR_OK)
       DebugPrintString("Logical drive 0: mounted OK\r\n","");
    else
       /* an error occured, display it and stop */
       error(res,1);

    u8_data_file_flag = FindFileName("", "DATA4K", 1);
    if(u8_data_file_flag)
        return 0;
    else
        return 1;
}

// BRIEF
// Function: SdUpdateStatus()
// Description: This function validate SD card file names are as expected 
// Check the "UPDATE" file exists and rename it to "BACKUP". The "BACKUP" file renamed to "TEMPDATA"
// Return 0(OK): "TRY[0-9]" not exsts,"BACKUP" and "UPDATE" exsts. 
// Return 1(FAIL): only "UPDATE[0-9]" exists. 
// Return 2(OK): only "UPDATE" and "BACKUP" exists
// Return 3(FAIL): "UPDATE" ,"BACKUP" and "TEMPDATA" exists
unsigned char SdUpdateStatus()
{
    unsigned char u8_try_file_flag = 0;
    unsigned char u8_update_file_flag = 0;
    unsigned char u8_backup_file_flag = 0;
    unsigned char u8_tempdata_file_flag = 0;
    unsigned char u8_try_counter;
    unsigned char u8_try_max;
    
    char p_s8_filename[]="TRY9";
    char p_s8_cnt_char[]="9";
    
    res=pf_mount(&fat);
    if (res==FR_OK)
       DebugPrintString("Logical drive 0: mounted OK\r\n","");
    else
    {
       /* an error occured, display it and stop */
       error(res,1); 
    }

#ifdef DEBUG_LCD
    lcd_clear();
    lcd_putsf("FIND TRY");
    delay_ms(DEBUG_LCD_MSG_MS);        
#endif
    #ifdef SD_FACTOR//case of factory comilation
    u8_try_max = 0;
    #else
    u8_try_max = 5;//8,7,6,5 cases for UPDATE and BACKUP try find
    #endif    
    for(u8_try_counter = 9; u8_try_counter > u8_try_max; )
    {
        u8_try_counter--;
        p_s8_cnt_char[0] = '0'+ u8_try_counter; 
        p_s8_filename[3]=p_s8_cnt_char[0];
#ifdef DEBUG_LCD
        lcd_clear();
        //lcd_puts(p_s8_cnt_char);
        lcd_puts(p_s8_filename);
        delay_ms(DEBUG_LCD_MSG_MS);        
#endif        
        
        
        if((u8_try_file_flag = FindFileName("", p_s8_filename ,0))==0)
        {
            continue;
        }        
        if(u8_try_counter <= 5)//for FACTORY and BACKUP
        {
            u8_try_file_flag = 2;//don't rename backup<->update
            
        }
        break;
    }

#ifdef DEBUG_LCD
    lcd_gotoxy(0,1);
    if(u8_try_file_flag)
        lcd_putsf("FILE EXISTS");
    else
        lcd_putsf("FILE NOT EXIST");
    delay_ms(DEBUG_LCD_MSG_MS);        
#endif
#ifdef DEBUG_LCD
    lcd_clear();
    lcd_putsf("FIND BACKUP");
    delay_ms(DEBUG_LCD_MSG_MS);        
#endif
    u8_backup_file_flag = FindFileName("", "BACKUP",1);
#ifdef DEBUG_LCD
    lcd_gotoxy(0,1);
    if(u8_backup_file_flag)
        lcd_putsf("FILE EXISTS");
    else
        lcd_putsf("FILE NOT EXIST");
    delay_ms(DEBUG_LCD_MSG_MS);        
#endif
#ifdef DEBUG_LCD
    lcd_clear();
    lcd_putsf("FIND UPDATE");
    delay_ms(DEBUG_LCD_MSG_MS);        
#endif   
    u8_update_file_flag = FindFileName("", "UPDATE",1);
#ifdef DEBUG_LCD
    lcd_gotoxy(0,1);
    if(u8_update_file_flag)
        lcd_putsf("FILE EXISTS");
    else
        lcd_putsf("FILE NOT EXIST");
    delay_ms(DEBUG_LCD_MSG_MS);        
#endif
/*
#ifdef DEBUG_LCD
    lcd_clear();
    lcd_putsf("FIND TEMPDATA");
    delay_ms(DEBUG_LCD_MSG_MS);        
#endif   
    u8_tempdata_file_flag = FindFileName("", "TEMPDATA",1);
#ifdef DEBUG_LCD
    lcd_gotoxy(0,1);
    if(u8_tempdata_file_flag)
        lcd_putsf("FILE EXISTS");
    else
        lcd_putsf("FILE NOT EXIST");
    delay_ms(DEBUG_LCD_MSG_MS);        
#endif
*/
    //in case "UPDATE" found check the "BACKUP" exists
    if(u8_update_file_flag && u8_backup_file_flag)// && u8_tempdata_file_flag)
    {
        
        if(u8_try_file_flag)
        {
           if(u8_try_file_flag!=2)//is not backup or factory case => switch names buckup<->update
           {
                //rename BACKUP to "UPBACKUP"     
                if(res=SdRenameFile("BACKUP","UPBACKUP"))
                    return 1;
                //rename UPDATE to "BACKUP"     
                if(res=SdRenameFile("UPDATE","BACKUP"))
                    return 1;    
                //rename UPBACKUP to "UPDATE"     
                if(res=SdRenameFile("UPBACKUP","UPDATE"))
                    return 1;
           }
           //rename TRY4,3,2 to "DONE"     
           if(res=SdRenameFile("TRY","DONE"))
                return 1;
           return 0;     
        }
        else
           return 2;                
    }
    return 4; //FAIL : STOP and signal that BACKUP and TEMPDATA or UPDATE files missing 
}

unsigned char CopyFile(char *path, char *srcfile, char *destfile)
{
    //unsigned long u32_offset = 0;
    //unsigned int  nbytes;
    //unsigned char buffer[COPY_BUFF_SIZE];
    unsigned char u8_eof_flag = 0;
      
    res=pf_mount(&fat);
    if (res==FR_OK)
       DebugPrintString("Logical drive 0: mounted OK\r\n","");
    else
       /* an error occured, display it and stop */
       error(res,1);
    
    while(u8_eof_flag == 0)
    {
        if ((res=pf_open(srcfile))==FR_OK)
           PORTC.0=0;//printf("File %s created OK\r\n",path);
        else{
           /* an error occured, display it and stop */
           if(res)//FR_NO_FILE,			/* 3 */
                error(res,2);
        }
       
       /* Move to offset of u32_offset from top of the file */
       res = pf_lseek(u32_offset);
       if ((res=pf_read(u8_Sd_File_Buffer,COPY_BUFF_SIZE,&nbytes))==FR_OK)
       {
            PORTC.0=1;
            if(nbytes < COPY_BUFF_SIZE)
               if(nbytes == 0)
                 return 0;
               else  
                 u8_eof_flag = 1; 
            if ((res=pf_open(destfile))==FR_OK)
                PORTC.0=0;//printf("File %s opened OK\r\n",path);
            else{
               /* an error occured, display it and stop */
               if(res)//FR_NO_FILE,			/* 3 */
                    error(res,2);
            }
            if ((res=pf_write512(u8_Sd_File_Buffer,u32_offset,nbytes,&nbytes))==FR_OK)
               //printf("%u bytes written of %u\r\n",nbytes,sizeof(text)-1);
               PORTC.0=1;//printf("write ok");
            else
               ///* an error occured, display it and stop */
               error(res,93);
            res = pf_lseek(u32_offset);
            if ((res=pf_read(u8_Sd_File_Buffer,COPY_BUFF_SIZE,&nbytes))==FR_OK)
                PORTC.0=1;//printf("File %s read OK\r\n",path);
            else{
               /* an error occured, display it and stop */
               if(res)//FR_NO_FILE,			/* 3 */
                    error(res,2);
            }
            u32_offset += COPY_BUFF_SIZE;  
       }
       else
           /* an error occured, display it and stop */
           error(res,6);
    }
    return 0;
}

// Function:    SdDataFileRead()  
// Description: Read data from SD root file "/DATA4K" 
// 3 argument:
// 1. *p_u8_data_buffer - pointer to bytes buffer place data from SD data file
// 2. u32_data_offset - SD data file offset in bytes
// 3. data_length -  SD data file bytes to read to provided buffer
// 4. *p_u16_read_bytes - pointer to u16 read data from SD data file
// Return 0: OK
unsigned char SdDataFileRead(unsigned char *p_u8_data_buffer, unsigned long u32_data_offset, unsigned int data_length, unsigned int *p_u16_read_bytes)
{
    /* mount logical drive 0: */
    res=pf_mount(&fat);
    if (res==FR_OK)
       DebugPrintString("Logical drive 0: mounted OK\r\n","");//printf("Logical drive 0: mounted OK\r\n");
    else
       /* an error occured, display it and stop */
       error(res,1);
    
    if ((res=pf_open("DATA4K"))==FR_OK)
       DebugPrintString("File DATA4K opened OK\r\n","");//printf("File %s opened OK\r\n",s_Sd_File_Path);
    else
       ///* an error occured, display it and stop */
       error(res,2);   
    
    /* Move to offset of u32_offset from top of the file */
       res = pf_lseek(u32_data_offset);
    /* Read data to buffer */
       if ((res=pf_read(p_u8_data_buffer,data_length,p_u16_read_bytes))==FR_OK)
            DebugPrintString("Read DATA4K OK\r\n","");
       else
            error(res,3);     
       
    return 0;
}

// Function:    SdDataFileWrite()  
// Description: Write data to SD root file "/DATA4K" 
// 4 argument:
// 1. *p_u8_data_buffer - pointer to bytes buffer place data from SD data file
// 2. u32_data_offset - SD data file offset in bytes
// 3. data_length -  SD data file bytes to write from provided buffer
// 4. *p_u16_read_bytes - pointer to u16 writen data to SD data file
unsigned char SdDataFileWrite(unsigned char *p_u8_data_buffer, unsigned long u32_data_offset, unsigned int data_length, unsigned int *p_u16_read_bytes)
{
    /* mount logical drive 0: */
    res=pf_mount(&fat);
    if (res==FR_OK)
       DebugPrintString("Logical drive 0: mounted OK\r\n","");//printf("Logical drive 0: mounted OK\r\n");
    else
       /* an error occured, display it and stop */
       error(res,1);
    
    if ((res=pf_open("DATA4K"))==FR_OK)
       DebugPrintString("File DATA4K opened OK\r\n","");//printf("File %s opened OK\r\n",s_Sd_File_Path);
    else
       ///* an error occured, display it and stop */
       error(res,2);   

    /* Write data from buffer to SD file */
       if ((res=pf_write512(p_u8_data_buffer, u32_data_offset, data_length, p_u16_read_bytes))==FR_OK)
            DebugPrintString("Write DATA4K OK\r\n","");
       else
            error(res,3);     
       
    return 0;
}

// Function:    SdUpdateFileWrite()  
// Description: Write data to SD root file "/UPDATE" 
// 4 argument:
// 1. *p_u8_data_buffer - pointer to bytes buffer place data from SD data file
// 2. u32_data_offset - SD data file offset in bytes
// 3. data_length -  SD data file bytes to write from provided buffer
// 4. *p_u16_read_bytes - pointer to u16 writen data to SD data file
// Return 0: OK
unsigned char SdUpdateFileWrite(unsigned char *p_u8_data_buffer, unsigned long u32_data_offset, unsigned int data_length, unsigned int *p_u16_read_bytes)
{
    /* mount logical drive 0: */
    res=pf_mount(&fat);
    if (res==FR_OK)
       DebugPrintString("Logical drive 0: mounted OK\r\n","");//printf("Logical drive 0: mounted OK\r\n");
    else
       /* an error occured, display it and stop */
       error(res,1);
    
    if ((res=pf_open("UPDATE"))==FR_OK)
       DebugPrintString("File UPDATE opened OK\r\n","");//printf("File %s opened OK\r\n",s_Sd_File_Path);
    else
       ///* an error occured, display it and stop */
       error(res,2);   

    /* Write data from buffer to SD file */
       if ((res=pf_write512(p_u8_data_buffer, u32_data_offset, data_length, p_u16_read_bytes))==FR_OK)
            DebugPrintString("Write UPDATE OK\r\n","");
       else
            error(res,3);     
       
    return 0;
}

// Function:    SdRenameFile()  
// Description: Rename SD root file "/NAME1" to "/NAME2"
// No arguments
// Return 0: OK
unsigned char SdRenameFile(const char* from_name, const char* to_name)
{
    res=pf_mount(&fat);
    if (res==FR_OK)
       DebugPrintString("Logical drive 0: mounted OK\r\n","");
    else
    {
       /* an error occured, display it and stop */
       error(res,1); 
    }
    if(res=pf_rename11("",from_name,to_name))
        return res;        
    return 0;
}

// Function:    SdUpdateFileComplete()  
// Description: Rename SD root file "/DONE" to "/TRY5"
// No arguments
// Return 0: OK
unsigned char SdUpdateFileComplete()
{
    res=pf_mount(&fat);
    if (res==FR_OK)
       DebugPrintString("Logical drive 0: mounted OK\r\n","");
    else
    {
       /* an error occured, display it and stop */
       error(res,1); 
    }
    if(res=pf_rename11("","DONE","TRY5"))
        return res;        
    return 0;
}
    
unsigned char SdDataErase(unsigned long u32_size_bytes, unsigned char u8_fill_value)
{
    unsigned long i;
    
    for(u32_offset = 0; u32_offset < COPY_BUFF_SIZE; u32_offset ++ )
    {    
        u8_Sd_File_Buffer[u32_offset] = u8_fill_value;
                 
    }
    
    for(u32_offset = 0; u32_offset < u32_size_bytes; u32_offset += COPY_BUFF_SIZE )
    {
        if(SdDataFileWrite(u8_Sd_File_Buffer, u32_offset, COPY_BUFF_SIZE, &nbytes))
            return 1;
        if(nbytes < COPY_BUFF_SIZE)
            return 2;
        
    }
    return 0;
}

unsigned char UnitTest1(){
    
    unsigned char u8_test_result;   
    BYTE testbuf[10]={'5','5','A','A','6','6','B','B','C','C'};
    //strcpy(path,"/0/UPDATE3.DAT");
    
    //1. check if UPDATE exists(means Boot copy the UPDATE3 to Flash App) then change the name to BACKUP3 and the BACKUP name to TEMPDATA
    //Return 0: Files ready to get new Firmware Update data after Buckup file is ready. 
    u8_test_result = SdUpdateStatus();
    if(u8_test_result)
        return 1;
    //2. check the TEMPDATA file exists to get new Firmware Update data 
    //Return 0: OK
    u8_test_result = SdDataFileStatus();
    if(u8_test_result)
        return 2;
    
    //3. Simulate copy Firmware Update data to TEMPDATA file
    //u8_test_result = CopyFile("", "DEMODATA", "TEMPDATA");
    
    //4. change the TEMPDATA filename to UPDATE3 then reset or jump to Boot
    //Return 0: OK
    //u8_test_result = pf_rename11("","TEMPDATA","UPDATE3");
    
    //4.1 Rename function example 
    u8_test_result = SdRenameFile("NAME1", "NAME2");
    if(u8_test_result)
        return 3;
    
    /** Example to fill data to TEPMDATA file then rename it to UPDATE ****
    //3. Fill "TEMPDATA" file with update file data
    if(u8_test_result = SdUpdateFileWrite(testbuf, 0, 5, &nbytes))
        return 3;
    //4. Rename "TEMPDATA" to "UPDATE3"
    if(u8_test_result = SdUpdateFileComplete())
        return 4;
    */
    
    //5. Erase data
    //unsigned char SdDataErase(unsigned long u32_size_bytes, unsigned char u8_fill_value)
    if(u8_test_result = SdDataErase(4096, ' '))
        return 5;
    
    //6. Write Data test
    //unsigned char SdDataFileWrite(unsigned char *p_u8_data_buffer, unsigned long u32_data_offset, unsigned int data_length, unsigned int *p_u16_read_bytes)
    if(u8_test_result = SdDataFileWrite(testbuf, 0, 5, &nbytes))
       return 6;
    
    //7. Read Data test
    //unsigned char SdDataFileRead(unsigned char *p_u8_data_buffer, unsigned long u32_data_offset, unsigned int data_length, unsigned int *p_u16_read_bytes)
    if(u8_test_result = SdDataFileRead(testbuf, 0, 5, &nbytes))
       return 7;
        
    return u8_test_result;
}

void main_app( void ){
  unsigned char testBuffer1[16];      // Declares variables for testing
  //unsigned char testBuffer2[PAGESIZE];      // Note. Each array uses PAGESIZE bytes of
                                            // code stack
  static unsigned char testChar; // A warning will come saying that this var is set but never used. Ignore it.
  int index;       
  unsigned char u8_test_result;
  DDRC.0 = 1;
  PORTC.0 = 1;
  delay_ms(1000);
  PORTC.0 = 0;
  delay_ms(1000);
  
  /* globally enable interrupts */
    #asm("sei")
    #asm("wdr")
#ifdef DEBUG_LED   
  DDRC=0xFF;
  PORTC=0xFF;
#endif   
  /* initialize the LCD for 2 lines & 16 columns */
#ifdef DEBUG_LCD  
    lcd_init(16);
  /* switch to writing in Display RAM */
    //lcd_gotoxy(0,0);
    //lcd_clear();
    //lcd_putsf("User char 0:");
  
  //disk_timerproc();
  lcd_clear();
  lcd_putsf("TST UPDATE V15");
  delay_ms(2000);
  PORTC.0 = 1;
  delay_ms(1000);
#endif  
  #asm("wdr")
  u8_test_result = UnitTest1();
#ifdef DEBUG_LCD
    lcd_clear();
    lcd_putsf("Result:");
    testBuffer1[0]=u8_test_result+'0';
    testBuffer1[1]=0;
    lcd_puts(testBuffer1);
    lcd_putsf("    ");
    if(u8_test_result)
    {
        lcd_gotoxy(0,1);
        lcd_putsf("FAIL");
        if(u8_test_result==3)
            lcd_putsf(" RENAME");
    }
    delay_ms(2500);
#endif  
  DebugBlinkLed(u8_test_result,0);
  
  //RenameTest();
  //UpdateTest();
  //WriteDataTest();
  //ReadDataTest();
  
  /* switch to writing in Display RAM */
#ifdef DEBUG_LCD
    lcd_gotoxy(0,0);
    lcd_putsf("Test done.");
#endif    
  //blink LEDS on Evaluation Bord PORTC LED-0,1,2,3,4,5,6,7
  do
    {
#ifdef DEBUG_LED      
      PORTC.0=0;
      PORTC.1=0;
      delay_ms(500);
      PORTC.1=1;
      PORTC.0=1;
      delay_ms(500);
      PORTC=0xFC;
#endif      
    }
    while(0); 
}

