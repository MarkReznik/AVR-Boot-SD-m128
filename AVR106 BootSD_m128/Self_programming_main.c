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





//(unsigned long)fat_begin_lba = Partition_LBA_Begin + Number_of_Reserved_Sectors;
//(unsigned long)cluster_begin_lba = Partition_LBA_Begin + Number_of_Reserved_Sectors + (Number_of_FATs * Sectors_Per_FAT);
//(unsigned char)sectors_per_cluster = BPB_SecPerClus;
//(unsigned long)root_dir_first_cluster = BPB_RootClus;
//void testWrite();


void main( void ){
  unsigned int i,j,k;
  unsigned char rollnum;
  unsigned char rollbuf[11];
/* globally enable interrupts */
#asm("sei")
#ifdef DEBUG_LCD
    DDRC.0=1;
    PORTC.0=1;
    /* initialize the LCD for 2 lines & 16 columns */
    lcd_init(16);
    /* switch to writing in Display RAM */
    lcd_gotoxy(0,0);
    lcd_clear();
    lcd_putsf("BootSdTest.");
    lcd_gotoxy(0,1);
    lcd_putsf("0");
    delay_ms(500); 
    //while(1);
#endif
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
    //fat init function
    //init SD
    fat_init();
    
    
    //dir open function
  dir_open("0       ");
  
  
  //fat_file_adr is hold the files records cluster in found dir
  //file open func. read first cluster where data about filenames in dir
  file_open_update("UPDATE");
  
  
    
  //check FAT for chain of clusters to read
  readbytes=0;
  while(fat_file_adr != 0x0FFFFFFFUL)
  {
    //read where next cluster from FAT, check that not EOF
    //if((result[0]=SD_readSingleBlock(fat_begin_lba, sdBuf, &token))!=SD_SUCCESS){
    
    if((result[0]=SD_readSingleBlock(fat_begin_lba+((fat_file_adr*4)/512), sdBuf, &token))!=SD_SUCCESS){
    #ifdef DEBUG_ERRSD    
        errorSD(7);
    #endif
        while(1);//do watchdog reset on error    
    }
    //next cluster address, of file data, read from current cluster record.each record 4 bytes (32bits)
    //fat_file_next_adr=buf2num(&sdBuf[fat_file_adr*4],4);
    fat_file_next_adr=buf2num(&sdBuf[(fat_file_adr*4)%512],4);
    #ifdef DEBUG_LCD
      lcd_clear();
      lcd_putsf("beglba");
      lcd_printhex(fat_begin_lba,sizeof(fat_begin_lba));
      delay_ms(1000);
      lcd_clear();
      lcd_putsf("curcls");
      lcd_printhex(fat_file_adr,sizeof(fat_file_adr));
      lcd_gotoxy(0,1);
      lcd_putsf("nxtcls");
      lcd_printhex(fat_file_next_adr,sizeof(fat_file_next_adr));
      delay_ms(1000); 
    #endif
    adr=cluster_begin_lba +(fat_file_adr-2)*SectorsPerCluster;
    for(i=0;i<SectorsPerCluster;i++)
    {             
        //read data from next sector of file cluster
        if((result[0]=SD_readSingleBlock(adr, sdBuf, &token))!=SD_SUCCESS){
        #ifdef DEBUG_ERRSD    
            errorSD(8);
        #endif    
        }
        #ifdef DEBUG_LCD
          lcd_clear();
          lcd_putsf("sector ");
          lcd_printhex(i,sizeof(i));
          //delay_ms(500);
          //if(readbytes==2048){
          lcd_gotoxy(0,1);
          lcd_putsf("data0 ");
          lcd_printhex(sdBuf[0],sizeof(sdBuf[0]));
          delay_ms(1000);
        //} 
        #endif
        //address 2000 = start adr flash app 3 bytes, flash pages 2 bytes, checksum 2 bytes
        //app bytes starts from 2048, roll 0x88
        if(readbytes<512){
            //j=0x99;
            for(j=0;j<256;j++){//find roll  0x00...0xFF
               if(j>0){
                   for(k=0;k<10;k++){//[settings]
                        rollbuf[k]=(sdBuf[k]<<1)|(sdBuf[k]>>7);  //ROL
                        rollbuf[k]^=j;  //XOR   j=roll
                   }
               }
               result[1]=compbuf("[settings]",&rollbuf[0]);
               if(result[1]!=0){
                    rollnum=j;
                    #ifdef DEBUG_LCD
                      lcd_clear();
                      lcd_putsf("roll ");
                      lcd_printhex(rollnum,sizeof(rollnum));
                      delay_ms(1000); 
                    #endif
                    break;
               }
            }
            if(result[1]==0){//roll didn't found
                #ifdef DEBUG_ERRSD    
                errorSD(9);
                #endif    
                //return;
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
               #ifdef DEBUG_LCD
                  lcd_clear();
                  lcd_putsf("appage ");
                  lcd_printhex(appPages,sizeof(appPages));
                  delay_ms(1000);
                  lcd_clear();
                  lcd_putsf("apstrt ");
                  lcd_printhex(appStartAdr,sizeof(appStartAdr));
                  delay_ms(1000); 
                #endif
               #asm("wdr")
               if(WriteFlashPage(appStartAdr, &sdBuf[pagesCnt*PAGESIZE])==0)
               {
                    //after error during flash write page. wait for watchdog to reset
                    #ifdef DEBUGLED
                    do
                    {
                      PORTC.6=0;
                      delay_ms(500);
                      PORTC.6=1;
                      delay_ms(500); 
                    }
                    #endif
                    while(1);
               }
               appStartAdr+=PAGESIZE;
               appPages--;
               if(appPages==0)
               {
                    #ifdef DEBUG_LCD
                      lcd_clear();
                      lcd_putsf("jump to app");
                      delay_ms(2000); 
                    #endif
                    app_pointer();//go to app address 0
                    /*
                    do
                    {
                      #ifdef DEBUGLED
                      PORTC.5=0;
                      delay_ms(500);
                      PORTC.5=1;
                      delay_ms(500);
                      #endif
                    }while(1);
                    */
               }
           }      
        }
        //read app start adr, num of pages, checksum
        else if(readbytes>=2000){//Offset=512-48=464        
           appStartAdr=(unsigned long)sdBuf[464]<<16;
           appStartAdr|=(unsigned long)sdBuf[465]<<8;
           appStartAdr|=(unsigned long)sdBuf[466];
           appPages=(unsigned int)sdBuf[467]<<8;
           appPages|=(unsigned int)sdBuf[468];
           bytesChecksum=(unsigned int)sdBuf[469]<<8;
           bytesChecksum|=(unsigned int)sdBuf[470];
           checksumCnt=0;
           #ifdef DEBUG_LCD
              lcd_clear();
              lcd_putsf("appags ");
              lcd_printhex(appPages,sizeof(appPages));
              delay_ms(500); 
            #endif
        }
        if(fat_file_next_adr == 0x0FFFFFFFUL){
            
            
            if(readbytes >= filesize){
                break;
            }
            else
            {
                /* 
                if(  WriteFlashPage(0x1EF00, sdBuf)){//;     // Writes testbuffer1 to Flash page 2
                    #ifdef DEBUGLED
                    PORTC.5=0;
                    #endif
                }                                          // Function returns TRUE
                if(  ReadFlashPage (0x1EF00, testBuf)){//;      // Reads back Flash page 2 to TestBuffer2
                    #ifdef DEBUGLED
                    PORTC.6=0;
                    #endif
                }
                */
            }
            
        }    
        adr++;              
    }
    fat_file_adr = fat_file_next_adr;        
  }      
  while(1);
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

#ifdef DEBUG_ERRSD
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
#ifdef DEBUG_LCD
  char strnum[5];
    if(err>100){
       err=100;
    }
    itoa(err,strnum);
    lcd_gotoxy(0,0);
    lcd_putsf("SD ERROR: ");
    lcd_puts(strnum);
    while(1);
#else    
    app_pointer();
#endif     
    //while(1);
}
#endif

//convert bytes buffer to 32bit UL value
unsigned long buf2num(unsigned char *buf,unsigned char len)
{
    unsigned long num=0;
    //unsigned char i;
    /*
    if(len>4){
       len=4;// 4bytes max 32bit UL
    }
    */
    for(;((len>0));len--)
    {
        num<<=8;
        num|=buf[len-1];        
    }
    return num;
}


#ifdef DEBUG_LCD
lcd_printhex(unsigned long num32, char size){
    char i,nible;
    //num32>>=((4-size)*8);//0x12345678 >>24 -> 0x00000012 
    //lcd_putchar(size+'0');
    for(i=1;i<=(size*2);i++){
        nible=((num32)>>(32-((4-size)*8)-((i)*4)))&0x0F;
        if(nible>9){ 
          nible-=0x0A;
          nible+='A';
        }
        else{
          nible+='0';
        }
        lcd_putchar(nible);
    }
}
#endif

//fat32 sd initialization 0=sucess, 1,2,3 errors
unsigned char fat_init(){
  if((result[0]=SD_init())!=SD_SUCCESS){
#ifdef DEBUG_ERRSD    
    errorSD(1);
#endif 
    return 1; 
    //app_pointer();//jump to app 0 on error  
  }
  #ifdef DEBUG_LCD
  lcd_putsf("1");
  delay_ms(500); 
  #endif
  // read MBR get FAT start sector
  if((result[0]=SD_readSingleBlock(0, sdBuf, &token))!=SD_SUCCESS){
#ifdef DEBUG_ERRSD    
    errorSD(2);
#endif
    return 2; 
    //app_pointer();//jump to app 0 on error   
  }  
  #ifdef DEBUG_LCD
  lcd_putsf("2");
  delay_ms(500); 
  #endif  
  adr=buf2num(&sdBuf[445+9],4);//FAT start sector. 1 sector = 512 bytes  
  
  //load and read FAT ID (1st) sector. Get FAT info. Secors per Cluster and etc..
  if((result[0]=SD_readSingleBlock(adr, sdBuf, &token))!=SD_SUCCESS){
    #ifdef DEBUG_ERRSD    
    errorSD(3);
    #endif 
    return 3;
    //app_pointer();//jump to app 0 on error   
  }  
  #ifdef DEBUG_LCD
  lcd_putsf("3");
  delay_ms(500); 
  #endif
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
  return 0;
}

//dir open function 0=sucess, 4 error
unsigned char dir_open(const char *dirname){
  unsigned int i,j;
  result[1]=0;
  for(i=0;i<SectorsPerCluster;i++)
  {
      
      if((result[0]=SD_readSingleBlock(adr, sdBuf, &token))!=SD_SUCCESS){
    #ifdef DEBUG_ERRSD    
        errorSD(4);
    #endif
        return 4; 
        //app_pointer();//jump to app 0 on error   
      }  
      for(j=0;j<(16);j++)//search 16*32bit records in 512bytes sector
      {
           //if((result[1]=compbuf("0          ",&sdBuf[j*32]))!=0)
           if((result[1]=compbuf(dirname,&sdBuf[j*32]))!=0)
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
  if(result[1]==0){
     //app_pointer();//jump to app on error dir not found
     return 5; //jump to app on error dir not found
  }       
  #ifdef DEBUG_LCD
  lcd_putsf("4");//dir found ok
  delay_ms(500); 
  #endif
  return 0; 
}

//file open function 0=sucess, 5,6 errors
unsigned char file_open_update(const char *filename){ 
  unsigned int i,j;
  adr=cluster_begin_lba +(fat_file_adr-2)*SectorsPerCluster;
  for(i=0;i<SectorsPerCluster;i++)
  {
      
      if((result[0]=SD_readSingleBlock(adr, sdBuf, &token))!=SD_SUCCESS){
    #ifdef DEBUG_ERRSD    
        errorSD(6);
    #endif
        return 6;
        //app_pointer();//jump to app on error    
      }  
      for(j=0;j<(16);j++)//search 16 * 32 filename records
      {
           //if((result[1]=compbuf("UPDATE",&sdBuf[j*32]))!=0)
           if((result[1]=compbuf(filename,&sdBuf[j*32]))!=0)
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
    #ifdef DEBUG_ERRSD    
    errorSD(6);
    #endif
    return 6;
    //app_pointer();//jump to app on error    
  }
  #ifdef DEBUG_LCD
  lcd_putsf("5");//file found ok
  delay_ms(500); 
  #endif
  
  
  //check UPDATE0 or UPDATE1...UPDATE9
  if((sdBuf[j*32+6])=='0'){
    //return 1;//error if update reach 0
    #ifdef DEBUG_ERRSD    
    errorSD(7);
    #endif
    #ifdef DEBUG_LCD
    lcd_putsf("ret0");
    delay_ms(500); 
    #endif
    return 7;  //if no more retry
    //app_pointer();//jump to app if no more retry
  }
  else if(((sdBuf[j*32+6])>'0')||((sdBuf[j*32+6])<='9')){ 
    sdBuf[j*32+6]--;//decrement 1 retry.
  }
  else{
    sdBuf[j*32+6]='9';
  }
  result[0]=SD_writeSingleBlock(adr, sdBuf, &token);//save new UPDATE(num) filename.
  #ifdef DEBUG_LCD
  lcd_putsf("7");
  delay_ms(500); 
  #endif
  return 0;
}  