
#include <string.h> // hp
#include "elegant.h" // hp
#include "strings.h" // hp
#include "iso_modem.h"

#include "Define.h"
#include "Time.h"
char FlagTech , FlagTranslate;
unsigned int CounterTranslate;
unsigned char NormalTec,Floor;
void String(unsigned int NumOfStr,char* str)
{
 // unsigned char Azer[2];
  unsigned char size;
  fourline=0;
 
  if(!Status){
      if((int)NumOfStr == 0){
           if ((FlagOpenDoor)||(FlagOpenDoor2)){
                if (EnglishMode){
                     strcpyf(str,"The latch      ");
                     if(FlagOpenDoor2) strcpyf(str,"The latch 2    ");
                     if((FlagOpenDoor2)&&(FlagOpenDoor)) strcpyf(str,"The latch 1&2  ");
                }
                else {
                     strcpyf(str,"  פתח את הדלת   ");
                     if(FlagOpenDoor2) strcpyf(str,"  פתח את הדלת 2 ");
                     if((FlagOpenDoor2)&&(FlagOpenDoor)) strcpyf(str,"  פתח את הדלתות ");
                }
           }
           else if ((FlagWait)||(FlagWait2)){
                if (EnglishMode)strcpyf(str,"   Wait till    ");
                else strcpyf(str," המתן לסיום...  ");
          }else if ((TimeConectedWithApp)&&(!CounterRing)){ 
              if (EnglishMode){
                      strcpyf(str,"Busy/ NO Answer");//FIX6 
                      if (AnsMD_timeOut)strcpyf(str,"ModemConnection");//No Keypad during modem connection
               }else { 
                      strcpyf(str," בתפוס אין מענה ");//FIX6
                      if (AnsMD_timeOut)strcpyf(str,   " בהתקשרות מודם ");//No Keypad during modem connection      
               }               
          }else {
                if (EnglishMode){
                    //strcpyf(str,"  Use arrows  ");  
                     strcpyf(str,"Use arrows    ");//FIX6 
                     if (AddedType>=4)strcpyf(str," HELO...   to  ");//FIX6    
                     //str[11] = 0x01;
                    // str[12] = 0x02;
                    // str[14] = 0x04;
                }
                else {
                    // strcpyf(str," השתמש בחיצים ");   
                     strcpyf(str," דפדף בחיצים    ");              //FIX6 
                     if (AddedType>=4)strcpyf(str,"      שלום      ");//FIX6    
                   //  str[9] = 0x01;
                   //  str[11] = 0x02;
                   //  str[14] = 0x04;
                }
//                if (Dsp_Connect_T) strcpyf(str,"                ");////Speech time
           }

      }
      if((int)NumOfStr == 1){
            if ((FlagOpenDoor)||(FlagOpenDoor2)){
                if (EnglishMode)strcpyf(str,"    Is unlocked ");
                else strcpyf(str,"                ");
           }
           else if ((FlagWait)||(FlagWait2)){
                if (EnglishMode)strcpyf(str,"  End of delay  ");
                else strcpyf(str,"        ההשהיה  ");
           }else if ((TimeConectedWithApp)&&(!CounterRing)){
               if (Dsp_Connect_T)fourline=1; //Speech time 
               if (EnglishMode){
                      strcpyf(str,"Hang by using * ");//FIX6
                      if (AnsMD_timeOut)strcpyf(str,"Do Not Touch!!!");//No Keypad during modem connection
               }else { 
                      strcpyf(str," נתק בכוכבית )*(");//FIX6   
                      if (AnsMD_timeOut)strcpyf(str," נא לא לגעת !!! ");//No Keypad during modem connection      
               } 
          }
           else {
                if (!(YesNoAnswer&0x1)){
                     if (EnglishMode)strcpyf(str,"to search name.");
                     else strcpyf(str," לאיתור הדייר/ת");
                     if (AddedType>=4){
                             if (EnglishMode)strcpyf(str,"to connect App");
                             else strcpyf(str," להתקשרות לדירה ");
                     }    
                }else {
                     if (EnglishMode)strcpyf(str,"to search name.");
                     else strcpyf(str," לאיתור המשרד");  
                     if (AddedType>=4){
                             if (EnglishMode)strcpyf(str,"connect office ");
                             else strcpyf(str," להתקשרות למשרד ");
                     }                         
                } 
                if (EnglishMode){
                     if (YesNoAnswer2 &0x20){
                             strcpyf(str,"to search Tenant");
                             if (AddedType>=4)strcpyf(str,"contact Tenant");
                     }
                }else {
                     if (YesNoAnswer2 &0x20){
                             strcpyf(str," לאיתור דייר ");//MENU
                             if (AddedType>=4)strcpyf(str," למתקשרות לדייר");//MENU 
                     }
                } 
                fourline=1; 
                SwapLine23_12=1;//DISP 4 Lines to 2 lines 
           }
      }
  }
  else{
      if((int)NumOfStr == pDisplay){
          if (EnglishMode){ //FIX1
               strcpyf(str,"PROG. MENU -   ");
               str[12]=pN/10+0x30;
               str[13]=pN%10+0x30;
          }
          else {
               strcpyf(str," תפריט ראשי -  "); 
               str[13]=pN%10+0x30;
               str[14]=pN/10+0x30;                
          } //FIX1
          MaxMenuN = 33;           
      }
      if((int)NumOfStr == pCodes)
      {
         if (EnglishMode)strcpyf(str,"Access codes  ");
         else strcpyf(str," רשימת הקודים");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pConfirmTone){
         if (EnglishMode)strcpyf(str,"Confirm by Tone");
         else strcpyf(str," אישור שיחה בטון");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pSetReadTimer){
         if (EnglishMode)strcpyf(str,"SetRead Timmers");
         else strcpyf(str," הצג/שנה טיימרים");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pSetReadTime){
         if (EnglishMode)strcpyf(str,"SetRead DayTime");
         else strcpyf(str," הצג/שנה יום/שעה");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pToneCodes){
         if (EnglishMode)strcpyf(str,"Remote TEL Tone");
         else strcpyf(str," טון פתיחה מרחוק");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pRingingNum){
         if (EnglishMode)strcpyf(str,"#of ring/answer");
         else strcpyf(str," מס צלצולים-מענה");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pBusySogTone){
         if (EnglishMode)strcpyf(str,"Enter Busy Call ");
         else strcpyf(str," נתון צלצול תפוס");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pTel1Num)
      {
         if (EnglishMode)strcpyf(str,"Telephone No.1 ");
         else strcpyf(str," מספרי טלפון 1 ");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pTel2Num)
      {
         if (EnglishMode)strcpyf(str,"Telephone No.2 ");
         else strcpyf(str," מספרי טלפון 2 ");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pTel3Num)
      {
         if (EnglishMode)strcpyf(str,"Telephone No.3 ");
         else strcpyf(str," מספרי טלפון 3 ");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pTel4Num)
      {
         if (EnglishMode)strcpyf(str,"Telephone No.4 ");
         else strcpyf(str," מספרי טלפון 4 ");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pTel5Num)
      {
         if (EnglishMode)strcpyf(str,"Telephone No.5 ");
         else strcpyf(str," מספרי טלפון 5 ");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pTel6Num)
      {
         if (EnglishMode)strcpyf(str,"Telephone No.6 ");
         else strcpyf(str," מספרי טלפון 6 ");
         MaxMenuD = 2;
      }


      if((int)NumOfStr == pSpeechLevel)
      {
         if (EnglishMode)strcpyf(str,"Speech Level ");
         else strcpyf(str," עוצמת דיבור ");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pFASTstep)
      {
         if (EnglishMode)strcpyf(str,"'FAST' sw. Step ");
         else strcpyf(str," קצב קידום מהיר");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pMasterCode)
      {
         if (EnglishMode)strcpyf(str,"Master code");
         else strcpyf(str,"  קוד טכנאי ");// strcpyf(str,"  קוד גישה ");  //FIX MENU
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pTecUserCode)
      {
         if (EnglishMode)strcpyf(str,"User code");
         else strcpyf(str,"  קוד לקוח ");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pNames)
      {
         if (EnglishMode)strcpyf(str,"    Tenants     ");
         else strcpyf(str," שמות הדיירים ");
         MaxMenuD = 2; 
         SwapLine23_12=4; //DISP 4 Lines to 2 lines  
      }
      if((int)NumOfStr == pOutput){
         if (EnglishMode)strcpyf(str,"Cross to Apart");
         else strcpyf(str," הצלבה לפי דירות");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pExtKeys){
         if (EnglishMode)strcpyf(str,"SW board Extend");
         else strcpyf(str," מעגל הרחבת מפסק");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pProxyLrn){
         if (EnglishMode)strcpyf(str,"Prxy Lern Mode1");
         else strcpyf(str," כרטיסי קירבה 1"); 
         if (PxyDirDone>10){
             if (EnglishMode)strcpyf(str,"Prxy - in order"); 
             else strcpyf(str," התגים אורגנו!!");//Fast Proxy 
             if (PxyDirDone==20) PxyDirDone=19;
         }          
         MaxMenuD = 2; 
         if (!Pxy_Timer)Pxy_Timer=60;//PXYOO
         Tst_Exist=1;//only sign //PXYOO            
      }
      if((int)NumOfStr == pProxyLrn2){
         if (EnglishMode)strcpyf(str,"Prxy Lern Mode2");
         else strcpyf(str," כרטיסי קירבה 2");
         if (PxyDirDone>10){
             if (EnglishMode)strcpyf(str,"Prxy - in order"); 
             else strcpyf(str," התגים אורגנו!!");//Fast Proxy 
             if (PxyDirDone==20) PxyDirDone=19;
         }          
         MaxMenuD = 2; 
         if (!Pxy_Timer)Pxy_Timer=60;//PXYOO
         Tst_Exist=2;//only sign //PXYOO            
      }
      if((int)NumOfStr == pFloorValue){
         if (EnglishMode)strcpyf(str,"Set Floor Value ");
         else strcpyf(str," קבע ערך לקומה ");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pEraseAll){
         if (EnglishMode)strcpyf(str,"Change AllValue");//FIX7   
         else strcpyf(str," שינוי ערכים !!!");//FIX7  
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pMasageOn){
         if (EnglishMode)strcpyf(str,"Message On/Off ");
         else strcpyf(str," הפעל/כבה הודעה");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pAnswerY_N){
         if (EnglishMode)strcpyf(str,"Yes/No Answare ");
         else strcpyf(str," תשובות כן ולא ");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pRelayControl){
         if (EnglishMode)strcpyf(str,"Relays control ");
         else strcpyf(str," שליטה בממסרים ");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pOfset){
         if (EnglishMode)strcpyf(str,"Sel Type/Numric");
         else strcpyf(str," בחר סוג/מספרי");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pNewNo){
         if (EnglishMode)strcpyf(str,"New App Numric ");
         else strcpyf(str," מספור חדש לדירה");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pService){
         if (EnglishMode)strcpyf(str,"Service Menu ");
         else strcpyf(str,"  תפריט שרות   ");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pTimeCycle){
         if (EnglishMode)strcpyf(str,"Timings (sec) ");
         else strcpyf(str," זמנים )שניות( ");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pFamilyNo){
         if (EnglishMode)strcpyf(str,"LCD Family No. ");
         else strcpyf(str," שיוך משפחתי DCL");
         MaxMenuD = 2;
      }
      if((int)NumOfStr == pCommSpd){
         if (EnglishMode)strcpyf(str,"Comm Speed ");
         else strcpyf(str," מהירות תקשורת  ");
         MaxMenuD = 2;
      }


      if((int)NumOfStr == pOfsetR)
      {
            if (EnglishMode)strcpyf(str,"Type /Add value ");
            else strcpyf(str," סוג / ערך מוסף ");
            FuncNumber(List,str);  
            SwapLine23_12=3;//DISP 4 Lines to 2 lines 
      }
       if((int)NumOfStr == pFamilyNoR)
      {
         if (EnglishMode)strcpyf(str,"Set LcdFamily #");
         else strcpyf(str," קבע שיוך משפחתי");
         SwapLine23_12=3;//DISP 4 Lines to 2 lines 
      }
       if((int)NumOfStr == pCommSpdR)
      {
         if (EnglishMode)strcpyf(str,"Set Comm Speed");
         else strcpyf(str," קבע מהירות קשר ");
      }
       if((int)NumOfStr == pConfirmToneR)
      {
         if (EnglishMode)strcpyf(str,"Confirm tone is");
         else strcpyf(str," טון אישור הוא: ");
         SwapLine23_12=3;//DISP 4 Lines to 2 lines
      }
      if((int)NumOfStr == pToneCodesR){
         if (EnglishMode)strcpyf(str,"remote code is:");
         else strcpyf(str," קוד פתיחה מרחוק");
         FuncNumber(List,str); 
         SwapLine23_12=1; //DISP 4 Lines to 2 lines
      }
      if((int)NumOfStr == pRingingNumR){
         if (EnglishMode)strcpyf(str,"# of RingsToAns");
         else strcpyf(str," מס צלצול למענה:");
         SwapLine23_12=1; //DISP 4 Lines to 2 lines
      }
      if((int)NumOfStr == pBusySogToneR){
        if(List == 1){
         if (EnglishMode)strcpyf(str,"Busy tone Type1");
         else  strcpyf(str,"    תפוס סוג 1  ");
        }
        if(List == 2){
          if (EnglishMode)strcpyf(str,"Busy tone Type2");
          else strcpyf(str,"    תפוס סוג 2  ");
        }
        if(List == 3){
          if (EnglishMode)strcpyf(str,"Busy tone Val. ");
          else strcpyf(str,"    תפוס עוצמה  ");
        }
        if(List == 4){
          if (EnglishMode)strcpyf(str,"Busy tone Freq ");
          else strcpyf(str,"     תפוס תדר   ");
        }
        if(List == 5){
          if (EnglishMode)strcpyf(str,"Call low Freq  ");
          else strcpyf(str," צלצול תדר תחתון");
        }
        if(List == 6){
          if (EnglishMode)strcpyf(str,"Call high Freq ");
          else strcpyf(str," צלצול תדר עליון");
        }
        if(List == 7){
          if (EnglishMode)strcpyf(str,"Break on call  ");
          else strcpyf(str," הפסקה בין צלצול");
        }
        if(List == 8){
          if (EnglishMode)strcpyf(str,"Calls to pass  ");
          else strcpyf(str," מס' צלצול למעבר");
        }
        if(List == 9){
          if (EnglishMode)strcpyf(str,"No of bussy til");
          else strcpyf(str," מס' פעמים לתפוס");
        }

         FuncNumber(List,str);
      }
      if((int)NumOfStr == pNewNoR)
      {
            if (EnglishMode)strcpyf(str,"app. number#");
            else strcpyf(str," דירה מספר #");
            FuncNumber(List,str);
            SwapLine23_12=1; //DISP 4 Lines to 2 lines
      }
      if((int)NumOfStr == pCodesR)
      {
            if (EnglishMode)strcpyf(str,"Enter code #");
            else strcpyf(str," הכנס קוד#");
            FuncNumber(List,str);
      }
      if((int)NumOfStr == pTel1NumR)
      {
            if (EnglishMode)strcpyf(str,"1-Enter Tel#");
            else strcpyf(str," 1-הכנס טל' #");
            FuncNumber(List,str);  
            SwapLine23_12=4; //DISP 4 Lines to 2 lines 
      }
      if((int)NumOfStr == pTel2NumR)
      {
            if (EnglishMode)strcpyf(str,"2-Enter Tel#");
            else strcpyf(str," 2-הכנס טל' #");
            FuncNumber(List,str); 
            SwapLine23_12=4; //DISP 4 Lines to 2 lines  
      }
      if((int)NumOfStr == pTel3NumR)
      {
            if (EnglishMode)strcpyf(str,"3-Enter Tel#");
            else strcpyf(str," 3-הכנס טל' #");
            FuncNumber(List,str);  
            SwapLine23_12=4; //DISP 4 Lines to 2 lines 
      }
      if((int)NumOfStr == pTel4NumR)
      {
            if (EnglishMode)strcpyf(str,"4-Enter Tel#");
            else strcpyf(str," 4-הכנס טל' #");
            FuncNumber(List,str); 
            SwapLine23_12=4; //DISP 4 Lines to 2 lines 
      }
      if((int)NumOfStr == pTel5NumR)
      {
            if (EnglishMode)strcpyf(str,"5-Enter Tel#");
            else strcpyf(str," 5-הכנס טל' #");
            FuncNumber(List,str);  
            SwapLine23_12=4; //DISP 4 Lines to 2 lines 
      }
      if((int)NumOfStr == pTel6NumR)
      {
            if (EnglishMode)strcpyf(str,"6-Enter Tel#");
            else strcpyf(str," 6-הכנס טל' #");
            FuncNumber(List,str); 
            SwapLine23_12=4; //DISP 4 Lines to 2 lines 
      }

      if((int)NumOfStr == pServiceR)
      {
            if (EnglishMode)strcpyf(str,"Enter Info #");
            else strcpyf(str," הכנס נתונים#");
            FuncNumber(List,str);
            SwapLine23_12=1; //DISP 4 Lines to 2 lines
      }
      if((int)NumOfStr == pProxyLrnR)
      {
            if (EnglishMode)strcpyf(str,"Learn Prxy1#");
            else strcpyf(str," למד קירבה 1#");
            FuncNumber(List,str);
            SwapLine23_12=3;//DISP 4 Lines to 2 lines 
      }
      if((int)NumOfStr == pProxyLrn2R)
      {
            if (EnglishMode)strcpyf(str,"Learn Prxy2#");
            else strcpyf(str," למד קירבה 2#");
            FuncNumber(List,str);
            SwapLine23_12=3;//DISP 4 Lines to 2 lines 
      }
      if((int)NumOfStr == pFloorValueR)
      {
            if (EnglishMode)strcpyf(str,"This floor #");
            else strcpyf(str," קומה זו -< #");
            Floor=1;
            FuncNumber(List,str);
      }
      if((int)NumOfStr == pRelayControlR)
      {
            if (List==1){
                 if (EnglishMode)strcpyf(str,"Relay1 upto App");
                 else strcpyf(str," ממסר 1 עד דירה ");
            }
            if (List==2){
                 if (EnglishMode)strcpyf(str,"Relay2 from App");
                 else strcpyf(str," ממסר 2 מדירה ");
            }
          // FuncNumber(List,str);
      }
      if((int)NumOfStr == pSpeechLevelR)
      {
         if (EnglishMode)strcpyf(str,"Set speech Levl");
         else strcpyf(str," קבע עוצמת דיבור"); 
         SwapLine23_12=1; //DISP 4 Lines to 2 lines
      }
      if((int)NumOfStr == pFASTstepR)
      {
         if (EnglishMode)strcpyf(str,"Set 'FAST' Step ");
         else strcpyf(str,"  קבע קצב קידום");
         SwapLine23_12=1; //DISP 4 Lines to 2 lines
      }
       if((int)NumOfStr == pMasterCodeR)
      {
         if (EnglishMode)strcpyf(str,"Set master code");
         else strcpyf(str," הכנס קוד גישה ");
         SwapLine23_12=1; //DISP 4 Lines to 2 lines
      }
       if((int)NumOfStr == pExtKeysR)
      {
         if (EnglishMode)strcpyf(str,"Enter board Qty");
         else strcpyf(str," הכנס כמות מעגל'"); 
          SwapLine23_12=3; //DISP 4 Lines to 2 lines  
      }
      if((int)NumOfStr == pSetReadTimeR)
      {
           if (EnglishMode)strcpyf(str,"Day & Time are:");
           else strcpyf(str," היום והשעה הם:");
            SwapLine23_12=3; //DISP 4 Lines to 2 lines  
      }
      if((int)NumOfStr == pSetReadTimerR)
      {
           if (List==1){
                if (EnglishMode)strcpyf(str,"Timer1(DIAL) Day");
                else strcpyf(str," טימר1 חיוג-ימים"); 
                 SwapLine23_12=3; //DISP 4 Lines to 2 lines  
           }
           if (List==2){
                if (EnglishMode)strcpyf(str,"TimerN0.1 Start");
                else strcpyf(str," טיימר 1  - התחל"); 
                 SwapLine23_12=3; //DISP 4 Lines to 2 lines  
           }
           if (List==3){
                if (EnglishMode)strcpyf(str,"TimerN0.1 Stop");
                else strcpyf(str," טיימר 1 - סיים "); 
                 SwapLine23_12=3; //DISP 4 Lines to 2 lines  
           }
           if (List==4){
                if (EnglishMode)strcpyf(str,"Timer2(DIAL) Day");
                else strcpyf(str," טימר2 חיוג-ימים");
                 SwapLine23_12=3; //DISP 4 Lines to 2 lines  
           }
           if (List==5){
                if (EnglishMode)strcpyf(str,"TimerN0.2 Start");
                else strcpyf(str," טיימר 2  - התחל");
                 SwapLine23_12=3; //DISP 4 Lines to 2 lines  
           }
           if (List==6){
                if (EnglishMode)strcpyf(str,"TimerN0.2 Stop");
                else strcpyf(str," טיימר 2 - סיים ");
                 SwapLine23_12=3; //DISP 4 Lines to 2 lines  
           }
           if (List==7){
                if (EnglishMode)strcpyf(str,"Timer3(RLY1) Day");
                else strcpyf(str," טימר3 RLY1-ימים"); 
                 SwapLine23_12=3; //DISP 4 Lines to 2 lines  
           }
           if (List==8){
                if (EnglishMode)strcpyf(str,"TimerN0.3 Start");
                else strcpyf(str," טיימר 3  - התחל");
                 SwapLine23_12=3; //DISP 4 Lines to 2 lines  
           }
           if (List==9){
                if (EnglishMode)strcpyf(str,"TimerN0.3 Stop");
                else strcpyf(str," טיימר 3 - סיים ");
                 SwapLine23_12=3; //DISP 4 Lines to 2 lines  
           }
           if (List==10){
                if (EnglishMode)strcpyf(str,"Timer4(RLY2) Day");
                else strcpyf(str," טימר4 RLY2-ימים"); 
                 SwapLine23_12=3; //DISP 4 Lines to 2 lines  
           }
           if (List==11){
                if (EnglishMode)strcpyf(str,"TimerN0.4 Start");
                else strcpyf(str," טיימר 4  - התחל");  
                 SwapLine23_12=3; //DISP 4 Lines to 2 lines  
           }
           if (List==12){
                if (EnglishMode)strcpyf(str,"TimerN0.4 Stop");
                else strcpyf(str," טיימר 4 - סיים "); 
                 SwapLine23_12=3; //DISP 4 Lines to 2 lines  
           }

      }
      if((int)NumOfStr == pEraseAllR)
      {
           if (List==1){
                if (EnglishMode){
                        strcpyf(str,"Erease ALLcode "); 
                        str[14]=6;//?
                }    
                else {
                        strcpyf(str," מחק כל הקודים  ");
                        str[14]=5;//?
                }
                SwapLine23_12=5;//DISP 4 Lines to 2 lines   
           }
           if (List==2){
                if (EnglishMode)strcpyf(str,"Erase all Prxy1");
                else {
                        strcpyf(str," מחק כל קירבה 1 ");
                        str[15]=5;//?
                } 
                if (PxyDirDone>10){
                     if (EnglishMode)strcpyf(str,"PrxyTags Erased"); 
                     else strcpyf(str," התגים נמחקו !!");//Fast Proxy 
                     if (PxyDirDone==20) PxyDirDone=19;
                }
                SwapLine23_12=5;//DISP 4 Lines to 2 lines                                               
           }
           if (List==3){
                if (EnglishMode)strcpyf(str,"Erase all Prxy2");
                else {
                        strcpyf(str," מחק כל קירבה 2 ");
                        str[15]=5;//?
                } 
                if (PxyDirDone>10){
                     if (EnglishMode)strcpyf(str,"PrxyTags Erased"); 
                     else strcpyf(str," התגים נמחקו !!");//Fast Proxy 
                     if (PxyDirDone==20) PxyDirDone=19;
                }
                SwapLine23_12=5;//DISP 4 Lines to 2 lines                                               
           }  
           if (List==4){                                         //FIX7
                if (EnglishMode)strcpyf(str,"DEF Name/TEL NC");   
                else strcpyf(str," FEDשומר טל שמות");
                SwapLine23_12=5;//DISP 4 Lines to 2 lines    
           }    //FIX7   
           if (List==5){ //U_D                                        //FIX7
                if (EnglishMode)strcpyf(str,"Rec dataFrom SD");   
                else strcpyf(str," מקבל ATAD מה-DS"); 
                SwapLine23_12=5;//DISP 4 Lines to 2 lines   
           }    //FIX7         
           if (List==6){                                         //FIX7
                if (EnglishMode)strcpyf(str,"Send Data to DS");   
                else strcpyf(str," שולח ATAD ל -DS"); 
                SwapLine23_12=5;//DISP 4 Lines to 2 lines   
           }    //FIX7  //U_D 
           SwapLine23_12=5;//DISP 4 Lines to 2 lines                                                   
      }
       if((int)NumOfStr == pMasageOnR)
      {
         if (List==1){
                if (EnglishMode){
                        strcpyf(str,"Entry message># "); 
                        str[14]=5;//?
                }    
                else{
                    strcpyf(str," פתיח בעזרת # "); 
                    str[13]=5;//?
                }  
           }  
           if (List==2){
                if (EnglishMode){
                        strcpyf(str,"Stage message ");
                        str[13]=5;//? 
                }   
                else{
                        strcpyf(str," הודעת קומה  "); 
                        str[12]=5;//? 
                }
           }
           if (List==3){
               if (EnglishMode){
                        strcpyf(str,"Close door Mes. ");  
                        str[14]=5;//?  
                }
                else{
                        strcpyf(str," הודעת סגור דלת "); 
                        str[15]=5;//?
                } 
           }   
           if (List==4){
                if (EnglishMode){
                        strcpyf(str,"Name  Announce  ");
                        str[14]=5;//?
                }    
                else{
                        strcpyf(str," להקריא שמות  ");
                        str[13]=5;//?
                }  
           }   
           if (List==5){
               if (EnglishMode){
                        strcpyf(str,"Door forgetMES  "); 
                        str[14]=5;//?
                }  
                else{
                        strcpyf(str,"  שיכחת דלת   ");
                        str[12]=5;//?
                }  
           }   
           if (List==6){
                if (EnglishMode){
                        strcpyf(str,"Welcome by Det  "); 
                        str[14]=5;//?
                }   
                else{
                        strcpyf(str," פתיח מגלאי   "); 
                        str[12]=5;//?
                }  
           }    
           if (List==7){
                if (EnglishMode){
                        strcpyf(str,"Ringing Mes.   ");
                        str[13]=5;//?
                }    
                else{
                        strcpyf(str," הודעת צלצול   ");
                        str[13]=5;//?
                }  
           } 
           if (List==8){
              if (EnglishMode){
                        strcpyf(str,"Open door Mes  ");
                        str[13]=5;//?
                }    
                else {
                        strcpyf(str," הודעת פתח דלת ");
                        str[14]=5;//?
                }  
           }                                    
      }
       if((int)NumOfStr == pAnswerY_NR)
      {
           if (List==1){
                if (EnglishMode)strcpyf(str,"App=0 Office=1 ");
                else strcpyf(str," דירה=0 משרד=1 ");
           }
           if (List==2){
                if (EnglishMode)strcpyf(str,"Det Active B.L ");
                else strcpyf(str," גלאי לתאורה אח.");
           }
           if (List==3){
                if (EnglishMode){
                        strcpyf(str,"Proxy 1 ->Rly 1 "); 
                        str[14]=5;//?
                }   
                else {
                        strcpyf(str," קירבה1-< ממסר1 ");  
                        str[15]=5;//?
                }  
           }   
           if (List==4){
                if (EnglishMode){
                        strcpyf(str,"Proxy 1 ->Rly 2 "); 
                        str[14]=5;//?
                }    
                else {
                        strcpyf(str," קירבה1-< ממסר2 ");  
                        str[15]=5;//?
                }   
           }   
           if (List==5){
                if (EnglishMode){
                        strcpyf(str,"Proxy 2 ->Rly 1 ");
                        str[14]=5;//?
                }      
                else {
                        strcpyf(str," קירבה2-< ממסר1 ");  
                        str[15]=5;//?
                }  
           }   
           if (List==6){
                if (EnglishMode){
                        strcpyf(str,"Proxy 2 ->Rly 2 "); 
                        str[14]=5;//?
                }      
                else {
                        strcpyf(str," קירבה2-< ממסר2 ");  
                        str[15]=5;//?
                }  
           }   
           if (List==7){
                if (EnglishMode){
                        strcpyf(str,"Proxy+Pin Code ");
                        str[14]=5;//?
                }       
                else strcpyf(str," הפעלה קירבה+קוד");  
           }  
           if (List==8){
                if (EnglishMode){
                        strcpyf(str,"AppName by A-B  "); 
                        str[14]=5;//?
                }      
                else {
                        strcpyf(str," שמות לפי א-ב   ");
                        str[14]=5;//?
                }  
           }
           if (List==9){
                if (EnglishMode){
                        strcpyf(str,"Extrrnal Proxy  ");
                        str[14]=5;//?
                }       
                else{
                        strcpyf(str," קירבה חיצוני  ");
                        str[14]=5;//? 
                } 
           }                           
           if (List==10){
                if (EnglishMode){
                        strcpyf(str,"Elevetor Board  ");
                        str[14]=5;//?
                }       
                else{
                        strcpyf(str," פיקוד מעליות  "); 
                        str[14]=5;//?
                } 
           }
           if (List==11){
                if (EnglishMode){
                        strcpyf(str,"RealT.C. useed  ");
                        str[14]=5;//?
                }
                else{
                        strcpyf(str," שימוש בשעון   ");
                        str[14]=5;//?
                }
           }
           if (List==12){
                if (EnglishMode){
                        strcpyf(str,"Show tel data   ");
                        str[14]=5;//?
                }
                else{
                        strcpyf(str," הצג נתוני טל'  "); 
                        str[14]=5;//?
                }
           }
           if (List==13){
                if (EnglishMode){
                        strcpyf(str,"Beep in unlock  ");
                        str[14]=5;//?
                }       
                else {
                        strcpyf(str," בזר בפתיחת דלת ");
                        str[15]=5;//?
                }  
           } 
           if (List==14){
                if (EnglishMode){
                        strcpyf(str,"no app/office   "); //FIX MENU 
                        str[13]=5;//?
                }
                else{
                        strcpyf(str," ללא דירה/משרד ");
                        str[15]=5;//?
                }
           }  
           if (List==15){
                if (EnglishMode)strcpyf(str,"Direct DialMode "); //FIX MENU
                else {
                        strcpyf(str,"  מצב חיוג ישיר ");
                        str[14]=5;//?
                }
           }           
           if (List==16){
                if (EnglishMode){
                        strcpyf(str,"  Full menu    "); //FIX MENU
                        str[12]=5;//?
                }
                else{
                        strcpyf(str,"   תפריט מלא    ");
                        str[13]=5;//?
                }
           }
      }
      if((int)NumOfStr == pTecUserCodeR)
      {
         if (EnglishMode)strcpyf(str," Set user code");
         else strcpyf(str," הכנס קוד לקוח ");
         SwapLine23_12=1; //DISP 4 Lines to 2 lines
      }
      if((int)NumOfStr == pNamesR)
      {
         fourline=1; 
         if (EnglishMode)strcpyf(str,"SetName#");
         else strcpyf(str," הכנס שם#"); 
         FuncNumber(List,str);
//         if (EnglishMode){ 
//             str[11]='-';  //PLACE
//             str[14]='4';
//             str[13]='5';
//             str[12]='9';          
//         }else {
//             str[12]='-';
//             str[13]='4';
//             str[14]='5';
//             str[15]='9'; 
//         }
      }
      if((int)NumOfStr == pOutputR){
         if (EnglishMode)strcpyf(str,"CrossTo App#");
         else strcpyf(str," הצלבה לדירה#");
         FuncNumber(List,str);
         SwapLine23_12=1; //DISP 4 Lines to 2 lines
      }
      if((int)NumOfStr == pTimeCycleR){
         if(List == 1)
             if (EnglishMode)strcpyf(str,"Delay Time   ");
             else strcpyf(str,"  זמן המתנה ");
         if(List == 2)
             if (EnglishMode)strcpyf(str,"Door Opening ");
             else strcpyf(str," זמן פתיחת דלת ");
         if(List == 3)
             if (EnglishMode)strcpyf(str,"Relay2 Dly time");
             else strcpyf(str," ז. השהיה ממסר 2");
         if(List == 4)
             if (EnglishMode)strcpyf(str,"Relay2 Opn time");
             else strcpyf(str," ז. פתיחה ממסר 2");
         if(List == 5)
             if (EnglishMode)strcpyf(str,"Illumination  ");
             else strcpyf(str,"  זמן תאורה ");
         if(List == 6)
             if (EnglishMode)strcpyf(str,"Ringing Time   ");
             else strcpyf(str," זמן הצגת דייר ");
         if(List == 7)   
             if (EnglishMode)strcpyf(str,"Next Dial Time ");
             else strcpyf(str,"  זמן לחיוג הבא ");         
//             if (EnglishMode)strcpyf(str,"Camera time    "); //FIX3   //FIX MENU        
//             else strcpyf(str," זמן מצלמה בלבד");  //FIX MENU   
         if(List == 8)
             if (EnglishMode)strcpyf(str,"Pin+ Proxy time ");
             else strcpyf(str," ז.מצב קוד+קירבה");
         if(List == 9)
             if (EnglishMode)strcpyf(str,"Door forget>Mes ");
             else strcpyf(str," שיכחת דלת-הודעה");
         if(List == 10)
             if (EnglishMode)strcpyf(str,"Det>wellcom Mes ");
             else strcpyf(str," ז. מגילוי לפתיח");
         if(List == 11)
             if (EnglishMode)strcpyf(str,"T.to name annou ");
             else strcpyf(str," זמן להודעת שמות");
         if(List == 12)
             if (EnglishMode)strcpyf(str,"T.to floor Mes. ");
             else strcpyf(str," זמן להודעת קומה");
         if(List == 13)
             if (EnglishMode)strcpyf(str,"T.to disp. list ");
             else strcpyf(str," זמן להצגת רשימה");
         if(List == 14)
             if (EnglishMode)strcpyf(str,"UpToDisp select");//ADJ DISP
             else strcpyf(str,"  עד להצגת נבחר"); //ADJ DISP
         if(List == 15)
             if (EnglishMode)strcpyf(str,"ToDisp Selected");//ADJ DISP
             else strcpyf(str," זמן הצגת נבחר ");  //ADJ DISP
         if(List == 16)
             if (EnglishMode)strcpyf(str,"talk time x10S'");
             else strcpyf(str," זמן דיבור x01ש'");
         if(List == 17)
             if (EnglishMode)strcpyf(str,"Bsuy -not used");
             else strcpyf(str," זמן תפוס- עתידי");         
         if(List == 18)
             if (EnglishMode)strcpyf(str,"Confirm-Not use"); //FIX MENU
             else strcpyf(str," זמן אישור-עתידי");//FIX MENU 
             if((List<6)||(List==8)||(List==9)) SwapLine23_12=1; //qqcc 
             else SwapLine23_12=12;//qqcc
      }
  }
  size = strlen(str);
  for(;size<16;size++)
      str[size] = ' ';

}
void FuncNumber(unsigned char Num,char* str)
{
  unsigned char Azer[4];
  unsigned char TmpNum;
  if (!EnglishMode){
     TmpNum=Num;
     if(Floor == 1)TmpNum--;
     Floor=0;        
     if (TmpNum>99){
          Azer[2] = (TmpNum/100)+0x30;
          TmpNum =TmpNum%100;
     }else Azer[2] =0x20;
     Azer[1] = TmpNum/10 + 0x30;
     Azer[0] = TmpNum%10 + 0x30;
  }else {
     TmpNum=Num;
     if(Floor == 1)TmpNum--;
     Floor=0;        
     if (TmpNum>99){
          Azer[0] = (TmpNum/100)+0x30;
          TmpNum =TmpNum%100;
     }else Azer[0] =0x20;
     Azer[1] = TmpNum/10 + 0x30;
     Azer[2] = TmpNum%10 + 0x30;
  }
  Azer[3] = 0;
  strcat(str,Azer);

}
void FuncNumberH(unsigned char Num,char* str)
{
    unsigned char Azer[4];
     Azer[2] = Num/100 + 0x30;
     Num%= 100;
     Azer[1] = Num/10 + 0x30;
     Azer[0] = Num%10 + 0x30;
     Azer[3] = 0;
     strcat(str,Azer);
}


void HebruSrting(char *str)
{
     char ch;
     char i;
     if (!EnglishMode){
          for(i=0;i<8;i++){
                ch = str[i];
                str[i] = str[15-i];
                str[15-i] = ch;
                if((str[i] >= 0xE0)&&(str[i] <= 0xFA))str[i]-= 0x40;
                if((ch >= 0xE0)&&(ch <= 0xFA))str[15-i]-= 0x40;
          }
     }
}
void ChangeSrting(char *str)
{
     char ch;
     char i;
     for(i=0;i<8;i++){
             ch = str[i];
             str[i] = str[15-i];
             str[15-i] = ch;
     }
}
