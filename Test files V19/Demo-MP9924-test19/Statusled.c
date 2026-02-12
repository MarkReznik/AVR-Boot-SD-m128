#include "StatusLed.h"
unsigned char StatusLed[8];           // array for status of leds   
void DisplayLed(char led,char Status)
{ 
      switch(Status)
      {
           case 0: 
                StatusLed[0]&= ~led;  
                StatusLed[1]&= ~led; 
           break;
           case 1:
                StatusLed[0]&= ~led; 
                StatusLed[1]|= led;
           break;  
           case 2: 
                StatusLed[0]|= led; 
                StatusLed[1]&= ~led;
           break;
           case 3:   
                StatusLed[0]|= led;
                StatusLed[1]|= led;
           break;  
           case 4:   
                StatusLed[0]^= led;
                StatusLed[1]^= led;
           break;                     
      }      
      RealTimeSHB[1] = AllBordsSHB;
      RealTime[2] = AllBords;    
}
void StatusKeybordLed(void)
{
    char i;      
    StatusLed[2] = StatusLed[3] = StatusLed[4] = 0;
    StatusLed[5] = StatusLed[6] = StatusLed[7] = 0;
    for(i = 0; i < 8;i++){           
         if(Zone[i] & 0x80) StatusLed[2]|= 1<<i;          // open                                   
         if(Zone[i] & 0x40) StatusLed[4]|= 1<<i;          // bypass        
         if(Zone[i] & 0x10) StatusLed[6]|= 1<<i;          // active
    }    
    for(i = 0; i < 8;i++){          
         if(Zone[i+8] & 0x80) StatusLed[3]|= 1<<i;        // open                             
         if(Zone[i+8] & 0x40) StatusLed[5]|= 1<<i;        // bypass        
         if(Zone[i+8] & 0x10) StatusLed[7]|= 1<<i;        // active  
    }          
}  