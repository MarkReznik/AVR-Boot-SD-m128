// This file has been prepared for Doxygen automatic documentation generation.
/*! \file ********************************************************************
*
* Atmel Corporation
*
* - File              : Self_programming.c
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
* $Date: Wednesday, January 18, 2006 15:18:52 UTC $
*
****************************************************************************/
#include <io.h>
//#include <inavr.h>
#include "Self_programming.h"
//#include "flash.h"

void (*__AddrToZ24WordToR1R0ByteToSPMCR_SPM_F)(void flash * addr, unsigned int data)= (void(*)(void flash *, unsigned int)) 0x0F9DB;
void (*__AddrToZ24ByteToSPMCR_SPM_W)(void flash * addr)= (void(*)(void flash *)) 0x0F9EB;
void (*__AddrToZ24ByteToSPMCR_SPM_E)(void flash * addr)= (void(*)(void flash *)) 0x0FA0B;
void (*__AddrToZ24ByteToSPMCR_SPM_EW)(void flash * addr)= (void(*)(void flash *)) 0x0FA2B;

/*!
* Declare global struct variable in EEPROM if Flash recovery enabled.
* FlashBackup pageNumber holds Flash pageaddress (/PAGESIZE) the data in Flash
* recovery buffer should be written to if data need to be recovered.
* FlashBackup.status tells if data need to be recovered.
**/
#ifdef __FLASH_RECOVER
__eeprom struct {
  unsigned int  pageNumber;
  unsigned char status;
}FlashBackup = {0};
#endif

__eeprom struct {
  unsigned long  flashStartAdr;
  unsigned int length;
  unsigned char status;//0=already moved to flash, 1=not moved to flash yet
  unsigned char data[PAGESIZE];
}_EepromBackup @10;

/*!
* The function Returns one byte located on Flash address given by ucFlashStartAdr.
**/
unsigned char ReadFlashByte(MyAddressType flashStartAdr){
//#pragma diag_suppress=Pe1053 // Suppress warning for conversion from long-type address to flash ptr.
  flashStartAdr;//+=ADR_LIMIT_LOW;
  return (unsigned char)*((MyFlashCharPointer)flashStartAdr);
//#pragma diag_default=Pe1053 // Back to default.
} // Returns data from Flash

/*!
* The function reads one Flash page from address flashStartAdr and stores data
* in array dataPage[]. The number of bytes stored is depending upon the
* Flash page size. The function returns FALSE if input address is not a Flash
* page address, else TRUE.
**/
unsigned char ReadFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage){
  unsigned int index;
  flashStartAdr;//+=ADR_LIMIT_LOW;
  if(!(flashStartAdr & (PAGESIZE-1))){      // If input address is a page address
    for(index = 0; index < PAGESIZE; index++){
      dataPage[index] = ReadFlashByte(flashStartAdr + index);
    }
    return TRUE;                            // Return TRUE if valid page address
  }
  else{
    return FALSE;                           // Return FALSE if not valid page address
  }
}
unsigned char ReadFlashBytes(MyAddressType flashStartAdr, unsigned char *dataPage, unsigned int length){
  	unsigned int index;
  	flashStartAdr+=ADR_LIMIT_LOW;
    for(index = 0; index < length; index++){
      dataPage[index] = ReadFlashByte(flashStartAdr + index);
    }
    return TRUE;                            // Return TRUE if valid page address
}
unsigned char VerifyFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage){
  unsigned int index;
  if(!(flashStartAdr & (PAGESIZE-1))){      // If input address is a page address
    for(index = 0; index < PAGESIZE; index++){
      if(dataPage[index] != ReadFlashByte(flashStartAdr + index))
      {
        PORTC.6=0;
        return FALSE;
      }
    }
    return TRUE;                            // Return TRUE if valid page address
  }
  else{
    PORTC.7=0;
    return FALSE;                           // Return FALSE if not valid page address
  }
}
unsigned char WriteFlashBytes(MyAddressType flashAdr, unsigned char *data, unsigned int length)
{
    unsigned char tempBuffer[PAGESIZE];
    MyAddressType flashAdrStart,flashAdrNext;
    unsigned int lengthStart,lengthIndex;                //length=0x20
    while(length)
    {
        flashAdrStart= flashAdr-(flashAdr%PAGESIZE);//0x1F0-(0x1F0%0x100)=0x0100                        //
        flashAdrNext = flashAdrStart+PAGESIZE;          //0x0100+0x100=0x200
        if((flashAdrNext - flashAdr) >= length)    //enough space case
        {
           lengthStart=length;
           length=0;  
        }
        else                                   //(0x200-0x1F0)<0x20
        {
           lengthStart=(flashAdrNext - flashAdr);        //len1=0x200-0x1F0=0x10
           length-=lengthStart;                         //len2=0x20-0x10=0x10
        }
        if(ReadFlashPage(flashAdrStart,tempBuffer)==FALSE) //read flash page to tempBuffer
        {
            PORTC.3=0;
            return FALSE;
        }
        for(lengthIndex=(flashAdr%PAGESIZE);lengthIndex<((flashAdr%PAGESIZE)+lengthStart);lengthIndex++)
        {
            tempBuffer[lengthIndex]=*data++;
        }
        flashAdr=flashAdrNext;
        if(WriteFlashPage(flashAdrStart+ADR_LIMIT_LOW,tempBuffer)==FALSE) //write tempBuffer to flash page
        {
            PORTC.4=0;
            return FALSE;
        }     
    }
    return TRUE;
}

/*!
* The function writes byte data to Flash address flashAddr. Returns FALSE if
* input address is not valid Flash byte address for writing, else TRUE.
**/
unsigned char WriteFlashByte(MyAddressType flashAddr, unsigned char data){
  MyAddressType  pageAdr;
  unsigned char eepromInterruptSettings,saveSREG;
  flashAddr+=ADR_LIMIT_LOW;
  if( AddressCheck( flashAddr & ~(PAGESIZE-1) )){

    if(ReadFlashByte(flashAddr)==data)
    {
        PORTC.4=0;
        return TRUE;
    }
    eepromInterruptSettings= EECR & (1<<EERIE); // Stores EEPROM interrupt mask
    EECR &= ~(1<<EERIE);                    // Disable EEPROM interrupt
    while(EECR & (1<<EEWE));                // Wait if ongoing EEPROM write
    saveSREG=SREG;
    #asm("cli")
    pageAdr=flashAddr & ~(PAGESIZE-1);      // Gets Flash page address from byte address

    #ifdef __FLASH_RECOVER
    FlashBackup.status=0;                   // Inicate that Flash buffer does
                                            // not contain data for writing
    while(EECR & (1<<EEWE));
    LpmReplaceSpm(flashAddr, data);         // Fills Flash write buffer
    WriteBufToFlash(ADR_FLASH_BUFFER);      // Writes to Flash recovery buffer
    FlashBackup.pageNumber = (unsigned int) (pageAdr/PAGESIZE); // Stores page address
                                                       // data should be written to
    FlashBackup.status = FLASH_BUFFER_FULL_ID; // Indicates that Flash recovery buffer
                                               // contains unwritten data
    while(EECR & (1<<EEWE));
    #endif

    if(LpmReplaceSpm(flashAddr, data)!=0)         // Fills Flash write buffer
    {
        _PAGE_WRITE(pageAdr);
        PORTC.1=0;
    }
    else
    {
        _PAGE_EW(pageAdr);
        PORTC.2=0;
    }
         
    #ifdef __FLASH_RECOVER
    FlashBackup.status = 0;                 // Indicates that Flash recovery buffer
                                            // does not contain unwritten data
    while(EECR & (1<<EEWE));
    #endif

    EECR |= eepromInterruptSettings;        // Restore EEPROM interrupt mask
    SREG=saveSREG;
    return TRUE;                            // Return TRUE if address
                                            // valid for writing
  }
  else
    return FALSE;                           // Return FALSE if address not
                                            // valid for writing
}

/*!
* The function writes data from array dataPage[] to Flash page address
* flashStartAdr. The Number of bytes written is depending upon the Flash page
* size. Returns FALSE if input argument ucFlashStartAdr is not a valid Flash
* page address for writing, else TRUE.
**/
unsigned char WriteFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage)
{
  unsigned int index;
  unsigned char eepromInterruptSettings,saveSREG;
  MyAddressType  pageAdr;
  flashStartAdr;//+=ADR_LIMIT_LOW;
  if( AddressCheck(flashStartAdr) ){
    if(eepromBackup(flashStartAdr,PAGESIZE,dataPage)==0)
    {
        return FALSE;
    }
    eepromInterruptSettings = EECR & (1<<EERIE); // Stoes EEPROM interrupt mask
    EECR &= ~(1<<EERIE);                    // Disable EEPROM interrupt
    while(EECR & (1<<EEWE));                // Wait if ongoing EEPROM write
    saveSREG=SREG;                          // Save SREG
    #asm("cli")
    
    #ifdef __FLASH_RECOVER
    FlashBackup.status=0;                   // Inicate that Flash buffer does
                                            // not contain data for writing
    while(EECR & (1<<EEWE));
    
    for(index = 0; index < PAGESIZE; index+=2){ // Fills Flash write buffer
      _WAIT_FOR_SPM();
      _FILL_TEMP_WORD(index, (unsigned int)dataPage[index]+((unsigned int)dataPage[index+1] << 8));
    }
    
    WriteBufToFlash(ADR_FLASH_BUFFER);      // Writes to Flash recovery buffer
    FlashBackup.pageNumber=(unsigned int)(flashStartAdr/PAGESIZE);
    FlashBackup.status = FLASH_BUFFER_FULL_ID; // Indicates that Flash recovery buffer
                                           // contains unwritten data
    while(EECR & (1<<EEWE));
    #endif
    
    //debug
    _PAGE_ERASE(flashStartAdr);
    
    for(index = 0; index < PAGESIZE; index+=2){ // Fills Flash write buffer
      _FILL_TEMP_WORD(index, (unsigned int)dataPage[index]+((unsigned int)dataPage[index+1] << 8));
    }
    _PAGE_WRITE(flashStartAdr);
    if(VerifyFlashPage(flashStartAdr,dataPage)==FALSE)
    {
      //PORTC.6=0;
      return FALSE;
    }  
    #ifdef __FLASH_RECOVER
      FlashBackup.status=0;                 // Inicate that Flash buffer does
                                            // not contain data for writing
      while(EECR & (1<<EEWE));
    #endif

    EECR |= eepromInterruptSettings;        // Restore EEPROM interrupt mask
    SREG=saveSREG;                          // Restore interrupts to SREG
    _EepromBackup.status=0;
    return TRUE;                            // Return TRUE if address                                            // valid for writing
  }
  else
    return FALSE;                           // Return FALSE if not address not
                                            // valid for writing
}

unsigned char eepromBackup(unsigned long flashStartAdr, unsigned int length, unsigned char *data)
{
    _EepromBackup.flashStartAdr=flashStartAdr;
    _EepromBackup.length=length;
    for(;length>0;length--)
    {
         _EepromBackup.data[length-1]=data[length-1];
         if(_EepromBackup.data[length-1]!=data[length-1])
         {
            return FALSE;//error during backup on eeprom
         }
    }
    _EepromBackup.status=1;//1=ready to move to flash
    return TRUE;
}

/*!
* The function checks if global variable FlashBackup.status indicates that Flash recovery
* buffer contains data that needs to be written to Flash. Writes data from
* Flash recovery buffer to Flash page address given by FLASH_recovery.pageAdr.
* This function should be called at program startup if FLASH recovery option
* is enabeled.
**/
unsigned char RecoverFlash(){
#ifdef __FLASH_RECOVER
  unsigned int index;
  unsigned long flashStartAdr = (MyAddressType)FlashBackup.pageNumber * PAGESIZE;
  if(FlashBackup.status == FLASH_BUFFER_FULL_ID){ // Checks if Flash recovery
                                                  //  buffer contains data
    
    for(index=0; index < PAGESIZE; index+=2){     // Writes to Flash write buffer
        _WAIT_FOR_SPM();
        _FILL_TEMP_WORD( index, *((MyFlashIntPointer)(ADR_FLASH_BUFFER+index)) );
    }
    
    
    //WriteBufToFlash((MyAddressType)FlashBackup.pageNumber * PAGESIZE);
    _WAIT_FOR_SPM();
    _PAGE_ERASE( flashStartAdr );
    _WAIT_FOR_SPM();
    _PAGE_WRITE( flashStartAdr );
    _WAIT_FOR_SPM();
    _ENABLE_RWW_SECTION();
    FlashBackup.status=0;                   // Inicate that Flash buffer does
                                            // not contain data for writing
    while(EECR & (1<<EEWE));
    return TRUE;                            // Returns TRUE if recovery has
                                            // taken place
  }
#endif
  return FALSE;
}


/*!
* The function checks if input argument is a valid Flash page address for
* writing. Returns TRUE only if:
* - Address points to the beginning of a Flash page
* - Address is within the limits defined in Self_programming.h
* - Address is not equal to page address used for buffring by the Flash recovery
*   functions (if enabled).
* Returns FALSE else.
**/
unsigned char AddressCheck(MyAddressType flashAdr){
  #ifdef __FLASH_RECOVER
  // The next line gives a warning 'pointless comparison with zero' if ADR_LIMIT_LOW is 0. Ignore it.
  if( (flashAdr >= ADR_LIMIT_LOW) && (flashAdr <= ADR_LIMIT_HIGH) &&
      (flashAdr != ADR_FLASH_BUFFER) && !(flashAdr & (PAGESIZE-1)) )
    return TRUE;                            // Address is a valid page address
  else
    return FALSE;                           // Address is not a valid page address
  #else
  if((flashAdr >= ADR_LIMIT_LOW) && (flashAdr <= ADR_LIMIT_HIGH) && !(flashAdr & (PAGESIZE-1) ) )
    return TRUE;                            // Address is a valid page address
  else
    return FALSE;                           // Address is not a valid page address
  #endif
}


/*!
* The function reads Flash page given by flashAddr, replaces one byte given by
* flashAddr with data, and stores entire page in Flash temporary buffer.
**/
unsigned char LpmReplaceSpm(MyAddressType flashAddr, unsigned char data){
//#pragma diag_suppress=Pe1053 // Suppress warning for conversion from long-type address to flash ptr.
    unsigned int index, oddByte, pcWord;
    unsigned char onlyWrite=1;
    MyAddressType  pageAdr;
    oddByte=(unsigned char)flashAddr & 1;
    pcWord=(unsigned int)flashAddr & (PAGESIZE-2); // Used when writing FLASH temp buffer
    pageAdr=flashAddr & ~(PAGESIZE-1);        // Get FLASH page address from byte address
    //_FILL_TEMP_WORD(index, (unsigned int)dataPage[index]+((unsigned int)dataPage[index+1] << 8));
    for(index=0; index < PAGESIZE; index+=2){
        if(index==pcWord){
          if(oddByte){
            _FILL_TEMP_WORD( index, (*(MyFlashCharPointer)(flashAddr & ~1) | ((unsigned int)data<<8)) );
          }                                     // Write odd byte in temporary buffer
          else{
            _FILL_TEMP_WORD( index, ( (*( (MyFlashCharPointer)flashAddr+1)<<8)  | data ) );
          }                                     // Write even byte in temporary buffer       
          if(((*((MyFlashCharPointer)flashAddr))&0xFF)!=0xFF)
                onlyWrite=0;                                    
        }
        else{
          _FILL_TEMP_WORD(index, *( (MyFlashIntPointer)(pageAdr+index) ) );
          //if(*((MyFlashIntPointer)(pageAdr+index)) != 0xFFFF)
                //onlyWrite=0;
        }                                       // Write Flash word directly to temporary buffer
    }
    return onlyWrite;
//#pragma diag_default=Pe1053 // Back to default.
}
