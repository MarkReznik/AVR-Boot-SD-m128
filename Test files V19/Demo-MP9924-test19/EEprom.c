#include <mega128.h>     
#include "EEprom.h"   

#pragma warn-
eeprom char ptr_EEPROM[3800];
#pragma warn+     
char eeprom *ptr_to_eeprom;  
unsigned int  Pointer;                 // pointer to data from eeprom
unsigned char  Line;       
unsigned char  FlagCanWriteEE;
void WriteDataChip(char List)  //write data to eeprom
{                  
    char i;
    int ind;         
    Line = List;
    ind = List - 1;
    ptr_to_eeprom = ptr_EEPROM + Pointer + (ind * MaxNum);
    for(i = 0; (i < MaxNum)&&(i < 16); i++){        
       FlagCanWriteEE = 1;
       EEPROM_write(ptr_to_eeprom++, Data[i]);     // wtite to eeprom                                                                                     
    }   
    
}
void ReadDataChip(char List)  //read data from eeprom
{
    char i;   
    int ind;   
    Line = List;
    ind = List - 1;          
    EEPROM_read(ptr_to_eeprom+3999);     // read from eeprom
    ptr_to_eeprom = ptr_EEPROM + Pointer + (ind * MaxNum);
    for(i = 0; (i < MaxNum)&&(i < 16); i++)        
       Data[i] = EEPROM_read(ptr_to_eeprom++);     // read from eeprom   
    Data[i] = 0;   
}  
void EEPROM_write(char eeprom* uiAddress, unsigned char ucData)
{                           
    if(FlagCanWriteEE){ 
        FlagCanWriteEE = 0;
        // Wait for compleshion of previous write
        while(EECR & (1<<0x02));         // EEWE    
        // set up address and data registers   
        *uiAddress = ucData;    
        // Write logical one to EEMWE    
        EECR|= (1<<0x04);            //EEMWE    
        // Start eeprom write by setting EEWE    
        EECR|= (1<<0x02);          //EEWE
    }    
}
unsigned char EEPROM_read(char eeprom* uiAddress)
{
    // wait for completion of previous write
    while(EECR & (1<<0x02));       // EEWE
       
    // start eeprom read by eriting EERE
    
    EECR|= (1<<0x01);       //EERE
    return (*uiAddress);
    
}    
   
