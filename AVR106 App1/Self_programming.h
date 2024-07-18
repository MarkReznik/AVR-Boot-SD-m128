// This file has been prepared for Doxygen automatic documentation generation.
/*! \file ********************************************************************
*
* Atmel Corporation
*
* - File              : Self_programming.h
* - Compiler          : IAR EWAVR 2.28a / 3.10c and newer
*
* - Support mail      : avr@atmel.com
*
* - Supported devices : All devices with bootloaders support.
*
* - AppNote           : AVR106 - C functions for reading and writing
*                       to flash memory.
*
* - Description       : The file contains functions for easy reading and writing
*                       of Flash memory on parts having the "Self-programming"
*                       feature. The user functions are as follows:
*
*                       ReadFlashByte()	
*                       ReadFlashPage()	
*                       WriteFlashByte()
*                       WriteFlashPage()	
*                       RecoverFlash()	
*
*                       The remaining functions contained in this file are used
*                       by the functions listet above.
*
* $Revision: 2.0 $
* $Date: Wednesday, January 18, 2006 15:18:54 UTC $
*
*****************************************************************************/
//#include <ioavr.h>

#ifndef __SELF_PROGRAMMING_H
#define __SELF_PROGRAMMING_H

#define _FILL_TEMP_WORD(addr,data) __AddrToZ24WordToR1R0ByteToSPMCR_SPM_F( (void flash *) (addr), data )
#define _PAGE_WRITE(addr) __AddrToZ24ByteToSPMCR_SPM_W( (void flash *) (addr) )
#define _PAGE_ERASE(addr) __AddrToZ24ByteToSPMCR_SPM_E( (void flash *) (addr) )
#define _PAGE_EW(addr)    __AddrToZ24ByteToSPMCR_SPM_EW( (void flash *) (addr) )


/******************************************************************************
* Defines for configuration
******************************************************************************/
#define __ATmega128__
#define FLASHEND 0x1FFFFUL    // 64K Words or 128Kbytes
//#define __FLASH_RECOVER       // This define enables FLASH buffering to avoid
                              // data loss if reset or power break when writing
#define ADR_FLASH_BUFFER 0x1000UL    // Defines the FLASH page address used for buffering
                              // if enabeled. Will use Flash page 0 for buffering
//#define ADR_LIMIT_LOW   0x10000UL     // Defines the low address limit for FLASH write
#define FLASH_BYTES     0x10000 //64Kbytes 
#define BOOTSECTORSIZE  0x2000U // 4096 words or 8192 bytes
#define ADR_LIMIT_HIGH  FLASHEND-BOOTSECTORSIZE// 0xF800 Word adr or 0x1F000 Byte adr. Defines the high address limit for FLASH write
#define ADR_LIMIT_LOW   (ADR_LIMIT_HIGH-FLASH_BYTES+1)
/******************************************************************************
* Definition of PAGESIZE
******************************************************************************/

#if defined(__ATtiny13__)   || defined(__AT90Tiny13__)   || \
    defined(__ATtiny2313__) || defined(__AT90Tiny2313__)
#define PAGESIZE 32
#endif

#if defined(__ATmega88__)   || defined(__AT90Mega88__)   || \
    defined(__ATmega48__)   || defined(__AT90Mega48__)   || \
    defined(__ATmega8__)    || defined(__AT90Mega8__)    || \
    defined(__ATmega8515__) || defined(__AT90Mega8515__) || \
    defined(__ATmega8535__) || defined(__AT90Mega8535__)
#define PAGESIZE 64
#endif

#if defined(__ATmega162__)  || defined(__AT90Mega162__)  || \
    defined(__ATmega163__)  || defined(__AT90Mega163__)  || \
    defined(__ATmega168__)  || defined(__AT90Mega168__)  || \
    defined(__ATmega169__)  || defined(__AT90Mega169__)  || \
    defined(__ATmega161__)  || defined(__AT90Mega161__)  || \
    defined(__ATmega16__)   || defined(__AT90Mega16__)   || \
    defined(__ATmega32__)   || defined(__AT90Mega32__)   || \
    defined(__ATmega323__)  || defined(__AT90Mega323__)  || \
    defined(__ATmega329__)  || defined(__AT90Mega329__)  || \
    defined(__ATmega3290__) || defined(__AT90Mega3290__)
#define PAGESIZE 128
#endif

#if defined(__ATmega64__)   || defined(__AT90Mega64__)   || \
    defined(__ATmega640__)  || defined(__AT90Mega640__)  || \
    defined(__ATmega649__)  || defined(__AT90Mega649__)  || \
    defined(__ATmega6490__) || defined(__AT90Mega6490__) || \
    defined(__ATmega128__)  || defined(__AT90Mega128__)  || \
    defined(__ATmega1280__) || defined(__AT90Mega1280__) || \
    defined(__ATmega1281__) || defined(__AT90Mega1281__) || \
    defined(__ATmega2560__) || defined(__AT90Mega2560__) || \
    defined(__ATmega2561__) || defined(__AT90Mega2561__)
#define PAGESIZE 256
#endif

/******************************************************************************
* Definition of datatypes
* All functions uses integer types for passing Flash addresses.
******************************************************************************/

#ifdef __HAS_ELPM__
typedef unsigned long MyAddressType;                  // Used for passing address to functions
typedef unsigned char __farflash* MyFlashCharPointer; // Used for reading Flash
typedef unsigned int __farflash* MyFlashIntPointer;  // Used for reading Flash
#else
typedef unsigned long  MyAddressType;                  // Used for passing address to functions
typedef unsigned char __flash* MyFlashCharPointer;    // Used for reading Flash
typedef unsigned int  __flash* MyFlashIntPointer;
#endif


/******************************************************************************
* Definition of SPM controll register. Labeled SPMCR on some devices, SPMSCR
* on others.
******************************************************************************/
/*
#if defined(__ATmega16__)   || defined(__AT90Mega16__)   || \
    defined(__ATmega161__)  || defined(__AT90Mega161__)  || \
    defined(__ATmega162__)  || defined(__AT90Mega162__)  || \
    defined(__ATmega163__)  || defined(__AT90Mega163__)  || \
    defined(__ATmega32__)   || defined(__AT90Mega32__)   || \
    defined(__ATmega323__)  || defined(__ATMega323__)    || \
    defined(__ATmega64__)   || defined(__AT90Mega64__)   || \
    defined(__ATmega8__)    || defined(__AT90Mega8__)    || \
    defined(__ATmega8535__) || defined(__AT90Mega8535__) || \
    defined(__ATmega8515__) || defined(__AT90Mega8515__)
#define SPMControllRegister SPMCR
#else
#define SPMControllRegister SPMCSR
#endif
*/
/******************************************************************************
* Other defines
******************************************************************************/

#define FLASH_BUFFER_FULL_ID  0xAA
#define TRUE 1
#define FALSE 0

/******************************************************************************
* Function prototypes
******************************************************************************/

/* User functions */


unsigned char ReadFlashByte(MyAddressType flashStartAdr);
unsigned char ReadFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage);
unsigned char WriteFlashByte(MyAddressType flashAddr, unsigned char data);
unsigned char WriteFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage);

unsigned char RecoverFlash();
unsigned char eepromBackup(unsigned long flashStartAdr, unsigned int length, unsigned char *data);
unsigned char VerifyFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage);
unsigned char WriteFlashBytes(MyAddressType flashAdr, unsigned char *data, unsigned int length);
unsigned char ReadFlashBytes(MyAddressType flashStartAdr, unsigned char *dataPage, unsigned int length);

/* Functions used by user functions */
unsigned char AddressCheck(MyAddressType flashAdr);

//void WriteBufToFlash(MyAddressType flashStartAdr);
unsigned char LpmReplaceSpm(MyAddressType flashAddr, unsigned char data);

#endif /* End if __BOOT_FUNC_H */
