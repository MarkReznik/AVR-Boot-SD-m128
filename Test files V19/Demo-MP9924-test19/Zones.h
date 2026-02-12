extern unsigned char Zone[16];               // array for status of zones                    
extern unsigned char ZoneHelp[16];   
extern unsigned char bZoneType;       //if 1 Zone Always open
extern unsigned char HalfZone;     
extern unsigned char ValueSenset, Senset;        

void ZoneOpen(void);
void TestChime(char ind);
void EnterChameToZone(void);
void ReadZoneType(void);   
void ReadZoneSenset(void);
void EnterToStutA_S(void);
char TestWasActivate(void);
//char TestBypass(void);
void ToBypassZone(void);
char TestZonesType(void);
void ListZones(int StutLine1);   //  to list names of zones
char TestNotAlways(void);