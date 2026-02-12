extern char eeprom *ptr_to_eeprom;  
extern unsigned int  Pointer;                 // pointer to data from eeprom 
extern unsigned char  Line;
void WriteDataChip(char List);      // write data to eeprom
void ReadDataChip(char List);       // read data from eeprom
void EEPROM_write(char eeprom* uiAddress, unsigned char ucData);
unsigned char EEPROM_read(char eeprom* uiAddress);

extern unsigned char MaxNum,Data[17];  // New 2.05 version change