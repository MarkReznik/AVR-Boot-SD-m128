#include <io.h> // hp
#include "LCD.h"

void Riset(void)
{

   Write_HalfComand(0x30);
   Write_HalfComand(0x30);
   Write_HalfComand(0x30);
   Write_HalfComand(0x30);
   Write_HalfComand(0x20);
   Write_Comand(0x28);
   Write_Comand(0x10);
   Write_Comand(0x0C);
   Write_Comand(0x06);
   Write_Comand(0x01);
   WriteRAM();

}
void WriteRAM(void){
char add;
   Write_Comand(0x48); 
   
   Write_Char(0x0);
   Write_Char(0xa);
   Write_Char(0xa);
   Write_Char(0x4);
   Write_Char(0x4);    // antenna   //add 0
   Write_Char(0x4);
   Write_Char(0x4);
   Write_Char(0x0);

//   Write_Char(0x0);
//   Write_Char(0x10);
//   Write_Char(0x10);
//   Write_Char(0x18);   // max receiving //add 1 
//   Write_Char(0x1c);
//   Write_Char(0x1e);
//   Write_Char(0x1f);
//   Write_Char(0x0);
   Write_Char(0x15);
   Write_Char(0x15);
   Write_Char(0x17);
   Write_Char(0x11);   // max receiving //add 1 
   Write_Char(0x11);   //=4
   Write_Char(0x10);
   Write_Char(0x18);
   Write_Char(0x1c);   

//   Write_Char(0x0);
//   Write_Char(0x0);
//   Write_Char(0x10);
//   Write_Char(0x18);   // max-1 receiving //add 2 
//   Write_Char(0x1c);
//   Write_Char(0x1e);
//   Write_Char(0x1f);
//   Write_Char(0x0);
   Write_Char(0x07);
   Write_Char(0x11);
   Write_Char(0x17);
   Write_Char(0x11);   // max-1 receiving //add 2 
   Write_Char(0x17);   //=3
   Write_Char(0x10);
   Write_Char(0x18);
   Write_Char(0x1c);   
   
//   Write_Char(0x0);
//   Write_Char(0x0);
//   Write_Char(0x0);
//   Write_Char(0x8);   // max-2 receiving //add 3 
//   Write_Char(0xc);
//   Write_Char(0xe);
//   Write_Char(0xf);
//   Write_Char(0x0);
   
   Write_Char(0x07);
   Write_Char(0x01);
   Write_Char(0x17);
   Write_Char(0x14);   // max-2 receiving //add 3 
   Write_Char(0x17);   //=2
   Write_Char(0x10);
   Write_Char(0x18);
   Write_Char(0x1c);   
   
//   Write_Char(0x0);
//   Write_Char(0x0);
//   Write_Char(0x0);
//   Write_Char(0x0);   // max-3 receiving //add 4 
//   Write_Char(0x4);   //1
//   Write_Char(0x6);
//   Write_Char(0x7);
//   Write_Char(0x0);  
   
   
   Write_Char(0x00);
   Write_Char(0x00);
   Write_Char(0x00);
   Write_Char(0x00);   // max-3 receiving //add 4
   Write_Char(0x00);   //minimum reception=1 
   Write_Char(0x00);
   Write_Char(0x00);
   Write_Char(0x00);
   
//   Write_Char(0x02);
//   Write_Char(0x06);
//   Write_Char(0x02);
//   Write_Char(0x12);   // max-3 receiving //add 4
//   Write_Char(0x17);   //minimum reception=1 
//   Write_Char(0x10);
//   Write_Char(0x18);
//   Write_Char(0x1c);
  
                     

   Write_Char(0x04);   
   Write_Char(0x0a);        
   Write_Char(0x11);       
   Write_Char(0x00);        
   Write_Char(0x00);    // /\   location 6   
   Write_Char(0x00);        
   Write_Char(0x00);     
   Write_Char(0x00); 
   
   Write_Char(0x04);   
   Write_Char(0x0a);        
   Write_Char(0x11);       
   Write_Char(0x0a);        
   Write_Char(0xff);    // /\  plus #  location 7   
   Write_Char(0x0a);        
   Write_Char(0xff);     
   Write_Char(0x0a); 
   
   
          
     
   Write_Char(0x0e);     //?
   Write_Char(0x11);        
   Write_Char(0x01);       
   Write_Char(0x02);        
   Write_Char(0x04);         
   Write_Char(0x00);        
   Write_Char(0x04);     
   Write_Char(0x00);            

                          
//   Write_Char(0x04);  
//   Write_Char(0x04);            
//   Write_Char(0x0A);       
//   Write_Char(0x11);      BELL       
//   Write_Char(0x1F);                   
//   Write_Char(0x04); 
//   Write_Char(0x00);   
//   Write_Char(0x00);     


}
void LCD_Delay(unsigned char Ms)
{
  unsigned int i;
  char j;
   for(j = 0;j < Ms;j++)
     for(i = 0;i<100;i++);
}

void WriteStr(unsigned char* Str,unsigned char Add)
{
   unsigned char Ind;
   Write_Comand(0x80 + Add);

   for(Ind = 0;(Ind < 16)&&(Str[Ind]);Ind++)
   {
      Write_Char(Str[Ind]);

   }
   for(;Ind<15;Ind++)
   {
      Write_Char(' ');
   }
}

void Write_Char(unsigned char Data)
{
   Chek_Busy();
   PORTC&= ~0xf0;
   PORTC|= ((Data & 0xF0)|RS);
   Togle_E();
   PORTC&= ~0xf0;
   PORTC|= (((Data<<4) &0xF0)|RS);
   Togle_E();
   PORTC&= ~RS;

}

void Write_Comand(unsigned char Data)
{

   Chek_Busy();
   PORTC&= ~0xf0;
   PORTC|= (Data & 0xF0);
   Togle_E();
   PORTC&= ~0xf0;
   PORTC|= ((Data<<4) &0xF0);
   Togle_E();

}
void Write_HalfComand(unsigned char Data)
{
   LCD_Delay(5);
   PORTC&= ~0xf0;
   PORTC|= (Data & 0xF0);
   Togle_E();
}

void Chek_Busy(void)
{
   unsigned char result = 0x80;
   PORTC|=0x80;
   DDRC=0x7F; // 0xe7

   PORTC|= R_W;
   PORTC&= ~RS;

   while (result & 0x80)
   {
       PORTC|= 0x80;         // set data
       #asm("nop");
       #asm("nop");
       #asm("nop");
       PORTC|= STROB;        // set clk
       #asm("nop");
       #asm("nop");
       #asm("nop");
       result = PINC;
       if(!(result & 0x80))
          result = PINC;
       PORTC&= ~0x80;   // clear data

       PORTC&= ~STROB;  // clear clk

       Togle_E();

   }

   DDRC=0xFF; // 0xe7
   PORTC&= ~0xf0;

   PORTC&= ~R_W;

}
void Togle_E(void)
{
   #asm("nop");
   #asm("nop");
   PORTC|= STROB;
   #asm("nop");
   #asm("nop");
   #asm("nop");
   PORTC&= ~STROB;
   #asm("nop");
   #asm("nop");
}