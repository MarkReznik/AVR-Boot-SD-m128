#include "Events.h"
#include "Define.h"     
#include "Time.h"     
unsigned char  ListEvent;       // max events
unsigned char ZoneEvent;    // if Type ARM or DIS code, else zone
unsigned char ChangeDisEvent;    
unsigned char EventLevel, FlagEventCycle;

void CaseEvent(char Type,char NumCode)
{    
    if((Type == EVENT_PANIC)||(Type == EVENT_OPEN)||
      (Type == EVENT_ALW)||(Type == EVENT_FIR)||(Type == BYP_ON))
           if(!(EventLevel & 0x01))return;     
    if((Type == EVENT_DIS)||(Type == STAY_1)||(Type == STAY_2)||
       (Type == AWAY_1)||(Type == AWAY_2)||(Type == EVENT_AMB))              
           if(!(EventLevel & 0x02))return;                   
    if((Type == BAT_OK)||(Type == BAT_NO)||(Type == AC_OK )||
       (Type == AC_NO) ||(Type == TEL_OK)||(Type == TEL_NO)||
       (Type == SIR_OK)||(Type == SIR_NO)) 
           if(!(EventLevel & 0x04))return;        
    if((Type == SIR_ON)||(Type == SIR_OFF)||(Type == EVENT_CLOSE))      
           if(!(EventLevel & 0x08))return;         
            
    Pointer = DisplayEvent;
    MaxNum = CMaxDisplayEvent;         
    if(ListEvent < 255) ListEvent++;     
    else{        
         ListEvent = 1;
         FlagEventCycle = 1;
    }
    Data[0] = Type;
    Data[1] = NumCode;     
    Data[2] = TimeHour;
    Data[3] = TimeMin;       
    Data[4] = Day;
    Data[5] = Month;     
       
    WriteData(ListEvent);
    
    //CountEventD = 0;
    //CountEventH = 0;
    //CountEventM = 0;
    
    WriteEvent();
}  
void Display_Event(char *str,char ch)
{
    char  Type, Zone, Hour, Min, Day, Month;
    Type = str[0];
    Zone = str[1];
    Hour = str[2];
    Min =  str[3];  
    Day =  str[4];
    Month = str[5];                         

    //if(Type == EVENT_ARM)   strcpyf(Data,"Arm Sy ");        
    if(Type == STAY_1)      strcpyf(Data,"Stay1  ");        
    if(Type == STAY_2)      strcpyf(Data,"Stay2  ");        
    if(Type == AWAY_1)      strcpyf(Data,"Away1  ");        
    if(Type == AWAY_2)      strcpyf(Data,"Away2  ");                      
    if(Type == EVENT_DIS)   strcpyf(Data,"Dis Sy ");
    if(Type == EVENT_PANIC) strcpyf(Data,"Pan    ");
    if(Type == EVENT_OPEN)  strcpyf(Data,"Opn Zn ");   
    if(Type == EVENT_CLOSE) strcpyf(Data,"Cls Zn ");    
    if(Type == SIR_ON)      strcpyf(Data,"S.ON   ");   
    if(Type == SIR_OFF)     strcpyf(Data,"S.OFF  ");
    if(Type == EVENT_FIR)   strcpyf(Data,"Fire   ");      
    if(Type == BAT_OK)      strcpyf(Data,"Bt.OK  ");   
    if(Type == BAT_NO)      strcpyf(Data,"Bt.NOK ");   
    if(Type == AC_OK)       strcpyf(Data,"Ac OK  ");   
    if(Type == AC_NO)       strcpyf(Data,"Ac NOK ");  
    if(Type == TEL_OK)      strcpyf(Data,"T.OK   ");   
    if(Type == TEL_NO)      strcpyf(Data,"T.NOK  ");     
    if(Type == EVENT_ALW)   strcpyf(Data,"Alw.Zn ");      
    if(Type == EVENT_AMB)   strcpyf(Data,"Ambush "); 
    if(Type == SIR_OK)      strcpyf(Data,"S.OK   ");      
    if(Type == SIR_NO)      strcpyf(Data,"S.NOK  ");
    if(Type == BYP_ON)      strcpyf(Data,"Bypass ");
    Data[7] = 0x30 + (Zone/10);
    Data[8] = 0x30 + (Zone%10);
    Data[9] = 0x20;  
    if(ch){         
         Data[10] = 0x30 + (Hour/10);
         Data[11] = 0x30 + (Hour%10);
         Data[12] = ':';
         Data[13] = 0x30 + (Min/10); 
         Data[14] = 0x30 + (Min%10);         
    }
    else{     
         Data[10] = 0x30 + (Day/10);
         Data[11] = 0x30 + (Day%10);
         Data[12] = '/';
         Data[13] = 0x30 + (Month/10); 
         Data[14] = 0x30 + (Month%10); 
    }
    Data[15] = 0;    
}
 
void WriteEvent(void)
{
    Pointer = StatusEvent;
    MaxNum = 16;     
    ReadData(1);
    Data[0] = ListEvent;    
    WriteData(1);
}
void ReadEvent(void)
{
    Pointer = StatusEvent;
    MaxNum = 16;
    ReadData(1);
    ListEvent  = Data[0];
} 