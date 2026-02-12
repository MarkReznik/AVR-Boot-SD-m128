#include <mega128.h>     
#include "Zones.h"   
#include "Define.h"  
unsigned char Zone[16];               // array for status of zones  
                   // 0x0001 - Open test
                   // 0x0002 - Open test
                   // 0x0004 - Chime/during arm active bypass/Restore
                   // 0x0008 - 24 Bifor Alm
                   // 0x0010 - History
                   // 0x0020 - Light
                   // 0x0040 - Bypass
                   // 0x0080 - Open
                   
unsigned char ZoneHelp[16];   
                   // 0x01 - status zone
                   // 0x02 - send to moked status of zone  
unsigned char bZoneType;       //if 1 Zone Always open 
unsigned char HalfZone; 
unsigned char ValueSenset, Senset;                   
                   
void ZoneOpen(void)
{  
   unsigned char Ready;
   unsigned char ind;
   ADCSRA = 0x86;               // enable AtoD
   ADMUX = 0x60; 
   
   for(ind = 0;ind<4;ind++)
   {           
           ADMUX&= ~0x07; 
           ADMUX|= (0x07 & ind); 
           #asm("nop");   
           ADCSRA|= 0x40;                // start AtoD           
           while(!(ADCSRA & 0x10));     
           Ready = ADCH;
           if((Senset | DataSenset[ind]) == 0x33){
                  if((Zone[ind] & 0x40)&&(DataType[ind]&0x0F))
                           Zone[ind]&= 0x74; 
                  if(Zone[ind] & 0x80)
                           Zone[ind]&= ~0x03;  
           }
           if(StatusY_N & DEOL)            // if DEOL     
           {    
               if((Senset | DataSenset[ind+4]) == 0x33){
                      if((Zone[ind+4] & 0x40)&&(DataType[ind+4]&0x0F))
                              Zone[ind+4]&= 0x74;          
          
                      if(Zone[ind+4] & 0x80)
                              Zone[ind+4]&= ~0x03;
               }
               if((Ready<0x50)||(Ready>0xB0))
               {     
                    if((Senset | DataSenset[ind]) == 0x33)               
                         Zone[ind] ++;                                     //  open 
                    if((Senset | DataSenset[ind+4]) == 0x33)           
                         Zone[ind+4] ++;                                    //  open
               }else
               if((Ready>0x50)&&(Ready<0x70))
               {     
                    if((Senset | DataSenset[ind]) == 0x33)                     // close     
                         Zone[ind]&= 0x7C;  
                    if((Senset | DataSenset[ind+4]) == 0x33)                                        
                         Zone[ind+4]&= 0x7C;                                   // close
               }else
               if((Ready>0x70)&&(Ready<0x90))
               {     
                     if((Senset | DataSenset[ind]) == 0x33)    
                            Zone[ind]&= 0x7C;                                       // close   
                     if((Senset | DataSenset[ind+4]) == 0x33)                   
                            Zone[ind+4]++;                                          // open
               }else
               if((Ready>0x90)&&(Ready<0xB0))
               {           
                     if((Senset | DataSenset[ind]) == 0x33)    
                            Zone[ind]++;                                            // open       
                     if((Senset | DataSenset[ind+4]) == 0x33)           
                            Zone[ind+4]&= 0x7C;                                      // close
               }
               TestChime(ind + 4);          
           }
           else
           if(StatusY_N & EOL){                   // if EOL      
                 if((Senset | DataSenset[ind]) == 0x33)        
                     if((Ready>0x52)&&(Ready<0xA2))            
                             Zone[ind]&= 0x7C;    
                     else
                             Zone[ind]++;  
           }
           else{     
                 if((Senset | DataSenset[ind]) == 0x33)    
                     if(Ready > 0x52)        
                           Zone[ind]++;
                     else
                           Zone[ind]&= 0x7C;    
           }          
           TestChime(ind);                        
        
   }        
   /*if(StatusY_N & DEOL)            // if DEOL     
         NumPIR = 11;
   else
         NumPIR = 4;       
   for(;NumPIR < 16;NumPIR++){ 
              if((Zone[NumPIR] & 0x40)&&(DataType[NumPIR]&0x0F))
                        Zone[NumPIR]&= 0x74;                    
                                      
              if(Zone[NumPIR] & 0x01){    
                        ClosePIR[NumPIR] = 10; 
                        Zone[NumPIR]|= 0x03;  
                        TestChime(NumPIR);   
                        Zone[NumPIR]&= ~0x03;       
              }                                                          
   }*/
   ADCSRA = 0;               // Disable AtoD
}
void TestChime(char ind)
{
     
     if(((Zone[ind]&0xC3) == 0x03)&&(DataType[ind]&0x0F))
     {
        
        if((DataType[ind]&0x0F) != 5)     // if not zone of key
        {
             if((Zone[ind]&0x20)&&(!ValueSiren))
             {             
                 ValueLight = ReturnTime(8); 
                 if(ValueLight){ 
                     ValueLight++;        
                     LightByte|= 0x01;                 
                     RelayOn(R_LIGHT);
                 }
             }
             if((Zone[ind]&0x04)&&(ButtonChime & 0x10))     // Chime call  
             {                      
                   RealTime[3]|= AllBords;                          
                   Beap = sCHIME;
                   if(StatusY_N & CHIME_SR)
                        StartChimeSiren(100);
             } 
             if(DataType[ind] == '6'){
                   DisplayLed(0x01,2);               
                   FlagFire = 1;                             
             }   
           
        } 
        if(DataType[ind] == 0x36){     
               DataMoked[pStopEvent][0] = EVENT_FIR; 
               DataMoked[pStopEvent][1] = ind+1;                                   
               pStopEvent++;
               if(pStopEvent >= MAX_EVENT)
                       pStopEvent = 0;      
               RelayOn(R_FIRE);                                                                     
        }                           
        Zone[ind]|= 0x80;             
        RelayOnZone(ind);
     }       
     if((Zone[ind]&0x03) == 0x03) Zone[ind]&= ~0x03; 
}
void EnterChameToZone(void)
{
    ClearBit(Zone,0x24);
    Pointer = ZoneSpacial;
    MaxNum = 16;
    ReadData(1);
    cpyBit(Zone,0x04,Data,0x01);  // chime
    cpyBit(Zone,0x20,Data,0x02);  // led           
}
void ReadZoneType(void)
{       
     char i;                  
     Pointer = ZoneType;
     MaxNum = 16;
     ReadData(1);
     for(i=0;i < 16;i++)
       DataType[i] = Data[i];
     DataType[i] = 0;                            
}      
void ReadZoneSenset(void)
{       
     char i;                  
     Pointer = ZoneSenset;
     MaxNum = 16;
     ReadData(1);
     for(i=0;i < 16;i++)
       DataSenset[i] = Data[i];
     DataSenset[i] = 0;                            
}
void EnterToStutA_S(void)
{
   char ind,Shift;
   char Value;
   Pointer = ZoneBhave;
   MaxNum = 16;
   ReadData(1);
   if(ButtonChime & 0x01)    //S1
       Shift = 2;
   else    
   if(ButtonChime & 0x02)   //S2
       Shift = 4;
   else    
   if(ButtonChime & 0x08)   // A2
       Shift = 1;
   else  
   if(ButtonChime & 0x04)   // A1
       Shift = 8; 
   else  return;       
   ClearBit(Zone,0x40);
   for(ind = 0;ind < 16;ind++){
      if(Data[ind] == 'A') Value = 0x0A;     
      else
      if(Data[ind] == 'B') Value = 0x0B;   
      else
      if(Data[ind] == 'C') Value = 0x0C;   
      else
      if(Data[ind] == 'D') Value = 0x0D;
      else
      if(Data[ind] == 'E') Value = 0x0E;      
      else
      if(Data[ind] == 'F') Value = 0x0F;    
      else  
      if((Data[ind]>= 0x30)&&(Data[ind] <= 0x39))
              Value = Data[ind]&0x0F;    
      else
              Value = 0;                         
      if((Value&Shift)||(ZoneHelp[ind]&0x40))
          Zone[ind]|= 0x40;  
   }
   /*if(TestBypass())
      DisplayLed(0x80,3);
   else
      DisplayLed(0x80,0);*/     
   WriteBypass();        
}
/*char TestBypass(void)
{
    char ind;
    char Return = 0;
    for(ind = 0;ind < 16;ind++)
    if(Zone[ind] & 0x40)
        Return = 1;
    return(Return);     
} */
void ToBypassZone(void)         //  to bypass zone if zone was activate
{
   char i;
   for(i = 0;i < 16;i++)
     if(Zone[i] & 0x10){
        Zone[i]|= 0x40; 
        Zone[i]&= 0x74;         
     }   
   /*if(TestBypass())
        DisplayLed(0x80,3); 
   else
        DisplayLed(0x80,0);      
   */     
}       
char TestWasActivate(void)
{          
    char ind;
    char Return = 0;
    for(ind = 0;ind < 16;ind++)
    if(Zone[ind] & 0x10)
        Return = 1;
    return(Return);   
}
char TestZonesType(void)
{  
     char ind = 0;
     char Find = 0; 
     char Level;
     char Res, ResH = 0;    
     Res = 0x80;        
     ResH = 0x04;
     FlagZoneReady = 0;             
     bZoneType = 0;
     while(ind < 16)
     {                
        Level = DataType[ind]&0x0F;     
        if(!(ZoneHelp[ind]&ResH)&&(Zone[ind]&Res)&& Level){                                
                            
              if(Level == 5)            // open zone of key
                  Find = ind + 1;   
              else{   
                      bZoneType|= GetBit(Level); 
                      if(StatusArm == 3){                      
                          if((Level == DELY)&&!ValueExit){ // if open door                               
                                if(ind < HalfZone)
                                     ValueExit = ReturnTime(2)+1;    // return enter time 
                                else
                                     ValueExit = ReturnTime(4)+1;    // return enter time                            
                                OpenDoor = 1;    
                                     
                          }else
                          if(Level == FLOW){                                 
                                if(!OpenDoor)
                                     StartAlarm = 1;
                          }
                          else{
                                StartAlarm = 1;
                          }  
                          ZoneHelp[ind]|= 0x84;     
                          Zone[ind]|= 0x08;                                                                             
                      }else
                      if(StatusArm == 2){     
                          if((Level >= 6)||((Level == 4)&&!(StatusY_N & AUTO_BYP))){
                                StatusArm = 3;       
                                ValueExit = 0;
                                //ClearBit(ZoneHelp,0x04); 
                                ind = 20;
                          }                                                                  
                          if((StatusY_N & SIMP_ARM)&&(Level == 1)&&(ButtonChime&0x03)){// St1 or Aw1 Auto                                                              
                                ButtonChime&= 0xF0;        // enter to status A1
                                ButtonChime|= 0x04;  
                                DisplayLed(0x30,0);
                                DisplayLed(0x20,3);                 
                                EnterToStutA_S(); 
                                ind = 20;
                          } 
                                        
                      }else
                      if(StatusArm < 2){      
                          if(Level >= 3) FlagZoneReady = 1;           
                          if(Level >= 6){   // open zone to display                          
                               if(!ValueExit)                                                                                                           
                                    ValueExit = 15;                                                                                                                                
                                   
                               DisplayZone = 0x08;     
                               Zone[ind]|= 0x08;     
                               OpenAlways = 1;      
                               SoundAlways = 1;   
                               ZoneHelp[ind]|= 0x04;
                               ZoneHelp[ind]|= 0x80;
                          }  
                      }                                             
                 } // else
        }  // if((Zone[ind] & 0x80)&&(Level)) 
        ind++;     
     } // while
     if((Find)&&(!OpenZoneKey))           
     {            
           OpenZoneKey = 1; 
           if((!StatusArm)&&(Status < 4))
                StartToArm();
           if(!Status)     
        Key_SA(Find);                                                                 
     } 
     if((!Find)&&(ind < 20))
          OpenZoneKey = 0;         
     return(bZoneType);
     
}
void ListZones(int StutLine1)   //  to list names of zones
{   
   unsigned char Count = 0;
   unsigned char BitHelp;
   unsigned char Find = 0;
 
   if(StutLine1 == pOpenZoneR){
        if(Status == 2)
           BitHelp = DisplayZone = 0x80;  
        else
           BitHelp = DisplayZone;  
   }
   if(StutLine1 == pBypassZoneR) BitHelp = 0x40;
   if(StutLine1 == pActivZoneR ) BitHelp = 0x10;
   
   while((!Find)&&(Count<=17))
   {
      if(List >= 16)
      {
           List = 0;
           CycleListZone = 1;    // second sycle of list zone
      }     
      if((Zone[List]&0x08)&&(!Status)){
            BitHelp = DisplayZone = 0x08;        
      }      
      if((Zone[List]&BitHelp)||(StutLine1 == pListZoneR))
         //if(((DataType[List]&0x0F)&&(DataType[List] != 0x35))||(Status == 2))    
         if((DataType[List]&0x0F)&&(DataType[List] != 0x35))
         { 
             Find = 1;                                                                                      
         }  
      Count++;
      List++;
       
   }
   if(!Find)
   {
       List = 0;  
       if(!StatusArm)                  // if zone DisplayZone was open
            ValueExit = 0;
       if(WasSiren)
           DisplayZone = 0x10;
       else    
           DisplayZone = 0x80; 
   }       
}    
char TestNotAlways(void)
{        
   char i;
   for(i = 0; i<MaxName;i++){
      if((Zone[i] & 0x80)&&(DataType[i] >= '6'))return(0);                              
   }  
   return(1);
}