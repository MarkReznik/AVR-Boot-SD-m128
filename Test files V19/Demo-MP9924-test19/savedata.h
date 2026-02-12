void WriteStatusLeds(void);         // Read status of Stay & Away to eeprom
void ReadStatusLeds(void);          // write status of Stay & Away to eeprom
void WriteStatus_SAC(void);         // Read status of Stay & Away to eeprom
void ReadStatus_SAC(void);          // write status of Stay & Away to eeprom
void WriteCountMadCode(void);       // write counter mad code to eeprom
void ReadCountMadCode(void);        // Read counter mad code from eeprom
void WriteActivate(void);           // write bit of Activate
void ReadActivate(void);            // read bit of Activate
void WriteBypass(void);            // write bit of bypass
void ReadBypass(void);             // read bit of bypass   
void WriteValueCycle(void);        // Write cycle of sirens
void ReadValueCycle(void);        // Read cycle of sirens
void ReadY_N(void);                 // return y/n ques. from eeprom(Y/N QUES.)
void ReadEventLevel(void);         // read  EventLevel from eeprom
void ReadCountRings(void);         // read  count of rings