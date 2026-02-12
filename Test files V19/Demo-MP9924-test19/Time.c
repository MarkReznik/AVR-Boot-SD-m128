#include "Time.h" 
#include "EEprom.h"  
#include "Define.h"  
unsigned char  TimeHour, TimeMin, TimeSec;   
unsigned char CounterTime, SaveTimeMin,SaveTimeHour,SaveDayWeek; 
unsigned char Year, Month, Day, DayWeek; 
unsigned char ChangeDate, ChangeTimeDate, ChangeDisTime; 
unsigned char PauseChTime, PauseTimeFlag;  
unsigned char EnteredTime;
void DisplayTime(char *str)
{
    if((!EnteredTime)&&(!ChangeDisTime)){  
        str[0] = ' ';    
        str[1] = ' ';
        str[2] = ' ';
        str[3] = ' ';
        str[4] = ' ';
        str[5] = 0; 
    }    
    else{   
        str[4] = (TimeHour/10) + 0x30;
        str[3] = (TimeHour%10) + 0x30; 
        if(ChangeDisTime)  
             str[2] = ':';
        else     
             str[2] = ' ';
        str[1] = (TimeMin/10) + 0x30;
        str[0] = (TimeMin%10) + 0x30;
        str[5] = 0;
    }  
}
void DisplayDate(char *str)
{             
     str[4] = (Day/10)+0x30;   
     str[3] = (Day%10)+0x30;   
     str[2] = '/';
     str[1] = (Month/10)+0x30;
     str[0] = (Month%10)+0x30;  
     str[5] = 0;
}     
void DisplaySecond(char *str)
{        
      str[4] = ' ';               
      str[3] = ' '; 
      str[2] = ':';               
      str[1] = (TimeSec/10) + 0x30;
      str[0] = (TimeSec%10) + 0x30;   
      str[5] = 0;
}     
void DisplayTimeDate(char *str)
{         
        ChangeDisTime = 1;   
        DisplayDayWeek(&str[0]);  
        str[1] = ' ';
        str[2] = (Year%10)+0x30;  
        str[3] = (Year/10)+0x30;
        str[4] = '/';
        DisplayDate(&str[5]);   
        str[10] = ' ';    
        DisplayTime(&str[11]);                                                          
        str[16] = 0;
}        
void DisplayDayWeek(char *str)
{    
      if(DayWeek == 1){
          str[0] = 'à';
      }  
      if(DayWeek == 2){
          str[0] = 'á';
      }
      if(DayWeek == 3){
          str[0] = 'â';
      }
      if(DayWeek == 4){
          str[0] = 'ã';
      }
      if(DayWeek == 5){
          str[0] = 'ä';
      }
      if(DayWeek == 6){
          str[0] = 'å';
      }
      if(DayWeek == 7){
          str[0] = 'æ';
      }     
      str[1] = 0;
}
char EnterDateTime(char Button,char NextCode)
{               
       if(Button == ZERO)Button = 0; 
       if(NextCode == 16){
               if(Button < 3){
                       Data[NextCode-1] = Button + 0x30;
                       NextCode--;
               }
       }else
       if(NextCode == 15){
               if((Button < 4)||((Button <= 9)&&(Data[NextCode] < 0x32))){
                       Data[NextCode-1] = Button + 0x30;   
                       NextCode--;
               }                       
       }else     
       if(NextCode == 13){
               if(Button < 6){
                       Data[NextCode-1] = Button + 0x30;
                       NextCode--;
               }
       }else
       if(NextCode == 12){
               if(Button <= 9){
                       Data[NextCode-1] = Button + 0x30;   
                       NextCode--;
               }                       
       }else
       if(NextCode == 10){
               if(Button < 4){
                       Data[NextCode-1] = Button + 0x30;
                       NextCode--;
               }
       }else
       if(NextCode == 9){
               if((Button < 2)||((Button <= 9)&&(Data[NextCode] < 0x33))){
                       Data[NextCode-1] = Button + 0x30;   
                       NextCode--;
               }                       
       }else
       if(NextCode == 7){
               if(Button < 2){
                       Data[NextCode-1] = Button + 0x30;
                       NextCode--;
               }
       }else
       if(NextCode == 6){
               if((Button < 3)||((Button <= 9)&&(Data[NextCode] < 0x31))){
                       Data[NextCode-1] = Button + 0x30;   
                       NextCode--;
               }                       
       }else
       if(NextCode == 4){
               if(Button <= 9){
                       Data[NextCode-1] = Button + 0x30;
                       NextCode--;
               }
       }else
       if(NextCode == 3){
               if(Button <= 9){
                       Data[NextCode-1] = Button + 0x30;   
                       NextCode--;
               }                       
       }else
       if(NextCode == 1){ 
             if((Button > 0)&&(Button < 8)){
                  DayWeek = Button;
                  DisplayDayWeek(&Data[0]);   
                  NextCode--;
             }   
             if(Button == NEXT){
                  DayWeek++;   
                  if(DayWeek > 7)
                      DayWeek = 1;
                  DisplayDayWeek(&Data[0]);   
                  
             }else                
             if(Button == BACK){
                  DayWeek--;   
                  if(DayWeek < 1)
                      DayWeek = 7;
                  DisplayDayWeek(&Data[0]);      
             }     
             Data[1] = ' '; 
       }
       if((NextCode == 14)||(NextCode == 11)||(NextCode == 8)||
          (NextCode == 5)||(NextCode == 2)) 
                       NextCode--; 
                     
       if(NextCode < 1)
             NextCode = 16;  
       return(NextCode);      
}  
void Data_Change(void)
{       
     Day++;     
     DayWeek++;
     if(DayWeek >= 8)
         DayWeek = 1; 
     if((Month == 1)||(Month == 3)||(Month == 5)||(Month == 7)
        ||(Month == 8)||(Month == 10)||(Month == 12))
     {
           if(Day >= 32)
               Day = 1;  
     } 
     else
     if(Month == 2){
           if(Year%4){
                if(Day >= 29)
                    Day = 1;
           }
           else
                if(Day >= 30)
                    Day = 1;         
     }
     else
           if(Day >= 31)
               Day = 1;    
     if(Day == 1)
          Month++;
     if(Month >= 13)
          Month = 1;
     if(Month == 1)
          Year++;           
     Write_Date();                //write date to eeprom                      
}
void Write_Date(void)
{        
     Pointer = TimeDate;
     MaxNum = CMaxTimeDate;
     Data[0] = Day;
     Data[1] = Month;
     Data[2] = Year;  
     Data[3] = DayWeek;   
     WriteData(1);  
} 
void Read_Date(void)
{        
     Pointer = TimeDate;      
     MaxNum = CMaxTimeDate;   
     ReadData(1);  
     Day = Data[0];
     Month = Data[1];
     Year = Data[2];   
     DayWeek = Data[3];       
}   
void ToZeroTime(void)
{        
     Pointer = TimeDate;      
     MaxNum = CMaxTimeDate;   
     ReadData(1);     
     Data[4] = Data[5] = 0;  
     WriteData(1);  
}
void Read_Time(void)
{        
     Pointer = TimeDate;      
     MaxNum = CMaxTimeDate;   
     ReadData(1);  
     TimeHour = Data[4];
     TimeMin  = Data[5];      
}