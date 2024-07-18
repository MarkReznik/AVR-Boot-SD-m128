
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Medium
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1124 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_MEDIUM_

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0464
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __GETBRPF
	OUT  RAMPZ,R22
	ELPM R@0,Z
	.ENDM

	.MACRO __GETBRPF_INC
	OUT  RAMPZ,R22
	ELPM R@0,Z+
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF ___AddrToZ24WordToR1R0ByteToSPMCR_SPM_F=R4
	.DEF ___AddrToZ24WordToR1R0ByteToSPMCR_SPM_F_msb=R5
	.DEF ___AddrToZ24ByteToSPMCR_SPM_W=R6
	.DEF ___AddrToZ24ByteToSPMCR_SPM_W_msb=R7
	.DEF ___AddrToZ24ByteToSPMCR_SPM_E=R8
	.DEF ___AddrToZ24ByteToSPMCR_SPM_E_msb=R9
	.DEF ___AddrToZ24ByteToSPMCR_SPM_EW=R10
	.DEF ___AddrToZ24ByteToSPMCR_SPM_EW_msb=R11

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0xDB,0xF9,0xEB,0xF9
	.DB  0xB,0xFA,0x2B,0xFA


__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DD  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
	LDI  R29,BYTE3(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	OUT  RAMPZ,R29
	ELPM R24,Z+
	ELPM R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	ELPM R26,Z+
	ELPM R27,Z+
	ELPM R0,Z+
	ELPM R1,Z+
	ELPM R28,Z+
	ELPM R29,Z+
	MOVW R22,R30
	IN   R29,RAMPZ
	MOVW R30,R0
	OUT  RAMPZ,R28
__GLOBAL_INI_LOOP:
	ELPM R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x564

	.CSEG
;// This file has been prepared for Doxygen automatic documentation generation.
;/*! \file ********************************************************************
;*
;* Atmel Corporation
;*
;* - File              : Self_programming_main.c
;* - Compiler          : IAR EWAVR 2.28a / 3.10c and newer
;*
;* - Support mail      : avr@atmel.com
;*
;* - Supported devices : This example is written for ATmega128.
;*
;* - AppNote           : AVR106 - C functions for reading and writing
;*                       to flash memory.
;*
;* - Description       : The file contains an example program using the Flash R/W
;*                       functions provided with the files Self_programming.h /
;*                       Self_programming.c . The program should be compiled using
;*                       a linker file (*.xcl) that is configured to place the
;*                       entire program code into the Boot section of the Flash memory.
;*                       Please refer to the application note document for more
;*                       information.
;*
;* $Revision: 2.0 $
;* $Date: Wednesday, January 18, 2006 15:18:52 UTC $
;*
;*****************************************************************************/
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include "Self_programming.h"
;
;void main( void ){
; 0000 0020 void main( void ){

	.CSEG
_main:
; .FSTART _main
; 0000 0021   unsigned char testBuffer1[PAGESIZE];      // Declares variables for testing
; 0000 0022   //unsigned char testBuffer2[PAGESIZE];      // Note. Each array uses PAGESIZE bytes of
; 0000 0023                                             // code stack
; 0000 0024   static unsigned char testChar; // A warning will come saying that this var is set but never used. Ignore it.
; 0000 0025   int index;
; 0000 0026   DDRC=0xFF;
	SUBI R29,1
;	testBuffer1 -> Y+0
;	index -> R16,R17
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0027   PORTC=0xFF;
	OUT  0x15,R30
; 0000 0028 
; 0000 0029   for(index=0; index<PAGESIZE; index++){
	__GETWRN 16,17,0
_0x4:
	__CPWRN 16,17,256
	BRGE _0x5
; 0000 002A     testBuffer1[index]=index;//(unsigned char)0xFF; // Fills testBuffer1 with values FF
	MOVW R30,R16
	MOVW R26,R28
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R16
; 0000 002B   }
	__ADDWRN 16,17,1
	RJMP _0x4
_0x5:
; 0000 002C   if(WriteFlashBytes(0x2, testBuffer1,PAGESIZE)){     // Writes testbuffer1 to Flash page 2
	RCALL SUBOPT_0x0
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(256)
	LDI  R27,HIGH(256)
	RCALL _WriteFlashBytes
	CPI  R30,0
	BREQ _0x6
; 0000 002D     PORTC.2=0;
	CBI  0x15,2
; 0000 002E   }                                            // Same as byte 4 on page 2
; 0000 002F   //MCUCR &= ~(1<<IVSEL);
; 0000 0030   ReadFlashBytes(0x2,&testChar,1);        // Reads back value from address 0x204
_0x6:
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
; 0000 0031   if(testChar==0x00)
	LDS  R30,_testChar_S0000000000
	CPI  R30,0
	BRNE _0x9
; 0000 0032   {
; 0000 0033       ReadFlashBytes(0x3,&testChar,1);        // Reads back value from address 0x204
	__GETD1N 0x3
	RCALL SUBOPT_0x2
; 0000 0034       if(testChar==0x01)
	LDS  R26,_testChar_S0000000000
	CPI  R26,LOW(0x1)
	BRNE _0xA
; 0000 0035         ReadFlashBytes(0x100,&testChar,1);        // Reads back value from address 0x204
	__GETD1N 0x100
	RCALL SUBOPT_0x2
; 0000 0036         if(testChar==0xFE)
_0xA:
	LDS  R26,_testChar_S0000000000
	CPI  R26,LOW(0xFE)
	BRNE _0xB
; 0000 0037             ReadFlashBytes(0x101,&testChar,1);        // Reads back value from address 0x204
	__GETD1N 0x101
	RCALL SUBOPT_0x2
; 0000 0038             if(testChar==0xFF)
_0xB:
	LDS  R26,_testChar_S0000000000
	CPI  R26,LOW(0xFF)
	BRNE _0xC
; 0000 0039               while(1)
_0xD:
; 0000 003A               {
; 0000 003B                   PORTC.0=0;
	CBI  0x15,0
; 0000 003C                   delay_ms(500);
	RCALL SUBOPT_0x3
; 0000 003D                   PORTC.0=1;
	SBI  0x15,0
; 0000 003E                   delay_ms(500);
	RCALL SUBOPT_0x3
; 0000 003F               }
	RJMP _0xD
; 0000 0040   }
_0xC:
; 0000 0041 
; 0000 0042   while(1)
_0x9:
_0x14:
; 0000 0043   {
; 0000 0044       PORTC.1=0;
	CBI  0x15,1
; 0000 0045       delay_ms(500);
	RCALL SUBOPT_0x3
; 0000 0046       PORTC.1=1;
	SBI  0x15,1
; 0000 0047       delay_ms(500);
	RCALL SUBOPT_0x3
; 0000 0048   }
	RJMP _0x14
; 0000 0049   //}
; 0000 004A }
_0x1B:
	RJMP _0x1B
; .FEND
;// This file has been prepared for Doxygen automatic documentation generation.
;/*! \file ********************************************************************
;*
;* Atmel Corporation
;*
;* - File              : Self_programming.c
;* - Compiler          : IAR EWAVR 2.28a / 3.10c and newer
;*
;* - Support mail      : avr@atmel.com
;*
;* - Supported devices : All devices with bootloaders support.
;*
;* - AppNote           : AVR106 - C functions for reading and writing
;*                       to flash memory.
;*
;* - Description       : The file contains functions for easy reading and writing
;*                       of Flash memory on parts having the "Self-programming"
;*                       feature. The user functions are as follows:
;*
;*                       ReadFlashByte()
;*                       ReadFlashPage()
;*                       WriteFlashByte()
;*                       WriteFlashPage()
;*                       RecoverFlash()
;*
;*                       The remaining functions contained in this file are used
;*                       by the functions listet above.
;*
;* $Revision: 2.0 $
;* $Date: Wednesday, January 18, 2006 15:18:52 UTC $
;*
;****************************************************************************/
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;//#include <inavr.h>
;#include "Self_programming.h"
;//#include "flash.h"
;
;void (*__AddrToZ24WordToR1R0ByteToSPMCR_SPM_F)(void flash * addr, unsigned int data)= (void(*)(void flash *, unsigned in ...
;void (*__AddrToZ24ByteToSPMCR_SPM_W)(void flash * addr)= (void(*)(void flash *)) 0x0F9EB;
;void (*__AddrToZ24ByteToSPMCR_SPM_E)(void flash * addr)= (void(*)(void flash *)) 0x0FA0B;
;void (*__AddrToZ24ByteToSPMCR_SPM_EW)(void flash * addr)= (void(*)(void flash *)) 0x0FA2B;
;
;/*!
;* Declare global struct variable in EEPROM if Flash recovery enabled.
;* FlashBackup pageNumber holds Flash pageaddress (/PAGESIZE) the data in Flash
;* recovery buffer should be written to if data need to be recovered.
;* FlashBackup.status tells if data need to be recovered.
;**/
;#ifdef __FLASH_RECOVER
;__eeprom struct {
;  unsigned int  pageNumber;
;  unsigned char status;
;}FlashBackup = {0};
;#endif
;
;__eeprom struct {
;  unsigned long  flashStartAdr;
;  unsigned int length;
;  unsigned char status;//0=already moved to flash, 1=not moved to flash yet
;  unsigned char data[PAGESIZE];
;}_EepromBackup @10;
;
;/*!
;* The function Returns one byte located on Flash address given by ucFlashStartAdr.
;**/
;unsigned char ReadFlashByte(MyAddressType flashStartAdr){
; 0001 0042 unsigned char ReadFlashByte(MyAddressType flashStartAdr){

	.CSEG
_ReadFlashByte:
; .FSTART _ReadFlashByte
; 0001 0043 //#pragma diag_suppress=Pe1053 // Suppress warning for conversion from long-type address to flash ptr.
; 0001 0044   flashStartAdr;//+=ADR_LIMIT_LOW;
	CALL __PUTPARD2
;	flashStartAdr -> Y+0
	RCALL SUBOPT_0x4
; 0001 0045   return (unsigned char)*((MyFlashCharPointer)flashStartAdr);
	RCALL SUBOPT_0x4
	__GETBRPF 30
	RJMP _0x2000001
; 0001 0046 //#pragma diag_default=Pe1053 // Back to default.
; 0001 0047 } // Returns data from Flash
; .FEND
;
;/*!
;* The function reads one Flash page from address flashStartAdr and stores data
;* in array dataPage[]. The number of bytes stored is depending upon the
;* Flash page size. The function returns FALSE if input address is not a Flash
;* page address, else TRUE.
;**/
;unsigned char ReadFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage){
; 0001 004F unsigned char ReadFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage){
_ReadFlashPage:
; .FSTART _ReadFlashPage
; 0001 0050   unsigned int index;
; 0001 0051   flashStartAdr;//+=ADR_LIMIT_LOW;
	RCALL SUBOPT_0x5
;	flashStartAdr -> Y+4
;	*dataPage -> Y+2
;	index -> R16,R17
	RCALL SUBOPT_0x6
; 0001 0052   if(!(flashStartAdr & (PAGESIZE-1))){      // If input address is a page address
	RCALL SUBOPT_0x6
	CPI  R30,0
	BRNE _0x20003
; 0001 0053     for(index = 0; index < PAGESIZE; index++){
	__GETWRN 16,17,0
_0x20005:
	__CPWRN 16,17,256
	BRSH _0x20006
; 0001 0054       dataPage[index] = ReadFlashByte(flashStartAdr + index);
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x7
	POP  R26
	POP  R27
	ST   X,R30
; 0001 0055     }
	__ADDWRN 16,17,1
	RJMP _0x20005
_0x20006:
; 0001 0056     return TRUE;                            // Return TRUE if valid page address
	LDI  R30,LOW(1)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2000002
; 0001 0057   }
; 0001 0058   else{
_0x20003:
; 0001 0059     return FALSE;                           // Return FALSE if not valid page address
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2000002
; 0001 005A   }
; 0001 005B }
; .FEND
;unsigned char ReadFlashBytes(MyAddressType flashStartAdr, unsigned char *dataPage, unsigned int length){
; 0001 005C unsigned char ReadFlashBytes(MyAddressType flashStartAdr, unsigned char *dataPage, unsigned int length){
_ReadFlashBytes:
; .FSTART _ReadFlashBytes
; 0001 005D   	unsigned int index;
; 0001 005E   	flashStartAdr+=ADR_LIMIT_LOW;
	RCALL SUBOPT_0x5
;	flashStartAdr -> Y+6
;	*dataPage -> Y+4
;	length -> Y+2
;	index -> R16,R17
	__GETD1S 6
	__ADDD1N 57344
	__PUTD1S 6
; 0001 005F     for(index = 0; index < length; index++){
	__GETWRN 16,17,0
_0x20009:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x2000A
; 0001 0060       dataPage[index] = ReadFlashByte(flashStartAdr + index);
	MOVW R30,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOVW R30,R16
	__GETD2S 6
	CLR  R22
	CLR  R23
	CALL __ADDD21
	RCALL _ReadFlashByte
	POP  R26
	POP  R27
	ST   X,R30
; 0001 0061     }
	__ADDWRN 16,17,1
	RJMP _0x20009
_0x2000A:
; 0001 0062     return TRUE;                            // Return TRUE if valid page address
	LDI  R30,LOW(1)
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
; 0001 0063 }
; .FEND
;unsigned char VerifyFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage){
; 0001 0064 unsigned char VerifyFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage){
_VerifyFlashPage:
; .FSTART _VerifyFlashPage
; 0001 0065   unsigned int index;
; 0001 0066   if(!(flashStartAdr & (PAGESIZE-1))){      // If input address is a page address
	RCALL SUBOPT_0x5
;	flashStartAdr -> Y+4
;	*dataPage -> Y+2
;	index -> R16,R17
	RCALL SUBOPT_0x6
	CPI  R30,0
	BRNE _0x2000B
; 0001 0067     for(index = 0; index < PAGESIZE; index++){
	__GETWRN 16,17,0
_0x2000D:
	__CPWRN 16,17,256
	BRSH _0x2000E
; 0001 0068       if(dataPage[index] != ReadFlashByte(flashStartAdr + index))
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	PUSH R30
	RCALL SUBOPT_0x7
	POP  R26
	CP   R30,R26
	BREQ _0x2000F
; 0001 0069       {
; 0001 006A         PORTC.6=0;
	CBI  0x15,6
; 0001 006B         return FALSE;
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2000002
; 0001 006C       }
; 0001 006D     }
_0x2000F:
	__ADDWRN 16,17,1
	RJMP _0x2000D
_0x2000E:
; 0001 006E     return TRUE;                            // Return TRUE if valid page address
	LDI  R30,LOW(1)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2000002
; 0001 006F   }
; 0001 0070   else{
_0x2000B:
; 0001 0071     PORTC.7=0;
	CBI  0x15,7
; 0001 0072     return FALSE;                           // Return FALSE if not valid page address
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2000002
; 0001 0073   }
; 0001 0074 }
; .FEND
;unsigned char WriteFlashBytes(MyAddressType flashAdr, unsigned char *data, unsigned int length)
; 0001 0076 {
_WriteFlashBytes:
; .FSTART _WriteFlashBytes
; 0001 0077     unsigned char tempBuffer[PAGESIZE];
; 0001 0078     MyAddressType flashAdrStart,flashAdrNext;
; 0001 0079     unsigned int lengthStart,lengthIndex;                //length=0x20
; 0001 007A     while(length)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,8
	SUBI R29,1
	CALL __SAVELOCR4
;	flashAdr -> Y+272
;	*data -> Y+270
;	length -> Y+268
;	tempBuffer -> Y+12
;	flashAdrStart -> Y+8
;	flashAdrNext -> Y+4
;	lengthStart -> R16,R17
;	lengthIndex -> R18,R19
_0x20015:
	RCALL SUBOPT_0x8
	SBIW R30,0
	BRNE PC+2
	RJMP _0x20017
; 0001 007B     {
; 0001 007C         flashAdrStart= flashAdr-(flashAdr%PAGESIZE);//0x1F0-(0x1F0%0x100)=0x0100                        //
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
	CALL __SUBD21
	__PUTD2S 8
; 0001 007D         flashAdrNext = flashAdrStart+PAGESIZE;          //0x0100+0x100=0x200
	RCALL SUBOPT_0xB
	__ADDD1N 256
	__PUTD1S 4
; 0001 007E         if((flashAdrNext - flashAdr) >= length)    //enough space case
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x6
	CALL __SUBD12
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x8
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRLO _0x20018
; 0001 007F         {
; 0001 0080            lengthStart=length;
	__GETWRSX 16,17,268
; 0001 0081            length=0;
	LDI  R30,LOW(0)
	__CLRW1SX 268
; 0001 0082         }
; 0001 0083         else                                   //(0x200-0x1F0)<0x20
	RJMP _0x20019
_0x20018:
; 0001 0084         {
; 0001 0085            lengthStart=(flashAdrNext - flashAdr);        //len1=0x200-0x1F0=0x10
	__GETW2SX 272
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
; 0001 0086            length-=lengthStart;                         //len2=0x20-0x10=0x10
	RCALL SUBOPT_0x8
	SUB  R30,R16
	SBC  R31,R17
	__PUTW1SX 268
; 0001 0087         }
_0x20019:
; 0001 0088         if(ReadFlashPage(flashAdrStart,tempBuffer)==FALSE) //read flash page to tempBuffer
	RCALL SUBOPT_0xB
	CALL __PUTPARD1
	MOVW R26,R28
	ADIW R26,16
	RCALL _ReadFlashPage
	CPI  R30,0
	BRNE _0x2001A
; 0001 0089         {
; 0001 008A             PORTC.3=0;
	CBI  0x15,3
; 0001 008B             return FALSE;
	LDI  R30,LOW(0)
	RJMP _0x2000004
; 0001 008C         }
; 0001 008D         for(lengthIndex=(flashAdr%PAGESIZE);lengthIndex<((flashAdr%PAGESIZE)+lengthStart);lengthIndex++)
_0x2001A:
	__GETW1SX 272
	ANDI R31,HIGH(0xFF)
	MOVW R18,R30
_0x2001E:
	RCALL SUBOPT_0x9
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R16
	CLR  R22
	CLR  R23
	CALL __ADDD12
	MOVW R26,R18
	CLR  R24
	CLR  R25
	CALL __CPD21
	BRSH _0x2001F
; 0001 008E         {
; 0001 008F             tempBuffer[lengthIndex]=*data++;
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,12
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R26,R28
	SUBI R26,LOW(-(270))
	SBCI R27,HIGH(-(270))
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LD   R30,Z
	MOVW R26,R0
	ST   X,R30
; 0001 0090         }
	__ADDWRN 18,19,1
	RJMP _0x2001E
_0x2001F:
; 0001 0091         flashAdr=flashAdrNext;
	RCALL SUBOPT_0x6
	__PUTD1SX 272
; 0001 0092         if(WriteFlashPage(flashAdrStart+ADR_LIMIT_LOW,tempBuffer)==FALSE) //write tempBuffer to flash page
	RCALL SUBOPT_0xB
	__ADDD1N 57344
	CALL __PUTPARD1
	MOVW R26,R28
	ADIW R26,16
	RCALL _WriteFlashPage
	CPI  R30,0
	BRNE _0x20020
; 0001 0093         {
; 0001 0094             PORTC.4=0;
	CBI  0x15,4
; 0001 0095             return FALSE;
	LDI  R30,LOW(0)
	RJMP _0x2000004
; 0001 0096         }
; 0001 0097     }
_0x20020:
	RJMP _0x20015
_0x20017:
; 0001 0098     return TRUE;
	LDI  R30,LOW(1)
_0x2000004:
	CALL __LOADLOCR4
	ADIW R28,20
	SUBI R29,-1
	RET
; 0001 0099 }
; .FEND
;
;/*!
;* The function writes byte data to Flash address flashAddr. Returns FALSE if
;* input address is not valid Flash byte address for writing, else TRUE.
;**/
;unsigned char WriteFlashByte(MyAddressType flashAddr, unsigned char data){
; 0001 009F unsigned char WriteFlashByte(MyAddressType flashAddr, unsigned char data){
; 0001 00A0   MyAddressType  pageAdr;
; 0001 00A1   unsigned char eepromInterruptSettings,saveSREG;
; 0001 00A2   flashAddr+=ADR_LIMIT_LOW;
;	flashAddr -> Y+7
;	data -> Y+6
;	pageAdr -> Y+2
;	eepromInterruptSettings -> R17
;	saveSREG -> R16
; 0001 00A3   if( AddressCheck( flashAddr & ~(PAGESIZE-1) )){
; 0001 00A4 
; 0001 00A5     if(ReadFlashByte(flashAddr)==data)
; 0001 00A6     {
; 0001 00A7         PORTC.4=0;
; 0001 00A8         return TRUE;
; 0001 00A9     }
; 0001 00AA     eepromInterruptSettings= EECR & (1<<EERIE); // Stores EEPROM interrupt mask
; 0001 00AB     EECR &= ~(1<<EERIE);                    // Disable EEPROM interrupt
; 0001 00AC     while(EECR & (1<<EEWE));                // Wait if ongoing EEPROM write
; 0001 00AD     saveSREG=SREG;
; 0001 00AE     #asm("cli")
; 0001 00AF     pageAdr=flashAddr & ~(PAGESIZE-1);      // Gets Flash page address from byte address
; 0001 00B0 
; 0001 00B1     #ifdef __FLASH_RECOVER
; 0001 00B2     FlashBackup.status=0;                   // Inicate that Flash buffer does
; 0001 00B3                                             // not contain data for writing
; 0001 00B4     while(EECR & (1<<EEWE));
; 0001 00B5     LpmReplaceSpm(flashAddr, data);         // Fills Flash write buffer
; 0001 00B6     WriteBufToFlash(ADR_FLASH_BUFFER);      // Writes to Flash recovery buffer
; 0001 00B7     FlashBackup.pageNumber = (unsigned int) (pageAdr/PAGESIZE); // Stores page address
; 0001 00B8                                                        // data should be written to
; 0001 00B9     FlashBackup.status = FLASH_BUFFER_FULL_ID; // Indicates that Flash recovery buffer
; 0001 00BA                                                // contains unwritten data
; 0001 00BB     while(EECR & (1<<EEWE));
; 0001 00BC     #endif
; 0001 00BD 
; 0001 00BE     if(LpmReplaceSpm(flashAddr, data)!=0)         // Fills Flash write buffer
; 0001 00BF     {
; 0001 00C0         _PAGE_WRITE(pageAdr);
; 0001 00C1         PORTC.1=0;
; 0001 00C2     }
; 0001 00C3     else
; 0001 00C4     {
; 0001 00C5         _PAGE_EW(pageAdr);
; 0001 00C6         PORTC.2=0;
; 0001 00C7     }
; 0001 00C8 
; 0001 00C9     #ifdef __FLASH_RECOVER
; 0001 00CA     FlashBackup.status = 0;                 // Indicates that Flash recovery buffer
; 0001 00CB                                             // does not contain unwritten data
; 0001 00CC     while(EECR & (1<<EEWE));
; 0001 00CD     #endif
; 0001 00CE 
; 0001 00CF     EECR |= eepromInterruptSettings;        // Restore EEPROM interrupt mask
; 0001 00D0     SREG=saveSREG;
; 0001 00D1     return TRUE;                            // Return TRUE if address
; 0001 00D2                                             // valid for writing
; 0001 00D3   }
; 0001 00D4   else
; 0001 00D5     return FALSE;                           // Return FALSE if address not
; 0001 00D6                                             // valid for writing
; 0001 00D7 }
;
;/*!
;* The function writes data from array dataPage[] to Flash page address
;* flashStartAdr. The Number of bytes written is depending upon the Flash page
;* size. Returns FALSE if input argument ucFlashStartAdr is not a valid Flash
;* page address for writing, else TRUE.
;**/
;unsigned char WriteFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage)
; 0001 00E0 {
_WriteFlashPage:
; .FSTART _WriteFlashPage
; 0001 00E1   unsigned int index;
; 0001 00E2   unsigned char eepromInterruptSettings,saveSREG;
; 0001 00E3   MyAddressType  pageAdr;
; 0001 00E4   flashStartAdr;//+=ADR_LIMIT_LOW;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR4
;	flashStartAdr -> Y+10
;	*dataPage -> Y+8
;	index -> R16,R17
;	eepromInterruptSettings -> R19
;	saveSREG -> R18
;	pageAdr -> Y+4
	RCALL SUBOPT_0xC
; 0001 00E5   if( AddressCheck(flashStartAdr) ){
	RCALL SUBOPT_0xD
	RCALL _AddressCheck
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20031
; 0001 00E6     if(eepromBackup(flashStartAdr,PAGESIZE,dataPage)==0)
	RCALL SUBOPT_0xC
	CALL __PUTPARD1
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RCALL _eepromBackup
	CPI  R30,0
	BRNE _0x20032
; 0001 00E7     {
; 0001 00E8         return FALSE;
	LDI  R30,LOW(0)
	RJMP _0x2000003
; 0001 00E9     }
; 0001 00EA     eepromInterruptSettings = EECR & (1<<EERIE); // Stoes EEPROM interrupt mask
_0x20032:
	IN   R30,0x1C
	ANDI R30,LOW(0x8)
	MOV  R19,R30
; 0001 00EB     EECR &= ~(1<<EERIE);                    // Disable EEPROM interrupt
	CBI  0x1C,3
; 0001 00EC     while(EECR & (1<<EEWE));                // Wait if ongoing EEPROM write
_0x20033:
	SBIC 0x1C,1
	RJMP _0x20033
; 0001 00ED     saveSREG=SREG;                          // Save SREG
	IN   R18,63
; 0001 00EE     #asm("cli")
	cli
; 0001 00EF 
; 0001 00F0     #ifdef __FLASH_RECOVER
; 0001 00F1     FlashBackup.status=0;                   // Inicate that Flash buffer does
; 0001 00F2                                             // not contain data for writing
; 0001 00F3     while(EECR & (1<<EEWE));
; 0001 00F4 
; 0001 00F5     for(index = 0; index < PAGESIZE; index+=2){ // Fills Flash write buffer
; 0001 00F6       _WAIT_FOR_SPM();
; 0001 00F7       _FILL_TEMP_WORD(index, (unsigned int)dataPage[index]+((unsigned int)dataPage[index+1] << 8));
; 0001 00F8     }
; 0001 00F9 
; 0001 00FA     WriteBufToFlash(ADR_FLASH_BUFFER);      // Writes to Flash recovery buffer
; 0001 00FB     FlashBackup.pageNumber=(unsigned int)(flashStartAdr/PAGESIZE);
; 0001 00FC     FlashBackup.status = FLASH_BUFFER_FULL_ID; // Indicates that Flash recovery buffer
; 0001 00FD                                            // contains unwritten data
; 0001 00FE     while(EECR & (1<<EEWE));
; 0001 00FF     #endif
; 0001 0100 
; 0001 0101     //debug
; 0001 0102     _PAGE_ERASE(flashStartAdr);
	RCALL SUBOPT_0xD
	MOVW R30,R8
	ICALL
; 0001 0103 
; 0001 0104     for(index = 0; index < PAGESIZE; index+=2){ // Fills Flash write buffer
	__GETWRN 16,17,0
_0x20037:
	__CPWRN 16,17,256
	BRSH _0x20038
; 0001 0105       _FILL_TEMP_WORD(index, (unsigned int)dataPage[index]+((unsigned int)dataPage[index+1] << 8));
	MOVW R30,R16
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOVW R30,R16
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X
	CLR  R1
	ADIW R30,1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOV  R31,R30
	LDI  R30,0
	MOVW R26,R0
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R4
	ICALL
; 0001 0106     }
	__ADDWRN 16,17,2
	RJMP _0x20037
_0x20038:
; 0001 0107     _PAGE_WRITE(flashStartAdr);
	RCALL SUBOPT_0xD
	MOVW R30,R6
	ICALL
; 0001 0108     if(VerifyFlashPage(flashStartAdr,dataPage)==FALSE)
	RCALL SUBOPT_0xC
	CALL __PUTPARD1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL _VerifyFlashPage
	CPI  R30,0
	BRNE _0x20039
; 0001 0109     {
; 0001 010A       //PORTC.6=0;
; 0001 010B       return FALSE;
	LDI  R30,LOW(0)
	RJMP _0x2000003
; 0001 010C     }
; 0001 010D     #ifdef __FLASH_RECOVER
; 0001 010E       FlashBackup.status=0;                 // Inicate that Flash buffer does
; 0001 010F                                             // not contain data for writing
; 0001 0110       while(EECR & (1<<EEWE));
; 0001 0111     #endif
; 0001 0112 
; 0001 0113     EECR |= eepromInterruptSettings;        // Restore EEPROM interrupt mask
_0x20039:
	IN   R30,0x1C
	OR   R30,R19
	OUT  0x1C,R30
; 0001 0114     SREG=saveSREG;                          // Restore interrupts to SREG
	OUT  0x3F,R18
; 0001 0115     _EepromBackup.status=0;
	__POINTW2MN __EepromBackup,6
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0001 0116     return TRUE;                            // Return TRUE if address                                            // vali ...
	LDI  R30,LOW(1)
	RJMP _0x2000003
; 0001 0117   }
; 0001 0118   else
_0x20031:
; 0001 0119     return FALSE;                           // Return FALSE if not address not
	LDI  R30,LOW(0)
; 0001 011A                                             // valid for writing
; 0001 011B }
_0x2000003:
	CALL __LOADLOCR4
	ADIW R28,14
	RET
; .FEND
;
;unsigned char eepromBackup(unsigned long flashStartAdr, unsigned int length, unsigned char *data)
; 0001 011E {
_eepromBackup:
; .FSTART _eepromBackup
; 0001 011F     _EepromBackup.flashStartAdr=flashStartAdr;
	ST   -Y,R27
	ST   -Y,R26
;	flashStartAdr -> Y+4
;	length -> Y+2
;	*data -> Y+0
	RCALL SUBOPT_0x6
	LDI  R26,LOW(__EepromBackup)
	LDI  R27,HIGH(__EepromBackup)
	CALL __EEPROMWRD
; 0001 0120     _EepromBackup.length=length;
	__POINTW2MN __EepromBackup,4
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL __EEPROMWRW
; 0001 0121     for(;length>0;length--)
_0x2003C:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __CPW02
	BRSH _0x2003D
; 0001 0122     {
; 0001 0123          _EepromBackup.data[length-1]=data[length-1];
	__POINTW2MN __EepromBackup,7
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	RCALL SUBOPT_0xE
	MOVW R26,R0
	CALL __EEPROMWRB
; 0001 0124          if(_EepromBackup.data[length-1]!=data[length-1])
	__POINTW2MN __EepromBackup,7
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDB
	MOV  R0,R30
	RCALL SUBOPT_0xE
	CP   R30,R0
	BREQ _0x2003E
; 0001 0125          {
; 0001 0126             return FALSE;//error during backup on eeprom
	LDI  R30,LOW(0)
	RJMP _0x2000002
; 0001 0127          }
; 0001 0128     }
_0x2003E:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
	RJMP _0x2003C
_0x2003D:
; 0001 0129     _EepromBackup.status=1;//1=ready to move to flash
	__POINTW2MN __EepromBackup,6
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0001 012A     return TRUE;
_0x2000002:
	ADIW R28,8
	RET
; 0001 012B }
; .FEND
;
;/*!
;* The function checks if global variable FlashBackup.status indicates that Flash recovery
;* buffer contains data that needs to be written to Flash. Writes data from
;* Flash recovery buffer to Flash page address given by FLASH_recovery.pageAdr.
;* This function should be called at program startup if FLASH recovery option
;* is enabeled.
;**/
;unsigned char RecoverFlash(){
; 0001 0134 unsigned char RecoverFlash(){
; 0001 0135 #ifdef __FLASH_RECOVER
; 0001 0136   unsigned int index;
; 0001 0137   unsigned long flashStartAdr = (MyAddressType)FlashBackup.pageNumber * PAGESIZE;
; 0001 0138   if(FlashBackup.status == FLASH_BUFFER_FULL_ID){ // Checks if Flash recovery
; 0001 0139                                                   //  buffer contains data
; 0001 013A 
; 0001 013B     for(index=0; index < PAGESIZE; index+=2){     // Writes to Flash write buffer
; 0001 013C         _WAIT_FOR_SPM();
; 0001 013D         _FILL_TEMP_WORD( index, *((MyFlashIntPointer)(ADR_FLASH_BUFFER+index)) );
; 0001 013E     }
; 0001 013F 
; 0001 0140 
; 0001 0141     //WriteBufToFlash((MyAddressType)FlashBackup.pageNumber * PAGESIZE);
; 0001 0142     _WAIT_FOR_SPM();
; 0001 0143     _PAGE_ERASE( flashStartAdr );
; 0001 0144     _WAIT_FOR_SPM();
; 0001 0145     _PAGE_WRITE( flashStartAdr );
; 0001 0146     _WAIT_FOR_SPM();
; 0001 0147     _ENABLE_RWW_SECTION();
; 0001 0148     FlashBackup.status=0;                   // Inicate that Flash buffer does
; 0001 0149                                             // not contain data for writing
; 0001 014A     while(EECR & (1<<EEWE));
; 0001 014B     return TRUE;                            // Returns TRUE if recovery has
; 0001 014C                                             // taken place
; 0001 014D   }
; 0001 014E #endif
; 0001 014F   return FALSE;
; 0001 0150 }
;
;
;/*!
;* The function checks if input argument is a valid Flash page address for
;* writing. Returns TRUE only if:
;* - Address points to the beginning of a Flash page
;* - Address is within the limits defined in Self_programming.h
;* - Address is not equal to page address used for buffring by the Flash recovery
;*   functions (if enabled).
;* Returns FALSE else.
;**/
;unsigned char AddressCheck(MyAddressType flashAdr){
; 0001 015C unsigned char AddressCheck(MyAddressType flashAdr){
_AddressCheck:
; .FSTART _AddressCheck
; 0001 015D   #ifdef __FLASH_RECOVER
; 0001 015E   // The next line gives a warning 'pointless comparison with zero' if ADR_LIMIT_LOW is 0. Ignore it.
; 0001 015F   if( (flashAdr >= ADR_LIMIT_LOW) && (flashAdr <= ADR_LIMIT_HIGH) &&
; 0001 0160       (flashAdr != ADR_FLASH_BUFFER) && !(flashAdr & (PAGESIZE-1)) )
; 0001 0161     return TRUE;                            // Address is a valid page address
; 0001 0162   else
; 0001 0163     return FALSE;                           // Address is not a valid page address
; 0001 0164   #else
; 0001 0165   if((flashAdr >= ADR_LIMIT_LOW) && (flashAdr <= ADR_LIMIT_HIGH) && !(flashAdr & (PAGESIZE-1) ) )
	CALL __PUTPARD2
;	flashAdr -> Y+0
	CALL __GETD2S0
	__CPD2N 0xE000
	BRLO _0x20040
	__CPD2N 0x1E000
	BRSH _0x20040
	RCALL SUBOPT_0x4
	CPI  R30,0
	BREQ _0x20041
_0x20040:
	RJMP _0x2003F
_0x20041:
; 0001 0166     return TRUE;                            // Address is a valid page address
	LDI  R30,LOW(1)
	RJMP _0x2000001
; 0001 0167   else
_0x2003F:
; 0001 0168     return FALSE;                           // Address is not a valid page address
	LDI  R30,LOW(0)
; 0001 0169   #endif
; 0001 016A }
_0x2000001:
	ADIW R28,4
	RET
; .FEND
;
;
;/*!
;* The function reads Flash page given by flashAddr, replaces one byte given by
;* flashAddr with data, and stores entire page in Flash temporary buffer.
;**/
;unsigned char LpmReplaceSpm(MyAddressType flashAddr, unsigned char data){
; 0001 0171 unsigned char LpmReplaceSpm(MyAddressType flashAddr, unsigned char data){
; 0001 0172 //#pragma diag_suppress=Pe1053 // Suppress warning for conversion from long-type address to flash ptr.
; 0001 0173     unsigned int index, oddByte, pcWord;
; 0001 0174     unsigned char onlyWrite=1;
; 0001 0175     MyAddressType  pageAdr;
; 0001 0176     oddByte=(unsigned char)flashAddr & 1;
;	flashAddr -> Y+12
;	data -> Y+11
;	index -> R16,R17
;	oddByte -> R18,R19
;	pcWord -> R20,R21
;	onlyWrite -> Y+10
;	pageAdr -> Y+6
; 0001 0177     pcWord=(unsigned int)flashAddr & (PAGESIZE-2); // Used when writing FLASH temp buffer
; 0001 0178     pageAdr=flashAddr & ~(PAGESIZE-1);        // Get FLASH page address from byte address
; 0001 0179     //_FILL_TEMP_WORD(index, (unsigned int)dataPage[index]+((unsigned int)dataPage[index+1] << 8));
; 0001 017A     for(index=0; index < PAGESIZE; index+=2){
; 0001 017B         if(index==pcWord){
; 0001 017C           if(oddByte){
; 0001 017D             _FILL_TEMP_WORD( index, (*(MyFlashCharPointer)(flashAddr & ~1) | ((unsigned int)data<<8)) );
; 0001 017E           }                                     // Write odd byte in temporary buffer
; 0001 017F           else{
; 0001 0180             _FILL_TEMP_WORD( index, ( (*( (MyFlashCharPointer)flashAddr+1)<<8)  | data ) );
; 0001 0181           }                                     // Write even byte in temporary buffer
; 0001 0182           if(((*((MyFlashCharPointer)flashAddr))&0xFF)!=0xFF)
; 0001 0183                 onlyWrite=0;
; 0001 0184         }
; 0001 0185         else{
; 0001 0186           _FILL_TEMP_WORD(index, *( (MyFlashIntPointer)(pageAdr+index) ) );
; 0001 0187           //if(*((MyFlashIntPointer)(pageAdr+index)) != 0xFFFF)
; 0001 0188                 //onlyWrite=0;
; 0001 0189         }                                       // Write Flash word directly to temporary buffer
; 0001 018A     }
; 0001 018B     return onlyWrite;
; 0001 018C //#pragma diag_default=Pe1053 // Back to default.
; 0001 018D }

	.DSEG
_testChar_S0000000000:
	.BYTE 0x1

	.ESEG

	.ORG 0xA
__EepromBackup:
	.BYTE 0x107

	.ORG 0x0

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	__GETD1N 0x2
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(_testChar_S0000000000)
	LDI  R31,HIGH(_testChar_S0000000000)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	RJMP _ReadFlashBytes

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	CALL __PUTPARD1
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	MOVW R30,R16
	__GETD2S 4
	CLR  R22
	CLR  R23
	CALL __ADDD21
	RJMP _ReadFlashByte

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	__GETW1SX 268
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	__GETD1SX 272
	__ANDD1N 0xFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	__GETD2SX 272
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ADDD21:
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRD:
	RCALL __EEPROMWRW
	ADIW R26,2
	MOVW R0,R30
	MOVW R30,R22
	RCALL __EEPROMWRW
	MOVW R30,R0
	SBIW R26,2
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
