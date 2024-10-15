
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 10.000000 MHz
;Memory model           : Medium
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 2080 byte(s)
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
	.EQU __DSTACK_SIZE=0x0820
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
	.DEF _retry=R4
	.DEF _retry_msb=R5
	.DEF _res=R7
	.DEF _nbytes=R8
	.DEF _nbytes_msb=R9
	.DEF ___AddrToZ24WordToR1R0ByteToSPMCR_SPM_F=R10
	.DEF ___AddrToZ24WordToR1R0ByteToSPMCR_SPM_F_msb=R11
	.DEF ___AddrToZ24ByteToSPMCR_SPM_W=R12
	.DEF ___AddrToZ24ByteToSPMCR_SPM_W_msb=R13
	.DEF __lcd_x=R6

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

_error_msg:
	.DB  LOW(_0x0*2),HIGH(_0x0*2),BYTE3(_0x0*2),BYTE4(_0x0*2),LOW(_0x0*2+1),HIGH(_0x0*2+1),BYTE3(_0x0*2+1),BYTE4(_0x0*2+1)
	.DB  LOW(_0x0*2+13),HIGH(_0x0*2+13),BYTE3(_0x0*2+13),BYTE4(_0x0*2+13),LOW(_0x0*2+13),HIGH(_0x0*2+13),BYTE3(_0x0*2+13),BYTE4(_0x0*2+13)
	.DB  LOW(_0x0*2+24),HIGH(_0x0*2+24),BYTE3(_0x0*2+24),BYTE4(_0x0*2+24),LOW(_0x0*2+37),HIGH(_0x0*2+37),BYTE3(_0x0*2+37),BYTE4(_0x0*2+37)
	.DB  LOW(_0x0*2+48),HIGH(_0x0*2+48),BYTE3(_0x0*2+48),BYTE4(_0x0*2+48),LOW(_0x0*2+59),HIGH(_0x0*2+59),BYTE3(_0x0*2+59),BYTE4(_0x0*2+59)
	.DB  LOW(_0x0*2+75),HIGH(_0x0*2+75),BYTE3(_0x0*2+75),BYTE4(_0x0*2+75),LOW(_0x0*2+85),HIGH(_0x0*2+85),BYTE3(_0x0*2+85),BYTE4(_0x0*2+85)
	.DB  LOW(_0x0*2+94),HIGH(_0x0*2+94),BYTE3(_0x0*2+94),BYTE4(_0x0*2+94),LOW(_0x0*2+112),HIGH(_0x0*2+112),BYTE3(_0x0*2+112),BYTE4(_0x0*2+112)
	.DB  LOW(_0x0*2+131),HIGH(_0x0*2+131),BYTE3(_0x0*2+131),BYTE4(_0x0*2+131),LOW(_0x0*2+148),HIGH(_0x0*2+148),BYTE3(_0x0*2+148),BYTE4(_0x0*2+148)
	.DB  LOW(_0x0*2+163),HIGH(_0x0*2+163),BYTE3(_0x0*2+163),BYTE4(_0x0*2+163),LOW(_0x0*2+180),HIGH(_0x0*2+180),BYTE3(_0x0*2+180),BYTE4(_0x0*2+180)
	.DB  LOW(_0x0*2+196),HIGH(_0x0*2+196),BYTE3(_0x0*2+196),BYTE4(_0x0*2+196)
_cvt_G003:
	.DB  0x80,0x9A,0x90,0x41,0x8E,0x41,0x8F,0x80
	.DB  0x45,0x45,0x45,0x49,0x49,0x49,0x8E,0x8F
	.DB  0x90,0x92,0x92,0x4F,0x99,0x4F,0x55,0x55
	.DB  0x59,0x99,0x9A,0x9B,0x9C,0x9D,0x9E,0x9F
	.DB  0x41,0x49,0x4F,0x55,0xA5,0xA5,0xA6,0xA7
	.DB  0xA8,0xA9,0xAA,0xAB,0xAC,0x21,0xAE,0xAF
	.DB  0xB0,0xB1,0xB2,0xB3,0xB4,0xB5,0xB6,0xB7
	.DB  0xB8,0xB9,0xBA,0xBB,0xBC,0xBD,0xBE,0xBF
	.DB  0xC0,0xC1,0xC2,0xC3,0xC4,0xC5,0xC6,0xC7
	.DB  0xC8,0xC9,0xCA,0xCB,0xCC,0xCD,0xCE,0xCF
	.DB  0xD0,0xD1,0xD2,0xD3,0xD4,0xD5,0xD6,0xD7
	.DB  0xD8,0xD9,0xDA,0xDB,0xDC,0xDD,0xDE,0xDF
	.DB  0xE0,0xE1,0xE2,0xE3,0xE4,0xE5,0xE6,0xE7
	.DB  0xE8,0xE9,0xEA,0xEB,0xEC,0xED,0xEE,0xEF
	.DB  0xF0,0xF1,0xF2,0xF3,0xF4,0xF5,0xF6,0xF7
	.DB  0xF8,0xF9,0xFA,0xFB,0xFC,0xFD,0xFE,0xFF
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0xDB,0xF9,0xEB,0xF9

_0x3:
	.DB  0x55,0x6E,0x69,0x74,0x20,0x54,0x65,0x73
	.DB  0x74,0x20,0x31
_0x22:
	.DB  0x35,0x35,0x41,0x41,0x36,0x36,0x42,0x42
	.DB  0x43,0x43
_0x0:
	.DB  0x0,0x46,0x52,0x5F,0x44,0x49,0x53,0x4B
	.DB  0x5F,0x45,0x52,0x52,0x0,0x46,0x52,0x5F
	.DB  0x49,0x4E,0x54,0x5F,0x45,0x52,0x52,0x0
	.DB  0x46,0x52,0x5F,0x4E,0x4F,0x54,0x5F,0x52
	.DB  0x45,0x41,0x44,0x59,0x0,0x46,0x52,0x5F
	.DB  0x4E,0x4F,0x5F,0x46,0x49,0x4C,0x45,0x0
	.DB  0x46,0x52,0x5F,0x4E,0x4F,0x5F,0x50,0x41
	.DB  0x54,0x48,0x0,0x46,0x52,0x5F,0x49,0x4E
	.DB  0x56,0x41,0x4C,0x49,0x44,0x5F,0x4E,0x41
	.DB  0x4D,0x45,0x0,0x46,0x52,0x5F,0x44,0x45
	.DB  0x4E,0x49,0x45,0x44,0x0,0x46,0x52,0x5F
	.DB  0x45,0x58,0x49,0x53,0x54,0x0,0x46,0x52
	.DB  0x5F,0x49,0x4E,0x56,0x41,0x4C,0x49,0x44
	.DB  0x5F,0x4F,0x42,0x4A,0x45,0x43,0x54,0x0
	.DB  0x46,0x52,0x5F,0x57,0x52,0x49,0x54,0x45
	.DB  0x5F,0x50,0x52,0x4F,0x54,0x45,0x43,0x54
	.DB  0x45,0x44,0x0,0x46,0x52,0x5F,0x49,0x4E
	.DB  0x56,0x41,0x4C,0x49,0x44,0x5F,0x44,0x52
	.DB  0x49,0x56,0x45,0x0,0x46,0x52,0x5F,0x4E
	.DB  0x4F,0x54,0x5F,0x45,0x4E,0x41,0x42,0x4C
	.DB  0x45,0x44,0x0,0x46,0x52,0x5F,0x4E,0x4F
	.DB  0x5F,0x46,0x49,0x4C,0x45,0x53,0x59,0x53
	.DB  0x54,0x45,0x4D,0x0,0x46,0x52,0x5F,0x4D
	.DB  0x4B,0x46,0x53,0x5F,0x41,0x42,0x4F,0x52
	.DB  0x54,0x45,0x44,0x0,0x46,0x52,0x5F,0x54
	.DB  0x49,0x4D,0x45,0x4F,0x55,0x54,0x0,0x45
	.DB  0x52,0x52,0x4F,0x52,0x3A,0x20,0x25,0x70
	.DB  0xD,0xA,0x0,0x53,0x44,0x20,0x4F,0x4B
	.DB  0x3A,0x20,0x0,0x53,0x44,0x20,0x45,0x52
	.DB  0x52,0x4F,0x52,0x3A,0x20,0x0,0x2C,0x0
	.DB  0x2F,0x30,0x2F,0x75,0x6E,0x69,0x74,0x74
	.DB  0x65,0x73,0x74,0x2E,0x74,0x78,0x74,0x0
	.DB  0x2F,0x30,0x2F,0x55,0x50,0x44,0x41,0x54
	.DB  0x45,0x33,0x2E,0x44,0x41,0x54,0x0,0x4C
	.DB  0x6F,0x67,0x69,0x63,0x61,0x6C,0x20,0x64
	.DB  0x72,0x69,0x76,0x65,0x20,0x30,0x3A,0x20
	.DB  0x6D,0x6F,0x75,0x6E,0x74,0x65,0x64,0x20
	.DB  0x4F,0x4B,0xD,0xA,0x0,0x2F,0x30,0x0
	.DB  0x55,0x50,0x44,0x41,0x54,0x45,0x0,0x44
	.DB  0x4F,0x4E,0x45,0x30,0x30,0x30,0x0,0x64
	.DB  0x61,0x74,0x61,0x2E,0x74,0x78,0x74,0x0
	.DB  0x46,0x69,0x6C,0x65,0x20,0x25,0x73,0x20
	.DB  0x63,0x72,0x65,0x61,0x74,0x65,0x64,0x20
	.DB  0x4F,0x4B,0xD,0xA,0x0,0x25,0x75,0x20
	.DB  0x62,0x79,0x74,0x65,0x73,0x20,0x77,0x72
	.DB  0x69,0x74,0x74,0x65,0x6E,0x20,0x6F,0x66
	.DB  0x20,0x25,0x75,0xD,0xA,0x0,0x46,0x69
	.DB  0x6C,0x65,0x20,0x25,0x73,0x20,0x6F,0x70
	.DB  0x65,0x6E,0x65,0x64,0x20,0x4F,0x4B,0xD
	.DB  0xA,0x0,0x25,0x75,0x20,0x62,0x79,0x74
	.DB  0x65,0x73,0x20,0x72,0x65,0x61,0x64,0xD
	.DB  0xA,0x0,0x52,0x65,0x61,0x64,0x20,0x74
	.DB  0x65,0x78,0x74,0x3A,0x20,0x22,0x25,0x73
	.DB  0x22,0xD,0xA,0x0,0x70,0x66,0x66,0x20
	.DB  0x54,0x65,0x73,0x74,0x33,0x2E,0x0,0x54
	.DB  0x65,0x73,0x74,0x33,0x20,0x64,0x6F,0x6E
	.DB  0x65,0x2E,0x0
_0x20003:
	.DB  0xB,0xFA
_0x20004:
	.DB  0x2B,0xFA
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2060003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x0A
	.DD  __REG_VARS*2

	.DW  0x0B
	.DW  _text
	.DD  _0x3*2

	.DW  0x10
	.DW  _0x15
	.DD  _0x0*2+240

	.DW  0x10
	.DW  _0x16
	.DD  _0x0*2+240

	.DW  0x0F
	.DW  _0x23
	.DD  _0x0*2+256

	.DW  0x03
	.DW  _0x23+15
	.DD  _0x0*2+301

	.DW  0x07
	.DW  _0x23+18
	.DD  _0x0*2+304

	.DW  0x08
	.DW  _0x23+25
	.DD  _0x0*2+311

	.DW  0x09
	.DW  _0x23+33
	.DD  _0x0*2+319

	.DW  0x02
	.DW  ___AddrToZ24ByteToSPMCR_SPM_E
	.DD  _0x20003*2

	.DW  0x02
	.DW  ___AddrToZ24ByteToSPMCR_SPM_EW
	.DD  _0x20004*2

	.DW  0x01
	.DW  __seed_G101
	.DD  _0x2020060*2

	.DW  0x02
	.DW  __base_y_G103
	.DD  _0x2060003*2

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
	.ORG 0x920

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
;/* FAT on MMC/SD/SD HC card support */
;//Petit fat api
;#include <pff_rn.h>
;#include "diskio.h"		/* Declarations of low level disk I/O functions */
;/* printf */
;#include <stdio.h>
;#include <stdlib.h>
;/* string functions */
;#include <string.h>
;#include <alcd.h>
;
;/*Globals*/
;int retry;
;/* FAT function result */
;FRESULT res;
;/* number of bytes written/read to the file */
;unsigned int nbytes;
;/* will hold the information for logical drive 0: */
;FATFS fat;
;/* will hold the file information */
;//FIL file;
;/* will hold file attributes, time stamp information */
;FILINFO finfo;
;/* root directory path */
;char path[64];//="/0/unittest.txt";
;/* text to be written to the file */
;char text[]="Unit Test 1";

	.DSEG
;/* file read buffer */
;char buffer[256];
;
;/* error message list */
;flash char * flash error_msg[]=
;{
;"", /* not used */
;"FR_DISK_ERR",
;"FR_INT_ERR",
;"FR_INT_ERR",
;"FR_NOT_READY",
;"FR_NO_FILE",
;"FR_NO_PATH",
;"FR_INVALID_NAME",
;"FR_DENIED",
;"FR_EXIST",
;"FR_INVALID_OBJECT",
;"FR_WRITE_PROTECTED",
;"FR_INVALID_DRIVE",
;"FR_NOT_ENABLED",
;"FR_NO_FILESYSTEM",
;"FR_MKFS_ABORTED",
;"FR_TIMEOUT"
;};
;/* display error message and stop */
;void error(FRESULT res, unsigned char num)
; 0000 0054 {

	.CSEG
_error:
; .FSTART _error
; 0000 0055     char strnum[5];
; 0000 0056     if(num>100){
	ST   -Y,R26
	SBIW R28,5
;	res -> Y+6
;	num -> Y+5
;	strnum -> Y+0
	LDD  R26,Y+5
	CPI  R26,LOW(0x65)
	BRLO _0x4
; 0000 0057        num=100;
	LDI  R30,LOW(100)
	STD  Y+5,R30
; 0000 0058     }
; 0000 0059     itoa(num,strnum);
_0x4:
	LDD  R30,Y+5
	CALL SUBOPT_0x0
; 0000 005A     do{
_0x6:
; 0000 005B     if ((res>=0) && (res<=FR_NO_FILESYSTEM)){//FR_NO_FILESYSTEM  FR_TIMEOUT
	LDD  R26,Y+6
	CPI  R26,0
	BRLO _0x9
	CPI  R26,LOW(0x8)
	BRLO _0xA
_0x9:
	RJMP _0x8
_0xA:
; 0000 005C        lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 005D        printf("ERROR: %p\r\n",error_msg[res]);
	__POINTD1FN _0x0,207
	CALL __PUTPARD1
	LDD  R30,Y+10
	CALL SUBOPT_0x1
	CALL __GETD1PF
	CALL SUBOPT_0x2
; 0000 005E        if(res==0){
	LDD  R30,Y+6
	CPI  R30,0
	BRNE _0xB
; 0000 005F         lcd_putsf("SD OK: ");
	__POINTD2FN _0x0,219
	RJMP _0x5B
; 0000 0060        }
; 0000 0061        else{
_0xB:
; 0000 0062         lcd_putsf("SD ERROR: ");
	__POINTD2FN _0x0,227
_0x5B:
	CALL _lcd_putsf
; 0000 0063        }
; 0000 0064        delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0065        lcd_puts(strnum);
	MOVW R26,R28
	CALL _lcd_puts
; 0000 0066        lcd_putsf(",");
	__POINTD2FN _0x0,238
	CALL _lcd_putsf
; 0000 0067        itoa(res,strnum);
	LDD  R30,Y+6
	CALL SUBOPT_0x0
; 0000 0068        lcd_puts(strnum);
	MOVW R26,R28
	CALL _lcd_puts
; 0000 0069        lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 006A        lcd_putsf(error_msg[res]);
	LDD  R30,Y+6
	CALL SUBOPT_0x1
	CALL __GETD2PF
	CALL _lcd_putsf
; 0000 006B     }
; 0000 006C     /* stop here */
; 0000 006D     //do
; 0000 006E         //{
; 0000 006F           PORTC.0=0;
_0x8:
	CBI  0x15,0
; 0000 0070           PORTC.1=0;
	CBI  0x15,1
; 0000 0071           delay_ms(150);
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
; 0000 0072           PORTC.1=1;
	SBI  0x15,1
; 0000 0073           PORTC.0=1;
	SBI  0x15,0
; 0000 0074           delay_ms(150);
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
; 0000 0075           PORTC=0xFC;
	LDI  R30,LOW(252)
	OUT  0x15,R30
; 0000 0076         }
; 0000 0077       while(1);
	RJMP _0x6
; 0000 0078 }
; .FEND
;unsigned char rn(char *newname, char *oldname){
; 0000 0079 unsigned char rn(char *newname, char *oldname){
; 0000 007A     strcpy(path,"/0/unittest.txt");
;	*newname -> Y+2
;	*oldname -> Y+0
; 0000 007B 
; 0000 007C }

	.DSEG
_0x15:
	.BYTE 0x10
;unsigned char RenameTest(){
; 0000 007D unsigned char RenameTest(){

	.CSEG
; 0000 007E    int retry;
; 0000 007F    strcpy(path,"/0/unittest.txt");
;	retry -> R16,R17
; 0000 0080 
; 0000 0081 }

	.DSEG
_0x16:
	.BYTE 0x10
;
;FRESULT rename (const char* dirname, const char* oldname, char* newname)
; 0000 0084 {

	.CSEG
; 0000 0085     FRESULT res;
; 0000 0086     FILINFO fno;
; 0000 0087     DIR dir;
; 0000 0088     int i;
; 0000 0089     BYTE rwbuf[512];
; 0000 008A 
; 0000 008B     res = pf_opendir(&dir, path);
;	*dirname -> Y+558
;	*oldname -> Y+556
;	*newname -> Y+554
;	res -> R17
;	fno -> Y+532
;	dir -> Y+516
;	i -> R18,R19
;	rwbuf -> Y+4
; 0000 008C     if (res == FR_OK) {
; 0000 008D         i = strlen(path);
; 0000 008E         for (;;) {
; 0000 008F             res = pf_readdir(&dir, &fno);
; 0000 0090             if (res != FR_OK || fno.fname[0] == 0) break;
; 0000 0091             if(fno.fname[0] == 'U'){
; 0000 0092                res = disk_readp(rwbuf,dir.sect,0,512);
; 0000 0093                if (res != FR_OK) break;
; 0000 0094                rwbuf[((dir.index-1)*32)+6]='5';
; 0000 0095                res = disk_writep(0,dir.sect);
; 0000 0096                if (res != FR_OK) break;
; 0000 0097                res = disk_writep(rwbuf,512);
; 0000 0098                if (res != FR_OK) break;
; 0000 0099                res = disk_writep(0,0);
; 0000 009A                break;
; 0000 009B             }
; 0000 009C             /*
; 0000 009D             if (fno.fattrib & AM_DIR) {
; 0000 009E                 sprintf(&path[i], "/%s", fno.fname);
; 0000 009F                 res = scan_files(path);
; 0000 00A0                 if (res != FR_OK) break;
; 0000 00A1                 path[i] = 0;
; 0000 00A2             } else {
; 0000 00A3                 printf("%s/%s\n", path, fno.fname);
; 0000 00A4             }
; 0000 00A5             */
; 0000 00A6         }
; 0000 00A7     }
; 0000 00A8 
; 0000 00A9     return res;
; 0000 00AA }
;
;unsigned char UnitTest1(){
; 0000 00AC unsigned char UnitTest1(){
_UnitTest1:
; .FSTART _UnitTest1
; 0000 00AD 
; 0000 00AE     BYTE testbuf[10]={'5','5','A','A','6','6','B','B','C','C'};
; 0000 00AF     strcpy(path,"/0/UPDATE3.DAT");
	SBIW R28,10
	LDI  R24,10
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x22*2)
	LDI  R31,HIGH(_0x22*2)
	LDI  R22,BYTE3(_0x22*2)
	CALL __INITLOCB
;	testbuf -> Y+0
	LDI  R30,LOW(_path)
	LDI  R31,HIGH(_path)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x23,0
	CALL _strcpy
; 0000 00B0     /* mount logical drive 0: */
; 0000 00B1     //if ((res=f_mount(0,&fat))==FR_OK)
; 0000 00B2 
; 0000 00B3     for(retry=0;retry<5;retry++){
	CLR  R4
	CLR  R5
_0x25:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x26
; 0000 00B4         res=pf_mount(&fat);
	LDI  R26,LOW(_fat)
	LDI  R27,HIGH(_fat)
	CALL _pf_mount
	MOV  R7,R30
; 0000 00B5         if (res==FR_OK){
	TST  R7
	BREQ _0x26
; 0000 00B6             break;
; 0000 00B7         }
; 0000 00B8         else{
; 0000 00B9           delay_ms(500);
	CALL SUBOPT_0x3
; 0000 00BA         }
; 0000 00BB     }
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	RJMP _0x25
_0x26:
; 0000 00BC 
; 0000 00BD     //res=pf_remount(&fat);
; 0000 00BE     if (res==FR_OK)
	TST  R7
	BRNE _0x29
; 0000 00BF        printf("Logical drive 0: mounted OK\r\n");
	__POINTD1FN _0x0,271
	CALL __PUTPARD1
	LDI  R24,0
	CALL _printf
	ADIW R28,4
; 0000 00C0     else
	RJMP _0x2A
_0x29:
; 0000 00C1        /* an error occured, display it and stop */
; 0000 00C2        error(res,1);
	ST   -Y,R7
	LDI  R26,LOW(1)
	RCALL _error
; 0000 00C3     //scan_files("/0");
; 0000 00C4 
; 0000 00C5     res=pf_rename("/0","UPDATE","DONE000");
_0x2A:
	__POINTW1MN _0x23,15
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x23,18
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x23,25
	CALL _pf_rename
	MOV  R7,R30
; 0000 00C6     //res=pf_rename("/0","DONE","UPDATE");
; 0000 00C7     if(res)
	TST  R7
	BREQ _0x2B
; 0000 00C8         error(res,22);
	ST   -Y,R7
	LDI  R26,LOW(22)
	RCALL _error
; 0000 00C9 
; 0000 00CA 
; 0000 00CB 
; 0000 00CC 
; 0000 00CD 
; 0000 00CE     /*this line will remove READ_ONLY attribute*/
; 0000 00CF     //f_chmod(path, AM_ARC, AM_ARC|AM_RDO);
; 0000 00D0     /* create a new file in the root of drive 0:
; 0000 00D1        and set write access mode */
; 0000 00D2     //if ((res=f_open(&file,path,FA_CREATE_ALWAYS | FA_WRITE))==FR_OK)
; 0000 00D3     if ((res=pf_open("data.txt"))==FR_OK)
_0x2B:
	__POINTW2MN _0x23,33
	CALL _pf_open
	MOV  R7,R30
	CPI  R30,0
	BRNE _0x2C
; 0000 00D4        printf("File %s created OK\r\n",path);
	__POINTD1FN _0x0,328
	CALL SUBOPT_0x4
; 0000 00D5     else{
	RJMP _0x2D
_0x2C:
; 0000 00D6        /* an error occured, display it and stop */
; 0000 00D7        if(res!=3)
	LDI  R30,LOW(3)
	CP   R30,R7
	BREQ _0x2E
; 0000 00D8             error(res,2);
	ST   -Y,R7
	LDI  R26,LOW(2)
	RCALL _error
; 0000 00D9     }
_0x2E:
_0x2D:
; 0000 00DA 
; 0000 00DB     /* write some text to the file,
; 0000 00DC        without the NULL string terminator sizeof(data)-1 */
; 0000 00DD     //if ((res=f_write(&file,text,sizeof(text)-1,&nbytes))==FR_OK)
; 0000 00DE     if ((res=pf_write512(testbuf,520,sizeof(testbuf),&nbytes))==FR_OK)
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(520)
	LDI  R31,HIGH(520)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x5
	CALL _pf_write512
	MOV  R7,R30
	CPI  R30,0
	BRNE _0x2F
; 0000 00DF        printf("%u bytes written of %u\r\n",nbytes,sizeof(text)-1);
	CALL SUBOPT_0x6
; 0000 00E0     else
	RJMP _0x30
_0x2F:
; 0000 00E1        ///* an error occured, display it and stop */
; 0000 00E2        error(res,93);
	ST   -Y,R7
	LDI  R26,LOW(93)
	RCALL _error
; 0000 00E3     if ((res=pf_write(text,sizeof(text)-1,&nbytes))==FR_OK)
_0x30:
	LDI  R30,LOW(_text)
	LDI  R31,HIGH(_text)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0x5
	CALL _pf_write
	MOV  R7,R30
	CPI  R30,0
	BRNE _0x31
; 0000 00E4        printf("%u bytes written of %u\r\n",nbytes,sizeof(text)-1);
	CALL SUBOPT_0x6
; 0000 00E5     else
	RJMP _0x32
_0x31:
; 0000 00E6        ///* an error occured, display it and stop */
; 0000 00E7        error(res,3);
	ST   -Y,R7
	LDI  R26,LOW(3)
	RCALL _error
; 0000 00E8 
; 0000 00E9         /* close the file */
; 0000 00EA     /*
; 0000 00EB     if ((res=f_close(&file))==FR_OK)
; 0000 00EC        printf("File %s closed OK\r\n",path);
; 0000 00ED     else
; 0000 00EE        // an error occured, display it and stop
; 0000 00EF        error(res,4);
; 0000 00F0     */
; 0000 00F1 
; 0000 00F2     /* open the file in read mode */
; 0000 00F3 
; 0000 00F4     //if ((res=f_open(&file,path,FA_READ|FA_WRITE))==FR_OK)
; 0000 00F5     if ((res=pf_open(path))==FR_OK)
_0x32:
	LDI  R26,LOW(_path)
	LDI  R27,HIGH(_path)
	CALL _pf_open
	MOV  R7,R30
	CPI  R30,0
	BRNE _0x33
; 0000 00F6        printf("File %s opened OK\r\n",path);
	__POINTD1FN _0x0,374
	CALL SUBOPT_0x4
; 0000 00F7     else
	RJMP _0x34
_0x33:
; 0000 00F8        ///* an error occured, display it and stop */
; 0000 00F9        error(res,7);
	ST   -Y,R7
	LDI  R26,LOW(7)
	RCALL _error
; 0000 00FA 
; 0000 00FB 
; 0000 00FC 
; 0000 00FD     /* read and display the file's content.
; 0000 00FE        make sure to leave space for a NULL terminator
; 0000 00FF        in the buffer, so maximum sizeof(buffer)-1 bytes can be read */
; 0000 0100     //if ((res=f_read(&file,buffer,sizeof(buffer)-1,&nbytes))==FR_OK)
; 0000 0101     if ((res=pf_read(buffer,sizeof(buffer)-1,&nbytes))==FR_OK)
_0x34:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0x5
	CALL _pf_read
	MOV  R7,R30
	CPI  R30,0
	BRNE _0x35
; 0000 0102        {
; 0000 0103        printf("%u bytes read\r\n",nbytes);
	__POINTD1FN _0x0,394
	CALL __PUTPARD1
	MOVW R30,R8
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x2
; 0000 0104        /* NULL terminate the char string in the buffer */
; 0000 0105        buffer[nbytes+1]=NULL;
	MOVW R30,R8
	__ADDW1MN _buffer,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0106        /* display the buffer contents */
; 0000 0107        printf("Read text: \"%s\"\r\n",buffer);
	__POINTD1FN _0x0,410
	CALL __PUTPARD1
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x2
; 0000 0108        }
; 0000 0109     else
	RJMP _0x36
_0x35:
; 0000 010A        /* an error occured, display it and stop */
; 0000 010B        error(res,6);
	ST   -Y,R7
	LDI  R26,LOW(6)
	RCALL _error
; 0000 010C 
; 0000 010D 
; 0000 010E     /* close the file */
; 0000 010F     /*
; 0000 0110     if ((res=f_close(&file))==FR_OK)
; 0000 0111        printf("File %s closed OK\r\n",path);
; 0000 0112     else
; 0000 0113        // an error occured, display it and stop
; 0000 0114        error(res,6);
; 0000 0115     */
; 0000 0116 
; 0000 0117     /* display file's attribute, size and time stamp */
; 0000 0118     //display_status(path);
; 0000 0119 
; 0000 011A 
; 0000 011B     /* change file's attributes, set the file to be Read-Only */
; 0000 011C     /*
; 0000 011D     if ((res=f_chmod(path,AM_RDO,AM_RDO))==FR_OK)
; 0000 011E        printf("Read-Only attribute set OK\r\n",path);
; 0000 011F     else
; 0000 0120        // an error occured, display it and stop
; 0000 0121        error(res,7);
; 0000 0122     */
; 0000 0123   return 1;
_0x36:
	LDI  R30,LOW(1)
	RJMP _0x20C0019
; 0000 0124 }
; .FEND

	.DSEG
_0x23:
	.BYTE 0x2A
;void main( void ){
; 0000 0125 void main( void ){

	.CSEG
_main:
; .FSTART _main
; 0000 0126   unsigned char testBuffer1[PAGESIZE];      // Declares variables for testing
; 0000 0127   //unsigned char testBuffer2[PAGESIZE];      // Note. Each array uses PAGESIZE bytes of
; 0000 0128                                             // code stack
; 0000 0129   static unsigned char testChar; // A warning will come saying that this var is set but never used. Ignore it.
; 0000 012A   int index;
; 0000 012B 
; 0000 012C   /* globally enable interrupts */
; 0000 012D     #asm("sei")
	SUBI R29,1
;	testBuffer1 -> Y+0
;	index -> R16,R17
	sei
; 0000 012E 
; 0000 012F   DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0130   PORTC=0xFF;
	OUT  0x15,R30
; 0000 0131   /* initialize the LCD for 2 lines & 16 columns */
; 0000 0132     lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0133   /* switch to writing in Display RAM */
; 0000 0134     //lcd_gotoxy(0,0);
; 0000 0135     lcd_clear();
	CALL _lcd_clear
; 0000 0136     //lcd_putsf("User char 0:");
; 0000 0137 
; 0000 0138   //disk_timerproc();
; 0000 0139   lcd_clear();
	CALL _lcd_clear
; 0000 013A   lcd_putsf("pff Test3.");
	__POINTD2FN _0x0,428
	CALL _lcd_putsf
; 0000 013B   delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 013C   UnitTest1();
	RCALL _UnitTest1
; 0000 013D 
; 0000 013E   //RenameTest();
; 0000 013F   //UpdateTest();
; 0000 0140   //WriteDataTest();
; 0000 0141   //ReadDataTest();
; 0000 0142 
; 0000 0143   /* switch to writing in Display RAM */
; 0000 0144     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0145     lcd_putsf("Test3 done.");
	__POINTD2FN _0x0,439
	CALL _lcd_putsf
; 0000 0146   do
_0x38:
; 0000 0147     {
; 0000 0148       PORTC.0=0;
	CBI  0x15,0
; 0000 0149       PORTC.1=0;
	CBI  0x15,1
; 0000 014A       delay_ms(500);
	CALL SUBOPT_0x3
; 0000 014B       PORTC.1=1;
	SBI  0x15,1
; 0000 014C       PORTC.0=1;
	SBI  0x15,0
; 0000 014D       delay_ms(500);
	CALL SUBOPT_0x3
; 0000 014E       PORTC=0xFC;
	LDI  R30,LOW(252)
	OUT  0x15,R30
; 0000 014F     }
; 0000 0150   while(1);
	RJMP _0x38
; 0000 0151   for(index=0; index<PAGESIZE; index++){
_0x43:
	__CPWRN 16,17,256
	BRGE _0x44
; 0000 0152     testBuffer1[index]=index;//(unsigned char)0xFF; // Fills testBuffer1 with values FF
	MOVW R30,R16
	MOVW R26,R28
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R16
; 0000 0153   }
	__ADDWRN 16,17,1
	RJMP _0x43
_0x44:
; 0000 0154   if(WriteFlashBytes(0x2, testBuffer1,PAGESIZE)){     // Writes testbuffer1 to Flash page 2
	CALL SUBOPT_0x7
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(256)
	LDI  R27,HIGH(256)
	RCALL _WriteFlashBytes
	CPI  R30,0
	BREQ _0x45
; 0000 0155     PORTC.2=0;
	CBI  0x15,2
; 0000 0156   }                                            // Same as byte 4 on page 2
; 0000 0157   //MCUCR &= ~(1<<IVSEL);
; 0000 0158   ReadFlashBytes(0x2,&testChar,1);        // Reads back value from address 0x204
_0x45:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
; 0000 0159   if(testChar==0x00)
	LDS  R30,_testChar_S0000005000
	CPI  R30,0
	BRNE _0x48
; 0000 015A   {
; 0000 015B       ReadFlashBytes(0x3,&testChar,1);        // Reads back value from address 0x204
	__GETD1N 0x3
	CALL SUBOPT_0x9
; 0000 015C       if(testChar==0x01)
	LDS  R26,_testChar_S0000005000
	CPI  R26,LOW(0x1)
	BRNE _0x49
; 0000 015D         ReadFlashBytes(0x100,&testChar,1);        // Reads back value from address 0x204
	__GETD1N 0x100
	CALL SUBOPT_0x9
; 0000 015E         if(testChar==0xFE)
_0x49:
	LDS  R26,_testChar_S0000005000
	CPI  R26,LOW(0xFE)
	BRNE _0x4A
; 0000 015F             ReadFlashBytes(0x101,&testChar,1);        // Reads back value from address 0x204
	__GETD1N 0x101
	CALL SUBOPT_0x9
; 0000 0160             if(testChar==0xFF)
_0x4A:
	LDS  R26,_testChar_S0000005000
	CPI  R26,LOW(0xFF)
	BRNE _0x4B
; 0000 0161               while(1)
_0x4C:
; 0000 0162               {
; 0000 0163                   PORTC.0=0;
	CBI  0x15,0
; 0000 0164                   delay_ms(500);
	CALL SUBOPT_0x3
; 0000 0165                   PORTC.0=1;
	SBI  0x15,0
; 0000 0166                   delay_ms(500);
	CALL SUBOPT_0x3
; 0000 0167               }
	RJMP _0x4C
; 0000 0168   }
_0x4B:
; 0000 0169 
; 0000 016A   while(1)
_0x48:
_0x53:
; 0000 016B   {
; 0000 016C       PORTC.1=0;
	CBI  0x15,1
; 0000 016D       delay_ms(500);
	CALL SUBOPT_0x3
; 0000 016E       PORTC.1=1;
	SBI  0x15,1
; 0000 016F       delay_ms(500);
	CALL SUBOPT_0x3
; 0000 0170   }
	RJMP _0x53
; 0000 0171   //}
; 0000 0172 }
_0x5A:
	RJMP _0x5A
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

	.DSEG
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
	CALL SUBOPT_0xA
; 0001 0045   return (unsigned char)*((MyFlashCharPointer)flashStartAdr);
	CALL SUBOPT_0xA
	__GETBRPF 30
	RJMP _0x20C0016
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
	CALL SUBOPT_0xB
;	flashStartAdr -> Y+4
;	*dataPage -> Y+2
;	index -> R16,R17
	CALL SUBOPT_0xC
; 0001 0052   if(!(flashStartAdr & (PAGESIZE-1))){      // If input address is a page address
	CALL SUBOPT_0xC
	CPI  R30,0
	BRNE _0x20005
; 0001 0053     for(index = 0; index < PAGESIZE; index++){
	__GETWRN 16,17,0
_0x20007:
	__CPWRN 16,17,256
	BRSH _0x20008
; 0001 0054       dataPage[index] = ReadFlashByte(flashStartAdr + index);
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xD
	POP  R26
	POP  R27
	ST   X,R30
; 0001 0055     }
	__ADDWRN 16,17,1
	RJMP _0x20007
_0x20008:
; 0001 0056     return TRUE;                            // Return TRUE if valid page address
	LDI  R30,LOW(1)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C0017
; 0001 0057   }
; 0001 0058   else{
_0x20005:
; 0001 0059     return FALSE;                           // Return FALSE if not valid page address
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C0017
; 0001 005A   }
; 0001 005B }
; .FEND
;unsigned char ReadFlashBytes(MyAddressType flashStartAdr, unsigned char *dataPage, unsigned int length){
; 0001 005C unsigned char ReadFlashBytes(MyAddressType flashStartAdr, unsigned char *dataPage, unsigned int length){
_ReadFlashBytes:
; .FSTART _ReadFlashBytes
; 0001 005D   	unsigned int index;
; 0001 005E   	flashStartAdr+=ADR_LIMIT_LOW;
	CALL SUBOPT_0xB
;	flashStartAdr -> Y+6
;	*dataPage -> Y+4
;	length -> Y+2
;	index -> R16,R17
	CALL SUBOPT_0xE
	__ADDD1N 57344
	CALL SUBOPT_0xF
; 0001 005F     for(index = 0; index < length; index++){
	__GETWRN 16,17,0
_0x2000B:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x2000C
; 0001 0060       dataPage[index] = ReadFlashByte(flashStartAdr + index);
	MOVW R30,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOVW R30,R16
	CALL SUBOPT_0x10
	CLR  R22
	CLR  R23
	CALL __ADDD21
	RCALL _ReadFlashByte
	POP  R26
	POP  R27
	ST   X,R30
; 0001 0061     }
	__ADDWRN 16,17,1
	RJMP _0x2000B
_0x2000C:
; 0001 0062     return TRUE;                            // Return TRUE if valid page address
	LDI  R30,LOW(1)
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20C0019:
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
	CALL SUBOPT_0xB
;	flashStartAdr -> Y+4
;	*dataPage -> Y+2
;	index -> R16,R17
	CALL SUBOPT_0xC
	CPI  R30,0
	BRNE _0x2000D
; 0001 0067     for(index = 0; index < PAGESIZE; index++){
	__GETWRN 16,17,0
_0x2000F:
	__CPWRN 16,17,256
	BRSH _0x20010
; 0001 0068       if(dataPage[index] != ReadFlashByte(flashStartAdr + index))
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	PUSH R30
	CALL SUBOPT_0xD
	POP  R26
	CP   R30,R26
	BREQ _0x20011
; 0001 0069       {
; 0001 006A         PORTC.6=0;
	CBI  0x15,6
; 0001 006B         return FALSE;
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C0017
; 0001 006C       }
; 0001 006D     }
_0x20011:
	__ADDWRN 16,17,1
	RJMP _0x2000F
_0x20010:
; 0001 006E     return TRUE;                            // Return TRUE if valid page address
	LDI  R30,LOW(1)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C0017
; 0001 006F   }
; 0001 0070   else{
_0x2000D:
; 0001 0071     PORTC.7=0;
	CBI  0x15,7
; 0001 0072     return FALSE;                           // Return FALSE if not valid page address
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C0017
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
_0x20017:
	CALL SUBOPT_0x11
	SBIW R30,0
	BRNE PC+2
	RJMP _0x20019
; 0001 007B     {
; 0001 007C         flashAdrStart= flashAdr-(flashAdr%PAGESIZE);//0x1F0-(0x1F0%0x100)=0x0100                        //
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	CALL __SUBD21
	__PUTD2S 8
; 0001 007D         flashAdrNext = flashAdrStart+PAGESIZE;          //0x0100+0x100=0x200
	CALL SUBOPT_0x14
	__ADDD1N 256
	CALL SUBOPT_0x15
; 0001 007E         if((flashAdrNext - flashAdr) >= length)    //enough space case
	CALL SUBOPT_0x13
	CALL SUBOPT_0xC
	CALL __SUBD12
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x11
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRLO _0x2001A
; 0001 007F         {
; 0001 0080            lengthStart=length;
	__GETWRSX 16,17,268
; 0001 0081            length=0;
	LDI  R30,LOW(0)
	__CLRW1SX 268
; 0001 0082         }
; 0001 0083         else                                   //(0x200-0x1F0)<0x20
	RJMP _0x2001B
_0x2001A:
; 0001 0084         {
; 0001 0085            lengthStart=(flashAdrNext - flashAdr);        //len1=0x200-0x1F0=0x10
	__GETW2SX 272
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
; 0001 0086            length-=lengthStart;                         //len2=0x20-0x10=0x10
	CALL SUBOPT_0x11
	SUB  R30,R16
	SBC  R31,R17
	__PUTW1SX 268
; 0001 0087         }
_0x2001B:
; 0001 0088         if(ReadFlashPage(flashAdrStart,tempBuffer)==FALSE) //read flash page to tempBuffer
	CALL SUBOPT_0x14
	CALL __PUTPARD1
	MOVW R26,R28
	ADIW R26,16
	RCALL _ReadFlashPage
	CPI  R30,0
	BRNE _0x2001C
; 0001 0089         {
; 0001 008A             PORTC.3=0;
	CBI  0x15,3
; 0001 008B             return FALSE;
	LDI  R30,LOW(0)
	RJMP _0x20C0018
; 0001 008C         }
; 0001 008D         for(lengthIndex=(flashAdr%PAGESIZE);lengthIndex<((flashAdr%PAGESIZE)+lengthStart);lengthIndex++)
_0x2001C:
	__GETW1SX 272
	ANDI R31,HIGH(0xFF)
	MOVW R18,R30
_0x20020:
	CALL SUBOPT_0x12
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R16
	CALL SUBOPT_0x16
	MOVW R26,R18
	CLR  R24
	CLR  R25
	CALL __CPD21
	BRSH _0x20021
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
	RJMP _0x20020
_0x20021:
; 0001 0091         flashAdr=flashAdrNext;
	CALL SUBOPT_0xC
	__PUTD1SX 272
; 0001 0092         if(WriteFlashPage(flashAdrStart+ADR_LIMIT_LOW,tempBuffer)==FALSE) //write tempBuffer to flash page
	CALL SUBOPT_0x14
	__ADDD1N 57344
	CALL __PUTPARD1
	MOVW R26,R28
	ADIW R26,16
	RCALL _WriteFlashPage
	CPI  R30,0
	BRNE _0x20022
; 0001 0093         {
; 0001 0094             PORTC.4=0;
	CBI  0x15,4
; 0001 0095             return FALSE;
	LDI  R30,LOW(0)
	RJMP _0x20C0018
; 0001 0096         }
; 0001 0097     }
_0x20022:
	RJMP _0x20017
_0x20019:
; 0001 0098     return TRUE;
	LDI  R30,LOW(1)
_0x20C0018:
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
	CALL SUBOPT_0x17
; 0001 00E5   if( AddressCheck(flashStartAdr) ){
	CALL SUBOPT_0x18
	RCALL _AddressCheck
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20033
; 0001 00E6     if(eepromBackup(flashStartAdr,PAGESIZE,dataPage)==0)
	CALL SUBOPT_0x17
	CALL __PUTPARD1
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RCALL _eepromBackup
	CPI  R30,0
	BRNE _0x20034
; 0001 00E7     {
; 0001 00E8         return FALSE;
	LDI  R30,LOW(0)
	CALL __LOADLOCR4
	ADIW R28,14
	RET
; 0001 00E9     }
; 0001 00EA     eepromInterruptSettings = EECR & (1<<EERIE); // Stoes EEPROM interrupt mask
_0x20034:
	IN   R30,0x1C
	ANDI R30,LOW(0x8)
	MOV  R19,R30
; 0001 00EB     EECR &= ~(1<<EERIE);                    // Disable EEPROM interrupt
	CBI  0x1C,3
; 0001 00EC     while(EECR & (1<<EEWE));                // Wait if ongoing EEPROM write
_0x20035:
	SBIC 0x1C,1
	RJMP _0x20035
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
	CALL SUBOPT_0x18
	__CALL1MN ___AddrToZ24ByteToSPMCR_SPM_E,0
; 0001 0103 
; 0001 0104     for(index = 0; index < PAGESIZE; index+=2){ // Fills Flash write buffer
	__GETWRN 16,17,0
_0x20039:
	__CPWRN 16,17,256
	BRSH _0x2003A
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
	MOVW R30,R10
	ICALL
; 0001 0106     }
	__ADDWRN 16,17,2
	RJMP _0x20039
_0x2003A:
; 0001 0107     _PAGE_WRITE(flashStartAdr);
	CALL SUBOPT_0x18
	MOVW R30,R12
	ICALL
; 0001 0108     if(VerifyFlashPage(flashStartAdr,dataPage)==FALSE)
	CALL SUBOPT_0x17
	CALL __PUTPARD1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL _VerifyFlashPage
	CPI  R30,0
	BRNE _0x2003B
; 0001 0109     {
; 0001 010A       //PORTC.6=0;
; 0001 010B       return FALSE;
	LDI  R30,LOW(0)
	CALL __LOADLOCR4
	JMP  _0x20C0011
; 0001 010C     }
; 0001 010D     #ifdef __FLASH_RECOVER
; 0001 010E       FlashBackup.status=0;                 // Inicate that Flash buffer does
; 0001 010F                                             // not contain data for writing
; 0001 0110       while(EECR & (1<<EEWE));
; 0001 0111     #endif
; 0001 0112 
; 0001 0113     EECR |= eepromInterruptSettings;        // Restore EEPROM interrupt mask
_0x2003B:
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
	CALL __LOADLOCR4
	JMP  _0x20C0011
; 0001 0117   }
; 0001 0118   else
_0x20033:
; 0001 0119     return FALSE;                           // Return FALSE if not address not
	LDI  R30,LOW(0)
	CALL __LOADLOCR4
	JMP  _0x20C0011
; 0001 011A                                             // valid for writing
; 0001 011B }
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
	CALL SUBOPT_0xC
	LDI  R26,LOW(__EepromBackup)
	LDI  R27,HIGH(__EepromBackup)
	CALL __EEPROMWRD
; 0001 0120     _EepromBackup.length=length;
	__POINTW2MN __EepromBackup,4
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL __EEPROMWRW
; 0001 0121     for(;length>0;length--)
_0x2003E:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __CPW02
	BRSH _0x2003F
; 0001 0122     {
; 0001 0123          _EepromBackup.data[length-1]=data[length-1];
	__POINTW2MN __EepromBackup,7
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	CALL SUBOPT_0x19
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
	CALL SUBOPT_0x19
	CP   R30,R0
	BREQ _0x20040
; 0001 0125          {
; 0001 0126             return FALSE;//error during backup on eeprom
	LDI  R30,LOW(0)
	RJMP _0x20C0017
; 0001 0127          }
; 0001 0128     }
_0x20040:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
	RJMP _0x2003E
_0x2003F:
; 0001 0129     _EepromBackup.status=1;//1=ready to move to flash
	__POINTW2MN __EepromBackup,6
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0001 012A     return TRUE;
_0x20C0017:
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
	BRLO _0x20042
	__CPD2N 0x1E000
	BRSH _0x20042
	CALL SUBOPT_0xA
	CPI  R30,0
	BREQ _0x20043
_0x20042:
	RJMP _0x20041
_0x20043:
; 0001 0166     return TRUE;                            // Address is a valid page address
	LDI  R30,LOW(1)
	RJMP _0x20C0016
; 0001 0167   else
_0x20041:
; 0001 0168     return FALSE;                           // Address is not a valid page address
	LDI  R30,LOW(0)
; 0001 0169   #endif
; 0001 016A }
_0x20C0016:
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
;//-----------------------------------------------------------------------
;// PFF - Low level disk control module for ATmega32
;//-----------------------------------------------------------------------
;#define _WRITE_FUNC	1			//allow write operations
;
;//#include "common.h"
;#include "diskio.h"
;#include "mmc.h"
;#include <mega128.h>
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
;
;// Definitions for MMC/SDC connection
;
;//#define SD_INS  6
;//#define SD_WP   7
;
;// Definitions for MMC/SDC command
;#define CMD0	(0x40+0)	// GO_IDLE_STATE
;#define CMD1	(0x40+1)	// SEND_OP_COND (MMC)
;#define	ACMD41	(0xC0+41)	// SEND_OP_COND (SDC)
;#define CMD8	(0x40+8)	// SEND_IF_COND
;#define CMD16	(0x40+16)	// SET_BLOCKLEN
;#define CMD17	(0x40+17)	// READ_SINGLE_BLOCK
;#define CMD24	(0x40+24)	// WRITE_BLOCK
;#define CMD55	(0x40+55)	// APP_CMD
;#define CMD58	(0x40+58)	// READ_OCR
;
;//-----------------------------------------------------------------------
;// SPI functions
;//-----------------------------------------------------------------------
;#define hardware_spi // если определено, то spi аппаратный
;
;#define SPI_PORTX PORTB
;#define SPI_DDRX DDRB
;
;#define SPI_MISO SD_DO
;#define SPI_MOSI SD_DI
;#define SPI_SCK SD_CLK
;#define SPI_SS SD_CS
;
;void INIT_SPI(void) {
; 0002 0029 void INIT_SPI(void) {

	.CSEG
_INIT_SPI:
; .FSTART _INIT_SPI
; 0002 002A #ifdef hardware_spi
; 0002 002B 	/*настройка портов ввода-вывода
; 0002 002C 	 все выводы, кроме MISO выходы*/
; 0002 002D 	SPI_DDRX |= (1 << SPI_MOSI) | (1 << SPI_SCK) | (1 << SPI_SS) | (0 << SPI_MISO);
	IN   R30,0x17
	ORI  R30,LOW(0x7)
	OUT  0x17,R30
; 0002 002E 	SPI_PORTX |= (1 << SPI_MOSI) | (1 << SPI_SCK) | (1 << SPI_SS) | (1 << SPI_MISO);
	IN   R30,0x18
	ORI  R30,LOW(0xF)
	OUT  0x18,R30
; 0002 002F 
; 0002 0030 	/*разрешение spi,старший бит вперед,мастер, режим 0*/
; 0002 0031 	SPCR = (1 << SPE) | (0 << DORD) | (1 << MSTR) | (0 << CPOL) | (0 << CPHA) | (0 << SPR1) | (0 << SPR0);
	LDI  R30,LOW(80)
	OUT  0xD,R30
; 0002 0032     SPSR = (1 << SPI2X);
	LDI  R30,LOW(1)
	OUT  0xE,R30
; 0002 0033     //SPCR |= (1 << SPR1) | (1 << SPR0);
; 0002 0034     //SPSR &= ~(1 << SPI2X);
; 0002 0035 #else
; 0002 0036 	PORTB |= (1<<SD_CS) | (1<<SD_DO) | (1<<SD_DI)/* | (1<<SD_WP) | (1<<SD_INS)*/;
; 0002 0037 	DDRB |=(1<<SD_CS) | (1<<SD_DI) | (1<<SD_CLK);
; 0002 0038 #endif
; 0002 0039 }
	RET
; .FEND
;
;void xmit_spi(BYTE data) {		// Send a byte
; 0002 003B void xmit_spi(BYTE data) {
_xmit_spi:
; .FSTART _xmit_spi
; 0002 003C #ifdef hardware_spi
; 0002 003D 	SPDR = data;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0002 003E 	while (!(SPSR & (1 << SPIF)));
_0x40003:
	SBIS 0xE,7
	RJMP _0x40003
; 0002 003F #else
; 0002 0040 	BYTE i;
; 0002 0041 
; 0002 0042 	for (i = 0; i < 8; i++) {
; 0002 0043 		if ((data & 0x80) == 0x00)
; 0002 0044 			PORTB &= ~(1<<SD_DI);
; 0002 0045 		else
; 0002 0046 			PORTB |= (1<<SD_DI);
; 0002 0047 		data = data << 1;
; 0002 0048 		PORTB |= (1<<SD_CLK);
; 0002 0049 		#asm("nop")
; 0002 004A 		PORTB &= ~(1<<SD_CLK);
; 0002 004B 	}
; 0002 004C #endif
; 0002 004D }
	ADIW R28,1
	RET
; .FEND
;
;BYTE rcv_spi(void) {				// Send 0xFF and receive a byte
; 0002 004F BYTE rcv_spi(void) {
_rcv_spi:
; .FSTART _rcv_spi
; 0002 0050 #ifdef hardware_spi
; 0002 0051 	unsigned char data;
; 0002 0052 	SPDR = 0xFF;
	ST   -Y,R17
;	data -> R17
	LDI  R30,LOW(255)
	OUT  0xF,R30
; 0002 0053 	while (!(SPSR & (1 << SPIF)));
_0x40006:
	SBIS 0xE,7
	RJMP _0x40006
; 0002 0054 	data = SPDR;
	IN   R17,15
; 0002 0055 	return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0002 0056 #else
; 0002 0057 	BYTE i, res = 0;
; 0002 0058 
; 0002 0059 	PORTB |= (1<<SD_DI);
; 0002 005A 
; 0002 005B 	for (i = 0; i < 8; i++) {
; 0002 005C 		PORTB |= (1<<SD_CLK);
; 0002 005D 		res = res << 1;
; 0002 005E 		if ((PINB & (1<<SD_DO))!=0x00)
; 0002 005F 		res = res | 0x01;
; 0002 0060 		PORTB &= ~(1<<SD_CLK);
; 0002 0061 		#asm("nop")
; 0002 0062 	}
; 0002 0063 	return res;
; 0002 0064 #endif
; 0002 0065 } /* Send 0xFF and receive a byte */
; .FEND
;//-----------------------------------------------------------------------
;
;
;
;//-----------------------------------------------------------------------
;//   Module Private Function
;//-----------------------------------------------------------------------
;static BYTE CardType;
;
;//-----------------------------------------------------------------------
;// Deselect the card and release SPI bus
;//-----------------------------------------------------------------------
;static
;void release_spi (void)
; 0002 0074 {
_release_spi_G002:
; .FSTART _release_spi_G002
; 0002 0075 	rcv_spi();
	RCALL _rcv_spi
; 0002 0076 }
	RET
; .FEND
;
;//-----------------------------------------------------------------------
;// Send a command packet to MMC
;//-----------------------------------------------------------------------
;static
;BYTE send_cmd (
; 0002 007D 	BYTE cmd,		// Command byte
; 0002 007E 	DWORD arg		// Argument
; 0002 007F )
; 0002 0080 {
_send_cmd_G002:
; .FSTART _send_cmd_G002
; 0002 0081 	BYTE n, res;
; 0002 0082 
; 0002 0083 
; 0002 0084 	if (cmd & 0x80) {	// ACMD<n> is the command sequense of CMD55-CMD<n>
	CALL __PUTPARD2
	ST   -Y,R17
	ST   -Y,R16
;	cmd -> Y+6
;	arg -> Y+2
;	n -> R17
;	res -> R16
	LDD  R30,Y+6
	ANDI R30,LOW(0x80)
	BREQ _0x40009
; 0002 0085 		cmd &= 0x7F;
	LDD  R30,Y+6
	ANDI R30,0x7F
	STD  Y+6,R30
; 0002 0086 		res = send_cmd(CMD55, 0);
	LDI  R30,LOW(119)
	CALL SUBOPT_0x1A
	MOV  R16,R30
; 0002 0087 		if (res > 1) return res;
	CPI  R16,2
	BRSH _0x20C0014
; 0002 0088 	}
; 0002 0089 
; 0002 008A 	// Select the card
; 0002 008B 	DESELECT();
_0x40009:
	SBI  0x18,0
; 0002 008C 	rcv_spi();
	RCALL _rcv_spi
; 0002 008D 	SELECT();
	CBI  0x18,0
; 0002 008E 	rcv_spi();
	RCALL _rcv_spi
; 0002 008F 
; 0002 0090 	// Send a command packet
; 0002 0091 	xmit_spi(cmd);						// Start + Command index
	LDD  R26,Y+6
	CALL SUBOPT_0x1B
; 0002 0092 	xmit_spi((BYTE)(arg >> 24));		// Argument[31..24]
	LDI  R30,LOW(24)
	CALL __LSRD12
	MOV  R26,R30
	RCALL _xmit_spi
; 0002 0093 	xmit_spi((BYTE)(arg >> 16));		// Argument[23..16]
	CALL SUBOPT_0x1C
	CALL __LSRD16
	MOV  R26,R30
	CALL SUBOPT_0x1B
; 0002 0094 	xmit_spi((BYTE)(arg >> 8));			// Argument[15..8]
	LDI  R30,LOW(8)
	CALL __LSRD12
	MOV  R26,R30
	RCALL _xmit_spi
; 0002 0095 	xmit_spi((BYTE)arg);				// Argument[7..0]
	LDD  R26,Y+2
	RCALL _xmit_spi
; 0002 0096 	n = 0x01;							// Dummy CRC + Stop
	LDI  R17,LOW(1)
; 0002 0097 	if (cmd == CMD0) n = 0x95;			// Valid CRC for CMD0(0)
	LDD  R26,Y+6
	CPI  R26,LOW(0x40)
	BRNE _0x4000B
	LDI  R17,LOW(149)
; 0002 0098 	if (cmd == CMD8) n = 0x87;			// Valid CRC for CMD8(0x1AA)
_0x4000B:
	LDD  R26,Y+6
	CPI  R26,LOW(0x48)
	BRNE _0x4000C
	LDI  R17,LOW(135)
; 0002 0099 	xmit_spi(n);
_0x4000C:
	MOV  R26,R17
	RCALL _xmit_spi
; 0002 009A 
; 0002 009B 	// Receive a command response
; 0002 009C 	n = 10;								// Wait for a valid response in timeout of 10 attempts
	LDI  R17,LOW(10)
; 0002 009D 	do {
_0x4000E:
; 0002 009E 		res = rcv_spi();
	RCALL _rcv_spi
	MOV  R16,R30
; 0002 009F 	} while ((res & 0x80) && --n);
	SBRS R16,7
	RJMP _0x40010
	SUBI R17,LOW(1)
	BRNE _0x40011
_0x40010:
	RJMP _0x4000F
_0x40011:
	RJMP _0x4000E
_0x4000F:
; 0002 00A0 
; 0002 00A1 	return res;			// Return with the response value
_0x20C0014:
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20C0015:
	ADIW R28,7
	RET
; 0002 00A2 }
; .FEND
;
;//--------------------------------------------------------------------------
;//
;//   Public Functions
;//
;//--------------------------------------------------------------------------
;
;//--------------------------------------------------------------------------
;// Initialize Disk Drive
;//--------------------------------------------------------------------------
;DSTATUS disk_initialize (void)
; 0002 00AE {
_disk_initialize:
; .FSTART _disk_initialize
; 0002 00AF 	BYTE n, cmd, ty, ocr[4];
; 0002 00B0 	WORD tmr;
; 0002 00B1     BYTE retry=0;
; 0002 00B2     while(retry<5){
	SBIW R28,4
	CALL __SAVELOCR6
;	n -> R17
;	cmd -> R16
;	ty -> R19
;	ocr -> Y+6
;	tmr -> R20,R21
;	retry -> R18
	LDI  R18,0
_0x40012:
	CPI  R18,5
	BRLO PC+2
	RJMP _0x40014
; 0002 00B3         INIT_SPI();
	RCALL _INIT_SPI
; 0002 00B4 
; 0002 00B5     //	if ((PINB&_BV(SD_INS))!=0x00) return STA_NOINIT;
; 0002 00B6 
; 0002 00B7     #if _WRITE_FUNC
; 0002 00B8         //if (MMC_SEL) disk_writep(0, 0);		// Finalize write process if it is in progress
; 0002 00B9     #endif
; 0002 00BA         for (n = 100; n; n--) rcv_spi();	// Dummy clocks
	LDI  R17,LOW(100)
_0x40016:
	CPI  R17,0
	BREQ _0x40017
	RCALL _rcv_spi
	SUBI R17,1
	RJMP _0x40016
_0x40017:
; 0002 00BC ty = 0;
	LDI  R19,LOW(0)
; 0002 00BD         if (send_cmd(CMD0, 0) == 1) {			// Enter Idle state
	LDI  R30,LOW(64)
	CALL SUBOPT_0x1A
	CPI  R30,LOW(0x1)
	BREQ PC+2
	RJMP _0x40018
; 0002 00BE             if (send_cmd(CMD8, 0x1AA) == 1) {	// SDv2
	LDI  R30,LOW(72)
	ST   -Y,R30
	__GETD2N 0x1AA
	RCALL _send_cmd_G002
	CPI  R30,LOW(0x1)
	BREQ PC+2
	RJMP _0x40019
; 0002 00BF                 for (n = 0; n < 4; n++) ocr[n] = rcv_spi();		// Get trailing return value of R7 resp
	LDI  R17,LOW(0)
_0x4001B:
	CPI  R17,4
	BRSH _0x4001C
	CALL SUBOPT_0x1D
	PUSH R31
	PUSH R30
	RCALL _rcv_spi
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-1
	RJMP _0x4001B
_0x4001C:
; 0002 00C0 if (ocr[2] == 0x01 && ocr[3] == 0xAA) {
	LDD  R26,Y+8
	CPI  R26,LOW(0x1)
	BRNE _0x4001E
	LDD  R26,Y+9
	CPI  R26,LOW(0xAA)
	BREQ _0x4001F
_0x4001E:
	RJMP _0x4001D
_0x4001F:
; 0002 00C1                     for (tmr = 12000; tmr && send_cmd(ACMD41, 1UL << 30); tmr--) ;	// Wait for leaving idle state (ACMD4 ...
	__GETWRN 20,21,12000
_0x40021:
	MOV  R0,R20
	OR   R0,R21
	BREQ _0x40023
	LDI  R30,LOW(233)
	ST   -Y,R30
	__GETD2N 0x40000000
	RCALL _send_cmd_G002
	CPI  R30,0
	BRNE _0x40024
_0x40023:
	RJMP _0x40022
_0x40024:
	__SUBWRN 20,21,1
	RJMP _0x40021
_0x40022:
; 0002 00C2                     if (tmr && send_cmd(CMD58, 0) == 0) {		// Check CCS bit in the OCR
	MOV  R0,R20
	OR   R0,R21
	BREQ _0x40026
	LDI  R30,LOW(122)
	CALL SUBOPT_0x1A
	CPI  R30,0
	BREQ _0x40027
_0x40026:
	RJMP _0x40025
_0x40027:
; 0002 00C3                         for (n = 0; n < 4; n++) ocr[n] = rcv_spi();
	LDI  R17,LOW(0)
_0x40029:
	CPI  R17,4
	BRSH _0x4002A
	CALL SUBOPT_0x1D
	PUSH R31
	PUSH R30
	RCALL _rcv_spi
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-1
	RJMP _0x40029
_0x4002A:
; 0002 00C4 ty = (ocr[0] & 0x40) ? 0x04	 | 0x08	 : 0x04	;
	LDD  R30,Y+6
	ANDI R30,LOW(0x40)
	BREQ _0x4002B
	LDI  R30,LOW(12)
	RJMP _0x4002C
_0x4002B:
	LDI  R30,LOW(4)
_0x4002C:
	MOV  R19,R30
; 0002 00C5                     }
; 0002 00C6                 }
_0x40025:
; 0002 00C7             } else {							// SDv1 or MMCv3
_0x4001D:
	RJMP _0x4002E
_0x40019:
; 0002 00C8                 if (send_cmd(ACMD41, 0) <= 1) 	{
	LDI  R30,LOW(233)
	CALL SUBOPT_0x1A
	CPI  R30,LOW(0x2)
	BRSH _0x4002F
; 0002 00C9                     ty = CT_SD1; cmd = ACMD41;	// SDv1
	LDI  R19,LOW(2)
	LDI  R16,LOW(233)
; 0002 00CA                 } else {
	RJMP _0x40030
_0x4002F:
; 0002 00CB                     ty = CT_MMC; cmd = CMD1;	// MMCv3
	LDI  R19,LOW(1)
	LDI  R16,LOW(65)
; 0002 00CC                 }
_0x40030:
; 0002 00CD                 for (tmr = 25000; tmr && send_cmd(cmd, 0); tmr--) ;	// Wait for leaving idle state
	__GETWRN 20,21,25000
_0x40032:
	MOV  R0,R20
	OR   R0,R21
	BREQ _0x40034
	ST   -Y,R16
	CALL SUBOPT_0x1E
	RCALL _send_cmd_G002
	CPI  R30,0
	BRNE _0x40035
_0x40034:
	RJMP _0x40033
_0x40035:
	__SUBWRN 20,21,1
	RJMP _0x40032
_0x40033:
; 0002 00CE                 if (!tmr || send_cmd(CMD16, 512) != 0)			// Set R/W block length to 512
	MOV  R0,R20
	OR   R0,R21
	BREQ _0x40037
	LDI  R30,LOW(80)
	ST   -Y,R30
	CALL SUBOPT_0x1F
	RCALL _send_cmd_G002
	CPI  R30,0
	BREQ _0x40036
_0x40037:
; 0002 00CF                     ty = 0;
	LDI  R19,LOW(0)
; 0002 00D0             }
_0x40036:
_0x4002E:
; 0002 00D1         }
; 0002 00D2         CardType = ty;
_0x40018:
	STS  _CardType_G002,R19
; 0002 00D3         release_spi();
	RCALL _release_spi_G002
; 0002 00D4         if(ty){
	CPI  R19,0
	BRNE _0x40014
; 0002 00D5            break;
; 0002 00D6         }
; 0002 00D7         retry++;
	SUBI R18,-1
; 0002 00D8         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0002 00D9     }
	RJMP _0x40012
_0x40014:
; 0002 00DA #ifdef hardware_spi
; 0002 00DB 	//для аппаратного SPI!!!--------------------------------------------
; 0002 00DC     //INIT_SPI();
; 0002 00DD     //SPCR &= ~((1 << SPR1) | (1 << SPR0)); // убираем предделитель
; 0002 00DE 	//SPSR |= (1 << SPI2X); // удваиваем частоту
; 0002 00DF 
; 0002 00E0 #else
; 0002 00E1     //------------------------------------------------------------------
; 0002 00E2 #endif
; 0002 00E3 
; 0002 00E4 	return ty ? 0 : STA_NOINIT;
	CPI  R19,0
	BREQ _0x4003A
	LDI  R30,LOW(0)
	RJMP _0x4003B
_0x4003A:
	LDI  R30,LOW(1)
_0x4003B:
	RJMP _0x20C0010
; 0002 00E5 }
; .FEND
;//-----------------------------------------------------------------------
;// Read partial sector
;//-----------------------------------------------------------------------
;
;DRESULT disk_readp (
; 0002 00EB 	BYTE *buff,		// Pointer to the read buffer (NULL:Read bytes are forwarded to the stream)
; 0002 00EC 	DWORD lba,		// Sector number (LBA)
; 0002 00ED 	WORD ofs,		// Byte offset to read from (0..511)
; 0002 00EE 	WORD cnt		// Number of bytes to read (ofs + cnt mus be <= 512)
; 0002 00EF )
; 0002 00F0 {
_disk_readp:
; .FSTART _disk_readp
; 0002 00F1 	DRESULT res;
; 0002 00F2 	BYTE rc;
; 0002 00F3 	WORD bc;
; 0002 00F4 
; 0002 00F5 //	if ((PINB&_BV(SD_INS))!=0x00) return RES_ERROR;
; 0002 00F6 
; 0002 00F7 	if (!(CardType & CT_BLOCK)) lba *= 512;		// Convert to byte address if needed
	CALL SUBOPT_0x20
;	*buff -> Y+12
;	lba -> Y+8
;	ofs -> Y+6
;	cnt -> Y+4
;	res -> R17
;	rc -> R16
;	bc -> R18,R19
	LDS  R30,_CardType_G002
	ANDI R30,LOW(0x8)
	BRNE _0x4003D
	CALL SUBOPT_0x14
	CALL SUBOPT_0x21
	__PUTD1S 8
; 0002 00F8 
; 0002 00F9 	res = RES_ERROR;
_0x4003D:
	LDI  R17,LOW(1)
; 0002 00FA 	if (send_cmd(CMD17, lba) == 0) {		// READ_SINGLE_BLOCK
	LDI  R30,LOW(81)
	ST   -Y,R30
	CALL SUBOPT_0x22
	RCALL _send_cmd_G002
	CPI  R30,0
	BREQ PC+2
	RJMP _0x4003E
; 0002 00FB 
; 0002 00FC 		bc = 30000;
	__GETWRN 18,19,30000
; 0002 00FD 		do {							// Wait for data packet in timeout of 100ms
_0x40040:
; 0002 00FE 			rc = rcv_spi();
	RCALL _rcv_spi
	MOV  R16,R30
; 0002 00FF 		} while (rc == 0xFF && --bc);
	CPI  R16,255
	BRNE _0x40042
	__SUBWRN 18,19,1
	BRNE _0x40043
_0x40042:
	RJMP _0x40041
_0x40043:
	RJMP _0x40040
_0x40041:
; 0002 0100 
; 0002 0101 		if (rc == 0xFE) {				// A data packet arrived
	CPI  R16,254
	BRNE _0x40044
; 0002 0102 			bc = 514 - ofs - cnt;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(514)
	LDI  R31,HIGH(514)
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUB  R26,R30
	SBC  R27,R31
	MOVW R18,R26
; 0002 0103 
; 0002 0104 			// Skip leading bytes
; 0002 0105 			if (ofs) {
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,0
	BREQ _0x40045
; 0002 0106 				do rcv_spi(); while (--ofs);
_0x40047:
	RCALL _rcv_spi
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	BRNE _0x40047
; 0002 0107 			}
; 0002 0108 
; 0002 0109 			// Receive a part of the sector
; 0002 010A 			if (buff) {	// Store data to the memory
_0x40045:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SBIW R30,0
	BREQ _0x40049
; 0002 010B 				do
_0x4004B:
; 0002 010C 					*buff++ = rcv_spi();
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ADIW R30,1
	STD  Y+12,R30
	STD  Y+12+1,R31
	SBIW R30,1
	PUSH R31
	PUSH R30
	RCALL _rcv_spi
	POP  R26
	POP  R27
	ST   X,R30
; 0002 010D 				while (--cnt);
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	BRNE _0x4004B
; 0002 010E 			} else {	// Forward data to the outgoing stream (depends on the project)
	RJMP _0x4004D
_0x40049:
; 0002 010F 				do
_0x4004F:
; 0002 0110                 ;//uart_transmit(rcv_spi());		// (Console output)
; 0002 0111 				while (--cnt);
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	BRNE _0x4004F
; 0002 0112 			}
_0x4004D:
; 0002 0113 
; 0002 0114 			// Skip trailing bytes and CRC
; 0002 0115 			do rcv_spi(); while (--bc);
_0x40052:
	RCALL _rcv_spi
	MOVW R30,R18
	SBIW R30,1
	MOVW R18,R30
	BRNE _0x40052
; 0002 0116 
; 0002 0117 			res = RES_OK;
	LDI  R17,LOW(0)
; 0002 0118 		}
; 0002 0119 	}
_0x40044:
; 0002 011A 
; 0002 011B 	release_spi();
_0x4003E:
	RCALL _release_spi_G002
; 0002 011C 
; 0002 011D 	return res;
	MOV  R30,R17
	CALL __LOADLOCR4
	RJMP _0x20C0011
; 0002 011E }
; .FEND
;
;//-----------------------------------------------------------------------
;// Write partial sector
;//-----------------------------------------------------------------------
;#if _WRITE_FUNC
;
;DRESULT disk_writep (
; 0002 0126 	const BYTE *buff,	// Pointer to the bytes to be written (NULL:Initiate/Finalize sector write)
; 0002 0127 	DWORD sa			// Number of bytes to send, Sector number (LBA) or zero
; 0002 0128 )
; 0002 0129 {
_disk_writep:
; .FSTART _disk_writep
; 0002 012A 	DRESULT res;
; 0002 012B 	WORD bc;
; 0002 012C 	static WORD wc;
; 0002 012D 
; 0002 012E //	if ((PINB&_BV(SD_INS))!=0x00) return RES_ERROR;
; 0002 012F //	if ((PINB&_BV(SD_WP))!=0x00) return RES_ERROR;
; 0002 0130 
; 0002 0131 	res = RES_ERROR;
	CALL __PUTPARD2
	CALL __SAVELOCR4
;	*buff -> Y+8
;	sa -> Y+4
;	res -> R17
;	bc -> R18,R19
	LDI  R17,LOW(1)
; 0002 0132 
; 0002 0133 	if (buff) {		// Send data bytes
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BREQ _0x40054
; 0002 0134 		bc = (WORD)sa;
	__GETWRS 18,19,4
; 0002 0135 		while (bc && wc) {		// Send data bytes to the card
_0x40055:
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x40058
	LDS  R30,_wc_S0020007000
	LDS  R31,_wc_S0020007000+1
	SBIW R30,0
	BRNE _0x40059
_0x40058:
	RJMP _0x40057
_0x40059:
; 0002 0136 			xmit_spi(*buff++);
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LD   R30,X+
	STD  Y+8,R26
	STD  Y+8+1,R27
	MOV  R26,R30
	RCALL _xmit_spi
; 0002 0137 			wc--; bc--;
	LDI  R26,LOW(_wc_S0020007000)
	LDI  R27,HIGH(_wc_S0020007000)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	__SUBWRN 18,19,1
; 0002 0138 		}
	RJMP _0x40055
_0x40057:
; 0002 0139 		res = RES_OK;
	LDI  R17,LOW(0)
; 0002 013A 	} else {
	RJMP _0x4005A
_0x40054:
; 0002 013B 		if (sa) {	// Initiate sector write process
	CALL SUBOPT_0xC
	CALL __CPD10
	BREQ _0x4005B
; 0002 013C 			if (!(CardType & CT_BLOCK)) sa *= 512;	// Convert to byte address if needed
	LDS  R30,_CardType_G002
	ANDI R30,LOW(0x8)
	BRNE _0x4005C
	CALL SUBOPT_0xC
	CALL SUBOPT_0x21
	CALL SUBOPT_0x15
; 0002 013D 			if (send_cmd(CMD24, sa) == 0) {			// WRITE_SINGLE_BLOCK
_0x4005C:
	LDI  R30,LOW(88)
	ST   -Y,R30
	__GETD2S 5
	RCALL _send_cmd_G002
	CPI  R30,0
	BRNE _0x4005D
; 0002 013E 				xmit_spi(0xFF); xmit_spi(0xFE);		// Data block header
	LDI  R26,LOW(255)
	RCALL _xmit_spi
	LDI  R26,LOW(254)
	RCALL _xmit_spi
; 0002 013F 				wc = 512;							// Set byte counter
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	STS  _wc_S0020007000,R30
	STS  _wc_S0020007000+1,R31
; 0002 0140 				res = RES_OK;
	LDI  R17,LOW(0)
; 0002 0141 			}
; 0002 0142 		} else {	// Finalize sector write process
_0x4005D:
	RJMP _0x4005E
_0x4005B:
; 0002 0143 			bc = wc + 2;
	LDS  R30,_wc_S0020007000
	LDS  R31,_wc_S0020007000+1
	ADIW R30,2
	MOVW R18,R30
; 0002 0144 			while (bc--) xmit_spi(0);	// Fill left bytes and CRC with zeros
_0x4005F:
	MOVW R30,R18
	__SUBWRN 18,19,1
	SBIW R30,0
	BREQ _0x40061
	LDI  R26,LOW(0)
	RCALL _xmit_spi
	RJMP _0x4005F
_0x40061:
; 0002 0145 if ((rcv_spi() & 0x1F) == 0x05) {
	RCALL _rcv_spi
	ANDI R30,LOW(0x1F)
	CPI  R30,LOW(0x5)
	BRNE _0x40062
; 0002 0146 				for (bc = 65000; rcv_spi() != 0xFF && bc; bc--) ;	// Wait ready
	__GETWRN 18,19,-536
_0x40064:
	RCALL _rcv_spi
	CPI  R30,LOW(0xFF)
	BREQ _0x40066
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x40067
_0x40066:
	RJMP _0x40065
_0x40067:
	__SUBWRN 18,19,1
	RJMP _0x40064
_0x40065:
; 0002 0147 				if (bc) res = RES_OK;
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x40068
	LDI  R17,LOW(0)
; 0002 0148 			}
_0x40068:
; 0002 0149 			release_spi();
_0x40062:
	RCALL _release_spi_G002
; 0002 014A 		}
_0x4005E:
; 0002 014B 	}
_0x4005A:
; 0002 014C 
; 0002 014D 	return res;
	MOV  R30,R17
	CALL __LOADLOCR4
	RJMP _0x20C000F
; 0002 014E }
; .FEND
;#endif
;/*----------------------------------------------------------------------------/
;/  Petit FatFs - FAT file system module  R0.02                 (C)ChaN, 2009
;/-----------------------------------------------------------------------------/
;/ Petit FatFs module is an open source software to implement FAT file system to
;/ small embedded systems. This is a free software and is opened for education,
;/ research and commercial developments under license policy of following trems.
;/
;/  Copyright (C) 2009, ChaN, all right reserved.
;/
;/ * The Petit FatFs module is a free software and there is NO WARRANTY.
;/ * No restriction on use. You can use, modify and redistribute it for
;/   personal, non-profit or commercial use UNDER YOUR RESPONSIBILITY.
;/ * Redistributions of source code must retain the above copyright notice.
;/
;/-----------------------------------------------------------------------------/
;/ Jun 15,'09  R0.01a  First release. (Branched from FatFs R0.07b.)
;/
;/ Dec 14,'09  R0.02   Added multiple code page support.
;/                     Added write funciton.
;/                     Changed stream read mode interface.
;/----------------------------------------------------------------------------*/
;
;#include "pff_rn.h"		/* Petit FatFs configurations and declarations */
;#include "diskio.h"		/* Declarations of low level disk I/O functions */
;#include <string.h>
;
;/*--------------------------------------------------------------------------
;
;   Private Functions
;
;---------------------------------------------------------------------------*/
;
;static
;FATFS *FatFs;	/* Pointer to the file system object (logical drive) */
;
;
;
;/*-----------------------------------------------------------------------*/
;/* String functions                                                      */
;/*-----------------------------------------------------------------------*/
;
;/* Fill memory */
;static
;void mem_set (void* dst, int val, int cnt) {
; 0003 002C void mem_set (void* dst, int val, int cnt) {

	.CSEG
_mem_set_G003:
; .FSTART _mem_set_G003
; 0003 002D 	char *d = (char*)dst;
; 0003 002E 	while (cnt--) *d++ = (char)val;
	CALL SUBOPT_0xB
;	*dst -> Y+6
;	val -> Y+4
;	cnt -> Y+2
;	*d -> R16,R17
	__GETWRS 16,17,6
_0x60003:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
	ADIW R30,1
	BREQ _0x60005
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	LDD  R30,Y+4
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x60003
_0x60005:
; 0003 002F }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C000E
; .FEND
;
;/* Compare memory to memory */
;static
;int mem_cmp (const void* dst, const void* src, int cnt) {
; 0003 0033 int mem_cmp (const void* dst, const void* src, int cnt) {
_mem_cmp_G003:
; .FSTART _mem_cmp_G003
; 0003 0034 	const char *d = (const char *)dst, *s = (const char *)src;
; 0003 0035 	int r = 0;
; 0003 0036 	while (cnt-- && (r = *d++ - *s++) == 0) ;
	CALL SUBOPT_0x23
;	*dst -> Y+10
;	*src -> Y+8
;	cnt -> Y+6
;	*d -> R16,R17
;	*s -> R18,R19
;	r -> R20,R21
	__GETWRS 16,17,10
	__GETWRS 18,19,8
	__GETWRN 20,21,0
_0x60006:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	ADIW R30,1
	BREQ _0x60009
	MOVW R26,R16
	__ADDWRN 16,17,1
	LD   R0,X
	CLR  R1
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R26,X
	CLR  R27
	MOVW R30,R0
	SUB  R30,R26
	SBC  R31,R27
	MOVW R20,R30
	SBIW R30,0
	BREQ _0x6000A
_0x60009:
	RJMP _0x60008
_0x6000A:
	RJMP _0x60006
_0x60008:
; 0003 0037 	return r;
	MOVW R30,R20
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; 0003 0038 }
; .FEND
;
;
;
;/*-----------------------------------------------------------------------*/
;/* FAT access - Read value of a FAT entry                                */
;/*-----------------------------------------------------------------------*/
;
;static
;CLUST get_fat (	/* 1:IO error, Else:Cluster status */
; 0003 0042 	CLUST clst	/* Cluster# to get the link information */
; 0003 0043 )
; 0003 0044 {
_get_fat_G003:
; .FSTART _get_fat_G003
; 0003 0045 	WORD wc, bc, ofs;
; 0003 0046 	BYTE buf[4];
; 0003 0047 	FATFS *fs = FatFs;
; 0003 0048 
; 0003 0049 
; 0003 004A 	if (clst < 2 || clst >= fs->max_clust)	/* Range check */
	CALL __PUTPARD2
	SBIW R28,6
	CALL __SAVELOCR6
;	clst -> Y+12
;	wc -> R16,R17
;	bc -> R18,R19
;	ofs -> R20,R21
;	buf -> Y+8
;	*fs -> Y+6
	CALL SUBOPT_0x24
	STD  Y+6,R30
	STD  Y+6+1,R31
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	BRLO _0x6000C
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,8
	CALL __GETD1P
	CALL SUBOPT_0x25
	CALL __CPD21
	BRLO _0x6000B
_0x6000C:
; 0003 004B 		return 1;
	RJMP _0x20C0013
; 0003 004C 
; 0003 004D 	switch (fs->fs_type) {
_0x6000B:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X
	LDI  R31,0
; 0003 004E 	case FS_FAT12 :
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x60011
; 0003 004F 		bc = (WORD)clst; bc += bc / 2;
	__GETWRS 18,19,12
	MOVW R30,R18
	LSR  R31
	ROR  R30
	__ADDWRR 18,19,30,31
; 0003 0050 		ofs = bc % 512; bc /= 512;
	MOVW R30,R18
	ANDI R31,HIGH(0x1FF)
	MOVW R20,R30
	MOVW R26,R18
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL __DIVW21U
	MOVW R18,R30
; 0003 0051 		if (ofs != 511) {
	LDI  R30,LOW(511)
	LDI  R31,HIGH(511)
	CP   R30,R20
	CPC  R31,R21
	BREQ _0x60012
; 0003 0052 			if (disk_readp(buf, fs->fatbase + bc, ofs, 2)) break;
	CALL SUBOPT_0x27
	CALL __PUTPARD1
	ST   -Y,R21
	ST   -Y,R20
	CALL SUBOPT_0x28
	BREQ _0x60013
	RJMP _0x60010
; 0003 0053 		} else {
_0x60013:
	RJMP _0x60014
_0x60012:
; 0003 0054 			if (disk_readp(buf, fs->fatbase + bc, 511, 1)) break;
	CALL SUBOPT_0x27
	CALL __PUTPARD1
	LDI  R30,LOW(511)
	LDI  R31,HIGH(511)
	CALL SUBOPT_0x29
	BREQ _0x60015
	RJMP _0x60010
; 0003 0055 			if (disk_readp(buf+1, fs->fatbase + bc + 1, 0, 1)) break;
_0x60015:
	MOVW R30,R28
	ADIW R30,9
	CALL SUBOPT_0x2A
	MOVW R30,R18
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2B
	CALL __PUTPARD1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x29
	BREQ _0x60016
	RJMP _0x60010
; 0003 0056 		}
_0x60016:
_0x60014:
; 0003 0057 		wc = LD_WORD(buf);
	__GETWRS 16,17,8
; 0003 0058 		return (clst & 1) ? (wc >> 4) : (wc & 0xFFF);
	LDD  R30,Y+12
	ANDI R30,LOW(0x1)
	BREQ _0x60017
	MOVW R30,R16
	CALL __LSRW4
	RJMP _0x60111
_0x60017:
	MOVW R30,R16
	ANDI R31,HIGH(0xFFF)
_0x60111:
	CLR  R22
	CLR  R23
	RJMP _0x20C0012
; 0003 0059 
; 0003 005A 	case FS_FAT16 :
_0x60011:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6001A
; 0003 005B 		if (disk_readp(buf, fs->fatbase + clst / 256, (WORD)(((WORD)clst % 256) * 2), 2)) break;
	MOVW R30,R28
	ADIW R30,8
	CALL SUBOPT_0x2A
	PUSH R25
	PUSH R24
	PUSH R27
	PUSH R26
	CALL SUBOPT_0x2C
	__GETD1N 0x100
	CALL __DIVD21U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x2D
	ANDI R31,HIGH(0xFF)
	LSL  R30
	ROL  R31
	CALL SUBOPT_0x2E
	BRNE _0x60010
; 0003 005C 		return LD_WORD(buf);
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CLR  R22
	CLR  R23
	RJMP _0x20C0012
; 0003 005D #if _FS_FAT32
; 0003 005E 	case FS_FAT32 :
_0x6001A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x60010
; 0003 005F 		if (disk_readp(buf, fs->fatbase + clst / 128, (WORD)(((WORD)clst % 128) * 4), 4)) break;
	MOVW R30,R28
	ADIW R30,8
	CALL SUBOPT_0x2A
	PUSH R25
	PUSH R24
	PUSH R27
	PUSH R26
	CALL SUBOPT_0x2C
	__GETD1N 0x80
	CALL __DIVD21U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x2D
	ANDI R30,LOW(0x7F)
	ANDI R31,HIGH(0x7F)
	CALL __LSLW2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	CALL SUBOPT_0x2F
	BRNE _0x60010
; 0003 0060 		return LD_DWORD(buf) & 0x0FFFFFFF;
	CALL SUBOPT_0x14
	__ANDD1N 0xFFFFFFF
	RJMP _0x20C0012
; 0003 0061 #endif
; 0003 0062 	}
_0x60010:
; 0003 0063 
; 0003 0064 	return 1;	/* An error occured at the disk I/O layer */
_0x20C0013:
	__GETD1N 0x1
_0x20C0012:
	CALL __LOADLOCR6
	ADIW R28,16
	RET
; 0003 0065 }
; .FEND
;
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Get sector# from cluster#                                             */
;/*-----------------------------------------------------------------------*/
;
;static
;DWORD clust2sect (	/* !=0: Sector number, 0: Failed - invalid cluster# */
; 0003 0070 	CLUST clst		/* Cluster# to be converted */
; 0003 0071 )
; 0003 0072 {
_clust2sect_G003:
; .FSTART _clust2sect_G003
; 0003 0073 	FATFS *fs = FatFs;
; 0003 0074 
; 0003 0075 
; 0003 0076 	clst -= 2;
	CALL __PUTPARD2
	CALL SUBOPT_0x30
;	clst -> Y+2
;	*fs -> R16,R17
	CALL SUBOPT_0x1C
	__SUBD1N 2
	CALL SUBOPT_0x31
; 0003 0077 	if (clst >= (fs->max_clust - 2)) return 0;		/* Invalid cluster# */
	MOVW R30,R16
	__GETD2Z 8
	__GETD1N 0x2
	CALL __SWAPD12
	CALL __SUBD12
	CALL SUBOPT_0x32
	CALL __CPD21
	BRLO _0x6001E
	CALL SUBOPT_0x33
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C000D
; 0003 0078 	return (DWORD)clst * fs->csize + fs->database;
_0x6001E:
	MOVW R30,R16
	LDD  R30,Z+1
	LDI  R31,0
	CALL SUBOPT_0x32
	CALL __CWD1
	CALL __MULD12U
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R26,R16
	ADIW R26,20
	CALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C000D
; 0003 0079 }
; .FEND
;
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Directory handling - Rewind directory index                           */
;/*-----------------------------------------------------------------------*/
;
;static
;FRESULT dir_rewind (
; 0003 0084 	DIR *dj			/* Pointer to directory object */
; 0003 0085 )
; 0003 0086 {
_dir_rewind_G003:
; .FSTART _dir_rewind_G003
; 0003 0087 	CLUST clst;
; 0003 0088 	FATFS *fs = FatFs;
; 0003 0089 
; 0003 008A 
; 0003 008B 	dj->index = 0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL SUBOPT_0x30
;	*dj -> Y+6
;	clst -> Y+2
;	*fs -> R16,R17
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x34
; 0003 008C 	clst = dj->sclust;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,4
	CALL SUBOPT_0x35
; 0003 008D 	if (clst == 1 || clst >= fs->max_clust)	/* Check start cluster range */
	CALL SUBOPT_0x32
	__CPD2N 0x1
	BREQ _0x60020
	MOVW R26,R16
	ADIW R26,8
	CALL __GETD1P
	CALL SUBOPT_0x32
	CALL __CPD21
	BRLO _0x6001F
_0x60020:
; 0003 008E 		return FR_DISK_ERR;
	LDI  R30,LOW(1)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C000E
; 0003 008F #if _FS_FAT32
; 0003 0090 	if (!clst && fs->fs_type == FS_FAT32)	/* Replace cluster# 0 with root cluster# if in FAT32 */
_0x6001F:
	CALL SUBOPT_0x1C
	CALL __CPD10
	BRNE _0x60023
	MOVW R26,R16
	LD   R26,X
	CPI  R26,LOW(0x3)
	BREQ _0x60024
_0x60023:
	RJMP _0x60022
_0x60024:
; 0003 0091 		clst = fs->dirbase;
	MOVW R26,R16
	ADIW R26,16
	CALL SUBOPT_0x35
; 0003 0092 #endif
; 0003 0093 	dj->clust = clst;						/* Current cluster */
_0x60022:
	CALL SUBOPT_0x1C
	__PUTD1SNS 6,8
; 0003 0094 	dj->sect = clst ? clust2sect(clst) : fs->dirbase;	/* Current sector */
	CALL SUBOPT_0x1C
	CALL __CPD10
	BREQ _0x60025
	CALL SUBOPT_0x32
	RCALL _clust2sect_G003
	RJMP _0x60026
_0x60025:
	MOVW R26,R16
	ADIW R26,16
	CALL __GETD1P
_0x60026:
	__PUTD1SNS 6,12
; 0003 0095 
; 0003 0096 	return FR_OK;	/* Seek succeeded */
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C000E
; 0003 0097 }
; .FEND
;
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Directory handling - Move directory index next                        */
;/*-----------------------------------------------------------------------*/
;
;static
;FRESULT dir_next (	/* FR_OK:Succeeded, FR_NO_FILE:End of table */
; 0003 00A2 	DIR *dj			/* Pointer to directory object */
; 0003 00A3 )
; 0003 00A4 {
_dir_next_G003:
; .FSTART _dir_next_G003
; 0003 00A5 	CLUST clst;
; 0003 00A6 	WORD i;
; 0003 00A7 	FATFS *fs = FatFs;
; 0003 00A8 
; 0003 00A9 
; 0003 00AA 	i = dj->index + 1;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL SUBOPT_0x36
;	*dj -> Y+8
;	clst -> Y+4
;	i -> R16,R17
;	*fs -> R18,R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,1
	MOVW R16,R30
; 0003 00AB 	if (!i || !dj->sect)	/* Report EOT when index has reached 65535 */
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x60029
	CALL SUBOPT_0x37
	BRNE _0x60028
_0x60029:
; 0003 00AC 		return FR_NO_FILE;
	LDI  R30,LOW(3)
	CALL __LOADLOCR4
	RJMP _0x20C000F
; 0003 00AD 
; 0003 00AE 	if (!(i & (16-1))) {	/* Sector changed? */
_0x60028:
	MOVW R30,R16
	ANDI R30,LOW(0xF)
	BREQ PC+2
	RJMP _0x6002B
; 0003 00AF 		dj->sect++;			/* Next sector */
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,12
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0003 00B0 
; 0003 00B1 		if (dj->clust == 0) {	/* Static table */
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,8
	CALL __GETD1P
	CALL __CPD10
	BRNE _0x6002C
; 0003 00B2 			if (i >= fs->n_rootdir)	/* Report EOT when end of table */
	MOVW R26,R18
	ADIW R26,4
	CALL __GETW1P
	CP   R16,R30
	CPC  R17,R31
	BRLO _0x6002D
; 0003 00B3 				return FR_NO_FILE;
	LDI  R30,LOW(3)
	CALL __LOADLOCR4
	RJMP _0x20C000F
; 0003 00B4 		}
_0x6002D:
; 0003 00B5 		else {					/* Dynamic table */
	RJMP _0x6002E
_0x6002C:
; 0003 00B6 			if (((i / 16) & (fs->csize-1)) == 0) {	/* Cluster changed? */
	MOVW R30,R16
	CALL __LSRW4
	MOVW R26,R30
	MOVW R30,R18
	LDD  R30,Z+1
	LDI  R31,0
	SBIW R30,1
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x6002F
; 0003 00B7 				clst = get_fat(dj->clust);		/* Get next cluster */
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	__GETD2Z 8
	RCALL _get_fat_G003
	CALL SUBOPT_0x15
; 0003 00B8 				if (clst <= 1) return FR_DISK_ERR;
	CALL SUBOPT_0x38
	CALL SUBOPT_0x26
	BRSH _0x60030
	LDI  R30,LOW(1)
	CALL __LOADLOCR4
	RJMP _0x20C000F
; 0003 00B9 				if (clst >= fs->max_clust)		/* When it reached end of dynamic table */
_0x60030:
	MOVW R26,R18
	ADIW R26,8
	CALL __GETD1P
	CALL SUBOPT_0x38
	CALL __CPD21
	BRLO _0x60031
; 0003 00BA 					return FR_NO_FILE;			/* Report EOT */
	LDI  R30,LOW(3)
	CALL __LOADLOCR4
	RJMP _0x20C000F
; 0003 00BB 				dj->clust = clst;				/* Initialize data for new cluster */
_0x60031:
	CALL SUBOPT_0xC
	__PUTD1SNS 8,8
; 0003 00BC 				dj->sect = clust2sect(clst);
	CALL SUBOPT_0x38
	RCALL _clust2sect_G003
	__PUTD1SNS 8,12
; 0003 00BD 			}
; 0003 00BE 		}
_0x6002F:
_0x6002E:
; 0003 00BF 	}
; 0003 00C0 
; 0003 00C1 	dj->index = i;
_0x6002B:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ST   X+,R16
	ST   X,R17
; 0003 00C2 
; 0003 00C3 	return FR_OK;
	LDI  R30,LOW(0)
	CALL __LOADLOCR4
	RJMP _0x20C000F
; 0003 00C4 }
; .FEND
;
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Directory handling - Find an object in the directory                  */
;/*-----------------------------------------------------------------------*/
;
;static
;FRESULT dir_find (
; 0003 00CF 	DIR *dj			/* Pointer to the directory object linked to the file name */
; 0003 00D0 )
; 0003 00D1 {
_dir_find_G003:
; .FSTART _dir_find_G003
; 0003 00D2 	FRESULT res;
; 0003 00D3 	BYTE c, *dir;
; 0003 00D4 
; 0003 00D5 
; 0003 00D6 	res = dir_rewind(dj);			/* Rewind directory object */
	CALL SUBOPT_0x20
;	*dj -> Y+4
;	res -> R17
;	c -> R16
;	*dir -> R18,R19
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _dir_rewind_G003
	MOV  R17,R30
; 0003 00D7 	if (res != FR_OK) return res;
	CPI  R17,0
	BREQ _0x60032
	CALL __LOADLOCR4
	RJMP _0x20C000D
; 0003 00D8 
; 0003 00D9 	dir = FatFs->buf;
_0x60032:
	CALL SUBOPT_0x39
	LD   R18,X+
	LD   R19,X
; 0003 00DA 	do {
_0x60034:
; 0003 00DB 		res = disk_readp(dir, dj->sect, (WORD)((dj->index % 16) * 32), 32)	/* Read an entry */
; 0003 00DC 			? FR_DISK_ERR : FR_OK;
	ST   -Y,R19
	ST   -Y,R18
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x3A
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x3B
	BREQ _0x60036
	LDI  R30,LOW(1)
	RJMP _0x60037
_0x60036:
	LDI  R30,LOW(0)
_0x60037:
	MOV  R17,R30
; 0003 00DD 		if (res != FR_OK) break;
	CPI  R17,0
	BRNE _0x60035
; 0003 00DE 		c = dir[DIR_Name];	/* First character */
	MOVW R26,R18
	LD   R16,X
; 0003 00DF 		if (c == 0) { res = FR_NO_FILE; break; }	/* Reached to end of table */
	CPI  R16,0
	BRNE _0x6003A
	LDI  R17,LOW(3)
	RJMP _0x60035
; 0003 00E0 		if (!(dir[DIR_Attr] & AM_VOL) && !mem_cmp(dir, dj->fn, 11)) /* Is it a valid entry? */
_0x6003A:
	MOVW R30,R18
	LDD  R30,Z+11
	ANDI R30,LOW(0x8)
	BRNE _0x6003C
	ST   -Y,R19
	ST   -Y,R18
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+2
	LDD  R27,Z+3
	ST   -Y,R27
	ST   -Y,R26
	LDI  R26,LOW(11)
	LDI  R27,0
	RCALL _mem_cmp_G003
	SBIW R30,0
	BREQ _0x6003D
_0x6003C:
	RJMP _0x6003B
_0x6003D:
; 0003 00E1 			break;
	RJMP _0x60035
; 0003 00E2 		res = dir_next(dj);							/* Next entry */
_0x6003B:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _dir_next_G003
	MOV  R17,R30
; 0003 00E3 	} while (res == FR_OK);
	CPI  R17,0
	BREQ _0x60034
_0x60035:
; 0003 00E4 
; 0003 00E5 	return res;
	MOV  R30,R17
	CALL __LOADLOCR4
	RJMP _0x20C000D
; 0003 00E6 }
; .FEND
;
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Read an object from the directory                                     */
;/*-----------------------------------------------------------------------*/
;#if _USE_DIR
;static
;FRESULT dir_read (
; 0003 00F1 	DIR *dj			/* Pointer to the directory object to store read object name */
; 0003 00F2 )
; 0003 00F3 {
_dir_read_G003:
; .FSTART _dir_read_G003
; 0003 00F4 	FRESULT res;
; 0003 00F5 	BYTE a, c, *dir;
; 0003 00F6 
; 0003 00F7 
; 0003 00F8 	res = FR_NO_FILE;
	CALL SUBOPT_0x23
;	*dj -> Y+6
;	res -> R17
;	a -> R16
;	c -> R19
;	*dir -> R20,R21
	LDI  R17,LOW(3)
; 0003 00F9 	dir = FatFs->buf;
	CALL SUBOPT_0x39
	LD   R20,X+
	LD   R21,X
; 0003 00FA 	while (dj->sect) {
_0x6003E:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	CALL __GETD1P
	CALL __CPD10
	BREQ _0x60040
; 0003 00FB 		res = disk_readp(dir, dj->sect, (WORD)((dj->index % 16) * 32), 32)	/* Read an entry */
; 0003 00FC 			? FR_DISK_ERR : FR_OK;
	ST   -Y,R21
	ST   -Y,R20
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL SUBOPT_0x3A
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x3B
	BREQ _0x60041
	LDI  R30,LOW(1)
	RJMP _0x60042
_0x60041:
	LDI  R30,LOW(0)
_0x60042:
	MOV  R17,R30
; 0003 00FD 		if (res != FR_OK) break;
	CPI  R17,0
	BRNE _0x60040
; 0003 00FE 		c = dir[DIR_Name];
	MOVW R26,R20
	LD   R19,X
; 0003 00FF 		if (c == 0) { res = FR_NO_FILE; break; }	/* Reached to end of table */
	CPI  R19,0
	BRNE _0x60045
	LDI  R17,LOW(3)
	RJMP _0x60040
; 0003 0100 		a = dir[DIR_Attr] & AM_MASK;
_0x60045:
	MOVW R30,R20
	LDD  R30,Z+11
	ANDI R30,LOW(0x3F)
	MOV  R16,R30
; 0003 0101 		if (c != 0xE5 && c != '.' && !(a & AM_VOL))	/* Is it a valid entry? */
	CPI  R19,229
	BREQ _0x60047
	CPI  R19,46
	BREQ _0x60047
	SBRS R16,3
	RJMP _0x60048
_0x60047:
	RJMP _0x60046
_0x60048:
; 0003 0102 			break;
	RJMP _0x60040
; 0003 0103 		res = dir_next(dj);				/* Next entry */
_0x60046:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL _dir_next_G003
	MOV  R17,R30
; 0003 0104 		if (res != FR_OK) break;
	CPI  R17,0
	BREQ _0x6003E
; 0003 0105 	}
_0x60040:
; 0003 0106 
; 0003 0107 	if (res != FR_OK) dj->sect = 0;
	CPI  R17,0
	BREQ _0x6004A
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x3C
; 0003 0108 
; 0003 0109 	return res;
_0x6004A:
	MOV  R30,R17
	CALL __LOADLOCR6
	RJMP _0x20C000E
; 0003 010A }
; .FEND
;
;#endif
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Pick a segment and create the object name in directory form           */
;/*-----------------------------------------------------------------------*/
;
;#ifdef _EXCVT
;	static const BYTE cvt[] = _EXCVT;
;#endif
;
;static
;FRESULT create_name (
; 0003 011A 	DIR *dj,			/* Pointer to the directory object */
; 0003 011B 	const char **path	/* Pointer to pointer to the segment in the path string */
; 0003 011C )
; 0003 011D {
_create_name_G003:
; .FSTART _create_name_G003
; 0003 011E 	BYTE c, d, ni, si, i, *sfn;
; 0003 011F 	const char *p;
; 0003 0120 
; 0003 0121 	/* Create file name in directory form */
; 0003 0122 	sfn = dj->fn;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR6
;	*dj -> Y+12
;	*path -> Y+10
;	c -> R17
;	d -> R16
;	ni -> R19
;	si -> R18
;	i -> R21
;	*sfn -> Y+8
;	*p -> Y+6
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADIW R26,2
	CALL __GETW1P
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0003 0123 	mem_set(sfn, ' ', 11);
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(11)
	LDI  R27,0
	RCALL _mem_set_G003
; 0003 0124 	si = i = 0; ni = 8;
	LDI  R30,LOW(0)
	MOV  R21,R30
	MOV  R18,R30
	LDI  R19,LOW(8)
; 0003 0125 	p = *path;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0003 0126 	for (;;) {
_0x6004C:
; 0003 0127 		c = p[si++];
	CALL SUBOPT_0x3D
	LD   R17,X
; 0003 0128 		if (c <= ' ' || c == '/') break;	/* Break on end of segment */
	CPI  R17,33
	BRLO _0x6004F
	CPI  R17,47
	BRNE _0x6004E
_0x6004F:
	RJMP _0x6004D
; 0003 0129 		if (c == '.' || i >= ni) {
_0x6004E:
	CPI  R17,46
	BREQ _0x60052
	CP   R21,R19
	BRLO _0x60051
_0x60052:
; 0003 012A 			if (ni != 8 || c != '.') break;
	CPI  R19,8
	BRNE _0x60055
	CPI  R17,46
	BREQ _0x60054
_0x60055:
	RJMP _0x6004D
; 0003 012B 			i = 8; ni = 11;
_0x60054:
	LDI  R21,LOW(8)
	LDI  R19,LOW(11)
; 0003 012C 			continue;
	RJMP _0x6004B
; 0003 012D 		}
; 0003 012E #ifdef _EXCVT
; 0003 012F 		if (c >= 0x80)					/* To upper extended char (SBCS) */
_0x60051:
	CPI  R17,128
	BRLO _0x60057
; 0003 0130 			c = cvt[c - 0x80];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(128)
	SBCI R31,HIGH(128)
	CLR  R22
	CLR  R23
	SUBI R30,LOW(-_cvt_G003*2)
	SBCI R31,HIGH(-_cvt_G003*2)
	SBCI R22,BYTE3(-_cvt_G003*2)
	__GETBRPF 17
; 0003 0131 #endif
; 0003 0132 		if (IsDBCS1(c) && i >= ni - 1) {	/* DBC 1st byte? */
_0x60057:
	LDI  R30,LOW(0)
	CPI  R30,0
	BREQ _0x60059
	MOV  R30,R19
	LDI  R31,0
	SBIW R30,1
	MOV  R26,R21
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x6005A
_0x60059:
	RJMP _0x60058
_0x6005A:
; 0003 0133 			d = p[si++];					/* Get 2nd byte */
	CALL SUBOPT_0x3D
	LD   R16,X
; 0003 0134 			sfn[i++] = c;
	CALL SUBOPT_0x3E
	ST   Z,R17
; 0003 0135 			sfn[i++] = d;
	CALL SUBOPT_0x3E
	ST   Z,R16
; 0003 0136 		} else {						/* Single byte code */
	RJMP _0x6005B
_0x60058:
; 0003 0137 			if (IsLower(c)) c -= 0x20;	/* toupper */
	CPI  R17,97
	BRLO _0x6005D
	CPI  R17,123
	BRLO _0x6005E
_0x6005D:
	RJMP _0x6005C
_0x6005E:
	SUBI R17,LOW(32)
; 0003 0138 			sfn[i++] = c;
_0x6005C:
	CALL SUBOPT_0x3E
	ST   Z,R17
; 0003 0139 		}
_0x6005B:
; 0003 013A 	}
_0x6004B:
	RJMP _0x6004C
_0x6004D:
; 0003 013B 	*path = &p[si];						/* Rerurn pointer to the next segment */
	MOV  R30,R18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ST   X+,R30
	ST   X,R31
; 0003 013C 
; 0003 013D 	sfn[11] = (c <= ' ') ? 1 : 0;		/* Set last segment flag if end of path */
	CPI  R17,33
	BRSH _0x6005F
	LDI  R30,LOW(1)
	RJMP _0x60060
_0x6005F:
	LDI  R30,LOW(0)
_0x60060:
	__PUTB1SNS 8,11
; 0003 013E 
; 0003 013F 	return FR_OK;
	LDI  R30,LOW(0)
	CALL __LOADLOCR6
_0x20C0011:
	ADIW R28,14
	RET
; 0003 0140 }
; .FEND
;
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Get file information from directory entry                             */
;/*-----------------------------------------------------------------------*/
;#if _USE_DIR
;static
;void get_fileinfo (		/* No return code */
; 0003 014B 	DIR *dj,			/* Pointer to the directory object */
; 0003 014C 	FILINFO *fno	 	/* Pointer to store the file information */
; 0003 014D )
; 0003 014E {
_get_fileinfo_G003:
; .FSTART _get_fileinfo_G003
; 0003 014F 	BYTE i, c, *dir;
; 0003 0150 	char *p;
; 0003 0151 
; 0003 0152 
; 0003 0153 	p = fno->fname;
	CALL SUBOPT_0x23
;	*dj -> Y+8
;	*fno -> Y+6
;	i -> R17
;	c -> R16
;	*dir -> R18,R19
;	*p -> R20,R21
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,9
	MOVW R20,R30
; 0003 0154 	if (dj->sect) {
	CALL SUBOPT_0x37
	BRNE PC+2
	RJMP _0x60062
; 0003 0155 		dir = FatFs->buf;
	CALL SUBOPT_0x39
	LD   R18,X+
	LD   R19,X
; 0003 0156 		for (i = 0; i < 8; i++) {	/* Copy file name body */
	LDI  R17,LOW(0)
_0x60064:
	CPI  R17,8
	BRSH _0x60065
; 0003 0157 			c = dir[i];
	CALL SUBOPT_0x3F
; 0003 0158 			if (c == ' ') break;
	BREQ _0x60065
; 0003 0159 			if (c == 0x05) c = 0xE5;
	CPI  R16,5
	BRNE _0x60067
	LDI  R16,LOW(229)
; 0003 015A 			*p++ = c;
_0x60067:
	PUSH R21
	PUSH R20
	__ADDWRN 20,21,1
	MOV  R30,R16
	POP  R26
	POP  R27
	ST   X,R30
; 0003 015B 		}
	SUBI R17,-1
	RJMP _0x60064
_0x60065:
; 0003 015C 		if (dir[8] != ' ') {		/* Copy file name extension */
	MOVW R30,R18
	LDD  R26,Z+8
	CPI  R26,LOW(0x20)
	BREQ _0x60068
; 0003 015D 			*p++ = '.';
	MOVW R26,R20
	__ADDWRN 20,21,1
	LDI  R30,LOW(46)
	ST   X,R30
; 0003 015E 			for (i = 8; i < 11; i++) {
	LDI  R17,LOW(8)
_0x6006A:
	CPI  R17,11
	BRSH _0x6006B
; 0003 015F 				c = dir[i];
	CALL SUBOPT_0x3F
; 0003 0160 				if (c == ' ') break;
	BREQ _0x6006B
; 0003 0161 				*p++ = c;
	PUSH R21
	PUSH R20
	__ADDWRN 20,21,1
	MOV  R30,R16
	POP  R26
	POP  R27
	ST   X,R30
; 0003 0162 			}
	SUBI R17,-1
	RJMP _0x6006A
_0x6006B:
; 0003 0163 		}
; 0003 0164 		fno->fattrib = dir[DIR_Attr];				/* Attribute */
_0x60068:
	MOVW R30,R18
	LDD  R30,Z+11
	__PUTB1SNS 6,8
; 0003 0165 		fno->fsize = LD_DWORD(dir+DIR_FileSize);	/* Size */
	MOVW R26,R18
	ADIW R26,28
	CALL __GETD1P
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __PUTDP1
; 0003 0166 		fno->fdate = LD_WORD(dir+DIR_WrtDate);		/* Date */
	MOVW R26,R18
	ADIW R26,24
	CALL __GETW1P
	__PUTW1SNS 6,4
; 0003 0167 		fno->ftime = LD_WORD(dir+DIR_WrtTime);		/* Time */
	MOVW R26,R18
	ADIW R26,22
	CALL __GETW1P
	__PUTW1SNS 6,6
; 0003 0168 	}
; 0003 0169 	*p = 0;
_0x60062:
	MOVW R26,R20
	LDI  R30,LOW(0)
	ST   X,R30
; 0003 016A }
_0x20C0010:
	CALL __LOADLOCR6
_0x20C000F:
	ADIW R28,10
	RET
; .FEND
;
;
;#endif /* _USE_DIR */
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Follow a file path                                                    */
;/*-----------------------------------------------------------------------*/
;
;static
;FRESULT follow_path (	/* FR_OK(0): successful, !=0: error code */
; 0003 0177 	DIR *dj,			/* Directory object to return last directory and found object */
; 0003 0178 	const char *path	/* Full-path string to find a file or directory */
; 0003 0179 )
; 0003 017A {
_follow_path_G003:
; .FSTART _follow_path_G003
; 0003 017B 	FRESULT res;
; 0003 017C 	BYTE *dir;
; 0003 017D 
; 0003 017E 
; 0003 017F 	while (*path == ' ') path++;		/* Skip leading spaces */
	CALL SUBOPT_0x20
;	*dj -> Y+6
;	*path -> Y+4
;	res -> R17
;	*dir -> R18,R19
_0x6006D:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R26,X
	CPI  R26,LOW(0x20)
	BRNE _0x6006F
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	RJMP _0x6006D
_0x6006F:
; 0003 0180 if (*path == '/') path++;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R26,X
	CPI  R26,LOW(0x2F)
	BRNE _0x60070
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0003 0181 	dj->sclust = 0;						/* Set start directory (always root dir) */
_0x60070:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,4
	CALL SUBOPT_0x40
; 0003 0182 
; 0003 0183 	if ((BYTE)*path <= ' ') {			/* Null path means the root directory */
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R26,X
	CPI  R26,LOW(0x21)
	BRSH _0x60071
; 0003 0184 		res = dir_rewind(dj);
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL _dir_rewind_G003
	MOV  R17,R30
; 0003 0185 		FatFs->buf[0] = 0;
	CALL SUBOPT_0x24
	LDD  R26,Z+6
	LDD  R27,Z+7
	LDI  R30,LOW(0)
	ST   X,R30
; 0003 0186 
; 0003 0187 	} else {							/* Follow path */
	RJMP _0x60072
_0x60071:
; 0003 0188 		for (;;) {
_0x60074:
; 0003 0189 			res = create_name(dj, &path);	/* Get a segment */
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,6
	RCALL _create_name_G003
	MOV  R17,R30
; 0003 018A 			if (res != FR_OK) break;
	CPI  R17,0
	BRNE _0x60075
; 0003 018B 			res = dir_find(dj);				/* Find it */
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL _dir_find_G003
	MOV  R17,R30
; 0003 018C 			if (res != FR_OK) {				/* Could not find the object */
	CPI  R17,0
	BREQ _0x60077
; 0003 018D 				if (res == FR_NO_FILE && !*(dj->fn+11))
	CPI  R17,3
	BRNE _0x60079
	CALL SUBOPT_0x41
	BREQ _0x6007A
_0x60079:
	RJMP _0x60078
_0x6007A:
; 0003 018E 					res = FR_NO_PATH;
	LDI  R17,LOW(4)
; 0003 018F 				break;
_0x60078:
	RJMP _0x60075
; 0003 0190 			}
; 0003 0191 			if (*(dj->fn+11)) break;		/* Last segment match. Function completed. */
_0x60077:
	CALL SUBOPT_0x41
	BRNE _0x60075
; 0003 0192 			dir = FatFs->buf;				/* There is next segment. Follow the sub directory */
	CALL SUBOPT_0x39
	LD   R18,X+
	LD   R19,X
; 0003 0193 			if (!(dir[DIR_Attr] & AM_DIR)) { /* Cannot follow because it is a file */
	MOVW R30,R18
	LDD  R30,Z+11
	ANDI R30,LOW(0x10)
	BRNE _0x6007C
; 0003 0194 				res = FR_NO_PATH; break;
	LDI  R17,LOW(4)
	RJMP _0x60075
; 0003 0195 			}
; 0003 0196 			dj->sclust =
_0x6007C:
; 0003 0197 #if _FS_FAT32
; 0003 0198 				((DWORD)LD_WORD(dir+DIR_FstClusHI) << 16) |
; 0003 0199 #endif
; 0003 019A 				LD_WORD(dir+DIR_FstClusLO);
	MOVW R26,R18
	ADIW R26,20
	CALL SUBOPT_0x42
	CALL __LSLD16
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R26,R18
	ADIW R26,26
	CALL __GETW1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x43
	__PUTD1SNS 6,4
; 0003 019B 		}
	RJMP _0x60074
_0x60075:
; 0003 019C 	}
_0x60072:
; 0003 019D 
; 0003 019E 	return res;
	MOV  R30,R17
	CALL __LOADLOCR4
_0x20C000E:
	ADIW R28,8
	RET
; 0003 019F }
; .FEND
;
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Check a sector if it is an FAT boot record                            */
;/*-----------------------------------------------------------------------*/
;
;static
;BYTE check_fs (	/* 0:The FAT boot record, 1:Valid boot record but not an FAT, 2:Not a boot record, 3:Error */
; 0003 01AA 	BYTE *buf,	/* Working buffer */
; 0003 01AB 	DWORD sect	/* Sector# (lba) to check if it is an FAT boot record or not */
; 0003 01AC )
; 0003 01AD {
_check_fs_G003:
; .FSTART _check_fs_G003
; 0003 01AE     if (disk_readp(buf, sect, 510, 2))		/* Read the boot sector */
	CALL __PUTPARD2
;	*buf -> Y+4
;	sect -> Y+0
	CALL SUBOPT_0x44
	LDI  R30,LOW(510)
	LDI  R31,HIGH(510)
	CALL SUBOPT_0x2E
	BREQ _0x6007D
; 0003 01AF 		return 3;
	LDI  R30,LOW(3)
	RJMP _0x20C000D
; 0003 01B0 	if (LD_WORD(buf) != 0xAA55)				/* Check record signature */
_0x6007D:
	CALL SUBOPT_0x45
	CPI  R30,LOW(0xAA55)
	LDI  R26,HIGH(0xAA55)
	CPC  R31,R26
	BREQ _0x6007E
; 0003 01B1 		return 2;
	LDI  R30,LOW(2)
	RJMP _0x20C000D
; 0003 01B2 
; 0003 01B3 	if (!disk_readp(buf, sect, BS_FilSysType, 2) && LD_WORD(buf) == 0x4146)	/* Check FAT12/16 */
_0x6007E:
	CALL SUBOPT_0x44
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	CALL SUBOPT_0x2E
	BRNE _0x60080
	CALL SUBOPT_0x45
	CPI  R30,LOW(0x4146)
	LDI  R26,HIGH(0x4146)
	CPC  R31,R26
	BREQ _0x60081
_0x60080:
	RJMP _0x6007F
_0x60081:
; 0003 01B4 		return 0;
	LDI  R30,LOW(0)
	RJMP _0x20C000D
; 0003 01B5 #if _FS_FAT32
; 0003 01B6 	if (!disk_readp(buf, sect, BS_FilSysType32, 2) && LD_WORD(buf) == 0x4146)	/* Check FAT32 */
_0x6007F:
	CALL SUBOPT_0x44
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	CALL SUBOPT_0x2E
	BRNE _0x60083
	CALL SUBOPT_0x45
	CPI  R30,LOW(0x4146)
	LDI  R26,HIGH(0x4146)
	CPC  R31,R26
	BREQ _0x60084
_0x60083:
	RJMP _0x60082
_0x60084:
; 0003 01B7 		return 0;
	LDI  R30,LOW(0)
	RJMP _0x20C000D
; 0003 01B8 #endif
; 0003 01B9 	return 1;
_0x60082:
	LDI  R30,LOW(1)
_0x20C000D:
	ADIW R28,6
	RET
; 0003 01BA }
; .FEND
;
;
;
;
;/*--------------------------------------------------------------------------
;
;   Public Functions
;
;--------------------------------------------------------------------------*/
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Mount/Unmount a Locical Drive                                         */
;/*-----------------------------------------------------------------------*/
;
;FRESULT pf_mount (
; 0003 01CC 	FATFS *fs		/* Pointer to new file system object (NULL: Unmount) */
; 0003 01CD )
; 0003 01CE {
_pf_mount:
; .FSTART _pf_mount
; 0003 01CF 	BYTE fmt, buf[36];
; 0003 01D0 	DWORD bsect, fsize, tsect, mclst;
; 0003 01D1 
; 0003 01D2 
; 0003 01D3 	FatFs = 0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,52
	ST   -Y,R17
;	*fs -> Y+53
;	fmt -> R17
;	buf -> Y+17
;	bsect -> Y+13
;	fsize -> Y+9
;	tsect -> Y+5
;	mclst -> Y+1
	LDI  R30,LOW(0)
	STS  _FatFs_G003,R30
	STS  _FatFs_G003+1,R30
; 0003 01D4 	if (!fs) return FR_OK;				/* Unregister fs object */
	LDD  R30,Y+53
	LDD  R31,Y+53+1
	SBIW R30,0
	BRNE _0x60085
	RJMP _0x20C000C
; 0003 01D5 
; 0003 01D6 
; 0003 01D7 	if (disk_initialize() & STA_NOINIT)	/* Check if the drive is ready or not */
_0x60085:
	RCALL _disk_initialize
	ANDI R30,LOW(0x1)
	BREQ _0x60086
; 0003 01D8 		return FR_NOT_READY;
	LDI  R30,LOW(2)
	RJMP _0x20C000B
; 0003 01D9 
; 0003 01DA 	/* Search FAT partition on the drive */
; 0003 01DB 	bsect = 0;
_0x60086:
	LDI  R30,LOW(0)
	__CLRD1S 13
; 0003 01DC 	fmt = check_fs(buf, bsect);			/* Check sector 0 as an SFD format */
	CALL SUBOPT_0x46
	CALL SUBOPT_0x47
; 0003 01DD 	if (fmt == 1) {						/* Not an FAT boot record, it may be FDISK format */
	CPI  R17,1
	BRNE _0x60087
; 0003 01DE 		/* Check a partition listed in top of the partition table */
; 0003 01DF 		if (disk_readp(buf, bsect, MBR_Table, 16)) {	/* 1st partition entry */
	CALL SUBOPT_0x46
	CALL SUBOPT_0x48
	LDI  R30,LOW(446)
	LDI  R31,HIGH(446)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(16)
	CALL SUBOPT_0x2F
	BREQ _0x60088
; 0003 01E0 			fmt = 3;
	LDI  R17,LOW(3)
; 0003 01E1 		} else {
	RJMP _0x60089
_0x60088:
; 0003 01E2 			if (buf[4]) {					/* Is the partition existing? */
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x6008A
; 0003 01E3 				bsect = LD_DWORD(&buf[8]);	/* Partition offset in LBA */
	__GETD1S 25
	__PUTD1S 13
; 0003 01E4 				fmt = check_fs(buf, bsect);	/* Check the partition */
	CALL SUBOPT_0x46
	CALL SUBOPT_0x47
; 0003 01E5 			}
; 0003 01E6 		}
_0x6008A:
_0x60089:
; 0003 01E7 	}
; 0003 01E8 	if (fmt == 3) return FR_DISK_ERR;
_0x60087:
	CPI  R17,3
	BRNE _0x6008B
	LDI  R30,LOW(1)
	RJMP _0x20C000B
; 0003 01E9 	if (fmt) return FR_NO_FILESYSTEM;	/* No valid FAT patition is found */
_0x6008B:
	CPI  R17,0
	BREQ _0x6008C
	LDI  R30,LOW(7)
	RJMP _0x20C000B
; 0003 01EA 
; 0003 01EB 	/* Initialize the file system object */
; 0003 01EC 	if (disk_readp(buf, bsect, 13, sizeof(buf))) return FR_DISK_ERR;
_0x6008C:
	CALL SUBOPT_0x46
	CALL SUBOPT_0x48
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(36)
	CALL SUBOPT_0x2F
	BREQ _0x6008D
	LDI  R30,LOW(1)
	RJMP _0x20C000B
; 0003 01ED 
; 0003 01EE 	fsize = LD_WORD(buf+BPB_FATSz16-13);				/* Number of sectors per FAT */
_0x6008D:
	MOVW R30,R28
	ADIW R30,39
	SBIW R30,13
	MOVW R26,R30
	CALL SUBOPT_0x42
	CALL SUBOPT_0x49
; 0003 01EF 	if (!fsize) fsize = LD_DWORD(buf+BPB_FATSz32-13);
	CALL SUBOPT_0x4A
	CALL __CPD10
	BRNE _0x6008E
	MOVW R30,R28
	ADIW R30,53
	SBIW R30,13
	MOVW R26,R30
	CALL __GETD1P
	CALL SUBOPT_0x49
; 0003 01F0 
; 0003 01F1 	fsize *= buf[BPB_NumFATs-13];						/* Number of sectors in FAT area */
_0x6008E:
	LDD  R30,Y+20
	LDI  R31,0
	CALL SUBOPT_0x22
	CALL __CWD1
	CALL __MULD12U
	CALL SUBOPT_0x49
; 0003 01F2 	fs->fatbase = bsect + LD_WORD(buf+BPB_RsvdSecCnt-13); /* FAT start sector (lba) */
	CALL SUBOPT_0x4B
	__GETD2S 13
	CALL SUBOPT_0x16
	__PUTD1SNS 53,12
; 0003 01F3 	fs->csize = buf[BPB_SecPerClus-13];					/* Number of sectors per cluster */
	LDD  R30,Y+17
	__PUTB1SNS 53,1
; 0003 01F4 	fs->n_rootdir = LD_WORD(buf+BPB_RootEntCnt-13);		/* Nmuber of root directory entries */
	MOVW R30,R28
	ADIW R30,34
	SBIW R30,13
	MOVW R26,R30
	CALL __GETW1P
	__PUTW1SNS 53,4
; 0003 01F5 	tsect = LD_WORD(buf+BPB_TotSec16-13);				/* Number of sectors on the file system */
	MOVW R30,R28
	ADIW R30,36
	SBIW R30,13
	MOVW R26,R30
	CALL SUBOPT_0x42
	__PUTD1S 5
; 0003 01F6 	if (!tsect) tsect = LD_DWORD(buf+BPB_TotSec32-13);
	CALL __CPD10
	BRNE _0x6008F
	MOVW R30,R28
	ADIW R30,49
	SBIW R30,13
	MOVW R26,R30
	CALL __GETD1P
	__PUTD1S 5
; 0003 01F7 	mclst = (tsect						/* Last cluster# + 1 */
_0x6008F:
; 0003 01F8 		- LD_WORD(buf+BPB_RsvdSecCnt-13) - fsize - fs->n_rootdir / 16
; 0003 01F9 		) / fs->csize + 2;
	CALL SUBOPT_0x4B
	__GETD2S 5
	CLR  R22
	CLR  R23
	CALL __SWAPD12
	CALL __SUBD12
	CALL SUBOPT_0x22
	CALL __SUBD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4C
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R22
	CLR  R23
	CALL __SUBD21
	LDD  R30,Y+53
	LDD  R31,Y+53+1
	CALL SUBOPT_0x4D
	CALL __DIVD21U
	__ADDD1N 2
	__PUTD1S 1
; 0003 01FA 	fs->max_clust = (CLUST)mclst;
	__PUTD1SNS 53,8
; 0003 01FB 
; 0003 01FC 	fmt = FS_FAT12;							/* Determine the FAT sub type */
	LDI  R17,LOW(1)
; 0003 01FD 	if (mclst >= 0xFF7) fmt = FS_FAT16;		/* Number of clusters >= 0xFF5 */
	__GETD2S 1
	__CPD2N 0xFF7
	BRLO _0x60090
	LDI  R17,LOW(2)
; 0003 01FE 	if (mclst >= 0xFFF7)					/* Number of clusters >= 0xFFF5 */
_0x60090:
	__GETD2S 1
	__CPD2N 0xFFF7
	BRLO _0x60091
; 0003 01FF #if _FS_FAT32
; 0003 0200 		fmt = FS_FAT32;
	LDI  R17,LOW(3)
; 0003 0201 #else
; 0003 0202 		return FR_NO_FILESYSTEM;
; 0003 0203 #endif
; 0003 0204 
; 0003 0205 	fs->fs_type = fmt;		/* FAT sub-type */
_0x60091:
	LDD  R26,Y+53
	LDD  R27,Y+53+1
	ST   X,R17
; 0003 0206 #if _FS_FAT32
; 0003 0207 	if (fmt == FS_FAT32)
	CPI  R17,3
	BRNE _0x60092
; 0003 0208 		fs->dirbase = LD_DWORD(buf+(BPB_RootClus-13));	/* Root directory start cluster */
	__GETD1S 48
	RJMP _0x60112
; 0003 0209 	else
_0x60092:
; 0003 020A #endif
; 0003 020B 		fs->dirbase = fs->fatbase + fsize;				/* Root directory start sector (lba) */
	CALL SUBOPT_0x4E
_0x60112:
	__PUTD1SNS 53,16
; 0003 020C 	fs->database = fs->fatbase + fsize + fs->n_rootdir / 16;	/* Data start sector (lba) */
	CALL SUBOPT_0x4E
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4C
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x16
	__PUTD1SNS 53,20
; 0003 020D 
; 0003 020E 	fs->flag = 0;
	LDD  R26,Y+53
	LDD  R27,Y+53+1
	ADIW R26,2
	LDI  R30,LOW(0)
	ST   X,R30
; 0003 020F 	FatFs = fs;
	LDD  R30,Y+53
	LDD  R31,Y+53+1
	STS  _FatFs_G003,R30
	STS  _FatFs_G003+1,R31
; 0003 0210 
; 0003 0211 	return FR_OK;
_0x20C000C:
	LDI  R30,LOW(0)
_0x20C000B:
	LDD  R17,Y+0
	ADIW R28,55
	RET
; 0003 0212 }
; .FEND
;
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Open or Create a File                                                 */
;/*-----------------------------------------------------------------------*/
;
;FRESULT pf_open (
; 0003 021C 	const char *path	/* Pointer to the file name */
; 0003 021D )
; 0003 021E {
_pf_open:
; .FSTART _pf_open
; 0003 021F 	FRESULT res;
; 0003 0220 	DIR dj;
; 0003 0221 	BYTE sp[12], dir[32];
; 0003 0222 	FATFS *fs = FatFs;
; 0003 0223 
; 0003 0224 
; 0003 0225 	if (!fs)						/* Check file system */
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,60
	CALL SUBOPT_0x36
;	*path -> Y+64
;	res -> R17
;	dj -> Y+48
;	sp -> Y+36
;	dir -> Y+4
;	*fs -> R18,R19
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x60094
; 0003 0226 		return FR_NOT_ENABLED;
	LDI  R30,LOW(6)
	RJMP _0x20C000A
; 0003 0227 
; 0003 0228 	fs->flag = 0;
_0x60094:
	MOVW R26,R18
	ADIW R26,2
	LDI  R30,LOW(0)
	ST   X,R30
; 0003 0229 	fs->buf = dir;
	CALL SUBOPT_0x4F
; 0003 022A 	dj.fn = sp;
	STD  Y+50,R30
	STD  Y+50+1,R31
; 0003 022B 	res = follow_path(&dj, path);	/* Follow the file path */
	MOVW R30,R28
	ADIW R30,48
	ST   -Y,R31
	ST   -Y,R30
	__GETW2SX 66
	RCALL _follow_path_G003
	MOV  R17,R30
; 0003 022C 	if (res != FR_OK) return res;	/* Follow failed */
	CPI  R17,0
	BREQ _0x60095
	RJMP _0x20C000A
; 0003 022D 	if (!dir[0] || (dir[DIR_Attr] & AM_DIR))	/* It is a directory */
_0x60095:
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x60097
	LDD  R30,Y+15
	ANDI R30,LOW(0x10)
	BREQ _0x60096
_0x60097:
; 0003 022E 		return FR_NO_FILE;
	LDI  R30,LOW(3)
	RJMP _0x20C000A
; 0003 022F 
; 0003 0230 	fs->org_clust =						/* File start cluster */
_0x60096:
; 0003 0231 #if _FS_FAT32
; 0003 0232 		((DWORD)LD_WORD(dir+DIR_FstClusHI) << 16) |
; 0003 0233 #endif
; 0003 0234 		LD_WORD(dir+DIR_FstClusLO);
	CALL SUBOPT_0x50
	__PUTD1RNS 18,32
; 0003 0235 	fs->fsize = LD_DWORD(dir+DIR_FileSize);	/* File size */
	__GETD1S 32
	__PUTD1RNS 18,28
; 0003 0236 	fs->fptr = 0;						/* File pointer */
	MOVW R26,R18
	ADIW R26,24
	CALL SUBOPT_0x40
; 0003 0237 	fs->flag = FA_OPENED;
	MOVW R26,R18
	ADIW R26,2
	LDI  R30,LOW(1)
	ST   X,R30
; 0003 0238 
; 0003 0239 	return FR_OK;
	LDI  R30,LOW(0)
_0x20C000A:
	CALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,3
	RET
; 0003 023A }
; .FEND
;
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Read File                                                             */
;/*-----------------------------------------------------------------------*/
;#if _USE_READ
;
;FRESULT pf_read (
; 0003 0245 	void* buff,		/* Pointer to the read buffer (NULL:Forward data to the stream)*/
; 0003 0246 	WORD btr,		/* Number of bytes to read */
; 0003 0247 	WORD* br		/* Pointer to number of bytes read */
; 0003 0248 )
; 0003 0249 {
_pf_read:
; .FSTART _pf_read
; 0003 024A 	DRESULT dr;
; 0003 024B 	CLUST clst;
; 0003 024C 	DWORD sect, remain;
; 0003 024D 	BYTE *rbuff = buff;
; 0003 024E 	WORD rcnt;
; 0003 024F 	FATFS *fs = FatFs;
; 0003 0250 
; 0003 0251 
; 0003 0252 	*br = 0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,14
	CALL __SAVELOCR6
;	*buff -> Y+24
;	btr -> Y+22
;	*br -> Y+20
;	dr -> R17
;	clst -> Y+16
;	sect -> Y+12
;	remain -> Y+8
;	*rbuff -> R18,R19
;	rcnt -> R20,R21
;	*fs -> Y+6
	__GETWRS 18,19,24
	CALL SUBOPT_0x24
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL SUBOPT_0x34
; 0003 0253 	if (!fs) return FR_NOT_ENABLED;		/* Check file system */
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,0
	BRNE _0x60099
	LDI  R30,LOW(6)
	RJMP _0x20C0009
; 0003 0254 	if (!(fs->flag & FA_OPENED))		/* Check if opened */
_0x60099:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+2
	ANDI R26,LOW(0x1)
	BRNE _0x6009A
; 0003 0255 		return FR_NOT_OPENED;
	LDI  R30,LOW(5)
	RJMP _0x20C0009
; 0003 0256 
; 0003 0257 	remain = fs->fsize - fs->fptr;
_0x6009A:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__GETD2Z 28
	PUSH R25
	PUSH R24
	PUSH R27
	PUSH R26
	CALL SUBOPT_0x51
	POP  R30
	POP  R31
	POP  R22
	POP  R23
	CALL __SUBD12
	__PUTD1S 8
; 0003 0258 	if (btr > remain) btr = (WORD)remain;			/* Truncate btr by remaining bytes */
	CALL SUBOPT_0x14
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CLR  R24
	CLR  R25
	CALL __CPD12
	BRSH _0x6009B
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	STD  Y+22,R30
	STD  Y+22+1,R31
; 0003 0259 
; 0003 025A 	while (btr)	{									/* Repeat until all data transferred */
_0x6009B:
_0x6009C:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SBIW R30,0
	BRNE PC+2
	RJMP _0x6009E
; 0003 025B 		if ((fs->fptr % 512) == 0) {				/* On the sector boundary? */
	CALL SUBOPT_0x51
	MOVW R30,R26
	MOVW R22,R24
	ANDI R31,HIGH(0x1FF)
	SBIW R30,0
	BREQ PC+2
	RJMP _0x6009F
; 0003 025C 			if ((fs->fptr / 512 % fs->csize) == 0) {	/* On the cluster boundary? */
	CALL SUBOPT_0x51
	CALL SUBOPT_0x52
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x4D
	CALL __MODD21U
	CALL __CPD10
	BRNE _0x600A0
; 0003 025D 				clst = (fs->fptr == 0) ?			/* On the top of the file? */
; 0003 025E 					fs->org_clust : get_fat(fs->curr_clust);
	CALL SUBOPT_0x51
	CALL __CPD02
	BRNE _0x600A1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,32
	CALL __GETD1P
	RJMP _0x600A2
_0x600A1:
	CALL SUBOPT_0x53
	RCALL _get_fat_G003
_0x600A2:
	__PUTD1S 16
; 0003 025F 				if (clst <= 1) goto fr_abort;
	__GETD2S 16
	CALL SUBOPT_0x26
	BRSH _0x600A4
	RJMP _0x600A5
; 0003 0260 				fs->curr_clust = clst;				/* Update current cluster */
_0x600A4:
	__GETD1S 16
	__PUTD1SNS 6,36
; 0003 0261 				fs->csect = 0;						/* Reset sector offset in the cluster */
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,3
	LDI  R30,LOW(0)
	ST   X,R30
; 0003 0262 			}
; 0003 0263 			sect = clust2sect(fs->curr_clust);		/* Get current sector */
_0x600A0:
	CALL SUBOPT_0x53
	RCALL _clust2sect_G003
	__PUTD1S 12
; 0003 0264 			if (!sect) goto fr_abort;
	CALL __CPD10
	BRNE _0x600A6
	RJMP _0x600A5
; 0003 0265 			fs->dsect = sect + fs->csect++;
_0x600A6:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x54
	CALL SUBOPT_0x25
	CALL SUBOPT_0x55
	__PUTD1SNS 6,40
; 0003 0266 		}
; 0003 0267 		rcnt = 512 - ((WORD)fs->fptr % 512);		/* Get partial sector data from sector buffer */
_0x6009F:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x56
	LDI  R26,LOW(512)
	LDI  R27,HIGH(512)
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
; 0003 0268 		if (rcnt > btr) rcnt = btr;
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	CP   R30,R20
	CPC  R31,R21
	BRSH _0x600A7
	__GETWRS 20,21,22
; 0003 0269 		dr = disk_readp(!buff ? 0 : rbuff, fs->dsect, (WORD)(fs->fptr % 512), rcnt);
_0x600A7:
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	SBIW R30,0
	BRNE _0x600A8
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x600A9
_0x600A8:
	MOVW R30,R18
_0x600A9:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	__GETD2Z 40
	CALL __PUTPARD2
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADIW R26,24
	CALL __GETW1P
	ANDI R31,HIGH(0x1FF)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	RCALL _disk_readp
	MOV  R17,R30
; 0003 026A 		if (dr) goto fr_abort;
	CPI  R17,0
	BRNE _0x600A5
; 0003 026B 		fs->fptr += rcnt; rbuff += rcnt;			/* Update pointers and counters */
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x57
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R20
	CALL SUBOPT_0x16
	MOVW R26,R0
	CALL __PUTDP1
	__ADDWRR 18,19,20,21
; 0003 026C 		btr -= rcnt; *br += rcnt;
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SUB  R30,R20
	SBC  R31,R21
	STD  Y+22,R30
	STD  Y+22+1,R31
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	LD   R30,X+
	LD   R31,X+
	ADD  R30,R20
	ADC  R31,R21
	ST   -X,R31
	ST   -X,R30
; 0003 026D 	}
	RJMP _0x6009C
_0x6009E:
; 0003 026E 
; 0003 026F 	return FR_OK;
	LDI  R30,LOW(0)
	RJMP _0x20C0009
; 0003 0270 
; 0003 0271 fr_abort:
_0x600A5:
; 0003 0272 	fs->flag = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x58
; 0003 0273 	return FR_DISK_ERR;
_0x20C0009:
	CALL __LOADLOCR6
	ADIW R28,26
	RET
; 0003 0274 }
; .FEND
;#endif
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Write File                                                            */
;/*-----------------------------------------------------------------------*/
;#if _USE_WRITE
;
;FRESULT pf_write (
; 0003 027F 	const void* buff,	/* Pointer to the data to be written */
; 0003 0280 	WORD btw,			/* Number of bytes to write (0:Finalize the current write operation) */
; 0003 0281 	WORD* bw			/* Pointer to number of bytes written */
; 0003 0282 )
; 0003 0283 {
_pf_write:
; .FSTART _pf_write
; 0003 0284 	CLUST clst;
; 0003 0285 	DWORD sect, remain;
; 0003 0286 	const BYTE *p = buff;
; 0003 0287 	WORD wcnt;
; 0003 0288 	FATFS *fs = FatFs;
; 0003 0289 
; 0003 028A 
; 0003 028B 	*bw = 0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,12
	CALL __SAVELOCR6
;	*buff -> Y+22
;	btw -> Y+20
;	*bw -> Y+18
;	clst -> Y+14
;	sect -> Y+10
;	remain -> Y+6
;	*p -> R16,R17
;	wcnt -> R18,R19
;	*fs -> R20,R21
	__GETWRS 16,17,22
	__GETWRMN 20,21,0,_FatFs_G003
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0x34
; 0003 028C 	if (!fs) return FR_NOT_ENABLED;		/* Check file system */
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x600AC
	LDI  R30,LOW(6)
	RJMP _0x20C0008
; 0003 028D 	if (!(fs->flag & FA_OPENED))		/* Check if opened */
_0x600AC:
	MOVW R30,R20
	LDD  R26,Z+2
	ANDI R26,LOW(0x1)
	BRNE _0x600AD
; 0003 028E 		return FR_NOT_OPENED;
	LDI  R30,LOW(5)
_0x20C0008:
	CALL __LOADLOCR6
	ADIW R28,24
	RET
; 0003 028F 
; 0003 0290 	if (!btw) {		/* Finalize request */
_0x600AD:
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	SBIW R30,0
	BRNE _0x600AE
; 0003 0291 		if ((fs->flag & FA__WIP) && disk_writep(0, 0)) goto fw_abort;
	MOVW R30,R20
	LDD  R26,Z+2
	ANDI R26,LOW(0x40)
	BREQ _0x600B0
	CALL SUBOPT_0x59
	CALL SUBOPT_0x1E
	RCALL _disk_writep
	CPI  R30,0
	BRNE _0x600B1
_0x600B0:
	RJMP _0x600AF
_0x600B1:
	RJMP _0x600B2
; 0003 0292 		fs->flag &= ~FA__WIP;
_0x600AF:
	MOVW R26,R20
	ADIW R26,2
	LD   R30,X
	ANDI R30,0xBF
	ST   X,R30
; 0003 0293 		return FR_OK;
	LDI  R30,LOW(0)
	JMP  _0x20C0003
; 0003 0294 	} else {		/* Write data request */
_0x600AE:
; 0003 0295 		if (!(fs->flag & FA__WIP))		/* Round down fptr to the sector boundary */
	MOVW R30,R20
	LDD  R26,Z+2
	ANDI R26,LOW(0x40)
	BRNE _0x600B4
; 0003 0296 			fs->fptr &= 0xFFFFFE00;
	MOVW R26,R20
	ADIW R26,24
	LD   R30,X+
	LD   R31,X+
	ANDI R30,LOW(0xFFFFFE00)
	ANDI R31,HIGH(0xFFFFFE00)
	ST   -X,R31
	ST   -X,R30
; 0003 0297 	}
_0x600B4:
; 0003 0298 	remain = fs->fsize - fs->fptr;
	MOVW R30,R20
	__GETD2Z 28
	PUSH R25
	PUSH R24
	PUSH R27
	PUSH R26
	CALL SUBOPT_0x5A
	POP  R30
	POP  R31
	POP  R22
	POP  R23
	CALL __SUBD12
	CALL SUBOPT_0xF
; 0003 0299 	if (btw > remain) btw = (WORD)remain;			/* Truncate btw by remaining bytes */
	CALL SUBOPT_0xE
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CLR  R24
	CLR  R25
	CALL __CPD12
	BRSH _0x600B5
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0003 029A 
; 0003 029B 	while (btw)	{									/* Repeat until all data transferred */
_0x600B5:
_0x600B6:
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	SBIW R30,0
	BRNE PC+2
	RJMP _0x600B8
; 0003 029C 		if (((WORD)fs->fptr % 512) == 0) {				/* On the sector boundary? */
	MOVW R30,R20
	CALL SUBOPT_0x56
	SBIW R30,0
	BREQ PC+2
	RJMP _0x600B9
; 0003 029D 			if ((fs->fptr / 512 % fs->csize) == 0) {	/* On the cluster boundary? */
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x52
	MOVW R30,R20
	CALL SUBOPT_0x4D
	CALL __MODD21U
	CALL __CPD10
	BRNE _0x600BA
; 0003 029E 				clst = (fs->fptr == 0) ?			/* On the top of the file? */
; 0003 029F 					fs->org_clust : get_fat(fs->curr_clust);
	CALL SUBOPT_0x5A
	CALL __CPD02
	BRNE _0x600BB
	MOVW R26,R20
	ADIW R26,32
	CALL __GETD1P
	RJMP _0x600BC
_0x600BB:
	MOVW R30,R20
	__GETD2Z 36
	RCALL _get_fat_G003
_0x600BC:
	CALL SUBOPT_0x5B
; 0003 02A0 				if (clst <= 1) goto fw_abort;
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x26
	BRSH _0x600BE
	RJMP _0x600B2
; 0003 02A1 				fs->curr_clust = clst;				/* Update current cluster */
_0x600BE:
	CALL SUBOPT_0x5C
	__PUTD1RNS 20,36
; 0003 02A2 				fs->csect = 0;						/* Reset sector offset in the cluster */
	MOVW R26,R20
	ADIW R26,3
	LDI  R30,LOW(0)
	ST   X,R30
; 0003 02A3 			}
; 0003 02A4 			sect = clust2sect(fs->curr_clust);		/* Get current sector */
_0x600BA:
	MOVW R30,R20
	__GETD2Z 36
	RCALL _clust2sect_G003
	__PUTD1S 10
; 0003 02A5 			if (!sect) goto fw_abort;
	CALL SUBOPT_0x17
	CALL __CPD10
	BRNE _0x600BF
	RJMP _0x600B2
; 0003 02A6 			fs->dsect = sect + fs->csect++;
_0x600BF:
	MOVW R26,R20
	CALL SUBOPT_0x54
	CALL SUBOPT_0x18
	CALL SUBOPT_0x55
	__PUTD1RNS 20,40
; 0003 02A7 			if (disk_writep(0, fs->dsect)) goto fw_abort;	/* Initiate a sector write operation */
	CALL SUBOPT_0x59
	MOVW R30,R20
	__GETD2Z 40
	RCALL _disk_writep
	CPI  R30,0
	BREQ _0x600C0
	RJMP _0x600B2
; 0003 02A8 			fs->flag |= FA__WIP;
_0x600C0:
	MOVW R26,R20
	ADIW R26,2
	LD   R30,X
	ORI  R30,0x40
	ST   X,R30
; 0003 02A9 		}
; 0003 02AA 		wcnt = 512 - ((WORD)fs->fptr % 512);		/* Number of bytes to write to the sector */
_0x600B9:
	MOVW R30,R20
	CALL SUBOPT_0x56
	LDI  R26,LOW(512)
	LDI  R27,HIGH(512)
	SUB  R26,R30
	SBC  R27,R31
	MOVW R18,R26
; 0003 02AB 		if (wcnt > btw) wcnt = btw;
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	CP   R30,R18
	CPC  R31,R19
	BRSH _0x600C1
	__GETWRS 18,19,20
; 0003 02AC 		if (disk_writep(p, wcnt)) goto fw_abort;	/* Send data to the sector */
_0x600C1:
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R18
	CLR  R24
	CLR  R25
	RCALL _disk_writep
	CPI  R30,0
	BRNE _0x600B2
; 0003 02AD 		fs->fptr += wcnt; p += wcnt;				/* Update pointers and counters */
	MOVW R30,R20
	CALL SUBOPT_0x57
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R18
	CALL SUBOPT_0x16
	MOVW R26,R0
	CALL __PUTDP1
	__ADDWRR 16,17,18,19
; 0003 02AE 		btw -= wcnt; *bw += wcnt;
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	SUB  R30,R18
	SBC  R31,R19
	STD  Y+20,R30
	STD  Y+20+1,R31
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LD   R30,X+
	LD   R31,X+
	ADD  R30,R18
	ADC  R31,R19
	ST   -X,R31
	ST   -X,R30
; 0003 02AF 		if (((WORD)fs->fptr % 512) == 0) {
	MOVW R30,R20
	CALL SUBOPT_0x56
	SBIW R30,0
	BRNE _0x600C3
; 0003 02B0 			if (disk_writep(0, 0)) goto fw_abort;	/* Finalize the currtent secter write operation */
	CALL SUBOPT_0x59
	CALL SUBOPT_0x1E
	RCALL _disk_writep
	CPI  R30,0
	BRNE _0x600B2
; 0003 02B1 			fs->flag &= ~FA__WIP;
	MOVW R26,R20
	ADIW R26,2
	LD   R30,X
	ANDI R30,0xBF
	ST   X,R30
; 0003 02B2 		}
; 0003 02B3 	}
_0x600C3:
	RJMP _0x600B6
_0x600B8:
; 0003 02B4 
; 0003 02B5 	return FR_OK;
	LDI  R30,LOW(0)
	JMP  _0x20C0003
; 0003 02B6 
; 0003 02B7 fw_abort:
_0x600B2:
; 0003 02B8 	fs->flag = 0;
	MOVW R26,R20
	CALL SUBOPT_0x58
; 0003 02B9 	return FR_DISK_ERR;
	JMP  _0x20C0003
; 0003 02BA }
; .FEND
;
;FRESULT pf_write512 (
; 0003 02BD 	BYTE* buff,	/* Pointer to the data to be written */
; 0003 02BE 	WORD ofs,			//offset to fill data
; 0003 02BF 	WORD btw,           /* Number of bytes to write */
; 0003 02C0     WORD* bw			/* Pointer to number of bytes written */
; 0003 02C1 )
; 0003 02C2 {
_pf_write512:
; .FSTART _pf_write512
; 0003 02C3      BYTE res;
; 0003 02C4      WORD i=ofs%512,j=0;
; 0003 02C5      BYTE buf512[512];
; 0003 02C6      FATFS *fs = FatFs;
; 0003 02C7 
; 0003 02C8      //WORD nbytes=0;
; 0003 02C9      if((btw)>512){
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,2
	SUBI R29,2
	CALL __SAVELOCR6
;	*buff -> Y+526
;	ofs -> Y+524
;	btw -> Y+522
;	*bw -> Y+520
;	res -> R17
;	i -> R18,R19
;	j -> R20,R21
;	buf512 -> Y+8
;	*fs -> Y+6
	CALL SUBOPT_0x5D
	MOVW R18,R30
	__GETWRN 20,21,0
	CALL SUBOPT_0x24
	STD  Y+6,R30
	STD  Y+6+1,R31
	CALL SUBOPT_0x5E
	CPI  R26,LOW(0x201)
	LDI  R30,HIGH(0x201)
	CPC  R27,R30
	BRLO _0x600C5
; 0003 02CA          return FR_DISK_ERR; //write bytes great than 512
	LDI  R30,LOW(1)
	RJMP _0x20C0007
; 0003 02CB      }
; 0003 02CC      res=pf_lseek((ofs/512)*512);
_0x600C5:
	CALL SUBOPT_0x5F
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL __DIVW21U
	LSL  R30
	ROL  R31
	MOV  R31,R30
	LDI  R30,0
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	RCALL _pf_lseek
	MOV  R17,R30
; 0003 02CD      if(((ofs%512)+btw)>512){//read replace then write
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x5E
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x201)
	LDI  R30,HIGH(0x201)
	CPC  R27,R30
	BRLO _0x600C6
; 0003 02CE         res=pf_read(buf512, 512, bw);
	CALL SUBOPT_0x60
	RCALL _pf_read
	MOV  R17,R30
; 0003 02CF         if(res!=FR_OK){
	CPI  R17,0
	BREQ _0x600C7
; 0003 02D0             return res;
	RJMP _0x20C0007
; 0003 02D1         }
; 0003 02D2         for(;i<512;i++,j++){
_0x600C7:
_0x600C9:
	__CPWRN 18,19,512
	BRSH _0x600CA
; 0003 02D3             buf512[i]=buff[j];
	CALL SUBOPT_0x61
; 0003 02D4         }
	__ADDWRN 18,19,1
	__ADDWRN 20,21,1
	RJMP _0x600C9
_0x600CA:
; 0003 02D5         res=pf_lseek(fs->fptr - 512);
	CALL SUBOPT_0x51
	CALL SUBOPT_0x62
; 0003 02D6         //res=pf_lseek((ofs/512)*512);
; 0003 02D7         res=pf_write(buf512, 512, bw);
	CALL SUBOPT_0x60
	RCALL _pf_write
	MOV  R17,R30
; 0003 02D8         if(res!=FR_OK){
	CPI  R17,0
	BREQ _0x600CB
; 0003 02D9             return res;
	RJMP _0x20C0007
; 0003 02DA         }
; 0003 02DB         i=0;
_0x600CB:
	__GETWRN 18,19,0
; 0003 02DC          //return FR_DISK_ERR; //write bytes great than 512
; 0003 02DD      }
; 0003 02DE      {
_0x600C6:
; 0003 02DF 
; 0003 02E0         res=pf_read(buf512, 512, bw);
	CALL SUBOPT_0x60
	RCALL _pf_read
	MOV  R17,R30
; 0003 02E1         res=pf_lseek(fs->fptr - 512);
	CALL SUBOPT_0x51
	CALL SUBOPT_0x62
; 0003 02E2         /*
; 0003 02E3         if(j>0){
; 0003 02E4             res=pf_lseek(((ofs/512)+1)*512);
; 0003 02E5         }
; 0003 02E6         else{
; 0003 02E7             res=pf_lseek((ofs/512)*512);
; 0003 02E8         }
; 0003 02E9         */
; 0003 02EA         if(res!=FR_OK){
	CPI  R17,0
	BREQ _0x600CC
; 0003 02EB             return res;
	MOV  R30,R17
	RJMP _0x20C0007
; 0003 02EC         }
; 0003 02ED         for(;j<btw;i++,j++){
_0x600CC:
_0x600CE:
	__GETW1SX 522
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x600CF
; 0003 02EE             buf512[i]=buff[j];
	CALL SUBOPT_0x61
; 0003 02EF         }
	__ADDWRN 18,19,1
	__ADDWRN 20,21,1
	RJMP _0x600CE
_0x600CF:
; 0003 02F0 
; 0003 02F1         res=pf_write(buf512, 512, bw);
	CALL SUBOPT_0x60
	RCALL _pf_write
	MOV  R17,R30
; 0003 02F2         if(res!=FR_OK){
	CPI  R17,0
	BREQ _0x600D0
; 0003 02F3             return res;
; 0003 02F4         }
; 0003 02F5      }
_0x600D0:
; 0003 02F6 
; 0003 02F7 }
_0x20C0007:
	CALL __LOADLOCR6
	ADIW R28,16
	SUBI R29,-2
	RET
; .FEND
;#endif
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Seek File R/W Pointer                                                 */
;/*-----------------------------------------------------------------------*/
;#if _USE_LSEEK
;
;FRESULT pf_lseek (
; 0003 0302 	DWORD ofs		/* File pointer from top of file */
; 0003 0303 )
; 0003 0304 {
_pf_lseek:
; .FSTART _pf_lseek
; 0003 0305 	CLUST clst;
; 0003 0306 	DWORD bcs, sect, ifptr;
; 0003 0307 	FATFS *fs = FatFs;
; 0003 0308 
; 0003 0309 
; 0003 030A 	if (!fs) return FR_NOT_ENABLED;		/* Check file system */
	CALL __PUTPARD2
	SBIW R28,16
	CALL SUBOPT_0x30
;	ofs -> Y+18
;	clst -> Y+14
;	bcs -> Y+10
;	sect -> Y+6
;	ifptr -> Y+2
;	*fs -> R16,R17
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x600D1
	LDI  R30,LOW(6)
	RJMP _0x20C0006
; 0003 030B 	if (!(fs->flag & FA_OPENED))		/* Check if opened */
_0x600D1:
	MOVW R30,R16
	LDD  R26,Z+2
	ANDI R26,LOW(0x1)
	BRNE _0x600D2
; 0003 030C 			return FR_NOT_OPENED;
	LDI  R30,LOW(5)
	RJMP _0x20C0006
; 0003 030D 
; 0003 030E 	if (ofs > fs->fsize) ofs = fs->fsize;	/* Clip offset with the file size */
_0x600D2:
	MOVW R26,R16
	ADIW R26,28
	CALL SUBOPT_0x63
	CALL __CPD12
	BRSH _0x600D3
	MOVW R26,R16
	ADIW R26,28
	CALL __GETD1P
	__PUTD1S 18
; 0003 030F 	ifptr = fs->fptr;
_0x600D3:
	MOVW R26,R16
	ADIW R26,24
	CALL SUBOPT_0x35
; 0003 0310 	fs->fptr = 0;
	MOVW R26,R16
	ADIW R26,24
	CALL SUBOPT_0x40
; 0003 0311 	if (ofs > 0) {
	CALL SUBOPT_0x64
	CALL __CPD02
	BRLO PC+2
	RJMP _0x600D4
; 0003 0312 		bcs = (DWORD)fs->csize * 512;	/* Cluster size (byte) */
	MOVW R30,R16
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x21
	__PUTD1S 10
; 0003 0313 		if (ifptr > 0 &&
; 0003 0314 			(ofs - 1) / bcs >= (ifptr - 1) / bcs) {	/* When seek to same or following cluster, */
	CALL SUBOPT_0x32
	CALL __CPD02
	BRSH _0x600D6
	CALL SUBOPT_0x65
	CALL SUBOPT_0x66
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x66
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD21
	BRSH _0x600D7
_0x600D6:
	RJMP _0x600D5
_0x600D7:
; 0003 0315 			fs->fptr = (ifptr - 1) & ~(bcs - 1);	/* start from the current cluster */
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x67
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x17
	CALL SUBOPT_0x67
	CALL __COMD1
	CALL __ANDD12
	__PUTD1RNS 16,24
; 0003 0316 			ofs -= fs->fptr;
	MOVW R26,R16
	ADIW R26,24
	CALL SUBOPT_0x63
	CALL __SUBD21
	__PUTD2S 18
; 0003 0317 			clst = fs->curr_clust;
	MOVW R26,R16
	ADIW R26,36
	CALL __GETD1P
	CALL SUBOPT_0x5B
; 0003 0318 		} else {							/* When seek to back cluster, */
	RJMP _0x600D8
_0x600D5:
; 0003 0319 			clst = fs->org_clust;			/* start from the first cluster */
	MOVW R26,R16
	ADIW R26,32
	CALL __GETD1P
	CALL SUBOPT_0x5B
; 0003 031A 			fs->curr_clust = clst;
	CALL SUBOPT_0x68
; 0003 031B 		}
_0x600D8:
; 0003 031C 		while (ofs > bcs) {				/* Cluster following loop */
_0x600D9:
	CALL SUBOPT_0x17
	CALL SUBOPT_0x64
	CALL __CPD12
	BRSH _0x600DB
; 0003 031D 			clst = get_fat(clst);		/* Follow cluster chain */
	CALL SUBOPT_0x2C
	CALL _get_fat_G003
	CALL SUBOPT_0x5B
; 0003 031E 			if (clst <= 1 || clst >= fs->max_clust) goto fe_abort;
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x26
	BRLO _0x600DD
	MOVW R26,R16
	ADIW R26,8
	CALL __GETD1P
	CALL SUBOPT_0x2C
	CALL __CPD21
	BRLO _0x600DC
_0x600DD:
	RJMP _0x600DF
; 0003 031F 			fs->curr_clust = clst;
_0x600DC:
	CALL SUBOPT_0x68
; 0003 0320 			fs->fptr += bcs;
	MOVW R30,R16
	CALL SUBOPT_0x57
	CALL SUBOPT_0x18
	CALL __ADDD12
	MOVW R26,R0
	CALL __PUTDP1
; 0003 0321 			ofs -= bcs;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x65
	CALL __SUBD12
	__PUTD1S 18
; 0003 0322 		}
	RJMP _0x600D9
_0x600DB:
; 0003 0323 		fs->fptr += ofs;
	MOVW R30,R16
	CALL SUBOPT_0x57
	CALL SUBOPT_0x64
	CALL __ADDD12
	MOVW R26,R0
	CALL __PUTDP1
; 0003 0324 		sect = clust2sect(clst);		/* Current sector */
	CALL SUBOPT_0x2C
	RCALL _clust2sect_G003
	CALL SUBOPT_0xF
; 0003 0325 		if (!sect) goto fe_abort;
	CALL SUBOPT_0xE
	CALL __CPD10
	BREQ _0x600DF
; 0003 0326 		fs->csect = (BYTE)(ofs / 512);	/* Sector offset in the cluster */
	CALL SUBOPT_0x64
	__GETD1N 0x200
	CALL __DIVD21U
	__PUTB1RNS 16,3
; 0003 0327 		if (ofs % 512)
	CALL SUBOPT_0x65
	ANDI R31,HIGH(0x1FF)
	SBIW R30,0
	BREQ _0x600E1
; 0003 0328 			fs->dsect = sect + fs->csect++;
	MOVW R26,R16
	CALL SUBOPT_0x54
	CALL SUBOPT_0x10
	CALL SUBOPT_0x55
	__PUTD1RNS 16,40
; 0003 0329 	}
_0x600E1:
; 0003 032A 
; 0003 032B 	return FR_OK;
_0x600D4:
	LDI  R30,LOW(0)
	RJMP _0x20C0006
; 0003 032C 
; 0003 032D fe_abort:
_0x600DF:
; 0003 032E 	fs->flag = 0;
	MOVW R26,R16
	CALL SUBOPT_0x58
; 0003 032F 	return FR_DISK_ERR;
_0x20C0006:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,22
	RET
; 0003 0330 }
; .FEND
;#endif
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Create a Directroy Object                                             */
;/*-----------------------------------------------------------------------*/
;#if _USE_DIR
;
;FRESULT pf_opendir (
; 0003 033B 	DIR *dj,			/* Pointer to directory object to create */
; 0003 033C 	const char *path	/* Pointer to the directory path */
; 0003 033D )
; 0003 033E {
_pf_opendir:
; .FSTART _pf_opendir
; 0003 033F 	FRESULT res;
; 0003 0340 	BYTE sp[12], dir[32];
; 0003 0341 	FATFS *fs = FatFs;
; 0003 0342 
; 0003 0343 
; 0003 0344 	if (!fs) {				/* Check file system */
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,44
	CALL SUBOPT_0x36
;	*dj -> Y+50
;	*path -> Y+48
;	res -> R17
;	sp -> Y+36
;	dir -> Y+4
;	*fs -> R18,R19
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x600E2
; 0003 0345 		res = FR_NOT_ENABLED;
	LDI  R17,LOW(6)
; 0003 0346 	} else {
	RJMP _0x600E3
_0x600E2:
; 0003 0347 		fs->buf = dir;
	CALL SUBOPT_0x4F
; 0003 0348 		dj->fn = sp;
	__PUTW1SNS 50,2
; 0003 0349 		res = follow_path(dj, path);			/* Follow the path to the directory */
	CALL SUBOPT_0x69
	RCALL _follow_path_G003
	MOV  R17,R30
; 0003 034A 		if (res == FR_OK) {						/* Follow completed */
	CPI  R17,0
	BRNE _0x600E4
; 0003 034B 			if (dir[0]) {						/* It is not the root dir */
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x600E5
; 0003 034C 				if (dir[DIR_Attr] & AM_DIR) {	/* The object is a directory */
	LDD  R30,Y+15
	ANDI R30,LOW(0x10)
	BREQ _0x600E6
; 0003 034D 					dj->sclust =
; 0003 034E #if _FS_FAT32
; 0003 034F 					((DWORD)LD_WORD(dir+DIR_FstClusHI) << 16) |
; 0003 0350 #endif
; 0003 0351 					LD_WORD(dir+DIR_FstClusLO);
	CALL SUBOPT_0x50
	__PUTD1SNS 50,4
; 0003 0352 				} else {						/* The object is not a directory */
	RJMP _0x600E7
_0x600E6:
; 0003 0353 					res = FR_NO_PATH;
	LDI  R17,LOW(4)
; 0003 0354 				}
_0x600E7:
; 0003 0355 			}
; 0003 0356 			if (res == FR_OK)
_0x600E5:
	CPI  R17,0
	BRNE _0x600E8
; 0003 0357 				res = dir_rewind(dj);			/* Rewind dir */
	LDD  R26,Y+50
	LDD  R27,Y+50+1
	RCALL _dir_rewind_G003
	MOV  R17,R30
; 0003 0358 		}
_0x600E8:
; 0003 0359 		if (res == FR_NO_FILE) res = FR_NO_PATH;
_0x600E4:
	CPI  R17,3
	BRNE _0x600E9
	LDI  R17,LOW(4)
; 0003 035A 	}
_0x600E9:
_0x600E3:
; 0003 035B 
; 0003 035C 	return res;
	RJMP _0x20C0005
; 0003 035D }
; .FEND
;
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Read Directory Entry in Sequense                                      */
;/*-----------------------------------------------------------------------*/
;
;FRESULT pf_readdir (
; 0003 0367 	DIR *dj,			/* Pointer to the open directory object */
; 0003 0368 	FILINFO *fno		/* Pointer to file information to return */
; 0003 0369 )
; 0003 036A {
_pf_readdir:
; .FSTART _pf_readdir
; 0003 036B 	FRESULT res;
; 0003 036C 	BYTE sp[12], dir[32];
; 0003 036D 	FATFS *fs = FatFs;
; 0003 036E 
; 0003 036F 
; 0003 0370 	if (!fs) {				/* Check file system */
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,44
	CALL SUBOPT_0x36
;	*dj -> Y+50
;	*fno -> Y+48
;	res -> R17
;	sp -> Y+36
;	dir -> Y+4
;	*fs -> R18,R19
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x600EA
; 0003 0371 		res = FR_NOT_ENABLED;
	LDI  R17,LOW(6)
; 0003 0372 	} else {
	RJMP _0x600EB
_0x600EA:
; 0003 0373 		fs->buf = dir;
	CALL SUBOPT_0x4F
; 0003 0374 		dj->fn = sp;
	__PUTW1SNS 50,2
; 0003 0375 		if (!fno) {
	LDD  R30,Y+48
	LDD  R31,Y+48+1
	SBIW R30,0
	BRNE _0x600EC
; 0003 0376 			res = dir_rewind(dj);
	LDD  R26,Y+50
	LDD  R27,Y+50+1
	CALL _dir_rewind_G003
	MOV  R17,R30
; 0003 0377 		} else {
	RJMP _0x600ED
_0x600EC:
; 0003 0378 			res = dir_read(dj);
	LDD  R26,Y+50
	LDD  R27,Y+50+1
	RCALL _dir_read_G003
	MOV  R17,R30
; 0003 0379 			if (res == FR_NO_FILE) {
	CPI  R17,3
	BRNE _0x600EE
; 0003 037A 				dj->sect = 0;
	LDD  R26,Y+50
	LDD  R27,Y+50+1
	CALL SUBOPT_0x3C
; 0003 037B 				res = FR_OK;
	LDI  R17,LOW(0)
; 0003 037C 			}
; 0003 037D 			if (res == FR_OK) {				/* A valid entry is found */
_0x600EE:
	CPI  R17,0
	BRNE _0x600EF
; 0003 037E 				get_fileinfo(dj, fno);		/* Get the object information */
	CALL SUBOPT_0x69
	RCALL _get_fileinfo_G003
; 0003 037F 				res = dir_next(dj);			/* Increment index for next */
	LDD  R26,Y+50
	LDD  R27,Y+50+1
	RCALL _dir_next_G003
	MOV  R17,R30
; 0003 0380 				if (res == FR_NO_FILE) {
	CPI  R17,3
	BRNE _0x600F0
; 0003 0381 					dj->sect = 0;
	LDD  R26,Y+50
	LDD  R27,Y+50+1
	CALL SUBOPT_0x3C
; 0003 0382 					res = FR_OK;
	LDI  R17,LOW(0)
; 0003 0383 				}
; 0003 0384 			}
_0x600F0:
; 0003 0385 		}
_0x600EF:
_0x600ED:
; 0003 0386 	}
_0x600EB:
; 0003 0387 
; 0003 0388 	return res;
_0x20C0005:
	MOV  R30,R17
	CALL __LOADLOCR4
	ADIW R28,52
	RET
; 0003 0389 }
; .FEND
;
;
;/*-----------------------------------------------------------------------*/
;/* Rename file inside provided directory                                      */
;/*-----------------------------------------------------------------------*/
;FRESULT pf_rename (
; 0003 0390     const char* dirname,
; 0003 0391     const char* oldname,
; 0003 0392     const char* newname
; 0003 0393 )
; 0003 0394 {
_pf_rename:
; .FSTART _pf_rename
; 0003 0395     FRESULT res;
; 0003 0396     FILINFO fno;
; 0003 0397     DIR dir;
; 0003 0398     int i,j;
; 0003 0399     BYTE rwbuf[512];
; 0003 039A 
; 0003 039B     res = pf_opendir(&dir, dirname);
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,38
	SUBI R29,2
	CALL __SAVELOCR6
;	*dirname -> Y+560
;	*oldname -> Y+558
;	*newname -> Y+556
;	res -> R17
;	fno -> Y+534
;	dir -> Y+518
;	i -> R18,R19
;	j -> R20,R21
;	rwbuf -> Y+6
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6B
; 0003 039C     if (res == FR_OK) {
	BREQ PC+2
	RJMP _0x600F1
; 0003 039D         i = strlen(oldname);
	CALL SUBOPT_0x6C
	MOVW R18,R30
; 0003 039E         j = strlen(oldname);
	CALL SUBOPT_0x6C
	MOVW R20,R30
; 0003 039F         if(i==6 || j==6){
; 0003 03A0 
; 0003 03A1         }
; 0003 03A2         for (;;) {
_0x600F6:
; 0003 03A3             res = pf_readdir(&dir, &fno);
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6D
; 0003 03A4             if (res != FR_OK || fno.fname[0] == 0) break;
	BRNE _0x600F9
	MOVW R30,R28
	SUBI R30,LOW(-(534))
	SBCI R31,HIGH(-(534))
	LDD  R26,Z+9
	CPI  R26,LOW(0x0)
	BRNE _0x600F8
_0x600F9:
	RJMP _0x600F7
; 0003 03A5             for(j=0;j<i;j++){
_0x600F8:
	__GETWRN 20,21,0
_0x600FC:
	__CPWRR 20,21,18,19
	BRGE _0x600FD
; 0003 03A6                 if(fno.fname[j] != oldname[j]){
	CALL SUBOPT_0x6E
	__GETW2SX 558
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CP   R30,R1
	BRNE _0x600FD
; 0003 03A7                     break;
; 0003 03A8                 }
; 0003 03A9             }
	__ADDWRN 20,21,1
	RJMP _0x600FC
_0x600FD:
; 0003 03AA             if(i==j){
	__CPWRR 20,21,18,19
	BREQ PC+2
	RJMP _0x600FF
; 0003 03AB 
; 0003 03AC                res = disk_readp(rwbuf,dir.sect,0,512);
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6F
	CALL __PUTPARD1
	CALL SUBOPT_0x59
	LDI  R26,LOW(512)
	LDI  R27,HIGH(512)
	CALL _disk_readp
	MOV  R17,R30
; 0003 03AD                if (res != FR_OK) break;
	CPI  R17,0
	BREQ _0x60100
	RJMP _0x600F7
; 0003 03AE                i = strlen(newname);
_0x60100:
	CALL SUBOPT_0x70
	CALL _strlen
	MOVW R18,R30
; 0003 03AF                for(j=0;j<i;j++){
	__GETWRN 20,21,0
_0x60102:
	__CPWRR 20,21,18,19
	BRGE _0x60103
; 0003 03B0                   rwbuf[((dir.index-1)*32)%512+j]=newname[j];
	__GETW1SX 518
	SBIW R30,1
	LSL  R30
	ROL  R31
	CALL __LSLW4
	ANDI R31,HIGH(0x1FF)
	ADD  R30,R20
	ADC  R31,R21
	MOVW R26,R28
	ADIW R26,6
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOVW R30,R20
	CALL SUBOPT_0x70
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R22
	ST   X,R30
; 0003 03B1                }
	__ADDWRN 20,21,1
	RJMP _0x60102
_0x60103:
; 0003 03B2                res = disk_writep(0,dir.sect);
	CALL SUBOPT_0x59
	CALL SUBOPT_0x6F
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x71
; 0003 03B3                if (res != FR_OK) break;
	BRNE _0x600F7
; 0003 03B4                res = disk_writep(rwbuf,512);
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x71
; 0003 03B5                if (res != FR_OK) break;
	BRNE _0x600F7
; 0003 03B6                res = disk_writep(0,0);
	CALL SUBOPT_0x59
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x71
; 0003 03B7                if (res != FR_OK) break;
	BRNE _0x600F7
; 0003 03B8                res = pf_opendir(&dir, dirname);
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6B
; 0003 03B9                if (res != FR_OK) break;
	BRNE _0x600F7
; 0003 03BA                res = pf_readdir(&dir, &fno);
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6D
; 0003 03BB                if (res != FR_OK || fno.fname[0] == 0) break;
	BRNE _0x60109
	MOVW R30,R28
	SUBI R30,LOW(-(534))
	SBCI R31,HIGH(-(534))
	LDD  R26,Z+9
	CPI  R26,LOW(0x0)
	BRNE _0x60108
_0x60109:
	RJMP _0x600F7
; 0003 03BC                for(j=0;j<i;j++){
_0x60108:
	__GETWRN 20,21,0
_0x6010C:
	__CPWRR 20,21,18,19
	BRGE _0x6010D
; 0003 03BD                     if(fno.fname[j] != newname[j]){
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x70
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CP   R30,R1
	BREQ _0x6010E
; 0003 03BE                         return FR_NO_FILE;
	LDI  R30,LOW(3)
	RJMP _0x20C0004
; 0003 03BF                     }
; 0003 03C0                }
_0x6010E:
	__ADDWRN 20,21,1
	RJMP _0x6010C
_0x6010D:
; 0003 03C1                if(i==j){
	__CPWRR 20,21,18,19
	BREQ _0x600F7
; 0003 03C2                   break;
; 0003 03C3                }
; 0003 03C4             }
; 0003 03C5             else{
	RJMP _0x60110
_0x600FF:
; 0003 03C6                res=FR_NO_FILE;
	LDI  R17,LOW(3)
; 0003 03C7             }
_0x60110:
; 0003 03C8         }
	RJMP _0x600F6
_0x600F7:
; 0003 03C9     }
; 0003 03CA 
; 0003 03CB     return res;
_0x600F1:
	MOV  R30,R17
_0x20C0004:
	CALL __LOADLOCR6
	ADIW R28,50
	SUBI R29,-2
	RET
; 0003 03CC }
; .FEND
;#endif /* _USE_DIR */
;
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

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
	JMP  _0x20C0001
; .FEND
_put_usart_G100:
; .FSTART _put_usart_G100
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	JMP  _0x20C0002
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,8
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0x34
_0x2000016:
	MOVW R26,R28
	ADIW R26,20
	CALL SUBOPT_0x72
	__GETBRPF 30
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x73
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x73
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x74
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x75
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x74
	CALL SUBOPT_0x76
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x74
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,4
	CALL __GETD1P
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	__POINTD1FN _tbl10_G100,0
	CALL SUBOPT_0xF
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	__POINTD1FN _tbl16_G100,0
	CALL SUBOPT_0xF
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x74
	CALL SUBOPT_0x76
	STD  Y+12,R30
	STD  Y+12+1,R31
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000043
	CALL __ANEGW1
	STD  Y+12,R30
	STD  Y+12+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x74
	CALL SUBOPT_0x76
	STD  Y+12,R30
	STD  Y+12+1,R31
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x73
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	MOVW R26,R28
	ADIW R26,6
	CALL SUBOPT_0x72
	__GETBRPF 18
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x73
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	CALL SUBOPT_0xE
	CALL __GETW1PF
	STD  Y+10,R30
	STD  Y+10+1,R31
	CALL SUBOPT_0xE
	__ADDD1N 2
	CALL SUBOPT_0xF
_0x200005A:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+12,R30
	STD  Y+12+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x75
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x73
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x75
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL __GETW1P
_0x20C0003:
	CALL __LOADLOCR6
	ADIW R28,24
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETD1P
	CALL __PUTPARD1
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

	.DSEG

	.CSEG

	.CSEG
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	CALL __PUTPARD2
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
    ld   r22,y+
    ld   r23,y+
    out  rampz,r22
strlenf0:
    elpm r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
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

	.DSEG

	.CSEG
__lcd_write_nibble_G103:
; .FSTART __lcd_write_nibble_G103
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 17
	SBI  0x15,1
	__DELAY_USB 17
	CBI  0x15,1
	__DELAY_USB 17
	RJMP _0x20C0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
	__DELAY_USB 167
	RJMP _0x20C0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R6,Y+1
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x77
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x77
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	MOV  R6,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2060005
	LDS  R30,__lcd_maxx
	CP   R6,R30
	BRLO _0x2060004
_0x2060005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2060007
	RJMP _0x20C0001
_0x2060007:
_0x2060004:
	INC  R6
	SBI  0x15,2
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,2
	RJMP _0x20C0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2060008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2060008
_0x206000A:
	LDD  R17,Y+0
_0x20C0002:
	ADIW R28,3
	RET
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	CALL __PUTPARD2
	ST   -Y,R17
_0x206000B:
	MOVW R26,R28
	ADIW R26,1
	CALL SUBOPT_0x72
	__GETBRPF 30
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x206000B
_0x206000D:
	LDD  R17,Y+0
	ADIW R28,5
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,1
	SBI  0x14,2
	SBI  0x14,3
	CBI  0x15,1
	CBI  0x15,2
	CBI  0x15,3
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G103,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G103,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x78
	CALL SUBOPT_0x78
	CALL SUBOPT_0x78
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G103
	__DELAY_USW 250
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_fat:
	.BYTE 0x2C
_path:
	.BYTE 0x40
_text:
	.BYTE 0xC
_buffer:
	.BYTE 0x100
_testChar_S0000005000:
	.BYTE 0x1
___AddrToZ24ByteToSPMCR_SPM_E:
	.BYTE 0x2
___AddrToZ24ByteToSPMCR_SPM_EW:
	.BYTE 0x2

	.ESEG

	.ORG 0xA
__EepromBackup:
	.BYTE 0x107

	.ORG 0x0

	.DSEG
_CardType_G002:
	.BYTE 0x1
_wc_S0020007000:
	.BYTE 0x2
_FatFs_G003:
	.BYTE 0x2
__seed_G101:
	.BYTE 0x4
__base_y_G103:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	JMP  _itoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_error_msg*2)
	LDI  R27,HIGH(_error_msg*2)
	LDI  R24,BYTE3(_error_msg*2)
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __LSLD1
	CALL __LSLD1
	CALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	CALL __PUTPARD1
	LDI  R30,LOW(_path)
	LDI  R31,HIGH(_path)
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x6:
	__POINTD1FN _0x0,349
	CALL __PUTPARD1
	MOVW R30,R8
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETD1N 0xB
	CALL __PUTPARD1
	LDI  R24,8
	CALL _printf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	__GETD1N 0x2
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(_testChar_S0000005000)
	LDI  R31,HIGH(_testChar_S0000005000)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _ReadFlashBytes

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL __PUTPARD1
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD:
	MOVW R30,R16
	__GETD2S 4
	CLR  R22
	CLR  R23
	CALL __ADDD21
	JMP  _ReadFlashByte

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	__GETW1SX 268
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	__GETD1SX 272
	__ANDD1N 0xFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	__GETD2SX 272
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x14:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x16:
	CLR  R22
	CLR  R23
	CALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x17:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1A:
	ST   -Y,R30
	__GETD2N 0x0
	JMP  _send_cmd_G002

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	CALL _xmit_spi
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1C:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	__GETD2N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	__GETD2N 0x200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	RCALL SUBOPT_0x1F
	CALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	LDS  R30,_FatFs_G003
	LDS  R31,_FatFs_G003+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x26:
	__CPD2N 0x2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x27:
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	__GETD2Z 12
	MOVW R30,R18
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _disk_readp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _disk_readp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	__GETD2Z 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	__ADDD1N 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2C:
	__GETD2S 14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	CALL __ADDD12
	CALL __PUTPARD1
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	LDI  R27,0
	CALL _disk_readp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x30:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRMN 16,17,0,_FatFs_G003
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x32:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x33:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	CALL __GETD1P
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x36:
	CALL __SAVELOCR4
	__GETWRMN 18,19,0,_FatFs_G003
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x37:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,12
	CALL __GETD1P
	CALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x39:
	LDS  R26,_FatFs_G003
	LDS  R27,_FatFs_G003+1
	ADIW R26,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	__GETD2Z 12
	CALL __PUTPARD2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3B:
	CALL __GETW1P
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	LSL  R30
	CALL __LSLW4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(32)
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	ADIW R26,12
	RCALL SUBOPT_0x33
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3D:
	MOV  R30,R18
	SUBI R18,-1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3E:
	MOV  R30,R21
	SUBI R21,-1
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	MOVW R26,R18
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R16,X
	CPI  R16,32
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	RCALL SUBOPT_0x33
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,2
	CALL __GETW1P
	LDD  R30,Z+11
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	CALL __GETW1P
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	CLR  R22
	CLR  R23
	CALL __ORD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x44:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x1C
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	MOVW R30,R28
	ADIW R30,17
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x47:
	__GETD2S 15
	CALL _check_fs_G003
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	__GETD1S 15
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	__GETD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	MOVW R30,R28
	ADIW R30,31
	SBIW R30,13
	MOVW R26,R30
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4C:
	LDD  R30,Y+53
	LDD  R31,Y+53+1
	LDD  R26,Z+4
	LDD  R27,Z+5
	MOVW R30,R26
	CALL __LSRW4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	LDD  R30,Z+1
	LDI  R31,0
	CALL __CWD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4E:
	LDD  R30,Y+53
	LDD  R31,Y+53+1
	__GETD2Z 12
	RCALL SUBOPT_0x4A
	CALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4F:
	MOVW R30,R28
	ADIW R30,4
	__PUTW1RNS 18,6
	MOVW R30,R28
	ADIW R30,36
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x50:
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	CLR  R22
	CLR  R23
	CALL __LSLD16
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+30
	LDD  R31,Y+30+1
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x51:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__GETD2Z 24
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x52:
	__GETD1N 0x200
	CALL __DIVD21U
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__GETD2Z 36
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x54:
	ADIW R26,3
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	CALL __CWD1
	CALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x56:
	LDD  R26,Z+24
	LDD  R27,Z+25
	MOVW R30,R26
	ANDI R31,HIGH(0x1FF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x57:
	ADIW R30,24
	MOVW R0,R30
	MOVW R26,R30
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	ADIW R26,2
	LDI  R30,LOW(0)
	ST   X,R30
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x59:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5A:
	MOVW R30,R20
	__GETD2Z 24
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5B:
	__PUTD1S 14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5C:
	__GETD1S 14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5D:
	__GETW1SX 524
	ANDI R31,HIGH(0x1FF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5E:
	__GETW2SX 522
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5F:
	__GETW2SX 524
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x60:
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x5F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x61:
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,8
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOVW R30,R20
	__GETW2SX 526
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R22
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x62:
	__SUBD2N 512
	CALL _pf_lseek
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	CALL __GETD1P
	__GETD2S 18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x64:
	__GETD2S 18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x65:
	__GETD1S 18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x66:
	__SUBD1N 1
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x17
	CALL __DIVD21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x67:
	__SUBD1N 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x68:
	RCALL SUBOPT_0x5C
	__PUTD1RNS 16,36
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x69:
	LDD  R30,Y+50
	LDD  R31,Y+50+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+50
	LDD  R27,Y+50+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6A:
	MOVW R30,R28
	SUBI R30,LOW(-(518))
	SBCI R31,HIGH(-(518))
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6B:
	__GETW2SX 562
	CALL _pf_opendir
	MOV  R17,R30
	CPI  R17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6C:
	__GETW2SX 558
	JMP  _strlen

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6D:
	MOVW R26,R28
	SUBI R26,LOW(-(536))
	SBCI R27,HIGH(-(536))
	CALL _pf_readdir
	MOV  R17,R30
	CPI  R17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6E:
	MOVW R30,R28
	SUBI R30,LOW(-(534))
	SBCI R31,HIGH(-(534))
	ADIW R30,9
	ADD  R30,R20
	ADC  R31,R21
	LD   R1,Z
	MOVW R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6F:
	MOVW R30,R28
	SUBI R30,LOW(-(520))
	SBCI R31,HIGH(-(520))
	ADIW R30,12
	MOVW R26,R30
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x70:
	__GETW2SX 556
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x71:
	CALL _disk_writep
	MOV  R17,R30
	CPI  R17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x72:
	CALL __GETD1P_INC
	RCALL SUBOPT_0x2B
	CALL __PUTDP1_DEC
	RJMP SUBOPT_0x67

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x73:
	ST   -Y,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x74:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	SBIW R30,4
	STD  Y+18,R30
	STD  Y+18+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x75:
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x76:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x77:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x78:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G103
	__DELAY_USW 250
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x9C4
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

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

__ANDD12:
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	RET

__ORD12:
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__LSLD1:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	RET

__LSRD16:
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	RET

__LSLD16:
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__COMD1:
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETW1PF:
	OUT  RAMPZ,R22
	ELPM R0,Z+
	ELPM R31,Z
	MOV  R30,R0
	RET

__GETD1PF:
	OUT  RAMPZ,R22
	ELPM R0,Z+
	ELPM R1,Z+
	ELPM R22,Z+
	ELPM R23,Z
	MOVW R30,R0
	RET

__GETD2PF:
	OUT  RAMPZ,R22
	ELPM R26,Z+
	ELPM R27,Z+
	ELPM R24,Z+
	ELPM R25,Z
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

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
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

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
	OUT  RAMPZ,R22
__INITLOC0:
	ELPM R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
