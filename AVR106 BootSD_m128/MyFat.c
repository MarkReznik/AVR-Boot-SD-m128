

//#define DEBUGLED
//#define DEBUG_ERRSD
//#define DEBUG_LCD

#ifdef DEBUG_LCD

/* printf */
#include <stdio.h>
#include <stdlib.h>
/* string functions */
#include <string.h>
#include <alcd.h>

#endif

unsigned char result[5], sdBuf[SDBUF_SIZE], testBuf[PAGESIZE], token, SectorsPerCluster, pagesCnt;
unsigned long appStartAdr,adr,SectorsPerFat,fat_begin_lba;
unsigned long cluster_begin_lba,root_dir_first_cluster,fat_file_adr,fat_file_next_adr,filesize,readbytes;
unsigned int appPages,bytesChecksum,checksumCnt;
unsigned int Number_of_Reserved_Sectors;

#ifdef DEBUG_ERRSD
void errorSD(unsigned char err);
#endif
#ifdef DEBUG_LCD
lcd_printhex(unsigned long num32, char size);
char cnum[10];
#endif

