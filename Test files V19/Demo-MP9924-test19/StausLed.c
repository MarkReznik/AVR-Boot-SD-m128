#include "StatusLed.h"
unsigned char StatusLed[6];           // array for status of leds   
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
      RealTime[2] = AllBords;    
}