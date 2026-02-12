#include "FuncBit.h"
//DEL unsigned char ClearFirstBit(unsigned char Key)  // return byte with out first bit
//DEL {
//DEL   unsigned char Index = 1;
//DEL   while(!(Key & Index)&&(Index))
//DEL        Index = Index * 2;
//DEL   Key = Key &~Index;
//DEL   return(Key);    
//DEL }
unsigned char GetFirstBit(unsigned char Word)  // return number of first bit
{
  unsigned char Index = 1;
  unsigned char Ind = 0;
  if(Word)
  while(!(Word & Index)&&(Index))
  {
       Index*= 2;
       Ind++;
  }    
  return (Ind);
}
unsigned char GetBit(unsigned char Index)  // return byte with first bit up
{   
   unsigned char Shift = 0x01;
   Shift = Shift << Index;
   return(Shift);
}
void cpyBit(char* str1,char Bit1,char* str2,char Bit2)
{
    char ind;
    ClearBit(str1,Bit1);
    for(ind = 0;ind < 16;ind++)    
    
      if(str2[ind] & Bit2)
          str1[ind]|= Bit1;
       
} 
void ClearBit(char* str,char bit1)
{
    char ind;
    for(ind = 0;ind < 16;ind++)
      str[ind]&= ~bit1;
}