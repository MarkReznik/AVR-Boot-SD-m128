//"Ver323 05/09/24")
//2 sec power up delay on MP3 

//2L-Version!!!  - see also 12c64.c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//2L-Version!!! //ADD SWITCH //RR++

//ADD RST RELAY //RR+    VER 320

// FIX3   - last fixes (see Strig.c file too)
// FIX3B  - Reduce LCD Pulse  time 
//FIX4 FIX app show error 
//FIX6 fix exit fast problem from menu and show app number (also in string.c)
//FIX7 fast Dhsh exit ;Defult menu,Dip NO name TO (also string.c and define.h)
//FIXTIME  Fixing time during PU
//FIX MENU

// FIX NAME ENG
// FIX NAME HEB
// 2LINE MODE
//DIAL #* in ISO_MODEM
//AUTO BUSSY DET in ISO_MODEM
//No Keypad during modem connection(last cahnges ) 

//U_D
//WaitTill_BusyTst  - test disconnect signal 





//FIX1  (elegant.c elegant.h Strings)

//FIX2B menue exit mode - fast pressing  

//250 CHANG -define
//'199' to '250' -elegant 
//MEM def X2  Proxy X6 -define  
 //ADJ DISP - string 
 //LONG STAR  - button +define +elegant 
 //StarDhsh - elegant 
 //2 Lines 
 //6 Proxy  proxy 6+  
 //0402 0404 
 
// replace * and 1 proxy//Done  
//check 101 201  //done
//finish 0401 
//add dial *#f
//add auto bussy detect 
//inc no of floor ?

//Pproxy
//Pproxy+  improved    !remove //PxyFas
//Pproxy++  solve 255 problem  !remove //PxyFas


// RECALL   fixing recall time out 

 //VER 2.2 // CALL not according to offset fixing 
//FIXING # Error Ver 2.3
 
 //swap Prxy CODE
 //PxyFast
  //Long BEEP  
   //One Beep
   //Status Light
   //TONE Problem 
   
   //LONG 8   (8 CHAR ID card ) 
   //ORG_Was_Start 
   //Speech time 
   //New ENG PLACE   

   //PLACE  not finish also on STRING 

//Move Next Phone if door not oppen  

 // Next_Ring - replace camera time with redial time 
 //FIXing stack problem 
 
// CounterSecond=0; //ACURATE 
//REDIAL 3  same value for speach busy and confrim 

//DTMF_Dly_Break was added 
//ShuntMicTime was updated on Modem

//VER280- Wait_DoorOpen_Now value if valid  ProxyValid=0
//VER282- Rly1/2 togel ADD.VAL 3-4-5 (456) to no name - 30099->0415-99-30015 04-9915 flooor15app99 upto f99a15 4(5)0-999 tel1-tel4 5(6)f0-9a99 tel1-
//VER 282 + Alon
//Ver277-MdmRepir

//Clear Y/N
//00 name 
//PRXO  - fix forget PRPOXY tages  
   //PRXO-MemShow  - show  found PRPOXY tages  
      //Floor_fix
//LCD
     //fix disply stack //reset LCD
      //fix voice stack //fix voice
      // fix forget YN answer //Fix YN  
      ////Reset after **  
      //fix ? LCD problem //?


/*********************************************
//3.open door & floor message improve

This program was produced by the
CodeWizardAVR V1.0.2.2d Standard
Automatic Program Generator
© Copyright 1998-2002
Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.ro
OC:\cvavr\MyProject\TestUart1\TestUart1.cof
e-mail:office@hpinfotech.ro , hpinfotech@xmail.ro

Project :
Version :
Date    : 14/03/2002
Author  : Hadar Asaf
Company : HESS Home Solution LTD
Comments:


Chip type           : ATmega128
Program type        : Application
Clock frequency     : 4.000000 MHz
Memory model        : Small
Internal SRAM size  : 4096
External SRAM size  : 0
Data Stack size     : 1024
*********************************************/
// Standard Input/Output functions
#include <stdio.h>
#include <mega128.h>
// Standard String functions
#include <String.h>
#include "FuncMain.h"
#include "Define.h"
//#include "ISO_Modem.h"
#include "Relay.h"
#include "EEprom.h"
#include "FuncBit.h"
#include "Strings.h"
#include "LCD.h"
#include "Button.h"
#include "iso_modem.h"
#include "I2C64.h"
//#include "Zones.h"
//#include "Events.h"
//#include "Time.h"
//#include "StatusLed.h"
//#include "SaveData.h"
//#include "Timer.h"
//#include "Telphone.h"

#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7
#define Pry_Wide 5

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 80//200
#define RX_BUFFER_SIZE01 130//50


// USART0 Transmitter buffer
#define TX_BUFFER_SIZE0 50//250
#define TX_BUFFER_SIZE1 80//40

#define  C_LineName 400

// Declare your global variables here


// USART0 Receiver buffer
char rx_buffer0[RX_BUFFER_SIZE0];
char MDM_buffer[80];
unsigned char rx_wr_index0;


// USART0 Transmitter buffer
char tx_buffer0[TX_BUFFER_SIZE0];
char tx_buffer[30];
unsigned char tx_rd_index0;
// USART1 Transmitter buffer
//char tx_buffer1[TX_BUFFER_SIZE1];
unsigned char tx_rd_index1;

//****************************  NEW ***************
unsigned char FlagTestButton;
unsigned char  ListName;
unsigned char  Order[NAMEN+2];
unsigned char BigName;
unsigned char CounterRing;
unsigned char  FlagRing;
unsigned char CounterDefult;
unsigned char WaitTime,OpenDoorTime,LightTime,RingTime;
unsigned char RemotCNT,CounterLight;
unsigned char CounterWait,FlagWait,CounterOpenDoor,FlagOpenDoor;
unsigned int SirenWith, ChangeSiren ,CounterSound,LineName;
unsigned char SugSound;
unsigned int   NamePointer,NamePointerN1,NamePointerN2,NamePointerN3,NamePointerTmp,ReturnValue;


//*************************************************
//char BuferToPC[30]; // bufer of PC

unsigned char TimeOfTimeOut;
//unsigned char ConectPC;
//unsigned int CountConectPC;
unsigned char ValueChecsum;
//unsigned char pBufer;             // Help for sending to PC
unsigned char StatusUart;
unsigned char CountTry;               // count of trying send to one bord
unsigned char RCountTry;              // count of trying send to all bords
unsigned char Tor;//, TorPIR, TorRPM, TorCDR, TorTRM, TorSHB;          // index of Array RealTime
//unsigned char NumPIR;
unsigned int  StutLine1;               // Number of first line
unsigned int  StutLine2;               // Number of second line
unsigned char Button;                 // Status of button
unsigned char CountCanSend,RedialThis;           // if count == READY you can send
//unsigned char CycleRealTime;
unsigned char RealTime[12];            // data of comand
                 // 0 - get device type
                 // 1 - get key
                 // 2 - send led
                 // 3 - send sound
                 // 4 - display 2 lines
                 // 5 - clear bit
                 // 6 - get key again
                 // 7 - light LCD
                 // 8 - turn off LCD
                 // 9 - get status
                 // 10 - Write data to PC
                 // 11 - to info status of system
//unsigned char RealTimePIR[12];            //  comand  of PIR
                 // 0 - get device type
                 // 1 - get key
                 // 2 - Turn On/Off Camera or Microfon
                 // 3 - Read from flash
                 // 4 - Write to flash
                 // 5 - Clear Bit Status
                 // 6 - get status
//unsigned char RealTimeRPM[12];            //  comand  of RTP

//unsigned char RealTimeCDR[12];            //  comand  of CODER

//unsigned char RealTimeTRM[12];            //  comand  of Tamper

//unsigned char RealTimeSHB[5];            //  comand  of Shabat

//unsigned char StatusTamper[17];           //  status of tampers
                       // 0x03  -  Speed
                       // 0x04  -  Master on/off
                       // 0x08  -  Room   on/off
//unsigned char RealTimeCLK [4];

//unsigned char StatusMode1, StatusMode2, StatusMode3;
//unsigned char NumMode, StatusCond;

//unsigned char TypeRealTime;
                 // 1 - Keybord
                 // 2 - PIR

unsigned char NumBit;                 // num of bit to clear from status of bord
unsigned char Beap;                   // num of sound to send
                 // 1 - chime sound.
                 // 2 - bypass sound (3 beeps high tones sound).
                 // 3 - zone open sound (2 beeps low tones sound).
                 // 4 - confermation sound.
                 // 5 - warning sound (long low tone).
unsigned char StatusGet;              // status resiev of bords
//unsigned char StatusBypass;
//unsigned char PauseBypass,  PauseBypassFlag, FlagCloseZone;
unsigned char FlagDisplay;
//**************************  type of menu **********
unsigned char Status;                 // status of system
unsigned char Level;                  // level of menu
unsigned char pN;                     // number of menu in level
unsigned char MaxMenuN;               // max number of menu in level
unsigned char MaxMenuD;               // max level in menu
unsigned char HNext[7];               // num of enter in all 6 levels
unsigned char NextCode;               // pointer to word
unsigned char List;                   //
unsigned char Change;                 // if 1 have to change
unsigned char ChangeWord, ValueWord;             // save word to change
unsigned char MaxNum;                 // max num of words in telephone or name
unsigned char Maximum;                // max num of telephone or name
unsigned char Data[17];               // string of data from eeprom
//unsigned char DataToPC[17];           // string of data for PC
//unsigned char DataType[17];           // string of zone type
//unsigned char DataSenset[17];           // string of zone type
//unsigned char ClosePIR[17];
//unsigned char ShortCut;               // help enter to mene
unsigned char StutWord;               // if == 0x20 word gadol else litle
//unsigned char ButtonSACB;

//************************  type of bord **********
unsigned char AllBords;//, AllBordsPIR, AllBordsRPM, AllBordsCDR, AllBordsTRM,AllBordsSHB;               // all bords
unsigned char IndexBord;              // poiner to bord
unsigned char MaxBord;//, MaxBordPIR, MaxBordRPM, MaxBordCDR, MaxBordTRM,MaxBordSHB;                // number of bords

//************************* Test Zones ***************

//unsigned int  StatusY_N, StatusY_N2;              // y/n Questions from eeprom
//unsigned char CanTestZone;
//unsigned char CounterTestZone;
//unsigned char TimeNotTestZone;
//********************** Difolt ************************
//unsigned char  StatusDifolt, NextDifolt;

//************************** SIREN *****************
//unsigned char CounterChimeSiren;     //Counter of chime siren
//unsigned char ValueSiren;
//unsigned char CounterSirenLight;
//unsigned char ValuePause;
//unsigned char ValueCycles;
//unsigned char CloseSiren;
//unsigned char ValueLight, ValueDoor;
//unsigned char LightByte;
//unsigned int SirenWith, ChangeSiren;
unsigned char ValueExit;       // time of exit or enter
//unsigned char OpenDoor;     // OpenDore = open door in enter or exit time
//unsigned char FlagStopSiren, FlagSirenAll ;
//******************** Conect to moked *************************
//unsigned char TimeOut1_rx;

//****************************  ARM ***************
//unsigned char StatusArm;              // if True system in statu Arm
//unsigned char StatusVolt, StatusAcBat;//, pVolt;             // if 1 Not AC if 2 have to display
//unsigned char AutoArm;
//unsigned char ButtonChime;
          // 0x01 - Stay_1
          // 0x02 - Stay_2
          // 0x04 - Away_1
          // 0x08 - Away_2
          // 0x10 - Chime
          // 0x20 - Test of key if 0 -> close
//unsigned char DisplayZone;       // if bit DisplayZone up & bit zone up  -> display zone

//****************************  Codes ***************

unsigned char AppCode  [4];    // array of code to test //0402
unsigned char UserCode[10];    // array of code to test
//unsigned char CodeOfCoder[7];    // array of code from coder
//unsigned char TimeOpenCoder, SoundCoder;
//Asaf
unsigned char AppDisplayTO;
unsigned short Dsp_Connect_T,BusyTstTO_Timer,BusyTstT,ConfimTstT,ConfimTstT_CNT,RedialTime,OpenDoorTestCNT;  //REDIAL 3
//Asaf
//unsigned char ValueCode;      //
//unsigned char CountMadCode;
//unsigned char CodeBypass;

//****************************** Counters of Program **************
unsigned int  ConterPauseRing,CounterRlySecond,MaxEEpromV,RST_R_TimOut;
//unsigned char  Flag2Second;
unsigned char  CounterSecond,Show_NextDial;
unsigned int CycleArm0, CycleArm1, CycleArm2, CycleArm3,AddedValue,NewAppNo,View;
//unsigned int  TimeListZone;
unsigned char  TimeChangeWord;
unsigned char   TimeEntToArm, TimeWasSiren, TimeMenu;
//unsigned char TimeLoGo;
//unsigned char CounterSubSys;
//unsigned char CountStopSirenAll;
//unsigned char TimeSpikeFire;

//***************************** 1/8 byte **********************************
bit Checsum, WasReceiving, CanSend, SendedToAll,MINUS,PowerFail,StarPass;
//bit CallSirenUp, WasSiren, CanNotBypass, CycleListZone, OpenZoneKey;
bit  MainCycle, Sending,DialTime,RST_R_Pin,DOT,TogleAppShow;//FIX6
bit FlagOneSec , FlagNotSend,NeetToDialFlge;// PanicWord;
unsigned char  CountCode2,CodeTest2,HoldRemoteRly,Bits_CNT1; // Bits_CNT1 Bit 0=*#p- , 1=line1/2 ,2 = End?
unsigned char NamePointer2,SpeechOneSec,EE_WriteDone,AllRdyShow;
unsigned char SwapLine23_12;
//char FlagAmbush;
//char ChangeCountMadCode, SecondPassword, Shabat, AmbushCodeFind;
//char FlagStatusCode, CloseAlways, SoundAlways;
//char FlagStopSirenAll, FlagDial, FlagSiren;
//char SpikeBypass;
//char FlagSpiker;
//char FlagDawnLoad;
//char FlagCycleList;
//char FlagTestTel,FlagCanTestTel;
//char FlagDefolt;
//char TimeTestBat;
//char SysNotOk , BordWord;
//char StartAlarm;
//char OpenAlways;
//char FlagWithMoked;
//char FlagSubSys;
//char FlagTecEasy;
//char FlagFirstDial, FlagFirstCallBack;
//char FlagWriteTime;
char EnterSound,LastLocaName;

char FlagTecUserCode,Floor_Test; //Floor_fix
unsigned char WelcomeTime;
//char FlagFire;
//char FlagZoneReady;
char BuferSlavePointer[4];
char BuferSlaveStatus[4];
unsigned char DataCode[10];
unsigned char fourline,DUMMY,secCNT,FlagPrySec,PrySecCnt,CuzPryCycl,PrxyCnt,MarkAsOne
,PrxyResult,PrxyStartSine,NoOfPulse,WasHigh,ProxyValid,PxySum,CodeReg,PxyErr,Auido_Sound,Audio_Cmnd,ii,Audio_Tx_Cnt,Pulse_Width
,Audio_Val,VoiceIC_Mode,Call_Pulse,Snd_Relay,Reminder,Tx_Max_Char,EnglishMode,EraseAllDone,WaitTime2,OpenDoorTime2,Rly12Ind,
Rly1End,Rly2Start,FlagWait2,CounterWait2,CounterOpenDoor2,FlagOpenDoor2,FastStpValue,YesNoAnswer,DoorForget,PxyCodeTime,PxyCodeCnt,
DETcnt,DETPin,WelcomeCounter,MAGcnt,MAGPin,MAGCounter,FloorMesCnt,AppCalled,NameMesCnt,AnnounceTime,ResetVoice,MessageOnOff
,FloorTime,BellSaveValue,AppCntCode,AcssesCodeTO,CountCode,DisplaySelected,DisplayNameList,WaitDisplay,DisplyList
,DispSelect,ClearSelect,TypeRam,AddedType,Type456SelTel,YesNoAnswer2,RST_Rcnt,Index_R,PanelNumber,BoardQty;//MMM
unsigned HighStableDet2,SignalMaxCnt2,SignalResult2,BussyBounse,SignalHighDet2,SogBusyTone2,HighStableDet,SignalMaxCnt,SignalResult,SignalHighDet
,SignalMinCnt2,SignalMinCnt,SogBusyTone,BussyBounse2,SignalTstCnt,ValumeValueBuf,FinshDialFlag,StartDialFlag,LineWasBussyFlag,Ringing,SignalHighTst
,ShuntMicTime,DTMF_Dly_Break,AnsMD_timeOut,AnswerAsModem,RingNumber,ReceivedData,TimeTestSystem,ConectPC,MDM_Reply_Mode
,rx_index_m1,CS_test,Wait_Tx1,MDM_oneSec,MDM_oneSecCnt,ToneDigCNT,DtmfExsist,DTMF_TestN,Tone_Dchr_cnt,ToneOKcnt,PauseButton,DelayBetweenTone
,ConfirmTONE,NextDailMode,DialingTo,TelNotConfirm,TIM_ADJ,One_Min,Hours,Minutes,Days,
Timer1D,Timer1SH,Timer1SM,Timer1PH,Timer1PM,Timer2D,Timer2SH,Timer2SM,Timer2PH,Timer2PM,Timer3D,Timer3SH,Timer3SM,Timer3PH,Timer3PM,QuitCallDet,
Timer4D,Timer4SH,Timer4SM,Timer4PH,Timer4PM,TimerStatus,AMP_ON_OFF,Show_Clock,Secounds,No_Floor_Mess,PC7WasHigh,PC7Cnt,TimeOut50Msec,FreqCallDet,
CallSign,CallCnt,FreqBussyDet,BussySign,BusyVolume,BusyFrq,CallLowF,CallHighF,CallBreak,NoOfCall,Rec597Data,ReadWriteClk,Last597,Rec597Long,
Busy_Det_Value,Tone_Dchr_cntB,Tone_Dchr_cntC,Tone_Dchr_cntD,rx_DataPoint,NoMore,MDM_Report,MDM_tx_time
,SelectedSpeed,MDM_Data,BussyTIM,PassWordTstNeeded,BussyNum,FLAGS,Point,MDM_Reply_M,MDM_index,Force_Rest,EndAnsMD_timeOut
,SafeDisp,NoConstantOpen,MemAppCntCode,T_R_TimeOut,Valid_BusyAck;

unsigned char  Class,PxyDirDone,Directory_Found,MSB_value,PrxyQty,PrxyStart,Force_it;//PxyFast   
unsigned char  WaitForExit;//FIX2B 
unsigned char DoNotDisp_AppNo;// FIX6
unsigned int MDM_Address;

unsigned char ProxyValue; //Pproxy

unsigned char MEM_Class,MEM_Location,Rst_LCD,Full_Reset;//PRXO-MemShow 
unsigned char  Scan_Pointer,Erase_ORG_Was_Start;//CLASS 
unsigned char  Type4App,Wait_DoorOpen_Now,Max_Speech_Time;//0402
unsigned char  Used_Cell,Found,Tst_Exist,AllReady_in_Mem,write_Aloowed,Saved_Char,Show_Used,Pxy_Timer,Tags_QtyDisp,testi;//PRXO
unsigned char WaitTill_BusyTst,ProxyStore;//WaitTill_BusyTst
unsigned short SpeechTime;
unsigned short Info_Disply,Tags_Qty;//PXYOO 
unsigned ToneKey[3],RecToneKey[3];

char NameRelay;  // CALL not according to offset fixing
unsigned char  Dial_This,Voice_Sug,Max_Tx_Buff,tx_index,Close_Door_TO,ThisDailMode,NO_Close_Door_Mes;
unsigned short CheckSum;
unsigned char Wait_For_Volume,Voice_Reset,Voice_End;
/*** MARK MODIFICATIONS START***/
// Uncomment #define DEBUG_LCD to use for debug
#include "sdboot.h"

/*** MARK MODIFICATIONS END***/
void main(void)
{
  // char ind;
/*** MARK MODIFICATIONS START***/  
  unsigned char u8_test_result;   
  unsigned char testbuf[0x20];
/*** MARK MODIFICATIONS END***/   
   EnglishMode=0;
   //WDTCR = 0x00;
   WDTCR = 0X1F;   // WD 2 SEC
   WDTCR = 0X0F;   // WD 2 SEC
// Declare your local variables here

// Input/Output Ports initialization
// Output - 1 DDR
// Input  - 0 DDR
// port 0 - NO
// port 1 - Yes
// Port A
PORTA=0x48;//00;
DDRA=0x59;//f0;

// Port B
PORTB=0x08;//89;
DDRB=0x07;//77;

// Port C
PORTC=0x00;//0x18;
DDRC=0xff; // 0xe7

// Port D
//PORTD=0xD0;
//DDRD=0xC8;
// last DDRD=0x3C;
PORTD=0x80;//f0;
DDRD=0x61;//2B;

// Port E
PORTE=0x06;//07;
DDRE=0xFe;

// Port F
PORTF=0x10;
DDRF=0x90;//RR++

// Port G
//PORTG=0x09;
//DDRG=0x12;
PORTG=0x1C;//09;
DDRG=0x07;//16;//PRXY TEST + EEPROM A

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 15.625 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x06;
ASSR=0x00;
TCNT0=0x4B;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00; //for 200+usec put 0x08 0x3f
OCR1AH=0x01;//0x00; //01 32usec 8mz -4m  was 02 for 128 usec intrrupt
OCR1AL=0x3f;//0x08; //00 32uf 8mhz-4m was 00//now 16 usec interrupt
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 15.625 kHz
// Mode: Normal top=FFh
// OC2 output: Disconnected
TCNT2=0x00;
OCR2=0x9c;//0xf9; for 4m   // 7f for 8m hz
TCCR2=0x0c;//0x0b; for 4m  // 0c for 8mhz
/*
TCCR2=0x0B;
TCNT2=0x63;
OCR2=0x00;
  */

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: 500.000 kHz
// Mode: Fast PWM top=OCR3A
// OC3A output: Toggle
// OC3B output: Discon.
// OC3C output: Discon.
TCCR3A=0x43;
TCCR3B=0x00;
TCNT3H=0x00;
TCNT3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=0x00;
EICRB=0x00;
EIMSK=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
//TIMSK|=0x80;
TIMSK|= 0x94;
ETIMSK=0x00;

// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud rate: 9600
UCSR0A=2;//(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (1<<U2X0) | (0<<MPCM0);
//UCSR0B=0x18;//NO  INT   (1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) 
UCSR0B=0x58;//TX INT D8 tx/rx int    (1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
UCSR0C=0x0E;//2 stop bits (0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (1<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
UBRR0H=0x00;
UBRR0L=0x81;  

// USART1 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART1 Receiver: On
// USART1 Transmitter: On
// USART1 Mode: Asynchronous
// USART1 Baud rate: 2400

/*UCSR1A=0x00;
UCSR1B=0x00;
UCSR1C=0x00;
UBRR1L=0x00;
UBRR1H=0x00;*/
// USART1 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART1 Receiver: Off
// USART1 Transmitter: On
// USART1 Mode: Asynchronous
// USART1 Baud rate: 300 with 4MHZ
/*UCSR1A=0x00;
UCSR1B=0x48;
UCSR1C=0x06;
UBRR1H=0x03;
UBRR1L=0x40; */
// USART1 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART1 Receiver: On
// USART1 Transmitter: On
// USART1 Mode: Asynchronous
// USART1 Baud rate: 300 with 10 MHZ

UCSR1A=0x00;
//UCSR1B=0x48;
UCSR1B=0xD8;
UCSR1C=0x06;
//UBRR1H=0x08;//300
//UBRR1L=0x22;//300
//UBRR1H=0x04;//600
//UBRR1L=0x11;//600
UBRR1H=0x02;//900
UBRR1L=0xB5;//900
//UBRR1H=0x02;//1200
//UBRR1L=0x08;//1200

// USART1 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART1 Receiver: On
// USART1 Transmitter: On
// USART1 Mode: Asynchronous
// USART1 Baud rate: 2400


UCSR1A=0x00;
UCSR1B=0x00;
UCSR1C=0x00;
UBRR1L=0x00;
UBRR1H=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
// Analog Comparator Output: Off
ACSR=0x80;
SFIOR=0x00;

// Global enable interrupts
#asm("sei")

/*** MARK Modification start***/
//main_app(); v17
/* initialize the LCD for 2 lines & 16 columns */
//#define DEBUG_LCD inside sdboot_app.c 
#ifdef DEBUG_LCD  
  lcd_init(16);
  lcd_clear();
  lcd_putsf("TST ");
  lcd_putsf(SD_NAME);  
  lcd_putsf(" ");
  lcd_putsf(SD_VER);
  delay_ms(DEBUG_LCD_MSG_MS);
#endif 
//1. SdDataFileStatus() check the DATA4K file exists to to read write 4K data 
//Return 0: OK
if((u8_test_result = SdDataFileStatus())==0)
{
//2. Erase data4k 4096 bytes by fill space char ' ' 0x20
//Return 0: OK
#ifdef DEBUG_LCD
    lcd_clear();
    lcd_putsf("Data4k Ok");
    delay_ms(DEBUG_LCD_MSG_MS);        
#endif
    if((u8_test_result = SdDataErase(4096, ' '))==0)
    {
#ifdef DEBUG_LCD
    lcd_clear();
    lcd_putsf("Erase Ok");
    delay_ms(DEBUG_LCD_MSG_MS);        
#endif
//3. Write Data test
//Return 0: OK
//unsigned char SdDataFileWrite(unsigned char *p_u8_data_buffer, unsigned long u32_data_offset, unsigned int data_length, unsigned int *p_u16_read_bytes)
        strcpyf(testbuf, SD_NAME);
        strcatf(testbuf, " FW ");
        strcatf(testbuf, SD_VER);
        strcatf(testbuf, "\r\n");
        SdDataFileWrite(testbuf, 0*15, 15, &nbytes);
        strcpyf(testbuf, "erase done ok\r\n");
        SdDataFileWrite(testbuf, 1*15, 15, &nbytes);
        strcpyf(testbuf, "write done ok\r\n");
        SdDataFileWrite(testbuf, 2*15, 15, &nbytes);
//4. Read Data test
//Return 0: OK
//unsigned char SdDataFileRead(unsigned char *p_u8_data_buffer, unsigned long u32_data_offset, unsigned int data_length, unsigned int *p_u16_read_bytes)
        if((u8_test_result = SdDataFileRead(testbuf, 2*15, 15, &nbytes))==0)
        {
            if(testbuf[0]=='w' && testbuf[12]=='k')
            {
                strcpyf(testbuf, "read  done ok\r\n");
                SdDataFileWrite(testbuf, 3*15, 15, &nbytes);
            }
            else
            {
                strcpyf(testbuf, "readwkfailed \r\n");
                SdDataFileWrite(testbuf, 3*15, 15, &nbytes);
            }
        }
        else
        {
            strcpyf(testbuf, "read  failed \r\n");
            SdDataFileWrite(testbuf, 3*15, 15, &nbytes);
        }
//5. Rename function use exact 8 chars in filename
//Otherwise only first filename part will compared then renamed 
        
        if(SdRenameFile("NAME0001", "NAME0004"))
        {
            #ifdef DEBUG_LCD
            lcd_clear();
            lcd_putsf("Rename failed");
            delay_ms(DEBUG_LCD_MSG_MS);        
            #endif
            strcpyf(testbuf, "rename1 failed\n");
        }
        else
        {
            #ifdef DEBUG_LCD
            lcd_clear();
            lcd_putsf("Rename Ok");
            delay_ms(DEBUG_LCD_MSG_MS);        
            #endif
            strcpyf(testbuf, "rename1 passed\n");
        }
        SdDataFileWrite(testbuf, 4*15, 15, &nbytes);        
        if(((FindFileName("", "NAME0001",1))==0)&&((FindFileName("", "NAME0004",1))!=0))
        {
            #ifdef DEBUG_LCD
            lcd_clear();
            lcd_putsf("Rename check Ok");
            delay_ms(DEBUG_LCD_MSG_MS);        
            #endif
        }
        else
        {
            #ifdef DEBUG_LCD
            lcd_clear();
            lcd_putsf("Rename chk Fail");
            delay_ms(DEBUG_LCD_MSG_MS);        
            #endif
        }
//6. check if TRY4,3,2 exists(means Boot copy the UPDATE to Flash App) then rename TRY to DONE
//Return 0: Files ready to get new Firmware Update data after Buckup file is ready. 
        u8_test_result = SdUpdateStatus();
        if(u8_test_result==0)
            strcpyf(testbuf, "updat done ok\r\n");
        else
            strcpyf(testbuf, "update failed\r\n");
        SdDataFileWrite(testbuf, 5*15, 15, &nbytes);
        //on TEMPDATA file exists fill some data
        if(u8_test_result==0)
        {
/** Example to fill data to TEPMDATA file then rename it to UPDATE ****/
//7. Fill "TEMPDATA" file with update file data
            strcpyf(testbuf, "this is update.");
            if(u8_test_result = SdUpdateFileWrite(testbuf, 0, 15, &nbytes))
            {
                strcpyf(testbuf, "updt fill fail\r\n");
            }
            else
            {
                strcpyf(testbuf, "updt fill done\r\n");
            }
            SdDataFileWrite(testbuf, 6*15, 15, &nbytes);
        } 
    }
}
else
{
#ifdef DEBUG_LCD
    lcd_clear();
    lcd_putsf("Data4k Fail");
    delay_ms(DEBUG_LCD_MSG_MS);        
#endif
}  
/*** MARK Modification end***/

//ToZeroTime();

RelayOff();
Riset();
Pointer = Name;
MaxNum = CMaxName;


//OrderName();
OrderNameRead();
CanSend = 1;
WasReceiving = 0;
Checsum = 0;
TimeOfTimeOut = MS_5; // now time out 5 Ms
ClearRealTime();
ConectPC = 1;

TimeOfTimeOut = MS_5; // now time out 5 Ms
TIMSK&= ~0x01; // close timeout
//UCSR0B&= ~0x20; // disable interapt send

StartFunc();

AllBords = 0x01;

RealTime[0] = 0xff;

TimeTestSystem = 56;
CanSend = 1;

PORTD|= 0x2; //set EE data to 1
FlagTecUserCode = 0;

PORTB |=0x2;//clk=1

ResetVoice=4;  //make voice reset and set the valume

TIM_ADJ=1;

Time_Up(); //Update time and limit
//FIXTIME
//DataReadPCF(2,1,&Data[0]);//read Secounds
//TIM_ADJ=(Data[0]&0xf0)*10+(Data[0]&0xf);
//One_Min=TIM_ADJ-0x10;
//TIM_ADJ=0;
//FIXTIME

EnglishMode=0;
     if (!(PIND&0x80)){
          #asm("NOP");
          #asm("NOP");
          if (!(PIND&0x80))EnglishMode=1;  
}
PORTC |=0x1;// hold light  
if (MCUCSR&0x7){
        PORTF &=~0x10;//RR++ 
        Voice_End=5;   
        StartEE();
}
else{
        CounterDefult = 51;
}
MCUCSR=0x0;
//StartEE();

AMP_ON_OFF=0;  // Realse all AMP indicators 
//PORTB |=0x20; // Realse Talk mode 
FLAGS=0;
//Erase_ORG_Was_Start=250;  //PRXO

DUMMY=0;
Rst_LCD=0;
Full_Reset=0;
Voice_Reset=0;

 PawerUp(); //** reset 
                


while(1)
{
              unsigned char i;
             // EnglishMode=1; 
              #asm("WDR");  
//             DDRE |=0x2; 
//             PORTE ^=0x2;
              if (Wait_For_Volume){ 
                     Wait_For_Volume--;
                     if (Wait_For_Volume==5){ 
                               Pointer = SpeechLevel;
                               MaxNum =  CMaxSpeechLevel;
                               ReadData(1);
                               Audio_Val= (Data[0]&0xf);//Set VoiceLevel 
//                               if (Audio_Val==0)MessageOnOff=0;//FIX1 no message when valume =0 
//                               else {  
                         //                         tx_buffer[0]=0x7E;  //play 3 
                         //                         tx_buffer[1]=0XFF;
                         //                         tx_buffer[2]=0X06;//NO 
                         //                         tx_buffer[3]=0X06;//OPCODE
                         //                         tx_buffer[4]=0X00;//REPLAY 
                         //                         tx_buffer[5]=0x00;//
                         //                         tx_buffer[6]=Audio_Val*3+15;//volume data  9 1b
                         //                         CheckSum=tx_buffer[1];
                         //                         CheckSum=CheckSum+tx_buffer[2]+tx_buffer[3]+tx_buffer[4]+tx_buffer[5]+tx_buffer[6]-1;
                         //                         CheckSum=0xFFFF-CheckSum;                                                                   
                         ////                                                 
                         //                         tx_buffer[7]=CheckSum>>8 ;//0XFE;//cs 
                         //                         tx_buffer[8]=CheckSum&0xff;//0XF6;//$0                                     
                         //                                                  
                         //                         tx_buffer[9]=0XEF;                                                                           
                         //                         Max_Tx_Buff =9;//N-1                          
                         //                         tx_index = 0;        
                         //                         UDR0=tx_buffer[0];
                                                  tx_buffer[0]=0x7E;  //play 3 
                                                  tx_buffer[1]=0XFF;
                                                  tx_buffer[2]=0X06;//NO 
                                                  tx_buffer[3]=0X06;//OPCODE
                                                  tx_buffer[4]=0X00;//REPLAY 
                                                  tx_buffer[5]=0x00;//
                                                  tx_buffer[6]=Audio_Val*3+15;//volume data  9 1b
                                                                                                               
                                                  tx_buffer[7]=0XEF;                                                                           
                                                  Max_Tx_Buff =7;//N-1                          
                                                  tx_index = 0;        
                                                  UDR0=tx_buffer[0];                 
                        //       }                                                                                                             
                     }  
              }              
              if (write_Aloowed)write_Aloowed--;//PRXO  
                                        
             if (Wait_DoorOpen_Now)Wait_DoorOpen_Now--; 

            // EEprotect 
             if(!Status)PORTE |=0x4;//DISALBLE EE WRITE 
             else PORTE &=~0x4;//ENALBLE EE WRITE  
             
             if(Status == 1){ //DISP 4 Lines to 2 lines
                     if (Info_Disply<1500)Info_Disply++; 
                     else Info_Disply=0;
             }
             else {  
                  if (Info_Disply<2000)Info_Disply++;
             }//DISP 4 Lines to 2 lines              
             
             
 
                     

             
//              if (Erase_ORG_Was_Start){ //PRXO
//                    Erase_ORG_Was_Start--;
//                    if (!Erase_ORG_Was_Start){
//                         Pointer = ORG_Was_Start;//ORG_Was_Start
//                         MaxNum =  CMaxORG_Was_Start;   
//                         ReadData(1);  //PRG SHOW           
//                         if (Data[0]=='1') {
//                               ArrangPrxy1(); 
//                         }
//                         else if (Data[0]=='2'){
//                               ArrangPrxy2(); 
//                         }                                         
//                    }                
//              } //PRXO
               
             if (ProxyStore)ProxyStore--;//LONG 8   
             if (LineName){
                    LineName--; 
                    if ((!LineName)&&(DisplayNameList)){
                           LineName=C_LineName;
                          // s_nd_Line ^=1; //2 Lines 
                           Bits_CNT1 ^=0x2; //2 Lines 
                    }
              }              
              
              TimeOut50Msec++;
               
              while (Force_Rest){//make reset after modem connection 
                 #asm("NOP"); 
              }
           
              if (TimeOut50Msec>=12){  
                   TimeOut50Msec=0;  
                   if ((PC7Cnt>(BusyFrq-10))&&(PC7Cnt<(BusyFrq+10))){
                        if (FreqBussyDet<255)FreqBussyDet++;
                   } 
                   if ((PC7Cnt>CallLowF)&&(PC7Cnt<CallHighF)&&(CallHighF>CallLowF)){
                        if (FreqCallDet<255)FreqCallDet++;
                        if (((QuitCallDet>CallBreak)&&(QuitCallDet<250))&&(CallSign)){
                             if (CallCnt<255){
                                  CallCnt++;//count the outgoing call 
                             }
                        }
                        CallSign=0;
                        BussySign=0;
                        QuitCallDet=0;
                   }
                   else { 
                        if (FreqBussyDet>=4){ //min 200 msec bussy tone long 
                             BussySign=1;
                        }
                        FreqBussyDet=0;
                        if (FreqCallDet>=4){ // min 200 msec call tone 
                             CallSign=1;
                        }
                        FreqCallDet=0;                        
                        if ((PC7Cnt<5)&&(QuitCallDet<255)){
                             QuitCallDet++;
                        }
                   }
                   PC7Cnt=0;                  
              }
              
              if ((AMP_ON_OFF)||(Max_Speech_Time))PORTA &=~ 0x08;// Open Amp (0 = amp 1 buzzer 2 voice ) 
              else  PORTA |= 0x08;// Close Amp (0 = amp 1 buzzer 2 speech ) 

              if(Reset < 10)ResetFunc();   // reset
              TestTelephone();//test answer from modem  
              
              if (!BusyFrq)BussySign=1;// when BusyFrq=0 no bussy freq test needed 
              //if (!NoOfCall)CallCnt=0;// when no of call to test = 0 then no test need
                                                                     
              //if ((((SignalResult>BussyNum)||(SignalResult2>BussyNum))&&(!WaitTill_BusyTst)&&(BussySign))||(TelNotConfirm)||((CallCnt>=NoOfCall)&&(NoOfCall))){
             if ((((SignalResult>BussyNum)||(SignalResult2>BussyNum))&&(!WaitTill_BusyTst))||(TelNotConfirm)||((CallCnt>=NoOfCall)&&(NoOfCall))){
                         CallCnt=0;// clear call counter for next use
                            
                         if ((NextDailMode)&&(DialingTo<2)&&((BusyTstTO_Timer)||(TelNotConfirm))){
                              DialingTo++;
                              TelNotConfirm=0; // ready for next test  
                              ConfimTstT_CNT= 0;//only if Confirm time exsist test needed 
                              OpenDoorTestCNT=0; //Move Next Phone if door not oppen      
                              if (DialingTo==2){
                                    if (TimerStatus&0x1){
                                         Pointer = Tel6Num;
                                         MaxNum = CMaxTel6Num;
                                    }else {
                                         Pointer = Tel3Num;
                                         MaxNum = CMaxTel3Num;
                                    }
                                    ReadData(RedialThis);
                                    if((Data[0]>=0x23)&&(Data[0]<=0x66)){                   
                                             if (SpeechTime)ConfimTstT_CNT= SpeechTime;//only if Confirm time exsist test needed 
                                             if (RedialTime)OpenDoorTestCNT=RedialTime+RingTime; //Move Next Phone if door not oppen 
                                             if (SpeechTime)BusyTstTO_Timer=SpeechTime;//set the tets time value
                                             NextDailMode=2;  //dial
                                             Show_NextDial=1; //REDIAL 3  
                                    }else{
                                             if (SpeechTime)ConfimTstT_CNT= SpeechTime;//see//MUST BE -10//only if Confirm time exsist test needed 
                                             if (RedialTime)OpenDoorTestCNT=SpeechTime; //Move Next Phone if door not oppen 
                                             if (SpeechTime)BusyTstTO_Timer=SpeechTime;//set the tets time value 
                                             NextDailMode=1; //stop dial
                                    }                                                             
//                                         if(Data[0]==' ')NextDailMode=1; //stop dial
//                                         else NextDailMode=2;  //dial 
                              }
                              if (DialingTo==1){
                                    if (TimerStatus&0x1){
                                         Pointer = Tel5Num;
                                         MaxNum = CMaxTel5Num;
                                    }else {
                                         Pointer = Tel2Num;
                                         MaxNum = CMaxTel2Num;
                                   }
                                   ReadData(RedialThis);
                                   if(Data[0]==' '){
                                         DialingTo++;
                                         if (TimerStatus&0x1){
                                              Pointer = Tel6Num;
                                              MaxNum = CMaxTel6Num;
                                         }else {
                                              Pointer = Tel3Num;
                                              MaxNum = CMaxTel3Num;
                                         }
                                         ReadData(RedialThis);
                                         if((Data[0]>=0x23)&&(Data[0]<=0x66)){                   
                                                 if (SpeechTime)ConfimTstT_CNT= SpeechTime;//only if Confirm time exsist test needed 
                                                 if (RedialTime)OpenDoorTestCNT=RedialTime+RingTime; //Move Next Phone if door not oppen 
                                                 if (SpeechTime)BusyTstTO_Timer=SpeechTime;//set the tets time value
                                                 NextDailMode=2;  //dial
                                                 Show_NextDial=1; //REDIAL 3  
                                         }else{
                                                 if (SpeechTime)ConfimTstT_CNT= SpeechTime;//see//MUST BE -10//only if Confirm time exsist test needed 
                                                 if (RedialTime)OpenDoorTestCNT=SpeechTime; //Move Next Phone if door not oppen 
                                                 if (SpeechTime)BusyTstTO_Timer=SpeechTime;//set the tets time value 
                                                 NextDailMode=1; //stop dial
                                          }                                                             
//                                         if(Data[0]==' ')NextDailMode=1; //stop dial
//                                         else NextDailMode=2;  //dial 
                                   } else NextDailMode=2;  //dial
                              }
                         }
                         AppDisplayTO=1;//FIX1               
                         TimeConectedWithApp = 1;
                         LineWasBussyFlag=2;
                         ToneDigCNT=2;
                         RecToneKey[0]=0;
                         RecToneKey[1]=0;
                         SignalResult=0;
                         SignalResult2=0;
                         Tone_Dchr_cnt=0;
                         Tone_Dchr_cntB=0;
                         Tone_Dchr_cntC=0;
                         Tone_Dchr_cntD=0;                          
              }

             
             //no need? if ((SpkPnAmpOn)&&(DtmfExsist)&&(!(PINA & 0x02))){
             if ((DtmfExsist)&&(!(PINA & 0x02))){
 		           PORTF |=0x80;// open mic
 		           DtmfExsist=0;
 		      }else if ((!(PINA & 0x02)))PORTF |=0x80;// open mic
 		      
              //if ((PINA & 0x02)&&(DTMF_TestN)&&(!FlagOpenDoor)){
              if ((PINA & 0x02)&&(DTMF_TestN)&&(FlagHoldLine)){//TONE Problem 
                   DtmfExsist++;
                   PORTF &=~0x80;// close mic  for avoid DTMF signal from Mic
                   if (DtmfExsist>10){
                        PORTA &= ~0X40;
                        DTMF_TestN=0;
                        if (ToneDigCNT>=2){
                             ToneDigCNT=0;
                             RecToneKey[0]=0;
                             RecToneKey[1]=0;
                        }     
                        RecToneKey[ToneDigCNT]= PINF&0x0F;
                        if ((ConfimTstT_CNT)&&(ConfimTstT_CNT<SpeechTime-(DTMF_Dly_Break))){  //MUST BE -10// test if during confermation the correct tone receved                        
                             if (ConfirmTONE=='-'){
                                  ConfimTstT_CNT=0; //stop test 
                               //when confirmed by tone no need to confirmed by open door
                                  OpenDoorTestCNT=0;// 
                                  BusyTstTO_Timer=0; //REDIAL 3
                                  Siren_Start(3);   //confirm by siren tone
                             }else if (ConfirmTONE==RecToneKey[ToneDigCNT]){
                                  ConfimTstT_CNT=0;
                                 //when confirmed by tone no need to confirmed by open door
                                  OpenDoorTestCNT=0; 
                                  BusyTstTO_Timer=0; //REDIAL 3
                                  Siren_Start(3);                           
                             }
                        }
                        if (ToneKey[0]=='-')RecToneKey[1]=RecToneKey[ToneDigCNT];
                        if (ToneKey[1]=='-')RecToneKey[0]=RecToneKey[ToneDigCNT];
                        if (RecToneKey[ToneDigCNT]==13){
                              Tone_Dchr_cnt++;
                        }else  Tone_Dchr_cnt=0;
                        if (RecToneKey[ToneDigCNT]==14){
                              Tone_Dchr_cntB++; 
                        }else  Tone_Dchr_cntB=0;
                        if (RecToneKey[ToneDigCNT]==15){
                              Tone_Dchr_cntC++; 
                        }else  Tone_Dchr_cntC=0;
                        if (RecToneKey[ToneDigCNT]==0){
                              Tone_Dchr_cntD++;   
                        }else  Tone_Dchr_cntD=0;                        
                        if (( Tone_Dchr_cnt>=2)||( Tone_Dchr_cntB>=2)
                                      ||( Tone_Dchr_cntC>=2)||( Tone_Dchr_cntD>=2)){
                              if ( Tone_Dchr_cnt>=2)AnswerAsModem=1; 
                              else if ( Tone_Dchr_cntB>=2)AnswerAsModem=2; 
                              else if ( Tone_Dchr_cntC>=2)AnswerAsModem=3; 
                              else if ( Tone_Dchr_cntD>=2)AnswerAsModem=4;                               
                              if (AnswerAsModem)Siren_Start(2);
                              AnsMD_timeOut=60;//sec time out in sec
                              Tone_Dchr_cnt=0;
                              TimeMenu=2;
                              TimeConectedWithApp = 2; 
                              LineWasBussyFlag=1;
                              ToneDigCNT=2;
                              RecToneKey[0]=0;
                              RecToneKey[1]=0;
                        }
                        ToneOKcnt=0;
//                        if((ToneKey[0]==RecToneKey[0])||(ToneKey[0]=='-'))ToneOKcnt++; //FIX MENU
//                        if((ToneKey[1]==RecToneKey[1])||(ToneKey[1]=='-'))ToneOKcnt++; //FIX MENU
 
                        if((ToneKey[0]==RecToneKey[0]))ToneOKcnt=1; //FIX MENU
                        if((ToneKey[1]==RecToneKey[0]))ToneOKcnt=2;//FIX MENU 
                        if ((RecToneKey[0]==0XA)||(RecToneKey[1]==0XA)){//FOR 0 PRESS // Next_Ring - No Camera time
                                 OpenDoorTestCNT=0; 
                                 ConfimTstT_CNT=0; 
                                 AppDisplayTO=1;
                                 TimeConectedWithApp=2; 
                                 RedialTime=SpeechTime;//stop redialing  
                                 Siren_Start(2); 
                        } // Next_Ring - No Camera time  
                       // if(!ToneOKcnt) ToneDigCNT=2;//on first error clr cnt  //FIX MENU 
                        
                        if ((ToneOKcnt)){
                             if (ToneOKcnt==1){ 
                                  if (!OpenDoorTime){ 
                                          Pointer = Relay1MeM;//
                                          MaxNum =  CMaxRelay1MeM;
                                          ReadData(1);  //PRG SHOW 
                                          if (Data[0]=='0') {
                                                  Pointer = Relay1MeM;//
                                                  MaxNum =  CMaxRelay1MeM;
                                                  strcpyf(Data,"1");
                                                  WriteData(1);  //PRG SHOW
                                                  Siren_Start(1);
                                                  OpenDoorRelay(); 
                                          }else { 
                                                  Pointer = Relay1MeM;//
                                                  MaxNum =  CMaxRelay1MeM;
                                                  strcpyf(Data,"0");
                                                  WriteData(1);  //PRG SHOW 
                                                  Siren_Start(3);
                                                  CloseDoorRelay();                                           
                                          }
                                  }else{
                                          OpenDoorRelay();                                          
                                          CounterOpenDoor = OpenDoorTime; 
                                          if (MessageOnOff &0x80){//open door  message  ?
                                                         Voice_Sug=146;//Open the door message
                                          } 
                                          RedialTime=SpeechTime;//stop redialing                                                                             
                                          CounterSecond=0; //ACURATE
                                          FlagOpenDoor = 1;
                                  }
                                  ConfimTstT_CNT=0;
                                  OpenDoorTestCNT=0;//Move Next Phone if door not oppen  
                                  CounterRing=1;
                             }else {
                                  if (!OpenDoorTime2){ 
                                          Pointer = Relay2MeM;//
                                          MaxNum =  CMaxRelay2MeM;
                                          ReadData(1);  //PRG SHOW 
                                          if (Data[0]=='0') {
                                                  Pointer = Relay2MeM;//
                                                  MaxNum =  CMaxRelay2MeM;
                                                  strcpyf(Data,"1");
                                                  WriteData(1);  //PRG SHOW
                                                  Siren_Start(1);
                                                  OpenDoorRelay2(); 
                                          }else { 
                                                  Pointer = Relay2MeM;//
                                                  MaxNum =  CMaxRelay2MeM;;
                                                  strcpyf(Data,"0");
                                                  WriteData(1);  //PRG SHOW 
                                                  Siren_Start(3);
                                                  CloseDoorRelay2();                                           
                                          }
                                  }else{
                                          OpenDoorRelay2();                                          
                                          CounterOpenDoor2 = OpenDoorTime2;   
                                          if (MessageOnOff &0x80){//open door  message  ?
                                                         Voice_Sug=146;//Open the door message
                                          }
                                          RedialTime=SpeechTime;//stop redialing                                                         
                                          CounterSecond=0; //ACURATE
                                          FlagWait2 = 0;
                                          FlagOpenDoor2 = 1;                                                                                 
                                  }  
                                  OpenDoorTestCNT=0;//Move Next Phone if door not oppen
                                  ConfimTstT_CNT=0;   
                                  CounterRing=1;                                                                                                         
                                                    
                             }
                             
//                             if (MessageOnOff &0x80){//open door  message  ?
//                                 MessageNoNeed=205;//Open the door message
//                             }

 
                             PauseButton=1;
                             TimeConectedWithApp = OpenDoorTime+7;//10; //FIX MENU  
                             AppDisplayTO=1;//FIX1 
                             LineWasBussyFlag=1;
                             ToneDigCNT=2;
                             RecToneKey[0]=0;
                             RecToneKey[1]=0;
                        }
                        if ((RecToneKey[0]==11)||(RecToneKey[0]==12)||(RecToneKey[1]==11)||(RecToneKey[1]==12)){
                             TimeConectedWithApp = 2;
                             LineWasBussyFlag=1;
                             ToneDigCNT=2;
                             RecToneKey[0]=0;
                             RecToneKey[1]=0;
                        }
                   ToneDigCNT++;
                   PORTA|= 0X40;
                   DelayBetweenTone=50; //200 msec
                   }
              }
              if (!(PINA & 0x02)) DTMF_TestN=1;
              if ((ShuntMicTime)||(DelayBetweenTone)) DTMF_TestN=0;


             // if (ButtonTimeOut)ButtonTimeOut--;

            /*  if (PIND&0x1){//RST_R input ?
                   if (RST_Rcnt<20)RST_Rcnt++;
              }else {
                        RST_Rcnt=0;
                        RST_R_Pin=0;
              }
              if (RST_Rcnt>=20){
                   RST_R_Pin=1;
              }
              if ((!DialTime)&&(RST_R_Pin)&&(!RST_R_TimOut)){
                   RST_R_TimOut=500;
              }
              if (RST_R_TimOut){
                   //PORTB |=0x20;// Realse  Talk Mode
                   RST_R_TimOut--;
                   if (!RST_R_TimOut){
                        if (PORTD &0x40){
                             //PORTB &=~0x20;// Put Talk Mode
                             PORTA &=~0x8;  // Put Speech AMP
                        }
                   }
              }*/


              if (PINF&0x10){//MAG input ?
                   if (MAGcnt<50)MAGcnt++;
              }else {
                   if (MAGcnt)MAGcnt--;
              }
              if (MAGcnt>=50)MAGPin =0x1;
              if (!MAGcnt){
                   MAGPin=0;
                   MAGCounter=0;
              }
              if (MAGPin){
                   if ((!Status)&&(MessageOnOff &0x10)){
                        if(!MAGCounter)MAGCounter=DoorForget;
                   }
              }


              if (PINF&0x20){//DET input ?
                   if (DETcnt<50)DETcnt++;
              }else {
                   if (DETcnt)DETcnt--;
              }
              if (DETcnt>=50)DETPin |=0x1;
              if (!DETcnt){
                   DETPin=0;
                   WelcomeCounter=0;
              }
              if (DETPin==0x1){
                   DETPin |=0x2;
                   if ((!Status)&&(MessageOnOff &0x20))WelcomeCounter=WelcomeTime;
              }

              if ((YesNoAnswer &0x2)&&(DETPin)){
                   if(LightTime){
                         CounterLight = LightTime;
                         PORTC |=0x1;
                   }
              }


              if (FlagHoldLine) TestVolt();else {  
                      if (FLAGS==0)PORTG |=0x2;// lit the led
                      else PORTG &=~0x2;// lit the led
              }
              //PORTG |=0x2;// lit the led
              SIREN_PROCES();

//              if (ResetVoice){
//                   if (ResetVoice>=200){//on message sign do not make reset
//                   }else if (ResetVoice==150){
//                        ResetVoice =0;
//                        MessageNoNeed=0;
//                        Audio_Tx_Cnt=32;
//                        VoiceIC_Mode=1;
//                        Auido_Sound=0xff;//stop sign
//                        Audio_Cmnd=1;
//                   }else if (ResetVoice==100){
//                        ResetVoice =0;
//                        MessageNoNeed=0;
//                        Audio_Tx_Cnt=32;
//                        VoiceIC_Mode=1;
//                        if (Audio_Val>7)Audio_Val=7;
//                        Auido_Sound=0xf0+Audio_Val;
//                        Audio_Cmnd=1;
//                   } else if (ResetVoice){
//                        AMP_ON_OFF &=~0x4;// voice OFF (0 = amp 1 buzzer 2 voice )  
//                        ResetVoice--;
//                        if (!ResetVoice)ResetVoice=100;//put set valume sign
//                   }
//              }
//              if ( (!ResetVoice)||(ResetVoice>2) )PORTB |=0x1;
//              else PORTB &=~0x1;//make reset pulse and set Audio voice


              if (FlagPrySec){
                  FlagPrySec=0;
                  if ((!(PINA&0x80))&&(Max_Speech_Time<35)){
                         #asm("NOP");
                         if (!(PINA&0x80)){
                              Max_Speech_Time=0;
                              PORTA &=~0x10;//Relase speech relay 
                         } 
                 }
                  if(Max_Speech_Time){ //count the amp open time  
                        Max_Speech_Time--; 
                        if (!Max_Speech_Time)PORTA &=~0x10;//Relase speech relay 
                 }                   
                     
                  if (Voice_End){
                         Voice_End--;
                         if (!Voice_End){
                                   PORTF |=0x10;//RR++
                         }
                  } 
                   
 
                                      

                    if(Status){
                          Rst_LCD=0; 
                          Full_Reset=0;
                    }
                  //  if ((!Rst_LCD)&&(Full_Reset>34))Full_Reset=34; //delay rest by 1MIN if Rst_LCD=0
                     if (Rst_LCD<250)Rst_LCD++;//reset LCD 
    
                    if((!(PING & 0x8))&&(PING & 0x10)){ 
                         if (Rst_LCD>=30){ //evry 10 sec 
                               PawerUp();
                               Riset(); 
                               Rst_LCD=1; 
                               Tor =100;
                               Full_Reset++; 
                               Voice_Reset++;                                
                               if (Full_Reset>=5)Siren_Start(0);
                               else Siren_Start(7);                                                
                               if (Full_Reset>=6){ //1 min time                                    
                                       WDTCR = 0X1F;   // WD 14mSEC
                                       WDTCR = 0X00;   // WD 14mSEC 
                                       while (1){ //force full reset
                                       }
                               }else  if (Voice_Reset>=3){ 
                                        Voice_Reset=0;
                                        PORTF &=~0x10;//RR++ 
                                        Voice_End=4; 
                               }                                     
                               
                         } 
                    }else { 
                         if (Rst_LCD>=240){//every 60 sec
                               PawerUp();
                               Riset(); 
                               Rst_LCD=1; 
                               Tor =100;
                               Full_Reset++; 
                               Voice_Reset++;        
//                               if (Full_Reset>=239)Siren_Start(0);
//                               else Siren_Start(7);                      
                               if (Full_Reset>=240){ //4 hours time  
                                       WDTCR = 0X1F;   // WD 14mSEC
                                       WDTCR = 0X00;   // WD 14mSEC 
                                       while (1){ //force full reset
                                       }
                               }else  if (Voice_Reset>=2){ 
                                        Voice_Reset=0;
                                        PORTF &=~0x10;//RR++
                                        Voice_End=4; 
                                }                                      
                               
                         }                     
                    }                                              
        
                  if (Pxy_Timer){//PXYOO 
                        if (Pxy_Timer>2)Pxy_Timer--;
                        if (Pxy_Timer==40){//60-40=20/4 = 5 sec 
                            Tags_Qty=0;                              
                            if(Tst_Exist == 1){
                                  Pointer = ProxyLrn;
                                  Maximum = MaxProxyLrn;
                                  MaxNum = CMaxProxyLrn; 
                            }else{  
                                  Pointer = ProxyLrn2;
                                  Maximum = MaxProxyLrn2;
                                  MaxNum = CMaxProxyLrn2;                            
                            }                                                                               
                            for (Class=0;Class<=5;Class++){ 
                                      Siren_Start(7); //PRXO  
                                      for(Tst_Exist=1;Tst_Exist<=MaxProxyLrn;Tst_Exist++){  
                                              PORTA &=~ 0x08;// Open Amp (0 = amp 1 buzzer 2 voice
                                              Found = 1;
                                              i = 0;  //LONG 8  
                                              ReadData(Tst_Exist); 
                                              if ((Data[7]>=0x30)&&(Data[7]<='F'))Tags_Qty++;
                                      }
                            }  
                            Class=0;
                            Tags_QtyDisp=15; 
                            AllReady_in_Mem=0;  
                            Show_Used=0;
                            Pxy_Timer=5;                                                                                                 
                        }                        
                  }//PXYOO                                   

                  if (Close_Door_TO){
                       Close_Door_TO--; 
                       if (!Close_Door_TO){                                                                
                                 if (NO_Close_Door_Mes);
                                 else  Voice_Sug=143;  //close door message                              
                       }
                  }
                  
                  if (ThisDailMode>20)ThisDailMode=20;             
                  if (ThisDailMode)ThisDailMode--;
 

                  if (FloorMesCnt){
                        FloorMesCnt--;
                        if (!FloorMesCnt){   
                              Pointer = FloorValue;
                              MaxNum =  CMaxFloorValue;
                              for(i=1;i<=MaxFloorValue  ;i++){
                                   ReadData(i);
                                   if (((Data[0]>0x2f)&&(Data[0]<0x3a))&&((Data[1]>0x2f)&&(Data[1]<0x3a))&&((Data[2]>0x2f)&&(Data[2]<0x3a))){
                                         Voice_Sug = (Data[0]&0x0f)*100+ (Data[1]&0x0f)*10 + (Data[2]&0x0f);
                                   }else if (((Data[0]>0x2f)&&(Data[0]<0x3a))&&((Data[1]>0x2f)&&(Data[1]<0x3a))){
                                         Voice_Sug = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
                                   }else if (((Data[0]>0x2f)&&(Data[0]<0x3a))){
                                         Voice_Sug = (Data[0]&0x0f);
                               }else i= MaxFloorValue+5;//exit now 
                                   if ( Voice_Sug>=Floor_Test){//Floor_fix
                                         Voice_Sug = 109+i;
                                         //if (Voice_Sug==110) Voice_Sug=141;
                                         if (Voice_Sug==110) Voice_Sug=166;                                                     
                                                                                                                    
                                         i= MaxFloorValue+5;//exit now
                                   }
                              }
                              if (Voice_Sug<111){
                                    Voice_Sug=0;//Fix first time error massage  
                              }
                              No_Floor_Mess=0;
                        }
                  }                
                 
                  if ((Voice_Sug)&&(Audio_Val)){           
                             PORTA |=0x10;//hold speech relay 
                             tx_buffer[0]=0x7E;  //play 3 
                             tx_buffer[1]=0XFF;
                             tx_buffer[2]=0X06;//NO 
                             tx_buffer[3]=0X03;//OPCODE
                             tx_buffer[4]=0x00;//0X01;//REPLAY 
                             tx_buffer[5]=0x00;//PART1 
                             tx_buffer[6]=Voice_Sug;//0x1;//PART2  
                              
                                                      
                             tx_buffer[7]=0XEF; 
                                                                                                       
                             Max_Tx_Buff =7;//N-1                          
                             tx_index = 0; 
                             PrySecCnt=0;      
                             UDR0=tx_buffer[0]; 
                             //Siren_Start(2); 
                             Voice_Sug=0;
                             Max_Speech_Time=20;//5 sec time out                                                                                              
                   }                             
                   
                   if (WaitTill_BusyTst)WaitTill_BusyTst--;//WaitTill_BusyTst
                   if (ProxyValid){
                            ProxyValid--; 
                            Rst_LCD=0; 
                   }
                            
                   if ((PxyDirDone>1)&&(PxyDirDone<20))PxyDirDone--;//Fast Proxy
                   if (PxyDirDone==10)PxyDirDone=0;                
//                   if ( MessageNoNeed){ //message need ?  
//                        AMP_ON_OFF |=0x4;// voice ON (0 = amp 1 buzzer 2 voice) 
//                        Audio_Tx_Cnt=32;
//                        VoiceIC_Mode=1;
//                        Auido_Sound=MessageNoNeed;
//                        Audio_Cmnd=0;
//                        if ((MessageNoNeed>=101)&&(MessageNoNeed<=131))ResetVoice=200;//put Mag Message sign
//                        MessageNoNeed=0;
//                        RelaseVoiceRly=200;
//                   }
              }
             if ((ProxyValid)&&((StutLine1==pProxyLrnR)||(StutLine1==pProxyLrn2R))){//PRXO                  
                    if ((!ProxyStore)&&(DataCode[7]>=0x30)&&(DataCode[7]<='F')){  //LONG 8
                          if (!write_Aloowed){ 
                                  Class=Scan_Pointer; 
                                  ReadData(List);
                                  if ((Data[7]>=0x30)&&(Data[7]<='F')){//PRXO       
                                          Show_Used=5;   //PRXO
                                          AllReady_in_Mem=0;
                                          Tags_QtyDisp=0;//PXYOO   
                                          Siren_Start(1); //PRXO
                                          write_Aloowed=3;    
                                  }else { 
                                          write_Aloowed=1; //start with allowed                       
                                          for (Class=0;Class<=5;Class++){
                                                  Siren_Start(7); //PRXO                                                     
                                                  for(Tst_Exist=1;Tst_Exist<=MaxProxyLrn;Tst_Exist++){                                                          
                                                          Found = 1;
                                                          i = 0;  //LONG 8
                                                          PORTA &=~ 0x08;// Open Amp (0 = amp 1 buzzer 2 voice   
                                                          ReadData(Tst_Exist);
                                                          while(((i < 8)&&Found )&&(ProxyValid)){
                                                               if(Data[i] != DataCode[i])Found =0;
                                                               i++;
                                                          }
                                                          if (Found){ 
                                                                  MEM_Class=Class+1;//PRXO-MemShow
                                                                  MEM_Location=Tst_Exist;//PRXO-MemShow                                                                
                                                                  Tst_Exist=MaxProxyLrn+1;//fast exit if found
                                                                  Class=10;//fast exit sign 
                                                                  write_Aloowed=2; //PRXO                                                    
                                                          }   
                                                  }
                                          } 
                                  }       
                                  if (write_Aloowed==1){  //PRXO
                                          SaveProxy(NextCode,Data,MaxNum); //PRXO   
                                          Siren_Start(5); //PRXO   
                                          ProxyStore=30; //LONG 8 //PRXO   
                                          PxyDirDone=4;//PxyFast //PRXO    
                                          Class=Scan_Pointer;                                                                                                                                                                          
                                          WriteData(List); 
                                          if(List < Maximum)
                                                List++;
                                          else
                                                List = 1;                               
                                          Class=Scan_Pointer; 
                                          ReadData(List); 
                                          Class=0; 
                                  }else if (write_Aloowed==2){
                                          AllReady_in_Mem=5;
                                          Show_Used=0;   //PRXO 
                                          Tags_QtyDisp=0;//PXYOO  
                                          Siren_Start(1); //PRXO 
                                          strcpyf(Data,"        ");  
                                          Class=0; //PRXO-MemShow
                                  }
                                  write_Aloowed=250;   
                          }                     
                    }
              } //PRXO  
              if (AppDisplayTO==1) {
                   SafeDisp=2;// try to display mini 2 times the selected  //FIX1 
                   if (AddedType==4){//0402                                   
                         if (AppCntCode!=4){
                                AppCntCode=0;// claer and beep if higher app nummber for next use FIX1
                                Siren_Start(2); //FIX1
                                AppDisplayTO=0; //FIX1
                                Type4App=0;                       
                         }else {                            
                                Type4App=(AppCode[0]&0xf)*10+(AppCode[1]&0xf);  //1st two digits 
                                NamePointer=Pointer;//temp use 
                                NewAppNo=0; 
                                for(i=1;i<=15;i++){
                                       Pointer = NewNo;
                                       MaxNum =  CMaxNewNo;
                                       ReadData(i);
                                       if(Data[1] == ' ')  NewAppNo = (Data[0]&0x0f);
                                       else if(Data[2] == ' ')  NewAppNo = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
                                       else {
                                            NewAppNo = (Data[0]&0x0f);
                                            NewAppNo *=100;
                                            NewAppNo = NewAppNo+(Data[1]&0x0f)*10 + (Data[2]&0x0f);
                                       }
                                       if (NewAppNo>99)NewAppNo=99;//max 99                                           
                                       if ( NewAppNo==Type4App){
                                            Type4App=i;
                                            i=16;
                                       }
                                       if (i==15)Type4App=0;
                                }                                
                                Pointer=NamePointer;//reput old value                                             
                                Type456SelTel=(AppCode[2]&0xf)*10+(AppCode[3]&0xf); //2nd two digits     
                                if ((!Type4App)||(Type4App>15)){
                                        AppCntCode=0;// claer and beep if higher app nummber for next use FIX1
                                        Siren_Start(2); //FIX1
                                        AppDisplayTO=0; //FIX1
                                        Type4App=0;
                                        NewAppNo=0;                                  
                                } 
                                else {
                                       Type4App=99;
                                       NewAppNo=0;
                                }                         
                         }
                   } //0402     
                   if((NamePointer = TestDoor(AppCode,AppCntCode))||(AddedType==4)){            
                       NamePointer=ReturnValue; 
                       if ((AddedType==4)&&(Type4App==99)){
                                 NamePointer=(AppCode[0]&0xf)*1000+(AppCode[1]&0xf)*100;  //calculate the correct app 
                                 NamePointer += (AppCode[2]&0xf)*10+(AppCode[3]&0xf);
                       }                                
                       if (AddedType==3){ 
                           for(i=1;i<=MaxNewNo;i++){
                               Pointer = NewNo;
                               MaxNum =  CMaxNewNo;
                               ReadData(i);
                               if(Data[1] == ' ')  NewAppNo = (Data[0]&0x0f);
                               else if(Data[2] == ' ')  NewAppNo = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
                               else {
                                    NewAppNo = (Data[0]&0x0f);
                                    NewAppNo *=100;
                                    NewAppNo = NewAppNo+(Data[1]&0x0f)*10 + (Data[2]&0x0f);
                               }
                               if ( NewAppNo==NamePointer){
                                    NewAppNo=i;
                                    i=MaxNewNo+1;
                               }
                          }
                       }                           
                       DisplaySelected =ClearSelect;//was 5 //FIX7
                       DisplayNameList=0;
                  }else { //FIX1
                        AppCntCode=0;// claer and beep if higher app nummber for next use FIX1
                       // Siren_Start(2); //FIX1
                        AppDisplayTO=0; //FIX1                                                                        
                    }//FIX1
              }
              if(!(PING & 0x010)){
                     if(CounterDefult < 51) CounterDefult++;
              }
              else CounterDefult = 0;
              if(CounterDefult == 50){
                     Pointer = MasterCode;
                     MaxNum = CMaxMasterCode;
                     strcpyf(Data,"123456           "); 
                     PORTE &=~0x4;//ENALBLE EE WRITE   
                     WriteData(1);    
                     PORTE |=0x4;//DISALBLE EE WRITE 
                     //RealTime[3] = AllBords;
                     //Beap = 5;
                     Siren_Start(5);
              }
              if((!(PINA & 0x4))&&(!NoConstantOpen)){  //on REX OR RMT  //FIX1
                   if (RemotCNT<50)RemotCNT++;
              }else {
                   if (RemotCNT)RemotCNT--;
                   NoConstantOpen=0;//FIX3
                   if (!RemotCNT)EE_WriteDone=0;
              }
//              if (Panel_Open=='O'){
//                   Panel_Open=0;
//                   OpenDoorRelay();
//                   CounterOpenDoor = OpenDoorTime; 
//                   CounterSecond=0; //ACURATE
//                   if (MessageOnOff &0x80){//open door  message  ?
//                         MessageNoNeed=205;//Open the door message
//                   }
//                   FloorMesCnt=FloorTime;
//                   FlagOpenDoor = 1;
//                   RealTime[4] = 1;
//                   //RealTime[3] = AllBords;
//                   //Beap = sCONFERM;
//              }
//              else
              if ((RemotCNT>=50)&&(!EE_WriteDone)&&(!OpenDoorTime)){ 
                         
                          Pointer = Relay1MeM;//
                          MaxNum =  CMaxRelay1MeM;
                          ReadData(1);  //PRG SHOW 
                          if (Data[0]=='0') {
                                  Pointer = Relay1MeM;//
                                  MaxNum =  CMaxRelay1MeM;
                                  strcpyf(Data,"1");
                                  WriteData(1);  //PRG SHOW
                                  Siren_Start(2);
                                  OpenDoorRelay(); 
                          }else { 
                                  Pointer = Relay1MeM;//
                                  MaxNum =  CMaxRelay1MeM;
                                  strcpyf(Data,"0");
                                  WriteData(1);  //PRG SHOW 
                                  Siren_Start(3);
                                  CloseDoorRelay();                                           
                          }
                          EE_WriteDone=1;               
              }
              if ((RemotCNT>=50)&&(!FlagOpenDoor)&&(OpenDoorTime)){
                        //   Panel_Open=0; 
                           if (MessageOnOff &0x80){//open door  message  ?
                                   Voice_Sug=146;//Open the door message 
                           }  
                           NO_Close_Door_Mes=1; 
                           No_Floor_Mess=1;
                           OpenDoorRelay(); 
                           CounterOpenDoor = OpenDoorTime; 
                           Rst_LCD=0; 
                           CounterSecond=0; //ACURATE 
                           NoConstantOpen=OpenDoorTime+1;//FIX3 FIX1 do not continuse open
                           FlagOpenDoor = 1;                                                
                           RealTime[4] = 1;
                           //RealTime[3] = AllBords;
                           //Beap = sCONFERM;
              }
              if(!CounterWait && FlagWait){
                  FlagWait = 0;
                  Rst_LCD=0;
                  if (!OpenDoorTime){ 
                          Pointer = Relay1MeM;//
                          MaxNum =  CMaxRelay1MeM;
                          ReadData(1);  //PRG SHOW 
                          if (Data[0]=='0') {
                                  Pointer = Relay1MeM;//
                                  MaxNum =  CMaxRelay1MeM;
                                  strcpyf(Data,"1");
                                  WriteData(1);  //PRG SHOW
                                  Siren_Start(1);
                                  OpenDoorRelay(); 
                          }else { 
                                  Pointer = Relay1MeM;//
                                  MaxNum =  CMaxRelay1MeM;
                                  strcpyf(Data,"0");
                                  WriteData(1);  //PRG SHOW 
                                  Siren_Start(3);
                                  CloseDoorRelay();                                           
                          }
                  }else {  
                          if (MessageOnOff &0x80){//open door  message  ?
                                         Voice_Sug=146;//Open the door message
                          }                                       
                          OpenDoorRelay();
                          CounterOpenDoor = OpenDoorTime;
                          CounterSecond=0; //ACURATE
                          FlagOpenDoor = 1;                             
                   }                  
                   RealTime[4] = 1;
                   //RealTime[3] = AllBords;
                   //Beap = sCONFERM;
              }
              if(!CounterWait2 && FlagWait2){ 
                  FlagWait2 = 0; 
                  Rst_LCD=0;                
                  if (!OpenDoorTime2){ 
                          Pointer = Relay2MeM;//
                          MaxNum =  CMaxRelay2MeM;
                          ReadData(1);  //PRG SHOW 
                          if (Data[0]=='0') {
                                  Pointer = Relay2MeM;//
                                  MaxNum =  CMaxRelay2MeM;
                                  strcpyf(Data,"1");
                                  WriteData(1);  //PRG SHOW
                                  Siren_Start(1);
                                  OpenDoorRelay2(); 
                          }else { 
                                  Pointer = Relay2MeM;//
                                  MaxNum =  CMaxRelay2MeM;
                                  strcpyf(Data,"0");
                                  WriteData(1);  //PRG SHOW 
                                  Siren_Start(3);
                                  CloseDoorRelay2();                                           
                          }
                  }else {
                           if (MessageOnOff &0x80){//open door  message  ?
                                         Voice_Sug=146;//Open the door message
                           }                                                      
                           CounterOpenDoor2 = OpenDoorTime2;
                           CounterSecond=0; //ACURATE
                           FlagOpenDoor2 = 1;
                           OpenDoorRelay2();
                  }
                   RealTime[4] = 1;
                   //RealTime[3] = AllBords;
                   //Beap = sCONFERM;
              }
              if(!CounterOpenDoor && FlagOpenDoor){
                   CloseDoorRelay();
                   FlagOpenDoor = 0;
                   WaitDisplay=6;//wait 1.5 sec befor main view
                   StartToArm(); 
                   
              }
              if(!CounterOpenDoor2 && FlagOpenDoor2){
                   CloseDoorRelay2();
                   FlagOpenDoor2 = 0;
                   WaitDisplay=6;//wait 1.5 sec befor main view
                   StartToArm();
              }
              if(FlagRing){
                   FlagRing = 0;
              }

              if(!FlagTestButton){
                   FlagTestButton = 20;
                   Button = TestButton();
                   if (AnsMD_timeOut)Button=0;//No Keypad during modem connection 
                   if(Button){
                       //  Siren_Start(1);
                         Rst_LCD=0;   
                         if(LightTime){
                              CounterLight = LightTime;
                              PORTC |=0x1;
                         }
                         ButtonMenu();
                         RealTime[4] = 1;
                         if(Status) TimeMenu = 180;
                   }else if ((Rec597Data)&&(BoardQty)){ //FIX1
                        if ((!Last597)&&(Rec597Data )){
                             if (Rec597Data<10){
                                  UserCode[0] = Rec597Data;
                                  AppCode[0] =  Rec597Data; 
                                  CountCode=1;
                                  AppCntCode=1; 
                             }
                             else if (Rec597Data<100){
                                  UserCode[0] = Rec597Data/10;
                                  UserCode[1] = Rec597Data%10;
                                  AppCode[0] =  UserCode[0];                                   
                                  AppCode[1] =  UserCode[1];                                   
                                  CountCode=2;
                                  AppCntCode=2; 
                             }
                             else if (Rec597Data<200){
                                  UserCode[0] = Rec597Data/100;
                                  UserCode[1] =Rec597Data%100;
                                  UserCode[2] = UserCode[1]%10;
                                  UserCode[1] = UserCode[1]/10;                                  
                                  AppCode[0] =  UserCode[0];                                   
                                  AppCode[1] =  UserCode[1]; 
                                  AppCode[2] =  UserCode[2];                                                                                                       
                                  CountCode=3;
                                  AppCntCode=3; 
                             }
                             if (Rec597Data<200){
                                  Button = BELL;                            
                                  if(LightTime){
                                       CounterLight = LightTime;
                                       PORTC |=0x1;
                                  }
                                  ButtonMenu();
                                  RealTime[4] = 1;
                                  if(Status) TimeMenu = 180;  
                             }                                                                                           
                        }
                        else Rec597Long++;
                        if  (Rec597Long>=120){
                             Siren_Start(2);
                             Rec597Long=0;
                        }
                   }else Rec597Long=0; 
              }

         /*     if(CanSend && (CountCanSend >= READY))  // can send
              {
                     CountCanSend = 0;
                     CanSend = 0;
                      // Spike with keybord
                     if(Tor >= 9) Tor = 0;
                     if(!RealTime[9]) RealTime[9] = AllBords;
                     if(!RealTime[Tor])Tor = 0;
                     while(!RealTime[Tor] && (Tor<10))Tor++;
                     IndexBord = GetFirstBit(RealTime[Tor]);
                     SendDataToKeybord();

              }// if

             if((Tor == 4)&& !Sending) // if sended to all and not sending
             {
                  CanSend = 1;
                  SendedToAll = 1;             // sended to all
                  Tor = 0;
                  RealTime[4] = 0;
                  RealTime[9] = AllBords;
                  StatusGet = 0;
             }

         if(WasReceiving)
            if(Checsum)      // if cheksam
            {
                    TestAnswerFromElement();
                    WasReceiving = 0;
                    CanSend = 1;
                    CountTry = 0;
            }// if
            else     // if not resieved
            {
                    CountCanSend = READY;
                    WasReceiving = 0;
                    CanSend = 1;
                    CountTry++;
                    if(CountTry>2)
                    {
                       CountTry = 0;
                       RealTime[Tor]&= ~(0x01<<IndexBord);
                    }
             } */
             if(FlagOneSec){
                        //FlagOneSec=0;
                         Tor++;
                         if(Tor >= 100) Tor = 0;
                         if (!Tx_Max_Char)SendDataToKeybord();
             }
       
/*             if (Call_Pulse){
               //   if (RingSpeachTime)Call_Pulse=125;
                  Call_Pulse--;
                  if (Call_Pulse==20){
                       PORTE |=0x02;//Realse  REST P
                       UCSR0B=0x48;
                  }
                  if (!Call_Pulse){
                       strcpyf(tx_buffer0,"SAAATTPHC\rSAAATTPHC\rSAAATTPHC\rSAAATTPHC\rCA"); //SUM 1+2 2+3 1+2+3
                       //10sum 100tenet 10 1 10 Time 1 Hex sum Cecksum
                       tx_buffer0[1]=0x30+Snd_Relay/100;
                       Reminder =Snd_Relay%100;
                       tx_buffer0[2]=0x30+Reminder/10;
                       tx_buffer0[3]=0x30+Reminder%10;
                       tx_buffer0[4]=0x30+(CameraTime-30)/10;
                       tx_buffer0[5]=0x30+(CameraTime-30)%10;
                       tx_buffer0[5]=0x30+(CameraTime-30)%10;
                       tx_buffer0[6]=0x30+PanelNumber;
                       tx_buffer0[7]=(tx_buffer0[1]&0xf)+(tx_buffer0[2]&0xf)+(tx_buffer0[3]&0xf)+(tx_buffer0[4]&0xf)+(tx_buffer0[5]&0xf)+(tx_buffer0[6]&0xf);
                       tx_buffer0[7]=0x30+(tx_buffer0[7]&0xf);
                       tx_buffer0[8]=(tx_buffer0[1]&0xf)^(tx_buffer0[2]&0xf)^(tx_buffer0[3]&0xf)^(tx_buffer0[4]&0xf)^(tx_buffer0[5])^(tx_buffer0[6]);
                       tx_buffer0[8]=0x30+(tx_buffer0[8]&0xf);

                       tx_buffer0[0]=Snd_Relay+(CameraTime-30)+PanelNumber;
                       tx_buffer0[0] &=0xf0;
                       tx_buffer0[0] >>=4;
                       tx_buffer0[0] +=0x30;

                       tx_buffer0[10] =tx_buffer0[0];
                       tx_buffer0[20]=tx_buffer0[0];
                       tx_buffer0[30]=tx_buffer0[0];

                       tx_buffer0[11]=tx_buffer0[1];
                       tx_buffer0[21]=tx_buffer0[1];
                       tx_buffer0[31]=tx_buffer0[1];

                       tx_buffer0[12]=tx_buffer0[2];
                       tx_buffer0[22]=tx_buffer0[2];
                       tx_buffer0[32]=tx_buffer0[2];

                       tx_buffer0[13]=tx_buffer0[3];
                       tx_buffer0[23]=tx_buffer0[3];
                       tx_buffer0[33]=tx_buffer0[3];


                       tx_buffer0[14]=tx_buffer0[4];
                       tx_buffer0[24]=tx_buffer0[4];
                       tx_buffer0[34]=tx_buffer0[4];


                       tx_buffer0[15]=tx_buffer0[5];
                       tx_buffer0[25]=tx_buffer0[5];
                       tx_buffer0[35]=tx_buffer0[5];

                       tx_buffer0[16]=tx_buffer0[6];
                       tx_buffer0[26]=tx_buffer0[6];
                       tx_buffer0[36]=tx_buffer0[6];

                       tx_buffer0[17]=tx_buffer0[7];
                       tx_buffer0[27]=tx_buffer0[7];
                       tx_buffer0[37]=tx_buffer0[7];

                       tx_buffer0[18]=tx_buffer0[8];
                       tx_buffer0[28]=tx_buffer0[8];
                       tx_buffer0[38]=tx_buffer0[8];

                       Tx_Max_Char=42;

                       tx_rd_index0 = 0;
                       UDR0=tx_buffer0[0];
                  }
             } */
             
             if (Wait_Tx1){
                   Wait_Tx1--;
                   if (!Wait_Tx1){                        
                            UDR1=tx_buffer1[tx_rd_index1]; 
                            Siren_Start(1);
                   }
             } 
            /* if (MDM_tx_time){
                  MDM_tx_time--;
                  if (!MDM_tx_time
             } */
             if (MDM_Report){ 
                  MDM_tx_time=1;
                 /* if (SelectedSpeed=='c')MDM_tx_time=3; 
                  else if (SelectedSpeed=='b')MDM_tx_time=6; 
                  else if (SelectedSpeed=='a')MDM_tx_time=34; */
                  if (MDM_Report=='r'){ 
                        //read EEprom  from MDM_Address
                       // DataReadEE(MDM_Address,MDM_Data,&tx_buffer1[0]);
                        for (i=0;i<0x30;i++){  
                             tx_buffer1[i] = 0x30+i;
                        }
                        //tx_buffer1[MDM_Data+1] = 13; //cr                                                                                        
                        //tx_buffer1[MDM_Data+2] = 0;                        
                        tx_buffer1[0x30] = 13; //cr                                                                                        
                        tx_buffer1[0x31] = 0;
                        tx_rd_index1 = 0;
                        UDR1= tx_buffer1[0]; 
                        MDM_Report=0;                  
                  }else{
                        tx_buffer1[0] = MDM_Report;
                        tx_buffer1[1] = 13; //cr                                                                                        
                        tx_buffer1[2] = 0;
                        tx_rd_index1 = 0;
                        UDR1= tx_buffer1[0]; 
                        MDM_Report=0;                  
                  }             
             }              
 
             if (MDM_oneSec){
                    MDM_oneSec=0;  
                    if (AnsMD_timeOut){
                         AnsMD_timeOut--;
                         if ((!AnsMD_timeOut)||(EndAnsMD_timeOut)){
                              EndAnsMD_timeOut=0;
                              AnswerAsModem=0;
                              MDM_Reply_Mode=0;
                              AMP_ON_OFF |=0x1;// AMP ON (0 = amp 1 buzzer 2 voice) 
                              TimeConectedWithApp = 1;
                              ToneDigCNT=2;
                              RecToneKey[0]=0;
                              RecToneKey[1]=0; 
                              PawerUp(); 
                              OrderName();//long beep and order 
                              Force_Rest =1;
                              ReliseLine();// realse line any way 
                              LineWasBussyFlag=0;                                                                                                                        
                         }
                   }
                   if ((AnsMD_timeOut==0)&&(MDM_Reply_Mode))MDM_Reply_Mode=0;
             }
             if(TimeTestSystem > 60)//&&(Status == 0))  // to test  AC
             {
                   TimeTestSystem = 0;
                   RealTime[0] = 0xFF;  // Test Status of keybord
             }
             if(FlagDisplay){
                   FlagDisplay = 0;
                   RealTime[4] = 1;
             }

             if(!TimeMenu &&(Status > 0))  // time out, exit to start
             {
                   StartToArm();
             }
             if (ThisDailMode)Reset=0;
             else if ((NeetToDialFlge)&&(Reset==10)){
                    NeetToDialFlge=0;
                    DialToApp(NameRelay);//NamePointer); // CALL not according to offset fixing 
             }
             if (FinshDialFlag){
                    SetVoiceMode();
                    //if (SpkSensVal>50)VoiceSpkMax;
                    //else VoiceMicMax();
             }
             /*if((TimeChangeWord > 125)&&(Status > 1)){
                    TimeChangeWord = 0;
                    StrLed();
                    RealTime[4] = 1;
             }*/
             if((TimeChangeWord > 32)&&(Status > 1))//FIX1
             {
                   TimeChangeWord = 0;
                   StrLed();
                   RealTime[4] = 1;
             } 


            while(!MainCycle){}
            MainCycle = 0;
   }//while
}

void FuncESC(void){     //system escape one level up
     if(!Level){ //FIX2B
          if (!WaitForExit) StartToArm();
          else WaitForExit =101; //FIX7 
          
     } //FIX2B
     else{
       Status = 1;
       Level--;
       pN = HNext[Level];
       StutLine2 =  StutLine1 / Max;
       StutLine1 = StutLine2 - pN;
       List = 0;
       RealTime[4] = 1; 
       //WaitForExit=2; //FIX2B  FIX6
     }
//{
//     if(!Level)
//          StartToArm();
//     else{
//       Status = 1;
//       Level--;
//       pN = HNext[Level];
//       StutLine2 =  StutLine1 / Max;
//       StutLine1 = StutLine2 - pN;
//       List = 0;
//       RealTime[4] = 1;
//     }
    /* if((!Level)||(FlagTecUserCode)){
          CountCode = 0;
          FlagTecUserCode = 0;     //Direct accses to codes
          StartToArm();
     }
     else{
       CountCode = 0;
       Status = 1;
       Level--;
       pN = HNext[Level];
       StutLine2 =  StutLine1 / Max;
       StutLine1 = StutLine2 - pN;
       List = 0;
       RealTime[4] = 1;
    }*/
}

void StrLed(void)   // to change char in place NextCode
{
   if(Change)
   {
      ChangeWord = Data[NextCode-1];
      if(ChangeWord=='.')Data[NextCode-1] = ' ';
      else Data[NextCode-1] = '.';
   }
   else
     Data[NextCode-1] = ChangeWord ;

   Change^=1;      
   if ((ProxyValid)&&((StutLine1==pProxyLrnR)||(StutLine1==pProxyLrn2R))){//PRXO 
           if(Status){  
                   Data[NextCode-1]=Saved_Char;//PRxO 
           }  
   }   
}
void CaseFunc(void)                          // enter to technical
{
            TimeChangeWord = 0;
            if(StutLine1 == pCodesR)                                     // enter Codes (4)
            {
                   Pointer = Code;
                   Maximum = MaxCode;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxCode;
                   Status = 4;
                   List = 1;
                   NextCode = 1;
                   Change = 1;

            }
            if(StutLine1 == pTel1NumR)                                     // enter Codes (4)
            {
                   Pointer = Tel1Num;
                   Maximum = MaxTel1Num;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxTel1Num;
                   Status = 4;
                   List = 1;
                   NextCode = 1;
                   Change = 1;

            }
            if(StutLine1 == pTel2NumR)                                     // enter Codes (4)
            {
                   Pointer = Tel2Num;
                   Maximum = MaxTel2Num;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxTel2Num;
                   Status = 4;
                   List = 1;
                   NextCode = 1;
                   Change = 1;

            }
            if(StutLine1 == pTel3NumR)                                     // enter Codes (4)
            {
                   Pointer = Tel3Num;
                   Maximum = MaxTel3Num;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxTel3Num;
                   Status = 4;
                   List = 1;
                   NextCode = 1;
                   Change = 1;

            }
            if(StutLine1 == pTel4NumR)                                     // enter Codes (4)
            {
                   Pointer = Tel4Num;
                   Maximum = MaxTel4Num;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxTel4Num;
                   Status = 4;
                   List = 1;
                   NextCode = 1;
                   Change = 1;

            }
            if(StutLine1 == pTel5NumR)                                     // enter Codes (4)
            {
                   Pointer = Tel5Num;
                   Maximum = MaxTel5Num;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxTel5Num;
                   Status = 4;
                   List = 1;
                   NextCode = 1;
                   Change = 1;

            }
            if(StutLine1 == pTel6NumR)                                     // enter Codes (4)
            {
                   Pointer = Tel6Num;
                   Maximum = MaxTel6Num;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxTel6Num;
                   Status = 4;
                   List = 1;
                   NextCode = 1;
                   Change = 1;

            }


            if(StutLine1 == pNewNoR)                                     // enter Service info
            {
                   Pointer = NewNo;
                   Maximum = MaxNewNo;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxNewNo;
                   Status = 4;
                   List = 1;
                   NextCode = 1;
                   Change = 1;
            }
            if(StutLine1 == pOfsetR)                                     // enter Service info
            {
                   Pointer = Ofset;
                   Maximum = MaxOfset;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxOfset;
                   Status = 4;
                   List = 1;
                   NextCode = 1;
                   Change = 1;

            }
            if(StutLine1 == pServiceR)                                     // enter Service info
            {
                   Pointer = Service;
                   Maximum = MaxService;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxService;
                   Status = 4;
                   List = 1;
                   NextCode = 1;
                   Change = 1;

            }
            if(StutLine1 == pRelayControlR)                                     // enter Codes (4)
            {
                   Pointer = RelayControl;
                   Maximum = MaxRelayControl;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxRelayControl;
                   Status = 4;
                   List = 1;
                   NextCode = 1;
                   Change = 1;
            }
            if(StutLine1 == pFloorValueR)                                     // enter Codes (4)
            {
                   Pointer = FloorValue;
                   Maximum = MaxFloorValue;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxFloorValue;
                   Status = 4;
                   List = 1;
                   NextCode = 1;
                   Change = 1;
            }
            if(StutLine1 == pProxyLrnR)                                     // enter Codes (4)
            {
                   Pointer = ProxyLrn;
                   Maximum = MaxProxyLrn;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxProxyLrn;
                   Status = 4;
                   List = 1;
                   NextCode = 1;
                   Change = 1; 
                   Scan_Pointer=0;   //6 Proxy
            }
            if(StutLine1 == pProxyLrn2R)                                     // enter Codes (4)
            {
                   Pointer = ProxyLrn2;
                   Maximum = MaxProxyLrn2;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxProxyLrn2;
                   Status = 4;
                   List = 1;
                   NextCode = 1;
                   Change = 1;
                   Scan_Pointer=0;      //6 Proxy                         
            }
            if(StutLine1 == pEraseAllR)                                     // enter Codes (4)
            {
                   Pointer = EraseAll;
                   Maximum = MaxEraseAll+2;//U_D
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxEraseAll;
                   Status = 7;
                   List = 1;
                   NextCode = 1;
                   Change = 1;
            }
            if(StutLine1 == pMasageOnR)                                     // enter Codes (4)
            {
                   Pointer = MasageOn;
                   Maximum = MaxMasageOn;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxMasageOn;
                   Status = 7;
                   List = 1;
                   NextCode = 1;
                   Change = 1;
            }
            if(StutLine1 == pAnswerY_NR)                                     // enter Codes (4)
            {
                   Pointer = AnswerY_N;
                   Maximum = MaxAnswerY_N;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxAnswerY_N;
                   Status = 7;
                   List = 1;
                   NextCode = 1;
                   Change = 1;
            }
            if(StutLine1 == pFamilyNoR)                                     // enter Codes (4)
            {
                   Pointer = FamilyNo;
                   Maximum = MaxFamilyNo;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxFamilyNo;
                   Status = 7;
                   List = 1;
                   NextCode = 1;
                   Change = 1;
            }
            if(StutLine1 == pExtKeysR)                                     // enter Codes (4)
            {
                   Pointer = ExtKeys;
                   Maximum = MaxExtKeys;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxExtKeys;
                   Status = 7;
                   List = 1;
                   NextCode = 1;
                   Change = 1;
            }            
            if(StutLine1 == pCommSpdR)                                     // enter Codes (4)
            {
                   Pointer = CommSpd;
                   Maximum = MaxCommSpd;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxCommSpd;
                   Status = 7;
                   List = 1;
                   NextCode = 1;
                   Change = 1;
            }
            if(StutLine1 == pSetReadTimeR)                                     // enter Codes (4)
            {
                   Pointer = SetReadTime;
                   Maximum = MaxSetReadTime;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxSetReadTime;
                   Status = 7;
                   List = 1;
                   NextCode = 1;
                   Change = 1;
            }
            if(StutLine1 == pSetReadTimerR)                                     // enter Codes (4)
            {
                   Pointer = SetReadTimer;
                   Maximum = MaxSetReadTimer;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxSetReadTimer;
                   Status = 7;
                   List = 1;
                   NextCode = 1;
                   Change = 1;
            }
            if(StutLine1 == pConfirmToneR)                                     // enter Codes (4)
            {
                   Pointer = ConfirmTone;
                   Maximum = MaxConfirmTone;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxConfirmTone;
                   Status = 7;
                   List = 1;
                   NextCode = 1;
                   Change = 1;
            }
            if(StutLine1 == pSpeechLevelR)                                     // enter Codes (4)
            {
                   Pointer = SpeechLevel;
                   Maximum = MaxSpeechLevel;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxSpeechLevel;
                   Status = 7;
                   List = 1;
                   NextCode = 1;
                   Change = 1;

            }
            if(StutLine1 == pFASTstepR)                                     // enter Codes (4)
            {
                   Pointer = FASTstep;
                   Maximum = MaxFASTstep;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxFASTstep;
                   Status = 7;
                   List = 1;
                   NextCode = 1;
                   Change = 1;

            }
            if(StutLine1 == pMasterCodeR)                                     // enter Codes (4)
            {
                   Pointer = MasterCode;
                   Maximum = MaxMasterCode;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxMasterCode;
                   Status = 7;
                   List = 1;
                   NextCode = 1;
                   Change = 1;

            }
            if(StutLine1 == pTecUserCodeR)                                     // enter Codes (4)
            {
                   Pointer = TecUserCode;
                   Maximum = MaxTecUserCode;
                   //FlagStatusCode = 1;        // help change madcode
                   MaxNum = CMaxTecUserCode;
                   Status = 8;
                   List = 1;
                   NextCode = 1;
                   Change = 1;

            }
            if(StutLine1 == pNamesR)   //enter zone name (7)
            {
                 Pointer = Name;
                 //StatusDifolt = dZONE;
                 //NextDifolt = START_DEF_NAME;
                 Maximum = MaxName;
                 MaxNum = CMaxName;
                 Status = 3;
                 List = 1;
                 NextCode = 5; 
                 if ( EnglishMode)NextCode = 4; //2 Lines
                 StutWord = 0;
                 ValueWord = 0;
                 Change = 1;
                 BellSaveValue='.';// first value for Bell key
                 //FlagDefolt|= 0x04; 
            }
            if(StutLine1 == pRingingNumR)   //enter zone name (99)
            {
                 Pointer = RingingNum;
                 //StatusDifolt = dZONE;
                 //NextDifolt = START_DEF_NAME;
                 Maximum = MaxRingingNum;
                 MaxNum = CMaxRingingNum;
                 Status = 6;
                 List = 1;
                 NextCode = 1;
                 StutWord = 0;
                 ValueWord = 0;
                 Change = 1;
            }
            if(StutLine1 == pToneCodesR)   //enter zone name (88)
            {
                 Pointer = ToneCodes;
                 //StatusDifolt = dZONE;
                 //NextDifolt = START_DEF_NAME;
                 Maximum = MaxToneCodes;
                 MaxNum = CMaxToneCodes;
                 Status = 5;
                 List = 1;
                 NextCode = 1;
                 StutWord = 0;
                 ValueWord = 0;
                 Change = 1;
                 //FlagDefolt|= 0x04;
            }
            if(StutLine1 == pBusySogToneR)   //enter zone name (99)
            {
                 Pointer = BusySogTone;
                 Maximum = MaxBusySogTone;
                 MaxNum = CMaxBusySogTone;
                 Status = 6;
                 List = 1;
                 NextCode = 1;
                 StutWord = 0;
                 ValueWord = 0;
                 Change = 1;
            }
            if(StutLine1 == pOutputR)   //enter zone name (7)
            {
                 Pointer = OutPut;
                 //StatusDifolt = dZONE;
                 //NextDifolt = START_DEF_NAME;
                 Maximum = MaxOutPut;
                 MaxNum = CMaxOutPut;
                 Status = 5;
                 List = 1;
                 NextCode = 1;
                 StutWord = 0;
                 ValueWord = 0;
                 Change = 1;
                 //FlagDefolt|= 0x04;
            }
            if(StutLine1 == pTimeCycleR)   //enter zone name (7)
            {
                 Pointer = TimeCycle;
                 //StatusDifolt = dZONE;
                 //NextDifolt = START_DEF_NAME;
                 Maximum = MaxTimeCycle;
                 MaxNum = CMaxTimeCycle;
                 Status = 6;
                 List = 1;
                 NextCode = 1;
                 StutWord = 0;
                 ValueWord = 0;
                 Change = 1;
                 //FlagDefolt|= 0x04;
            }
            if(List){
                  if(StutLine1 == pNamesR){ //2 Lines 
                        Class=1; 
                        ReadData(List); 
                        Class=0;
                        StrFromEE(&rx_buffer0[0]);                 //MMM 
                    if (!EnglishMode) HebruSrting(&rx_buffer0[0]);   //2 Lines                            
                  }        
                  ReadData(List); 
                  if(StutLine1 == pServiceR){   // enter Service info
                            Pointer = 200+((List-1)*CMaxService);//OrderNames;
                            MaxNum = CMaxService;
                            ReadDataChip(1);
                  }
            }
}

void StartFunc(void)   // function enter to start
{
   StutLine1 = 0;
   StutLine2 = 1;
   RealTime[4] = 1;
   List = 0;
   Level = 0;
   Status = 0;
 //  PawerUp();
}
void StartToArm(void)   // function enter to start
{
   StutLine1 = 0;
   StutLine2 = 1;
   //ShortCut = 0;
  // StatusVolt = StatusVolt &~0x80;
   RealTime[4] = 1;
   List = 0;
   Level = 0;
   Status = 0;
   //StatusBypass = 0;
   //StatusElement = 0;
}
void FuncSACB(void)    //  status Stay, Away, Chime, Bypass
{
     char CodeTest,i;
     unsigned  char NumValue;
     unsigned  int NamePointerTmpTamp;
     unsigned  short TampShortVal;


     //Asaf
      if(Button == DHSH){
              if (MessageOnOff &0x1)WelcomeCounter=WelcomeTime;  
              BusyTstTO_Timer=0; 
              OpenDoorTestCNT=0;  //Move Next Phone if door not oppen
              ConfimTstT_CNT=0;//? 
              DisplayNameList=1;//1/4  second return to main //FIX7
              DisplaySelected=0; //FIX7                
      }

     //Asaf
     else if(Button == FAST){  
//       if (testi<15)testi++; ////disply arranged memory 
//       else testi=0;      
            SwapLine23_12=11;  //DISP 4 Lines to 2 lines
            Info_Disply=0;     //DISP 4 Lines to 2 lines
            Bits_CNT1 &=~0x2; //2 Lines 
            LineName=C_LineName;//2 Lines           
            CountCode=0;//FIX6
            AppCntCode=0;//FIX6 
            AppDisplayTO=0;//FIX6 
            // OrderNameRead();//??? TBD  //DISP 4 Lines to 2 lines
            DisplayNameList=DisplyList;//40=10 second
            DisplaySelected=0;
            if (MessageOnOff &0x8){//on Name announce
                 NameMesCnt=AnnounceTime;
            }
            if (AddedType>=4){ 
            }else {              
                    if (!AllRdyShow){     //MMM  //DISP 4 Lines to 2 lines
                         ListName=1;
                         NamePointer = ReturnNamePointer(ListName);
                         NamePointerN1 = ReturnNamePointer(ListName+1);
        //                 NamePointerN2 = ReturnNamePointer(ListName+2);
        //                 NamePointerN3 = ReturnNamePointer(ListName+3);
                    }else {
                         ListName+=(2*FastStpValue);
                         if(ListName > BigName) ListName = 1;
                         NamePointer = ReturnNamePointer(ListName);
                         NamePointerN1 = ReturnNamePointer(ListName+1);
        //                 NamePointerN2 = ReturnNamePointer(ListName+2);
        //                 NamePointerN3 = ReturnNamePointer(ListName+3);
                    } //DISP 4 Lines to 2 lines
            }
            AllRdyShow=1; 
            Dial_This= NamePointer;       
     }
     else if(Button == NEXT){ 
           // s_nd_Line=0; 
            SwapLine23_12=10;    //DISP 4 Lines to 2 lines  
            Info_Disply=0;     //DISP 4 Lines to 2 lines 
            Bits_CNT1 &=~0x2; //2 Lines 
            LineName=C_LineName;//2 Lines  
            CountCode=0;//FIX6 
            AppCntCode=0;//FIX6 
            AppDisplayTO=0;//FIX6        
            OrderNameRead();
            DisplayNameList=DisplyList;//40=10 second
            DisplaySelected=0;
            if (MessageOnOff &0x8){//on Name announce
                 NameMesCnt=AnnounceTime;
            } 
            if (AddedType>=4){
            }else { 
                    if (!AllRdyShow){     //MMM
                         ListName=1;
                         NamePointer = ReturnNamePointer(ListName);
                         NamePointerN1 = ReturnNamePointer(ListName+1);
//                         NamePointerN2 = ReturnNamePointer(ListName+2);
//                         NamePointerN3 = ReturnNamePointer(ListName+3);
                    }else {
                         ListName++;//117 +=4;
                         if(ListName > BigName) ListName = 1;
                         NamePointer = ReturnNamePointer(ListName);
                         NamePointerN1 = ReturnNamePointer(ListName+1);
//                         NamePointerN2 = ReturnNamePointer(ListName+2);
//                         NamePointerN3 = ReturnNamePointer(ListName+3);
                    } 
            }
            AllRdyShow=1;
            Dial_This= NamePointer;
     }else if(Button == BACK){
            SwapLine23_12=10;    //DISP 4 Lines to 2 lines
            Info_Disply=0;     //DISP 4 Lines to 2 line              
            //s_nd_Line=0; 
            Bits_CNT1 &=~0x2; //2 Lines 
            LineName=C_LineName;//2 Lines  
            CountCode=0;//FIX6 
            AppCntCode=0;//FIX6 
            AppDisplayTO=0;//FIX6        
            OrderNameRead();
            DisplayNameList=DisplyList;//40=10 second
            DisplaySelected=0;
            if (MessageOnOff &0x8){//on Name announce
                 NameMesCnt=AnnounceTime;
            } 
            if (AddedType>=4){
            }else {             
                    if (!AllRdyShow){     //MMM
                         ListName = (BigName/4);
                         ListName *=4;
                         ListName+=BigName%4;
                        // if(BigName%4)ListName++;else ListName --;//117 -=3;
                         NamePointer = ReturnNamePointer(ListName);
                         NamePointerN1 = ReturnNamePointer(ListName+1);
                         NamePointerN2 = ReturnNamePointer(ListName+2);
                         NamePointerN3 = ReturnNamePointer(ListName+3);
                    }else {
                         if(ListName==1){
                              ListName=BigName;
                              ListName = (BigName/4);
                              ListName *=4; 
                              ListName+=BigName%4;
                             // if(BigName%4)ListName++;else ListName --;//117 -=3;
                         }else ListName --;//117 -=4;
                         if (ListName)NamePointer = ReturnNamePointer(ListName);
                         if (ListName+1)NamePointerN1 = ReturnNamePointer(ListName+1);
                         if (ListName+2)NamePointerN2 = ReturnNamePointer(ListName+2);
                         if (ListName+3)NamePointerN3 = ReturnNamePointer(ListName+3);
                    }
            }
            AllRdyShow=1;
            Dial_This= NamePointer;

     }else
     if((Button == BELL)){//)&&(!CounterRing)){  // RECALL 
            if (!AppCntCode)AppCntCode=MemAppCntCode;//FIX1 for BELL USE 
            MemAppCntCode=0;//FIX1 
            if (AddedType==4){//0402 
                 Type4App=0;    
                 if (AppCntCode!=4){
                       Siren_Start(2); //FIX1
                       AppCntCode=0;               
                 }else {   
                       Type4App=(AppCode[0]&0xf)*10+(AppCode[1]&0xf);  //1st two digits 
                       NewAppNo=0; 
                       NamePointer=Pointer;//temp use 
                       for(i=1;i<=15;i++){
                               Pointer = NewNo;
                               MaxNum =  CMaxNewNo;
                               ReadData(i);                                
                               if(Data[1] == ' ')  NewAppNo = (Data[0]&0x0f);
                               else if(Data[2] == ' ')  NewAppNo = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
                               else {
                                    NewAppNo = (Data[0]&0x0f);
                                    NewAppNo *=100;
                                    NewAppNo = NewAppNo+(Data[1]&0x0f)*10 + (Data[2]&0x0f);
                               }
                               if (NewAppNo>99)NewAppNo=99;//max 99                                           
                               if ( NewAppNo==Type4App){
                                    Type4App=i;
                                    i=16;
                               } 
                               if (i==15)Type4App=0;
                       }
                       Pointer=NamePointer;//reput old value       
                       Type456SelTel=(AppCode[2]&0xf)*10+(AppCode[3]&0xf); //2nd two digits    
                       if ((!Type4App)||(Type4App>15)){
                             Siren_Start(2); //FIX1
                             AppCntCode=0;  
                             AppCode[3]=0; 
                             Type4App=0; 
                             NewAppNo=0;                                                     
                       }else{// //Use  Type4App veribale
                               NewAppNo=0;
                       }                                                              
                 }
                                       
            }//0402           
            if(((NamePointer = TestDoor(AppCode,AppCntCode)&&(AddedType<4))||(AddedType>=5))||(((AddedType==4))&&(Type4App))){


                 NamePointer=ReturnValue;
                 if (MessageOnOff &0x40){ 
                         ThisDailMode=8;
                         Voice_Sug =145;//ringing now                                                
                 }else
                 ThisDailMode=0;                  
                
           //      No_Floor_Mess=1;
//                 else if (RelaseVoiceRly)AMP_ON_OFF &=~0x4;// voice OFF (0 = amp 1 buzzer 2 voice ) 
                 FlagRing = 1;
                 ConterPauseRing = 75;
                 CounterRing = RingTime;         //MMM  
                 DisplaySelected=0;//FIX DISPLAY 
                 AppDisplayTO=0;  // No Display need
                // AppClearTO=0;  //  No Code clear need
                 AcssesCodeTO=0;// no clear code need
                 CountCode = 0;
                 Reset=0;
                 NeetToDialFlge=1;
                 NextDailMode=1;
                 BusyTstTO_Timer=BusyTstT;//set the tets time value 
                 CallCnt=0; 
                 CallSign=0;    
                 QuitCallDet=0;
                 FreqCallDet=0;  
                 PC7Cnt=0;   
                 //  test next phone - to skip on no confirm or open 
                 RedialThis=NamePointer; //Remember for next dialing
    
                 if (TimerStatus&0x1){
                      Pointer = Tel5Num;
                      MaxNum = CMaxTel5Num;
                 }else {
                      Pointer = Tel2Num;
                      MaxNum = CMaxTel2Num;
                 } 
                 ReadData(RedialThis); 
                 Show_NextDial=0; //REDIAL 3
                 if((Data[0]>=0x23)&&(Data[0]<=0x66)){                  
                         if (SpeechTime)ConfimTstT_CNT= SpeechTime;//see//MUST BE -10//only if Confirm time exsist test needed 
                         if (RedialTime)OpenDoorTestCNT=RedialTime+RingTime; //Move Next Phone if door not oppen 
                         if (SpeechTime)BusyTstTO_Timer=SpeechTime;//set the tets time value 
                 }else{
                         if (SpeechTime)ConfimTstT_CNT= SpeechTime;//see//MUST BE -10//only if Confirm time exsist test needed 
                         if (RedialTime)OpenDoorTestCNT=SpeechTime; //Move Next Phone if door not oppen 
                         if (SpeechTime)BusyTstTO_Timer=SpeechTime;//set the tets time value 
                  }  

                 //  test next phone - to skip on no confirm or open                    
                 DialingTo=0;
                 AppCntCode=0;
                 if (AddedType>=4){
                         if (AddedType==4){ 
                                // pay attantion swap between  Type456SelTeland Type4App!!!!
                                Type456SelTel=Type4App;//(AppCode[0]&0xf)*10+(AppCode[1]&0xf);  //1st two digits 
                                Type4App=(AppCode[2]&0xf)*10+(AppCode[3]&0xf); //2nd two digits                           
                                NamePointer=1;   
                                if (Type456SelTel<=6){  //for 0100- 0199 
                                         NameRelay=Type4App;
                                         if (!NameRelay)NameRelay=100;  //for 100,200...,600
                                }else  if (((Type456SelTel)>=7)&&((Type456SelTel)<=12)){ //for 7xx-12xx 
                                         Type456SelTel=(Type456SelTel)-6;
                                         NameRelay=(Type4App)+100; 
                                         if (NameRelay==100)NameRelay=200;//for 700,800,900                                                                 
                                }else  if (((Type456SelTel)>=13)&&((Type456SelTel)<=15)){ //for 7xx-15xx 

                                         if ((Type4App<=50)&&(Type4App)){                       
                                                 if (Type456SelTel==13)Type456SelTel=1;
                                                 else  if (Type456SelTel==14)Type456SelTel=3;
                                                 else  if (Type456SelTel==15)Type456SelTel=5; 
                                                 NameRelay=201;
                                                 NameRelay=(Type4App)+200; 
                                         }else {  
                                                 if (Type456SelTel==13)Type456SelTel=2;
                                                 else  if (Type456SelTel==14)Type456SelTel=4;
                                                 else  if (Type456SelTel==15)Type456SelTel=6;
                                                 NameRelay=(Type4App)+150; 
                                                 if (NameRelay==150)NameRelay=250;//for 700,800,900                                         
                                         }
                                }                                                                                                    
                         }
                         else if (AddedType==5){//Add/sel =4xxx  001-999 direct  mode / 000 not allowed  
                                 if (!NamePointer){
                                         Type456SelTel=5;
                                         NameRelay=1;                                 
                                 }else {
                                         Type456SelTel=(NamePointer/250)+1; //if (NamePointer==999){
                                         NameRelay= NamePointer%250; //NameRelay=249;  Type456SelTel=4;  
                                 }
                         }                                   
                         else if (AddedType==6){  //Add/sel =5xxx  001-999 floor 0-9 99 app  mode/000 not allowed 
                                if (!(NamePointer/100)){//for 0xx dial 
                                         Type456SelTel=4;
                                         NameRelay=(NamePointer%100)+100;
                                         if (NameRelay==100)NameRelay=200;//for 000                                                                     
                                }                         
                                else if ((NamePointer/100)<=6){  //for 100- 199 
                                         Type456SelTel=(NamePointer/100);
                                         NameRelay=(NamePointer%100);
                                         if (!NameRelay)NameRelay=100;  //for 100,200...,600
                                }else  if (((NamePointer/100)>=7)&&((NamePointer/100)<=9)){ //for 7xx-9xx 
                                         Type456SelTel=(NamePointer/100)-6;
                                         NameRelay=(NamePointer%100)+100; 
                                         if (NameRelay==100)NameRelay=200;//for 700,800,900                          
                                 }                                                
                         }                           

                 }
                 if (AddedType==3){
                      for(i=1;i<=MaxNewNo;i++){
                           Pointer = NewNo;
                           MaxNum =  CMaxNewNo;
                           ReadData(i);
                           if(Data[1] == ' ')  NewAppNo = (Data[0]&0x0f);
                           else if(Data[2] == ' ')  NewAppNo = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
                           else {
                                NewAppNo = (Data[0]&0x0f);
                                NewAppNo *=100;
                                NewAppNo = NewAppNo+(Data[1]&0x0f)*10 + (Data[2]&0x0f);
                           }
                           if ( NewAppNo==NamePointer){
                                NewAppNo=i;
                                i=MaxNewNo+1;
                           }
                      }
                      NameRelay=NewAppNo;
                 }
                 else if (!AddedType){
                      NameRelay=NamePointer;
                }
                 else if (AddedType==1)NameRelay=NamePointer-AddedValue;
                 else if (AddedType==2){
                             NamePointerTmpTamp=(NamePointer/100)-1;
                             NamePointerTmpTamp *= AddedValue;
                             NumValue= NamePointer%100;
                             NumValue =NumValue+NamePointerTmpTamp;
                             NameRelay=NumValue;
                 }
                
                 RelayOn(GetRelay(NameRelay));
                 TimeConectedWithApp=SpeechTime;//was 60;  //FIX MENU // Next_Ring - No Camera time 
                 if (TimeConectedWithApp){ 
                      PORTD |=0x40;// Hold camera relay
                      //PORTB &=~0x20;// Put Talk Mode
                      DialTime=1;                 
                 }
                 SpeechOneSec=0; 
        }
            else{
//                 if (RelaseVoiceRly)AMP_ON_OFF &=~0x4;// voice OFF (0 = amp 1 buzzer 2 voice) 
                 AppDisplayTO=0;  // No Display need
                // AppClearTO=0;  //  No Code clear need
                 AcssesCodeTO=0;// no clear code need
                 CountCode = 0;
                 AppCntCode=0;
                 Siren_Start(2);
            }
     }else
     if(Button == STAR){    
            Dial_This=0;     
            Dsp_Connect_T=0;//Speech time  
            AppDisplayTO=0;//FIX1 
            AppCode[3]=0;//0402
            BusyTstTO_Timer=0;  
            OpenDoorTestCNT=0;  //Move Next Phone if door not oppen
            ConfimTstT_CNT=0;//? 
            if (TimeConectedWithApp>1){
                 TimeConectedWithApp = 1;
                 if(FlagHoldLine)LineWasBussyFlag=1;
                 Reset=0;
            }
//            if (RelaseVoiceRly){ 
//                 if (AMP_ON_OFF &0x4)ResetVoice=150;  //make voice STOP
//                 AMP_ON_OFF &=~0x4;// voice OFF (0 = amp 1 buzzer 2 voice ) 
//            }
            DisplaySelected=0;
            //CounterRing = 0;
            AllRdyShow=0;
            ListName=0;
            WelcomeCounter=0;// if tenedt press STAR no welcome message need
            CodeTest = TestCode(); 
            AppCntCode=0;
            if(CodeTest == 1){ 
                 CountCode = 0;
                 Show_Clock=0;                  
                 if (((YesNoAnswer &0x40)&&(PxyCodeCnt))||(!(YesNoAnswer &0x40))){// for proxy & code
                      if (Rly12Ind<=Rly1End){
                           CounterWait = WaitTime; 
                           CounterSecond=0; //ACURATE
                           FlagWait = 1;
                           NamePointer = 0;
                           RealTime[4] = 1;
                           ListName = 0;
                           Siren_Start(1);
                           NO_Close_Door_Mes=1;
                           No_Floor_Mess=1;
                      }if (Rly12Ind>=Rly2Start){
                           CounterWait2 = WaitTime2; 
                           CounterSecond=0; //ACURATE
                           FlagWait2 = 1;
                           NamePointer = 0;
                           RealTime[4] = 1;
                           ListName = 0;
                           Siren_Start(1);
                           NO_Close_Door_Mes=1;
                           No_Floor_Mess=1;
                      }
                      if ((FlagWait2)&&(FlagWait)){
                             CounterWait=CounterWait2;  //rlay 2 delay apriority
                             CounterSecond=0; //ACURATE 
                             NO_Close_Door_Mes=1;
                             No_Floor_Mess=1;
                      }
                      if ((!FlagWait2)&&(!FlagWait)) Siren_Start(3);
                 }

            }else
            if(CodeTest == 2){  
                 Show_Clock=0;
                 // enter to menu
                 AppDisplayTO=0;  // No Selected Display need
                 Status  = 1;
                 Level = 0;
                 pN = 1;
                 StutLine1 = 0;
                 StutLine2 = StutLine1 + pN;
                 CountCode = 0;
                 FlagTecUserCode = 0;
                 Siren_Start(1);
            }else
            if(CodeTest == 3){ 
                 Show_Clock=0;
                // enter to menu (Tec user code)
                 AppDisplayTO=0;  // No Selected Display need
                 Status  = 1;
                 Level = 0;
                 pN = 1;
                 StutLine1 = 0;
                 StutLine2 = StutLine1 + pN;
                 CountCode = 0;
                 //Button = NEXT; // Direct accses to codes
                 //ButtonMenu();
                 //Button = BELL;
                 //ButtonMenu();
                 FlagTecUserCode = 1;
            }
            else{
                 Max_Speech_Time=1;//stop this timer 
                 AppDisplayTO=0;  // No Display need
                 //AppClearTO=0;  //  No Code clear need
                 AcssesCodeTO=0;// no clear code need
                 Siren_Start(2);
                 CountCode = 0;
                 AppCntCode=0;
                 DisplayNameList=1;//1/4  second return to main
                 DisplaySelected=0;   
                 Show_Clock=20;//show clock for 5 second 
                 DoNotDisp_AppNo=1;//FIX6 
                 CounterRing=0;//0402 fix redisply selected TO
                 PawerUp(); //** reset 
            }
     }
     else{
            if((Button>0)&&(Button<0x0B)){
                 if (AppCntCode==4)AppCntCode=0;
                 if ((AppCntCode==3)&&(AddedType==4)){//0402
                      AppCode[3]= Button;
                      if (AppCode[3]==0xA)AppCode[3]=0;//FIX4  
                      AppCntCode=4;
                 }//0402
                 if((AppCntCode < 3)){//FIX1 
                        AppCode[AppCntCode] = Button; //FIX1
                        if (AppCode[AppCntCode]==0xA)AppCode[AppCntCode]=0;//FIX4
                        AppCntCode++; //FIX1  
                        AppCode[3]=0;//0402                                             
                 }//FIX1  
                 AppDisplayTO=DispSelect+1;  //8= 2 sec Time out //FIX1  
                                              
                 if(Button == ZERO)Button = 0;
                 UserCode[CountCode] = Button;                  
                 if(CountCode < 10) CountCode++; //FIX4                      
                 AcssesCodeTO=60;// 15 sec acsses code clear time out 
                 if (DoNotDisp_AppNo)DoNotDisp_AppNo=10;//FIX6
            }
    }
}

void ButtonMenu(void)      // mangment of Button from keybord
{
unsigned char i,SI=0; //Long BEEP
    if(Status == 0)
    {
      //  if (!ButtonTimeOut){
               Siren_Start(1);
               FuncSACB();
         //      ButtonTimeOut=30;
      //  }
    }else
    if(Status == 1) {    //Main Menu  
          if (Button){  //DISP 4 Lines to 2 lines
               if (Button == STAR){
                   if(((StutLine1 == pProxyLrnR) ||(StutLine1 == pProxyLrn2R)))
                   Force_it=1; 
               }
               Info_Disply=0;
          }//DISP 4 Lines to 2 lines        
    Siren_Start(1);
    AppDisplayTO=0;
         //if((FlagTecUserCode)&&(Button != BELL))return;
         if (Button == NEXT)
         {       
              Pxy_Timer=0; //PXYOO 
              Tags_QtyDisp=0; //PXYOO            
              if(FlagTecUserCode){
                    switch (pN){
                         case 1:
                             pN=2;
                             break;
                         case 2:
                             pN=21;
                             break; 
                        case 21:
                             pN=22;
                             break;   
                        case 22:
                             pN=23;
                             break;                               
                        case 23:
                             pN=1;
                             break;                             
                    }                                                               
              }
              else{
                   if (!(YesNoAnswer2 &0x40)){ //MENU FIX
                         switch (pN){
                             case 1:
                                  pN=2;
                                  break;
                             case 2:
                                  pN=3;
                                  break; 
                             case 3:
                                  pN=4;
                                  break;  
                             case 4:
                                  pN=5;
                                  break;    
                             case 5:
                                  pN=21;
                                  break; 
                             case 21:
                                  pN=22;
                                  break; 
                             case 22:
                                  pN=6;
                                  break; 
                             case 6:
                                  pN=7;
                                  break; 
                             case 7:
                                  pN=14;
                                  break; 
                             case 14:
                                  pN=16;
                                  break; 
                             case 16:
                                  pN=27;
                                  break; 
                             case 27:
                                  pN=29;
                                  break;  
                             case 29:
                                  pN=1;
                                  break;                                                                                                                                                                                                                                                                                                                                                                               
                        }                                         
                   }else {
                        if (pN == MaxMenuN)pN = 1;
                        else {
                             pN++;
                        }
                   }
              }
                   StutLine2 = StutLine1 + pN;

         }else
         if (Button == BACK)
         {   
              Pxy_Timer=0; //PXYOO 
              Tags_QtyDisp=0; //PXYOO            
              if(FlagTecUserCode){
                     switch (pN){
                         case 1:
                             pN=23;
                             break; 
                        case 23:
                             pN=22;
                             break;                             
                         case 22:
                             pN=21;
                             break; 
                        case 21:
                             pN=2;
                             break;  
                        case 2:
                             pN=1;
                             break;                             
                    }                          
	          }else{ 
                   if (!(YesNoAnswer2 &0x40)){//menu fix   
                         switch (pN){
                             case 1:
                                pN=29;
                                break;
                             case 29:
                                pN=27;
                                break; 
                             case 27:
                                pN=16;
                                break;  
                             case 16:
                                pN=14;
                                break;    
                             case 14:
                                pN=7;
                                break;   
                             case 7:
                                pN=6;
                                break; 
                             case 6:
                                pN=22;
                                break;    
                             case 22:
                                pN=21;
                                break;
                             case 21:
                                pN=5;
                                break;  
                             case 5:
                                pN=4;
                                break; 
                             case 4:
                                pN=3;
                                break;  
                             case 3:
                                pN=2;
                                break;
                             case 2:
                                pN=1;
                                break;                                                                                                                                                                                                                                                                                                                                       
                        }                                        
                   }else {                            
                        if (pN == 1) pN = MaxMenuN;
                             else {
                              pN--;
                             }
                        }
                   }
                   StutLine2 = StutLine1 + pN;
         }else
         if (Button == BELL)
         {
              Pxy_Timer=0; //PXYOO 
              Tags_QtyDisp=0; //PXYOO            
               if(Level<MaxMenuD-1)
               {
                  HNext[Level] = pN;
                  Level++;
                  pN = 1;
                  StutLine1 = StutLine2 * Max;
                  StutLine2 = StutLine1 + pN;
                }
                CaseFunc();
                if(StutLine1 == pSetReadTimeR){
                      Time_Up(); //Update time and limit
                      Data[0]=0x30+(Days&0xf);
                      Data[1]=0x30+((Hours&0xf0)>>4);
                      Data[2]=0x30+(Hours&0xf);
                      Data[3]=0x30+((Minutes&0xf0)>>4);
                      Data[4]=0x30+(Minutes&0xf);
                      PowerFail=0;
                }
                if((StutLine1 == pSetReadTimerR)||(StutLine1 == pSetReadTimeR)){
                     TimerStatus |=0x10;//put clear sign
                }
         }else
         if (Button == DHSH){ 
                  Pxy_Timer=0; //PXYOO  
                  Tags_QtyDisp=0;//PXYOO          
                  AppDisplayTO=0;
                  StarPass=0;
//                   if(!Level){  //check if Rmote Master code != master code
//                             Pointer = RmtMasterCode;
//                             MaxNum = CMaxRmtMasterCode;
//                             ReadData(1);  
//                             for (i=0;i<=9;i++){ 
//                                  MDM_buffer[i]=Data[i];
//                             }                             
//                             Pointer = MasterCode;
//                             MaxNum = CMaxMasterCode;
//                             ReadData(1); 
//                             MDM_Reply_M=0;
//                             for (i=0; i< CMaxRmtMasterCode; i++){
//                                  if ((Data[i]==0)||(Data[i]==' '))i= CMaxRmtMasterCode+2;//exit        
//                                  else if (Data[i]!=MDM_buffer[i])MDM_Reply_M=1; //put error found sign                                
//                             }
//                             if (MDM_Reply_M){
//                                  //Siren_Start(5);//no sound needed for confermation  
//                                  Pointer = RmtMasterCode;
//                                  MaxNum = CMaxRmtMasterCode;
//                                  WriteData(1);                                   
//                             }
//                             MDM_Reply_M=0;
//                   }
                  FuncESC();
                  DisplayNameList=1;//1/4  second return to main
         }
   }else
   {        //enter code, follow me,telephone,sys.type...
      Siren_Start(1);
      if(!Change) StrLed();  
      if(Button == STAR){   //PRXO-2L
             if(StutLine1!=pNamesR) Siren_Start(3);    //PRXO-2L
             Info_Disply=500; //PRXO-2L 
      }   //PRXO-2L
      if ( Button==2){
             Info_Disply=0;//PRXO-2L 
      }                     
      if(((StutLine1 == pProxyLrnR) ||(StutLine1 == pProxyLrn2R))){ //6 Proxy
            if (Button==2)Button=STAR; //Swap between Star and @ keys 
            else if (Button==STAR)Button=2; // //6 Proxy
      }

    //  if((Button == STAR)&&(!ButtonTimeOut)){
      if(Button == STAR){ 
          SwapLine23_12=0;  //DISP 4 Lines to 2 lines
          if ((StutLine1==pTel1NumR)||(StutLine1==pTel2NumR)||(StutLine1==pTel3NumR)||(StutLine1==pTel4NumR)||(StutLine1==pTel5NumR)
                    ||(StutLine1==pTel6NumR)||(StutLine1==pToneCodesR)||(StutLine1==pConfirmToneR)) {
                if (!(Bits_CNT1&0x1))MINUS=1;
                EnterNumber();  // 2 sec delay or one number tone
                Bits_CNT1 &=~0x1;
          }
          if(StutLine1==pNamesR){
               if (EnglishMode){
                    if(NextCode > 4){
                         NextCode--;
                         ValueWord = 0;
                    }
                    else{
                         fourline=0;
                                             
                         if (Scan_Pointer==1)Class=1;//2 Lines
                         WriteData(List);
                         Class=0;//2 Lines  
                         if (Scan_Pointer==2){
                               strcpyf(Data,"                ");
                               Class=1;
                               WriteData(List);
                               Class=0;
                         }
                         Scan_Pointer=0;//2 Lines 
                                           
                         PawerUp();
                         if(StutLine1 == pNamesR) OrderName();
                         FuncESC();
                    }
               }else {
                    NextCode++;
                    if(NextCode > (MaxNum)) { //2 Lines
                          if (!Scan_Pointer){ 
                               NextCode = 5; //FIX NAME  HEB
                               Scan_Pointer=1;
                               WriteData(List);
                               Class=1; 
                               ReadData(List);
                               Class=0;  
                          }else { 
                               if (Scan_Pointer==2){ 
                                     WriteData(List);
                                     Scan_Pointer=1; 
                                     NextCode = 5; //FIX NAME  HEB  
                                     Class=1; 
                                     ReadData(List);
                                     Class=0;                                       
                               }else NextCode=MaxNum;
                          }
                    } //2 Lines
                    ValueWord = 0;
               }
          }
          else if((StutLine1==pProxyLrnR)||(StutLine1==pProxyLrn2R)){ //PRXO
                  NextCode = 1;
                  ClearString(NextCode,Data,MaxNum); 
                  strcpyf(Data,"        ");  //PRXO
                  Class=Scan_Pointer; //PRXO
                  WriteData(List); //PRXO
                  PxyDirDone=1;//PxyFast 
                  Class=0;  //PRXO          
          }else 
          if((StutLine1==pCodesR)||( (StutLine1==pServiceR)&&(Rly1End==0)&&(Rly2Start==0)) ){
                  NextCode = 1;
                  ClearString(NextCode,Data,MaxNum); 
                  PxyDirDone=1;//PxyFast 
          }else if (StutLine1==pEraseAllR){
               if (List<=4)EraseAllDone=4;//U_D    
               Siren_Start(1);
               PORTA &=~ 0x08; //AMP ON              
               if (List==1){
                    Pointer = Code;
                    MaxNum = CMaxCode;
                    for(i=1;i<=MaxCode;i++){
                         strcpyf(Data,"          ");
                         WriteData(i);
                    }
               }else
               if (List==2){ 
                    SI=0; //Long BEEP
                    PxyDirDone=20; 
                    for (MSB_value=4;MSB_value<=68;MSB_value++){ 
                              tx_buffer0[MSB_value]=0x20;
                    } 
                    SendToLCD(&tx_buffer0[4],&tx_buffer0[20],&tx_buffer0[36],&tx_buffer0[52]);  //MMM
                                                    
                    AMP_ON_OFF |=0x8;// make long buzzer sound 
                    Pointer = ProxyLrn;
                    MaxNum = CMaxProxyLrn;
                    for(i=1;i<=MaxProxyLrn;i++){
                         SI++;                                      
                         if (SI<=2)Siren_Stop();
                         if (SI==6){
                              Siren_Start(3);
                              SI=0;
                         }      
                         strcpyf(Data,"        "); 
                         for (Class=0;Class<=5;Class++){//6 Proxy
                               WriteData(i); 
                         } //6 Proxy
                    } 
                    Class=0;//6 Proxy
               }else
               if (List==3){
                    SI=0; //Long BEEP
                    PxyDirDone=20; 
                    for (MSB_value=4;MSB_value<=68;MSB_value++){ 
                              tx_buffer0[MSB_value]=0x20;
                    } 
                    SendToLCD(&tx_buffer0[4],&tx_buffer0[20],&tx_buffer0[36],&tx_buffer0[52]);  //MMM
                                                      
                    AMP_ON_OFF |=0x8;// make long buzzer sound                
                    Pointer = ProxyLrn2;
                    MaxNum = CMaxProxyLrn2;
                    for(i=1;i<=MaxProxyLrn2;i++){
                         SI++;                                      
                         if (SI<=2)Siren_Stop();
                         if (SI==6){
                              Siren_Start(3);
                              SI=0;
                         }      
                         strcpyf(Data,"        ");
                         for (Class=0;Class<=5;Class++){//6 Proxy
                               WriteData(i); 
                         } //6 Proxy
                    }
                    Class=0;//6 Proxy
               }else                       //FIX7 start
               if (List==4){  
                    Pointer = KeepName;
                    MaxNum =  CMaxKeepName;
                    strcpyf(Data,"5");
                    WriteData(1);   
                                 
                    while(1){
                         #asm("NOP"); 
                         Siren_Start(1);
                    }
               }   //FIX7 end 
               if (List==5){ //RECEIVE DATA //U_D 
                    #asm("WDR"); 
                    PORTB &=~0x2;//CLK = LOW   
                    PORTB &=~0x4;//Data = LOW  for receive mode
                    Make_20ms_Reset();//make 20msec reset pulse 
                    Valid_BusyAck=0;                    
                    while (Valid_BusyAck<10){
                         #asm("NOP"); 
                         if (!(PINB &0x8))Valid_BusyAck++;
                         else Valid_BusyAck=0;
                    } 
  
                    while(1){
                        #asm("WDR"); 
                        #asm("NOP"); 
                        Siren_Start(1);   
                        PORTA &= ~0x08; //AMP OFF
                        T_R_TimeOut=6 ; //5x4=20 msec
                        while (T_R_TimeOut){
                              while(!MainCycle){}
                              MainCycle = 0;
                              T_R_TimeOut--; 
                        }                           
                        T_R_TimeOut=255 ; //5x4=20 msec
                        PORTA |= 0x08; //AMP OFF
                        while (T_R_TimeOut){
                              while(!MainCycle){}
                              MainCycle = 0;
                              T_R_TimeOut--; 
                        } 
                    }                     
               }   //FIX7 end    
               if (List==6){                 
                    PORTB &=~0x2;//CLK = LOW   
                    PORTB |=0x4;//Data = High  for TX mode
                    Make_20ms_Reset();//make 20msec reset pulse 
               
                    while(1){
                         #asm("NOP"); 
                         Siren_Start(1);
                    }
               }   //FIX7 end //SEND DATA  //U_D                                            
               PORTA |= 0x08; //AMP OFF
               AMP_ON_OFF=0;  
               Siren_Start(1);            
          }
      }else
      if(Button == FAST)
      { 
           Info_Disply=0; //PRXO-2L         
           if((StutLine1 == pProxyLrnR) ||(StutLine1 == pProxyLrn2R)){  //PRXO 
                           Class=Scan_Pointer; 
                           WriteData(List); 
                           if(List < Maximum-9)
                                List+=10;
                           else
                           List = 1;                          
                           Class=Scan_Pointer; 
                           ReadData(List); 
                           Class=0;             
                        //PRXO             
            }else{         
                    StarPass=0;             
                    if ((StutLine1==pTel1NumR)||(StutLine1==pTel2NumR)||(StutLine1==pTel3NumR) //add dial *#f
                            ||(StutLine1==pTel4NumR)||(StutLine1==pTel5NumR)||(StutLine1==pTel6NumR)) {
                    }else {
                            if (Scan_Pointer==1)Class=1;//2 Lines 
                           //PRXO if ((StutLine1 == pProxyLrnR) ||(StutLine1 == pProxyLrn2R))Class=Scan_Pointer;//6 Proxy  
                    } //add dial *#f
                       
                    WriteData(List);
                    
                    Class=0;//2 Lines    
                   //PRXO if((StutLine1 == pProxyLrnR) ||(StutLine1 == pProxyLrn2R))Scan_Pointer=0;      //6 Proxy                
                    if (Scan_Pointer==2){
                         strcpyf(Data,"                ");
                         Class=1;
                         WriteData(List);
                         Class=0;
                    }
                    Scan_Pointer=0;//2 Lines 
                    
                    //NextDifolt = START_DEF_NAME;
                    //if(List <(Maximum-9)/2) 2LINE MODE 
                    if(List <(Maximum-9))
                       List+=10;
                    else
                    List = 1;    
                    if(StutLine1 == pNamesR){  //2 Lines 
                          Class=1; 
                          ReadData(List); 
                          Class=0;
                          StrFromEE(&rx_buffer0[0]);                 //MMM 
                          if (!EnglishMode) HebruSrting(&rx_buffer0[0]);   //2 Lines                            
                    }                       
                    ReadData(List);
                    NextCode = 1;
                    if(StutLine1 == pNamesR) {
                         NextCode = 5;   //enter zone name (7) 
                         if ( EnglishMode)NextCode = 4; //2 Lines
                    }
                    StutWord = 0;
                    ValueWord = 0;
            }
      }else
      if(Button == NEXT)
      { 
             Info_Disply=0; //PRXO-2L        
             if((StutLine1 == pProxyLrnR) ||(StutLine1 == pProxyLrn2R)){  //PRXO 
                           Class=Scan_Pointer; 
                           WriteData(List); 
                           if(List < Maximum)
                                List++;
                            else
                                List = 1;                               
                           Class=Scan_Pointer; 
                           ReadData(List);                           
                           Class=0;             
                        //PRXO             
            }else {         
                    StarPass=0;                
                    if ((StutLine1==pTel1NumR)||(StutLine1==pTel2NumR)||(StutLine1==pTel3NumR) //add dial *#f
                            ||(StutLine1==pTel4NumR)||(StutLine1==pTel5NumR)||(StutLine1==pTel6NumR)) {
                    }else {
                            if (Scan_Pointer==1)Class=1;//2 Lines  
                           //PRXO if((StutLine1 == pProxyLrnR) ||(StutLine1 == pProxyLrn2R))Class=Scan_Pointer;//6 Proxy  
                    } //add dial *#f   
                                
                    WriteData(List);
                    Class=0;//2 Lines    
                   //PRXO if((StutLine1 == pProxyLrnR) ||(StutLine1 == pProxyLrn2R))Scan_Pointer=0;      //6 Proxy              
                    if (Scan_Pointer==2){
                         strcpyf(Data,"                ");
                         Class=1;
                         WriteData(List);
                         Class=0;
                    }
                    Scan_Pointer=0;//2 Lines 
                    
                    if(StutLine1 == pServiceR){   // enter Service info
                         Pointer = 200+((List-1)*CMaxService);//OrderNames;
                         MaxNum = CMaxService;
                         WriteDataChip(1);
                    }
                    //NextDifolt = START_DEF_NAME;  
                   // if(List < Maximum/2) 2LINE MODE
                    if(List < Maximum)
                       List++;
                    else
                      List = 1;   
                    if(StutLine1 == pNamesR){  //2 Lines 
                          Class=1; 
                          ReadData(List); 
                          Class=0;
                          StrFromEE(&rx_buffer0[0]);                 //MMM 
                          if (!EnglishMode) HebruSrting(&rx_buffer0[0]);   //2 Lines                            
                    }                      
                    ReadData(List);
                    if(StutLine1 == pServiceR){   // enter Service info
                         Pointer = 200+((List-1)*CMaxService);//OrderNames;
                         MaxNum = CMaxService;
                         ReadDataChip(1);
                    }
                    NextCode = 1;
                    if(StutLine1 == pNamesR) {
                         NextCode = 5;   //enter zone name (7) 
                         if ( EnglishMode)NextCode = 4; //2 Lines
                    }
                    StutWord = 0;
                    ValueWord = 0; 
            }
      }else
      if(Button == BACK)
      { 
            Info_Disply=0; //PRXO-2L    
            if((StutLine1 == pProxyLrnR) ||(StutLine1 == pProxyLrn2R)){  //PRXO 
                           Class=Scan_Pointer; 
                           WriteData(List); 
                           if(List > 1) List--;
                           else List = Maximum;
                           NextCode = 1;                            
                           Class=Scan_Pointer; 
                           ReadData(List);                        
                           Class=0;             
                        //PRXO             
            }else {    //FIX2         
                    StarPass=0;                         
                    if ((StutLine1==pTel1NumR)||(StutLine1==pTel2NumR)||(StutLine1==pTel3NumR) //add dial *#f
                            ||(StutLine1==pTel4NumR)||(StutLine1==pTel5NumR)||(StutLine1==pTel6NumR)) {
                    }else {
                            if (Scan_Pointer==1)Class=1;//2 Lines 
                           //PRXO if((StutLine1 == pProxyLrnR) ||(StutLine1 == pProxyLrn2R))Class=Scan_Pointer;//6 Proxy    
                    } //add dial *#f 
                       
                    WriteData(List);
                    Class=0;//2 Lines    
                   //PRXO if((StutLine1 == pProxyLrnR) ||(StutLine1 == pProxyLrn2R))Scan_Pointer=0;      //6 Proxy    
                    if (Scan_Pointer==2){
                         strcpyf(Data,"                ");
                         Class=1;
                         WriteData(List);
                         Class=0;
                    }
                    Scan_Pointer=0;//2 Lines 
                    
                    if(StutLine1 == pServiceR){   // enter Service info
                         Pointer = 200+((List-1)*CMaxService);//OrderNames;
                         MaxNum = CMaxService;
                         WriteDataChip(1);
                    }
                    //NextDifolt = START_DEF_NAME;
                    if(List > 1)
                       List--;
                    else  
                       List = Maximum;
                       //List = Maximum/2;  2LINE mode 
                    NextCode = 1;
                    if(StutLine1 == pNamesR) {
                         NextCode = 5;   //enter zone name (7) 
                         if ( EnglishMode)NextCode = 4; //2 Lines
                    }
                    StutWord = 0;
                    ValueWord = 0; 
                    if(StutLine1 == pNamesR){    //2 Lines 
                          Class=1; 
                          ReadData(List); 
                          Class=0;
                          StrFromEE(&rx_buffer0[0]);                 //MMM 
                          if (!EnglishMode) HebruSrting(&rx_buffer0[0]);   //2 Lines                            
                    }                               
                    ReadData(List);
                    if(StutLine1 == pServiceR){   // enter Service info
                         Pointer = 200+((List-1)*CMaxService);//OrderNames;
                         MaxNum = CMaxService;
                         ReadDataChip(1);
                    } 
            }
      }else if(Button == L_STAR){//LONG STAR             
            if (StutLine1 == pNamesR){
                  for(i=(NextCode-1);i<=MaxNum;i++){
                         Data[i] =' '; 
                  }
                  if (!Scan_Pointer){
                       Scan_Pointer=2;
                       strcpyf(rx_buffer0,"                ");
                       StrFrom_rx_buffer0(&tx_buffer0[36]);                 //MMM  //2 Lines    
                  } 
            } 
            else if (StarPass){
                   NextCode++;
                   Bits_CNT1 |=0x1;                  
            }   
            StarPass=0;    
      }else//LONG STAR 
      //if((Button == DHSH)&&(!EraseAllDone)&&(!ButtonTimeOut))
      if((Button == DHSH)&&(!EraseAllDone))
      {     
            WaitForExit=2;//FIX6    
            AppDisplayTO=0;
            if(StutLine1==pSetReadTimeR){
                 Days=Data[0]&0xf;
                 if (Days>0)Days--;
                 if (Days>0x6)Days=0x6;
                 Data[0]=Days;
                 DataWritePCF(6,1,&Data[0]);//days
                 Data[1]&=~0xf0;
                 Data[2]&=~0xf0;
                 Hours=(Data[1]<<4)+Data[2];
                 if (Hours>0x23)Hours=0x23;
                 Data[0]=Hours;
                 DataWritePCF(4,1,&Data[0]);//hours
                 Data[3]&=~0xf0;
                 Data[4]&=~0xf0;
                 Minutes=(Data[3]<<4)+Data[4];
                 if (Minutes>0x59)Minutes=0x59;
                 Data[0]=Minutes;
                 DataWritePCF(3,1,&Data[0]);//min
                 Data[0]=0;
                 DataWritePCF(2,1,&Data[0]);//secounds
                 //LIMIT_Up();
            }
     // ButtonTimeOut=30;
            if (EnglishMode){
                 PORTA &=~ 0x08; //AMP ON 
//                 if ((PxyDirDone)&&(StutLine1 == pProxyLrnR)){ //PxyFast
//                     ArrangPrxy1();
//                 }
//                 if ((PxyDirDone)&&(StutLine1 == pProxyLrn2R)){ //PxyFast 
//                      ArrangPrxy2();           
//                 }                                                     
                 if(StutLine1==pNamesR){
                      NextCode++;
                      if(NextCode > (MaxNum-1)) { //2 Lines
                           if (!Scan_Pointer){ 
                                NextCode = 4; //FIX NAME  HEB
                                Scan_Pointer=1;
                                WriteData(List);
                                Class=1; 
                                ReadData(List);
                                Class=0;  
                           }else {                                                                  
                               if (Scan_Pointer==2){ 
                                     WriteData(List);
                                     Scan_Pointer=1; 
                                     NextCode = 4; //FIX NAME  HEB
                                     Class=1; 
                                     ReadData(List);
                                     Class=0;                                       
                               }else NextCode=MaxNum-1; 
                           }
                      } //2 Lines
                      ValueWord = 0;
                 }else {
                       fourline=0;  
                    
                       if((StutLine1 == pProxyLrnR) ||(StutLine1 == pProxyLrn2R))Class=Scan_Pointer;//6 Proxy   
                       WriteData(List); 
                       Class=0;//6 Proxy //2 Lines 
                       if((StutLine1 == pProxyLrnR) ||(StutLine1 == pProxyLrn2R))Scan_Pointer=0;      //6 Proxy 
                        
                       if ((PxyDirDone)&&(StutLine1 == pProxyLrnR)){ //PxyFast //New ENG PLACE 
                             ArrangPrxy1();
                       }
                       if ((PxyDirDone)&&(StutLine1 == pProxyLrn2R)){ //PxyFast 
                              ArrangPrxy2();           
                       } 
                                                                                                      
                       if(StutLine1 == pServiceR){   // enter Service info
                            Pointer = 200+((List-1)*CMaxService);//OrderNames;
                            MaxNum = CMaxService;
                            WriteDataChip(1);
                       }
                       PawerUp();
                       if(StutLine1 == pNamesR) OrderName();
                       FuncESC();
                 }  
                 PORTA |= 0x08; //AMP OFF                 
            }else { 
                 PORTA &=~ 0x08; //AMP ON                          
                 if((NextCode > 5)&&(StutLine1==pNamesR)){
                       NextCode--;
                       ValueWord = 0;
                 }else { 
                       fourline=0;
                       if ((StutLine1==pTel1NumR)||(StutLine1==pTel2NumR)||(StutLine1==pTel3NumR) //add dial *#f
                                ||(StutLine1==pTel4NumR)||(StutLine1==pTel5NumR)||(StutLine1==pTel6NumR)) {
                       }else {
                               if (Scan_Pointer==1)Class=1;//2 Lines 
                               if((StutLine1 == pProxyLrnR) ||(StutLine1 == pProxyLrn2R))Class=Scan_Pointer;//6 Proxy   
                       } //add dial *#f                                              

                       WriteData(List); 
                       if ((PxyDirDone)&&(StutLine1 == pProxyLrnR)){ //PxyFast
                            ArrangPrxy1();
                       }
                       if ((PxyDirDone)&&(StutLine1 == pProxyLrn2R)){ //PxyFast 
                            ArrangPrxy2();           
                       }                          MaxNum = CMaxProxyLrn2;    
                       
 
                       
                       Class=0;//6 Proxy //2 Lines     
                       if((StutLine1 == pProxyLrnR) ||(StutLine1 == pProxyLrn2R))Scan_Pointer=0;      //6 Proxy                          
                       if (Scan_Pointer==2){
                             strcpyf(Data,"                ");
                             Class=1;
                             WriteData(List);
                             Class=0;
                       }
                       Scan_Pointer=0;//2 Lines 
            
                       if(StutLine1 == pServiceR){   // enter Service info
                            Pointer = 200+((List-1)*CMaxService);//OrderNames;
                            MaxNum = CMaxService;
                            WriteDataChip(1);
                       }
                       PawerUp();
                       if(StutLine1==pSpeechLevelR){
//                            while(1){
//                                 #asm("NOP");
//                            }
                       }
                       if(StutLine1 == pNamesR) OrderName();
                       FuncESC();
                 }
                 PORTA |= 0x08; //AMP OFF                 
            }

      }else
      if(Button == BELL){
           SwapLine23_12=0;  //DISP 4 Lines to 2 lines
           if ((StutLine1==pTel1NumR)||(StutLine1==pTel2NumR)||(StutLine1==pTel3NumR)||(StutLine1==pTel4NumR)||(StutLine1==pTel5NumR)
                                 ||(StutLine1==pSetReadTimerR)||(StutLine1==pConfirmToneR)||(StutLine1==pTel6NumR)||(StutLine1==pConfirmToneR)) {
                 ClearString(NextCode,Data,MaxNum);
           }
           if (StutLine1==pNamesR){//FIX1
//                 Data[NextCode-1] = BellSaveValue;//FIX1 //was insert the last chosen one into the location by BELL
                         PORTA &=~ 0x08; //AMP ON//FIX1     
                         fourline=0;//FIX1
                         if (Scan_Pointer==2){ 
                               Class=0; 
                               WriteData(List);
                               strcpyf(Data,"                ");
                               Class=1;
                               WriteData(List);
                               Class=0;
                         }else {
                              if (Scan_Pointer)Class=1;//2 Lines 
                              WriteData(List);
                              Class=0;//2 Lines 
                         }
                         Scan_Pointer=0;//2 Lines 
                         
                         PawerUp();   //FIX1
                         OrderName();//FIX1
                         FuncESC(); //FIX1
           }//FIX1
      }
      else
            if(StutLine1==pNamesR) {  
                 Info_Disply=0;     //DISP 4 Lines to 2 lines
                 //if (!ButtonTimeOut)EnterWord();  //enter numbers or names
                 EnterWord();  //enter numbers or names    
                 Change=0; //FIX1  
                 TimeChangeWord=0;//FIX1  
                 ChangeWord = Data[NextCode-1];//FIX1 
                 StrLed();//FIX1 
                 RealTime[4] = 1;//FIX1               
            }
            else { 
                  Info_Disply=0;     //DISP 4 Lines to 2 lines
                  if ((StutLine1==pServiceR)&&(Rly1End==0)&&(Rly2Start==0))i=0;
                  else i=1;
                  if (StutLine1!=pServiceR)i=0;
                  if ((StutLine1==pProxyLrnR)||(StutLine1==pProxyLrn2R)||i==1 ){
                  }else {
                       if(NextCode == 1) ClearString(NextCode,Data,MaxNum);
                       EnterNumber();
                  } 
                  if(((StutLine1 == pProxyLrnR) ||(StutLine1 == pProxyLrn2R))&&(Button ==2)){  //6 Proxy
                       Class=Scan_Pointer; 
                       WriteData(List);    
                       Scan_Pointer++;
                       if (Scan_Pointer>5)Scan_Pointer=0; 
                       Class=Scan_Pointer; 
                       ReadData(List); 
                       Class=0;
                  }  //6 Proxy   
                      
            }
   }
}   // func
void ClearString(char NextCode,char* Data,char MaxNum)
{
   unsigned char ind;
   for(ind = NextCode-1;ind<MaxNum;ind++)
     Data[ind] = ' ';
}
void SaveProxy(char NextCode,char* Data,char MaxNum)
{
   unsigned char ind;
   for(ind = 0;ind<MaxNum;ind++){
        Data[ind] = DataCode[ind];
   }
}


void EnterNumber(void)         //enter numbers
{
     char ClrBit;
     if(((Button>0)&&(Button<0x0B))||(MINUS)){
          if(Button == 0x0A)Button = 0;
          if (MINUS){ 
              if (!((StutLine1==pToneCodesR)||(StutLine1==pConfirmToneR))){                                                 
                   if (Scan_Pointer==1)Button='*'-0x30;
                   else if (Scan_Pointer==2)Button='#'-0x30;
                   else if (Scan_Pointer==3)Button='f'-0x30;
                   else if (Scan_Pointer==4)Button=':'-0x30;
                   else Button='-'-0x30; 
                   if (NextCode==1) {
                        if (Scan_Pointer<4)Scan_Pointer++;
                        else Scan_Pointer=0;
                   }else {  
                       if (Scan_Pointer<3)Scan_Pointer++;
                        else Scan_Pointer=0;                   
                   }   
                   StarPass=1;
              }else { 
                   Button='-'-0x30;                              
              }                      
          }        
          
          if (!MINUS){               
                Data[NextCode-1] = 0x30 + Button; 
                NextCode++;   
                StarPass=0;
          }else {              
               Data[NextCode-1] = 0x30 + Button;
               if ((StutLine1==pToneCodesR)||(StutLine1==pConfirmToneR))NextCode++;    
          }
          MINUS=0;  
          if(NextCode>MaxNum)
          {
                if ((StutLine1==pFloorValueR)||(StutLine1==pRelayControlR)){
                     if ( (( Data[0]&0xf )*100)+(( Data[1]&0xf )*10)+( Data[2]&0xf )  >NAMEN){
                          Data[0]=0x31;
                          Data[1]=0x39;  //over NAMEN app
                          Data[2]=0x39;
                     }
                }
                if ((StutLine1==pAnswerY_NR)||(StutLine1==pMasageOnR)){
                          if ( Data[0]==0x30)Data[0]=0x4E; // no = N
                          else Data[0]=0x59;//yes = Y
                }
                NextCode = 1;
          }
     }
     ValueWord = 0;
}
void EnterCode(void)
{
   if((Button>0)&&(Button<0x0B))
   {
      if(Button == 0x0A)Button = 0;
      UserCode[NextCode-1]  = 0x30 + Button;
      NextCode++;
         if(NextCode>MaxNum+1)
                NextCode--;
   }
}
void EnterWord(void)              //enter  Name
{
     unsigned char Azer;
     StutWord = 0;
     if((Button>0)&&(Button<0x0B))
     {

        ValueWord++;  
        if(Button == 0x0A) Button = 0;//FIX1
        if (EnglishMode){
              if((Button == 7)||(Button == 9)){
              if(ValueWord>9)ValueWord = 1;
              }else
                if(ValueWord>7)ValueWord = 1;
                if((Button == 1)||(!Button))if(ValueWord>4)ValueWord = 1;//FIX1
        }else {
              if((Button == 4)||(Button == 5)||(Button == 7)||(Button == 9)){
                     if(ValueWord>9)ValueWord = 1;
                     if((Button == 4)||(Button == 5)||(Button == 7))if(ValueWord>8)ValueWord = 1;
              }else
                     if(ValueWord>7)ValueWord = 1; 
                     if((Button == 1)||(!Button))if(ValueWord>4)ValueWord = 1; //FIX1                    
        }
        


        if(!StutWord)
              Azer = GetWord(ValueWord,Button);
        else{
              Azer = ValueWord + 0x3D + (Button*3);
              if(StutWord == 2)Azer+= 0x20;
        }
        if(!Button){
              if(ValueWord==1) Azer = ' ';
              if(ValueWord==2) Azer = '(';
              if(ValueWord==3) Azer = ')';
        }
        Data[NextCode-1] = Azer;
        BellSaveValue= Azer;
    }
}
char GetWord(char Value, char Batton){
   if (EnglishMode){
          if(Batton == 1){
                if(Value == 1) return('.');
                if(Value == 2) return('-');
                if(Value == 3) return(',');
          }
          if(Batton == 2){
                if(Value == 1) return('A');
                if(Value == 2) return('B');
                if(Value == 3) return('C');
                if(Value == 4) return('a');
                if(Value == 5) return('b');
                if(Value == 6) return('c');
          }
          if(Batton == 3){
                if(Value == 1) return('D');
                if(Value == 2) return('E');
                if(Value == 3) return('F');
                if(Value == 4) return('d');
                if(Value == 5) return('e');
                if(Value == 6) return('f');
          }
          if(Batton == 4){
                if(Value == 1) return('G');
                if(Value == 2) return('H');
                if(Value == 3) return('I');
                if(Value == 4) return('g');
                if(Value == 5) return('h');
                if(Value == 6) return('i');
          }
          if(Batton == 5){
                if(Value == 1) return('J');
                if(Value == 2) return('K');
                if(Value == 3) return('L');
                if(Value == 4) return('j');
                if(Value == 5) return('k');
                if(Value == 6) return('l');
          }
          if(Batton == 6){
                if(Value == 1) return('M');
                if(Value == 2) return('N');
                if(Value == 3) return('O');
                if(Value == 4) return('m');
                if(Value == 5) return('n');
                if(Value == 6) return('o');
          }
          if(Batton == 7){
                if(Value == 1) return('P');
                if(Value == 2) return('Q');
                if(Value == 3) return('R');
                if(Value == 4) return('S');
                if(Value == 5) return('p');
                if(Value == 6) return('q');
                if(Value == 7) return('r');
                if(Value == 8) return('s');
          }
          if(Batton == 8){
                if(Value == 1) return('T');
                if(Value == 2) return('U');
                if(Value == 3) return('V');
                if(Value == 4) return('t');
                if(Value == 5) return('u');
                if(Value == 6) return('v');
          }
          if(Batton == 9){
                if(Value == 1) return('W');
                if(Value == 2) return('X');
                if(Value == 3) return('Y');
                if(Value == 4) return('Z');
                if(Value == 5) return('w');
                if(Value == 6) return('x');
                if(Value == 7) return('y');
                if(Value == 8) return('z');
          }
   }else {
     if(Batton == 1){
           if(Value == 1) return('.');
           if(Value == 2) return('-');
           if(Value == 3) return(',');
     }
     if(Batton == 2){
           if(Value == 1) return('ד');
           if(Value == 2) return('ה');
           if(Value == 3) return('ו');
           if(Value == 4) return('A');
           if(Value == 5) return('B');
           if(Value == 6) return('C');
     }
     if(Batton == 3){
           if(Value == 1) return('א');
           if(Value == 2) return('ב');
           if(Value == 3) return('ג');
           if(Value == 4) return('D');
           if(Value == 5) return('E');
           if(Value == 6) return('F');
     }
     if(Batton == 4){
           if(Value == 1) return('מ');
           if(Value == 2) return('ם');
           if(Value == 3) return('נ');
           if(Value == 4) return('ן');
           if(Value == 5) return('G');
           if(Value == 6) return('H');
           if(Value == 7) return('I');
     }
     if(Batton == 5){
           if(Value == 1) return('י');
           if(Value == 2) return('כ');
           if(Value == 3) return('ך');
           if(Value == 4) return('ל');
           if(Value == 5) return('J');
           if(Value == 6) return('K');
           if(Value == 7) return('L');
     }
     if(Batton == 6){
           if(Value == 1) return('ז');
           if(Value == 2) return('ח');
           if(Value == 3) return('ט');
           if(Value == 4) return('M');
           if(Value == 5) return('N');
           if(Value == 6) return('O');
     }
     if(Batton == 7){
           if(Value == 1) return('ר');
           if(Value == 2) return('ש');
           if(Value == 3) return('ת');
           if(Value == 4) return('P');
           if(Value == 5) return('Q');
           if(Value == 6) return('R');
           if(Value == 7) return('S');
     }
     if(Batton == 8){
           if(Value == 1) return('צ');
           if(Value == 2) return('ץ');
           if(Value == 3) return('ק');
           if(Value == 4) return('T');
           if(Value == 5) return('U');
           if(Value == 6) return('V');
     }
     if(Batton == 9){
           if(Value == 1) return('ס');
           if(Value == 2) return('ע');
           if(Value == 3) return('פ');
           if(Value == 4) return('ף');
           if(Value == 5) return('W');
           if(Value == 6) return('X');
           if(Value == 7) return('Y');
           if(Value == 8) return('Z');
     }
   }
   return(Batton+0x30);

}
void  SendDataToKeybord(void)
{
     unsigned  char NumValue,MSB_Type4,Hund;
     unsigned  int ReusltT2,RemindT2;
     unsigned char index = 3;
     unsigned char Close = 0xFF, CloseLED = 0xFF;
     tx_buffer0[1] = 0x10 + IndexBord;
     tx_buffer0[2] = 0x10 + IndexBord;
     tx_buffer0[3] = Tor;
      if(Tor == 4)
      {
                tx_buffer0[3]+= 0x50;
                tx_buffer0[1] = 0x10;
                tx_buffer0[2] = 0x10 + MaxBord;
      }
     switch (Tor)
     {

        case 2:
        break;
        case 3:
          tx_buffer0[4] = Beap;
          index = 4;
        break;
        case 4:
                  String(StutLine1,&tx_buffer0[4]);
                  if(Status > 1){
                        StrFromEE(&tx_buffer0[20]);
                        if(Status == 3)
                              HebruSrting(&tx_buffer0[20]);
                  }else
                  if(BuferSlavePointer[IndexBord]){
                        if(BuferSlaveStatus[IndexBord]){
                        }
                  }else
                  if(NamePointer && CounterRing){
                        fourline=2;
                        Pointer = Name;
                        MaxNum = CMaxName;                     //MMM
                        if (AddedType==3){
                             ReadData(NewAppNo);
                             AppCalled= NewAppNo;
                        }
                        else if (!AddedType){
                             ReadData(NamePointer);
                             AppCalled= NamePointer;
                        }else if (AddedType==1){
                             ReadData(NamePointer-AddedValue);
                             AppCalled= NamePointer-AddedValue;
                        }
                        else if (AddedType==2){
                             NamePointerTmp=(NamePointer/100)-1;
                             NamePointerTmp *= AddedValue;
                             NumValue= NamePointer%100;
                             NumValue =NumValue+NamePointerTmp;
                             ReadData(NumValue); 
                             AppCalled= NumValue;//404
                        }else if (AddedType==4){   //0402
                             NumValue=(AppCode[0]&0xf)*10+(AppCode[1]&0xf)-1;  //calculate the correct app 
                             NumValue += (AppCode[2]&0xf)*10+(AppCode[3]&0xf);         
                             ReadData(NumValue);
                             Data[0]=0x20;  
                             AppCalled= NumValue;//404
                        }   //0402       
                        Floor_Test=AppCalled;//Floor_fix
                        if (SafeDisp){//FIX1
                             SafeDisp--; //FIX1
                             if (!SafeDisp){
                                 MemAppCntCode=AppCntCode;//FIX1 Memory the last code for bell use 
                                  AppCntCode=0;//FIX1  
                                  AppDisplayTO=0;//FIX4                                                                                                    
                             }
                        }//FIX1                        
                        if (EnglishMode){
                             if (!(YesNoAnswer&0x1))strcpyf(&tx_buffer0[20],"app. ringing    "); //MENU
                             else strcpyf(&tx_buffer0[20],"Office Ring     ");
                             if (YesNoAnswer2 &0x20)strcpyf(&tx_buffer0[20],"Tenant Ring     ");                             
                             NamePointerTmp=NamePointer;
                             if (NamePointerTmp>99){
                                  tx_buffer0[32] = 0x30+(NamePointerTmp/100);
                                  (NamePointerTmp=NamePointerTmp%100);
                             }
                             tx_buffer0[33] = 0x30 + NamePointerTmp/10;
                             tx_buffer0[34] = 0x30 + NamePointerTmp%10;  
                             if (AddedType==4){//0402 
                                 tx_buffer0[31] = 0x30 + AppCode[0];
                                 tx_buffer0[32] = 0x30 + AppCode[1];                                 
                                 tx_buffer0[33] = 0x30 + AppCode[2];
                                 tx_buffer0[34] = 0x30 + AppCode[3];                           
                             } //0402                                                          
                             StrFromEE(&tx_buffer0[36]);                 //MMM
                             strcpyf(&tx_buffer0[04],"               ");
                             strcpyf(&tx_buffer0[52],"               "); 
                             if (AddedType<4){
                                     tx_buffer0[36]='T';
                                     tx_buffer0[37]='o';
                                     tx_buffer0[38]=':';  
                             }
                             Class=1;               //2 Lines             
                             ReadData(AppCalled); //404
                             if (AddedType>=4)Data[0]=0;
                             else{ 
                                     Data[0]=0x20; //Alon
                                     Data[1]=0x20;
                                     Data[2]=0x20;
                             }

                             Class=0; 
                             StrFromEE(&tx_buffer0[52]);     //  2 Lines   
                             if (Show_NextDial){//REDIAL 3  
                                     strcpyf(&tx_buffer0[4],"Try Call Other  ");
                                     tx_buffer0[20]=' '; 
                                     tx_buffer0[20]='a';   
                             } //REDIAL 3                                                     
                        }else {                              
                             if (!(YesNoAnswer&0x1)) strcpyf(&tx_buffer0[20]," מצלצל לדירה 30 ");
                             else strcpyf(&tx_buffer0[20]," מצלצל למשרד 30 ");
                              if (YesNoAnswer2 &0x20)strcpyf(&tx_buffer0[20]," מצלצל לדייר 30 ");//MENU 
                             SwapLine23_12=1;  //DISP 4 Lines to 2 lines   
                             NamePointerTmp=NamePointer;
                             if (NamePointerTmp>99){
                                  Hund=NamePointerTmp/100;
                                  tx_buffer0[35] = 0x30+(NamePointerTmp/100); 
                                  (NamePointerTmp=NamePointerTmp%100);
                             }
                             tx_buffer0[34] = 0x30 + NamePointerTmp/10;
                             tx_buffer0[33] = 0x30 + NamePointerTmp%10; 
                             if (AddedType==4){//0402 
                                 tx_buffer0[35] = 0x30 + AppCode[0];
                                 tx_buffer0[34] = 0x30 + AppCode[1];                                 
                                 tx_buffer0[33] = 0x30 + AppCode[2];
                                 tx_buffer0[32] = 0x30 + AppCode[3];                       
                             } //0402                                     
                             HebruSrting(&tx_buffer0[20]);
                             StrFromEE(&tx_buffer0[36]);                 //MMM
                             HebruSrting(&tx_buffer0[36]);
                             strcpyf(&tx_buffer0[04],"               ");
                             Class=1;               //2 Lines             
                             ReadData(AppCalled);  //404  
                             
                             if (AddedType>=4)Data[0]=0;
                             else{ 
                                     Data[0]=0x20; //Alon
                                     Data[1]=0x20;
                                     Data[2]=0x20;
                             }
                                                
                             Class=0; 
                             StrFromEE(&tx_buffer0[52]);                 //MMM
                             HebruSrting(&tx_buffer0[52]);   //2 Lines 
                             if (Show_NextDial){//REDIAL 3  
                                     strcpyf(&tx_buffer0[4],"  מנסה מספר אחר ");
                                     if ((!Hund)||(Hund>9))tx_buffer0[20]=' ';
                                     else tx_buffer0[20]= 0x30+Hund;
                                      
                             } //REDIAL 3
//                             if (tx_buffer0[47]==' ')tx_buffer0[47]=0xac;  //FIX1
//                             else tx_buffer0[48]=0xac;
                        } 
                        
                  }
                  else
                  if((!FlagOpenDoor)&&(!FlagOpenDoor2)&&(NamePointer)&&(!FlagWait2)
                                &&(!FlagWait)&&(!WaitDisplay)&& DisplaySelected && !Status ){
                        fourline=2;
                        Pointer = Name;
                        MaxNum = CMaxName;                     //MMM
                        if (AddedType==3){
                             ReadData(NewAppNo);
                             AppCalled= NewAppNo;
                        }
                        else if (AddedType==4){//0402 
                             Type4App=(AppCode[0]&0xf)*10+(AppCode[1]&0xf)-1;  //calculate the correct app 
                             Type4App += (AppCode[2]&0xf)*10+(AppCode[3]&0xf);                        
                             ReadData(Type4App);
                             AppCalled= Type4App; //404                 
                        } //0402
                        else if (!AddedType){
                             ReadData(NamePointer);
                             AppCalled= NamePointer;
                        }else if (AddedType==1){
                             ReadData(NamePointer-AddedValue);
                             AppCalled= NamePointer-AddedValue;
                        }
                        else if (AddedType==2){
                             NamePointerTmp=(NamePointer/100)-1;
                             NamePointerTmp *= AddedValue;
                             NumValue= NamePointer%100;
                             NumValue =NumValue+NamePointerTmp;
                             ReadData(NumValue);
                             AppCalled=NumValue;//404
                        }                        
                        if (SafeDisp){//FIX1
                             SafeDisp--; //FIX1
                             Siren_Start(7); //FIX1   
                             if (!SafeDisp){ 
                                  MemAppCntCode=AppCntCode;//FIX1 Memory the last code for bell use 
                                  AppCntCode=0;//FIX1                                                                                                         
                             }
                        }//FIX1
                        if (EnglishMode){
                             if (!(YesNoAnswer&0x1))strcpyf(&tx_buffer0[20],"Select app.     "); //MENU
                             else strcpyf(&tx_buffer0[20],"Select Office  "); 
                             if (YesNoAnswer2 &0x20)strcpyf(&tx_buffer0[20],"Selected         ");
                             NamePointerTmp=NamePointer;
                             if (NamePointerTmp>99){
                                  tx_buffer0[32] = 0x30+(NamePointerTmp/100);
                                  (NamePointerTmp=NamePointerTmp%100);
                             }
                             tx_buffer0[33] = 0x30 + NamePointerTmp/10;
                             tx_buffer0[34] = 0x30 + NamePointerTmp%10;    
                             if (AddedType==4){//0402 
                                 tx_buffer0[31] = 0x30 + AppCode[0];
                                 tx_buffer0[32] = 0x30 + AppCode[1];                                 
                                 tx_buffer0[33] = 0x30 + AppCode[2];
                                 tx_buffer0[34] = 0x30 + AppCode[3];
                                 Type4App=1;                         
                             } //0402                                                   
                             StrFromEE(&tx_buffer0[36]);                 //MMM
                             strcpyf(&tx_buffer0[04],"               ");
 
                             strcpy(&tx_buffer0[4], &tx_buffer0[20]); //strcpy(destination, source); //2 Lines                                 
                             Class=1;               //2 Lines             
                             ReadData(AppCalled);//404 
                              
                             if (AddedType>=4)Data[0]=0;
                             else{ 
                                     Data[0]=0x20; //Alon
                                     Data[1]=0x20;
                                     Data[2]=0x20;
                             }
                         
                             Class=0; 
                             StrFromEE(&tx_buffer0[36]);        //2 Lines  
                             strcpyf(&tx_buffer0[52],"Press B to call");                                     
                        }else {
                             if (!(YesNoAnswer&0x1)) strcpyf(&tx_buffer0[20],"  נבחרה דירה 30 ");
                             else strcpyf(&tx_buffer0[20],"  נבחר משרד  30 "); 
                             if (YesNoAnswer2 &0x20)strcpyf(&tx_buffer0[20],"  נבחר דייר  30 ");
                             NamePointerTmp=NamePointer;
                             if (NamePointerTmp>99){
                                  tx_buffer0[35] = 0x30+(NamePointerTmp/100);
                                  (NamePointerTmp=NamePointerTmp%100);
                             }
                             tx_buffer0[34] = 0x30 + NamePointerTmp/10;
                             tx_buffer0[33] = 0x30 + NamePointerTmp%10; 
                             if (AddedType==4){ //0402
//                                  if(AppCode[3]==0xA)tx_buffer0[32]=0x30;
//                                  else tx_buffer0[32]=0x30+AppCode[3];
//                                  if (!(NamePointer/100)) tx_buffer0[35] = 0x30;
                                     tx_buffer0[32]=AppCode[3]+0x30;
                                     tx_buffer0[33]=AppCode[2]+0x30;
                                     tx_buffer0[34]=AppCode[1]+0x30;
                                     tx_buffer0[35]=AppCode[0]+0x30;
                                     Type4App=1;
                             }//0402                             
                             HebruSrting(&tx_buffer0[20]);
                             StrFromEE(&tx_buffer0[36]);                 //MMM
                             HebruSrting(&tx_buffer0[36]);
                             strcpyf(&tx_buffer0[04],"               ");
                             strcpyf(&tx_buffer0[52],"               "); 
                             strcpy(&tx_buffer0[4], &tx_buffer0[20]); //strcpy(destination, source); //2 Lines   
                             HebruSrting(&tx_buffer0[4]);   //2 Lines                                                                 
                 
//                             tx_buffer0[5]='ה'-0x40;  //2 Lines 
//                             tx_buffer0[6]='ק'-0x40;
//                             tx_buffer0[7]='ש'-0x40;
//
//                             tx_buffer0[9]='פ'-0x40;;
//                             tx_buffer0[10]='ע'-0x40;;
//                             tx_buffer0[11]='מ'-0x40;;
//                             tx_buffer0[12]='ו'-0x40;;
//                             tx_buffer0[13]='ן'-0x40;;
//
//                             tx_buffer0[15]='ל'-0x40;;
//                             tx_buffer0[16]='צ'-0x40;;
//                             tx_buffer0[17]='ל'-0x40;;
//                             tx_buffer0[18]='צ'-0x40;;
//                             tx_buffer0[19]='ל'-0x40;;  //2 Lines 
                             Class=1;               //2 Lines 
//                             if (AddedType==4) ReadData(Type4App);//0402         
//                             else ReadData(NamePointer); //0402 
                             ReadData(AppCalled);//404 

                             if (AddedType>=4)Data[0]=0;
                             else{ 
                                     Data[0]=0x20; //Alon
                                     Data[1]=0x20;
                                     Data[2]=0x20;
                             }
 
                             Class=0; 
//                             StrFromEE(&tx_buffer0[52]);                 //MMM
//                             HebruSrting(&tx_buffer0[52]);   //2 Lines  
                             StrFromEE(&tx_buffer0[36]);                 //MMM
                             HebruSrting(&tx_buffer0[36]);   //2 Lines      
                             tx_buffer0[66]='ה'-0x40;
                             tx_buffer0[65]='ק'-0x40;
                             tx_buffer0[64]='ש'-0x40;

                             tx_buffer0[62]='פ'-0x40;;
                             tx_buffer0[61]='ע'-0x40;;
                             tx_buffer0[60]='מ'-0x40;;
                             tx_buffer0[59]='ו'-0x40;;
                             tx_buffer0[58]='ן'-0x40;;

                             tx_buffer0[56]='ל'-0x40;;
                             tx_buffer0[55]='צ'-0x40;;
                             tx_buffer0[54]='ל'-0x40;;
                             tx_buffer0[53]='צ'-0x40;;
                             tx_buffer0[52]='ל'-0x40;;                                                                      
                                                             
                        }
                  }else
                  if((!FlagOpenDoor)&&(!FlagOpenDoor2)&&(!FlagWait2)&&(!FlagWait)&&(!WaitDisplay)&& NamePointer && !Status){
                        fourline=2;
                        if (AddedType==3){
                             Pointer = NewNo;
                             MaxNum =  CMaxNewNo;
                             ReadData(NamePointer);
                             if(Data[1] == ' ')  NewAppNo = (Data[0]&0x0f);
                             else if(Data[2] == ' ')  NewAppNo = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
                             else {
                                    NewAppNo = (Data[0]&0x0f);
                                    NewAppNo *=100;
                                    NewAppNo = NewAppNo+(Data[1]&0x0f)*10 + (Data[2]&0x0f);
                             }
                             NamePointerTmp=NewAppNo;
                        }
                        Pointer = Name;
                        MaxNum = CMaxName;
                        if (Bits_CNT1 &0x2){//2 Lines 
                             Class=1; //2 Lines 
                             ReadData(NamePointer); 
                             Class=0; 
                             if (!(strncmp(Data,"                ", 16)))ReadData(NamePointer);; 
                        }else ReadData(NamePointer);//2 Lines 
                  
                        StrFromEE(&tx_buffer0[4]);
                        if (!AddedType){
                             NamePointerTmp=NamePointer;
                        }
                        if (AddedType==1){
                             NamePointerTmp = NamePointer+AddedValue;//FIX4
                        }
                        else if (AddedType==2){   
                            NamePointerTmp = NamePointer;//FIX4  //0402
                            if(NamePointerTmp){
                                    ReusltT2=NamePointerTmp/ AddedValue;
                                    RemindT2=NamePointerTmp% AddedValue; 
                                    if (!RemindT2){
                                         ReusltT2--; 
                                         RemindT2=AddedValue; 
                                    }
                                    NamePointerTmp =((ReusltT2+1)*100)+(RemindT2);//FIX4 
                            }
                            if (NamePointerTmp>999)NamePointerTmp=0;

//                             if (NamePointerTmp < AddedValue )NamePointerTmp +=100;
//                             else if (NamePointerTmp < (2*AddedValue) )NamePointerTmp +=200;
//                             else if (NamePointerTmp < (3*AddedValue) )NamePointerTmp +=300;
//                             else if (NamePointerTmp < (4*AddedValue) )NamePointerTmp +=400;
//                             else if (NamePointerTmp < (5*AddedValue) )NamePointerTmp +=500;
//                             else if (NamePointerTmp < (6*AddedValue) )NamePointerTmp +=600;
//                             else if (NamePointerTmp < (7*AddedValue) )NamePointerTmp +=700;
//                             else if (NamePointerTmp < (8*AddedValue) )NamePointerTmp +=800;
//                             else if (NamePointerTmp < (9*AddedValue) )NamePointerTmp +=900; //0402
                        }else if (AddedType==4){ 
                            NamePointerTmp = NamePointer;//FIX4  //0402
                            if(NamePointerTmp){
                                    ReusltT2=NamePointerTmp/ AddedValue;
                                    RemindT2=NamePointerTmp% AddedValue; 
                                    if (!RemindT2){
                                         ReusltT2--; 
                                         RemindT2=AddedValue; 
                                    }
                                    ReusltT2++;
                                    if (ReusltT2>=10){
                                         MSB_Type4=(ReusltT2/10); 
                                         if (MSB_Type4>9)MSB_Type4=0xf; //disply up to 99 0402                                       
                                         ReusltT2 %=10;                                          
                                    }else{
                                         MSB_Type4=0;
                                    }                                    
                                    NamePointerTmp =((ReusltT2)*100)+(RemindT2);//FIX4 
                            }                            
                        }
                        if (EnglishMode){
                             if (NamePointerTmp>99){
                                  tx_buffer0[4] = 0x30+(NamePointerTmp/100);
                                  (NamePointerTmp=NamePointerTmp%100);
                             }
                             tx_buffer0[5] = 0x30 + NamePointerTmp/10;
                             tx_buffer0[6] = 0x30 + NamePointerTmp%10;
                             if (AddedType==4){  
                                  tx_buffer0[7]=tx_buffer0[6];
                                  tx_buffer0[6]=tx_buffer0[5];
                                  tx_buffer0[5]=tx_buffer0[4];
                                  tx_buffer0[4]=0x30+MSB_Type4;
                                  if (tx_buffer0[5]==' ')tx_buffer0[5]=0x30;
                             }
                        }else{
                             if (NamePointerTmp>99){
                                  tx_buffer0[7] =  0x30+(NamePointerTmp/100);
                                  (NamePointerTmp=NamePointerTmp%100);
                             }
                             tx_buffer0[6] = 0x30 + NamePointerTmp/10;
                             tx_buffer0[5] = 0x30 + NamePointerTmp%10; 
                             if (AddedType==4){
                                   tx_buffer0[8]=0x30+MSB_Type4; 
                                   if (tx_buffer0[7]==' ')tx_buffer0[7]=0x30;
                             }                     
                        }
                        if (AddedType==3){
                             Pointer = NewNo;
                             MaxNum =  CMaxNewNo;
                             ReadData(NamePointerN1);
                             if(Data[1] == ' ')  NewAppNo = (Data[0]&0x0f);
                             else if(Data[2] == ' ')  NewAppNo = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
                             else {
                                    NewAppNo = (Data[0]&0x0f);
                                    NewAppNo *=100;
                                    NewAppNo = NewAppNo+(Data[1]&0x0f)*10 + (Data[2]&0x0f);
                             }
                             NamePointerTmp=NewAppNo;
                        }
                        Pointer = Name;
                        MaxNum = CMaxName; 
                        if (Bits_CNT1 &0x2){//2 Lines 
                             Class=1; //2 Lines 
                             ReadData(NamePointerN1); 
                             Class=0; 
                             if (!(strncmp(Data,"                ", 16)))ReadData(NamePointerN1);; 
                        }else ReadData(NamePointerN1); //2 Lines
                       
                        StrFromEE(&tx_buffer0[20]);
                        if (!AddedType){
                             NamePointerTmp=NamePointerN1;
                        }
                        else if (AddedType==1){
                             NamePointerTmp = NamePointerN1+AddedValue;  //FIX4
                        }
                        else if (AddedType==2){   
                            NamePointerTmp = NamePointerN1;//FIX4  //0402
                            if(NamePointerTmp){
                                    ReusltT2=NamePointerTmp/ AddedValue;
                                    RemindT2=NamePointerTmp% AddedValue; 
                                    if (!RemindT2){
                                         ReusltT2--; 
                                         RemindT2=AddedValue; 
                                    }
                                    NamePointerTmp =((ReusltT2+1)*100)+(RemindT2);//FIX4 
                            }
                            if (NamePointerTmp>999)NamePointerTmp=0;          
//                             NamePointerTmp = NamePointerN1;//FIX4
//                             if (NamePointerTmp < AddedValue )NamePointerTmp +=100;
//                             else if (NamePointerTmp < (2*AddedValue) )NamePointerTmp +=200;
//                             else if (NamePointerTmp < (3*AddedValue) )NamePointerTmp +=300;
//                             else if (NamePointerTmp < (4*AddedValue) )NamePointerTmp +=400;
//                             else if (NamePointerTmp < (5*AddedValue) )NamePointerTmp +=500;
//                             else if (NamePointerTmp < (6*AddedValue) )NamePointerTmp +=600;
//                             else if (NamePointerTmp < (7*AddedValue) )NamePointerTmp +=700;
//                             else if (NamePointerTmp < (8*AddedValue) )NamePointerTmp +=800;
//                             else if (NamePointerTmp < (9*AddedValue) )NamePointerTmp +=900; //0402
                        }else if (AddedType==4){
                            NamePointerTmp = NamePointerN1;//FIX4  //0402
                            if(NamePointerTmp){
                                    ReusltT2=NamePointerTmp/ AddedValue;
                                    RemindT2=NamePointerTmp% AddedValue; 
                                    if (!RemindT2){
                                         ReusltT2--; 
                                         RemindT2=AddedValue; 
                                    }
                                    ReusltT2++;
                                    if (ReusltT2>=10){
                                         MSB_Type4=(ReusltT2/10);  
                                         if (MSB_Type4>9)MSB_Type4=0xf; //disply up to 99 0402                                        
                                         ReusltT2 %=10; 
                                    }else{
                                         MSB_Type4=0;
                                    }                                    
                                    NamePointerTmp =((ReusltT2)*100)+(RemindT2);//FIX4 
                            }                                  
                        }                        
                        if (EnglishMode){
                             if (NamePointerTmp>99){
                                  tx_buffer0[20] = 0x30+(NamePointerTmp/100);
                                  (NamePointerTmp=NamePointerTmp%100);
                             }
                             tx_buffer0[21] = 0x30 + NamePointerTmp/10;
                             tx_buffer0[22] = 0x30 + NamePointerTmp%10; 
                             if (AddedType==4){   
                                   tx_buffer0[23]=tx_buffer0[22];
                                   tx_buffer0[22]=tx_buffer0[21];
                                   tx_buffer0[21]=tx_buffer0[20];                             
                                   tx_buffer0[20]=0x30+MSB_Type4; 
                                    if (tx_buffer0[21]==' ')tx_buffer0[21]=0x30;
                             }
                        }else{
                             if (NamePointerTmp>99){
                                  tx_buffer0[23] = 0x30+(NamePointerTmp/100);
                                  (NamePointerTmp=NamePointerTmp%100);
                             }
                             tx_buffer0[22] = 0x30 + NamePointerTmp/10;
                             tx_buffer0[21] = 0x30 + NamePointerTmp%10;
                             if (AddedType==4){
                                  tx_buffer0[24]=0x30+MSB_Type4; 
                                  if (tx_buffer0[23]==' ')tx_buffer0[23]=0x30;
                             }                        
                        }
                        if (!NamePointerTmp)strcpyf(&tx_buffer0[20],"                ");

                        if (AddedType==3){
                             Pointer = NewNo;
                             MaxNum =  CMaxNewNo; 
                             ReadData(NamePointerN2); 
                             if(Data[1] == ' ')  NewAppNo = (Data[0]&0x0f);
                             else if(Data[2] == ' ')  NewAppNo = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
                             else {
                                    NewAppNo = (Data[0]&0x0f);
                                    NewAppNo *=100;
                                    NewAppNo = NewAppNo+(Data[1]&0x0f)*10 + (Data[2]&0x0f);
                             }
                             NamePointerTmp=NewAppNo;
                        }
                        Pointer = Name;
                        MaxNum = CMaxName;  
                        if (Bits_CNT1 &0x2){//2 Lines 
                             Class=1; //2 Lines 
                             ReadData(NamePointerN2); 
                             Class=0; 
                             if (!(strncmp(Data,"                ", 16)))ReadData(NamePointerN2);; 
                        }else ReadData(NamePointerN2); //2 Lines
                       
                        StrFromEE(&tx_buffer0[36]);
                        if (!AddedType){
                             NamePointerTmp=NamePointerN2;
                        }
                        else if (AddedType==1){
                             NamePointerTmp = NamePointerN2+AddedValue;//FIX4
                        }
                        else if (AddedType==2){  
                                NamePointerTmp = NamePointerN2;//FIX4   //0402
                                if(NamePointerTmp){
                                        ReusltT2=NamePointerTmp/ AddedValue;
                                        RemindT2=NamePointerTmp% AddedValue; 
                                        if (!RemindT2){
                                             ReusltT2--; 
                                             RemindT2=AddedValue; 
                                        }
                                        NamePointerTmp =((ReusltT2+1)*100)+(RemindT2);//FIX4 
                                }
                                if (NamePointerTmp>999)NamePointerTmp=0;              
//                             NamePointerTmp = NamePointerN2;FIX4
//                             if (NamePointerTmp < AddedValue )NamePointerTmp +=100;
//                             else if (NamePointerTmp < (2*AddedValue) )NamePointerTmp +=200;
//                             else if (NamePointerTmp < (3*AddedValue) )NamePointerTmp +=300;
//                             else if (NamePointerTmp < (4*AddedValue) )NamePointerTmp +=400;
//                             else if (NamePointerTmp < (5*AddedValue) )NamePointerTmp +=500;
//                             else if (NamePointerTmp < (6*AddedValue) )NamePointerTmp +=600;
//                             else if (NamePointerTmp < (7*AddedValue) )NamePointerTmp +=700;
//                             else if (NamePointerTmp < (8*AddedValue) )NamePointerTmp +=800;
//                             else if (NamePointerTmp < (9*AddedValue) )NamePointerTmp +=900; //0402
                        }else if (AddedType==4){
                            NamePointerTmp = NamePointerN2;//FIX4  //0402
                            if(NamePointerTmp){
                                    ReusltT2=NamePointerTmp/ AddedValue;
                                    RemindT2=NamePointerTmp% AddedValue; 
                                    if (!RemindT2){
                                         ReusltT2--; 
                                         RemindT2=AddedValue; 
                                    }
                                    ReusltT2++;
                                    if (ReusltT2>=10){
                                         MSB_Type4=(ReusltT2/10); 
                                         if (MSB_Type4>9)MSB_Type4=0xf; //disply up to 99 0402                                         
                                         ReusltT2 %=10;   
                                    }else{
                                         MSB_Type4=0;
                                    }                                   
                                    NamePointerTmp =((ReusltT2)*100);
                                    NamePointerTmp +=(RemindT2);//FIX4 
                            }                                            
                        }
                        if (EnglishMode){
                              if (NamePointerTmp>99){
                                   tx_buffer0[36] = 0x30+(NamePointerTmp/100);
                                  (NamePointerTmp=NamePointerTmp%100);
                              }
                              tx_buffer0[37] = 0x30 + NamePointerTmp/10;
                              tx_buffer0[38] = 0x30 + NamePointerTmp%10;
                              if (AddedType==4){ 
                                   tx_buffer0[39]=tx_buffer0[38];
                                   tx_buffer0[38]=tx_buffer0[37];
                                   tx_buffer0[37]=tx_buffer0[36];                                  
                                   tx_buffer0[36]=0x30+MSB_Type4;
                                   if (tx_buffer0[37]==' ')tx_buffer0[37]=0x30;
                              }
                        }else {
                              if (NamePointerTmp>99){
                                   tx_buffer0[39] = 0x30+(NamePointerTmp/100);
                                  (NamePointerTmp=NamePointerTmp%100);
                              }
                              tx_buffer0[38] = 0x30 + NamePointerTmp/10;
                              tx_buffer0[37] = 0x30 + NamePointerTmp%10;
                              if (AddedType==4){
                                   tx_buffer0[40]=0x30+MSB_Type4;
                                   if (tx_buffer0[39]==' ')tx_buffer0[39]=0x30;
                              }
                        }
                        if (!NamePointerTmp)strcpyf(&tx_buffer0[36],"                ");

                        if (AddedType==3){
                             Pointer = NewNo;
                             MaxNum =  CMaxNewNo;
                             ReadData(NamePointerN3); 
                             if(Data[1] == ' ')  NewAppNo = (Data[0]&0x0f);
                             else if(Data[2] == ' ')  NewAppNo = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
                             else {
                                    NewAppNo = (Data[0]&0x0f);
                                    NewAppNo *=100;
                                    NewAppNo = NewAppNo+(Data[1]&0x0f)*10 + (Data[2]&0x0f);
                             }
                             NamePointerTmp=NewAppNo;
                        }
                        Pointer = Name;
                        MaxNum = CMaxName; 
                        if (Bits_CNT1 &0x2){//2 Lines 
                             Class=1; //2 Lines 
                             ReadData(NamePointerN3); 
                             Class=0; 
                             if (!(strncmp(Data,"                ", 16)))ReadData(NamePointerN3);; 
                        }else {
                              ReadData(NamePointerN3);//2 Lines    
                              Bits_CNT1 &=~0x4;//0402
                              if (!(strncmp(Data,"                ", 16)))Bits_CNT1 |=0x4;//00402
                        }
                       
                        StrFromEE(&tx_buffer0[52]);
                        if (!AddedType){
                             NamePointerTmp=NamePointerN3;
                        }
                        else if (AddedType==1){
                             NamePointerTmp = NamePointerN3+AddedValue;//FIX4
                        }
                        else if (AddedType==2){ 
                            NamePointerTmp = NamePointerN3;//FIX4  //0402 
                            if(NamePointerTmp){
                                    ReusltT2=NamePointerTmp/ AddedValue;
                                    RemindT2=NamePointerTmp% AddedValue; 
                                    if (!RemindT2){
                                         ReusltT2--; 
                                         RemindT2=AddedValue; 
                                    }
                                    NamePointerTmp =((ReusltT2+1)*100)+(RemindT2);//FIX4 
                            }
                            if (NamePointerTmp>999)NamePointerTmp=0;     
//                             NamePointerTmp = NamePointerN3;//FIX4
//                             if (NamePointerTmp < AddedValue )NamePointerTmp +=100;
//                             else if (NamePointerTmp < (2*AddedValue) )NamePointerTmp +=200;
//                             else if (NamePointerTmp < (3*AddedValue) )NamePointerTmp +=300;
//                             else if (NamePointerTmp < (4*AddedValue) )NamePointerTmp +=400;
//                             else if (NamePointerTmp < (5*AddedValue) )NamePointerTmp +=500;
//                             else if (NamePointerTmp < (6*AddedValue) )NamePointerTmp +=600;
//                             else if (NamePointerTmp < (7*AddedValue) )NamePointerTmp +=700;
//                             else if (NamePointerTmp < (8*AddedValue) )NamePointerTmp +=800;
//                             else if (NamePointerTmp < (9*AddedValue) )NamePointerTmp +=900;//0402
                        }else if (AddedType==4){ 
                            NamePointerTmp = NamePointerN3;//FIX4  //0402
                           if(NamePointerTmp){
                                    ReusltT2=NamePointerTmp/ AddedValue;
                                    RemindT2=NamePointerTmp% AddedValue; 
                                    if (!RemindT2){
                                         ReusltT2--; 
                                         RemindT2=AddedValue; 
                                    }
                                    ReusltT2++;
                                    if (ReusltT2>=10){
                                         MSB_Type4=(ReusltT2/10);  
                                         if (MSB_Type4>9)MSB_Type4=0xf; //disply up to 99 0402                                        
                                         ReusltT2 %=10; 
                                    }else{
                                         MSB_Type4=0;
                                    }                                    
                                    NamePointerTmp =((ReusltT2)*100)+(RemindT2);//FIX4 
                            }                                          
                        }                        
                        if (EnglishMode){
                             if (NamePointerTmp>99){
                                   tx_buffer0[52] = 00x30+(NamePointerTmp/100);
                                  (NamePointerTmp=NamePointerTmp%100);
                             }
                             tx_buffer0[53] = 0x30 + NamePointerTmp/10;
                             tx_buffer0[54] = 0x30 + NamePointerTmp%10;
                             if (AddedType==4){ 
                                   tx_buffer0[55]=tx_buffer0[54];
                                   tx_buffer0[54]=tx_buffer0[53];
                                   tx_buffer0[53]=tx_buffer0[52];                                 
                                   tx_buffer0[52]=0x30+MSB_Type4;
                                   if (tx_buffer0[53]==' ')tx_buffer0[53]=0x30;
                             }
                           //  if (!NamePointerTmp)strcpyf(&tx_buffer0[52],"----- END ------ "); 
                             if (Bits_CNT1 &0x4)strcpyf(&tx_buffer0[52],"----- END ------ ");
                             if (AddedType>=5){
                             }

                        }else {
                             if (NamePointerTmp>99){
                                   tx_buffer0[55] = 0x30+(NamePointerTmp/100);
                                  (NamePointerTmp=NamePointerTmp%100);
                             }
                             tx_buffer0[54] = 0x30 + NamePointerTmp/10;
                             tx_buffer0[53] = 0x30 + NamePointerTmp%10;                                 
                             if (AddedType==4){
                                   tx_buffer0[56]=0x30+MSB_Type4; 
                                   if (tx_buffer0[55]==' ')tx_buffer0[55]=0x30;
                             } 
                                                                      
                            // if (!NamePointerTmp)strcpyf(&tx_buffer0[52]," ---- סוף ------ ");
                             if (Bits_CNT1 &0x4)strcpyf(&tx_buffer0[52]," ---- סוף ------ ");
                             if (AddedType>=5){  

                             }                                
                        }

                        HebruSrting(&tx_buffer0[20]);
                        HebruSrting(&tx_buffer0[36]);
                        HebruSrting(&tx_buffer0[52]);
                  }
                  else{
                        String(StutLine2,&tx_buffer0[20]);
                        HebruSrting(&tx_buffer0[20]);
                  }

                 // if (!VoiceIC_Mode)
                  Disable_RelayTime();// for 30 usec timer stop it
                  HebruSrting(&tx_buffer0[4]);       //MMM
                  SendToLCD(&tx_buffer0[4],&tx_buffer0[20],&tx_buffer0[36],&tx_buffer0[52]);  //MMM
                  Enable_RelayTime();
                    
                if (EnglishMode){
                     if (AddedType==4){
                           tx_buffer0[7]=0x30+(NamePointerTmp/1000);
                     } 
                }else{
            
                }                  

        break;
        case 5:
           tx_buffer0[4] = NumBit;
           index = 4;
        break;
        case 6:

        break;
        case 9:
           tx_buffer0[4] = (Status);
           tx_buffer0[5] = BigName;

           tx_buffer0[6] = RingTime;  // ringing time
           tx_buffer0[7] = WaitTime;   // delay open
           tx_buffer0[8] = OpenDoorTime;   // open time
           tx_buffer0[9] = LightTime;
           tx_buffer0[10] = HoldRemoteRly;
           HoldRemoteRly=0;
           index = 10;
        break;

     }
     tx_buffer0[0] = index;
     tx_rd_index0 = 0;
     ValueChecsum = 0;
     //PORTE|=0x04;          // Send
     Sending = 1;
     StatusUart = 1;
     // NO EXKB     UDR0 = tx_buffer0[0];   // first data

}

void SendToLCD(char* str1,char* str2,char* str3,char* str4){
     unsigned char i,Error,ind,AppPoint;//FIX6

     if((StutLine1 == pProxyLrnR)||(StutLine1 == pProxyLrn2R)||(StutLine1==pAnswerY_NR)||(StutLine1==pMasageOnR)||(StutLine1==pEraseAllR)
       ||((StutLine1 == pTimeCycleR)&&(List==6))||((StutLine1 == pTimeCycleR)&&((List>=10)||(List==7)))||(StutLine1 == pRelayControlR)||(StutLine1==pFloorValueR)
       ||(StutLine1==pSetReadTimerR)||(StutLine1==pBusySogToneR)||(StutLine1==pSetReadTimeR)||(StutLine1==pExtKeysR)||(StutLine1==pCodesR)||(StutLine1==pCommSpdR)
       ||(StutLine1==pFamilyNoR)||(StutLine1==pOfsetR)||(StutLine1 ==pTel1NumR)||(StutLine1 ==pTel2NumR)||(StutLine1 ==pTel3NumR)
       ||(StutLine1 == pConfirmToneR)||(StutLine1 ==pTel4NumR)||(StutLine1 ==pTel5NumR)||(StutLine1 ==pTel6NumR)||(Status==1))fourline=1;// Put 4 line sign 
       //FIX MENU add tel1-tel6 to list 
       
       if (Pointer == NewNo)fourline=0; //error = during new number show 006 in 4 lines    //FIX7

     if (fourline==0){
          str3=str2;
          str2=str1;
          strcpyf(str4,"                 ");
          str1=str4;
     }
     if (fourline==1){
          if(StutLine1==pNamesR){
             //  strcpyf(str3,"               "); //2 Lines  
               StrFrom_rx_buffer0(&tx_buffer0[36]);                 //MMM  //2 Lines        
               if (EnglishMode){                               
                    strcpyf(str4,"EXIT <- *  # ->");
               }else {
             //  strcpyf(str3,"                 "); //MMM //2 Lines                                     
                    strcpyf(str4," יציאה>- #  * -<");
                    HebruSrting(str4);
               }
          } 
          else if((StutLine1 == pProxyLrnR)||(StutLine1 == pProxyLrn2R)||(StutLine1==pCodesR)||(StutLine1==pEraseAllR)){
               strcpyf(str3,"               "); 
               if(StutLine1==pCodesR){
//                   if (!AddedType) strcpyf(str3,"REF APP (250)  ");
//                   if (AddedType==0x31) strcpyf(str3,"1              "); 
//                   if (!AddedType==0x32) strcpyf(str3,"2              ");
//                   if (!AddedType==0x33) strcpyf(str3,"3              "); //PLACE 
               }
               if (StutLine1==pEraseAllR){
                    if (EraseAllDone){
                         if (EnglishMode){
                              strcpyf(str2,"Erase all Prxy!"); //Long BEEP 
                              strcpyf(str3," Please Wait!!");
                         }else {
                              strcpyf(str2," מחיקה כוללת!!! ");
                              HebruSrting(str2);
                              strcpyf(str3,"  נא להמתין !!! "); //Long BEEP 
                              HebruSrting(str3);                              
                    }
                    if (EraseAllDone)EraseAllDone--;
                    }else  strcpyf(str2,"               ");  
               }
               if (((StutLine1==pProxyLrnR)||(StutLine1==pProxyLrn2R))&&(PxyDirDone!=20)){ //6 Proxy//Prxy Fast
                    if (EnglishMode){          
                          strcpyf(str3,"1/6 Next?Press*"); 
                          str3[8]=5;//?
                          str3[0]=Scan_Pointer+0x31;    
                          strcpyf(str4,"Press2 to Erase");                     
                    }else{              
                          strcpyf(str3," 6/1 לבא- הקש * "); 
                          str3[3]=Scan_Pointer+0x31;
                          HebruSrting(str3);        
                          strcpyf(str4,"  למחיקה הקש 2  ");
                          HebruSrting(str4);                          
                    }
               }else {            
                       if (PxyDirDone!=20){ //Prxy Fast          
                           if (EnglishMode){
                                strcpyf(str4,"Press* to Erase");
                           }else {
                                strcpyf(str4,"  למחיקה הקש *  ");
                                HebruSrting(str4);
                           } 
                       } 
                       if ((StutLine1==pEraseAllR)&&((List==5)|(List==6))){  //U_D
                              if (EnglishMode){
                                      strcpyf(str3,"  Are you sure?");                               
                                      strcpyf(str4,"Press* to start");                                                         
                              }
                              else {                        
                                      strcpyf(str3,"  האם אתה בטוח? ");
                                      HebruSrting(str3);                                    
                                      strcpyf(str4,"   להעברה הקש * ");
                                      HebruSrting(str4); 
                              }                                
                       }  //U_D                      
               } //6 Proxy 
          }else if (StutLine1 == pBusySogToneR){
               if (EnglishMode){
                    if (List==1){
                         strcpyf(str3,"option number 1");
                         strcpyf(str4,"By test  +/- 1 ");
                    }
                    if (List==2){
                         strcpyf(str3,"option number 2");
                         strcpyf(str4,"By test  +/- 1 ");
                    }
                    if (List==3){
                         strcpyf(str3,"Max sensative0");
                         strcpyf(str4,"Best- by test!");
                    }
                    if (List==4){
                         strcpyf(str3,"pulses in 50 mS");
                         strcpyf(str4,"Best- by test!");
                    }
                    if (List==5){
                         strcpyf(str3,"Low freq level ");
                         strcpyf(str4,"By test  -10   ");
                    }
                    if (List==6){
                         strcpyf(str3,"uper freq level");
                         strcpyf(str4,"By test  +10   ");
                    }
                    if (List==7){
                         strcpyf(str3,"Break on Call  ");
                         strcpyf(str4,"Base time 50 mS");
                    }
                    if (List==8){
                         strcpyf(str3,"To next phone..");
                         strcpyf(str4,"0 =with no test");
                    } 
                    if (List==89){
                         strcpyf(str3,"to hang phone..");
                         strcpyf(str4,"recomm 08 time ");
                    }                                                                                                   
               }else {
                    if (List==1){               
                         strcpyf(str3," אפשרות מס' 1   ");
                         strcpyf(str4," לפי הנמדד +/- 1");   
                    }
                    if (List==2){               
                         strcpyf(str3," אפשרות מס'  2  ");
                         strcpyf(str4," לפי הנמדד +/- 1");   
                    }                    
                    if (List==3){               
                         strcpyf(str3," 0  רגישות מרבית");
                         strcpyf(str4," מומלץ לפי הנמדד");   
                    }
                    if (List==4){               
                         strcpyf(str3," מס פולס ב05 מלי");
                         strcpyf(str4," מומלץ לפי הנמדד");   
                    }
                    if (List==5){ 
                         strcpyf(str3,"  קו גילוי תחתון");                                     
                         strcpyf(str4,"  לפי הנמדד 01- ");
                    }                   
                    if (List==6){               
                         strcpyf(str3,"  קו גילוי עליון");                                     
                         strcpyf(str4,"  לפי הנמדד 01+ ");
                    }
                    if (List==7){               
                         strcpyf(str3," הפסקה בין צלצול");                                     
                         strcpyf(str4," בסיס זמן 05 מלי");  
                    }
                    if (List==8){               
                         strcpyf(str3," לטלפון הבא ... ");
                         strcpyf(str4," 0   ללא בדיקה  ");   
                    }  
                    if (List==9){               
                         strcpyf(str3," לניתוק השיחה...");
                         strcpyf(str4," מומלץ 80 פעמים ");   
                    }                                                                                   
                    HebruSrting(str3);
                    HebruSrting(str4);
               }
          }else if (StutLine1 == pConfirmToneR){
               if (EnglishMode){
                      strcpyf(str3,"Do not select 0");                               
                      strcpyf(str4,"or use door key");                                                         
               }
               else {                        
                      strcpyf(str3," נא לא לבחור מקש");
                      HebruSrting(str3);                                    
                      strcpyf(str4," 0 או מקש דלת1/2");
                      HebruSrting(str4); 
               }                                               
          }else if ((StutLine1 ==pTel1NumR)||(StutLine1 ==pTel2NumR)||(StutLine1 ==pTel3NumR)||(StutLine1 ==pTel4NumR)//FIX MENU
               ||(StutLine1 ==pTel5NumR)||(StutLine1 ==pTel6NumR)){
               View=List-1;
               View *=CMaxName;
              // View= Name+(List-1)*CMaxName;
               if (EnglishMode){
                    DataReadEE(Name+View,CMaxName,&str4[0]);    
               }else {  
                    DataReadEE(Name+View,CMaxName,&str4[0]);            
                    HebruSrting(str4);
               }//FIX MENU
          }else if (StutLine1 == pSetReadTimeR){
               if (EnglishMode){
                    strcpyf(str3,"DHHMM <<<DISPLY");
                    strcpyf(str4,"Show value>>SET");
               }else {
                    strcpyf(str3," תצוגה:    MMHHD");
                    strcpyf(str4," הערך המוצג ישמר");
                    HebruSrting(str3);
                    HebruSrting(str4);
               }
          }else if (StutLine1 == pFamilyNoR){
               if (EnglishMode){
                    strcpyf(str3,"Value0 Any Call");
                    strcpyf(str4,"1 or 2 or 3=1+2");
               }else {
                    strcpyf(str3,"  ערך 0 כל קריאה");
                    strcpyf(str4," 1 או 2 או 3=1+2");
                    HebruSrting(str3);
                    HebruSrting(str4);
               }
          }else if (StutLine1 == pSetReadTimerR){
             if ((List==1)||(List==4)||(List==7)||(List==10)){
               if (EnglishMode){
                    strcpyf(str3,"DDDDDDD<<DISPLY");
                    strcpyf(str4,"1=Sunday7=Sater");
               }else {
                    strcpyf(str3," תצוגה:  DDDDDDD");
                    strcpyf(str4," 1= יום א' 7=ש' ");
                    HebruSrting(str3);
                    HebruSrting(str4);
               }
             }else {
               if (EnglishMode){
                    strcpyf(str3,"HHMMxxx<<DISPLY");
                    strcpyf(str4,"Start /Stop tim");
               }else {
                    strcpyf(str3," תצוגה:  xxxMMHH");
                    strcpyf(str4," זמן התחלה /סיום");
                    HebruSrting(str3);
                    HebruSrting(str4);
               }
             }
          }else if (StutLine1 == pOfsetR){
               if (EnglishMode){
                    strcpyf(str3,"0=Add Val 1-100 ");//0402
                    strcpyf(str4,"Step 2=New3=4DG ");//0402
               }else {
                    strcpyf(str3," הוסף ערך=0 1=כל");//0402
                    strcpyf(str4," 001 2=חדש 3=4ספ");//0402
                    HebruSrting(str3);
                    HebruSrting(str4);
               }
          }else if (StutLine1 == pCommSpdR){
               strcpyf(str3,"               ");
               if (EnglishMode){
                    strcpyf(str4,"Max speed = 0 ");
               }else {
                    strcpyf(str4," מקסימום ערך =0 ");
                    HebruSrting(str4);
               }
          }else if (StutLine1 == pRelayControlR){
               strcpyf(str3,"               ");
               if (EnglishMode){
                    strcpyf(str4,"000 =not active ");
               }else {
                    strcpyf(str4," 000 = לא פעיל  ");
                    HebruSrting(str4);
               }
          }else if (Status==1){
                    strcpyf(str3,"               ");
                    strcpyf(str4,"Ver323 05/09/24"); //RR+
          }else if (StutLine1==pTimeCycleR){
               if (EnglishMode){
                    if (List==6){
                         strcpyf(str3,"& Ring Name Dsp");
                         strcpyf(str4,"MaxRecoValue05s");
                    }
                    else if (List==7){
//                         strcpyf(str3,"               "); //REDIAL 3
//                         strcpyf(str4,"addition to 30s");
                        // strcpyf(str3,"Time= 0 No test ");                         
                         strcpyf(str3," Min Value 1 ");
                        // strcpyf(str3," Min Value 1 ");
                         strcpyf(str4," Time in sec   ");
                    }else if (List==15) {
                         strcpyf(str3," 1/4 sec base ");
                         strcpyf(str4,"<4 replace by4");//FIX3B                    
                    }else if (List==16) {
                         strcpyf(str3," Min Value 1 ");
                         strcpyf(str4,"Time=10 X value");
                    }else if ((List==17)||(List==18)) {
//                         strcpyf(str3,"until end test  ");  //REDIAL 3
                         strcpyf(str3,"NOT IN USE NOW!"); 
                         strcpyf(str4,"NOT IN USE NOW!");
                        // strcpyf(str3," Min Value 1 ");
                       //  strcpyf(str4,"Time=10 X value");
                    }else {
                         strcpyf(str3," 1/4 sec base ");
                         strcpyf(str4,"0 replace by1");
                    }
               }else {
                    if (List==6){
                         strcpyf(str3," ותצוגת שם מצלצל");
                         strcpyf(str4," מומלץ 50 שניות ");
                         HebruSrting(str3);
                         HebruSrting(str4);
                    }
                    else if (List==7){
//                         strcpyf(str3,"               ");
//                         strcpyf(str4," בנוסף ל03 שניות");
//                         HebruSrting(str4);
                         //strcpyf(str3," מינימום ערך = 1"); //REDIAL 3   
                         strcpyf(str3," מינימום ערך =1 ");
                         strcpyf(str4,"    ערך בשניות  ");
                         HebruSrting(str3);
                         HebruSrting(str4);
                    } else if (List==15) {
                         strcpyf(str4," קטן מ4 יוחלף ב4");//FIX3B
                         strcpyf(str3," בסיס 4/1 שניה  ");
                         strcpyf(str4," קטן מ4 יוחלף ב4");//FIX3B
                         HebruSrting(str3); 
                         HebruSrting(str4);
                    }else if (List==16) {
                         strcpyf(str3," מינימום ערך = 1");
                         strcpyf(str4," זמן = 01 X ערך ");
                         HebruSrting(str3);
                         HebruSrting(str4);
                    }else if ((List==17)||(List==18)){
//                         strcpyf(str3," עד לסיום בדיקה ");
//                         strcpyf(str4," ערך 0 ללא בדיקה");
//                         HebruSrting(str3);
//                         HebruSrting(str4);
                       //  strcpyf(str3," מינימום ערך = 1"); //REDIAL 3
                         //strcpyf(str3," ערך 0 ללא בדיקה"); 
                         strcpyf(str3," לא בשימוש כעת! ");
                         strcpyf(str4," לא בשימוש כעת! ");                                                    
                        // strcpyf(str4," זמן = 01 X ערך ");
                         HebruSrting(str3);
                         HebruSrting(str4);
                    }else {
                         strcpyf(str3," בסיס 4/1 שניה  ");
                         strcpyf(str4," ערך 0 מוחלף ל 1");
                         HebruSrting(str3);
                         HebruSrting(str4);
                    }
               }
          }else if (StutLine1==pFloorValueR){
               if (EnglishMode){
                    strcpyf(str3,"Set Last app    ");
                    strcpyf(str4,"  to this floor ");
               }else {
                    strcpyf(str3," דירה אחרונה    ");
                    strcpyf(str4,"       לקומה זו ");
                    str4[15]=5;//?
                    HebruSrting(str3);
                    HebruSrting(str4);
               }
          }else if (StutLine1==pExtKeysR){
               strcpyf(str3,"               ");
               if (EnglishMode){
                    strcpyf(str4,"Max 25 boards..");
               }else {
                    strcpyf(str4," מקס' 52 מעגלים ");
                    HebruSrting(str4);
               }
          }
          else if ((StutLine1==pAnswerY_NR)||(StutLine1==pMasageOnR)){
               strcpyf(str3,"               ");
               if (EnglishMode){
                    if (List==8){
                           strcpyf(str3,"Change?NameEntr");//FIX4 
                           str3[6]=5;//?
                    }
                    strcpyf(str4,"1-9->Yes 0->No ");
               }else {
                 //   strcpyf(str4,"       לקומה זו?");  
                    if (List==8){
                           strcpyf(str3," שונה?הכנס לשמות");//FIX4 
                           str3[5]=5;//?   
                    }
                    strcpyf(str4," 1-9=Y-כן 0=N-לא"); 
                    HebruSrting(str3);//FIX4
                    HebruSrting(str4);
               } 
//               if (EnglishMode){ //Clear Y/N   
//                      if ((StutLine1==pAnswerY_NR)&&(List == 12)||(List == 16)){ 
//                            str1[12]=' '; 
//                            str1[13]=' ';
//                            str1[14]=' ';
//                       } 
//                       if ((StutLine1==pAnswerY_NR)&&((List == 2)||(List == 8)||(List == 9)||(List == 10)||(List == 11)||(List == 13))){ 
//                            str1[14]=' ';
//                       }               
//               }else{ 
//                       if ((StutLine1==pAnswerY_NR)&&((List == 1)||(List == 11)||(List == 13))){ 
//                            str1[0]=' ';
//                       } 
//                       if ((StutLine1==pAnswerY_NR)&&((List == 8)||(List == 9)||(List == 10)||(List == 11)||(List == 12)||(List == 16))){ 
//                            str1[0]=' '; 
//                            str1[1]=' ';
//                            str1[2]=' ';
//                       }
//               }//Clear Y/N                
          }
          else {
               if (EnglishMode){
                     if (!(YesNoAnswer&0x1)){
                         strcpyf(str3,"Enter App numbr"); //MMM
                    }else {
                         strcpyf(str3,"Enter Office No"); //MMM
                    } 
                    if (YesNoAnswer2 &0x20)strcpyf(str3,"Enter Tenant No"); //MENU FIX
                     strcpyf(str4,"then press BELL"); 
                     if ((TimeConectedWithApp)&&(!CounterRing)){ 
                         if (Dsp_Connect_T) {
                                  strcpyf(str3," Connected/ing  ");//Speech time
                                  strcpyf(str4,"                ");//Speech time 
                                  str4[5]=(Dsp_Connect_T/100)+0x30;
                                  i= Dsp_Connect_T%100;
                                  str4[6]=i/10+0x30;
                                  str4[7]=i%10+0x30;                                   
                         }                  
                     }                          
                   // str4[12] = 0x03;                    
                   // str4[12] = 0x03;
               }
               else {
                    if (!(YesNoAnswer&0x1)){
                         strcpyf(str3," הקש מספר דירה  "); //MMM
                         SwapLine23_12=6;//swap line2 and 4 
                    }else {
                         strcpyf(str3," הקש מספר משרד  "); //MMM
                         SwapLine23_12=6;//swap line2 and 4 
                    }
                    if (YesNoAnswer2 &0x20)strcpyf(str3," הקש מספר דייר  ");
                    strcpyf(str4," ולחץ על הפעמון "); 
                     if ((TimeConectedWithApp)&&(!CounterRing)){ 
                             strcpyf(str3," מתחבר/מחובר!!! ");////Speech time
                             strcpyf(str4,"                ");////Speech time
                             str4[8]=(Dsp_Connect_T/100)+0x30;
                             i= Dsp_Connect_T%100;
                             str4[7]=i/10+0x30;
                             str4[6]=i%10+0x30;
                    }                       
                    //str4[14] = 0x03;
                    HebruSrting(str3);
                    HebruSrting(str4);
               }
          }
//          if ((StutLine1 ==pTel1NumR)||(StutLine1 ==pTel2NumR)||(StutLine1 ==pTel3NumR)||(StutLine1 ==pTel4NumR)//FIX MENU
//               ||(StutLine1 ==pTel5NumR)||(StutLine1 ==pTel6NumR)){ 
//                   str3=str2; 
//                   str2=str1;
//                   str1=str4;                       
//         }//FIX MENU
     }
     if ((ProxyValid)&&(!Status)){ //6 Proxy
         ind = 0;
         for (Class=0;Class<=5;Class++){  
//                if (Class&0x1)Siren_Start(5);//proxy 6+ 
//                else  Siren_Stop() ;//proxy 6+           
                 if (ProxyValid){  
//  str3[0]=Class+0x30; //show Class
//  str3[1]=DataCode[7]; //show tag received last digit  
                     if (DataCode[7]>57) PrxyStart=DataCode[7]-55; //MODY
                     else PrxyStart=DataCode[7]-48; //MODY 
                     if (PrxyStart>16) PrxyStart=0;//FAST FIX                
                     Pointer = PrxyQtytRly1;
                     MaxNum =1;// CMaxPrxyQtytRly1;
                     ReadDataQty(PrxyStart);  //      no of proxy for this DataCode  
                     PrxyQty=Data[0];   
  
//  str3[2]=PrxyQty+0x30; //show qty found    
                     if (PrxyQty>250) PrxyQty=0;//FAST FIX 
                                                                   
                     if (PrxyQty>0){ //only if PrxyQty exsist then  > check the tag  
                          Directory_Found=0; //for calculation                                
                          for (ind=0;ind<PrxyStart;ind++){//calculate the address 
                                Pointer = PrxyQtytRly1;
                                MaxNum =1;// CMaxPrxyQtytRly1;
                                ReadDataQty(ind);   //read qty data 
                                Directory_Found +=Data[0];   
                          }// show from where to start read 
                          

     
//   Data[1]=Directory_Found&0xf0; 
//   Data[1]>>=4;
//   Data[1]+=0x30;
//  str3[4]=Data[1];
//   Data[1]=Directory_Found&0xf;
//   Data[1]+=0x30;
//  str3[5]=Data[1];    
//  
//
//   // show first add data to read  
//   Pointer = PrxyDirRly1+1;
//   MaxNum =1;// 
//   ReadData(Directory_Found);   
//   Data[1]=Data[0]&0xf0; 
//   Data[1]>>=4;
//   if (Data[1]>9)Data[1]+=55;
//   else Data[1]+=48;
//  str3[7]=Data[1];
//   Data[1]=Data[0]&0xf;
//   if (Data[1]>9)Data[1]+=55;
//   else Data[1]+=48;
//  str3[8]=Data[1];  
//        if (PrxyQty)Class=7;   
                          
                     }
                     if (PrxyQty>250) PrxyQty=0;//FAST FIX
                     if (Directory_Found>250) PrxyQty=0;//FAST FIX    
                     if ((Directory_Found+PrxyQty)>250)PrxyQty=0;//FAST FIX 
                     
                     if (PrxyQty){
                         for (MSB_value=(Directory_Found);MSB_value<=(Directory_Found+PrxyQty);MSB_value++){ 
                              Pointer = PrxyDirRly1+1;
                              MaxNum =1; 
                              ReadData(MSB_value); 
                              ind=Data[0];//convert pointer to address (one byte)
           
                         
                              Pointer = ProxyLrn;
                              MaxNum = CMaxProxyLrn;                               
                              ReadData(ind); 
                               
//str3[0]=Data[0]; 
//str3[1]=Data[1]; 
//str3[2]=Data[2]; 
//str3[3]=Data[3]; 
//str3[4]=Data[4]; 
//str3[5]=Data[5]; 
//str3[6]=Data[6]; 
//str3[7]=Data[7];                                
                              
                              Error = 0;  //LONG 8
                              i = 0;
                              while(((i < 8)&& !Error)&&(ProxyValid)){
                                   if(Data[i] != DataCode[i])Error = 1;
                                   i++;
                              }                             
                              if((!Error)&&(ProxyValid)){
                                     if (YesNoAnswer &0x40){ //for proxy & code - set counter to time out
                                          PxyCodeCnt=PxyCodeTime; 
                                          ProxyValid=0;//fast exit 
                                     }else {
                                          if (YesNoAnswer &0x4){//for proy 1 to relay 1
                                               CounterWait = WaitTime;
                                               CounterSecond=0; //ACURATE
                                               CounterSecond=0;
                                               FlagWait = 1;
                                               NamePointer = 0;
                                               RealTime[4] = 1;
                                               ListName = 0;  
                                               WelcomeCounter=0;// if tenedt press STAR no welcome message need
                                          }
                                          if (YesNoAnswer &0x8){//for proy 1 to relay 2
                                               CounterWait2 = WaitTime2;
                                               CounterSecond=0; //ACURATE
                                               FlagWait2 = 1;
                                               NamePointer = 0;
                                               RealTime[4] = 1;
                                               ListName = 0;     
                                               WelcomeCounter=0; //if tenedt press STAR no welcome message need
                                          }
                                          if ((FlagWait2)&&(FlagWait)){
                                               CounterWait=CounterWait2; // rlay 2 delay apriority
                                               CounterSecond=0; //ACURATE
                                          }
                                          if ((!FlagWait2)&&(!FlagWait)) Siren_Start(3); 
                                          ProxyValid=0;//fast exit 
                                     }
                              }  
                         }
                     }
                } 
         }       
  
         ind = 0;
         for (Class=0;Class<=5;Class++){  
//                if (Class&0x1)Siren_Start(5);//proxy 6+ 
//                else  Siren_Stop() ;//proxy 6+           
                 if (ProxyValid){  
                     if (DataCode[7]>57) PrxyStart=DataCode[7]-55; //MODY
                     else PrxyStart=DataCode[7]-48; //MODY 
                     if (PrxyStart>16) PrxyStart=0;//FAST FIX                
                     Pointer = PrxyQtytRly2;
                     MaxNum =1;// CMaxPrxyQtytRly1;
                     ReadDataQty(PrxyStart);  //      no of proxy for this DataCode  
                     PrxyQty=Data[0];
                     if (PrxyQty>250) PrxyQty=0;//FAST FIX

                                                                              
                     if (PrxyQty>0){ //only if PrxyQty exsist then  > check the tag  
                          Directory_Found=0; //for calculation                                
                          for (ind=0;ind<PrxyStart;ind++){//calculate the address 
                                Pointer = PrxyQtytRly2;
                                MaxNum =1;// CMaxPrxyQtytRly1;
                                ReadDataQty(ind);   //read qty data 
                                Directory_Found +=Data[0];   
                          }// show from where to start read 
                                                    
                     }                     
                     if (PrxyQty>250) PrxyQty=0;//FAST FIX
                     if (Directory_Found>250) PrxyQty=0;//FAST FIX    
                     if ((Directory_Found+PrxyQty)>250)PrxyQty=0;//FAST FIX 
                                                   
                     if (PrxyQty){
                         for (MSB_value=(Directory_Found);MSB_value<=(Directory_Found+PrxyQty);MSB_value++){ 
                              Pointer = PrxyDirRly2+1;
                              MaxNum =1; 
                              ReadData(MSB_value); 
                              ind=Data[0];//convert pointer to address (one byte)
           
                         
                              Pointer = ProxyLrn2;
                              MaxNum = CMaxProxyLrn2;                               
                              ReadData(ind);
                              
                              
                              Error = 0;
                              i = 0;   //LONG 8
                              while(((i < 8)&& !Error)&&(ProxyValid)){
                                   if(Data[i] != DataCode[i])Error = 1;
                                   i++;
                              }
                              if((!Error)&&(ProxyValid)){ 
                                     if (YesNoAnswer &0x40){// for proxy & code - set counter to time out
                                          PxyCodeCnt=PxyCodeTime;
                                          ProxyValid=0;//fast exit 
                                     }else {
                                          if (YesNoAnswer &0x10){//for proy 2 to relay 1
                                               CounterWait = WaitTime;
                                               NO_Close_Door_Mes=1;
                                               No_Floor_Mess=1;
                                               CounterSecond=0; //ACURATE
                                               FlagWait = 1;
                                               NamePointer = 0;
                                               RealTime[4] = 1;
                                               ListName = 0;     
                                               WelcomeCounter=0;// if tenedt press STAR no welcome message need                           
                                          }
                                          if (YesNoAnswer &0x20){//for proy 2 to relay 2
                                               CounterWait2 = WaitTime2;
                                               CounterSecond=0; //ACURATE 
                                               NO_Close_Door_Mes=1;
                                               No_Floor_Mess=1;                                               
                                               FlagWait2 = 1;
                                               NamePointer = 0;
                                               RealTime[4] = 1;
                                               ListName = 0;   
                                               WelcomeCounter=0;// if tenedt press STAR no welcome message need                           
                                          }
                                          if ((FlagWait2)&&(FlagWait)) {
                                               CounterWait=CounterWait2;  //rlay 2 delay apriority 
                                               NO_Close_Door_Mes=1;
                                               No_Floor_Mess=1;
                                               CounterSecond=0; //ACURATE 
                                          }
                                          if ((!FlagWait2)&&(!FlagWait)) Siren_Start(3); 
                                          ProxyValid=0;//fast exit 
                                         }
                              }  
                         }
                     }
                } 
         }       
         Class=0;
         Siren_Start(2);
         ProxyValid=0;//fast exit                                                             
      
     }   //6 Proxy
     
     
     if (Show_Used){ //PRXO
             Show_Used--; 
             Siren_Start(7); //PRXO 
             if (EnglishMode)
             strcpyf(str1,"Used!Erase/Move");  
             else {
                     strcpyf(str1," תפוס!!-נקה/עבור"); 
                     HebruSrting(str1); 
             }
     
     } //PRXO
     else if (AllReady_in_Mem){  
             AllReady_in_Mem--; 
             Siren_Start(7); //PRXO 
             if (EnglishMode){
                     strcpyf(str1,"Allready in MEM");
                     strcpyf(str2,"Location: /    ");
                     str2[9]=MEM_Class+0x30;//PRXO-MemShow
                     str2[11]=(MEM_Location/100)+0x30;//PRXO-MemShow
                     str2[12]=((MEM_Location%100)/10)+0x30;//PRXO-MemShow  
                     str2[13]=((MEM_Location%100)%10)+0x30;//PRXO-MemShow                            
             }else {
                     strcpyf(str1," !!קיים בזיכרון!");  
                     HebruSrting(str1);  
                     strcpyf(str2,"   במיקום:   /  ");  
                     HebruSrting(str2);
                     str2[1]=MEM_Class+0x30;//PRXO-MemShow
                     str2[3]=(MEM_Location/100)+0x30;//PRXO-MemShow
                     str2[4]=((MEM_Location%100)/10)+0x30;//PRXO-MemShow  
                     str2[5]=((MEM_Location%100)%10)+0x30;//PRXO-MemShow                  
             }     
     }else if (Tags_QtyDisp){ //PXYOO
             Tags_QtyDisp--;
             strcpyf(str3,"Tags Qty:       ");  
             MaxEEpromV=Tags_Qty;                                   
            // str3[10]=(MaxEEpromV/10000)+0x30; 
             MaxEEpromV=MaxEEpromV%10000; 
             str3[10]=(MaxEEpromV/1000)+0x30; 
             MaxEEpromV=MaxEEpromV%1000;
             str3[11]=(MaxEEpromV/100)+0x30;
             MaxEEpromV=MaxEEpromV%100;
             str3[12]=(MaxEEpromV/10)+0x30;
             str3[13]=(MaxEEpromV%10)+0x30; 
     }   //PXYOO  
     
          

//View max eeprom pointer  
//See workinf testi SUB on COM116-2L    
//                      Pointer = Tel2Num;
//                      MaxNum = CMaxTel2Num; 
//                      ReadData(NamePointer);
//                       str2[0]=Data[0];
//                       str2[1]=Data[1];
//                       str2[2]='A';  
//                       str2[3]='S';
//                       str2[4]='F';
                           
           
          /* MaxEEpromV =MaxEEprom;
           str2[0]=(MaxEEpromV/10000)+0x30; 
           MaxEEpromV=MaxEEpromV%10000; 
           str2[1]=(MaxEEpromV/1000)+0x30; 
          // str2[0]=Save_Button+0x30;
           MaxEEpromV=MaxEEpromV%1000;
           str2[2]=(MaxEEpromV/100)+0x30;
           MaxEEpromV=MaxEEpromV%100;
           str2[3]=(MaxEEpromV/10)+0x30;
           str2[4]=(MaxEEpromV%10)+0x30;*/  
   /*       if (!Status){ 
             Class=0; 

                Pointer = PrxyDirRly1+1;//+8 for secnd part show 
                MaxNum =1;
                
                for (i=0;i<=7;i++){ 
                   ReadData(i);
                   Data[1]=Data[0]&0xf0; 
                   Data[1]>>=4;
                   if (Data[1]>9)Data[1]+=55;
                   else Data[1]+=48;
                   if (i==7)str1[2*i]='-';
                   else str1[2*i]=Data[1]; 
                   
                   Data[1]=Data[0]&0xf;
                   if (Data[1]>9)Data[1]+=55;
                   else Data[1]+=48;
                   str1[(2*i)+1]=Data[1];

                } 
               
                Pointer = PrxyQtytRly1; //+7 for secnd part show
                MaxNum =1;
                
                for (i=0;i<=7;i++){
                   ReadDataQty(i);
                   Data[1]=Data[0]&0xf0; 
                   Data[1]>>=4;
                   Data[1]+=0x30;
                   if (i==7)str2[2*i]='+';
                   else str2[2*i]=Data[1]; 
                   
                   Data[1]=Data[0]&0xf;
                   Data[1]+=0x30;
                   str2[(2*i)+1]=Data[1];
                }             
            Class=0; 

//                Pointer = PrxyDirRly1+1;
//                MaxNum =1;
//                
//                for (i=0;i<=7;i++){ 
//                   ReadData(i);
//                   Data[1]=Data[0]&0xf0; 
//                   Data[1]>>=4;
//                   if (Data[1]>9)Data[1]+=55;
//                   else Data[1]+=48;
//                   if (i==7)str3[2*i]='-';
//                   else str3[2*i]=Data[1]; 
//                   
//                   Data[1]=Data[0]&0xf;
//                   if (Data[1]>9)Data[1]+=55;
//                   else Data[1]+=48;
//                   str3[(2*i)+1]=Data[1];
//
//                } 
//               
                Pointer = PrxyQtytRly1+9; //+7
                MaxNum =1;
                
                for (i=0;i<=7;i++){
                   ReadDataQty(i);
                   Data[1]=Data[0]&0xf0; 
                   Data[1]>>=4;
                   if (Data[1]>9)Data[1]+=55;
                   else Data[1]+=48;
                   if (i==7)str4[2*i]='+';
                   else str4[2*i]=Data[1]; 
                   
                   Data[1]=Data[0]&0xf;
                   if (Data[1]>9)Data[1]+=55;
                   else Data[1]+=48;
                   str4[(2*i)+1]=Data[1];
                }             
                 Class=0;              

           }*/ 


           //str1[1]= AddedType+0x30;

         /*  i=ReturnValue;
           str2[1]= ReturnValue/100+0x30;
           i=ReturnValue%100;
           str2[2]= i/10+0x30;
           str2[3]= i%10+0x30; */

         /*    str3[1]=0x30+AppCode[0];
             str3[2]=0x30+AppCode[1];
             str3[3]=0x30+AppCode[2];
             str3[4]=0x30+UserCode[3];
             str3[5]=0x30+UserCode[4];
             str3[6]=0x30+UserCode[5];
             str3[7]=0x30+UserCode[6];
             str3[8]=0x30+UserCode[7];
             str3[9]=0x30+UserCode[8];
             str3[10]=0x30+UserCode[9];
             str3[12]=0x30+AppCntCode;*/

          //   str3[1]=0x30+Show_Sel;   
            if((Status == 0)&&(AppCntCode)&&(!DoNotDisp_AppNo)){  //FIX6 
                 if (EnglishMode)  AppPoint=11;//0402
                 else AppPoint=0 ;
                   
                 if (AppCntCode==1){                       
                      str1[AppPoint+0]= AppCode[0]+0x30; 
                      if (!TogleAppShow)str1[AppPoint+0]=' ';
                 }
                 else if (AppCntCode==2){ 
                      str1[AppPoint+0]= AppCode[0]+0x30;
                      str1[AppPoint+1]= AppCode[1]+0x30;
                      if (!TogleAppShow)str1[AppPoint+0]=' ';
                      if (!TogleAppShow)str1[AppPoint+1]=' ';
                 }
                 else if ((AppCntCode==4)&&(AddedType>=4)){
                      str1[AppPoint+0]= AppCode[0]+0x30;
                      str1[AppPoint+1]= AppCode[1]+0x30;
                      str1[AppPoint+2]= AppCode[2]+0x30; 
                      str1[AppPoint+3]= AppCode[3]+0x30;
                      if (!TogleAppShow)str1[AppPoint+0]=' ';
                      if (!TogleAppShow)str1[AppPoint+1]=' ';
                      if (!TogleAppShow)str1[AppPoint+2]=' ';
                      if (!TogleAppShow)str1[AppPoint+3]=' ';                          
                 } 
                 else if (AppCntCode==3){ 
                      str1[AppPoint+0]= AppCode[0]+0x30;
                      str1[AppPoint+1]= AppCode[1]+0x30;
                      str1[AppPoint+2]= AppCode[2]+0x30;
                      if (!TogleAppShow)str1[AppPoint+0]=' ';
                      if (!TogleAppShow)str1[AppPoint+1]=' ';
                      if (!TogleAppShow)str1[AppPoint+2]=' ';
                 }                 
                 TogleAppShow ^=1;
            }   //FIX6 
          if (SwapLine23_12==1){//DISP 4 Lines to 2 lines
                  WriteStr(str2,0);           // send data to display
                  WriteStr(str3,0x40);           
          }
          else   if (SwapLine23_12==2){
                  if (Info_Disply<=750){
                          str2[14]=6;                 // '^' sign //DISP 4 Lines to 2 lines
                          WriteStr(str1,0);           // send data to display
                          WriteStr(str2,0x40);               
                  }else if (Info_Disply<=825){ 
                          WriteStr(str1,0x0);            
                          WriteStr(str3,0x40);           // send data to display
                  }else Info_Disply=0;
                
          }
          else   if (SwapLine23_12==3){
                  if ((Info_Disply<=400)&&(!Force_it)){
                          str2[14]=6;                  // '^' sign //DISP 4 Lines to 2 lines
                          WriteStr(str1,0);           // send data to display
                          WriteStr(str2,0x40);               
                  }
                  else if ((Info_Disply<=950)||(Force_it)){ 
                          if (Force_it){
                                 Force_it=0;
                                 Info_Disply=410;
                          }
                          WriteStr(str1,0x0);            
                          WriteStr(str3,0x40);           // send data to display
                  }  
                  else if ((Info_Disply<=1200)&&(!Force_it)){ 
                          WriteStr(str1,0x0);            
                          WriteStr(str4,0x40);           // send data to display
                  }              
                  else Info_Disply=0;
                 // Siren_Start(1);                 
          }
          else   if (SwapLine23_12==4){
                  if (Info_Disply<=750){  
                          if((StutLine1 == pTel1NumR)||(StutLine1 == pTel1NumR)||(StutLine1 == pTel2NumR)||(StutLine1 == pTel3NumR)
                          ||(StutLine1 == pTel4NumR)||(StutLine1 == pTel5NumR)||(StutLine1 == pTel6NumR)){
                                  if (EnglishMode)str1[11]=7; 
                                  else str1[3]=7;  
                          }  
                          else str2[0]=6;                   // '^' sign //DISP 4 Lines to 2 lines
                          WriteStr(str1,0);           // send data to display
                          WriteStr(str2,0x40); 
                                        
                  }else if (Info_Disply<=1100){ 
                          WriteStr(str1,0x0);            
                          WriteStr(str4,0x40);           // send data to display
                  }else Info_Disply=0;
                 // Siren_Start(1);                 
          }else if (SwapLine23_12==5){ 
                  WriteStr(str1,0);           // send data to display
                  WriteStr(str4,0x40);           
          }
          else   if (SwapLine23_12==6){ //wp
                  if (Info_Disply<=950){
                          WriteStr(str2,0);           // send data to display
                          WriteStr(str1,0x40);               
                  }else if (Info_Disply<=1500){ 
                          WriteStr(str3,0x0);            
                          WriteStr(str4,0x40);           // send data to display
                  }else Info_Disply=0;                
          }                
          else if (SwapLine23_12==10){ 
                  WriteStr(str1,0);           // send data to display 
                  if (EnglishMode){
                        strcpyf(str3,"Use Bell ToCall ");
                  }else {
                          strcpyf(str3," לחיוג הקש פעמון");              
                          HebruSrting(str3); 
                  }       
                  WriteStr(str3,0x40);       
          }  //DISP 4 Lines to 2 lines  
          else if (SwapLine23_12==12){ //qqcc
                  if (Info_Disply<=950){  
                          str2[14]=6;                  // '^' sign //DISP 4 Lines to 2 lines                           
                          WriteStr(str1,0);           // send data to display
                          WriteStr(str2,0x40);    
                            
                  }else if (Info_Disply<=1500){ 
                          WriteStr(str3,0x0);            
                          WriteStr(str4,0x40);           // send data to display
                  }else Info_Disply=0;          
          }   
//          else if (SwapLine23_12==13){ //qqcc
//                          WriteStr(str1,0);           // send data to display
//                          WriteStr(str2,0x40); 
//         
//          }          
//                                       
          
//        if ((Show_Clock)&&(YesNoAnswer2&0x4)){ //only if RTC used 
//              Time_Up();
//              if (EnglishMode){  
//                   if ((Days&0xf)==1)strcpyf(str4,"  :  :   Sunday"); 
//                   else if ((Days&0xf)==2)strcpyf(str4,"  :  :   Monday"); 
//                   else if ((Days&0xf)==3)strcpyf(str4,"  :  :  Tuesday"); 
//                   else if ((Days&0xf)==4)strcpyf(str4,"  :  :  Wednesd"); 
//                   else if ((Days&0xf)==5)strcpyf(str4,"  :  :  Thursdy"); 
//                   else if ((Days&0xf)==6)strcpyf(str4,"  :  :   Friday"); 
//                   else if ((Days&0xf)==7)strcpyf(str4,"  :  :  Saturdy");
//                   else if (PowerFail)strcpyf(str4,"  :  :   ??????");
//                   str4[0]=0x30+((Hours&0xf0)>>4);
//                   str4[1]=0x30+(Hours&0xf);
//                   str4[3]=0x30+((Minutes&0xf0)>>4);
//                   str4[4]=0x30+(Minutes&0xf);
//                   str4[6]=0x30+((Secounds&0xf0)>>4);
//                   str4[7]=0x30+(Secounds&0xf);                                        
//                   if (Show_Clock&0x1)str4[2]=':'; 
//                   else {
//                        str4[2]=' '; 
//                        if (PowerFail){
//                              str4[0]=0x20;
//                              str4[1]=0x20;
//                              str4[3]=0x20;
//                              str4[4]=0x20;
//                              str4[6]=0x20;
//                              str4[7]=0x20;;                                                                     
//                        }
//                  }
//              }else { 
//                   if ((Days&0xf)==1)strcpyf(str4," יום א'   :  :  "); 
//                   else if ((Days&0xf)==2)strcpyf(str4," יום ב'   :  :  "); 
//                   else if ((Days&0xf)==3)strcpyf(str4," יום ג'   :  :  "); 
//                   else if ((Days&0xf)==4)strcpyf(str4," יום ד'   :  :  "); 
//                   else if ((Days&0xf)==5)strcpyf(str4," יום ה'   :  :  "); 
//                   else if ((Days&0xf)==6)strcpyf(str4," יום ו'   :  :  "); 
//                   else if ((Days&0xf)==7)strcpyf(str4," יום ש'   :  :  "); 
//                   else if (PowerFail)strcpyf(str4," ??????   :  :  ");                  
//                   str4[15]=0x30+((Hours&0xf0)>>4);
//                   str4[14]=0x30+(Hours&0xf);
//                   str4[12]=0x30+((Minutes&0xf0)>>4);
//                   str4[11]=0x30+(Minutes&0xf);
//                   str4[9]=0x30+((Secounds&0xf0)>>4);
//                   str4[8]=0x30+(Secounds&0xf);                                        
//                   if (Show_Clock&0x1)str4[13]=':'; 
//                   else {
//                        str4[13]=' '; 
//                        if (PowerFail){
//                              str4[15]=0x20;
//                              str4[14]=0x20;
//                              str4[12]=0x20;
//                              str4[11]=0x20;
//                              str4[9]=0x20;
//                              str4[8]=0x20;;                                                                     
//                        }
//                  }
//                  HebruSrting(str4);                  
//              } 
//        } 
//        if ((YesNoAnswer2&0x8)&&((Status == 0))){ //show freq and level result
//             if (!FlagHoldLine) { 
//                  Busy_Det_Value=0;
//                  BussyTIM=0;
//             }
//             str2[0]= ' ';
//             str2[1]= 'L';
//             str2[2]= 'V';
//             str2[3]= 'L';
//             str2[4]= '='; 
//             str2[5]= (Busy_Det_Value/10)+0x30;
//             str2[6]= (Busy_Det_Value%10)+0x30;
//             str2[7]= ' '; 
//             str2[8]= 'T';
//             str2[9]= 'I';
//             str2[10]= 'M';
//             str2[11]= 'E'; 
//             str2[12]= '='; 
//             str2[13]= (BussyTIM/10)+0x30;
//             str2[14]= (BussyTIM%10)+0x30; 
//             if (DOT)str2[0]='*';                        
//                                        
//             str3[0]= 'F';
//             str3[1]= 'R';
//             str3[2]= 'Q';
//             str3[3]= '='; 
//             if (PC7Cnt<=5){
//                  str3[4]=0x30;
//                  Reminder=0;
//             }
//             else {
//                  str3[4]= PC7Cnt/100+0x30;
//                  Reminder =PC7Cnt%100;
//             }
//             str3[5]= Reminder/10+0x30;
//             str3[6]= Reminder%10+0x30; 
//             str3[7]= ' '; 
//             str3[8]= 'F'; 
//             str3[9]= 'R'; 
//             str3[10]= 'Q'; 
//             str3[11]= ' '; 
//             str3[12]= 'S'; 
//             str3[13]= 'H'; 
//             str3[14]= 'W'; 
//             
//                          
//             strcpyf(str4,"if BussyTime >0");                        
//        }      
//            if (SwapLine4_3==10){ //DISP 4 Lines to 2 lines 
//                     WriteStr(str1,0);           // send data to display
//                     WriteStr(str2,0x40);
//                     WriteStr(str3,0x10);
//                     if (EnglishMode){
//                     //     strcpyf(str4,"Use Bell ToCall ");
//                            strcpyf(str4,"ToCall    pres "); 
//                              str4[8]= str1[2];    
//                              str4[7]= str1[1]; 
//                              str4[6]= str1[0]; 
//                              str4[14]=6;                            
//                     }else {
//                           //   strcpyf(str4," הקש פעמון לחיוג"); 
//                              strcpyf(str4," לחיוג ל012 הקש ");                   
//                              HebruSrting(str4);
//                              str4[0]=6;
//                              str4[7]= str1[14];    
//                              str4[6]= str1[13]; 
//                              str4[5]= str1[12]; 
//                              
//                              
//                      }
//                      WriteStr(str4,0x50);  //DISP 4 Lines to 2 lines 
//                      if (EnglishMode){    
//                           str1[0]=0x54;//TO:
//                           str1[1]=0x4f;
//                           str1[2]=0x3a;                      
//                      }else { 
//                           str1[14]=0xa0;//:אל
//                           str1[13]=0xac;
//                           str1[12]=0x3a;
//          }  
            else {          

                     WriteStr(str1,0);           // send data to display
                     WriteStr(str2,0x40);
//                     WriteStr(str3,0x10);  //DISP 4 Lines to 2 lines 
//                     WriteStr(str4,0x50); //DISP 4 Lines to 2 lines 
            }
            fourline=0;   
            if (SwapLine23_12!=10)SwapLine23_12=0;  //DISP 4 Lines to 2 lines 
}
void StrFrom_rx_buffer0(char* str) //2 Lines
{
   unsigned char i;

   strcpyf(str,"                ");
   for(i = 0;(i<MaxNum)&&(Data[i]);i++)
              str[i] = rx_buffer0[i];
}  //2 Lines


void StrFromEE(char* str)
{
   unsigned char i;

   strcpyf(str,"                ");
   for(i = 0;(i<MaxNum)&&(Data[i]);i++)
              str[i] = Data[i]; 
              
}

void PawerUp(void)
{


     //ee+ Reset MP3 
     tx_buffer[0]=0x7E;  //play 3 
     tx_buffer[1]=0XFF;
     tx_buffer[2]=0X06;//NO 
     tx_buffer[3]=0X0C;//OPCODE
     tx_buffer[4]=0X00;//REPLAY 
     tx_buffer[5]=0x00;//
     tx_buffer[6]=0x00;                                                                                      
     tx_buffer[7]=0XEF;                                                                           
     Max_Tx_Buff =7;//N-1                          
     tx_index = 0;        
     UDR0=tx_buffer[0]; 
     Wait_For_Volume=250;

     
     
     AllRdyShow=0;//FIX4
     Pointer = TimeCycle;
     MaxNum = CMaxTimeCycle;
     ReadData(1);
     if(Data[1] == ' ')  WaitTime = Data[0]&0x0f;
     else WaitTime = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     ReadData(2);
     if(Data[1] == ' ')  OpenDoorTime = Data[0]&0x0f;
     else OpenDoorTime = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     ReadData(3);
     if(Data[1] == ' ')  WaitTime2 = Data[0]&0x0f;
     else WaitTime2 = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     ReadData(4);
     if(Data[1] == ' ')  OpenDoorTime2 = Data[0]&0x0f;
     else OpenDoorTime2 = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     ReadData(5);
     if(Data[1] == ' ')  LightTime = Data[0]&0x0f;
     else LightTime = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     ReadData(6);
     if(Data[1] == ' ') RingTime = Data[0]&0x0f;
     else RingTime = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     if (RingTime<1)RingTime=1; //was 5 and  2 //FIX MENU
     ReadData(7);
     if(Data[1] == ' ') RedialTime = Data[0]&0x0f;
     else RedialTime = (Data[0]&0x0f)*10 + (Data[1]&0x0f); 
     if (!RedialTime)RedialTime=1;
     RedialTime=RedialTime;   //REDIAL 3
     ReadData(8);
     if(Data[1] == ' ') PxyCodeTime = Data[0]&0x0f;
     else PxyCodeTime = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     if (PxyCodeTime==0)PxyCodeTime=1;
     ReadData(9);
     if(Data[1] == ' ') DoorForget = Data[0]&0x0f;
     else DoorForget = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     if (DoorForget==0)DoorForget=1;
     ReadData(10);
     if(Data[1] == ' ') WelcomeTime = Data[0]&0x0f;
     else WelcomeTime = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     if (WelcomeTime==0)WelcomeTime=1;
     ReadData(11);
     if(Data[1] == ' ') AnnounceTime = Data[0]&0x0f;
     else AnnounceTime = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     if (AnnounceTime==0)AnnounceTime=1;
     ReadData(12);
     if(Data[1] == ' ') FloorTime = Data[0]&0x0f;
     else FloorTime = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     if (FloorTime==0)FloorTime=1;
     ReadData(13);
     if(Data[1] == ' ') DisplyList = Data[0]&0x0f;
     else DisplyList = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     if (DisplyList==0)DisplyList=1;
     ReadData(14);
     if(Data[1] == ' ') DispSelect= Data[0]&0x0f;
     else DispSelect = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     if (DispSelect==0)DispSelect=1;
     ReadData(15);
     if(Data[1] == ' ') ClearSelect = Data[0]&0x0f;
     else ClearSelect = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     if (ClearSelect<4)ClearSelect=4; //FIX3B
     ReadData(16);
     if(Data[1] == ' ') SpeechTime = Data[0]&0x0f;
     else SpeechTime = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     if (!SpeechTime)SpeechTime=1;
     SpeechTime=10*SpeechTime;
     SpeechTime += RingTime;
     ReadData(17);
     if(Data[1] == ' ') BusyTstT = Data[0]&0x0f;
     else BusyTstT = (Data[0]&0x0f)*10 + (Data[1]&0x0f); 
    // if (!BusyTstT)BusyTstT=1;
     BusyTstT=10*BusyTstT;//REDIAL 3
     ReadData(18);
     if(Data[1] == ' ') ConfimTstT = Data[0]&0x0f;
     else ConfimTstT = (Data[0]&0x0f)*10 + (Data[1]&0x0f); 
    // if (!ConfimTstT)ConfimTstT=1;
     ConfimTstT=10*ConfimTstT;//REDIAL 3   
     
     if (!OpenDoorTime){
          Pointer = Relay1MeM;//
          MaxNum =  CMaxRelay1MeM;
          ReadData(1);  //PRG SHOW 
          if (Data[0]=='1') OpenDoorRelay();
          else CloseDoorRelay();
     } 
     if (!OpenDoorTime2){
          Pointer = Relay2MeM;//
          MaxNum =  CMaxRelay2MeM;
          ReadData(1);  //PRG SHOW 
          if (Data[0]=='1') OpenDoorRelay2();
          else CloseDoorRelay2();
     }                          
     
     
     Pointer = BusySogTone;
     MaxNum = CMaxBusySogTone;
     ReadData(3);
     if(Data[1] == ' ') BusyVolume = Data[0]&0x0f;
     else BusyVolume = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     ReadData(4);
     if(Data[1] == ' ') BusyFrq = Data[0]&0x0f;//when 0 no test need 
     else BusyFrq = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     ReadData(5);
     if(Data[1] == ' ') CallLowF = Data[0]&0x0f;
     else CallLowF = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     ReadData(6);
     if(Data[1] == ' ') CallHighF = Data[0]&0x0f;
     else CallHighF = (Data[0]&0x0f)*10 + (Data[1]&0x0f); 
     ReadData(7);
     if(Data[1] == ' ') CallBreak = Data[0]&0x0f;
     else CallBreak = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     ReadData(8);
     if(Data[1] == ' ') NoOfCall = Data[0]&0x0f;// when 0 no test need 
     else NoOfCall = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     ReadData(9);
     if(Data[1] == ' ') NoOfCall = Data[0]&0x0f;// bussy number  
     else BussyNum = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     



     Pointer = SetReadTimer;
     MaxNum =  CMaxSetReadTimer;
     ReadData(1);
     Timer1D=0;
     if(Data[0] == 0x31)Timer1D |=0x1;  //day 1
     if(Data[1] == 0x32)Timer1D |=0x2;
     if(Data[2] == 0x33)Timer1D |=0x4;
     if(Data[3] == 0x34)Timer1D |=0x8;
     if(Data[4] == 0x35)Timer1D |=0x10;
     if(Data[5] == 0x36)Timer1D |=0x20;
     if(Data[6] == 0x37)Timer1D |=0x40; //day 7
     ReadData(4);
     Timer2D=0;
     if(Data[0] == 0x31)Timer2D |=0x1; //day 1
     if(Data[1] == 0x32)Timer2D |=0x2;
     if(Data[2] == 0x33)Timer2D |=0x4;
     if(Data[3] == 0x34)Timer2D |=0x8;
     if(Data[4] == 0x35)Timer2D |=0x10;
     if(Data[5] == 0x36)Timer2D |=0x20;
     if(Data[6] == 0x37)Timer2D |=0x40; //day 7
     ReadData(7);
     Timer3D=0;
     if(Data[0] == 0x31)Timer3D |=0x1; //day 1
     if(Data[1] == 0x32)Timer3D |=0x2;
     if(Data[2] == 0x33)Timer3D |=0x4;
     if(Data[3] == 0x34)Timer3D |=0x8;
     if(Data[4] == 0x35)Timer3D |=0x10;
     if(Data[5] == 0x36)Timer3D |=0x20;
     if(Data[6] == 0x37)Timer3D |=0x40; //day 7
     ReadData(10);
     Timer4D=0;
     if(Data[0] == 0x31)Timer4D |=0x1; //day 1
     if(Data[1] == 0x32)Timer4D |=0x2;
     if(Data[2] == 0x33)Timer4D |=0x4;
     if(Data[3] == 0x34)Timer4D |=0x8;
     if(Data[4] == 0x35)Timer4D |=0x10;
     if(Data[5] == 0x36)Timer4D |=0x20;
     if(Data[6] == 0x37)Timer4D |=0x40; //day 7

     ReadData(2);
     Timer1SH=((Data[0]&0xf)<<4)|(Data[1]&0xf);
     if(Timer1SH>0x23)Timer1SH=0x23;
     Timer1SM=((Data[2]&0xf)<<4)|(Data[3]&0xf);
     if(Timer1SM>0x59)Timer1SM=0x59;
     ReadData(3);
     Timer1PH=((Data[0]&0xf)<<4)|(Data[1]&0xf);
     if(Timer1PH>0x23)Timer1PH=0x23;
     Timer1PM=((Data[2]&0xf)<<4)|(Data[3]&0xf);
     if(Timer1PM>0x59)Timer1PM=0x59;
     ReadData(5);
     Timer2SH=((Data[0]&0xf)<<4)|(Data[1]&0xf);
     if(Timer2SH>0x23)Timer2SH=0x23;
     Timer2SM=((Data[2]&0xf)<<4)|(Data[3]&0xf);
     if(Timer2SM>0x59)Timer2SM=0x59;
     ReadData(6);
     Timer2PH=((Data[0]&0xf)<<4)|(Data[1]&0xf);
     if(Timer2PH>0x23)Timer2PH=0x23;
     Timer2PM=((Data[2]&0xf)<<4)|(Data[3]&0xf);
     if(Timer2PM>0x59)Timer2PM=0x59;
     ReadData(8);
     Timer3SH=((Data[0]&0xf)<<4)|(Data[1]&0xf);
     if(Timer3SH>0x23)Timer3SH=0x23;
     Timer3SM=((Data[2]&0xf)<<4)|(Data[3]&0xf);
     if(Timer3SM>0x59)Timer3SM=0x59;
     ReadData(9);
     Timer3PH=((Data[0]&0xf)<<4)|(Data[1]&0xf);
     if(Timer3PH>0x23)Timer3PH=0x23;
     Timer3PM=((Data[2]&0xf)<<4)|(Data[3]&0xf);
     if(Timer3PM>0x59)Timer3PM=0x59;
     ReadData(11);
     Timer4SH=((Data[0]&0xf)<<4)|(Data[1]&0xf);
     if(Timer4SH>0x23)Timer4SH=0x23;
     Timer4SM=((Data[2]&0xf)<<4)|(Data[3]&0xf);
     if(Timer4SM>0x59)Timer4SM=0x59;
     ReadData(12);
     Timer4PH=((Data[0]&0xf)<<4)|(Data[1]&0xf);
     if(Timer4PH>0x23)Timer4PH=0x23;
     Timer4PM=((Data[2]&0xf)<<4)|(Data[3]&0xf);
     if(Timer4PM>0x59)Timer4PM=0x59;

     if ( TimerStatus&0x10){// on time/timer manue change  relase relay and erase save
          if ( TimerStatus&0x2)CloseDoorRelay();  //realse  relay 1 before enter to menue
          if ( TimerStatus&0x4)CloseDoorRelay2(); //realse  relay 2 before enter to menue
          TimerStatus=0;
          Pointer = SaveTimerSta;
          MaxNum = CMaxSaveTimerSta;
          strcpyf(Data,"0");
          WriteData(1);
     }
     Pointer = SaveTimerSta;
     MaxNum =  CMaxSaveTimerSta;
     ReadData(1);                // Saved timer status bits:
     TimerStatus=(Data[0]&0x0f);// bit 0= Dial , bit 1= Rly1 Bit2= Rly 2 bit 3= Dial Tst
     if ( TimerStatus&0x2)OpenDoorRelay();  //hold relay 1 after PU if nedded
     if ( TimerStatus&0x4)OpenDoorRelay2(); //hold relay 2 after PU if nedded

     Pointer = Type;
     MaxNum =  CMaxType;
     ReadData(1);

     TypeRam = ((Data[0]&0x0f)*100)+ ((Data[1]&0x0f)*10)+ (Data[2]&0x0f);

     if(LightTime == 99){
         PORTC |=0x1; //Light back Light
     }
     if((!LightTime)&&(!Status)) { //Status Light 
         PORTC &=~0x1; //Blank back Light
     }
     Pointer = RelayControl;
     MaxNum =  CMaxRelayControl;
     ReadData(1);
     if(Data[1] == ' ')  Rly1End = (Data[0]&0x0f);
     else if(Data[2] == ' ')  Rly1End = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     else Rly1End = (Data[0]&0x0f)*100+ (Data[1]&0x0f)*10 + (Data[2]&0x0f);
     ReadData(2);
     if(Data[1] == ' ')  Rly2Start = (Data[0]&0x0f);
     else if(Data[2] == ' ')  Rly2Start = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     else Rly2Start = (Data[0]&0x0f)*100+ (Data[1]&0x0f)*10 + (Data[2]&0x0f);

     Pointer = Ofset;
     MaxNum =  CMaxOfset;
     ReadData(1);
     AddedType = (Data[0]&0x0f);
     AddedValue=0;
     AddedValue = (Data[1]&0x0f);
     AddedValue *=100;
     AddedValue = AddedValue+(Data[2]&0x0f)*10 + (Data[3]&0x0f);
     if (!AddedType){// max adda value 749 for type 0
          if (AddedValue>(999-NAMEN))AddedValue=999-NAMEN;
     }
     else if ((AddedType==3)&&(AddedValue>99))AddedValue=99; // max adda value 99 for type 1,3,5
     else if (AddedType==2)AddedValue=0;//0 added value for type 2 
     else if ((AddedType==1)&&(AddedValue>100))AddedValue=100;//100 max added value for type 1 
     // type 1 and 4 do not touch AddedValue
     if (AddedType>=1)AddedType++;
     else if (AddedValue)AddedType=1;// type 0 change to 1 if AddedValue>0 
     if (AddedType>6)AddedType=6; // max 6 types 
          
     //type (0)0 no change 
     //type (0)1 offset max 855 ofset 
     //type (1)2 every 100     
     //type (2)3 new table
     //type (3)4 new 4 digit number  1599-9915 new arry with 2 dig of floor and 2 digit of app
     //type (4)5 4000-4999  --->1-999 app on  tel1-tel4  - limit last one by AddedValue
     //type (5)6 5000-5xxx -->0-9 bulding app 1-99 tel1 1-99 100-199 same to tel 2,3,4 tel 5 1-99
 

     Pointer = RingingNum;
     MaxNum = CMaxRingingNum;
     ReadData(1);
     if(Data[1] == ' ') RingNumber = Data[0]&0x0f;
     else RingNumber = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
     if (!RingNumber)RingNumber=1; //No Keypad during modem connection


     Pointer = FASTstep;
     MaxNum =  CMaxFASTstep;
     ReadData(1);
     FastStpValue= (Data[0]&0x0f);

     YesNoAnswer=0;
     YesNoAnswer2=0;
     Pointer = AnswerY_N;
     MaxNum =  CMaxAnswerY_N;
     ReadData(1);
     if (Data[0]=='Y')YesNoAnswer |=0x1;//put  Replace appartment by Ofice no
     ReadData(2);
     if (Data[0]=='Y')YesNoAnswer |=0x2;//put  back light ilumination by det
     ReadData(3);
     if (Data[0]=='Y')YesNoAnswer |=0x4;//put  proxy 1 relay 1
     ReadData(4);
     if (Data[0]=='Y')YesNoAnswer |=0x8;//put  proxy 1 relay 2
     ReadData(5);
     if (Data[0]=='Y')YesNoAnswer |=0x10;//put  proxy 2 relay 1
     ReadData(6);
     if (Data[0]=='Y')YesNoAnswer |=0x20;//put  proxy 2 relay 2
     ReadData(7);
     if (Data[0]=='Y')YesNoAnswer |=0x40;//put  Proxy plus code
     ReadData(8);
     if (Data[0]=='Y')YesNoAnswer |=0x80;//put  A-Z mode 
     ReadData(9);
     if (Data[0]=='Y')YesNoAnswer2 |=0x1;//put  Extrnal Proxy
     ReadData(10);
     if (Data[0]=='Y')YesNoAnswer2 |=0x2;//put  Elevetor board
     ReadData(11);
     if (Data[0]=='Y')YesNoAnswer2 |=0x4;//put  Y/N low batt sound 
     ReadData(12);
     if (Data[0]=='Y')YesNoAnswer2 |=0x8;//put  Y/N Show Phone parameters 
     ReadData(13);
     if (Data[0]=='Y')YesNoAnswer2 |=0x10;//put  Y/N buzzer on unlock 
     ReadData(14);
     if (Data[0]=='Y')YesNoAnswer2 |=0x20;//put  Y/N APP/OFFICE DISP  //FIX MENU 
     ReadData(15);
     if (Data[0]=='Y')YesNoAnswer2 |=0x80;//put  Direct Dial Mode   //FIX MENU         
     ReadData(16);
     if (Data[0]=='Y')YesNoAnswer2 |=0x40;//put  Y/N Full menue  //FIX MENU        
     

     Pointer = MasageOn;
     MaxNum =  CMaxMasageOn;
     MessageOnOff=0;
     ReadData(1);
     if (Data[0]=='Y')MessageOnOff |=0x1;//put  Welcome message by # on
     ReadData(2);
     if (Data[0]=='Y')MessageOnOff |=0x2;//put  floor message on
     ReadData(3);
     if (Data[0]=='Y')MessageOnOff |=0x4;//put  close door message on
     ReadData(4);
     if (Data[0]=='Y')MessageOnOff |=0x8;//put  announce names  on
     ReadData(5);
     if (Data[0]=='Y')MessageOnOff |=0x10;//put  Forget door Message   on
     ReadData(6);
     if (Data[0]=='Y')MessageOnOff |=0x20;//put  welcome by det Message   on
     ReadData(7);
     if (Data[0]=='Y')MessageOnOff |=0x40;//put  Ring Message   on
     ReadData(8);
     if (Data[0]=='Y')MessageOnOff |=0x80;//put  open Message   on 
 

      Pointer = ExtKeys;
      MaxNum =  CMaxExtKeys;
      ReadData(1);
      if(Data[1] == ' ') BoardQty = Data[0]&0x0f; // Number of extenation 
      else BoardQty = (Data[0]&0x0f)*10 + (Data[1]&0x0f); 
      

      Pointer = ConfirmTone;
      MaxNum =  CMaxConfirmTone;
      ReadData(1);
      if ((Data[0]>=0x30)&&(Data[0]<=0x39))   // Confirm receiving call tone
     		ConfirmTONE=(Data[0]&0xf); else ConfirmTONE='-';


    /*  Pointer = CommSpd;
      MaxNum =  CMaxCommSpd;
      ReadData(1);
     if ((Data[0]&0xf)==0){//300 bout
           UBRR0H=0x08;//300
           UBRR0L=0x22;//300
      }
      if ((Data[0]&0xf)==1){ //600 bout
           UBRR0H=0x04;//600
           UBRR0L=0x11;//600
      }
      if ((Data[0]&0xf)==2){//900 bout
           UBRR0H=0x02;//900
           UBRR0L=0xB5;//900
      }
      if ((Data[0]&0xf)>=3){//1200 bout
           UBRR0H=0x02;//1200
           UBRR0L=0x08;//1200
      } */



//      Pointer = SpeechLevel;
//      MaxNum =  CMaxSpeechLevel;
//      ReadData(1);
//      Audio_Val= (Data[0]&0xf);//Set VoiceLevel 
//      if (Audio_Val==0)MessageOnOff=0;//FIX1 no message when valume =0 
//      else {  
////                         tx_buffer[0]=0x7E;  //play 3 
////                         tx_buffer[1]=0XFF;
////                         tx_buffer[2]=0X06;//NO 
////                         tx_buffer[3]=0X06;//OPCODE
////                         tx_buffer[4]=0X00;//REPLAY 
////                         tx_buffer[5]=0x00;//
////                         tx_buffer[6]=Audio_Val*3+15;//volume data  9 1b
////                         CheckSum=tx_buffer[1];
////                         CheckSum=CheckSum+tx_buffer[2]+tx_buffer[3]+tx_buffer[4]+tx_buffer[5]+tx_buffer[6]-1;
////                         CheckSum=0xFFFF-CheckSum;                                                                   
//////                                                 
////                         tx_buffer[7]=CheckSum>>8 ;//0XFE;//cs 
////                         tx_buffer[8]=CheckSum&0xff;//0XF6;//$0                                     
////                                                  
////                         tx_buffer[9]=0XEF;                                                                           
////                         Max_Tx_Buff =9;//N-1                          
////                         tx_index = 0;        
////                         UDR0=tx_buffer[0];
//                         tx_buffer[0]=0x7E;  //play 3 
//                         tx_buffer[1]=0XFF;
//                         tx_buffer[2]=0X06;//NO 
//                         tx_buffer[3]=0X06;//OPCODE
//                         tx_buffer[4]=0X00;//REPLAY 
//                         tx_buffer[5]=0x00;//
//                         tx_buffer[6]=Audio_Val*3+15;//volume data  9 1b
//                                                                                      
//                         tx_buffer[7]=0XEF;                                                                           
//                         Max_Tx_Buff =7;//N-1                          
//                         tx_index = 0;        
//                         UDR0=tx_buffer[0];                 
//      }                               
      


     DETPin |= 0x2; //was open
     MAGPin |= 0x2; //was open
     

     Pointer = BusySogTone;
     MaxNum = CMaxBusySogTone;
     ReadData(1);
     if(Data[1] == ' ') SogBusyTone = Data[0]&0x0f;
     else SogBusyTone = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
    //if (!SogBusyTone)SogBusyTone=1;else //0 0 auto mode 
     if (SogBusyTone>100)SogBusyTone=100;
     ReadData(2);
     if(Data[1] == ' ') SogBusyTone2 = Data[0]&0x0f;
     else SogBusyTone2 = (Data[0]&0x0f)*10 + (Data[1]&0x0f);
    // if (!SogBusyTone2)SogBusyTone2=1;else  //0 0 auto mode 
     if (SogBusyTone2>100)SogBusyTone2=100;

     Pointer = ToneCodes;
     MaxNum = CMaxToneCodes;
     ReadData(1);
     if ((Data[0]>=0x30)&&(Data[0]<=0x39)){ //START// No Keypad during modem connection(last cahnges ) 
     		ToneKey[0] =Data[0]&0x0f;
     } else ToneKey[0]='-';
     if ((Data[1]>=0x30)&&(Data[1]<=0x39)){            
     		ToneKey[1] =Data[1]&0x0f;
     } else ToneKey[1]='-'; 
     if (ToneKey[0] ==0)ToneKey[0]=10;  
     if (ToneKey[1] ==0)ToneKey[1]=10; //END //No Keypad during modem connection(last cahnges )  


   Data[0]=0x81;// 1024 HZ output
   DataWritePCF(0xD,1,&Data[0]);//hours
   Data[0]=0;// contrl 1
   DataWritePCF(0,1,&Data[0]);//hours
   Data[0]=0;// contrl 2
   DataWritePCF(1,1,&Data[0]);//hours  
   
  

}

char TestCode(void)
{
    char Find,Error,ind,i;
    Find = ind = 0;
    MaxNum = CMaxMasterCode;
    Pointer = MasterCode;


    if(CountCode)do
    {
       ind++;
       ReadData(ind);
       Error = 0;
       i = 0;
       while((i < CountCode)&& !Error)
       {
           if(Data[i] != UserCode[i]+0x30)
               Error = 1;
           i++;
       }
       if(!Error)
       {
           Find = 1;
           if((Data[i] > 0x20)&&(CountCode < CMaxMasterCode)) Find = 0;
       }
    }while((ind <= MaxCode+2)&& !Find);
    if(Find){    // if was press mad code
          if(ind == 1) Find = 2;  // master code
          else
          if(ind == 2) Find = 3;  // tec. user code
    }
    Rly12Ind=ind-2;
    return(Find);
}

char TestRemoteCode(void)
{
    char Find,Error,ind,i;
    Find = ind = 0;
    MaxNum = CMaxMasterCode;
    Pointer = MasterCode;

    if(CountCode2)do
    {
       ind++;
       ReadData(ind);
       Error = 0;
       i = 0;
       while((i < CountCode2)&& !Error)
       {
           if (rx_buffer0[i+3]==10)rx_buffer0[i+3]=0;
           if(Data[i] != rx_buffer0[i+3]+0x30)
               Error = 1;
           i++;
       }
       if(!Error)
       {
           Find = 1;
           if((Data[i] > 0x20)&&(CountCode2 < CMaxMasterCode))
               Find = 0;
       }
    }while((ind <= MaxCode+2)&& !Find);
    if(Find){    // if was press mad code
          if(ind == 1) Find = 2;  // master code
          else
          if(ind == 2) Find = 3;  // tec. user code
    }
    return(Find);
}

void Enable_RelayTime(void)
{
    TCNT1H=0x00;
    TCNT1L=0x00;
    TCCR1B=0x09;
}
void Disable_RelayTime(void)
{
    TCCR1B=0x00;
}

interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
unsigned char i,v;  
if ((YesNoAnswer2&0x8)||(BusyTstTO_Timer)){  
       if (PIND&0x10){
            if (!PC7WasHigh){ 
                 if (PC7Cnt<250)PC7Cnt++; 
            } 
            PC7WasHigh=1;                      
       }
       else PC7WasHigh=0;  
}

if (VoiceIC_Mode){
  if (!Pulse_Width){
     if (Audio_Tx_Cnt==32){
          PORTB &=~0x6;//data=clk=0
          Audio_Tx_Cnt--;
          Pulse_Width=76;
     }
     else {
          if ((Audio_Tx_Cnt==2)&&(Auido_Sound&0x1))PORTB |=0x4;
          else if ((Audio_Tx_Cnt==4)&&(Auido_Sound&0x2))PORTB |=0x4;
          else if ((Audio_Tx_Cnt==6)&&(Auido_Sound&0x4))PORTB |=0x4;
          else if ((Audio_Tx_Cnt==8)&&(Auido_Sound&0x8))PORTB |=0x4;
          else if ((Audio_Tx_Cnt==10)&&(Auido_Sound&0x10))PORTB |=0x4;
          else if ((Audio_Tx_Cnt==12)&&(Auido_Sound&0x20))PORTB |=0x4;
          else if ((Audio_Tx_Cnt==14)&&(Auido_Sound&0x40))PORTB |=0x4;
          else if ((Audio_Tx_Cnt==16)&&(Auido_Sound&0x80))PORTB |=0x4;
          else if ((Audio_Tx_Cnt>16)&&(Audio_Cmnd))PORTB |=0x4;
          if (Audio_Tx_Cnt){
              Audio_Tx_Cnt--;
              if (!Audio_Tx_Cnt)VoiceIC_Mode=0;
              PORTB ^=0x2;//flip clk
              Pulse_Width=7;
          }
     }
  }else {
     Pulse_Width--;
     if ((Pulse_Width==3)&&(!(Audio_Tx_Cnt&0x1)))PORTB &=~0x4;
     if ( (Pulse_Width==3) && (Audio_Cmnd) && (Audio_Tx_Cnt>30) ) PORTB |=0x4;
  }
}
else if ((!CounterRing)&&(!Wait_DoorOpen_Now)){

if (PrxyCnt<50)PrxyCnt++ ;//inc up to limit
//PORTG &=~0x4;//put end sign
if (PrxyStartSine){
     if ((PINA&0x20)&&(!WasHigh)){// rise edge
         if (PrxyCnt>Pry_Wide*2){
              MarkAsOne =1;//rise after long zero
              NoOfPulse++;
              CodeReg<<=1;
              CodeReg++;//==1
              if (NoOfPulse%5)PxySum++;

         }
         else  if ((PrxyCnt>Pry_Wide)&&(MarkAsOne )){
              CodeReg<<=1;
              CodeReg++;//==1
              NoOfPulse++;
              if (NoOfPulse%5)PxySum++;
         }
         else  if ((PrxyCnt>Pry_Wide)&&(!MarkAsOne )){
              CodeReg<<=1;//==0
              NoOfPulse++;
         }
         PrxyCnt=0;
         WasHigh=1;
         if (NoOfPulse==55){
              if (CodeReg&0x1)PxyErr=1;// if stop bit =1 then error
              CodeReg>>=1;
              CodeReg &=~0xf0;
              DataCode[(NoOfPulse/5)-1]=CodeReg;
         }
         else if (!(NoOfPulse%5)){//for 5/10/15/20/25...
              if ((PxySum&0x1)==(CodeReg&0x1)){//check sum is correct
                  CodeReg>>=1;
                  CodeReg &=~0xf0;
                  DataCode[(NoOfPulse/5)-1]=CodeReg;
              }else {
                  PxyErr=1;
              }
              CodeReg=0;
              PxySum=0;
        }
     }
     if ((!(PINA&0x20))&&(WasHigh)){// falling edge
         if (PrxyCnt>Pry_Wide*2){
              MarkAsOne =0;//Fall after long one
              CodeReg<<=1;//==0
              NoOfPulse++;

              if (NoOfPulse==55){
                   if (CodeReg&0x1)PxyErr=1;// if stop bit =1 then error
                   CodeReg>>=1;
                   CodeReg &=~0xf0;
                   DataCode[(NoOfPulse/5)-1]=CodeReg;
              }
              else if (!(NoOfPulse%5)){//for 5/10/15/20/25...
                   if ((PxySum&0x1)==(CodeReg&0x1)){//check sum is correct
                        CodeReg>>=1;
                        CodeReg &=~0xf0;
                        DataCode[(NoOfPulse/5)-1]=CodeReg;
                   }else {
                        PxyErr=1;
                   }
                   CodeReg=0;
                   PxySum=0;
              }
         }
         WasHigh=0;
         PrxyCnt=0;
    }
    if (NoOfPulse==55){  
    //PORTG &=~0x4;//put end sign
         PrxyStartSine=0;
         PxySum=0;//test vertical CS
         for (i=0;i<10;i++)if (DataCode[i]&0x1)PxySum++;
         if ( ( PxySum&0x1)!=((DataCode[10])&0x1) )PxyErr=1;
         PxySum=0;
         for (i=0;i<10;i++)if (DataCode[i]&0x2)PxySum++;
         CodeReg = DataCode[10]>>1;
         if ( ( PxySum&0x1)!=((CodeReg&0x1)) )PxyErr=1;
         PxySum=0;
         for (i=0;i<10;i++)if (DataCode[i]&0x4)PxySum++;
         CodeReg = DataCode[10]>>2;
         if ( ( PxySum&0x1)!=((CodeReg&0x1)) )PxyErr=1;
         PxySum=0;
         for (i=0;i<10;i++)if (DataCode[i]&0x8)PxySum++;
         CodeReg = DataCode[10]>>3;
         if ( ( PxySum&0x1)!=((CodeReg&0x1)) )PxyErr=1;
         DataCode[14]=0x30+PxySum;
         if (!PxyErr){
              v=0; //test error card 0000000000
              for (i=0;i<10;i++){
                   if (DataCode[i]==0)v++;
                   if (DataCode[i]<=9)DataCode[i] +=0x30;
                   else if (DataCode[i]>9)DataCode[i] =DataCode[i]+0x40-9;
              }                
              for(i=0;i<5;i++){
                  CodeReg=DataCode[i];
                  NoOfPulse=DataCode[9-i];   //swap places 
                  
                  DataCode[i]=NoOfPulse; //temporrly use NoOfPulse as memory
                  DataCode[9-i]=CodeReg;
              }
              for(i=0;i<=3;i++){ //swap Prxy CODE  //LONG 8               
                   NoOfPulse=DataCode[i]; //temporrly use NoOfPulse as memory
                   DataCode[i]=DataCode[7-i];
                   DataCode[7-i]=NoOfPulse;                    
              } //swap Prxy CODE  //LONG 8                      
              if ((!ProxyValid)&&(v<=6)){// max 6 zero in the result                                                           
                   if (!Status){
                        ProxyValid=5;
                        //Siren_Start(1);  //One Beep
                   }
                   else ProxyValid=4; 
                   if (Wait_DoorOpen_Now)ProxyValid=0;
              }
         }
    }
}else {////////////chechk for start ///////////////////
    if ((PINA&0x20)&&(!WasHigh)){// rise edge
        if (PrxyCnt>Pry_Wide*2){
            MarkAsOne =1;//rise after long zero
        }
        else  if ((PrxyCnt>Pry_Wide)&&(MarkAsOne )){
            PrxyResult++;
        }
        if ((PrxyResult==8)&&(!(PrxyStartSine))){
            PrxyResult=0;
            if (!ProxyValid)PrxyStartSine=1;
            //if (ProxyValid)ProxyValid=4;
            NoOfPulse=0;
            CodeReg=0;
            PxySum=0;
            PxyErr=0;
            //PORTG |=0x4;//put start sign
        }
        PrxyCnt=0;
        WasHigh=1;
    }
    if ((!(PINA&0x20))&&(WasHigh)){// falling edge
        if (PrxyCnt>Pry_Wide*2){
            MarkAsOne =0;//Fall after long one
            PrxyResult=0;

        }
        WasHigh=0;
        PrxyCnt=0;
    }
}
}


/*     CuzPryCycl++;
if ( CuzPryCycl>=8){
   CuzPryCycl=0;*/
 /*  if(CounterPauseRelay){
         CounterPauseRelay--;
         //if(!CounterPauseRelay)PORTB|= 0x20;
   }else if(FlagStartRelay){
        if(Data_Rely & BiRelay){
            // if(CountRelay <= 1) PORTB&=~0x20;
            // else PORTB|= 0x20;
        }
        else{
             //if(CountRelay == 0) PORTB&=~0x20;
             //else PORTB|= 0x20;
        }
        CountRelay++;
        if(CountRelay == 3){
              CountRelay = 0;
              BiRelay<<= 1;
              if(BiRelay & 0x2000){
                  BiRelay = 1;
                  //PORTB&=~0x20;
                  CounterPauseRelay = 36*4;
                  FlagStartRelay--;
                 // if(!FlagStartRelay) Disable_RelayTime();
              }

        }
     }*/
   //}
}
interrupt [USART0_RXC] void uart0_rx_isr(void)         // receiving
{
char status,data;
#asm
    push r26
    push r27
    push r30
    push r31
    in   r26,sreg
    push r26
#endasm
//PORTB|= 0x01;
status=UCSR0A;
//CountCanSend = 0;
//TCNT0=TimeOfTimeOut;       // restart timer of timeout
data=UDR0;
/*
   if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
         rx_buffer0[rx_wr_index0]=data;

         if (++rx_wr_index0 >= rx_buffer0[0]+2)
         {
                //UCSR0B&= ~0x10;   // receive
                //UCSR0B&= ~0x80;   // receive
                StatusUart = 0;
                TIMSK&= ~0x01;    // Close Time Out
                if((ValueChecsum == data)&&(!rx_buffer0[1])){
                   Checsum = 1;
                }
                else{
                   Checsum = 0;
                }
                WasReceiving = 1;

                // stop interapt
         }
         else if(rx_wr_index0 > 1)
                    ValueChecsum+= data;
   };  */
  // PORTB&= ~0x01;     PORTB|= 0x01;
#asm
    pop  r26
    out  sreg,r26
    pop  r31
    pop  r30
    pop  r27
    pop  r26
#endasm
}

interrupt [USART0_TXC] void uart0_tx_isr(void)
{
#asm
    push r26
    push r27
    push r30
    push r31
    in   r26,sreg
    push r26
#endasm


            if(++tx_index > Max_Tx_Buff)
             {
               //   UCSRB|= 0x20;   // enable interapt empaty
             }
             else{
                      UDR0=tx_buffer[tx_index];
             }            


//            tx_rd_index0++;
//            Tx_Max_Char--;
//            if(!Tx_Max_Char)
//            {
//                 //UCSR0B=0xD8;
//                 //Press_Call_pls=50;//put press call+delay
//                 DialTime=0;
//             //    PORTA &=~0x8;  // put Speech AMP
//            }
//            else{
//                        UDR0=tx_buffer0[tx_rd_index0];
//            }  
/*

             tx_rd_index1++;
             if(Status_MD){
                   if(tx_buffer1[0]<tx_rd_index1-1)
                   {
                       tx_rd_index1 = 0;
                   }
                   else{
                        while(PORTD & 0x08);
                       UDR1=tx_buffer1[tx_rd_index1];
                   }
             }
             else{
                   if(!tx_buffer1[tx_rd_index1])
                   {
                       tx_rd_index1 = 0;
                   }
                   else{
                        while(PORTD & 0x08);
                        UDR1=tx_buffer1[tx_rd_index1];
                   }
             }    */
/*             if(++tx_rd_index0 > tx_buffer0[0]+1)
             {
                  StatusUart = 2;
                  UCSR0B|= 0x20;   // enable interapt empaty
             }
             else{
                  if(tx_rd_index0 > tx_buffer0[0]){
                      UDR0 = ValueChecsum;
                  }
                  else{
                      ValueChecsum+= tx_buffer0[tx_rd_index0];
                      UDR0=tx_buffer0[tx_rd_index0];
                  }
             }*/

#asm
    pop  r26
    out  sreg,r26
    pop  r31
    pop  r30
    pop  r27
    pop  r26
#endasm

}

interrupt [USART0_DRE] void uart0_udre_isr(void)
{
#asm
    push r26
    push r27
    push r30
    push r31
    in   r26,sreg
    push r26
#endasm
/*                    UCSR0B&= ~0x20;    // disable interapt send
                   // PORTE&= ~0x04;     // Receive
                    rx_wr_index0 = 0;
                    ValueChecsum = 0;
                    StatusUart = 3;
                    TIMSK|=0x01;        // enable Time out
                    //CountConectPC = 0;
                    TCNT0=TimeOfTimeOut;
                    Sending = 0;
                    CountCanSend = 0;  */
#asm
    pop  r26
    out  sreg,r26
    pop  r31
    pop  r30
    pop  r27
    pop  r26
#endasm
}

interrupt [USART1_RXC] void uart1_rx_isr(void)
{

unsigned char status,data,CheckSum,point,type,location,End_Pnt,FillUpTo,Qtty;

#asm
    push r26
    push r27
    push r30
    push r31
    in   r26,sreg
    push r26
#endasm

status=UCSR1A;
data=UDR1;

if ((data=='!')&&(AnsMD_timeOut)){ //Ver277-MdmRepir
    if (!MDM_Reply_Mode){
         Siren_Start(2);
         PassWordTstNeeded=1; 
    }
    MDM_Reply_Mode=1;
    AnsMD_timeOut=60;
    TimeConectedWithApp=SpeechTime;//was 60;  //FIX MENU  
}
if (MDM_Reply_Mode){  
            if (data==0x11){
                  MDM_index=0;   
                  for (Point=0; Point<16; Point++)
                  {
                       Data [Point] = 0x20;
                  }                                 
                  AnsMD_timeOut=60;
                  TimeConectedWithApp=SpeechTime;//was 60;  //FIX MENU  
            }
            else if (data==13){                                
                  ValueChecsum=0;
                  for (Point=0; Point<= (MDM_index-3) ; Point++)
                  {
                       ValueChecsum += MDM_buffer[Point];
                  }
                  
                  CS_test = ValueChecsum >> 4;
                  CS_test = CS_test & 0xf;
                  CS_test +=0x30; 
                  MDM_Reply_M=0;
                  if (CS_test==MDM_buffer [MDM_index-2])MDM_Reply_M++;                   
                  CS_test = ValueChecsum & 0xf;
                  CS_test +=0x30;     
                  if (CS_test==MDM_buffer [MDM_index-1])MDM_Reply_M++;
                  
                  
                  if (MDM_Reply_M==2){ 
                      if (MDM_buffer[0]=='K'){
                            Pointer = MasterCode;
                            MaxNum = CMaxMasterCode;
                            ReadData(1); 
                            for (Point=0; Point< CMaxMasterCode; Point++){
                                 if ((Data[Point]==0)||(Data[Point]==' '))Point= CMaxMasterCode+2;//exit        
                                 else if (Data[Point]!=MDM_buffer[Point+1])MDM_Reply_M=0; //put error found sign                                
                            }
                            if (MDM_Reply_M){
                                 MDM_Reply_M=3;//send OK sign 
                                 PassWordTstNeeded=0;
                            }
                      //PC send W+ Type or W+Type+Location +Qtty 
                      //Replay OKok or ERROR 
                      }else if ((MDM_buffer[0]=='W')&&(!PassWordTstNeeded)){  
                
                            MDM_Reply_M=3;//send OK sign                              ;
                            End_Pnt=0;  //here is 3x 3x                             
                            if ((MDM_buffer[1]=='0')||(MDM_buffer[1]=='1')){//ocode 01-16 no location or Qtty 
                                 for (point=1;point<MDM_index-3;point+=2) //change to 
                                 { //convert to one byte data + arrange Data 
                                      tx_buffer1[End_Pnt]= ((MDM_buffer[point]&0xf)<<4)+(MDM_buffer[point+1]&0xf); 
                                      if (End_Pnt>=1){ 
                                           Data[End_Pnt-1]=tx_buffer1[End_Pnt];//use tx_buffer1 temporrly 
                                      }
                                      End_Pnt++;
                                 } 
                                  //ADD here HEX test  and corect Data lenght  (short by one digit)                             
                                // type= (((tx_buffer1[0])&0xf)*10) +((tx_buffer1[1])&0xf);  
                                 type= tx_buffer1[0];

                            }else { // opcode 40->=0  there is location and qtty     
                                 End_Pnt=0;  //here is 3x 3x ....
                                 for (point=1;point<MDM_index-3;point+=2)
                                 { //convert to one byte data + arrange Data
                                      tx_buffer1[End_Pnt]= ((MDM_buffer[point]&0xf)<<4)+(MDM_buffer[point+1]&0xf); 
                                      if (End_Pnt>=3){ 
                                           Data[End_Pnt-3]=tx_buffer1[End_Pnt];//use tx_buffer1 temporrly 
                                      }
                                      End_Pnt++;
                                 } 
                                 //ADD here HEX test  and corect Data lenght  (short by one digit)                                   
                                 //type= (((tx_buffer1[0])&0xf)*10) +((tx_buffer1[1])&0xf);
                                 //location = (((tx_buffer1[2])&0xf)*16) +((tx_buffer1[3])&0xf);
                                 //Qtty=  (((tx_buffer1[4])&0xf)*10) +((tx_buffer1[5])&0xf); //TBD *10 or *16
                                 type= tx_buffer1[0]; 
                                 
                                 location = tx_buffer1[1];
                                 Qtty=  tx_buffer1[2] ; // *16
                                 if (!Qtty)Qtty=1;///NEED TO BE REMOVE AFTER QTTY SEND  
                                 //MaxEEpromV= type;
                                // MaxEEpromV=type*1000 + location;
                                            
                            }                                                                     
                            switch (type){
                            
                                 case 1://write TimeCycle  Part 1 
                                      End_Pnt=1;//write 9 times 
                                      strcpy (tx_buffer1,Data);  
                                        for (location=1; location<=18;location+=2){
                                           Pointer = TimeCycle;
                                           MaxNum = CMaxTimeCycle;
                                           Data[0]= tx_buffer1[location-1];
                                           Data[1]= tx_buffer1[location];
                                           WriteData(End_Pnt);                                          
                                           End_Pnt++;
                                      }  
                                      MDM_Reply_M=3;//Replay =OK  
                                 break;
                                 case 2://write TimeCycle  Part 2
                                      End_Pnt=10;//write 8 times
                                      strcpy (tx_buffer1,Data); 
                                      for (location=1; location<=18;location+=2){
                                           Pointer = TimeCycle;
                                           MaxNum = CMaxTimeCycle;
                                           Data[0]= tx_buffer1[location-1];
                                           Data[1]= tx_buffer1[location];
                                           WriteData(End_Pnt);                                              
                                           End_Pnt++;
                                      } 
                                      MDM_Reply_M=3;//Replay =OK     
                                 break;                                                                                 
                                 case 3://write AnswerY_N
                                      End_Pnt=1;//write 8 times
                                      strcpy (tx_buffer1,Data); 
                                      for (location=1; location<=16;location++){
                                           Pointer = AnswerY_N;
                                           MaxNum = CMaxAnswerY_N;  
                                          // if (location==14)location=15;//swap Last menu location 
                                           Data[0]= tx_buffer1[location-1];                                      
                                           WriteData(End_Pnt);                                              
                                           End_Pnt++;
                                      }
                                      MDM_Reply_M=3;//Replay =OK  
                                 break;  
                                 case 4://write RmtMasterCode 
                                       Pointer = RmtMasterCode;
                                       MaxNum = CMaxRmtMasterCode;
                                       WriteData(1);
                                       MDM_Reply_M=3;//Replay =OK   
                                 break; 
                                 case 5://write MasterCode 
                                       strcpy (tx_buffer1,Data); 
                                       Pointer = RmtMasterCode;
                                       MaxNum = CMaxRmtMasterCode;
                                       ReadData(1); 
                                       strcpy (Data,tx_buffer1);
                                       if( strcmp(tx_buffer1,Data) == 0 ){                                       
                                            Pointer = MasterCode;
                                            MaxNum = CMaxMasterCode;
                                            WriteData(1); 
                                            //Siren_Start(3);
                                       } 
                                       MDM_Reply_M=3;//Replay =OK                                    
                                 break;                                                                                                                                                                   
                                 case 6://write TecUserCode 
                                       Pointer = TecUserCode;
                                       MaxNum = CMaxTecUserCode;
                                       WriteData(1);
                                       MDM_Reply_M=3;//Replay =OK  
                                 break;  
                                 case 7://write BusySogTone  //
                                       End_Pnt=1;//write 9 times 
                                       strcpy (tx_buffer1,Data);
                                       for (location=1; location<=18;location+=2){ //                                        
                                            Pointer = BusySogTone;
                                            MaxNum = CMaxBusySogTone;
                                            Data[0]= tx_buffer1[location-1];
                                            Data[1]= tx_buffer1[location];
                                            WriteData(End_Pnt);                                          
                                            End_Pnt++;
                                       }
                                       MDM_Reply_M=3;//Replay =OK  
                                 break;    
                                 case 8://write FloorValue  //
                                       End_Pnt=1;//write 10 times 
                                       strcpy (tx_buffer1,Data);
                                       for (location=0; location<10;location++){
                                            Pointer = FloorValue;
                                            MaxNum = CMaxFloorValue;
                                            Data[0]= tx_buffer1[location*3];
                                            Data[1]= tx_buffer1[location*3+1];
                                            Data[2]= tx_buffer1[location*3+2];
                                            WriteData(End_Pnt);                                          
                                            End_Pnt++;
                                       }
                                       MDM_Reply_M=3;//Replay =OK  
                                 break;             
                                 case 9://write FloorValue #2 //
                                       End_Pnt=11;//write 10 times 
                                       strcpy (tx_buffer1,Data);
                                       for (location=0; location<10;location++){
                                            Pointer = FloorValue;
                                            MaxNum = CMaxFloorValue;
                                            Data[0]= tx_buffer1[location*3];
                                            Data[1]= tx_buffer1[location*3+1];
                                            Data[2]= tx_buffer1[location*3+2];
                                            WriteData(End_Pnt);                                          
                                            End_Pnt++;
                                       }
                                       MDM_Reply_M=3;//Replay =OK  
                                 break;                     
                                 case 10://write FloorValue #3 //
                                       End_Pnt=21;//write 10 times 
                                       strcpy (tx_buffer1,Data);
                                       for (location=0; location<10;location++){
                                            Pointer = FloorValue;
                                            MaxNum = CMaxFloorValue;
                                            Data[0]= tx_buffer1[location*3];
                                            Data[1]= tx_buffer1[location*3+1];
                                            Data[2]= tx_buffer1[location*3+2];
                                            WriteData(End_Pnt);                                          
                                            End_Pnt++;
                                       }
                                       MDM_Reply_M=3;//Replay =OK                                          
                                 break; 
                                case 17://write FloorValue #4 //
                                       End_Pnt=31;//write 10 times 
                                       strcpy (tx_buffer1,Data);
                                       for (location=0; location<10;location++){
                                            Pointer = FloorValue;
                                            MaxNum = CMaxFloorValue;
                                            Data[0]= tx_buffer1[location*3];
                                            Data[1]= tx_buffer1[location*3+1];
                                            Data[2]= tx_buffer1[location*3+2];
                                            WriteData(End_Pnt);                                          
                                            End_Pnt++;
                                       }
                                       MDM_Reply_M=3;//Replay =OK                                          
                                 break;
                                 case 18://write FloorValue #5 //
                                       End_Pnt=41;//write 10 times 
                                       strcpy (tx_buffer1,Data);
                                       for (location=0; location<10;location++){
                                            Pointer = FloorValue;
                                            MaxNum = CMaxFloorValue;
                                            Data[0]= tx_buffer1[location*3];
                                            Data[1]= tx_buffer1[location*3+1];
                                            Data[2]= tx_buffer1[location*3+2];
                                            WriteData(End_Pnt);                                          
                                            End_Pnt++;
                                       }
                                       MDM_Reply_M=3;//Replay =OK                                          
                                 break;
                                case 19://write FloorValue #6 //
                                       End_Pnt=51;//write 10 times 
                                       strcpy (tx_buffer1,Data);
                                       for (location=0; location<10;location++){
                                            Pointer = FloorValue;
                                            MaxNum = CMaxFloorValue;
                                            Data[0]= tx_buffer1[location*3];
                                            Data[1]= tx_buffer1[location*3+1];
                                            Data[2]= tx_buffer1[location*3+2];
                                            WriteData(End_Pnt);                                          
                                            End_Pnt++;
                                       }
                                       MDM_Reply_M=3;//Replay =OK                                          
                                 break;                                                                     
                                 case 11://write MasageOn
                                      End_Pnt=1;//write 8 times
                                      strcpy (tx_buffer1,Data); 
                                      for (location=1; location<=8;location++){
                                           Pointer = MasageOn;
                                           MaxNum = CMaxMasageOn;
                                           Data[0]= tx_buffer1[location-1];                                      
                                           WriteData(End_Pnt);                                              
                                           End_Pnt++;
                                      }
                                      MDM_Reply_M=3;//Replay =OK  
                                 break; 
                                 case 12://write RelayControl  //
                                       End_Pnt=1;//write 2 times 
                                       strcpy (tx_buffer1,Data);
                                       for (location=1; location<=6;location+=3){
                                            Pointer = RelayControl;
                                            MaxNum = CMaxRelayControl;
                                            Data[0]= tx_buffer1[location-1];
                                            Data[1]= tx_buffer1[location];
                                            Data[2]= tx_buffer1[location+1];
                                            WriteData(End_Pnt);                                          
                                            End_Pnt++;
                                       }
                                       MDM_Reply_M=3;//Replay =OK  
                                 break; 
                                 case 13://write ExtKeys (2),FASTstep(1),CommSpd(1),FamilyNo(1),Ofset(4)                                      
                                           strcpy (tx_buffer1,Data); 
                                           Pointer = ExtKeys;
                                           MaxNum = CMaxExtKeys;
                                           Data[0]= tx_buffer1[0]; 
                                           Data[1]= tx_buffer1[1];                                       
                                           WriteData(1);
                                           Pointer = FASTstep;
                                           MaxNum = CMaxFASTstep;
                                           Data[0]= tx_buffer1[2]; 
                                           WriteData(1); 
                                           Pointer = CommSpd;
                                           MaxNum = CMaxCommSpd;
                                           Data[0]= tx_buffer1[3]; 
                                           WriteData(1);   
                                           Pointer = FamilyNo;
                                           MaxNum = CMaxFamilyNo;
                                           Data[0]= tx_buffer1[4]; 
                                           WriteData(1);   
                                           Pointer = Ofset;
                                           MaxNum = CMaxOfset;
                                           Data[0]= tx_buffer1[5]; 
                                           Data[1]= tx_buffer1[6]; 
                                           Data[2]= tx_buffer1[7];    
                                           Data[3]= tx_buffer1[8];                                          
                                           WriteData(1); 
                                           MDM_Reply_M=3;//Replay =OK      
                                 break;                                                                               
                                 case 14://write SetReadTimer part#1                                    
                                       End_Pnt=1;//write 6 times from location 1
                                       strcpy (tx_buffer1,Data);
                                       for (location=1; location<=27;location+=4){
                                            Pointer = SetReadTimer;
                                            MaxNum = CMaxSetReadTimer;
                                            Data[0]= tx_buffer1[location-1];
                                            Data[1]= tx_buffer1[location];
                                            Data[2]= tx_buffer1[location+1];
                                            Data[3]= tx_buffer1[location+2];
                                            if ((location==1)|| (location==16)){
                                                   Data[4]= tx_buffer1[location+3];
                                                   Data[5]= tx_buffer1[location+4];
                                                   Data[6]= tx_buffer1[location+5]; 
                                                   location +=3;                                           
                                            }else{
                                                 Data[4]=0x20; 
                                                 Data[5]=0x20;
                                                 Data[6]=0x20;
                                            }                                            
                                            WriteData(End_Pnt);                                          
                                            End_Pnt++;
                                       } 
                                       MDM_Reply_M=3;//Replay =OK  
                                 break;                                                                                                                              
                                 case 15://write SetReadTimer part#2                                    
                                       End_Pnt=7;//write 6 times from location 7 
                                       strcpy (tx_buffer1,Data);
                                       for (location=1; location<=27;location+=4){
                                            Pointer = SetReadTimer;
                                            MaxNum = CMaxSetReadTimer;
                                            Data[0]= tx_buffer1[location-1];
                                            Data[1]= tx_buffer1[location];
                                            Data[2]= tx_buffer1[location+1];
                                            Data[3]= tx_buffer1[location+2];
                                            if ((location==1)|| (location==16)){
                                                   Data[4]= tx_buffer1[location+3];
                                                   Data[5]= tx_buffer1[location+4];
                                                   Data[6]= tx_buffer1[location+5]; 
                                                   location +=3;                                           
                                            }else{
                                                 Data[4]=0x20; 
                                                 Data[5]=0x20;
                                                 Data[6]=0x20;
                                            }                                            
                                            WriteData(End_Pnt);                                          
                                            End_Pnt++;
                                       } 
                                       MDM_Reply_M=3;//Replay =OK  
                                 break;   
                                 case 16://write SpeechLevel (1),RingingNum(2),ToneCodes(2),ConfirmTone(1)                                      
                                           strcpy (tx_buffer1,Data); 
                                           Pointer = SpeechLevel;
                                           MaxNum = CMaxSpeechLevel;
                                           Data[0]= tx_buffer1[0]; 
                                           WriteData(1);
                                           Pointer = RingingNum;
                                           MaxNum = CMaxRingingNum;
                                           Data[0]= tx_buffer1[1]; 
                                           Data[1]= tx_buffer1[2];                                            
                                           WriteData(1); 
                                           Pointer = ToneCodes;
                                           MaxNum = CMaxToneCodes;
                                           Data[0]= tx_buffer1[3];
                                           Data[1]= tx_buffer1[4];                                              
                                           WriteData(1);   
                                           Pointer = ConfirmTone;
                                           MaxNum = CMaxConfirmTone;
                                           Data[0]= tx_buffer1[5]; 
                                           WriteData(1);
                                           MDM_Reply_M=3;//Replay =OK    
                                 break;     
                                 
                                 case 40://write name 
                                       End_Pnt= strlen(Data);
                                       if (!End_Pnt)strcpyf(Data,"                ");
                                       for (point= location;point<(location+Qtty);point++){
                                            Pointer = Name;
                                            MaxNum = CMaxName;
                                            WriteData(point);
                                            AnsMD_timeOut=60;
                                       }
                                       MDM_Reply_M=3;//Replay =OK  
                                 break;  
                                case 150://write name2 
                                       End_Pnt= strlen(Data);
                                       if (!End_Pnt)strcpyf(Data,"                ");
                                       for (point= location;point<(location+Qtty);point++){
                                            Pointer = Name;
                                            MaxNum = CMaxName;
                                            Class=1;
                                            WriteData(point); 
                                            Class=0; 
                                            AnsMD_timeOut=60;
                                       }
                                       MDM_Reply_M=3;//Replay =OK  
                                 break;                                 
                                 case 50://write Tel1Num 
                                       for (point= location;point<(location+Qtty);point++){
                                            Pointer = Tel1Num;
                                            MaxNum = CMaxTel1Num;
                                            WriteData(point);  
                                            AnsMD_timeOut=60;
                                       }
                                       MDM_Reply_M=3;//Replay =OK  
                                 break;                                                  
                                 case 60://write Code 
                                       for (point= location;point<(location+Qtty);point++){
                                            Pointer = Code;
                                            MaxNum = CMaxCode;
                                            WriteData(point);   
                                            AnsMD_timeOut=60;
                                       }
                                       MDM_Reply_M=3;//Replay =OK  
                                 break;                                  
                                 case 70://write Tel2Num 
                                       for (point= location;point<(location+Qtty);point++){
                                            Pointer = Tel2Num;
                                            MaxNum = CMaxTel2Num;
                                            WriteData(point);      
                                            AnsMD_timeOut=60;
                                       }
                                       MDM_Reply_M=3;//Replay =OK  
                                 break;                                  
                                 case 80://write Tel3Num 
                                       for (point= location;point<(location+Qtty);point++){
                                            Pointer = Tel3Num;
                                            MaxNum = CMaxTel3Num;
                                            WriteData(point);              
                                            AnsMD_timeOut=60;
                                       }
                                       MDM_Reply_M=3;//Replay =OK  
                                 break; 
                                 case 90://write Tel4Num 
                                       for (point= location;point<(location+Qtty);point++){
                                            Pointer = Tel4Num;
                                            MaxNum = CMaxTel4Num;
                                            WriteData(point);            
                                            AnsMD_timeOut=60;
                                       }
                                       MDM_Reply_M=3;//Replay =OK  
                                 break;  
                                 case 100://write Tel5Num 
                                       for (point= location;point<(location+Qtty);point++){
                                            Pointer = Tel5Num;
                                            MaxNum = CMaxTel5Num;
                                            WriteData(point);             
                                            AnsMD_timeOut=60;
                                       } 
                                       MDM_Reply_M=3;//Replay =OK  
                                 break; 
                                 case 110://write Tel6Num 
                                       for (point= location;point<(location+Qtty);point++){
                                            Pointer = Tel6Num;
                                            MaxNum = CMaxTel6Num;
                                            WriteData(point);                 
                                            AnsMD_timeOut=60;
                                       }
                                       MDM_Reply_M=3;//Replay =OK  
                                 break;  
                                 case 120://write NewNo  
                                       for (point= location;point<(location+Qtty);point++){
                                            Pointer = NewNo ;
                                            MaxNum = CMaxNewNo ;
                                            if(Qtty>1){ 
                                                Data[0]= (point)/100+0x30;
                                                End_Pnt= point%100;//get the left from deived  
                                                Data[1]= (End_Pnt)/10+0x30;
                                                Data[2]= (End_Pnt)%10+0x30;
                                            }                                             
                                            WriteData(point);     
                                            AnsMD_timeOut=60;
                                       } 
                                       MDM_Reply_M=3;//Replay =OK  
                                 break; 
                                 case 130://write OutPut  
                                       for (point= location;point<(location+Qtty);point++){
                                            Pointer = OutPut ;
                                            MaxNum = CMaxOutPut ; 
                                            if(Qtty>1){ 
                                                Data[0]= (point)/100+0x30;
                                                End_Pnt= point%100;//get the left from deived  
                                                Data[1]= (End_Pnt)/10+0x30;
                                                Data[2]= (End_Pnt)%10+0x30;
                                            }                                             
                                            WriteData(point);       
                                            AnsMD_timeOut=60;
                                       }
                                       MDM_Reply_M=3;//Replay =OK  
                                 break; 
                                 case 140://write Clock
                                                                             
                                       Days=tx_buffer1[2]&0xf;
                                       if (Days>0)Days--;
                                       if (Days>0x6)Days=0x6;
                                       Data[0]=Days;
                                       DataWritePCF(6,1,&Data[0]);//days
                                       Data[1]= tx_buffer1[3]&0xf;
                                       Data[2]= tx_buffer1[4]&0xf;
                                       Hours=(Data[1]<<4)+Data[2];
                                       if (Hours>0x23)Hours=0x23;
                                       Data[0]=Hours;
                                        DataWritePCF(4,1,&Data[0]);//hours
                                       Data[3]= tx_buffer1[5]&0xf;
                                       Data[4]= tx_buffer1[6]&0xf;
                                       Minutes=(Data[3]<<4)+Data[4];
                                       if (Minutes>0x59)Minutes=0x59;
                                       Data[0]=Minutes;
                                        DataWritePCF(3,1,&Data[0]);//min
                                       Data[0]=0;
                                        DataWritePCF(2,1,&Data[0]);//secounds                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                                       MDM_Reply_M=3;//Replay =OK                                        
                                 break;                                                                   
                            } 
                            // PC send R+ Type+Location ( R0101)
                            //replay OK+Qty + data 
                      }else if ((MDM_buffer[0]=='R')&&(!PassWordTstNeeded)){
                            MDM_Reply_M=0;  
                            type= (((MDM_buffer[1])&0xf)*16) +((MDM_buffer[2])&0xf);
                            location = (((MDM_buffer[3])&0xf)*16) +((MDM_buffer[4])&0xf);
                            //ADD here HEX test  and corect Data lenght  (short by one digit)
                            switch (type){ 
                                 case 1://read MasterCode 
                                      Qtty=1;
                                      Pointer = MasterCode;
                                      MaxNum = CMaxMasterCode;
                                      ReadData(1);
                                      MDM_Reply_M=4;//Replay =OK  
                                 break; 
                                 case 2://read TecUserCode 
                                      Qtty=1;                                
                                      Pointer = TecUserCode;
                                      MaxNum = CMaxTecUserCode;
                                      ReadData(1);
                                      MDM_Reply_M=4;//Replay =OK                                 
                                 break; 
                                 case 3://read Code 
                                      for (point=location;point <MaxCode;point++){
                                           Pointer = Code;
                                           MaxNum = CMaxCode;
                                           ReadData(point);
                                           if (point==location){ 
                                               strcpy (tx_buffer1,Data);
                                               Qtty=1;
                                           }else {
                                               if( strcmp(tx_buffer1,Data) == 0 )Qtty++;//if strings are compare 
                                               else  point=MaxCode+2; //fast exit                                           
                                           }
                                      }
                                      Pointer = Code;
                                      MaxNum = CMaxCode;
                                      ReadData(location);
                                      MDM_Reply_M=4;//Replay =OK  
                                 break;                                  
                                 case 4://read name  
                                      ///remove and replace                                 
                                      Qtty=1; 
                                      Pointer = Name;
                                      MaxNum = CMaxName;
                                      ReadData(location);
//                                      if (location==1)strcpyf(Data," HADAR     ");
//                                      else if (location==2)strcpyf(Data," ASAF      ");
//                                      else if (location==3)strcpyf(Data," ASAFA    "); 
                                      // end remove 
                                       for (point=location;point <=MaxName;point++){
                                            Pointer = Name;
                                            MaxNum = CMaxName;
                                            ReadData(point);
                                            if (point==location){ 
                                                strcpy (tx_buffer1,Data);
                                                Qtty=1;
                                            }else {
                                                if( strcmp(tx_buffer1,Data) == 0 )Qtty++;//if trings are compare 
                                                else  point=MaxName+2; //fast exit                                           
                                            }
                                       }
                                      MDM_Reply_M=4;//Replay =OK   
                                 break;  
                                 case 31://read name2  
                                      ///remove and replace                                 
                                      Qtty=1; 
                                      Pointer = Name;
                                      MaxNum = CMaxName;
                                      ReadData(location);
//                                      if (location==1)strcpyf(Data," HADAR     ");
//                                      else if (location==2)strcpyf(Data," ASAF      ");
//                                      else if (location==3)strcpyf(Data," ASAFA    "); 
                                      // end remove 
                                       for (point=location;point <=MaxName;point++){
                                            Pointer = Name;
                                            MaxNum = CMaxName;
                                            Class=1;
                                            ReadData(point); 
                                            Class=0;
                                            if (point==location){ 
                                                strcpy (tx_buffer1,Data);
                                                Qtty=1;
                                            }else {
                                                if( strcmp(tx_buffer1,Data) == 0 )Qtty++;//if trings are compare 
                                                else  point=MaxName+2; //fast exit                                           
                                            }
                                       }
                                      MDM_Reply_M=4;//Replay =OK   
                                 break;                                                                                                                                  
                                 case 14: //5://read OutPut
                                      for (point=location;point <=MaxOutPut;point++){
                                           Pointer = OutPut;
                                           MaxNum = CMaxOutPut;
                                           ReadData(point);                                            
                                           if (point==location){  // for first location transfer data to buffer1 
                                                Qtty=1; 
                                                if ((Data[2]==0x20)&&(Data[1]==0x20))
                                                     End_Pnt = (Data[0]&0x0f);
                                                else if (Data[2]==0x20)
                                                     End_Pnt = (Data[0]&0x0f)*10+ (Data[1]&0x0f);
                                                else End_Pnt = (Data[0]&0x0f)*100 + (Data[1]&0x0f)*10+ (Data[2]&0x0f); 
                                                if(End_Pnt != point )point=MaxOutPut+2; //fast exit (no auto fit mode)                                                  
                                           }else {  // calculate the Data point value- auto fit mode 
                                                if ((Data[2]==0x20)&&(Data[1]==0x20))
                                                     End_Pnt = (Data[0]&0x0f);
                                                else if (Data[2]==0x20)
                                                     End_Pnt = (Data[0]&0x0f)*10+ (Data[1]&0x0f);
                                                else End_Pnt = (Data[0]&0x0f)*100 + (Data[1]&0x0f)*10+ (Data[2]&0x0f);
 
                                                if(End_Pnt == point )Qtty++;//if points are compare                                                      
                                                else {
                                                     ReadData(point-1); 
                                                     point=MaxOutPut+2; //fast exit (send qty & last location-1)                                                         
                                                }
                                           }                                          
                                      }                                      
                                      MDM_Reply_M=4;//Replay =OK                                                                                                                                                                      
                                 break;                                 
                                 case 6://read TimeCycle 
                                      Qtty=1;                                
                                      Pointer = TimeCycle;
                                      MaxNum = CMaxTimeCycle;
                                      ReadData(location);
                                      MDM_Reply_M=4;//Replay =OK                                 
                                 break;                                 
                                 case 7://read ExtKeys
                                      Qtty=1;                                
                                      Pointer = ExtKeys;
                                      MaxNum = CMaxExtKeys;  //TBD
                                      ReadData(1);
                                      MDM_Reply_M=4;//Replay =OK                                                                        
                                 break;                                 
                                 case 8://read MasageOn
                                      Qtty=1;                                
                                      Pointer = MasageOn;
                                      MaxNum = CMaxMasageOn;  
                                      ReadData(location);
                                      if (Data[0]!='Y')strcpyf(Data,"0");//TBD 0 or " " or "N"   
                                      MDM_Reply_M=4;//Replay =OK      
                                 break;                                 
                                 case 9://read AnswerY_N
                                      Qtty=1;                                
                                      Pointer = AnswerY_N;
                                      MaxNum = CMaxAnswerY_N;  
                                      ReadData(location);
                                      if (Data[0]!='Y')strcpyf(Data,"0");//TBD 0 or " " or "N"   
                                      MDM_Reply_M=4;//Replay =OK                                                                        
                                 break;                                 
                                 case 10://read FloorValue
                                      for (point=location;point <MaxFloorValue;point++){
                                           Pointer = FloorValue;
                                           MaxNum = CMaxFloorValue;
                                           ReadData(point);
                                           if (point==location){ 
                                               strcpy (tx_buffer1,Data);
                                               Qtty=1;
                                           }else {
                                               if( strcmp(tx_buffer1,Data) == 0 )Qtty++;//if strings are compare 
                                               else  point=MaxCode+2; //fast exit                                           
                                           }
                                      }
                                      Pointer = FloorValue;
                                      MaxNum = CMaxFloorValue;
                                      ReadData(location);
                                      MDM_Reply_M=4;//Replay =OK                                                                    
                                 break;                           
                                 case 11://read RelayControl
                                      Qtty=1;                                
                                      Pointer = RelayControl;
                                      MaxNum = CMaxRelayControl;  
                                      ReadData(location);
                                      MDM_Reply_M=4;//Replay =OK                                                                                                                                         
                                 break;                                 
                                 case 12://read FASTstep
                                      Qtty=1;                                
                                      Pointer = FASTstep;
                                      MaxNum = CMaxFASTstep;  
                                      ReadData(1); 
                                      MDM_Reply_M=4;//Replay =OK                                                                         
                                 break; 
                                 case 13://Ofset (4 digit mode and offset)
                                      Qtty=1;                                
                                      Pointer = Ofset;
                                      MaxNum = CMaxOfset;  
                                      ReadData(1);  
                                      MDM_Reply_M=4;//Replay =OK                                                                        
                                break;                                    
                                case 5: // 14://NewNo
                                      for (point=location;point <=MaxNewNo;point++){
                                           Pointer = NewNo;
                                           MaxNum = CMaxNewNo;
                                           ReadData(point);                                            
                                           if (point==location){  // for first location transfer data to buffer1 
                                                Qtty=1; 
                                                if ((Data[2]==0x20)&&(Data[1]==0x20))
                                                     End_Pnt = (Data[0]&0x0f);
                                                else if (Data[2]==0x20)
                                                     End_Pnt = (Data[0]&0x0f)*10+ (Data[1]&0x0f);
                                                else End_Pnt = (Data[0]&0x0f)*100 + (Data[1]&0x0f)*10+ (Data[2]&0x0f); 
                                                if(End_Pnt != point )point=MaxNewNo+2; //fast exit (no auto fit mode)                                                  
                                           }else {  // calculate the Data point value- auto fit mode 
                                                if ((Data[2]==0x20)&&(Data[1]==0x20))
                                                     End_Pnt = (Data[0]&0x0f);
                                                else if (Data[2]==0x20)
                                                     End_Pnt = (Data[0]&0x0f)*10+ (Data[1]&0x0f);
                                                else End_Pnt = (Data[0]&0x0f)*100 + (Data[1]&0x0f)*10+ (Data[2]&0x0f);
 
                                                if(End_Pnt == point )Qtty++;//if points are compare                                                      
                                                else {
                                                     ReadData(point-1); 
                                                     point=MaxNewNo+2; //fast exit (send qty & last location-1)                                                         
                                                }
                                           }                                          
                                      }                                      
                                      MDM_Reply_M=4;//Replay =OK                                 
                                 break;
                                 case 15://CommSpd
                                      Qtty=1;                                
                                      Pointer = CommSpd;
                                      MaxNum = CMaxCommSpd;  
                                      ReadData(1); 
                                      MDM_Reply_M=4;//Replay =OK                                                                         
                                 break;                                                                                                
                                 case 16://Tel1Num 
                                      for (point=location;point <MaxTel1Num;point++){
                                           Pointer = Tel1Num;
                                           MaxNum = CMaxTel1Num;
                                           ReadData(point);
                                           if (point==location){ 
                                               strcpy (tx_buffer1,Data);
                                               Qtty=1;
                                           }else {
                                               if( strcmp(tx_buffer1,Data) == 0 )Qtty++;//if strings are compare 
                                               else  point=MaxTel1Num+2; //fast exit                                           
                                           }
                                      }
                                      Pointer = Tel1Num;
                                      MaxNum = CMaxTel1Num;
                                      ReadData(location);
                                      MDM_Reply_M=4;//Replay =OK                             break;              
                                 break;                                         
                                 case 17://Tel2Num
                                      for (point=location;point <MaxTel2Num;point++){
                                           Pointer = Tel2Num;
                                           MaxNum = CMaxTel2Num;
                                           ReadData(point);
                                           if (point==location){ 
                                               strcpy (tx_buffer1,Data);
                                               Qtty=1;
                                           }else {
                                               if( strcmp(tx_buffer1,Data) == 0 )Qtty++;//if strings are compare 
                                               else  point=MaxTel2Num+2; //fast exit                                           
                                           }
                                      }
                                      Pointer = Tel2Num;
                                      MaxNum = CMaxTel2Num;
                                      ReadData(location);
                                      MDM_Reply_M=4;//Replay =OK                             break;              
                                 break;              
                                 case 18://Tel3Num
                                     for (point=location;point <MaxTel3Num;point++){
                                           Pointer = Tel3Num;
                                           MaxNum = CMaxTel3Num;
                                           ReadData(point);
                                           if (point==location){ 
                                               strcpy (tx_buffer1,Data);
                                               Qtty=1;
                                           }else {
                                               if( strcmp(tx_buffer1,Data) == 0 )Qtty++;//if strings are compare 
                                               else  point=MaxTel3Num+2; //fast exit                                           
                                           }
                                      }
                                      Pointer = Tel3Num;
                                      MaxNum = CMaxTel3Num;
                                      ReadData(location);
                                      MDM_Reply_M=4;//Replay =OK                  
                                 break;              
                                 case 19://Tel4Num
                                        for (point=location;point <MaxTel4Num;point++){
                                           Pointer = Tel4Num;
                                           MaxNum = CMaxTel4Num;
                                           ReadData(point);
                                           if (point==location){ 
                                               strcpy (tx_buffer1,Data);
                                               Qtty=1;
                                           }else {
                                               if( strcmp(tx_buffer1,Data) == 0 )Qtty++;//if strings are compare 
                                               else  point=MaxTel4Num+2; //fast exit                                           
                                           }
                                      }
                                      Pointer = Tel4Num;
                                      MaxNum = CMaxTel4Num;
                                      ReadData(location);
                                      MDM_Reply_M=4;//Replay =OK   
                                 break;              
                                 case 20://Tel5Num
                                        for (point=location;point <MaxTel5Num;point++){
                                           Pointer = Tel5Num;
                                           MaxNum = CMaxTel5Num;
                                           ReadData(point);
                                           if (point==location){ 
                                               strcpy (tx_buffer1,Data);
                                               Qtty=1;
                                           }else {
                                               if( strcmp(tx_buffer1,Data) == 0 )Qtty++;//if strings are compare 
                                               else  point=MaxTel5Num+2; //fast exit                                           
                                           }
                                      }
                                      Pointer = Tel5Num;
                                      MaxNum = CMaxTel5Num;
                                      ReadData(location);
                                      MDM_Reply_M=4;//Replay =OK   
                                 break;              
                                 case 21://Tel6Num
                                        for (point=location;point <MaxTel6Num;point++){
                                           Pointer = Tel6Num;
                                           MaxNum = CMaxTel6Num;
                                           ReadData(point);
                                           if (point==location){ 
                                               strcpy (tx_buffer1,Data);
                                               Qtty=1;
                                           }else {
                                               if( strcmp(tx_buffer1,Data) == 0 )Qtty++;//if strings are compare 
                                               else  point=MaxTel6Num+2; //fast exit                                           
                                           }
                                      }
                                      Pointer = Tel6Num;
                                      MaxNum = CMaxTel6Num;
                                      ReadData(location);
                                      MDM_Reply_M=4;//Replay =OK   
                                 break;              
                                 case 22://RingingNum
                                      Qtty=1;                                
                                      Pointer = RingingNum;
                                      MaxNum = CMaxRingingNum;  
                                      ReadData(1);  
                                      MDM_Reply_M=4;//Replay =OK                                                                        
                                 break;              
                                 case 23://BusySogTone
                                      Qtty=1;                                
                                      Pointer = BusySogTone;
                                      MaxNum = CMaxBusySogTone;  
                                      ReadData(location); 
                                      MDM_Reply_M=4;//Replay =OK                                                                         
                                 break;              
                                 case 24://ToneCodes
                                      Qtty=1;                                
                                      Pointer = ToneCodes;
                                      MaxNum = CMaxToneCodes;  
                                      ReadData(1);
                                      MDM_Reply_M=4;//Replay =OK                                                                          
                                 break; 
                                 case 25://ConfirmTone
                                      Qtty=1;                                
                                      Pointer = OutPut;
                                      MaxNum = CMaxOutPut;  
                                      ReadData(1);
                                      strcpyf(Data,"3"); 
                                      MDM_Reply_M=4;//Replay =OK                                                                         
                                 break;              
                                 case 26://SetReadTimer
                                      Qtty=1;                                
                                      Pointer = SetReadTimer;
                                      MaxNum = CMaxSetReadTimer;  
                                      ReadData(location); 
                                      End_Pnt= strlen(Data);
                                      if (End_Pnt<7){ //TBD not working 
                                           for (point=End_Pnt;point>=7;point++){
                                                Data [5] = 0x20;  //exrend string 
                                           }
                                           Data [7]=0;//put end sign 
                                      }
                                      MDM_Reply_M=4;//Replay =OK                                                                         
                                 break;              
                                 case 27://FamilyNo
                                      Qtty=1;                                
                                      Pointer = FamilyNo;
                                      MaxNum = CMaxFamilyNo;  
                                      ReadData(1); 
                                      MDM_Reply_M=4;//Replay =OK                                                                         
                                 break;   
                                 case 28://SpeechLevel   
                                      Qtty=1;                                
                                      Pointer = SpeechLevel;
                                      MaxNum = CMaxSpeechLevel;  
                                      ReadData(1); 
                                      MDM_Reply_M=4;//Replay =OK                                                                         
                                 break;  
                                                                 
                                 ///  time display         
                                 case 30://ReadTime
                                      Qtty=1;  
                                      Data [0]= 0x30+(Days&0xf);//days  
                                      Data [1]=0x30+((Hours&0xf0)>>4);
                                      Data [2]=0x30+(Hours&0xf);
                                      Data[3]=0x30+((Minutes&0xf0)>>4);
                                      Data[4]=0x30+(Minutes&0xf);
                                      Data[6]=0x30+((Secounds&0xf0)>>4);
                                      Data[7]=0x30+(Secounds&0xf);          
                                      MDM_Reply_M=4;//Replay =OK                                                                          
                                 break;
             
                            }
                      }
                      if (MDM_Reply_M==0){
                           tx_buffer1[0]='E'; //master code error 
                           tx_buffer1[1]='R';  
                           tx_buffer1[2]='e';
                           tx_buffer1[3]='r';                                                                                                                                                                                                
                           tx_buffer1[4]=13;
                           tx_buffer1[5]=0;                       
                           tx_rd_index1=0;
                           UDR1=tx_buffer1[0]; 
                      }
                      else if (MDM_Reply_M==2){
                           tx_buffer1[0]=MDM_buffer[0]; 
                           tx_buffer1[1]=PassWordTstNeeded+0x30;  
                           tx_buffer1[2]='e';
                           tx_buffer1[3]='r';                                                                                                                                                                                                
                           tx_buffer1[4]=13;
                           tx_buffer1[5]=0;                       
                           tx_rd_index1=0;
                           UDR1=tx_buffer1[0];
                      } 
                      else if (MDM_Reply_M==3){
                           tx_buffer1[0]='O';  //master code send from pc = ok 
                           tx_buffer1[1]='K';  
                           tx_buffer1[2]='o';
                           tx_buffer1[3]='k';                                                                                                                                                                                                
                           tx_buffer1[4]=13;
                           tx_buffer1[5]=0;                       
                           tx_rd_index1=0;
                           UDR1=tx_buffer1[0]; 
                      }                                                                            
                      else if (MDM_Reply_M==4)//for receive from PC mode only 
                      { 
                           tx_buffer1[0]='o';  //Repaly ok  +Data Qtty 
                           tx_buffer1[1]='k';  
                           tx_buffer1[2]=((Qtty&0xf0)>>4)+0x30;
                           tx_buffer1[3]=(Qtty&0xf)+0x30; 
                                                                                                                                                                                     
                           End_Pnt=0;                          
 
                           for (point=0;point<MaxNum;point++)
                           { 
                                if (Data[point]==0){ //on end of string sign 
                                     point=MaxNum+1;//exit 
                                }
                                else {  //arrange Data after 4 char massage (OKok or ok+XX)
                                     tx_buffer1[End_Pnt+4]=((Data[point]&0xf0)>>4)+0x30;
                                     End_Pnt++;
                                     tx_buffer1[End_Pnt+4]=(Data[point]&0xf)+0x30; 
                                     End_Pnt++;
                                }
                           }
                           //ADD here HEX value and send as number (0x30-0x3f)
                           tx_buffer1[End_Pnt+4]=0;//put new end sign 
                           ValueChecsum=0; //calculate check sum 
                           for(point=0;point< strlen (tx_buffer1);point++)
                           {
                                ValueChecsum +=tx_buffer1[point];
                           }
                           tx_buffer1[point]= ((ValueChecsum&0xf0)>>4)+0x30;
                           tx_buffer1[point+1]= (ValueChecsum&0xf)+0x30;                                                                                                                                                                               
                           tx_buffer1[point+2]=13;
                           tx_buffer1[point+3]=0;                       
                           tx_rd_index1=0;  //send data until end sign 
                           UDR1=tx_buffer1[0]; 
                      }
                      
                 }else{   
                           if ((MDM_buffer[0]=='T')&&(MDM_buffer[1]=='I')&&(MDM_buffer[2]=='M')&&(MDM_buffer[3]=='t')
                                                                       &&(MDM_buffer[4]=='i')&&(MDM_buffer[5]=='m'))
                           { 
                                tx_buffer1[0]='T'; //check sum error 
                                tx_buffer1[1]='M';  
                                tx_buffer1[2]='t';
                                tx_buffer1[3]='m';                                                                                                                                                                                                
                                tx_buffer1[4]=13;
                                tx_buffer1[5]=0;                       
                                tx_rd_index1=0;
                                UDR1=tx_buffer1[0]; 
                                EndAnsMD_timeOut=1;
                           }else { 
              
//RECEIVED PLS CS SEND BACK                                  
//                                  for (Point=0; Point<= (MDM_index-1) ; Point++)
//                                  {
//                                       tx_buffer1[Point]= MDM_buffer[Point]; ;
//                                  }            
//                                 tx_buffer1[0]=MDM_buffer[0]; //check sum error 
//                                 tx_buffer1[1]=MDM_buffer[1];  
//                                 tx_buffer1[2]=((ValueChecsum >> 4)&0xf)+0x30;
//                                 tx_buffer1[3]=((ValueChecsum )&0xf)+0x30;   
//                                 tx_buffer1[4]= MDM_buffer [MDM_index-2];// 
//                                 tx_buffer1[5]= MDM_buffer [MDM_index-1]; 
//                                 tx_buffer1[6]= (((MDM_index-3)>> 4)&0xf)+0x30; 
//                                 tx_buffer1[7]= (MDM_index-3)&0xf+0x30;  
//                                 ValueChecsum*=16;
//                                 ValueChecsum +=MDM_buffer [MDM_index-1];
//                                 
//                                 End_Pnt= ((MDM_buffer [MDM_index-2])*16)+MDM_buffer [MDM_index-1];
//                                 tx_buffer1[MDM_index]=((ValueChecsum&0xf0)>>4)+0x30;//((MDM_index>>4)&0xf)+0x30;
//                                 tx_buffer1[MDM_index+1]=(ValueChecsum&0xf)+0x30;//(MDM_index&0xf)+0x30; 
//                                 tx_buffer1[MDM_index+2]=ValueChecsum/100+0x30;
//                                 tx_buffer1[MDM_index+3]=(ValueChecsum%100)/10+0x30; 
//                                 tx_buffer1[MDM_index+4]=(ValueChecsum%100)%10+0x30; 
//                                 tx_buffer1[MDM_index+5]=a/100+0x30;
//                                 tx_buffer1[MDM_index+6]=(a%100)/10+0x30; 
//                                 tx_buffer1[MDM_index+7]=(a%100)%10+0x30;                                 
//                                 
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
//                                 tx_buffer1[MDM_index+8]=13;
//                                 tx_buffer1[MDM_index+9]=0;

// CS SEND     
                                tx_buffer1[0]='C'; //check sum error 
                                tx_buffer1[1]='S';  
                                tx_buffer1[2]='c';
                                tx_buffer1[3]='s';  
                                                                                                                                                                                                                    
                                tx_buffer1[4]=13;
                                tx_buffer1[5]=0; 

                                                                       
                                tx_rd_index1=0;
                                UDR1=tx_buffer1[0]; 
                           }
                 } 
                 
            }
            else {                
                MDM_buffer[MDM_index]=data;
                if (MDM_index<80)MDM_index++;
           }
}


if (!MDM_Reply_Mode){
   if (((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0))
   {
    		 ReceivedData=data;
                 rx_buffer1[rx_wr_index1]=data;
                 rx_wr_index1++;
                 if(rx_wr_index1 >= RX_BUFFER_SIZE1)
                       rx_wr_index1 = 0;
   };
}

#asm
    pop  r26
    out  sreg,r26
    pop  r31
    pop  r30
    pop  r27
    pop  r26
#endasm
}


interrupt [USART1_TXC] void uart1_tx_isr(void)
{
#asm
    push r26
    push r27
    push r30
    push r31
    in   r26,sreg
    push r26
#endasm            
                   tx_rd_index1++;
                   if(!tx_buffer1[tx_rd_index1])
                   {
                       tx_rd_index1 = 0; 
                   }
                   else{ 
                       UDR1=tx_buffer1[tx_rd_index1];// 
                   }

#asm
    pop  r26
    out  sreg,r26
    pop  r31
    pop  r30
    pop  r27
    pop  r26
#endasm
}



interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{


       TIMSK&= ~0x01;      // disable timeout
       WasReceiving = 1;
       Checsum = 0;

}
interrupt [TIM2_COMP] void timer2_comp_isr(void)
{
    unsigned char i;
     MainCycle = 1;
     SirenWith+= ChangeSiren;  
     
   

     if(DelayBetweenTone)DelayBetweenTone--;
   /*  if (TimeRplaceVolumeCnt){
       	  TimeRplaceVolumeCnt--;
          if(!TimeRplaceVolumeCnt){
          	    DecideVolumeFlag=1;
          	    TimeRplaceVolumeCnt=200;
          }
     }*/
     if(TimeReset) TimeReset--;
     if(Busy1) Busy1--;
     if(FlagTestButton) FlagTestButton--;
     if(CounterSound){
             CounterSound--;
             if(!CounterSound) Siren_Stop();
     }
     ConterPauseRing--;
     if(ConterPauseRing ==1){
        ConterPauseRing = 0;
        if(CounterRing){
               if (!(MessageOnOff &0x40))Siren_Start(5); // do not ring during RING message ON
        }
     }
     MDM_oneSecCnt++;
     if (MDM_oneSecCnt >=250){
          MDM_oneSecCnt -=250; 

          if (Show_Clock)Show_Clock--;// 
          MDM_oneSec=1;
          One_Min++;
          if ((PowerFail)&&((One_Min&0x7)==0)&&(YesNoAnswer2&0x4))Siren_Start(7);   //Clock set need sign
          if (One_Min>=60){
               One_Min=0;
               Time_Up();
               if (((Days==1)&&(Timer1D&0x1))||((Days==2)&&(Timer1D&0x2))||((Days==3)&&(Timer1D&0x4))||((Days==4)&&(Timer1D&0x8))
                                ||((Days==5)&&(Timer1D&0x10))||((Days==6)&&(Timer1D&0x20))||((Days==7)&&(Timer1D&0x40))) {
                    if ((Timer1SH==Hours)&&(Timer1SM==Minutes)){
                                              TimerStatus |=0x80;// put save need on
                                              TimerStatus |=0x1; //put Dial timer on
                    }
                    if ((Timer1PH==Hours)&&(Timer1PM==Minutes)){
                                              TimerStatus |=0x80;// put save need on
                                              TimerStatus &=~0x1; //put Dial timer off
                    }
               }
               if (((Days==1)&&(Timer2D&0x1))||((Days==2)&&(Timer2D&0x2))||((Days==3)&&(Timer2D&0x4))||((Days==4)&&(Timer2D&0x8))
                                ||((Days==5)&&(Timer2D&0x10))||((Days==6)&&(Timer2D&0x20))||((Days==7)&&(Timer2D&0x40))) {
                    if ((Timer2SH==Hours)&&(Timer2SM==Minutes)){
                                              TimerStatus |=0x80;// put save need on
                                              TimerStatus |=0x1; //put Dial timer on
                    }
                    if ((Timer2PH==Hours)&&(Timer2PM==Minutes)){
                                              TimerStatus |=0x80;// put save need on
                                              TimerStatus &=~0x1; //put Dial timer off
                    }
               }
               if (((Days==1)&&(Timer3D&0x1))||((Days==2)&&(Timer3D&0x2))||((Days==3)&&(Timer3D&0x4))||((Days==4)&&(Timer3D&0x8))
                                ||((Days==5)&&(Timer3D&0x10))||((Days==6)&&(Timer3D&0x20))||((Days==7)&&(Timer3D&0x40))) {
                    if ((Timer3SH==Hours)&&(Timer3SM==Minutes)){
                                              TimerStatus |=0x80;// put save need on
                                              TimerStatus |=0x2; //put RLY1 timer on
                                              OpenDoorRelay();  //hold relay 1
                    }
                    if ((Timer3PH==Hours)&&(Timer3PM==Minutes)){
                                              TimerStatus |=0x80;// put save need on
                                              TimerStatus &=~0x2; //put RLY1 timer off
                                              CloseDoorRelay();  //reales  relay 1
                    }
               }
               if (((Days==1)&&(Timer4D&0x1))||((Days==2)&&(Timer4D&0x2))||((Days==3)&&(Timer4D&0x4))||((Days==4)&&(Timer4D&0x8))
                                ||((Days==5)&&(Timer4D&0x10))||((Days==6)&&(Timer4D&0x20))||((Days==7)&&(Timer4D&0x40))) {
                    if ((Timer4SH==Hours)&&(Timer4SM==Minutes)){
                                              TimerStatus |=0x80;// put save need on
                                              TimerStatus |=0x4; //put RLY2 timer on
                                              OpenDoorRelay2();  //hold relay 2
                    }
                    if ((Timer4PH==Hours)&&(Timer4PM==Minutes)){
                                              TimerStatus |=0x80;// put save need on
                                              TimerStatus &=~0x4; //put RLY2 timer off
                                              CloseDoorRelay2();  //reales  relay 2
                    }
               }

               if ( TimerStatus&0x80){
                      TimerStatus &=~0x80;// put save needed value
                      Pointer = SaveTimerSta;
                      MaxNum = CMaxSaveTimerSta;
                      Data[0]= 0x30+TimerStatus;
                      WriteData(1);
               }
          }
     }

     SpeechOneSec++;
     if (SpeechOneSec >= 250){
         SpeechOneSec -= 250;  

         if (Dsp_Connect_T)Dsp_Connect_T++;//Speech time 
         
         if(TimeConectedWithApp){
               TimeConectedWithApp--; 
               Rst_LCD=0;
               if(!TimeConectedWithApp){ 
                    Dsp_Connect_T=0;//Speech time   // Next_Ring - No Camera time
                    OpenDoorTestCNT=0; //FIXing stack problem 
                    ConfimTstT_CNT=0; //FIXing stack problem  
                    BusyTstTO_Timer=0;//FIXing stack problem  
                   //RR+ PORTD &=~0x40; //Relase Camera Relay  // Next_Ring - No Camera time    
                    AMP_ON_OFF &=~0x1;// AMP OFF (0 = amp 1 buzzer 2 voice ) 
                    ReliseLine();
                    CounterRing=0;  
                    if (NextDailMode==2){ 
                            if (MessageOnOff &0x40){ 
                                    NextDailMode=8;// entrer to TO on dialing
                                    Voice_Sug =165;// RE ringing now 
                            }else NextDailMode=6;// entrer to TO on dialing 
                    }
                    else NextDailMode=0;   //end of Dialing mode
                    if (AddedType>=5)NextDailMode=0;   //end of Dialing mode
               }
         }
         if (BusyTstTO_Timer)BusyTstTO_Timer--;//busy test time out
         if (OpenDoorTestCNT){
               OpenDoorTestCNT--;
               if (OpenDoorTestCNT==1){
                     TelNotConfirm=1;
                     OpenDoorTestCNT=0;
               }  
         }
    
         if (ConfimTstT_CNT){
              ConfimTstT_CNT--; 
              if (ConfimTstT_CNT==1){
                   TelNotConfirm=1;
                   ConfimTstT_CNT=0;  
 
              }
         }
         if (NextDailMode>3){
              NextDailMode--;
              if (NextDailMode==4){ //at end
                   NextDailMode=1;
                   CounterRing = RingTime;         //MMM
                   Reset=0;  
//                   if (MessageOnOff &0x40){ 
////                         Voice_Sug =165;// RE ringing now 
//                           Message_End=15;
//                   }
                 //  No_Floor_Mess=1;                   
                   NeetToDialFlge=1;
                   NamePointer=RedialThis; 
                   if (DialingTo< 2){
                         Show_NextDial=1; //REDIAL 3 
                         if (TimerStatus&0x1){
                              Pointer = Tel6Num;
                              MaxNum = CMaxTel6Num;
                         }else {
                              Pointer = Tel3Num;
                              MaxNum = CMaxTel3Num;
                         }
                         ReadData(RedialThis); 

                         if((Data[0]>=0x23)&&(Data[0]<=0x66)){                   
                                 if (SpeechTime)ConfimTstT_CNT= SpeechTime;//only if Confirm time exsist test needed 
                                 if (RedialTime)OpenDoorTestCNT=RedialTime+RingTime; //Move Next Phone if door not oppen 
                                 if (SpeechTime)BusyTstTO_Timer=SpeechTime;//set the tets time value
                         }else{
                                 if (SpeechTime)ConfimTstT_CNT= SpeechTime;//see//MUST BE -10//only if Confirm time exsist test needed 
                                 if (RedialTime)OpenDoorTestCNT=SpeechTime; //Move Next Phone if door not oppen 
                                 if (SpeechTime)BusyTstTO_Timer=SpeechTime;//set the tets time value 
                                 NextDailMode=1; //stop dial
                          }                       
                   }                   
                   CallCnt=0; 
                   CallSign=0;    
                   QuitCallDet=0;
                   FreqCallDet=0;  
                   PC7Cnt=0; 
                   TimeConectedWithApp=SpeechTime;//was 60;  //FIX MENU // Next_Ring - No Camera time 
                   SpeechOneSec=0;
              }
         }
         if(ShuntMicTime){
              ShuntMicTime--;
              if (!ShuntMicTime){
                   ToneDigCNT=2;
                   RecToneKey[0]=0;
                   RecToneKey[1]=0;
              }
         }
         if(TimeOutReset)TimeOutReset--;
     }
     CounterSecond++;
     CounterRlySecond++;
     if(CounterRlySecond >= 300){   //
           CounterRlySecond-= 300;
           FlagOneSec = 1;
     }
     PrySecCnt++;
     if (PrySecCnt>=62){
          PrySecCnt=0;
          FlagPrySec=1;
          
          if (DoNotDisp_AppNo)DoNotDisp_AppNo--;//FIX6
          if (WaitDisplay)WaitDisplay--; 
          if (WaitForExit){ //FIX2B
               WaitForExit--;
               if ( WaitForExit==100){
                    WaitForExit=0;
                    StartToArm();//fix fast exit pressing 
               }
          }//FIX2B                    

          if (DisplaySelected){
               DisplaySelected--;
               if (!DisplaySelected){
                     RealTime[4] = 1;
                     NamePointer = 0;//add
                     ListName = 0; //add    //MMM
                     AllRdyShow=0;
                     //ListName=0; //FIX4
                     //AppCntCode=0; //FIX4 
                     MemAppCntCode=0;//FIX1   
                     AppCode[3]=0;//0402                                                                            
               }
          }
          if (DisplayNameList){
               DisplayNameList--;
               if (!DisplayNameList){
                         RealTime[4] = 1;
                         NamePointer = 0;//add
                         ListName = 0; //add    //MMM
                         AllRdyShow=0;
                         ListName=0; 
                         AppCntCode=0;
                         Dial_This=0;                                                     
               }
          } 
//           if(AppClearTO){
//               AppClearTO--;
//               if (!AppClearTO){
//               }
//           }          
          if(AppDisplayTO){
                AppDisplayTO--;
                if (!AppDisplayTO){                         
//                      AppClearTO=ClearSelect+1;//14=  3.5  Sec Code time out
                        DisplaySelected=ClearSelect+1;//14=  3.5  Sec Code time out 
                }
          }
          if (AcssesCodeTO){
               AcssesCodeTO--;
               if (!AcssesCodeTO){
                   CountCode = 0;
               }
          }

          if (NameMesCnt){
                NameMesCnt--;
                if (!NameMesCnt){
                     Voice_Sug=(ListName/4)+1;
                }
          }

          if (WelcomeCounter){
               WelcomeCounter--;
               if (!WelcomeCounter){
                        Voice_Sug=142;//welcome message no 0000.ad4 need
               }
          }
          if (MAGCounter){
               MAGCounter--;
               if (!MAGCounter){
                    if (!Status){
                         MAGCounter=250;
                         Voice_Sug=144;
                    }
               }
               if ((MAGCounter==120)&&(!Status)){
                    MAGPin=0;
                    MAGCounter=0;
                    Voice_Sug=144; //please close the door
               }
          }
     }
    if(CounterSecond >= 250){   //  one second 
            CounterSecond-= 250;
          //Flag2Second=1;//^= 1;
          //FlagOneSec = 1;
          if (PxyCodeCnt)PxyCodeCnt--;//prxy time out
          if (Status){//in program mode clear counters any way
               MAGCounter=0;
               WelcomeCounter=0;
               FloorMesCnt=0;
               NameMesCnt=0;
          }
        //  TimeTestSystem++;
          if(CounterRing){
                CounterRing--;
                Rst_LCD=0;
                //if(Flag2Second) Siren_Start(5);
                if(!CounterRing){
                         Dsp_Connect_T=1;//Speech time 
                         RelayOff();
                         RealTime[4] = 1;
                         NamePointer = 0;//add
                         ListName = 0; //add    //MMM
                         AllRdyShow=0;
                         ListName=0;
                }
          }
          if(TimeMenu) TimeMenu--;
          if(CounterLight && (CounterLight < 99)){
               CounterLight--;
               if(!CounterLight){
                    if (!Status)PORTC &=~0x1;  //Status Light
               }
          }
          if(CounterWait){
                    CounterWait--;
                    Siren_Start(4); 
                    Rst_LCD=0;
                    //RealTime[3] = AllBords;
                    //Beap = 4;
          }
          if(CounterWait2){
                    CounterWait2--;
                    Siren_Start(4); 
                    Rst_LCD=0;
                    //RealTime[3] = AllBords;
                    //Beap = 4;
          }
          if(CounterOpenDoor){
                    CounterOpenDoor--;
                    Wait_DoorOpen_Now=250;
                    if ((YesNoAnswer2 &0x10)&&(CounterOpenDoor))Siren_Start(3);//FIX1 
                    if (!CounterOpenDoor){
                           if ((MessageOnOff &0x4)) {
                                 Close_Door_TO=6;//test door open one time after end of opening
                                 if ((MessageOnOff &0x2)&&(!No_Floor_Mess))FloorMesCnt=FloorTime+1;
                           }else if ((MessageOnOff &0x2)&&(!No_Floor_Mess))FloorMesCnt=FloorTime;  
                    }                      
                    //RealTime[3] = AllBords;
                    //Beap = 3;
                    Rst_LCD=0;
          }
          if (NoConstantOpen)NoConstantOpen--;//FIX1 
          if(CounterOpenDoor2){
                    CounterOpenDoor2--;  
                    Wait_DoorOpen_Now=250;
                    if ((YesNoAnswer2 &0x10)&&(CounterOpenDoor2)) Siren_Start(3);//FIX1
                    if (!CounterOpenDoor2){
                            if ((MessageOnOff &0x4)){
                                    Close_Door_TO=6;//test door open one time after end of opening
                                    if ((MessageOnOff &0x2)&&(!No_Floor_Mess))FloorMesCnt=FloorTime+1;  
                            }else if ((MessageOnOff &0x2)&&(!No_Floor_Mess))FloorMesCnt=FloorTime;  
                    }                      
                    //RealTime[3] = AllBords;
                    //Beap = 3;
                    Rst_LCD=0;
          }
      /*    if(PauseButton){
              PauseButton--;
              if(!PauseButton)  {
              //Asaf
              //if(Status == 0) AcssesCode=0;
              //Asaf
              PauseButtonFlag = 1;
              }
          } */
     }

     CountCanSend++;
     TimeChangeWord++;



     if(CycleArm0)CycleArm0--;
     if(CycleArm1)CycleArm1--;
     if(CycleArm2)CycleArm2--;
     if(CycleArm3)CycleArm3--;

}


void TestAnswerFromElement(void)
{
            RealTime[Tor]&= ~(0x01<<IndexBord);
            if(Tor == 0)
            {
                      AllBords|= GetBit(IndexBord);
                      if(MaxBord < IndexBord)
                                MaxBord = IndexBord;
            }else
            if(Tor == 9)     // get status
            {
            	       if (rx_buffer0[6])RealTime[7] = 1;//get code (enter was press)

                       if (rx_buffer0[5]>100){
                           if ((BuferSlaveStatus[IndexBord])==0x81){
               	                RelayOn( ReturnNamePointer(rx_buffer0[5]-100));
               	           }else
               	                RelayOn(rx_buffer0[5]-100); //hold remote relay
            	      }else
            	           if (rx_buffer0[5])RelayOff(); //realese remote relay

                       if(BuferSlavePointer[IndexBord] != rx_buffer0[4]){
                             BuferSlavePointer[IndexBord] = rx_buffer0[4];
                             if(BuferSlavePointer[IndexBord])
                                   RealTime[6]|= (0x01<<IndexBord);
                             else
                                   RealTime[4] = 1;
                       }
                       if(BuferSlaveStatus[IndexBord] != rx_buffer0[3]){
                             BuferSlaveStatus[IndexBord] = rx_buffer0[3];
                             if(BuferSlavePointer[IndexBord])
                                   RealTime[6]|= (0x01<<IndexBord);
                             else
                                   RealTime[4] = 1;
                       }
                       if(rx_buffer0[2] & 0x01)
                                 StatusGet|= GetBit(IndexBord);
                       if(rx_buffer0[2] & 0x80)
                                 RealTime[1]|= GetBit(IndexBord);

                                //   Tor = 0;
                       if(SendedToAll)    // if sended to all
                                  if(IndexBord>=MaxBord)
                                          if((StatusGet == AllBords)||(RCountTry>=3))
                                          {
                                              SendedToAll = 0;
                                              RCountTry = 0;
                                              RealTime[5] = AllBords;
                                              NumBit = 0x01;

                                           }
                                           else
                                           {
                                              RCountTry++;
                                              RealTime[4] = 1;
                                           }
            }else
            if(Tor == 1)     // get key
            {
                       Button = rx_buffer0[3];
                       ButtonMenu();
                       RealTime[4] = 1;
                       if(Status) TimeMenu = 180;
            }else
            if(Tor == 8)        // difolt
            {
                       rx_buffer0[18] = 0;
                       strcpy(Data,&rx_buffer0[3]);
                       Data[15] = 0x20;
                       ChangeWord = Data[0];
            }else
            if(Tor == 7)        // get code
            {
            		CountCode2=(rx_buffer0[13]);
            		CodeTest2 = TestRemoteCode();
                        if  (CodeTest2==1) HoldRemoteRly=1;;
                        if  ((CodeTest2==0)||(CodeTest2>1)) HoldRemoteRly=99;//Error code
                       // userTechCodeif  (CodeTest2==2) Siren_Start(2);
                       //master code if  (CodeTest2==3) Siren_Start(3);

            }
}
void ClearRealTime(void)
{
     char i;
     for(i = 0;i<13;i++)
        RealTime[i] = 0;
}

void StartEE(void)
{
 char i, Status,KeepNameFlag;
 int Wait,Wait2; 
// unsigned int t;
      Status = 1; //FIX7 start
      Pointer = KeepName;
      MaxNum =  CMaxKeepName;
      ReadData(1);
      if (Data[0]=='5')KeepNameFlag=1;
      else KeepNameFlag=0;
      if (!(KeepNameFlag)){
           for(i=0;i<10;i++){ 
               if(PING & 0x10) return;                     
               if(PING & 0x8){
                    Pointer = PRG_Was_Done;//FIX7 start
                    MaxNum =  CMaxPRG_Was_Done;
                    ReadData(1);  //PRG SHOW  
                    if (Data[0]=='%'){  
                        for (Wait=0;Wait<50000;Wait++){                              
                             for (Wait2=0;Wait2<50;Wait2++){ 
                                  #asm("nop"); 
                                  #asm("WDR");
                             }
                        }                  

                        PORTE &=~0x4;//ENALBLE EE WRITE                                              
                        strcpyf(Data,"0");
                        WriteData(1);  //PRG SHOW 
                        PORTE |=0x4;//DISALBLE EE WRITE                         
                    }
                    return;                      
             } 
               //if(!(PIND&0x40)) Status = 0;
               #asm("nop");
           }
      } //FIX7 end 
       if (!(KeepNameFlag)){ //Factory reset 
              PORTF &=~0x10;//RR++ 
              Voice_End=5;  
              Pointer = PRG_Was_Done;//FIX7 start
              MaxNum =  CMaxPRG_Was_Done;
              ReadData(1);  //PRG SHOW 
              for (MSB_value=4;MSB_value<=68;MSB_value++){ 
                      tx_buffer0[MSB_value]=0x20;
              } 
              if (Data[0]=='%'){  
                     strcpyf(tx_buffer0,"          PRG");
                     SendToLCD(&tx_buffer0[4],&tx_buffer0[20],&tx_buffer0[36],&tx_buffer0[52]);  //MMM                                          
                     while(1){
                             #asm("WDR")
                             PORTG &=~0x2;// Blanck the led  
                             PORTC |=0x1;//Ligt Back Light   
                     }                
              }
              else {  
                     strcpyf(tx_buffer0,"     Factory Reset   Please Wait");                                                                                                     
              } 

      }else {//Name/Tel Stay
              for (MSB_value=4;MSB_value<=68;MSB_value++){ 
                   tx_buffer0[MSB_value]=0x20;  
              }   
                strcpyf(tx_buffer0,"     Name/Tel Stay   Please Wait");
              //strcpyf(tx_buffer0,"      Names Stay      Please Wait");  
      }
      
      SendToLCD(&tx_buffer0[4],&tx_buffer0[20],&tx_buffer0[36],&tx_buffer0[52]);  //MMM 
      PORTC |=0x1;//Ligt Back Light   
            
      PORTG |=0x2;// lit the led   
      
     // EEprotect          
      PORTE &=~0x4;//ENALBLE EE WRITE                
       
      
  if (!(KeepNameFlag)){ //FIX7 - only for MP199                  
      /// Faster Erase Chip /////////
      Pointer = Name;
      MaxNum = CMaxName;
      for(i=1;i<=(MaxName+1);i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"                ");
           WritePage(i);
      } 
      for(i=1;i<=(MaxName+1);i++){
           PORTG ^=0x2;// blink the led 
           ReadData(i); 
           if ((Data[0]!=' ')||(Data[1]!=' ')||(Data[2]!=' ')||(Data[3]!=' ')||(Data[4]!=' ')||(Data[5]!=' ')||(Data[6]!=' ')||
           (Data[7]!=' ')||(Data[8]!=' ')||(Data[9]!=' ')||(Data[10]!=' ')||(Data[11]!=' ')||(Data[12]!=' ')||(Data[13]!=' ')||
           (Data[14]!=' ')||(Data[15]!=' ')){
               strcpyf(Data,"                ");
               WriteData(i);                   
           }
      }      
      
      Class=1; 
      for(i=1;i<=(MaxName+1);i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"                ");
           WritePage(i);
      } 
      for(i=1;i<=(MaxName+1);i++){
           PORTG ^=0x2;// blink the led 
           ReadData(i); 
           if ((Data[0]!=' ')||(Data[1]!=' ')||(Data[2]!=' ')||(Data[3]!=' ')||(Data[4]!=' ')||(Data[5]!=' ')||(Data[6]!=' ')||
           (Data[7]!=' ')||(Data[8]!=' ')||(Data[9]!=' ')||(Data[10]!=' ')||(Data[11]!=' ')||(Data[12]!=' ')||(Data[13]!=' ')||
           (Data[14]!=' ')||(Data[15]!=' ')){
               strcpyf(Data,"                ");
               WriteData(i);                   
           }
      }                   
      Class=0; 
      
       
      Pointer = Tel1Num;
      MaxNum = CMaxTel1Num;  
      for(i=1;i<=(MaxTel1Num+1);i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"                ");
           WritePage(i);
      } 
      for(i=1;i<=(MaxTel1Num+1);i++){
           PORTG ^=0x2;// blink the led 
           ReadData(i); 
           if ((Data[0]!=' ')||(Data[1]!=' ')||(Data[2]!=' ')||(Data[3]!=' ')||(Data[4]!=' ')||(Data[5]!=' ')||(Data[6]!=' ')||
           (Data[7]!=' ')||(Data[8]!=' ')||(Data[9]!=' ')||(Data[10]!=' ')||(Data[11]!=' ')||(Data[12]!=' ')||(Data[13]!=' ')||
           (Data[14]!=' ')||(Data[15]!=' ')){
               strcpyf(Data,"                ");
               WriteData(i);                   
           }
      }      
            
      Pointer = Tel2Num;
      MaxNum = CMaxTel2Num;
      for(i=1;i<=(MaxTel2Num+1);i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"                ");
           WritePage(i);
      } 
      for(i=1;i<=(MaxTel2Num+1);i++){
           PORTG ^=0x2;// blink the led 
           ReadData(i); 
           if ((Data[0]!=' ')||(Data[1]!=' ')||(Data[2]!=' ')||(Data[3]!=' ')||(Data[4]!=' ')||(Data[5]!=' ')||(Data[6]!=' ')||
           (Data[7]!=' ')||(Data[8]!=' ')||(Data[9]!=' ')||(Data[10]!=' ')||(Data[11]!=' ')||(Data[12]!=' ')||(Data[13]!=' ')||
           (Data[14]!=' ')||(Data[15]!=' ')){
               strcpyf(Data,"                ");
               WriteData(i);                   
           }
      }      
   
      Pointer = Tel3Num;
      MaxNum = CMaxTel3Num;
      for(i=1;i<=(MaxTel3Num+1);i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"                ");
           WritePage(i);
      }  
      for(i=1;i<=(MaxTel3Num+1);i++){
           PORTG ^=0x2;// blink the led 
           ReadData(i); 
           if ((Data[0]!=' ')||(Data[1]!=' ')||(Data[2]!=' ')||(Data[3]!=' ')||(Data[4]!=' ')||(Data[5]!=' ')||(Data[6]!=' ')||
           (Data[7]!=' ')||(Data[8]!=' ')||(Data[9]!=' ')||(Data[10]!=' ')||(Data[11]!=' ')||(Data[12]!=' ')||(Data[13]!=' ')||
           (Data[14]!=' ')||(Data[15]!=' ')){
               strcpyf(Data,"                ");
               WriteData(i);                   
           }
      }      
            
      Pointer = Tel4Num;
      MaxNum = CMaxTel4Num;
      for(i=1;i<=(MaxTel4Num+1);i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"                ");
           WritePage(i);
      } 
      for(i=1;i<=(MaxTel4Num+1);i++){
           PORTG ^=0x2;// blink the led 
           ReadData(i); 
           if ((Data[0]!=' ')||(Data[1]!=' ')||(Data[2]!=' ')||(Data[3]!=' ')||(Data[4]!=' ')||(Data[5]!=' ')||(Data[6]!=' ')||
           (Data[7]!=' ')||(Data[8]!=' ')||(Data[9]!=' ')||(Data[10]!=' ')||(Data[11]!=' ')||(Data[12]!=' ')||(Data[13]!=' ')||
           (Data[14]!=' ')||(Data[15]!=' ')){
               strcpyf(Data,"                ");
               WriteData(i);                   
           }
      }      
            
      Pointer = Tel5Num;
      MaxNum = CMaxTel5Num;
      for(i=1;i<=(MaxTel5Num+1);i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"                ");
           WritePage(i);
      }
      for(i=1;i<=(MaxTel5Num+1);i++){
           PORTG ^=0x2;// blink the led 
           ReadData(i); 
           if ((Data[0]!=' ')||(Data[1]!=' ')||(Data[2]!=' ')||(Data[3]!=' ')||(Data[4]!=' ')||(Data[5]!=' ')||(Data[6]!=' ')||
           (Data[7]!=' ')||(Data[8]!=' ')||(Data[9]!=' ')||(Data[10]!=' ')||(Data[11]!=' ')||(Data[12]!=' ')||(Data[13]!=' ')||
           (Data[14]!=' ')||(Data[15]!=' ')){
               strcpyf(Data,"                ");
               WriteData(i);                   
           }
      }      
            
      Pointer = Tel6Num;
      MaxNum = CMaxTel6Num;
      for(i=1;i<=(MaxTel6Num+1);i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"                ");
           WritePage(i);
      }
      for(i=1;i<=(MaxTel6Num+1);i++){
           PORTG ^=0x2;// blink the led 
           ReadData(i); 
           if ((Data[0]!=' ')||(Data[1]!=' ')||(Data[2]!=' ')||(Data[3]!=' ')||(Data[4]!=' ')||(Data[5]!=' ')||(Data[6]!=' ')||
           (Data[7]!=' ')||(Data[8]!=' ')||(Data[9]!=' ')||(Data[10]!=' ')||(Data[11]!=' ')||(Data[12]!=' ')||(Data[13]!=' ')||
           (Data[14]!=' ')||(Data[15]!=' ')){
               strcpyf(Data,"                ");
               WriteData(i);                   
           }
      }              
  }//FIX7 Only For MP199         
      
 ///////////////////////////////////////////          
      
      
      Pointer = Code;
      MaxNum = CMaxCode;
      strcpyf(Data,"123       ");
      WriteData(1);
      for(i=2;i<=MaxCode;i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"          ");
           WriteData(i);
      }
      Pointer = Code;
      MaxNum = CMaxCode;
      strcpyf(Data,"456       ");
      WriteData(MaxCode);      

           
      PORTG &=~0x2;// blank the led
      Pointer = MasterCode;
      MaxNum = CMaxMasterCode;
      strcpyf(Data,"123456           ");
      WriteData(1); 
//       Pointer = RmtMasterCode;
//       MaxNum = CMaxRmtMasterCode;
//       strcpyf(Data,"123456           ");
//       WriteData(1);             
      Pointer = TecUserCode;
      MaxNum = CMaxTecUserCode;
      strcpyf(Data,"252525           ");
      WriteData(1);
      
      
      Pointer = OutPut;
      MaxNum =  CMaxOutPut;

    // if(Status){
         for(i=1;i<=MaxOutPut;i++){            // big bord
               PORTG ^=0x2;// lit the led
              if (i>99){
                  NamePointerTmp = i % 100;
                  Data[0] = 0x30 + i/100;
                  Data[1] = 0x30 + NamePointerTmp/10;
                  Data[2] = 0x30 + NamePointerTmp%10;
                  WriteData(i);
              }else {
           	  Data[0] = 0x30 + i/10;
                  Data[1] = 0x30 + i%10;
                  Data[2] = 0x20;
                  WriteData(i);
              }
         }

     /* else{
         for(i=1;i<=12;i++){                  //small borg
             Data[0] = 0x30 + i/10;
             Data[1] = 0x30 + i%10;
             WriteData(i);
         }
         for(i=13;i<=MaxOutPut-4;i++){
             Data[0] = 0x30 + (i+4)/10;
             Data[1] = 0x30 + (i+4)%10;
             WriteData(i);
         }
         for(i=MaxOutPut-3;i<=MaxOutPut;i++){
             Data[0] = ' ';
             Data[1] = ' ';
             WriteData(i);
         }
      }*/


      Pointer = TimeCycle;
      MaxNum =  CMaxTimeCycle;
      strcpyf(Data,"00");   //Entry Delay 1
      WriteData(1);
      strcpyf(Data,"05");   // open 1
      WriteData(2);
      strcpyf(Data,"00");   // delay 2
      WriteData(3);
      strcpyf(Data,"02");   // open 2
      WriteData(4);
      strcpyf(Data,"99");   // illumintion time
      WriteData(5);
      strcpyf(Data,"05");   // ring time
      WriteData(6);
      strcpyf(Data,"30");   //was  camera time now redial time 
      WriteData(7);
      strcpyf(Data,"30");   // Pin+ Code Time out
      WriteData(8);
      strcpyf(Data,"40");   // forget open door time out 10 sec
      WriteData(9);
      strcpyf(Data,"10");   // det to welcome message  2.5 sec
      WriteData(10);
      strcpyf(Data,"08");   // Time to anncoce names   2 sec
      WriteData(11);
      strcpyf(Data,"06");   // Time to floor message   3 sec
      WriteData(12);
      strcpyf(Data,"40");   // time to Display list   3 sec
      WriteData(13);
      strcpyf(Data,"06");   // Time to disply select   3 sec  //FIX1
      WriteData(14);
      strcpyf(Data,"20");   // Time to clear select (reset code)   3 sec//FIX1
      WriteData(15);
      strcpyf(Data,"10");   // Speech Time X10    10X10=100 sec
      WriteData(16);
      strcpyf(Data,"00");   // Bsuy test time
      WriteData(17);
      strcpyf(Data,"00");   // Confirm Test time
      WriteData(18);


   if (!(KeepNameFlag)){ //FIX7
      Pointer = Name;
      MaxNum = CMaxName;
      if (!EnglishMode){ 
               strcpyf(Data,"      דירה 1    ");
               WriteData(1);
               strcpyf(Data,"      דירה 2    ");
               WriteData(2);               
               strcpyf(Data,"      דירה 3    ");
               WriteData(3);                           
//          strcpyf(Data,"     לוי דוד  ");
//          WriteData(1);
//          strcpyf(Data,"     אהרון משה");
//          WriteData(2);
//          strcpyf(Data,"     בן דוד י ");
//          WriteData(3);
//          strcpyf(Data,"     תשבי יקוב");
//          WriteData(4);
//          strcpyf(Data,"     יהודה דוד");
//          WriteData(5);
//          strcpyf(Data,"     גמל צור  ");
//          WriteData(6);
//          strcpyf(Data,"     אבני יוסף");
//          WriteData(7);
//          strcpyf(Data,"     דדני יעל ");
//          WriteData(8);
//          strcpyf(Data,"     סוזן דלל ");
//          WriteData(9);
//          strcpyf(Data,"     הדר יוסף ");
//          WriteData(10);
      }else {
          strcpyf(Data,"   APP. # 1     ");
          WriteData(1);
          strcpyf(Data,"   APP. # 2     ");
          WriteData(2);
          strcpyf(Data,"   APP. # 3     ");
          WriteData(3);
//          strcpyf(Data,"    APP. # 4  ");
//          WriteData(4);
//          strcpyf(Data,"    APP. # 5  ");
//          WriteData(5);
//          strcpyf(Data,"    APP. # 6  ");
//          WriteData(6);
//          strcpyf(Data,"    APP. # 7  ");
//          WriteData(7);
//          strcpyf(Data,"    APP. # 8  ");
//          WriteData(8);
//          strcpyf(Data,"    APP. # 9  ");
//          WriteData(9);
//          strcpyf(Data,"    APP. # 10  ");
//          WriteData(10);

      } 
//      Class=1;  
////      strcpyf(Data,"");  
////      for(i=1;i<=NAMEN;i++){      
////          WriteData(i);          
////      } 
//      if (EnglishMode){ 
//          strcpyf(Data,"   APP. # 1CC   ");
//          WriteData(1);
//          strcpyf(Data,"   APP. # 2dd   ");
//          WriteData(2);
//          strcpyf(Data,"   APP. # 3ee   "); 
//          WriteData(3);                      
//      } 
//          
//      Class=0;      

    /*  strcpyf(Data,"     דירה מספר 1");
      WriteData(1);
      strcpyf(Data,"     דירה מספר 2");
      WriteData(2);
      strcpyf(Data,"     דירה מספר 3");
      WriteData(3);
      strcpyf(Data,"     דירה מספר 4");
      WriteData(4);
      strcpyf(Data,"     דירה מספר 5");
      WriteData(5);
      strcpyf(Data,"     דירה מספר 6");
      WriteData(6);
      strcpyf(Data,"     דירה מספר 7");
      WriteData(7);
      strcpyf(Data,"     דירה מספר 8");
      WriteData(8);
      strcpyf(Data,"     דירה מספר 9");
      WriteData(9);
      strcpyf(Data,"     דירה מספר01");
      WriteData(10);
      strcpyf(Data,"     דירה מספר11");
      WriteData(11);
      strcpyf(Data,"     דירה מספר21");
      WriteData(12);
      strcpyf(Data,"     דירה מספר31");
      WriteData(13);
      strcpyf(Data,"     דירה מספר41");
      WriteData(14);
      strcpyf(Data,"     דירה מספר51");
      WriteData(15);
      strcpyf(Data,"     דירה מספר61");
      WriteData(16);
      strcpyf(Data,"     דירה מספר71");
      WriteData(17);
      strcpyf(Data,"     דירה מספר81");
      WriteData(18);
      strcpyf(Data,"     דירה מספר91");
      WriteData(19);   */

   }//FIX7 

   /*   for(i=18;i<=21;i++){
           strcpyf(Data,"     דירה מספר71");
        Data[14]=0x30+i%10;
        Data[15]=0x30+i/10;
           WriteData(i);
      } */
     /* for(i=11;i<=MaxName;i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"                ");
           WriteData(i);
      } */
    /*  if (!EnglishMode)strcpyf(Data,"     דירה מסר041");
      else  strcpyf(Data,"    APP. # 140 ");
      WriteData(140);*/

      Pointer = ExtKeys;
      MaxNum =  CMaxExtKeys;
      strcpyf(Data,"00");
      WriteData(1);
      
      Pointer = FamilyNo;
      MaxNum =  CMaxFamilyNo;
      strcpyf(Data,"0");
      WriteData(1);
      

      PORTG ^=0x2;// flip the led

      Pointer = MasageOn;
      MaxNum =  CMaxMasageOn;
      strcpyf(Data,"N"); // welcome message  by # on
      WriteData(1);
      strcpyf(Data,"Y");// Floor  message on
      WriteData(2);
      strcpyf(Data,"N"); //Close door  off
      WriteData(3);
      strcpyf(Data,"N"); // Announce Names   0ff
      WriteData(4);
      strcpyf(Data,"N"); //  Door forget message 0ff
      WriteData(5);
      strcpyf(Data,"Y"); //  Welcome by det message 0n
      WriteData(6);
      strcpyf(Data,"Y"); //  Ringing message 0n
      WriteData(7);
      strcpyf(Data,"Y"); //  Open Door message 0ff
      WriteData(8);


      Pointer = CommSpd;
      MaxNum =  CMaxCommSpd;
      strcpyf(Data,"2");  // Set Comm Speed to 2
      WriteData(1);

      Pointer = ConfirmTone;
      MaxNum =  CMaxConfirmTone;
      strcpyf(Data,"-");  // Set Comm Speed to 2
      WriteData(1);




      PORTG ^=0x2;// blink the led

      Pointer = FASTstep;
      MaxNum =  CMaxFASTstep;
      strcpyf(Data,"1"); // number of stepX4
      WriteData(1);

      Pointer = SpeechLevel;
      MaxNum =  CMaxSpeechLevel;
      strcpyf(Data,"7"); // Speech level =8
      WriteData(1);

      Pointer = AnswerY_N;
      MaxNum =  CMaxAnswerY_N;
      strcpyf(Data,"N"); // Replace appartment by Ofice no
      WriteData(1);
      strcpyf(Data,"N"); // Det to Back light
      WriteData(2);
      strcpyf(Data,"Y"); // Proxy 1 to relay 1
      WriteData(3);
      strcpyf(Data,"N"); // Proxy 1 to relay 2
      WriteData(4);
      strcpyf(Data,"N"); // Proxy 2 to relay 1
      WriteData(5);
      strcpyf(Data,"Y"); // Proxy 2 to relay 2
      WriteData(6);
      strcpyf(Data,"N"); // active only Proxy +pin
      WriteData(7);
      strcpyf(Data,"N"); // App Name by A-B ?
      WriteData(8);
      strcpyf(Data,"N"); // Extrnal Proxy  ?
      WriteData(9);
      strcpyf(Data,"N"); // Elevetor Board ?
      WriteData(10);
      strcpyf(Data,"N"); // RTC uesed ?
      WriteData(11);
      strcpyf(Data,"N"); // Show Phone Parameters  
      WriteData(12);   
      strcpyf(Data,"Y"); // sound  in unlock 
      WriteData(13);               
      strcpyf(Data,"N"); // w/o app/office   //FIX MENU
      WriteData(14);
      strcpyf(Data,"N"); // Direct Dial Mode //FIX MENU
      WriteData(15);                
      strcpyf(Data,"N"); // Full menu   //FIX MENU
      WriteData(16);                               





      PORTG ^=0x2;// blink the led

      Pointer = RelayControl;
      MaxNum =  CMaxRelayControl;
      strcpyf(Data,"250");  // relay 1 end at 144
      WriteData(1);
      strcpyf(Data,"250"); // relay 2 start at 144 //not active
      WriteData(2);

      PORTG ^=0x2;// blink the led

      Pointer = Type;
      MaxNum =  CMaxType;
      strcpyf(Data,"201");  // Write type
      WriteData(1);


      Pointer = Ofset;
      MaxNum =  CMaxOfset;
      strcpyf(Data,"0000");  // Ofset1 value until namber/added number
      WriteData(1);


      Pointer = NewNo;
      MaxNum =  CMaxNewNo;
      for(i=1;i<=MaxNewNo;i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"000");
           if (i<10)Data[2]=0x30+i;
           else if(i<100){
                Data[1]=0x30+i/10;
                Data[2]=0x30+i%10;
           }
           else {
                NewAppNo= i%100;
                Data[0]=0x30+i/100;
                Data[1]=0x30+NewAppNo/10;
                Data[2]=0x30+NewAppNo%10;
           }
           WriteData(i);
      }

      PORTG ^=0x2;// blink the led

      Pointer = FloorValue;
      MaxNum =  CMaxFloorValue;
      strcpyf(Data,"000");  // up to app equ graound floor
      WriteData(1);
      strcpyf(Data,"004"); // up to app 4 equ graound floor
      WriteData(2);
      strcpyf(Data,"008"); // up to app 8 equ graound floor
      WriteData(3);
      strcpyf(Data,"012"); // up to app 12 equ graound floor
      WriteData(4);
      strcpyf(Data,"016"); // up to app 16 equ graound floor
      WriteData(5);
      for(i=6;i<=MaxFloorValue;i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"000");
           WriteData(i);
      }

      PORTG ^=0x2;// blink the led

      Pointer = SetReadTimer;
      MaxNum = CMaxSetReadTimer;
      strcpyf(Data,"       ");
      WriteData(1);
      strcpyf(Data,"1200");
      WriteData(2);
      strcpyf(Data,"1300");
      WriteData(3);
      strcpyf(Data,"       ");
      WriteData(4);
      strcpyf(Data,"       ");
      WriteData(5);
      strcpyf(Data,"       ");
      WriteData(6);
      strcpyf(Data,"       ");
      WriteData(7);
      strcpyf(Data,"1600");
      WriteData(8);
      strcpyf(Data,"1700");
      WriteData(9);
      strcpyf(Data,"       ");
      WriteData(10);
      strcpyf(Data,"1800");
      WriteData(11);
      strcpyf(Data,"1900");
      WriteData(12);

      Pointer = SaveTimerSta;
      MaxNum = CMaxSaveTimerSta;
      strcpyf(Data,"0");
      WriteData(1);




      PORTG ^=0x2;// blink the led
   if (!(KeepNameFlag)){ //FIX7 - only for MP199     
      Pointer = Tel1Num;
      MaxNum = CMaxTel1Num;
      strcpyf(Data,"21");
      WriteData(1);
      strcpyf(Data,"22");
      WriteData(2);
      strcpyf(Data,"23");
      WriteData(3);   
  }
/*      for(i=4;i<=MaxTel1Num;i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"          ");
           WriteData(i);
      }
      Pointer = Tel2Num;
      MaxNum = CMaxTel2Num;
      for(i=1;i<=MaxTel2Num;i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"          ");
           WriteData(i);
      }
      Pointer = Tel3Num;
      MaxNum = CMaxTel3Num;
      for(i=1;i<=MaxTel3Num;i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"          ");
           WriteData(i);
      }
      Pointer = Tel4Num;
      MaxNum = CMaxTel4Num;
      for(i=1;i<=MaxTel4Num;i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"          ");
           WriteData(i);
      }
      Pointer = Tel5Num;
      MaxNum = CMaxTel5Num;
      for(i=1;i<=MaxTel5Num;i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"          ");
           WriteData(i);
      }
      Pointer = Tel6Num;
      MaxNum = CMaxTel6Num;
      for(i=1;i<=MaxTel6Num;i++){
           PORTG ^=0x2;// blink the led
           strcpyf(Data,"          ");
           WriteData(i);
      }*/
      
      Pointer = RingingNum;
      MaxNum = CMaxRingingNum;
      strcpyf(Data,"01");
      WriteData(1);

      PORTG ^=0x2;// blink the led

      Pointer = BusySogTone;
      MaxNum = CMaxBusySogTone;
      strcpyf(Data,"00");//bussy sug 1 //auto mode 
      WriteData(1);
      strcpyf(Data,"00");//bussy sug 2 //auto mode 
      WriteData(2); 
      strcpyf(Data,"45");//bussy volume 
      WriteData(3);
      strcpyf(Data,"00");//bussy freq - 0 no freq test 
      WriteData(4);
      strcpyf(Data,"30");//call lower frq 
      WriteData(5);
      strcpyf(Data,"50");//call upper frq 
      WriteData(6);
      strcpyf(Data,"40");//break betwwen call
      WriteData(7);
      strcpyf(Data,"00");//Number of call - 0 no test 
      WriteData(8);
      strcpyf(Data,"08");//Bussy Number 
      WriteData(9);
      
      
      
      

      PORTG ^=0x2;// blink the led

      Pointer = ToneCodes;
      MaxNum = CMaxToneCodes;
      strcpyf(Data,"57");
      WriteData(1);  
      
      
      Pointer = KeepName;//FIX7 start
      MaxNum =  CMaxKeepName;
      strcpyf(Data,"0");
      WriteData(1);  //FIX7 end 
      KeepNameFlag=0; //clear any way 
      
      PORTC &=~0x1;//Balnck  Back Light 
     // if (!(KeepNameFlag)){    
          Pointer = PRG_Was_Done;//FIX7 start
          MaxNum =  CMaxPRG_Was_Done;
          strcpyf(Data,"%");
          WriteData(1);  //PRG SHOW  
    //  }  
          Pointer = Relay1MeM;//
          MaxNum =  CMaxRelay1MeM;
          strcpyf(Data,"0");
          WriteData(1);  //PRG SHOW 
          
          Pointer = Relay2MeM;//
          MaxNum =  CMaxRelay2MeM;
          strcpyf(Data,"0");
          WriteData(1);  //PRG SHOW             
     
               // EEprotect 
          PORTE |=0x4;//DISALBLE EE WRITE 
}

char TestDoor(char* code,char num){
unsigned char MidValue;
    if (!num){
          if (Dial_This)ReturnValue=Dial_This;//116     
    }
    else if(num == 1){
        ReturnValue=(code[0]);
    }
    else
    if(num == 2){
    	if ((((code[0])*10) + code[1])>99) ReturnValue=0;
    	else ReturnValue=(((code[0])*10) + code[1]);
    }   else
    if(num == 3){
        ReturnValue = code[0];
        ReturnValue *=100;
        MidValue=((code[1]*10) + code[2]);
        ReturnValue = ReturnValue + MidValue;
    }
    else ReturnValue=0;
    if(!AddedType){
    	   if (ReturnValue>NAMEN)return(0);
    	   else  return(ReturnValue);
    }
    else if(AddedType==1){
    	  if (ReturnValue>(NAMEN+AddedValue)) return(0);
    	  if (ReturnValue<(AddedValue+1)) return(0);
    	  return(ReturnValue);
    }
    else if(AddedType==2){
          MidValue= code[0];
          if (  MidValue >((NAMEN/AddedValue)+1) )return(0);
          else if  ((ReturnValue>100)&&(ReturnValue<101+AddedValue))return(ReturnValue);
          else if  ((ReturnValue>200)&&(ReturnValue<201+AddedValue))return(ReturnValue);
          else if  ( (ReturnValue>300)&&(ReturnValue<301+AddedValue))return(ReturnValue);
          else if  ( (ReturnValue>400)&&(ReturnValue<401+AddedValue))return(ReturnValue);
          else if  ( (ReturnValue>500)&&(ReturnValue<501+AddedValue))return(ReturnValue);
          else if  ( (ReturnValue>600)&&(ReturnValue<601+AddedValue))return(ReturnValue);
          else if  ( (ReturnValue>700)&&(ReturnValue<701+AddedValue))return(ReturnValue);
          else if  ( (ReturnValue>800)&&(ReturnValue<801+AddedValue))return(ReturnValue);
          else if  ( (ReturnValue>900)&&(ReturnValue<901+AddedValue))return(ReturnValue);
          else return(0);
    }

}

char ReturnNamePointer(char ListName){
     char i;
//     if (YesNoAnswer &0x80){ //FIX1
          for(i=0;i<MaxName;i++){
               if(ListName == Order[i]) return(i+1);
          }
           return(0);
//     }  //FIX1
//     else {
//          return(ListName);
//     } //FIX1
}

void OrderName(void){
   char i,j;
   char HData[CMaxName];
   char Line1[17],Line2[17],Line3[17],Line4[17];
   if (EnglishMode){
        strcpyf(Line1,"wait...        ");
        strcpyf(Line2,"Organizing name");
        strcpyf(Line3,"May take few   ");
        strcpyf(Line4,"       minutes");
   }else {
        strcpyf(Line1,"  מארגן שמות    ");
        strcpyf(Line2,"  אנא המתן      ");
        strcpyf(Line3,"  בסבלנות       ");
        strcpyf(Line4,"                ");
        HebruSrting(Line1);
        HebruSrting(Line2);//MMM
        HebruSrting(Line3);
        HebruSrting(Line4);
   }
   fourline=100;
   SendToLCD(Line1,Line2,Line3,Line4);
   BigName = 0;
   LastLocaName=0;
   Pointer = Name;
   MaxNum = CMaxName;
   for(i=1;i<=MaxName;i++){
      Disable_RelayTime();// for 30 usec timer stop it
      #asm("WDR");
      Order[i-1] = 0;
      ReadData(i);
      cpyString(HData,Data,CMaxName);
       if(!BlankStr(HData)){         
            if (i >LastLocaName)LastLocaName=i;
            Order[i-1] = 1;
            for(j=1;j<=MaxName;j++){
                 ReadData(j);
                 if(!BlankStr(Data))
                      if(TestString(HData,Data,i,j))  Order[i-1]++;
            }
       }
       if(Order[i-1] > BigName) BigName = Order[i-1]; 
   }
   Pointer = 1;//OrderNames;
   MaxNum = CMaxOrderNames;
   for(j=1;j<=MaxName+1;j++){
          Data[0]= Order[j-1];
          if (j==(MaxName+1))Data[0]=BigName;
          WriteDataChip(j);
   }
   Siren_Start(3);
}
void OrderNameRead(void){
    char j;
    Pointer = 1;//OrderNames;
    MaxNum = CMaxOrderNames;
    for(j=1;j<=MaxName+1;j++){
          ReadDataChip(j);
          if (j==(MaxName+1))BigName=Data[0];
          else Order[j-1]=Data[0];
    }
}

char BlankStr(char* str){
    char i;
    for(i=0;i<16;i++)
       if(str[i] != ' ') return(0);
    return(1);
}
char TestString(char* str1,char* str2,char count1,char count2){
 char i;
 char s1[16],s2[16];
 cpyString(s1,str1,16);
 cpyString(s2,str2,16);
 MoveBlank(s1);
 MoveBlank(s2);
 if (!(YesNoAnswer &0x80)){ //FIX1
      if(count1 > count2) return(1);
      else return(0);
 }   //FIX1
 for(i = 0; i < 16;i++){
    if(s1[i] > s2[i])return(1);
    else
    if(s1[i] < s2[i])return(0);
 }
 if(count1 > count2) return(1);
 else return(0);
}
void MoveBlank(char* str){
    char i;
    while(str[0] == ' '){
        for(i = 0;i<15;i++)
           str[i] = str[i+1];
        str[i] = ' ';
    }
}
void cpyString(char* str1,char* str2,char num){
     while(num){
         num--;
         str1[num] = str2[num];
     }
}
char GetRelay(char name){
    char Relay;
    Pointer = OutPut;
    MaxNum = CMaxOutPut;
    ReadData(name);
    if ((Data[2]==0x20)&&(Data[1]==0x20))
         Relay = (Data[0]&0x0f);
    else if (Data[2]==0x20)
         Relay = (Data[0]&0x0f)*10+ (Data[1]&0x0f);
    else Relay = (Data[0]&0x0f)*100 + (Data[1]&0x0f)*10+ (Data[2]&0x0f);

    if((Relay > 0)&&(Relay < 145))
        return(Relay);
    else
        return(0);
}
void Siren_Start(char Sug)
{
    AMP_ON_OFF |=0x2;// BUZ OFF (0 = amp 1 buzzer 2 voice ) 
    if(VoiceIC_Mode)Disable_RelayTime();       
    SugSound = Sug;
    CounterSound = 1000;
    TCCR3B=0x1B;
}
void Siren_Stop(void)
{
    SugSound = 0;
    TCCR3B=0x00;
    PORTE&= ~0x08;
    Enable_RelayTime();
    AMP_ON_OFF &=~0x2;// BUZ OFF (0 = amp 1 buzzer 2 voice) 
}

void  Make_20ms_Reset(void)
{
    PORTB &=~0x1;//RESET=0 
    T_R_TimeOut=16 ; //5x4=20 msec
    while (T_R_TimeOut){
          while(!MainCycle){}
          MainCycle = 0;
          T_R_TimeOut--; 
    }
    PORTB |=0x1;//RESSET=1 
}

void WriteData(char List)  //write data to eeprom
{
    int ind;           //+160
    char k,CN2; 
    ind= List - 1; 
    CN2=Class;
    while(CN2){
         ind += 250;
         CN2--;
    } 
   // ind += Class*250;
    ind *= MaxNum;
    ind += Pointer;
    for (k=0;k<MaxNum;k++){
         DataWriteEE(ind+k,1,&Data[k]);
    }
}
void WritePage(char List)  //write data to eeprom
{
    int ind;           //+160
    char k;
    ind= List - 1; 
    ind += Class*250;
    ind *= MaxNum;
    ind += Pointer;
    for (k=0;k<(MaxNum-1);k++){
         if (!k)PageStrWriteEE(ind+k,1,&Data[k]);  
         else PageWriteEE(ind+k,1,&Data[k]);
    }
    PageStpWriteEE(ind+k,1,&Data[k]);
}

void ReadData(char List)  //read data from eeprom
{
    int ind;  
    char CN2; 
    ind= List - 1;        //+160
    CN2=Class;
    while(CN2){
         ind += 250;
         CN2--;
    } 
   // ind += Class*250;
    ind *= MaxNum;
    ind += Pointer;
    DataReadEE(ind,MaxNum,&Data[0]); 
    if (MaxNum == CMaxName){   
            Data[0]=' ';//00 name 
            Data[1]=' ';
            Data[2]=' '; 
            if (!EnglishMode)Data[3]=' ';
    } 
    if ((ProxyValid)&&((StutLine1==pProxyLrnR)||(StutLine1==pProxyLrn2R))){//PRXO 
            if(Status)Saved_Char=Data[0];//PRxO 
    }                     
}
void Time_Up(void){
     if(!Status){//enter only of normal mode   
          DataReadPCF(4,1,&Data[0]);//hours
          Data[0]&=0x3f;
          Hours=Data[0];
          DataReadPCF(3,1,&Data[0]);//min
          Data[0]&=0x7f;
          Minutes=Data[0];
          DataReadPCF(2,1,&Data[0]);//Seconds
          Data[0]&=0x7f;
          Secounds=Data[0];   
          DataReadPCF(6,1,&Data[0]);//days
          Data[0]&=0x7;
          Days=Data[0];
          Days++;
          //if (Days>7)Days=7;
          DataReadPCF(2,1,&Data[0]);//SEC test
          if (Data[0]&0x80){
               Days=0;
               PowerFail=1;// put power fail sign
          }
          else {
               Data[0]=0x10; // for accurecy adjust PF8563 to MEGA168 Clock
               //FIXTIME if ((!TIM_ADJ)&&(!Show_Clock))DataWritePCF(2,1,&Data[0]);//Secounds
          }
     }
  // LIMIT_Up();
}
void ArrangPrxy1(void){
unsigned char ind,TestedValue,SI=0; //Long BEEP
      Pointer = ORG_Was_Start;//ORG_Was_Start
      MaxNum =  CMaxORG_Was_Start;
      ReadData(1);  //PRG SHOW  
      if (Data[0]!="1"){
              strcpyf(Data,"1");
              WriteData(1);  //SAVE FLAGE 
      } 
          
     PxyDirDone=20; 
     for (MSB_value=4;MSB_value<=68;MSB_value++){ 
              tx_buffer0[MSB_value]=0x20;
     } 
     if (EnglishMode){
         tx_buffer0[25]=87; //W
         tx_buffer0[26]=65; //A
         tx_buffer0[27]=73; //I
         tx_buffer0[28]=84;//T 
     }else {
         tx_buffer0[25]=0xaf; //ן
         tx_buffer0[26]=0xba; //ת
         tx_buffer0[27]=0xae; //מ
         tx_buffer0[28]=0xa4;//ה 
     }
                               
     SendToLCD(&tx_buffer0[4],&tx_buffer0[20],&tx_buffer0[36],&tx_buffer0[52]);  //MMM   
                             
                              
     for (Class=0;Class<=5;Class++){
          Directory_Found=0;                                                                            
          for (MSB_value=0;MSB_value<=0xf;MSB_value++){
             PrxyQty=0;                                       
             SI++;                                      
             if (SI<=2)Siren_Stop();
             if (SI==6){
                  Siren_Start(3);
                  SI=0;
             }      
             for (ind=1;ind<=NAMEN;ind++){                                                                                                                                             
                     Pointer = ProxyLrn;
                     MaxNum = CMaxProxyLrn;                           
                     ReadData(ind);
                                            
                     if (MSB_value>9)TestedValue= MSB_value+55; //imp
                     else TestedValue= MSB_value+48; //imp

                     if (Data[7]==TestedValue){//imp 
                         Data[0]=ind;
                         Pointer = PrxyDirRly1+1;
                         MaxNum = 1;                                                        
                         WriteData(Directory_Found);
                         Directory_Found++; 
                         PrxyQty++;                                                
                     } 
                       
             }                           
             Data[0]=PrxyQty;
             Pointer = PrxyQtytRly1;
             MaxNum = 1;                                                        
             WriteDataQty(MSB_value); //Imp                                     
          }
     } 
     Class=0;
     Pointer = ORG_Was_Start;//ORG_Was_Start
     MaxNum =  CMaxORG_Was_Start; 
     strcpyf(Data,"0");
     WriteData(1);  //PRG SHOW           
}
void ArrangPrxy2(void){
unsigned char ind,TestedValue,SI=0; //Long BEEP
      Pointer = ORG_Was_Start;//ORG_Was_Start
      MaxNum =  CMaxORG_Was_Start;
      ReadData(1);  //PRG SHOW  
      if (Data[0]!='2'){
              strcpyf(Data,"2");
              WriteData(1);  //SAVE FLAGE 
      } 
     
     PxyDirDone=20; 
     for (MSB_value=4;MSB_value<=68;MSB_value++){ 
              tx_buffer0[MSB_value]=0x20;
     } 
     if (EnglishMode){
         tx_buffer0[25]=87; //W
         tx_buffer0[26]=65; //A
         tx_buffer0[27]=73; //I
         tx_buffer0[28]=84;//T 
     }else {
         tx_buffer0[25]=0xaf; //ן
         tx_buffer0[26]=0xba; //ת
         tx_buffer0[27]=0xae; //מ
         tx_buffer0[28]=0xa4;//ה 
     }
                               
     SendToLCD(&tx_buffer0[4],&tx_buffer0[20],&tx_buffer0[36],&tx_buffer0[52]);  //MMM  
     for (Class=0;Class<=5;Class++){
          Directory_Found=0;                                                                            
          for (MSB_value=0;MSB_value<=0xf;MSB_value++){
             PrxyQty=0;                                       
             SI++;                                      
             if (SI<=2)Siren_Stop();
             if (SI==6){
                  Siren_Start(3);
                  SI=0;
             }      
             for (ind=1;ind<=NAMEN;ind++){                                                                                                                                             
                     Pointer = ProxyLrn2;
                     MaxNum = CMaxProxyLrn2;                           
                     ReadData(ind); 
                     if (MSB_value>9)TestedValue= MSB_value+55; //imp
                     else TestedValue= MSB_value+48; //imp

                                                 
                     if (Data[7]==TestedValue){//imp 
                         Data[0]=ind;
                         Pointer = PrxyDirRly2+1;
                         MaxNum = 1;                                                        
                         WriteData(Directory_Found);
                         Directory_Found++; 
                         PrxyQty++;                                                
                     }
             }                           
             Data[0]=PrxyQty;
             Pointer = PrxyQtytRly2;
             MaxNum = 1;                                                        
             WriteDataQty(MSB_value); //Imp                                     
          }

     }
     Class=0;
     Pointer = ORG_Was_Start;//ORG_Was_Start
     MaxNum =  CMaxORG_Was_Start; 
     strcpyf(Data,"0");
     WriteData(1);  //PRG SHOW      
 } 
void WriteDataQty(char List)  //write data to eeprom
{
    int ind;           //+160
    char k;
    ind= List; 
    ind += Class*CMaxPrxyQtytRly1;
    ind *= MaxNum;
    ind += Pointer;
    for (k=0;k<MaxNum;k++){
         DataWriteEE(ind+k,1,&Data[k]);
    }
}
void ReadDataQty(char List)  //write data to eeprom
{
    int ind;           //+160
    char k;
    ind= List; 
    ind += Class*CMaxPrxyQtytRly1;
    ind *= MaxNum;
    ind += Pointer;
    for (k=0;k<MaxNum;k++){
         DataReadEE(ind+k,1,&Data[k]);
    }
}
void SIREN_PROCES(void)
{
   if(SugSound){
            switch(SugSound){
                case 1:
                   if(CounterSound > 970) SirenWith = (0x00C0);else
                   CounterSound = 1;
                break;
                case 2:
                   if(CounterSound > 900) SirenWith = (0x0280);else
                   CounterSound = 1;
                break;
                case 3:
                   if(CounterSound > 750) SirenWith = (0x0080);else
                   CounterSound = 1;
                break;
                case 4:
                   if(CounterSound > 980) SirenWith = (0x00C0);else
                   CounterSound = 1;
                break;
                case 5:
                   if(CounterSound > 985) SirenWith = 0x0080 + 12*7;else
                   if(CounterSound > 970) SirenWith = 0x0080 + 12*3;else
                   if(CounterSound > 955) SirenWith = 0x0080 + 12*7;else
                   if(CounterSound > 940) SirenWith = 0x0080 + 12*3;else
                   if(CounterSound > 925) SirenWith = 0x0080 + 12*7;else
                   if(CounterSound > 910) SirenWith = 0x0080 + 12*3;else
                   if(CounterSound > 895) SirenWith = 0x0080 + 12*7;else
                   CounterSound = 1;
                break;
                case 6:
                   if(CounterSound > 900) SirenWith = 0x0080 + 12*1;else
                   if(CounterSound > 800) SirenWith = 0x0080 + 12*5;else
                   if(CounterSound > 700) SirenWith = 0x0080 + 12*7;else
                   if(CounterSound > 600) SirenWith = 0x0080 + 12*3;else
                   if(CounterSound > 500) SirenWith = 0x0080 + 12*10;else
                   if(CounterSound > 400) SirenWith = 0x0080 + 12*7;else
                   if(CounterSound > 300) SirenWith = 0x0080 + 12*8;else
                   if(CounterSound > 200) SirenWith = 0x0080 + 12*4;else
                   if(CounterSound > 100) SirenWith = 0x0080 + 12*7;else
                   SirenWith = 0x0080 + 12*1;
                break;
                case 7:
                   if(CounterSound > 990) SirenWith = (0x00C0);else
                   CounterSound = 1;
                break;
            }
            SirenWith = SirenWith /3.2;
            OCR3AH = (SirenWith >> 8);
            OCR3AL = SirenWith;          }



       /*OCR3AH = (SirenWith >> 8);
       OCR3AL = SirenWith;
       if(SirenWith > 0x0100) ChangeSiren = -2;
       if(SirenWith < 0x0080) ChangeSiren = 1;
       */
}