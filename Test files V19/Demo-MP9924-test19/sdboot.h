#ifndef _SDBOOT_H_

#define DEBUG_LCD
#ifdef DEBUG_LCD
#define DEBUG_LCD_MSG_MS 1000
#include <alcd.h>
#include <delay.h>
#endif
#define _SDBOOT_H_
#define SD_VER  "V19"
//1. Comment this to use BACKUP or FACTOR
//#define SD_UPDATE
#define SD_NAME "UPDATE"
#ifndef SD_UPDATE
//2  Comment this to use FACTOR
//#define SD_BACKUP
#define SD_NAME "BACKUP"
#ifndef SD_BACKUP
//3
#define SD_FACTOR
#define SD_NAME "FACTOR"
#endif
#endif
extern unsigned int nbytes;
unsigned char FindFileName(char *path, char *filename, unsigned char u8_is_exact);
unsigned long FindFileNameSize(char *path, char *filename, unsigned char u8_is_exact);
unsigned char SdDataFileStatus();
unsigned char SdUpdateStatus();
unsigned char CopyFile(char *path, char *srcfile, char *destfile);
unsigned char SdDataFileRead(unsigned char *p_u8_data_buffer, unsigned long u32_data_offset, unsigned int data_length, unsigned int *p_u16_read_bytes);
unsigned char SdDataFileWrite(unsigned char *p_u8_data_buffer, unsigned long u32_data_offset, unsigned int data_length, unsigned int *p_u16_read_bytes);
unsigned char SdUpdateFileWrite(unsigned char *p_u8_data_buffer, unsigned long u32_data_offset, unsigned int data_length, unsigned int *p_u16_read_bytes);
unsigned char SdRenameFile(const char *from_name, const char *to_name);
unsigned char SdUpdateFileComplete();
unsigned char SdDataErase(unsigned long u32_size_bytes, unsigned char u8_fill_value);
unsigned char UnitTest1();
void main_app( void );

#endif