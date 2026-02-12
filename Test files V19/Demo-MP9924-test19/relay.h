
extern unsigned char RelaysOut[16];   
extern unsigned int LongRalay, Data_Rely, BiRelay;     
extern unsigned char CountR_RES_F, FlagR_RES_F;
extern unsigned char CountRelay;    
extern unsigned char FlagStartRelay,Wait_DoorOpen_Now;       
extern unsigned char CounterPauseRelay;
extern unsigned char QueRelay;
void SendToRelaySW(int Relay,char Num);
void SendToRelay(void);  // send data to relay     
void RelayOn(char Relay);                // 
void RelayOnZone(char ind);   
void RelayOff(void);
void RelayXOR(char Relay); 
void OpenDoorRelay(void);
void CloseDoorRelay(void);
void OpenDoorRelay2(void);
void CloseDoorRelay2(void);


extern unsigned char Call_Pulse,Snd_Relay,PxyCodeCnt;  // New 2.05 version change

