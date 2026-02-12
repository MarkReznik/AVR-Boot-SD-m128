#define MESSAGE_1  5
#define MESSAGE_2  8

#define ADDRESS_MESSAGE_1   0x01F7  //WAS 1E9
#define ADDRESS_MESSAGE_2   0x0222 //WAS 2IF  LAST ADDRESS IS

#define TONE_RES    0
#define MODEM_RES   1
#define MOKED_RES   2

#define RX_BUFFER_SIZE1 250
#define TX_BUFFER_SIZE1 250
//Asaf

// USART1 Receiver buffer
extern char rx_buffer1[RX_BUFFER_SIZE1];
extern unsigned char rx_wr_index1, rx_rd_index1;
extern unsigned short Dsp_Connect_T;

// USART1 Transmitter buffer
extern char tx_buffer1[TX_BUFFER_SIZE1];
extern unsigned char tx_rd_index1,RingTime;

extern unsigned char  mConected, tConected;
//extern unsigned char TimeOut1, TimeConect;
extern unsigned int  Busy1;
extern unsigned char CountTel, CountMoked;   // number of telephon
extern unsigned char CycleDial;      // cycle of follow
extern unsigned char tUserCode[7], tCountCode;
extern unsigned char pStartEvent, pStopEvent;
extern unsigned char pStartMoked, pStartMoked_S;
extern unsigned char TrySendMoked, MaxTryMoked;
extern unsigned char DataMoked[20][2];
extern unsigned char pStrSpike[36];  // hp            // string of word to speak
extern unsigned int StrInt[8]; // hp             // string of word to speak
extern unsigned char dStr, nStr, MaxStr;
extern unsigned char EntStatus,NumMessage;
extern unsigned char NewSpike;
extern unsigned char Reset, StatusReset, TimeReset,ResetM_T;
extern unsigned char PhoneUp;
extern unsigned char PauseSpike,TimeSpike;
extern unsigned char CountPauseSpike, BitPauseSpike;//,PauseKey;
extern unsigned char StatusElement;
extern unsigned char SpikeKeybord, SaveBordSpiker;//,SpikePuls;
extern unsigned char Status_MD;
extern unsigned char CounterDisConect, FlagDisConect;
extern unsigned int TimeConectWithPC;
extern unsigned char FlagCallBack1 ,FlagCallBack2 ,CounterCallback;
extern unsigned char TimePress;
extern unsigned char CounterTone , FlagTone;
extern unsigned char IndexSM;
extern unsigned char TimeOutReset;
extern unsigned char CRings;
extern unsigned char TimeToneOut;
extern unsigned char FlagHoldLine;
extern unsigned char FlagEndOfMess,FlagCountEndOfMess;
extern unsigned char KeyTel, FlagTestKeyTel;
extern unsigned char FlagSpikeStatZone,Type456SelTel;
extern unsigned char FlagStatusTone,WaitTill_BusyTst;
extern unsigned int TimeConectedWithApp;
void SpikeIn(void);
void ToMokedOut(void);
//void ToTelephoneOut(void);
void TestTelephone(void);
void SetVoiceMode(void);
void VoiceMicMax(void);
void VoiceSpkMax(void);
void TestVolt(void);
void TestAvrg(void);

char ConectToMoked(char CountTelephon);
char SendDataToMoked(char ind);
char ConectToTel(char CountTelephon);
char tTestPassword(void);
char tTestCode(void);
char TestDialNeed(char Status);
void HoldLine(void);
void ReliseLine(void);
void Moked_DisConect(void);                        // Moked disconect
void CloseDialParameters(void);
char TestStatusZone(char Bit);
void Spiker(char Word);       // speak with
void ButtonSpike(char Key);
void tSpikeSystem(int* StrInt);
void StrSpike(char* Str,int StutLine);
char Map(char i);
void SpikeMessage(int Address,char Time);
void StopMessage(void);
void GetMessage(int Address);
void SpikeStatusSystem(char Word);
void SpikeStatusPuls(char Word);
void AnswerToRingModem(void);
void AnswerToRingTone(void);
void Spikenumber(char Key);
void DataFromPC(void);
char TestPassFromPC(char* str);
void FromComandToData(void);
void FromDataToComand(void);
void TelCallBack(void);
char ChecsamDataMoked(char*str,char ind);
void TestTelLine(void);
void ResetFunc(void);
void ResetFuncTone(void);
void ResetFuncModem(void);
void ResetFuncMoked(void);
char HexNum(char num);
int Hex(char num);
void DialToApp(char Pointer);
void AnswerToRingModem(void);





































