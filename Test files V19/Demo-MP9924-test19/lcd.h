#define STROB   0x02   //prt2
#define RS      0x04   //prt0 
#define R_W     0x08   //prt0

void Riset(void);
void LCD_Delay(unsigned char Ms);
void WriteStr(unsigned char* Str,unsigned char Add);
void Write_Char(unsigned char Data);               
void Write_Comand(unsigned char Data);
void Write_HalfComand(unsigned char Data);
void Chek_Busy(void);
void Togle_E(void);
void WriteRAM(void);