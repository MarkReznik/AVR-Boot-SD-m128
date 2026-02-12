


void StartE2E (void);
void StopEE (void);
void SetData(void);
void SetCLK(void);
void ClearCLK(void);
//void ClearData(void);
void DataReadEE(int Address,char Quntty,char* Data);
void DataWriteEE(int Address,char Quntty,char* Data); 
void PageStrWriteEE(int Address,char Quntty,char* Data); 
void PageWriteEE(int Address,char Quntty,char* Data); 
void PageStpWriteEE(int Address,char Quntty,char* Data); 


void DataReadPCF(char Address3,char Quntty,char* Data);
void DataWritePCF(char Address3,char Quntty,char* Data);
char ReceiveData(void);
void SendData(char Data);
void Delay(void);
void mocack (void);
void noack (void);
char fmack(void);
char fmackPCF(void);
void ClearAll(void);
void Delay(void); 