extern unsigned char ListEvent;       // max events
extern unsigned char ZoneEvent;    // if Type ARM or DIS code, else zone
extern unsigned char ChangeDisEvent;  
extern unsigned char EventLevel, FlagEventCycle;
   
void Display_Event(char *str,char ch);
void CaseEvent(char Type,char NumCode);
void WriteEvent(void);
void ReadEvent(void);