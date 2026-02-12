#include "Button.h"
#include "Define.h"
#include "Elegant.h" // hp
#include <io.h> // hp

unsigned char Key,Long_Cnt,Long_Wait,Test_Key; //LONG STAR 
char TestButton(void){
     char LastKey,v;


if (BoardQty){
////read 597
//     Last597= Rec597Data;//max keys
//     PORTE |=0x4;
//     #asm("NOP");
//     #asm("NOP");
//     PORTE &=~0x4;
//
//
//
//
//     Rec597Data=0;
//     for (v=0;v<(8*BoardQty);v++){
//          if (!(PINA & 0x10)){
//               #asm("NOP");
//               if (!(PINA & 0x10))Rec597Data =(8*BoardQty)-v;
//          }
//          PORTA &=~0x80;
//          #asm("NOP");
//          #asm("NOP");
//          PORTA |=0x80;
//     }

   //  if (Rec597Data==1)Rec597Data=0;
}

     LastKey = Key;
     Key = GetButton();                                           
     ////LONG STAR 
     if ((EnglishMode)&&(Status)&&(StutLine1 == pNamesR))Test_Key=DHSH;
     else Test_Key=STAR; 
     if ((Key== Test_Key)&&(Status)&&((StutLine1 == pNamesR)||(StutLine1 == pTel1NumR)||(StutLine1 == pTel2NumR)
                ||(StutLine1 == pTel3NumR)||(StutLine1 == pTel4NumR)||(StutLine1 == pTel5NumR)||(StutLine1 == pTel6NumR)) 
                    &&(!Long_Wait)){ 
          Key=255;
          if (Long_Cnt<20)Long_Cnt++; 
          else Long_Cnt=0;
          if (Long_Cnt==15){
                Long_Cnt=0;
                Key=L_STAR; //same as L_DHSH for english name 
                Long_Wait=5; 
          }  
     }else if ((Key==0)&&(Long_Cnt)&&(!Long_Wait)){
           Key=Test_Key;  
           Long_Cnt=0;
     }
     if (Key==255)Key=0;
     if (Long_Wait)Long_Wait--; 
     ////LONG STAR      
     PORTE&= ~0xf0;
     if(LastKey == Key) return(0);
     else return(Key);
}
char GetButton(void){
    char Shift,i;
    //PORTB&= ~0x40;
    Shift = 0x10;
    PORTE&= ~0xf0;
    PORTE|= Shift;
    for(i=0;i<4;i++){
        if(Shift&0x10){
             if(PINB & 0x80) return 1;
             if(PINB & 0x10) return 2;
             if(PINB & 0x40) return 3;
             if((PINB & 0x20)&&(!Status)) return FAST;                 //up
             else if((PINB & 0x20)&&(Status==1))return NEXT;
             else if((PINB & 0x20)&&(Status>1)){
                  if((StutLine1 == pNamesR)||(StutLine1 == pCodesR)||
                  (StutLine1 == pProxyLrnR)||(StutLine1 == pProxyLrn2R)
                  ||(StutLine1 ==pNewNoR)||(StutLine1 == pOutputR)||(StutLine1 == pTel1NumR)||(StutLine1 == pTel2NumR)
                  ||(StutLine1 == pTel3NumR)||(StutLine1 == pTel4NumR)||(StutLine1 == pTel5NumR)||(StutLine1 == pTel6NumR))return FAST;
                  else return NEXT;
             }
        }
        if(Shift&0x20){
             if(PINB & 0x80) return 4;
             if(PINB & 0x10) return 5;
             if(PINB & 0x40) return 6;
             if(PINB & 0x20) return NEXT;                  //dwon
        }
        if(Shift&0x40){
             if(PINB & 0x80) return 7;
             if(PINB & 0x10) return 8;
             if(PINB & 0x40) return 9;
             if(PINB & 0x20) return BACK;               //  (MENU)
        }
        if(Shift&0x80){
             if(PINB & 0x80) return STAR;                 //ENTER
             if(PINB & 0x10) return ZERO;
             if(PINB & 0x40) return DHSH;   //ESC
             if(PINB & 0x20) return BELL;              //fast up to be declear
        }
        Shift<<=1;
        PORTE&= ~0xf0;
        PORTE|= Shift;
    }
/*    PORTB|= 0x40;
       #asm("nop");
       #asm("nop");
       #asm("nop");
       #asm("nop");
    if(PINB & 0x04) return NEXT;
    if(PINB & 0x08) return BACK;
    if(PINB & 0x10) return MENU; */

    return(0);
}


/*#include "Button.h"
#include "Define.h"
unsigned char Key;
char TestButton(void){
     char LastKey;
     LastKey = Key;
     Key =0;
     GetButton();
     if(LastKey == Key) return(0);
     else return(Key);
}
char GetButton(void){
    char i;
    for(i=0;i<4;i++){
        PORTE&= ~0xf0;
        if (i==0)PORTE|= 0x10;
        else if (i==1)PORTE|= 0x20;
        else if (i==2)PORTE|= 0x40;
        else if (i==3)PORTE|= 0x80;
        #asm("NOP");
        #asm("NOP");
        #asm("NOP");
        #asm("NOP");
        if((i==0)&&(!Key)){
             if(PINB & 0x10) Key= 1;
             else if(PINB & 0x40) Key= 2;
             else if(PINB & 0x20) Key= 3;
             else if((PINB & 0x80)&&(!Status)) Key= FAST;                 //up
             else if((PINB & 0x80)&&(Status==1))Key= NEXT;
             else if((PINB & 0x80)&&(Status>1)){
                  if((StutLine1 == pNamesR)||(StutLine1 == pCodesR)||
                  (StutLine1 == pProxyLrnR)||(StutLine1 == pProxyLrn2R)
                  ||(StutLine1 ==pNewNoR)||(StutLine1 == pOutputR))Key= FAST;
                  else Key= NEXT;
             }
        }
        if((i==1)&&(!Key)){
             if(PINB & 0x10) Key= 4;
             else if(PINB & 0x40) Key= 5;
             else if(PINB & 0x20) Key= 6;
             else if(PINB & 0x80) Key= NEXT;                  //dwon
        }
        if((i==2)&&(!Key)){
             if(PINB & 0x10) Key= 7;
             else if(PINB & 0x40) Key= 8;
             else if(PINB & 0x20) Key= 9;
             else if(PINB & 0x80) Key= BACK;               //  (MENU)
        }
        if((i==3)&&(!Key)){
             if(PINB & 0x10) Key= STAR;                 //ENTER
             else if(PINB & 0x40) Key= ZERO;
             else if(PINB & 0x20) Key= DHSH;   //ESC
             else if(PINB & 0x80) Key= BELL;              //fast up to be declear
             PORTE&= ~0xf0;
        }
    }
} */

