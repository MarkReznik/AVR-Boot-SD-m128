extern unsigned char  TimeHour, TimeMin, TimeSec;
extern unsigned char CounterTime, SaveTimeMin,SaveTimeHour,SaveDayWeek; 
extern unsigned char Year, Month, Day, DayWeek;      
extern unsigned char ChangeDate, ChangeTimeDate, ChangeDisTime;
extern unsigned char PauseChTime, PauseTimeFlag;
extern unsigned char EnteredTime;

void DisplayTime(char *str);  
void DisplayDate(char *str);   
void DisplaySecond(char *str);   
void DisplayTimeDate(char *str);  
void DisplayDayWeek(char *str);
void Data_Change(void);  
void Write_Date(void);
void Read_Date(void); 
void ToZeroTime(void); 
void Read_Time(void);
char EnterDateTime(char Button,char NextCode);