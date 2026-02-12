#include <mega128.h>
#include "ISO_Modem.h"
#include "TableMoked.h"
#include "Define.h"
#include "elegant.h" // hp
#include <string.h> // hp
#include "eeprom.h" // hp

//Asaf

// USART1 Receiver buffer

char rx_buffer1[RX_BUFFER_SIZE1];
unsigned char rx_wr_index1, rx_rd_index1;

// USART1 Transmitter buffer
char tx_buffer1[TX_BUFFER_SIZE1];

//?unsigned char tx_rd_index1;
unsigned char mFlagRes;
unsigned char mConected, tConected;
//unsigned char TimeOut1, TimeConect;
unsigned int  Busy1;
unsigned char CountTel, CountMoked;   // number of telephon
unsigned char CycleDial, mCycleDial;      // cycle of follow
unsigned char tUserCode[7], tCountCode;
unsigned char pStartEvent, pStopEvent;
unsigned char pStartMoked, pStartMoked_S;
unsigned char TrySendMoked, MaxTryMoked;
//unsigned char DataMoked[MAX_EVENT][2];
unsigned char pStrSpike[36];              // string of word to speak
unsigned int  StrInt[8];              // string of word to speak
unsigned char dStr, nStr, MaxStr;
unsigned char EntStatus,NumMessage;
unsigned char NewSpike;
unsigned char PhoneUp;
unsigned char Reset, StatusReset, TimeReset,ResetM_T;
//unsigned char CanEnterSys, CounterRing;
unsigned char StatusSpike, TimeSpike, TelTone,PauseSpike,NextKey;
unsigned char TelButton[11], TelStart, TelStop;
unsigned char SaveStatus, SaveStatusArm;
unsigned char CountPauseSpike, BitPauseSpike;
unsigned char StatusElement;
unsigned char BaundPhone;
unsigned char SpikeKeybord, SaveBordSpiker;//,SpikePuls;
unsigned char MessageOut, FlagMass;
unsigned char SpikeKey;

unsigned char mValueChecsum;
unsigned char Status_MD;
unsigned char CounterDisConect, FlagDisConect;
unsigned int  TimeConectWithPC;
unsigned char FlagCallBack1 ,FlagCallBack2 ,CounterCallback;
unsigned char FlagY;
unsigned char TimePress;
unsigned char FirstWord;
unsigned char EndOfMess;

unsigned char BufTL[2];
unsigned char CountTelLine;
unsigned char CounterTone , FlagTone;
unsigned char IndexSM;
unsigned char TimeOutReset;
unsigned char FlagTryCon;
unsigned char FlagCanSpikeMES;
unsigned char CRings;
unsigned char FlagServisR;
unsigned char TimeToneOut;
unsigned char FlagHoldLine;
unsigned char CountPauseRing;
unsigned char FlagEndOfMess, FlagCountEndOfMess;
unsigned char KeyTel, FlagTestKeyTel;
unsigned char FlagSpikeStatZone;
unsigned char FlagStatusTone;
unsigned short TimeConectedWithApp;

/* SE2 bits 0,1 (d=00) GPIO1 control if value 2  act as anlog input
   SE3 bits 6,7 (d=00) AIN gain 00=0db,01=6db 10=2.5db ,11= 12db
   SE4 bits 5,4 (d=00) DRT mode 01= voice mode 00= data mode
       bit 1 APO analog power on (mast be on at voice mode)
   SF4 (d=000 1111)
       bits 0,1 AOUT trasmit gain 00=-18db 01=-24db 10=-30db 11=mute
       bits 2,3 AOUT receive gain 00=0db 01=-6db 10=-12db 11=mute
       bits 4,5,6 Analog receive gain
	      (speking)OFF HOOK 000=0db 001=3db 010=9db 0011=9db 1xx=12db
	               ON HOOK 000=7db 001=6db 010=4.8db 011=3.5db 1xx=2 db

Receiving Cahr=
		','= dialing
		't' = dialing tone
		'r' = ringing
		'b' = bussy
*/
void SetVoiceMode(void)
{
        FinshDialFlag=0;
        //VoiceModeStatus=1;
        strcpyf(tx_buffer1,"ATSE2=02SE3=00SE4=12SF4=4b\r");
        tx_rd_index1 = 0;
        UDR1=tx_buffer1[0];
}
void VoiceMicMax(void)
{
//        VoiceModeStatus=1;
       //PORTA |= 0x04;   //with mic

        strcpyf(tx_buffer1,"ATSF4=0b\r");//mic = max volume
        tx_rd_index1 = 0;
        UDR1=tx_buffer1[0];
}
void VoiceSpkMax(void)
{
//        VoiceModeStatus=1;
        //PORTA&= ~0x04;  //with out mic

        strcpyf(tx_buffer1,"ATSF4=4b\r");//mic = min volume
        tx_rd_index1 = 0;
        UDR1=tx_buffer1[0];
}
void TestTelephone(void)           // massege from modem
{

      if (ReceivedData== 'R'){
         // Siren_Start(2);
          Ringing++;
          if ((AnsMD_timeOut)&&(Ringing<25))AnsMD_timeOut=60;//keep AnsMD_timeOut value during ringing up to 25 rings
          ReceivedData=0;
          if ((RingNumber)||(AnswerAsModem)){
               if (Ringing>=RingNumber){ 
            //   Siren_Start(2);
                    HoldLine(); 
                    Dsp_Connect_T=1; 
                    if (AnswerAsModem) {
                           AnswerToRingModem();
                           AnswerAsModem=0;
                           AnsMD_timeOut=60;
                           Siren_Start(1);
                    }
                    else {
                        AnswerToRingTone();

                    }
                    AMP_ON_OFF |=0x1;// AMP ON (0 = amp 1 buzzer 2 voice )

                   //no need? SpkPnAmpOn=1;
                    ShuntMicTime=1;
                    TimeConectedWithApp = SpeechTime;
               }
          }
      }/*
      if ((ReceivedData== 'b')&&(TimeConectedWithApp>5)){
           TimeConectedWithApp = 5;
           //Siren_Start(2);
      } */
      if(rx_rd_index1 != rx_wr_index1){
             if(Reset < 10){  // if not reset

                        if(rx_buffer1[rx_rd_index1] == 0x4F){
                                 Reset++;
                                 Busy1 = 0;
                        }

             }
             else{
                        if ((StartDialFlag)&&(rx_buffer1[rx_rd_index1] == ',')){
                                     StartDialFlag=0;
                                     FinshDialFlag=1;
                                   //space  TimeRplaceVolumeCnt=200;
                                     ValumeValueBuf=0;
                        }
                     /*   if ((VoiceModeStatus==1)&&(rx_buffer1[rx_rd_index1] == 0x4F)){
                                     VoiceModeStatus=2;
                                     TimeRplaceVolumeCnt=200; //800 msec
                        }*/


                    //    if(rx_buffer1[rx_rd_index1] == 'b'){   // line busy

                  //     TimeConectedWithApp = 5;
		/*  if ((ReceivedData== 'b')&&(TimeConectedWithApp>2)){
                       TimeConectedWithApp = 2;
                  }*/
                 /* if(rx_buffer1[rx_rd_index1] == 'r'){   // ringing
     		       PORTA|= 0x04;
                  }*/
                  /*if(rx_buffer1[rx_rd_index1] == 'R'){   // line busy
                       HoldLine();
                       AnswerToRingModem();
                  }*/
             }


             rx_rd_index1++;
             if(rx_rd_index1 >= RX_BUFFER_SIZE1)
                        rx_rd_index1 = 0;
      }
}
void FromComandToData(void)
{
      Status_MD = 1;
}
void FromDataToComand(void)
{
      Status_MD = 0;
}

void AnswerToRingTone(void)
{
        strcpyf(tx_buffer1,"ATA0\r");
        tx_rd_index1 = 0;
        FlagStatusTone = 1;
        UDR1=tx_buffer1[0];
        No_Floor_Mess=1; //put answer by panel flag for no floor message output 
        NO_Close_Door_Mes=0;
}



char ConectToTel(char CountTelephon)
{
    char i;
//    ShuntMicTime=2;//RingTime+1;
//    if (ShuntMicTime<3) ShuntMicTime=3;

    strcpyf(tx_buffer1,"ATDT");     
    WaitTill_BusyTst=140;//wait 35x4 until bussy test
    No_Floor_Mess=0; //erase answer by panel flag
    NO_Close_Door_Mes=0; 
    if (AddedType>=4){ 
           if (Type456SelTel==1){
              Pointer = Tel1Num;
              MaxNum = CMaxTel1Num;
           }
           else  if (Type456SelTel==2){
              Pointer = Tel2Num;
              MaxNum = CMaxTel2Num;
           }    
           else  if (Type456SelTel==3){
              Pointer = Tel3Num;
              MaxNum = CMaxTel3Num;
           } 
           else  if (Type456SelTel==4){
              Pointer = Tel4Num;
              MaxNum = CMaxTel4Num;
           } 
           else  if (Type456SelTel==5){
              Pointer = Tel5Num;
              MaxNum = CMaxTel5Num;
           }
           else  if (Type456SelTel==6){
              Pointer = Tel6Num;
              MaxNum = CMaxTel6Num;
           }                                             
    } 
    else {
            if (DialingTo==0){
                 if (TimerStatus&0x1){
                      Pointer = Tel4Num;
                      MaxNum = CMaxTel4Num;
                 }else {
                      Pointer = Tel1Num;
                      MaxNum = CMaxTel1Num;
                 }
            }else if (DialingTo==1){
                 if (TimerStatus&0x1){
                      Pointer = Tel5Num;
                      MaxNum = CMaxTel5Num;
                 }else {
                      Pointer = Tel2Num;
                      MaxNum = CMaxTel2Num;
                 }
            }else if (DialingTo>1){
                 if (TimerStatus&0x1){
                      Pointer = Tel6Num;
                      MaxNum = CMaxTel6Num;
                 }else {
                      Pointer = Tel3Num;
                      MaxNum = CMaxTel3Num;
                 }
            }
    }
    ReadData(CountTelephon);
//    if(Data[0] == ':'){   //REDIAL 3
//         for(i=0;(i<15)&&(Data[i]>0x20);i++){ // erase the : sign
//              Data[i]=Data[i+1];
//         }
//         if (i<15)Data[i+1]=0x20;
//    } else ConfimTstT_CNT=0; // test not need if no : sign
    DTMF_Dly_Break=0;
    for(i=0;(i<16)&&(Data[i]>0x20);i++){
       ShuntMicTime++;
       if(Data[i] == '-'){
           tx_buffer1[i + 4] = ',';
//           ShuntMicTime++;
//           ShuntMicTime++;
           DTMF_Dly_Break+=2;
       } //DIAL #* in ISO_MODEM
//       else if (Data[i] == '*')Data[i+4]='B';//to dial *   //FIXING # Error Ver 2.3
//       else if (Data[i] == '#')Data[i+4]='C';//to dial #  
//       else if (Data[i] == 'f')Data[i+4]=',';//to dial #
       //DIAL #* in ISO_MODEM
       else
           tx_buffer1[i + 4] = Data[i];
    }
    ShuntMicTime=ShuntMicTime/4; //each digit wait 1/2 sec 
    ShuntMicTime +=5; // add waiting time until start dial 
    ShuntMicTime +=DTMF_Dly_Break;
    DTMF_Dly_Break= ShuntMicTime;//for Confirm use in BIG CLOCK 

    if(i > 1){
        i+= 4;
        tx_buffer1[i++] = ';';
        //tx_buffer1[i++] = '!';
        //tx_buffer1[i++] = '0';
        tx_buffer1[i++] = 13;
        tx_buffer1[i] = 0;
        tx_rd_index1 = 0;

        UDR1=tx_buffer1[0];
        TimeConectedWithApp = SpeechTime;
        StartDialFlag=1;


        return(1);
    }else
        return(0);
}
/*{
    char i;


    strcpyf(tx_buffer1,"ATDT");
    Pointer = OutPut;
    MaxNum = CMaxOutPut;
    ReadData(CountTelephon);
    for(i=0;(i<16)&&(Data[i]>0x20);i++)
       if(Data[i] == '-')
           tx_buffer1[i + 4] = ',';
       else
           tx_buffer1[i + 4] = Data[i];

    if(i > 1){
        i+= 4;
        if(ResetM_T == TONE_RES){
               tx_buffer1[i++] = '!';
               tx_buffer1[i++] = '0';
        }
        tx_buffer1[i++] = 13;
        tx_buffer1[i] = 0;
        tx_rd_index1 = 0;
        UDR1=tx_buffer1[0];
        TimeConectedWithApp = 180;
        return(1);
    }else
        return(0);
}*/



void HoldLine(void)
{
   if(!FlagHoldLine){
      FlagHoldLine = 1;
      SignalTstCnt=0;
      SignalMaxCnt=0;
      SignalMinCnt=0;
      SignalHighTst=0; 
      WaitTill_BusyTst=140;//wait 35x4 until bussy test
     }
}
void ReliseLine(void)
{
   if(FlagHoldLine){
      LineWasBussyFlag=0;
      FlagHoldLine = 0;
      Reset = 0; 
   }
}



/*void TestTelLine(void)
{
     if(!Busy1){
         if(Reset == 10){
            strcpyf(tx_buffer1,"ATSDB?\r");       // TEST
            tx_rd_index1 = 0;
            UDR1=tx_buffer1[0];
            Busy1 = 150;
            FlagTestTel--;
            FlagCanTestTel = 1;
            CountTelLine = 0;
         }
     }
}*/

void ResetFunc(void)
{
    char ind;
    int lPointer;
    char lMaxNum;
    unsigned char sData[17];
    lPointer = Pointer;
    lMaxNum = MaxNum;
    strcpy(sData,Data);
    if((!Reset)&&(!Busy1)){
               if(StatusReset == 0){
                        FlagStatusTone = 0;
                        PORTG&= ~0x04;
                        TimeReset = 3;
                        StatusReset = 1;
                        Ringing=0;
               }

               if((!TimeReset)&&(StatusReset == 1)){
                        PORTG|= 0x04;
                        TimeReset = 3;
                        StatusReset = 2;
               }

               if((!TimeReset)&&(StatusReset == 2)){
                        UCSR1A=0x00;
                        UCSR1B=0xD8;
                        UCSR1C=0x86;
                        UBRR1L=0x03; //2400 on 10M crystal
                        UBRR1H=0x01;

                        strcpyf(tx_buffer1,"AT\r");       // TEST
                        tx_rd_index1 = 0;
                        UDR1=tx_buffer1[0];
                        StatusReset = 0;
                        Busy1 = 100;
               }
    }
    if((Reset == 1)&&(!Busy1)){
             strcpyf(tx_buffer1,"ATE0\r");       // echo off
             tx_rd_index1 = 0;
             UDR1=tx_buffer1[0];
             Busy1 = 100;
    }
    if((Reset == 2)&&(!Busy1)){
            // Pointer = TranslateMoked;
            // MaxNum = CMaxTranslateMoked;
             //ReadData(9);
             Data[8]='0';
             Data[9]='0';
             Data[10]='0';
             Data[11]='0';
             Data[12]='0';
             Data[13]='0';
             Data[14]='0';
             Data[15]='0';

             strcpyf(tx_buffer1,"AT");
             ind = 2;
             if((Data[8] > '0')||(Data[9] > '0')){
                      strcpyf(&tx_buffer1[ind],"SF5=00\r");
                      ind+= 4;
                      tx_buffer1[ind++] = Data[8];
                      tx_buffer1[ind++] = Data[9];
             }
             if((Data[10] > '0')||(Data[11] > '0')){
                      strcpyf(&tx_buffer1[ind],"SF6=00\r");
                      ind+= 4;
                      tx_buffer1[ind++] = Data[10];
                      tx_buffer1[ind++] = Data[11];
             }
             if((Data[12] > '0')||(Data[13] > '0')){
                      strcpyf(&tx_buffer1[ind],"SF7=00\r");
                      ind+= 4;
                      tx_buffer1[ind++] = Data[12];
                      tx_buffer1[ind++] = Data[13];
             }
             if((Data[14] > '0')||(Data[15] > '0')){
                      strcpyf(&tx_buffer1[ind],"S62=00\r");
                      ind+= 4;
                      tx_buffer1[ind++] = Data[14];
                      tx_buffer1[ind++] = Data[15];
             }
             if(ind > 2){
                      tx_rd_index1 = 0;
                      UDR1=tx_buffer1[0];
                      Busy1 = 100;
             }
             else    Reset++;

    }
    if(Reset > 2){
          ResetFuncTone();
    }
    Pointer = lPointer;
    MaxNum = lMaxNum;
    strcpy(Data,sData);

}
void ResetFuncTone(void)
{
              if((Reset == 3)&&(!Busy1)){

                    strcpyf(tx_buffer1,"ATSE4=02SE2=02SF4=03\r");       // OVER TO STATUS TELEPHONE OUT
                    tx_rd_index1 = 0;
                    UDR1=tx_buffer1[0];
                    Busy1 = 200;
              if (LineWasBussyFlag) TimeOutReset = 3;else TimeOutReset = 1;
              }
             if((Reset == 4)&&(!Busy1)){
                    strcpyf(tx_buffer1,"ATM2\r");       // Spekear allwways on
                    tx_rd_index1 = 0;
                    UDR1=tx_buffer1[0];
                    Busy1 = 300;
                    if (LineWasBussyFlag) TimeOutReset = 3;else TimeOutReset = 1;
              }
              if((Reset >4)&&(!Busy1)&&!TimeOutReset){
              	      LineWasBussyFlag=0;
                      Reset = 10;
                      rx_wr_index1 = 0;
                      rx_rd_index1 = 0;

                      StartDialFlag=0;
                      FinshDialFlag=0;
                      //VoiceModeStatus=0;
                      PORTA&= ~0x04;  //no mic need
              }
}

void DialToApp(char Pointer){
     AMP_ON_OFF |=0x1;// AMP ON (0 = amp 1 buzzer 2 voice )
     PORTF |=0x80;// open mic
     // no need ? SpkPnAmpOn=1;
     HoldLine();
     ConectToTel(Pointer);
}
void AnswerToRingModem(void)
{
//          if (AnswerAsModem==1){
//                strcpyf(tx_buffer1,"ATS07=01A\r");  //BELL 103  -300 BOUT   not working usb modem
//                //strcpyf(tx_buffer1,"ATA\r");  //  auto mode
// //                UBRR1H=0x08;
// //                UBRR1L=0x22; //300 on 10M crystal
//          }
//          else if (AnswerAsModem==2){
//                strcpyf(tx_buffer1,"ATS07=48A\r");  // BELL V23  - 600 BOUT RATE  WORKING usb modem
// //                UBRR1H=0x04;
// //                UBRR1L=0x11; //600 on 10M crystal
//          }
//          else if (AnswerAsModem==3){
//                strcpyf(tx_buffer1,"ATSE0=01");  // 1200 BOUT RATE
//          }
//          else if (AnswerAsModem==4){
//                strcpyf(tx_buffer1,"ATS07=06A\r");  //BELL V22.bis 2400 BOUT - not working usb modem
// //                UBRR1H=0x01;
// //                UBRR1L=0x03; //2400 on 10M crystal
//          }


//SAME AS UPPER BUT CCITT (BIT 1=HIGH  see page 50 on SI2400 datasheet
//          if (AnswerAsModem==1)strcpyf(tx_buffer1,"ATS07=03A\r");  //CCITT 103  -300 BOUT   not working usb modem
//          else if (AnswerAsModem==2) strcpyf(tx_buffer1,"ATS07=50A\r");  // CCITT V23  - 600 BOUT RATE  WORKING usb modem
//          else if (AnswerAsModem==3)strcpyf(tx_buffer1,"ATS07=02A\r");  // CCITT 212A  - 1200 BOUT RATE  WORKING usb modem
//          else if (AnswerAsModem==4)strcpyf(tx_buffer1,"ATS07=08A\r");  //CCITT V22.bis 2400 BOUT - not working usb modem


        //strcpyf(tx_buffer1,"ATS07=02A\r");  //V22 -1200 BOUT RATE  - WORKING usb modem
        //strcpyf(tx_buffer1,"ATS07=16A\r");  //V23 -1200/75 tx/rx  BOUT RATE - WORKING usb modem
        //strcpyf(tx_buffer1,"ATS07=24A\r");  //V23 -75/1200 tx/rx  BOUT RATE - WORKING usb modem
        // else if (AnswerAsModem==4) external modem use

        //2400 Was Choosen
        strcpyf(tx_buffer1,"ATS07=06A\r");  //BELL V22.bis 2400 BOUT - not working usb modem

        tx_rd_index1 = 0;
        UDR1=tx_buffer1[0];
}
void TestVolt(void)
{
  char Ready,BusyTone,BusyTone2,Delta,LastBussy;
  char Result = 0x0F;

   if (ValumeValueBuf>250)return;

   ADCSRA = 0x84;               // enable AtoD
   ADMUX = 0x66;
   #asm("nop");
   ADCSRA|= 0x40;                // start AtoD
   while(!(ADCSRA & 0x10));
   Ready = ADCH;
   SignalTstCnt++;
   //if(Ready>100)Busy_Det_Value= Ready-100;
   //else Busy_Det_Value=0;
   Busy_Det_Value= Ready-100;
   if (Ready> (BusyVolume+100) ){
         DOT=1;
         PORTG |= 0x02;
         if (!SignalHighDet) BussyBounse=0;
         SignalHighDet=1;
   }else {
         DOT=0;
         PORTG&= ~0x02;//SignalMaxCnt++;
         if (SignalHighDet) BussyBounse=0;
         SignalHighDet=0;
   }
   if (BussyBounse<10) BussyBounse++;

   if (BussyBounse>5){
         if (SignalHighDet){
              if (SignalMaxCnt<250)SignalMaxCnt++;
         }else
              if (SignalMinCnt<250)SignalMinCnt++;
   }

   if (Ready> (BusyVolume+100)) {
         //PORTG |= 0x02;
         if (!SignalHighDet2) BussyBounse2=0;
         SignalHighDet2=1;
   }else {
         //PORTG&= ~0x02;//SignalMaxCnt++;
         if (SignalHighDet2) BussyBounse2=0;
         SignalHighDet2=0;
   }
   if (BussyBounse2<10) BussyBounse2++;

   if (BussyBounse2>5){
         if (SignalHighDet2){
              if (SignalMaxCnt2<250)SignalMaxCnt2++;
         }else
              if (SignalMinCnt2<250)SignalMinCnt2++;
   }
   BusyTone=SogBusyTone;  //AUTO BUSSY DET 
   BusyTone2=SogBusyTone2; 
   if ((BusyTone==0)&&(BusyTone2==0)){//for auto adjust mode
          if ((BussyBounse == 5) && (!SignalHighDet)){
                LastBussy=(SignalMaxCnt+SignalMinCnt)/2; //HighSpeed
          }            
          BusyTone=LastBussy*0.9 ;
          BusyTone2=BusyTone*1.1;  
   }   
   Delta=BusyTone/5;//mak 20% +/-    //AUTO BUSSY DET 
   
   if ((BussyBounse == 5) && (SignalHighDet)){
    BussyTIM= SignalMinCnt/22.5;
   	if ((!HighStableDet)&&(SignalMinCnt>((BusyTone-Delta)*2))
   	                                &&(SignalMinCnt<((BusyTone+Delta)*2)))
   	    if (SignalResult)SignalResult++;
   	    else SignalResult=0;
   	SignalMinCnt=0;
   	HighStableDet=1;
   }
   if ((BussyBounse == 5) && (SignalHighDet2)){
   	if ((!HighStableDet2)&&(SignalMinCnt2>((BusyTone-Delta)*2))
   	                                &&(SignalMinCnt2<((BusyTone+Delta)*2)))
   	    if (SignalResult2)SignalResult2++;
   	    else SignalResult2=0;
   	SignalMinCnt2=0;
   	HighStableDet2=1;
   }
   if ((BussyBounse == 5) && (!SignalHighDet)){
        if ((HighStableDet)&&(SignalMaxCnt>(BusyTone*2))
                                        &&(SignalMaxCnt<(BusyTone*3)))
            SignalResult++;
   	    else SignalResult=0;
   	SignalMaxCnt=0;
   	HighStableDet=0;
   }
   if ((BussyBounse == 5) && (!SignalHighDet2)){
        if ((HighStableDet2)&&(SignalMaxCnt2>(BusyTone2*2))
                                        &&(SignalMaxCnt2<(BusyTone2*3)))
            SignalResult2++;
   	    else SignalResult2=0;
   	SignalMaxCnt2=0;
   	HighStableDet2=0;
   }
   ADCSRA = 0;               // Disable AtoD
}

