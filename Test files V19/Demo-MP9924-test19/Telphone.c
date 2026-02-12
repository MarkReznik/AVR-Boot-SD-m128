#include <mega128.h> 
#include "Telphone.h"  
#include "Define.h"  

unsigned char  StrTelTone[17];   // telephone number
unsigned char  GoTel, indTone, MaxTone;
unsigned char  SecondTone, TimePauseTone,TimePausePul; 
unsigned char  ChangePul;      
void ToTelephonePuls(void)
{
           if((!tConected)&&(!TimePauseTone))
           {                                                                               
                   if(CountTel >= MaxTelephone-1){                 
                               CountTel = 0; 
                               if(CycleDial != 0xFF)
                                     CycleDial--;   
                               if(!CycleDial)FlagStopSiren|= 1;                                           
                   }
                   else{        
                              FlagStopSiren&= ~0x01;   
                              CountTel++;                      
                              SendTelephone(CountTel);                                                                                                                                                                                              
                   }                                          
           }                                 
}       
 void SendTelephone(char Number)
{                
      char i;   
      Pointer = Telephone;                   
      MaxNum = CMaxTelephone;       
      ReadData(Number);
      for(i = 0;(i < 16)&&(Data[i]>0x20);i++){  
           StrTelTone[i] = Data[i];  
           if(StrTelTone[i] != '-')
                   StrTelTone[i]&= 0x0F;  
                   
           if(!StrTelTone[i])StrTelTone[i] = 10;
      }                
      if(i){
              MaxTone = i;      
              indTone = 0;
              GoTel = 1;  
              DelayTone(2);
              ChangePul = 1;
              PORTD|= 0x04;    
              //PORTD|= 0x20;         
              tConected = 1;
              TimePausePul = 250;   
      }                      
}
void ToneDialer(void){
      // char qData = 0;
       if((GoTel == 1)&&(!TimePausePul))
       {    
            if(StrTelTone[indTone]=='-'){
                  TimePausePul = 250; 
                  StrTelTone[indTone] = 0;
            }else
            if(StrTelTone[indTone]){
                  PORTD^= 0x04;   
                  ChangePul^= 0x01;   
                  if(ChangePul){
                        StrTelTone[indTone]--;  
                        TimePausePul = 7;
                  }else
                        TimePausePul = 15;               
            }
            else{ 
                   indTone++;  
                   TimePausePul = 125;
                   if(indTone >=  MaxTone){   
                           GoTel = 2;  
                           DelayTone(5);    
                   }         
            }     
       }
       if((GoTel == 2)&&(!TimePauseTone)){               
               PORTD&= ~0x80;
               if(StatusY_N2 & TIME_LIS)
                        DelayTone(TIME_CONECT_2);   //55
               else     DelayTone(TIME_CONECT_1);   //55
               GoTel = 3; 
       }  
       if((GoTel == 3)&&(!TimePauseTone)){ 
               DisConectPuls();  
       }
       
} 
void DisConectPuls(void)      // Moked, Telephone  disconect
{         
     tConected = 0;    
     GoTel = 0;     
     PORTD&= ~0x04;      
     PORTD|= 0x80;    
     DelayTone(2);    
     //PORTD&= ~0x20;
}  

void DelayTone(char Time)
{                        
     SecondTone = 0;
     TimePauseTone = Time; // sec 
}

 