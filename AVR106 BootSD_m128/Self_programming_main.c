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
#include "flash.h"
#include "Self_programming.h"
#include "spi_sdcard.h"

#define SDBUF_SIZE  512
#define PAGES_PER_SDBUF (SDBUF_SIZE/PAGESIZE)


unsigned char result[5], sdBuf[SDBUF_SIZE], testBuf[PAGESIZE], token, SectorsPerCluster, pagesCnt;
unsigned long appStartAdr,adr,SectorsPerFat,fat_begin_lba;
unsigned long cluster_begin_lba,root_dir_first_cluster,fat_file_adr,fat_file_next_adr,filesize,readbytes;
unsigned int appPages,bytesChecksum,checksumCnt;
unsigned int Number_of_Reserved_Sectors;
//(unsigned long)fat_begin_lba = Partition_LBA_Begin + Number_of_Reserved_Sectors;
//(unsigned long)cluster_begin_lba = Partition_LBA_Begin + Number_of_Reserved_Sectors + (Number_of_FATs * Sectors_Per_FAT);
//(unsigned char)sectors_per_cluster = BPB_SecPerClus;
//(unsigned long)root_dir_first_cluster = BPB_RootClus;
//void testWrite();

#ifdef DEBUGLED
void errorSD(unsigned char err);
#endif

unsigned long buf2num(unsigned char *buf,unsigned char len);
unsigned char compbuf(const unsigned char *src,unsigned char *dest);
void (*app_pointer)(void) = (void(*)(void))0x0000;

void main( void ){

  unsigned int i,j,k;
  unsigned char rollnum;
  unsigned char rollbuf[11];
/* globally enable interrupts */
#asm("sei")

#ifdef DEBUGLED
  DDRC=0xFF;
  PORTC=0xFF;
    //do
    {
      PORTC.0=0;
      PORTC.1=1;
      delay_ms(500);
      PORTC.1=0;
      PORTC.0=1;
      delay_ms(500);
      PORTC=0xFF;
    }
    //while(1);
#endif    
  //init SD
  if((result[0]=SD_init())!=SD_SUCCESS){
#ifdef DEBUGLED    
    errorSD(0);
#endif    
  }
  
  // read MBR get FAT start sector
  if((result[0]=SD_readSingleBlock(0, sdBuf, &token))!=SD_SUCCESS){
#ifdef DEBUGLED    
    errorSD(1);
#endif    
  }  
    
  adr=buf2num(&sdBuf[445+9],4);//FAT start sector. 1 sector = 512 bytes  
  
  //load and read FAT ID (1st) sector. Get FAT info. Secors per Cluster and etc..
  if((result[0]=SD_readSingleBlock(adr, sdBuf, &token))!=SD_SUCCESS){
    #ifdef DEBUGLED    
    errorSD(2);
    #endif    
  }  

  SectorsPerCluster=sdBuf[0x0D];// 8 sectors per cluster
  SectorsPerFat=buf2num(&sdBuf[0x24],4); // 0xF10 for test sdcard
  Number_of_Reserved_Sectors=buf2num(&sdBuf[0x0E],2); // 0x20 usually
  //read the FAT fils/directories info from Root Directory cluster (usually 2),Number_of_Reserved_Sectors (usually 0x20). Looking for Folder '0' and clucter of FLASH.DAT file
  //(unsigned long)fat_begin_lba = Partition_LBA_Begin + Number_of_Reserved_Sectors;
  fat_begin_lba=adr+Number_of_Reserved_Sectors;//0x20;//first sector of FAT data
  //(unsigned long)cluster_begin_lba = Partition_LBA_Begin + Number_of_Reserved_Sectors + (Number_of_FATs * Sectors_Per_FAT);
  //Number_of_FATs always 2. Offset 0x10 8bit
  cluster_begin_lba=fat_begin_lba+(2*SectorsPerFat);//number of sector where data begin
  //read root dir (sector 2 but always offset 2 too then 0) to find folder 0 FAT reference. and find Flash.dat sector
  //lba_addr = cluster_begin_lba + (cluster_number - 2) * sectors_per_cluster;
  adr=cluster_begin_lba +(2-2)*SectorsPerCluster;
  //adr*=512UL;
  result[1]=0;
  for(i=0;i<SectorsPerCluster;i++)
  {
      if((result[0]=SD_readSingleBlock(adr, sdBuf, &token))!=SD_SUCCESS){
    #ifdef DEBUGLED    
        errorSD(3);
    #endif    
      }  
      for(j=0;j<(16);j++)
      {
           if((result[1]=compbuf("0          ",&sdBuf[j*32]))!=0)
           {
                break;//dir 0 is found
           }
      }
      if(result[1]!=0)
      {
        fat_file_adr =(unsigned long)sdBuf[j*32+0x14]<<16;
        fat_file_adr|=(unsigned long)sdBuf[j*32+0x1A];
        break;
      }
      else
        adr++;
  }
  adr=cluster_begin_lba +(fat_file_adr-2)*SectorsPerCluster;
  for(i=0;i<SectorsPerCluster;i++)
  {
      if((result[0]=SD_readSingleBlock(adr, sdBuf, &token))!=SD_SUCCESS){
    #ifdef DEBUGLED    
        errorSD(4);
    #endif    
      }  
      for(j=0;j<(16);j++)
      {
           if((result[1]=compbuf("NEW",&sdBuf[j*32]))!=0)
           {
                break;//file Flash... is found
           }
      }
      if(result[1]!=0)
      {
        //read 1st number of cluster where data placed 
        fat_file_adr =(unsigned long)sdBuf[j*32+0x14]<<16;
        fat_file_adr|=(unsigned long)sdBuf[j*32+0x1A];
        filesize = buf2num(&sdBuf[j*32+0x1C],8);
        break;
      }
      else
        adr++;
  }
  
  if(result[1]==0){// error if file not found
    #ifdef DEBUGLED    
        errorSD(4);
    #endif    
  }
  //change filename to DON after good prog
  sdBuf[j*32+0]='D';sdBuf[j*32+1]='O';sdBuf[j*32+2]='N';
  result[0]=SD_writeSingleBlock(adr, sdBuf, &token);
  
  
  //check FAT for chain of clusters to read
  readbytes=0;
  while(fat_file_adr != 0x0FFFFFFFUL)
  {
    //read where next cluster from FAT, check that not EOF
    if((result[0]=SD_readSingleBlock(fat_begin_lba, sdBuf, &token))!=SD_SUCCESS){
    #ifdef DEBUGLED    
        errorSD(5);
    #endif    
    }
    fat_file_next_adr=buf2num(&sdBuf[fat_file_adr*4],4);
    
    adr=cluster_begin_lba +(fat_file_adr-2)*SectorsPerCluster;
    for(i=0;i<SectorsPerCluster;i++)
    {             
        //read data from next sector of file cluster
        if((result[0]=SD_readSingleBlock(adr, sdBuf, &token))!=SD_SUCCESS){
        #ifdef DEBUGLED    
            errorSD(6);
        #endif    
          }
        //address 2000 = start adr flash app 3 bytes, flash pages 2 bytes, checksum 2 bytes
        //app bytes starts from 2048, roll 0x88
        if(readbytes<512){
            //j=0x99;
            for(j=0;j<256;j++){//find roll
               if(j>0){
                   for(k=0;k<10;k++){//[settings]
                        rollbuf[k]=(sdBuf[k]<<1)|(sdBuf[k]>>7);  //ROL
                        rollbuf[k]^=j;  //XOR   j=roll
                   }
               }
               result[1]=compbuf("[settings]",&rollbuf[0]);
               if(result[1]!=0){
                    rollnum=j;
                    break;
               }
            }
            if(result[1]==0){//roll didn't found
                #ifdef DEBUGLED    
                errorSD(7);
                #endif    
                return;
            }
        }
        for(j=0;j<512;j++)
        {
            if(rollnum!=0){
                sdBuf[j]=(sdBuf[j]<<1)|(sdBuf[j]>>7);  //ROL
                sdBuf[j]^=rollnum;//0x88;  //XOR 
            }
            checksumCnt+=sdBuf[j];
        }
        readbytes+=512;
        //read app data
        if(readbytes>2048)
        {
           for(pagesCnt=0;pagesCnt<PAGES_PER_SDBUF;pagesCnt++)
           {
               if(WriteFlashPage(appStartAdr, &sdBuf[pagesCnt*PAGESIZE])==0)
               {
                    //while(1)
                    do
                    {
                      PORTC.6=0;
                      delay_ms(500);
                      PORTC.6=1;
                      delay_ms(500);
                    }while(1);
               }
               appStartAdr+=PAGESIZE;
               appPages--;
               if(appPages==0)
               {
                    app_pointer();
                    do
                    {
                      PORTC.5=0;
                      delay_ms(500);
                      PORTC.5=1;
                      delay_ms(500);
                    }while(1); 
               }
           }      
        }
        //read app start adr, num of pages, checksum
        else if(readbytes>=2000)//Offset=512-48=464
        {
           appStartAdr=(unsigned long)sdBuf[464]<<16;
           appStartAdr|=(unsigned long)sdBuf[465]<<8;
           appStartAdr|=(unsigned long)sdBuf[466];
           appPages=(unsigned int)sdBuf[467]<<8;
           appPages|=(unsigned int)sdBuf[468];
           bytesChecksum=(unsigned int)sdBuf[469]<<8;
           bytesChecksum|=(unsigned int)sdBuf[470];
           checksumCnt=0;
        }
        if(fat_file_next_adr == 0x0FFFFFFFUL)
            if(readbytes >= filesize)
            {
                break;
            }
            else
            {
                
                if(  WriteFlashPage(0x1EF00, sdBuf))//;     // Writes testbuffer1 to Flash page 2
                    PORTC.5=0;                                          // Function returns TRUE
                if(  ReadFlashPage (0x1EF00, testBuf))//;      // Reads back Flash page 2 to TestBuffer2
                    PORTC.6=0;
            }
            
        adr++;              
    }
    fat_file_adr = fat_file_next_adr;        
  }  
  
  
  while(1);
  //static unsigned char testChar; // A warning will come saying that this var is set but never used. Ignore it.
  //if(PORTA==0x55)
    //testWrite();                                          // Returns TRUE
  //__AddrToZ24WordToR1R0ByteToSPMCR_SPM_F(0,0);
  //__AddrToZ24ByteToSPMCR_SPM_W((void flash *)0);
  /*
  unsigned char testBuffer1[PAGESIZE];      // Declares variables for testing
  unsigned char testBuffer2[PAGESIZE];      // Note. Each array uses PAGESIZE bytes of
                                            // code stack
  int index;

  DDRC=0xFF;
  PORTC=0xFF;
  //DDRC=0x00;
  //PORTC=0x00;
  //MCUCR |= (1<<IVSEL);
                        // Move interrupt vectors to boot
  //RecoverFlash();
  
  dospm();
  
  for(index=0; index<PAGESIZE; index++){
    testBuffer1[index]=(unsigned char)index; // Fills testBuffer1 with values 0,1,2..255
  }
  PORTC.4=0;
  //for(;;){
  if(  WriteFlashPage(0x1000, testBuffer1))//;     // Writes testbuffer1 to Flash page 2
    PORTC.5=0;                                          // Function returns TRUE
  if(  ReadFlashPage(0x1000, testBuffer2))//;      // Reads back Flash page 2 to TestBuffer2
    PORTC.6=0;                                          // Function returns TRUE
  if(  WriteFlashByte(0x1004, 0x38))//;            // Writes 0x38 to byte address 0x204
    PORTC.5=0;                                          // Same as byte 4 on page 2
  */
  
  //}
}

unsigned char compbuf(const unsigned char *src,unsigned char *dest)
{
    while(*src)
    {
        if(*src++ != *dest++)
            return 0;
        //src++;dest++;
        //len--;
    }
    return 1;
}

#ifdef DEBUGLED
void errorSD(unsigned char err)
{
#ifdef DEBUGLED    
    unsigned int repeat=10;
    do{
       PORTC &= ~(1<<err);
       delay_ms(500);
       PORTC = 0xFF; 
       delay_ms(500);
    }
    while(repeat--);
#endif  
    app_pointer();
}
#endif

unsigned long buf2num(unsigned char *buf,unsigned char len)
{
    unsigned long num=0;
    //unsigned char i;
    for(;len>0;len--)
    {
        num<<=8;
        num|=buf[len-1];        
    }
    return num;
}

/*
void testWrite()
{
  unsigned char testBuffer1[PAGESIZE];      // Declares variables for testing
  unsigned char testBuffer2[PAGESIZE];      // Note. Each array uses PAGESIZE bytes of
                                            // code stack
  
  
  static unsigned char testChar; // A warning will come saying that this var is set but never used. Ignore it.
  int index;

  //DDRC=0xFF;
  //PORTC=0xFF;
  //DDRC=0x00;
  //PORTC=0x00;
  //MCUCR |= (1<<IVSEL);
                        // Move interrupt vectors to boot
  //RecoverFlash();
  
  //dospm();
  
  for(index=0; index<PAGESIZE; index++){
    testBuffer1[index]=(unsigned char)index; // Fills testBuffer1 with values 0,1,2..255
  }
  PORTC.4=0;
  //for(;;){
  if(  WriteFlashPage(0x1EF00, testBuffer1))//;     // Writes testbuffer1 to Flash page 2
    PORTC.5=0;                                          // Function returns TRUE
  if(  ReadFlashPage(0x1EF00, testBuffer2))//;      // Reads back Flash page 2 to TestBuffer2
    PORTC.6=0;                                          // Function returns TRUE
  if(  WriteFlashByte(0x1EF04, 0x38))//;            // Writes 0x38 to byte address 0x204
    PORTC.5=1;                                          // Same as byte 4 on page 2
  testChar = ReadFlashByte(0x1EF04);        // Reads back value from address 0x204
  
  if(testChar==0x38)
  {
    while(1)
    {
      PORTC.6=0;
      delay_ms(500);
      PORTC.6=1;
      delay_ms(500);;
    }
  }  
}
*/