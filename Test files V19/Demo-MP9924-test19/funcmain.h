//****************************** MAIN ********************
void StartFunc(void);  // start of program    
void StartToArm(void);
void ButtonMenu(void);  //  

         
char TestButton(void);
char TestDoor(char* code,char num);

void EnterNumber(void);    // to enter numbers
void EnterWord(void);      // to enter words
void FuncNumber(unsigned char Num,char* str);   // to add number to string  
void FuncNumberH(unsigned char Num,char* str);   // to add number to string 
//void ButtonFromPC(char* rx_buffer0);

void SendToKeybordSmart(void);
void SendDataToPC(void);         // send data to PC
void SendDataToKeybord(void);    // send data to keybord  
void SendDataToPIR(void);       // send data to PIR 
void SendDataToRPM(void);       // send data to RPM
void SendDataToCDR(void);        // send data to Coder  
void SendDataToTRM(void);       // send data to termo 
void SendDataToSHB(void);      // send data to shabat  
void SendDataToCLK(void);

void FuncESC(void);        // exit from 
void FuncSACB(void);
void ShotCutToMenu(char num);
void CaseFunc(void);
void StrLed(void);
void PawerUp(void);
void TestVolt(void);  

//*****************************  ZONES ******************
void ZoneOpen(void);
char TestZonesType(void);
void EnterChameToZone(void);  // to enter bit of chame to array of zone
void EnterToStutA_S(void);
char TestBypass(void);
//void Key_SA(char List); // enter to Stay or Awway; 
void ListZones(int StutLine1);
void ReadY_N(void );  // read Y/N Questions from eeprom
void StatusKeybordLed(void);  // Status of Leds for keybord withn't display
void TestChime(char ind);
//void WriteUnitData(void);
//void EnterUnitData(void);          // Test Key or Unit Data From KeyBord #8  
char TestCodeKey(char CodeKey);   // Test Code Of Key and Unit  
void ReadZoneType(void);          // enter type of zone to array DataType
//****************************** STING ********************

void String(unsigned int NumOfStr,char* str);
void StrFromEE(char* str);
void StrFrom_rx_buffer0(char* str);
void ClearString(char NextCode,char* Data,char MaxNum);  // clear string  
void SaveProxy(char NextCode,char* Data,char MaxNum);
void MoveBlank(char* str);
char GetWord(char Value, char Batton);
//char DisTimeCycle(char ind1, char ind2);

//*****************************  BIT, BYTE ********************


//************************* EEPROM ******************

void WritePage(char List);      // write data to eeprom
void WriteData(char List);      // write data to eeprom
void ReadData(char List);       // read data from eeprom

void WriteStatus_SAC(void);      // Save Byte of Stay, Away, Chime
void ReadStatus_SAC(void);      // Read Byte of Stay, Away, Chime
void DeleteUnits(void);
void ClearUnit(char List);


//*********************** TEST CODES ******************
unsigned char TestPassword(void);     //if password true get 1 else get 0
unsigned char EnterPassword(void);
char TestCode(void);                  //return 1 if  one from alls codes true
char TestRemoteCode(void);                  //return 1 if  one from alls codes true  
void WriteCountMadCode(void);         // write counter mad code to eeprom
void ReadCountMadCode(void);          // Read counter mad code from eeprom 
void EnterCode(void);                 // enter number of password
//char TestHaveCode(char num);      
//char TestCodeOfCoder(void);          
//**************************** SIREN ************** 
//void Siren_Start(void);
//void Siren_Stop(void);
//void StartChimeSiren(char Beep);
char TestActivate(char Num, char bitD);      // test activ. of siren 
//void SIREN_UP(char List);                    // start siren
//char ReturnTime(char Place);
void ToBypassZone(void);
void CaseEvent(char Type,char Code);
void WriteEvent(void);
void ReadEvent(void); 
void SIREN_PROCES(void);
void SIREN_ON(void);                     // turn on siren    
void SIREN_OFF(void);                    // turn off siren       
void STOP_ALL_SIREN(void);
void SendCloseZone(void);     
void WriteEventOfBypass(void);
void Time_Up(void);
//******************************* RELAY ****************

//void SendRelay(void); 
void Enable_RelayTime(void);

void Disable_RelayTime(void);


//*************************** MOKED *************************


//************** Zmani ****************  
void TestAnswerFromElement(void);
void TestAnswerFromPC(void);
void StartEE(void); 
void ClearRealTime(void); 
//void CopyDataFromPC(char* str1,char* str2,char max);

char ReturnNamePointer(char ListName);  
void OrderName(void); 
void OrderNameRead(void);        
char TestString(char* str1,char* str2,char count1,char count2);  
void cpyString(char* str1,char* str2,char num);
char BlankStr(char* str); 
char GetRelay(char name);
void SendToLCD(char* str1,char* str2,char* str3,char* str4);
void Siren_Start(char Sug);
void Siren_Stop(void);
void SIREN_PROCES(void);
void  Make_20ms_Reset(void);
void WriteDataQty(char List); 
void ReadDataQty(char List);
void ArrangPrxy1(void);
void ArrangPrxy2(void); 
void Clear_ORG_Was_Start(void);