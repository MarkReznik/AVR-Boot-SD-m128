#ifndef COMMON_H
#define COMMON_H

//#define PRINT_LCD   1
//#define DEBUG_PROTEUS   1
//#define PRINT_LCD_DEBUG   1

#define PETITFATFS  1
#define USART_SPI 1
#define MAX_FOLDERS 100
#ifndef  USART_SPI
//#define PRINT_DEBUG  1
#endif

#define LCD_MSG_DELAY 0
#define LCD_MSG_SHORT_DELAY 600
#define LCD_MSG_LONG_DELAY 600
#ifdef  PRINT_LCD
//#define DEBUG_BUTTONS   1
//#define DEBUG_BUTTONS1   1
#else 
#define   SEG7  1
#endif

#include <mega328p.h>
//#include <mega64.h>
#ifdef PRINT_LCD
#include <alcd.h>
#include <stdlib.h>
#endif
#include <stdio.h>
// Standard Input/Output functions
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "integer.h"
#include "avr910.h"
#include <delay.h>
#include "mycode.h"
#include "mysdcard.h"

//#define PRINT_DELAY_MS  500

/*ADC defines*/
enum
{   BUTTONS_RELEASED=0,
    BUTTON_START,
    BUTTON_STOP,
    BUTTON_UP,
    BUTTON_DOWN,
    BUTTONS_PRESSED
};//Buttons;

/* Timer1 overflow interrupt frequency [Hz] */
#define T1_OVF_FREQ 2000
/* Timer1 clock prescaler value */
#define T1_PRESC 64//1024L
/* Timer1 initialization value after overflow */
#define T1_INIT (0x10000L-(_MCU_CLOCK_FREQUENCY_/(T1_PRESC*T1_OVF_FREQ)))
/* 100Hz timer interrupt generated by ATmega128 Timer1 overflow */
//ovf_freq 1Hz
//presc 1024
//init= 0x10000-(12,000,000/1,024*1)
extern unsigned char tx_counter;
extern volatile unsigned char    CanBeep;
extern volatile unsigned char    StopEvent;
extern unsigned char    DoTone;
extern unsigned char    DoTimes;
extern unsigned char    DoTypeLength;


void StartButtonAction(void);
void UpButtonAction(void);
void StopButtonAction(void);
void DownButtonAction(void);
unsigned char TestButton(UCHAR bt);
unsigned char TestADCs();
//void TestBeeps(void);
void Beeps(UCHAR tone,UCHAR times,int type_length);
void DoBeeps(UCHAR tone,UCHAR times,int type_length);



#ifdef PRINT_LCD
extern char lcdnum[];
extern UCHAR CanTestButtons;

UCHAR lcd_GetProgName(UCHAR row);
void lcd_putsf_row(UCHAR row,flash char *str);
void lcd_putsf_row3(UCHAR row,flash char *str);
void lcd_puts_row(UCHAR row,char *str);
void lcd_puts_hex(UCHAR hexnum);
#endif
#ifdef SEG7 //7 segment
void init7seg(void);
void show7seg(char num);
#endif

#endif