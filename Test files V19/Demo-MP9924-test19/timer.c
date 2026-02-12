#include "Timer.h"
#include "Define.h"   
char StatusTimer[CMaxTimer][MaxTimer];
void DisplayTimer(char num)
{    
     char i;
     char Day, Hour, Min, Arm; 
     num--;
     Day  = StatusTimer[0][num];
     Hour = StatusTimer[1][num];
     Min  = StatusTimer[2][num];
     Arm  = StatusTimer[3][num];
     for(i = 15;i > 8; i--){
          if(Day & (0x01<<(15-i)))
              Data[i] = 0x31 + (15-i);
          else
              Data[i] = '*';    
     }                     
     Data[8] = ' ';
     Data[7]  = 0x30 + (Hour/10);
     Data[6]  = 0x30 + (Hour%10);   
     Data[5] = ':';
     Data[4] = 0x30 + (Min/10);
     Data[3] = 0x30 + (Min%10);
     Data[2] = ' '; 
     if(List < MaxTimer-1){
        if((Arm == 1)||(Arm == 2)){
             Data[1] = 'S';
             Data[0] = 0x30 + Arm; 
        }
        if((Arm == 3)||(Arm == 4)){
             Data[1] = 'A';
             Data[0] = 0x2E + Arm; 
        }
        if(Arm == 5){   
             Data[1] = 'D';
             Data[0] = '*'; 
        }
        if(!Arm){
             Data[1] = '*';
             Data[0] = '*'; 
        }
     }
     else{    
             Data[1] = 'O';  
             if(List == (MaxTimer-1)) Data[0] = 'n';  // on             
             if(List == MaxTimer) Data[0] = 'f';  // off
     } 
     Data[16] = 0;   
}     
char EnterTimer(char Button, char NextCode)      // change timer
{                             
       NextCode--;    
       if(Button == ZERO)Button = 0; 
       if((NextCode <= 15)&&(NextCode >= 9)&&(Button == ALT)){
              if(Data[NextCode] == '*')
                      Data[NextCode] = 0x31 + 15 - NextCode;
              else
                      Data[NextCode] = '*'; 
              NextCode--;                  
       }else
       if(NextCode == 7){
               if(Button < 3){
                       Data[NextCode] = Button + 0x30;
                       NextCode--;
               }
       }else
       if(NextCode == 6){
               if((Button < 4)||((Button <= 9)&&(Data[NextCode+1] < 0x32))){
                       Data[NextCode] = Button + 0x30;   
                       NextCode--;
               }                       
       }else     
       if(NextCode == 4){
               if(Button < 6){
                       Data[NextCode] = Button + 0x30;
                       NextCode--;
               }
       }else
       if(NextCode == 3){
               if(Button <= 9){
                       Data[NextCode] = Button + 0x30;   
                       NextCode--;
                       if(List >= MaxTimer-1) NextCode = 15; 
               }                       
       }else
       if(NextCode == 1){           
               if(Button == STAY){
                       Data[NextCode] = 'S';
                       NextCode--;
               }else
               if(Button == AWAY){
                       Data[NextCode] = 'A';
                       NextCode--;
               }else
               if(Button == ALT){
                       Data[NextCode] = 'D';
                       NextCode--;
               }                       
       }else
       if(NextCode == 0){    
               if((Button == 1)||(Button == 2)){
                       Data[NextCode] = Button + 0x30;   
                       NextCode = 15;
               }                           
       }      
       if((NextCode == 8)||(NextCode == 5)||(NextCode == 2)) 
                       NextCode--;  
   
       return(NextCode + 1);  
       
}  
 
void Write_Timer(char num)
{                   
     char i;
     char Day, Hour, Min, Arm; 
     num--;        
     Day = 0;
     Pointer = Timer;
     MaxNum = CMaxTimer;
     for(i = 15;i > 8;i--)
        if(Data[i] != '*')
             Day|= (0x01<<(15-i));  
     Hour = (Data[7]-0x30)*10 + (Data[6]-0x30);  
     Min =  (Data[4]-0x30)*10 + (Data[3]-0x30); 
     if(Data[1] == 'S'){
           Arm = Data[0]-0x30;    
           if((Arm != 1)&&(Arm != 2)) 
                Arm = 0;      
     }else
     if(Data[1] == 'A'){   
           Arm = Data[0]-0x30; 
           if((Arm == 1)||(Arm == 2)) 
                Arm+= 2;
           else
                Arm = 0;     
     }else          
     if(Data[1] == 'D'){  
           Arm = 5;          
     }else
           Arm = 0;       
     Data[0] = StatusTimer[0][num] = Day;
     Data[1] = StatusTimer[1][num] = Hour;
     Data[2] = StatusTimer[2][num] = Min;
     Data[3] = StatusTimer[3][num] = Arm;
     WriteData(num+1);  
} 
void Read_Timer(void)
{      
     char i; 
     Pointer = Timer;
     MaxNum = CMaxTimer;  
     for(i = 0;i<MaxTimer;i++){
         ReadData(i+1);        
         StatusTimer[0][i] = Data[0];
         StatusTimer[1][i] = Data[1];
         StatusTimer[2][i] = Data[2];
         StatusTimer[3][i] = Data[3];     
     }    
} 
void TestTimer(char Week,char Hour, char Min)
{      
     char i;
     char pWeek, pHour, pMin, pArm = 0; 
     Week = 0x01<<(Week - 1);             
          
     for(i = 0; i<MaxTimer; i++){
           pWeek = StatusTimer[0][i];
           pHour = StatusTimer[1][i];
           pMin  = StatusTimer[2][i];
           if((pWeek & Week)&&(pHour == Hour)&&(pMin == Min)){
                if(i == (MaxTimer-2)){
                          Timer_Test(6);  // on
                }else
                if(i == (MaxTimer-1)){
                          Timer_Test(7);  // off
                }
                else{
                   pArm  = StatusTimer[3][i];                    
                }
           }    
     }    
     if(pArm) Timer_Test(pArm);              
}
void Timer_Test(char TimerArm)                                           
{                    
              if(TimerArm == 1){ 
                       if(ButtonChime & 0x0E){     // over to S1
                                   Key_SA(0);                             
                                   TimeEntToArm = 0;
                                   DisplayLed(0x08,0);  
                                   StatusVolt = StatusVolt &~0x0f; 
                                   AutoArm = 1;
                                   Key_SA(6);                                                                                                               
                       }else
                       if(!(ButtonChime & 0x0F)){   // On to S1 
                                    StartToArm();
                                    //iCounter4 = 0;   
                                    TimeEntToArm = 0;
                                    DisplayLed(0x08,0);  
                                    StatusVolt = StatusVolt &~0x0f; 
                                    AutoArm = 1;                                              
                                    Key_SA(20); 
                       }
              }
              if(TimerArm == 2){ 
                       if(ButtonChime & 0x0D){     // over to S2 
                                     Key_SA(0);  
                                     //iCounter4 = 0; 
                                     TimeEntToArm = 0;
                                     DisplayLed(0x08,0);  
                                     StatusVolt = StatusVolt &~0x0f;  
                                     AutoArm = 1;
                                     Key_SA(20);  
                                     ButtonChime^= 0x03;
                                     EnterToStutA_S();              
                       }else
                       if(!(ButtonChime & 0x0F)){   // On to S2     
                                     StartToArm();
                                    // iCounter4 = 0; 
                                     TimeEntToArm = 0;
                                     DisplayLed(0x08,0);  
                                     StatusVolt = StatusVolt &~0x0f; 
                                     AutoArm = 1;
                                     Key_SA(20); 
                                     ButtonChime^= 0x03;
                                     EnterToStutA_S();  
                       }
              }    
              if(TimerArm == 3){ 
                       if(ButtonChime & 0x0B){     // over to A1    
                                      Key_SA(0);  
                                      //iCounter4 = 0; 
                                      TimeEntToArm = 0;
                                      DisplayLed(0x08,0);  
                                      StatusVolt = StatusVolt &~0x0f;  
                                      AutoArm = 1;
                                      Key_SA(30);                                                   
                       }else
                       if(!(ButtonChime & 0x0F)){   // On to A1    
                                      StartToArm();
                                      //iCounter4 = 0; 
                                      TimeEntToArm = 0;
                                      DisplayLed(0x08,0);  
                                      StatusVolt = StatusVolt &~0x0f;    
                                      AutoArm = 1;
                                      Key_SA(30);                                                       
                       }
              }
              if(TimerArm == 4){  
                       if(ButtonChime & 0x07){     // over to A2  
                                       Key_SA(0);   
                                       //iCounter4 = 0; 
                                       TimeEntToArm = 0;
                                       DisplayLed(0x08,0);  
                                       StatusVolt = StatusVolt &~0x0f;  
                                       AutoArm = 1;
                                       Key_SA(30);  
                                       ButtonChime^= 0x0C;
                                       EnterToStutA_S();   
                       }else
                       if(!(ButtonChime & 0x0F)){   // On to A2  
                                       StartToArm();
                                       //iCounter4 = 0; 
                                       TimeEntToArm = 0;
                                       DisplayLed(0x08,0);  
                                       StatusVolt = StatusVolt &~0x0f; 
                                       AutoArm = 1;
                                       Key_SA(30);  
                                       ButtonChime^= 0x0C;
                                       EnterToStutA_S(); 
                       } 
              }
              if(TimerArm == 5){ 
                       if(ButtonChime & 0x0F){
                                       Key_SA(0);            // off
                       }
                                        
              } 
              if(TimerArm == 6){ 
                       RelayOn(R_TIMER);
                                        
              }  
              if(TimerArm == 7){ 
                       RelayOff(R_TIMER);                                        
              }      
}