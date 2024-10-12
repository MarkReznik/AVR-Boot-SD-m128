
#ifndef __MYFAT_H
#define __MYFAT_H

#define SDBUF_SIZE  512
#define PAGES_PER_SDBUF (SDBUF_SIZE/PAGESIZE)


//function prototypes
unsigned char fat_init();//0=sucess, 1,2,3 errors
unsigned char dir_open(const char *dirname); //0=sucess, 4 error
unsigned char file_open_update(const char *filename); //0=sucess, 5,6 errors
unsigned long buf2num(unsigned char *buf,unsigned char len);
unsigned char compbuf(const unsigned char *src,unsigned char *dest);
void (*app_pointer)(void) = (void(*)(void))0x0000;


#enfif