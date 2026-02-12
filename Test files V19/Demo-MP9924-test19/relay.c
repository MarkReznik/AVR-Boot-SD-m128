#include <mega128.h>          
#include "Relay.h"
#include "Define.h"  
  
unsigned int LongRalay1,LongRalay2,LongRalay3, LongRalay4, LongRalay5, LongRalay6, LongRalay7;  
unsigned int   Data_Rely, BiRelay;  
unsigned char CountR_RES_F, FlagR_RES_F;
unsigned char CountRelay;    
unsigned char FlagStartRelay;       
unsigned char CounterPauseRelay;  
unsigned char QueRelay,TempRelay,TempRelay1,TempRelay2;

void RelayOn(char Relay)
{           
     char i;   
   //  Call_Pulse=125;   
  //   PORTE &=~0x02;//HOLD  REST P                         
   //  UCSR0B=0x00;                   
  //   Snd_Relay=1;//Relay; 
  /*   
     //PORTA = PORTF = 0;
     //clear relay output 
     PORTF &=~0x3f;
     PORTA |=0x30;// strob u19 and U20 
     #asm("NOP");           
     #asm("NOP");           
     PORTA &=~0x30;
     
     PORTF &=~0x3f;  
     CamBLrelay &=~0xf;
     PORTF |=CamBLrelay; //restor camera and back light status
     PORTA |=0x40;// strob u21
     #asm("NOP");           
     #asm("NOP");           
     PORTA &=~0x40;

     
     if(!Relay)return; 
     if(Relay>16)return; 
        
     if(Relay >= 9){ 
          Relay-=9;
          TempRelay2=0;  
          TempRelay2 |= ((int)0x01<<Relay);                    
     }else{  
          TempRelay1=0;      
          Relay-=1;
          TempRelay1= (1<<Relay); 
     } 
     if ( TempRelay2){           
          if (TempRelay2 &0xf0){
               TempRelay1 =TempRelay2>> 4;
               PORTF &=~0x3f;   
               CamBLrelay |=TempRelay1; //restor camera and back light status                  
               PORTF |=CamBLrelay; //restor camera and back light status  
               PORTA |=0x40;// strob u21
               #asm("NOP");           
               #asm("NOP");           
               PORTA &=~0x40; 
          }else {    
               TempRelay1 =TempRelay2<< 2;
               PORTF &=~0x3f;   
               PORTF |=TempRelay1; //restor camera and back light status                  
               PORTA |=0x20;// strob u20
               #asm("NOP");           
               #asm("NOP");           
               PORTA &=~0x20;           
          }  
          TempRelay1=0;                      
     }else if (TempRelay1){
          if (TempRelay1& 0xc0){  
               PORTF &=~0x3f; 
               if (TempRelay1&0x80) PORTF |=0x2;
               if (TempRelay1&0x40) PORTF |=0x1;               
               PORTF |=TempRelay2; //restor camera and back light status                  
               PORTA |=0x20;// strob u20
               #asm("NOP");           
               #asm("NOP");           
               PORTA &=~0x20;                     
          }else {
               PORTF &=~0x3f;   
               PORTF |=TempRelay1; //restor camera and back light status                  
               PORTA |=0x10;// strob u20
               #asm("NOP");           
               #asm("NOP");           
               PORTA &=~0x10;                     
          }
     }*/
 
}  
    
void RelayOff(void)
{     
/*     //PORTA = PORTF = 0;  
     PORTF &=~0x3f;
     PORTA |=0x30;// strob u19 and U20 
     #asm("NOP");           
     #asm("NOP");           
     PORTA &=~0x30;
     
     PORTF &=~0x3f;
     CamBLrelay &=~0xf;
     PORTF |=CamBLrelay; //restor camera and back light status  
     
     PORTA |=0x40;// strob u21
     #asm("NOP");           
     #asm("NOP");           
     PORTA &=~0x40;*/
 
}  
void OpenDoorRelay2(void){
     Wait_DoorOpen_Now=250;
     PxyCodeCnt=0;
     PORTG|= 0x1;
}
void OpenDoorRelay(void){
     Wait_DoorOpen_Now=250;
     PxyCodeCnt=0;
     PORTD|= 0x20;
} 
void CloseDoorRelay2(void){
     PORTG&= ~0x1;
}
void CloseDoorRelay(void){
     PORTD&= ~0x20; 
}
