#include "TableMoked.h"   
#include "Define.h"  

char TableOfEvents(char* str)
{                                
      char Return = 0;    
      char i, ind = 0;   
      char TypeCH, Digit, Type;
      char AllData = 1, FlagData = 0;
      int lPointer;
      char lMaxNum;  
      unsigned char sData[17];    
      
      lPointer = Pointer;
      lMaxNum = MaxNum;
      strcpy(sData,Data);
                            
      IndexSM = 0;
      Pointer = TranslateMoked;
      MaxNum = CMaxTranslateMoked;               
       
      ReadData(8);  
      
      TypeCH = Data[7]&0x0f;
      
      Digit = Data[6]&0x0f;
      
      if(Data[0] == '4') AllData = 6;    
      if((Data[0] == '4')||(Data[0] == '3')) Type = '7'; 
      else  Type = Data[0];          
        
      str[ind++] = '!';  
      if(tx_buffer1[0] != '!'){                  
            str[ind++] = Type;  
      }      
      i = ind; 
      
      ReadData(1);                           
      
      str[ind++] = Data[0];          
      str[ind++] = Data[1];
      str[ind++] = Data[2];
      if((Data[3]>='0')&&(Data[3]<='9'))
                 str[ind++] = Data[3];   
  
      switch(Type)
      {           
          case '1':                
              str[ind++] = '1';
              str[ind++] = '8';                  
              while(!(Return = TableOfEvents_1(&str[ind])));  
              ind+=9;
              str[ind] = Checsam_CS(&str[i],ind-i);                                                  
              ind++;               
              MaxTryMoked = 2;      
              if(Return == 1){
                     FlagData = 1;     
                     IndexSM++;
              }       
          break;
          case '2':
          break;   
          case '7':            

              while(AllData && (Return != 2)){      
                   AllData--;             
                   while(!(Return = TableOfEvents_7(&str[ind])));                                                                          
                   if(Return == 1){
                           FlagData = 1;  
                           if(Digit == 1) str[ind] = str[ind+1];
                           ind+= Digit;  
                           IndexSM++;
                   }        
                   
              }                   
              if(TypeCH == 1){  //  checsam   
                   MaxTryMoked = 2;
                   str[ind] = Checsam_CS(&str[i],ind-i);
                   ind++;                             
              }else
              if(TypeCH == 2){    // repeat    
                   MaxTryMoked = 5;                                          
              }                         
          break;              
      }    
      Pointer = lPointer;
      MaxNum = lMaxNum;
      strcpy(sData,Data);
      
      if(FlagData){                                
            return(ind);
      }          
      else return(0);
}       
char Checsam_CS(char*str,char ind)
{          
     char i;
     char CH = 0;
     for(i = 0;i<ind;i++)
       if(str[i] == '0')
           CH+= 10;
       else 
           CH+= (str[i]&0x0f);
     CH = CH%15;              
     CH = 15 - CH;  
          
     if(CH >= 10) CH+= 0x37;
     else         CH+= 0x30;
     
     return(CH);   
}   
char Checsam_RP(char*str,char ind)
{          
     return(1);
}  
char Checsam_RD(char*str,char ind)
{          
     return(1);
}

char TableOfEvents_7(char* str)
{                               
      char Help1, Help2;
      char Type, num;   
      char ind = 0;    
      char pM;
      str[0] = str[1] = 0;
      
      if(CountMoked == 3)         
           pM = pStartMoked_S + IndexSM;               
      else       
           pM = pStartMoked + IndexSM;                 
      if(pM >= MAX_EVENT) pM-= MAX_EVENT;          
      if(pM == pStopEvent) return(2);            
      Type = DataMoked[pM][0];    
      num = DataMoked[pM][1]; 
      if(num) num--;  
           
      Pointer = TranslateMoked;
      MaxNum = CMaxTranslateMoked;                   
      
      switch(Type)
      {         
         case STAY_1:
         case STAY_2:
         case AWAY_1:
         case AWAY_2:       // sys. arm                
              if(num < 8){
                       ReadData(4);
              }         
              else{          
                       num-= 8;
                       ReadData(5);                            
              }         
              str[ind++] = Data[num*2];  
              str[ind++] = Data[(num*2)+1];               
         break;                    
         case EVENT_DIS:        // sys. disarm    
              ReadData(6);       
              Help1 = Data[14];
              Help2 = Data[15];
              if((Help1>'0')||(Help2 > '0')){                                                
                     if(num < 8){
                                ReadData(4);
                     }         
                     else{          
                                num-= 8;
                                ReadData(5);                                      
                     }  
                     if((Data[(num*2)+1] > '0')||(Data[num] > '0')){
                          str[ind++] = Help1;
                          str[ind++] = Data[(num*2)+1];    
                     }                   
              }             
         break;     
         case EVENT_PANIC:        // panic
              ReadData(5);  
              str[ind++] = Data[8];  
              str[ind++] = Data[9];   
         break; 
         case EVENT_OPEN:        // open zone    
         case EVENT_ALW:        // always open
              if(num < 8){
                       ReadData(2);
              }         
              else{          
                       num-= 8;
                       ReadData(3);                            
              }         
              str[ind++] = Data[num*2];  
              str[ind++] = Data[(num*2)+1];
         break; 
         case EVENT_CLOSE:        // close zone    
              ReadData(6);       
              Help1 = Data[12];
              Help2 = Data[13];
              if((Help1>'0')||(Help2 > '0')){                                                
                     if(num < 8){
                           ReadData(2);
                     }         
                     else{          
                           num-= 8;
                           ReadData(3);                                      
                     }                         
                     if((Data[(num*2)+1] > '0')||(Data[num] > '0')){
                          str[ind++] = Help1;
                          str[ind++] = Data[(num*2)+1];    
                     }                 
              }        
         break;  
         case SIR_ON:  
              ReadData(6);  
              str[ind++] = Data[8];  
              str[ind++] = Data[9];    
         break;
         case SIR_OFF:                  
              ReadData(6);  
              str[ind++] = Data[10];  
              str[ind++] = Data[11];    
         break;
         case EVENT_FIR:        // fire    
              ReadData(6);  
              str[ind++] = Data[12];  
              str[ind++] = Data[13];        
         break;   
         case BAT_OK:        // bat. ok 
              ReadData(6);  
              str[ind++] = Data[4];  
              str[ind++] = Data[5];     
         break; 
         case BAT_NO:        // bat. not ok    
              ReadData(6);  
              str[ind++] = Data[6];  
              str[ind++] = Data[7];    
         break; 
         case AC_OK:        // ac ok   
              ReadData(6);  
              str[ind++] = Data[0];  
              str[ind++] = Data[1];      
         break; 
         case AC_NO:        // ac not ok   
              ReadData(6);  
              str[ind++] = Data[2];  
              str[ind++] = Data[3];    
         break;  
         case SIR_OK:        // ac ok   
              ReadData(7);  
              str[ind++] = Data[0];  
              str[ind++] = Data[1];      
         break; 
         case SIR_NO:        // ac not ok   
              ReadData(7);  
              str[ind++] = Data[2];  
              str[ind++] = Data[3];    
         break;                       
         case EVENT_AMB:        // ambush code 
              ReadData(5);  
              str[ind++] = Data[14];  
              str[ind++] = Data[15];  
         break; 
         case BYP_ON:    
              ReadData(7);
              if((Data[4] > '0')||(Data[5] > '0')){
                     str[ind++] = Data[4];  
                     str[ind++] = Data[5];    
              }
              else{   
                   Help1 = Data[6];
                   Help2 = Data[7];
                   if((Help1>'0')||(Help2 > '0')){                                                
                        if(num < 8){
                              ReadData(2);
                        }         
                        else{          
                              num-= 8;
                              ReadData(3);                                      
                        }                         
                        if((Data[(num*2)+1] > '0')||(Data[num] > '0')){
                              str[ind++] = Help1;
                              str[ind++] = Data[(num*2)+1];    
                        } 
                   }                
              }        
                     
         break;                 
      }    
            
      if((str[0] > '0')||(str[1] > '0')){           
          return(1);
      }
      else{  
          IndexSM++;                                          
          return(0);     
      }     
}
char TableOfEvents_1(char* str)
{                               
      char Help1, Help2;
      char Type, num;   
      char ind = 0;
      
      if(CountMoked == 3) {           
           if(pStartMoked_S == pStopEvent) return(2);     
                
           Type = DataMoked[pStartMoked_S][0];    
           num = DataMoked[pStartMoked_S][1]; 
           if(num) num--;   
      }
      else{                      
           if(pStartMoked == pStopEvent) return(2); 
           
           Type = DataMoked[pStartMoked][0];    
           num = DataMoked[pStartMoked][1]; 
           if(num) num--; 
      }     
            
      Pointer = TranslateMoked;
      MaxNum = CMaxTranslateMoked;                   
      
      switch(Type)
      {     
         case STAY_1:
         case STAY_2:
         case AWAY_1:
         case AWAY_2:       // sys. arm                 
              if(num < 8){
                       ReadData(4);   
                       Help1 = Data[num*2];
                       Help2 = Data[(num*2)+1];
              }         
              else{          
                       num-= 8;
                       ReadData(5);
                       Help1 = Data[num*2];
                       Help2 = Data[(num*2)+1];
                       num+=8;                         
              }         
              if((Help1 >'0')||(Help2 >'0')){
                   strcpyf(str,"140100");     
                   ind = 6;        
                   num++;
                   str[ind++] = 0x30 + num/100;  
                   num%= 100;  
                   str[ind++] = 0x30 + num/10;   
                   str[ind++] = 0x30 + num%10;                    
              }                
         break;                    
         case EVENT_DIS:        // sys. disarm    
              ReadData(6);       
              Help1 = Data[14];
              Help2 = Data[15];
              if((Help1>'0')||(Help2 > '0')){                                                
                     if(num < 8){
                          ReadData(4);   
                          Help1 = Data[num*2];
                          Help2 = Data[(num*2)+1];
                     }         
                     else{          
                          num-= 8;
                          ReadData(5);
                          Help1 = Data[num*2];
                          Help2 = Data[(num*2)+1];
                          num+=8;                         
                     }         
                     if((Help1 >'0')||(Help2 >'0')){
                          strcpyf(str,"340100");     
                          ind = 6;    
                          num++;
                          str[ind++] = 0x30 + num/100;   
                          num%= 100; 
                          str[ind++] = 0x30 + num/10;   
                          str[ind++] = 0x30 + num%10;                    
                    }                              
              }             
         break;     
         case EVENT_PANIC:        // panic
              ReadData(5);  
              if((Data[8] >'0')||(Data[9] >'0')){
                    strcpyf(str,"112000000");  
                    ind = 9;   
              }
         break; 
         case EVENT_OPEN:        // open zone    
         case EVENT_ALW:        // always open
              if(num < 8){
                       ReadData(2);   
                       Help1 = Data[num*2];
                       Help2 = Data[(num*2)+1];
              }         
              else{          
                       num-= 8;
                       ReadData(3);
                       Help1 = Data[num*2];
                       Help2 = Data[(num*2)+1];
                       num+=8;                         
              }         
              if((Help1 >'0')||(Help2 >'0')){
                   strcpyf(str,"113100");     
                   ind = 6;        
                   num++;
                   str[ind++] = 0x30 + num/100;    
                   num%= 100; 
                   str[ind++] = 0x30 + num/10;   
                   str[ind++] = 0x30 + num%10;                    
              }    
         break; 
         case EVENT_CLOSE:        // close zone    
              ReadData(6);       
              Help1 = Data[12];
              Help2 = Data[13];
              if((Help1>'0')||(Help2 > '0')){                                                
                     if(num < 8){
                          ReadData(2);   
                          Help1 = Data[num*2];
                          Help2 = Data[(num*2)+1];
                     }         
                     else{          
                          num-= 8;
                          ReadData(3);
                          Help1 = Data[num*2];
                          Help2 = Data[(num*2)+1];
                          num+=8;                         
                     }         
                     if((Help1 >'0')||(Help2 >'0')){
                          strcpyf(str,"313100");     
                          ind = 6;      
                          num++;
                          str[ind++] = 0x30 + num/100;   
                          num%= 100; 
                          str[ind++] = 0x30 + num/10;   
                          str[ind++] = 0x30 + num%10;                    
                    }                 
              }        
         break;  
         case SIR_ON:  
              ReadData(6);  
              if((Data[10] >'0')||(Data[11] >'0')){
                    strcpyf(str,"112200000");  
                    ind = 9;   
              }  
         break;
         case SIR_OFF:                  
              ReadData(6);  
              if((Data[8] >'0')||(Data[9] >'0')){
                    strcpyf(str,"313100000");  
                    ind = 9;   
              }     
         break;
         case EVENT_FIR:        // fire    
              ReadData(5);  
              if((Data[12] >'0')||(Data[13] >'0')){
                    strcpyf(str,"112000000");  
                    ind = 9;   
              }        
         break;   
         case BAT_OK:        // bat. ok 
              ReadData(6);  
              if((Data[4] >'0')||(Data[5] >'0')){
                    strcpyf(str,"330900000");  
                    ind = 9;   
              }        
         break; 
         case BAT_NO:        // bat. not ok    
              ReadData(6);  
              if((Data[6] >'0')||(Data[7] >'0')){
                    strcpyf(str,"130900000");  
                    ind = 9;   
              }           
         break; 
         case AC_OK:        // ac ok   
              ReadData(6);  
              if((Data[0] >'0')||(Data[1] >'0')){
                    strcpyf(str,"330100000");  
                    ind = 9;   
              }            
         break; 
         case AC_NO:        // ac not ok   
              ReadData(6);  
              if((Data[2] >'0')||(Data[3] >'0')){
                    strcpyf(str,"130100000");  
                    ind = 9;   
              }         
         break;        
         case SIR_OK:        // ac ok   
              ReadData(7);  
              if((Data[0] >'0')||(Data[1] >'0')){
                    strcpyf(str,"332100000");  
                    ind = 9;   
              }            
         break; 
         case SIR_NO:        // ac not ok   
              ReadData(7);  
              if((Data[2] >'0')||(Data[3] >'0')){
                    strcpyf(str,"132100000");  
                    ind = 9;   
              }         
         break;                       
         case EVENT_AMB:        // ambush code 
              ReadData(5);  
              if((Data[14] >'0')||(Data[15] >'0')){
                    strcpyf(str,"112200000");  
                    ind = 9;   
              }  
         break; 
         case BYP_ON:
              ReadData(7);  
              if((Data[4] >'0')||(Data[5] >'0')){
                    strcpyf(str,"157400000");  
                    ind = 9;   
              }
              else{   
                   Help1 = Data[6];
                   Help2 = Data[7];
                   if((Help1>'0')||(Help2 > '0')){                                                
                        if(num < 8){
                             ReadData(2);   
                             Help1 = Data[num*2];
                             Help2 = Data[(num*2)+1];
                        }         
                        else{          
                             num-= 8;
                             ReadData(3);
                             Help1 = Data[num*2];
                             Help2 = Data[(num*2)+1];
                             num+=8;                         
                        }           
                        if((Help1 >'0')||(Help2 >'0')){
                             strcpyf(str,"157300");     
                             ind = 6;      
                             num++;
                             str[ind++] = 0x30 + num/100;   
                             num%= 100; 
                             str[ind++] = 0x30 + num/10;   
                             str[ind++] = 0x30 + num%10;                    
                        }     
                   }    
              }
         break;                
      }    
            
      if(ind == 9){           
          return(1);
      }
      else{
          if(CountMoked == 3){     
               pStartMoked_S++;
               if(pStartMoked_S >= MAX_EVENT)
                    pStartMoked_S = 0;   
          }
          else{
               pStartMoked++;
               if(pStartMoked >= MAX_EVENT)
                    pStartMoked = 0;              
          }
          return(0);   
      }     
}