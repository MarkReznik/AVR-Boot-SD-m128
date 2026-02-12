 //2L-Version!!!


  #include "I2C64.h"
  #include <io.h> // hp
  #include "elegant.h" // hp

void StartE2E (void)
{
   PORTD=PORTD | 0x2;
   PORTD=PORTD | 0x1;
   Delay ();
   PORTD=PORTD &~0x2;
   Delay ();
   PORTD=PORTD &~ 0x1;
}
void StopEE (void)
{
   PORTD=PORTD &~0x2;
   Delay ();
   PORTD=PORTD | 0x1;
   Delay ();
   PORTD=PORTD | 0x2;
   Delay ();
   PORTD=PORTD &~ 0x1;
}
char fmack(void)
{
   char Result;

   //PORTD = PORTD | 0x2;         // for scop -set mark
   PORTD = PORTD | 0x2;         // SET DATA
   DDRD = DDRD &~0x2;      // change data pin to input
   Delay ();
   PORTD = PORTD | 0x1;         // SET CLK
   Delay ();
   Delay ();
   Result = PIND & 0x2;
   if(Result)
         Result = PIND & 0x2;
   PORTD = PORTD &~ 0x1;       // CLEAT CLK
   Delay ();
   DDRD = DDRD | 0x2;       // change data pin to output
   PORTD = PORTD &~0x2;         // CLR DATA
   //PORTD = PORTD &~0x2;         //for scop - CLR mark
   Delay ();


   return (!Result);
}
char fmackPCF(void)
{
   char Result;

//PORTD = PORTD | 0x2;         // for scop -set mark
   PORTD = PORTD | 0x2;         // SET DATA
   DDRD = DDRD &~0x2;      // change data pin to input
   Delay ();
   PORTD = PORTD | 0x1;         // SET CLK
   Delay ();
   Result = PIND & 0x2;
   if(Result)
         Result = PIND & 0x2;
   PORTD = PORTD &~ 0x1;       // CLEAT CLK
   Delay ();
   DDRD = DDRD | 0x2;       // change data pin to output
   PORTD = PORTD &~0x2;         // CLR DATA

//PORTD = PORTD &~0x2;         //for scop - CLR mark
   Delay ();


   return (!Result);
}
void DataReadPCF(char Address3,char Quntty,char* Data)
{
//2L-Version!!!
 
//  char i;
//  char Address1;
//  Address1=Address3&0xf;   
//
//       do
//       {
//         do{
////PORTD = PORTD &~0x2;         //for scop - CLR mark
//             StopEE();
//             StartE2E();
//             SendData(0xa2);  // a2 for PCF
////PORTD |= 0x2;         //for scop - CLR mark
//           }while(!fmackPCF());
////PORTD = PORTD &~0x2;         //for scop - CLR mark
//           SendData(Address1);
//       }while(!fmackPCF());
//  do
//  {
//    StartE2E();
//    SendData(0xa3);// a3 for PCF
//  }while(!fmackPCF());
//
//  for(i=0;i<Quntty-1;i++)
//  {
//    #asm("WDR");
//    Data[i] = ReceiveData();
//    Data[i+1] = 0;     // limit the string len to max 16 if number is 16 digit
//    //*********** moak **********
//    PORTD=PORTD &~0x2;
//    PORTD=PORTD | 0x1;
//    Delay ();
//    PORTD=PORTD &~ 0x1;
//    //****************************
//  }
//  Data[i] = ReceiveData();
//  //************ noak *********
//  PORTD=PORTD | 0x2;
//  PORTD=PORTD | 0x1;
//  Delay ();
//  PORTD=PORTD &~ 0x1;
//  //**************************
//  StopEE(); 
  
}


void DataReadEE(int Address,char Quntty,char* Data)
{
  char i;
  char Address1;
  char Address2;

  Address1 = Address>>8;
  Address2 = Address;
  do
  {
       do
       {
         do{

             StopEE();
             StartE2E();
             SendData(0xa0);  // a0 for 000 a8 for 100
           }while(!fmack());
           SendData(Address1);
       }while(!fmack());
        SendData(Address2);
  }while(!fmack());
  do
  {
    StartE2E();
    SendData(0xa1);// a1 for 000 a9 for 100
  }while(!fmack());

  for(i=0;i<Quntty-1;i++)
  {
    #asm("WDR");
    Data[i] = ReceiveData();
    Data[i+1] = 0;     // limit the string len to max 16 if number is 16 digit
    //*********** moak **********
    PORTD=PORTD &~0x2;
    PORTD=PORTD | 0x1;
    Delay ();
    PORTD=PORTD &~ 0x1;
    //****************************
  }
  Data[i] = ReceiveData();
  //************ noak *********
  PORTD=PORTD | 0x2;
  PORTD=PORTD | 0x1;
  Delay ();
  PORTD=PORTD &~ 0x1;
  //**************************
  StopEE();
}
char ReceiveData(void)
{
  unsigned char i,Result;

  Result = 0;

  for (i = 0;i < 8;i++)	// each bit at a time , MSB first
  {

     PORTD = PORTD | 0x2;         // set data
     DDRD = DDRD &~0x2;      // change data pin to input
     Delay ();
     PORTD = PORTD | 0x1;         // SET CLK
     Delay ();
     Result<<= 1;

     Delay ();
     if(PIND & 0x2)
	      Result|= 0X01;
     PORTD = PORTD &~ 0x1;       // CLEAT CLK
     Delay ();
     DDRD = DDRD | 0x2;      // change data pin to output
     PORTD = PORTD &~0x2;         // clear data
     Delay ();
  }

  return(Result);
}
void SendData(char Data)
{
   unsigned char i;
   char Bit = 0;
   Delay ();
   for (i = 0; i < 8; i++)
    {

     if (Data & 0x80) PORTD |=0x2;	// send each bit , MSB first
   	    else PORTD = PORTD&~0x2;
   	  Delay ();
   	 PORTD=PORTD | 0x1;
   	  Delay ();
   	 PORTD=PORTD &~0x1;
   	  Delay ();
     Data = Data << 1;
 }
}
void Delay(void)
{
     #asm(" NOP ");
     //#asm(" NOP ");
    // #asm(" NOP ");
    // #asm(" NOP ");
    // #asm(" NOP ");
   }
void DataWritePCF(char Address3,char Quntty,char* Data)
{
//2L-Version!!!
//  char i;
//  char Address1;
//  Address1=Address3&0xf;  
//
//     do
//       {
//         do{
//             StopEE();
//             StartE2E();
//             SendData(0xa2);// a2 for PCF
//           }while(!fmackPCF());
//           SendData(Address1);
//       }while(!fmackPCF());
//
//
//  for(i=0;i<Quntty;i++)
//  {
//    #asm("WDR");
//    SendData(Data[i]);
//    while(!fmackPCF()){};
//  }
//  StopEE();
}

void DataWriteEE(int Address,char Quntty,char* Data)
{
  char i;
  char Address1;
  char Address2;
  Address1 = Address>>8;
  Address2 = Address;

  do
  {
     do
       {
         do{
             StopEE();
             StartE2E();
             SendData(0xa0);// a0 for 000 a8 for 100
           }while(!fmack());
           SendData(Address1);
       }while(!fmack());
       SendData(Address2);
  }while(!fmack());

  for(i=0;i<Quntty;i++)
  {
    #asm("WDR");
    SendData(Data[i]);
    while(!fmack()){};
  }
  StopEE();
}
void PageStrWriteEE(int Address,char Quntty,char* Data)
{
  char i;
  char Address1;
  char Address2;
  Address1 = Address>>8;
  Address2 = Address;


  do
  {
     do
       {
         do{
             StopEE();
             StartE2E();
             SendData(0xa0);// a0 for 000 a8 for 100
           }while(!fmack());
           SendData(Address1);
       }while(!fmack());
       SendData(Address2);
  }while(!fmack());

  for(i=0;i<Quntty;i++)
  {
    #asm("WDR");
    SendData(Data[i]);
    while(!fmack()){};
  }
}
void PageWriteEE(int Address,char Quntty,char* Data)
{
  char i;
  char Address1;
  char Address2;

  for(i=0;i<Quntty;i++)
  {
    #asm("WDR");
    SendData(Data[i]);
    while(!fmack()){};
  }
}
void PageStpWriteEE(int Address,char Quntty,char* Data)
{
  char i;
  char Address1;
  char Address2;

  for(i=0;i<Quntty;i++)
  {
    #asm("WDR");
    SendData(Data[i]);
    while(!fmack()){};
  }
  StopEE();
}

void ClearAll(void)
{
   int i;
   Data[0] =0;
   for(i = 0;i<8180;i+=16)
   {
      DataWriteEE(i,16,Data);
   }

}








