
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
_cvt_G002:
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
	.DB  0xD,0xA,0x0,0x53,0x44,0x20,0x45,0x52
	.DB  0x52,0x4F,0x52,0x3A,0x20,0x0,0x2C,0x0
	.DB  0x2F,0x30,0x2F,0x75,0x6E,0x69,0x74,0x74
	.DB  0x65,0x73,0x74,0x2E,0x74,0x78,0x74,0x0
	.DB  0x4C,0x6F,0x67,0x69,0x63,0x61,0x6C,0x20
	.DB  0x64,0x72,0x69,0x76,0x65,0x20,0x30,0x3A
	.DB  0x20,0x6D,0x6F,0x75,0x6E,0x74,0x65,0x64
	.DB  0x20,0x4F,0x4B,0xD,0xA,0x0,0x25,0x73
	.DB  0x20,0xD,0xA,0x0,0x46,0x69,0x6C,0x65
	.DB  0x20,0x25,0x73,0x20,0x63,0x72,0x65,0x61
	.DB  0x74,0x65,0x64,0x20,0x4F,0x4B,0xD,0xA
	.DB  0x0,0x25,0x75,0x20,0x62,0x79,0x74,0x65
	.DB  0x73,0x20,0x77,0x72,0x69,0x74,0x74,0x65
	.DB  0x6E,0x20,0x6F,0x66,0x20,0x25,0x75,0xD
	.DB  0xA,0x0,0x46,0x69,0x6C,0x65,0x20,0x25
	.DB  0x73,0x20,0x6F,0x70,0x65,0x6E,0x65,0x64
	.DB  0x20,0x4F,0x4B,0xD,0xA,0x0,0x25,0x75
	.DB  0x20,0x62,0x79,0x74,0x65,0x73,0x20,0x72
	.DB  0x65,0x61,0x64,0xD,0xA,0x0,0x52,0x65
	.DB  0x61,0x64,0x20,0x74,0x65,0x78,0x74,0x3A
	.DB  0x20,0x22,0x25,0x73,0x22,0xD,0xA,0x0
	.DB  0x70,0x66,0x66,0x20,0x54,0x65,0x73,0x74
	.DB  0x2E,0x0,0x54,0x65,0x73,0x74,0x32,0x20
	.DB  0x64,0x6F,0x6E,0x65,0x2E,0x0
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
	.DW  _0x13
	.DD  _0x0*2+232

	.DW  0x10
	.DW  _0x14
	.DD  _0x0*2+232

	.DW  0x10
	.DW  _0x15
	.DD  _0x0*2+232

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
;#include <pff.h>
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
; 0000 0053 {

	.CSEG
; 0000 0054     char strnum[5];
; 0000 0055     if(num>100){
;	res -> Y+6
;	num -> Y+5
;	strnum -> Y+0
; 0000 0056        num=100;
; 0000 0057     }
; 0000 0058     itoa(num,strnum);
; 0000 0059     do{
; 0000 005A     if ((res>=FR_DISK_ERR) && (res<=FR_NO_FILESYSTEM)){//FR_NO_FILESYSTEM  FR_TIMEOUT
; 0000 005B        lcd_gotoxy(0,0);
; 0000 005C        printf("ERROR: %p\r\n",error_msg[res]);
; 0000 005D        lcd_putsf("SD ERROR: ");
; 0000 005E        delay_ms(100);
; 0000 005F        lcd_puts(strnum);
; 0000 0060        lcd_putsf(",");
; 0000 0061        itoa(res,strnum);
; 0000 0062        lcd_puts(strnum);
; 0000 0063        lcd_gotoxy(0,1);
; 0000 0064        lcd_putsf(error_msg[res]);
; 0000 0065     }
; 0000 0066     /* stop here */
; 0000 0067     //do
; 0000 0068         //{
; 0000 0069           PORTC.0=0;
; 0000 006A           PORTC.1=0;
; 0000 006B           delay_ms(150);
; 0000 006C           PORTC.1=1;
; 0000 006D           PORTC.0=1;
; 0000 006E           delay_ms(150);
; 0000 006F           PORTC=0xFC;
; 0000 0070         }
; 0000 0071       while(1);
; 0000 0072 }
;unsigned char rn(char *newname, char *oldname){
; 0000 0073 unsigned char rn(char *newname, char *oldname){
; 0000 0074     strcpy(path,"/0/unittest.txt");
;	*newname -> Y+2
;	*oldname -> Y+0
; 0000 0075 
; 0000 0076 }

	.DSEG
_0x13:
	.BYTE 0x10
;unsigned char RenameTest(){
; 0000 0077 unsigned char RenameTest(){

	.CSEG
; 0000 0078    int retry;
; 0000 0079    strcpy(path,"/0/unittest.txt");
;	retry -> R16,R17
; 0000 007A 
; 0000 007B }

	.DSEG
_0x14:
	.BYTE 0x10
;
;unsigned char UnitTest1(){
; 0000 007D unsigned char UnitTest1(){

	.CSEG
; 0000 007E     strcpy(path,"/0/unittest.txt");
; 0000 007F     /* mount logical drive 0: */
; 0000 0080     //if ((res=f_mount(0,&fat))==FR_OK)
; 0000 0081     for(retry=0;retry<5;retry++){
; 0000 0082         res=pf_mount(&fat);
; 0000 0083         if (res==FR_OK){
; 0000 0084             break;
; 0000 0085         }
; 0000 0086         else{
; 0000 0087           delay_ms(500);
; 0000 0088         }
; 0000 0089     }
; 0000 008A     if (res==FR_OK)
; 0000 008B        printf("Logical drive 0: mounted OK\r\n");
; 0000 008C     else
; 0000 008D        /* an error occured, display it and stop */
; 0000 008E        error(res,1);
; 0000 008F 
; 0000 0090 
; 0000 0091     printf("%s \r\n",path);
; 0000 0092     /*this line will remove READ_ONLY attribute*/
; 0000 0093     //f_chmod(path, AM_ARC, AM_ARC|AM_RDO);
; 0000 0094     /* create a new file in the root of drive 0:
; 0000 0095        and set write access mode */
; 0000 0096     //if ((res=f_open(&file,path,FA_CREATE_ALWAYS | FA_WRITE))==FR_OK)
; 0000 0097     if ((res=pf_open(path))==FR_OK)
; 0000 0098        printf("File %s created OK\r\n",path);
; 0000 0099     else{
; 0000 009A        /* an error occured, display it and stop */
; 0000 009B        if(res!=3)
; 0000 009C             error(res,2);
; 0000 009D     }
; 0000 009E 
; 0000 009F     /* write some text to the file,
; 0000 00A0        without the NULL string terminator sizeof(data)-1 */
; 0000 00A1     //if ((res=f_write(&file,text,sizeof(text)-1,&nbytes))==FR_OK)
; 0000 00A2     if ((res=pf_write(text,sizeof(text)-1,&nbytes))==FR_OK)
; 0000 00A3        printf("%u bytes written of %u\r\n",nbytes,sizeof(text)-1);
; 0000 00A4     else
; 0000 00A5        ///* an error occured, display it and stop */
; 0000 00A6        error(res,3);
; 0000 00A7 
; 0000 00A8         /* close the file */
; 0000 00A9     /*
; 0000 00AA     if ((res=f_close(&file))==FR_OK)
; 0000 00AB        printf("File %s closed OK\r\n",path);
; 0000 00AC     else
; 0000 00AD        // an error occured, display it and stop
; 0000 00AE        error(res,4);
; 0000 00AF     */
; 0000 00B0 
; 0000 00B1     /* open the file in read mode */
; 0000 00B2 
; 0000 00B3     //if ((res=f_open(&file,path,FA_READ|FA_WRITE))==FR_OK)
; 0000 00B4     if ((res=pf_open(path))==FR_OK)
; 0000 00B5        printf("File %s opened OK\r\n",path);
; 0000 00B6     else
; 0000 00B7        ///* an error occured, display it and stop */
; 0000 00B8        error(res,7);
; 0000 00B9 
; 0000 00BA 
; 0000 00BB 
; 0000 00BC     /* read and display the file's content.
; 0000 00BD        make sure to leave space for a NULL terminator
; 0000 00BE        in the buffer, so maximum sizeof(buffer)-1 bytes can be read */
; 0000 00BF     //if ((res=f_read(&file,buffer,sizeof(buffer)-1,&nbytes))==FR_OK)
; 0000 00C0     if ((res=pf_read(buffer,sizeof(buffer)-1,&nbytes))==FR_OK)
; 0000 00C1        {
; 0000 00C2        printf("%u bytes read\r\n",nbytes);
; 0000 00C3        /* NULL terminate the char string in the buffer */
; 0000 00C4        buffer[nbytes+1]=NULL;
; 0000 00C5        /* display the buffer contents */
; 0000 00C6        printf("Read text: \"%s\"\r\n",buffer);
; 0000 00C7        }
; 0000 00C8     else
; 0000 00C9        /* an error occured, display it and stop */
; 0000 00CA        error(res,6);
; 0000 00CB 
; 0000 00CC 
; 0000 00CD     /* close the file */
; 0000 00CE     /*
; 0000 00CF     if ((res=f_close(&file))==FR_OK)
; 0000 00D0        printf("File %s closed OK\r\n",path);
; 0000 00D1     else
; 0000 00D2        // an error occured, display it and stop
; 0000 00D3        error(res,6);
; 0000 00D4     */
; 0000 00D5 
; 0000 00D6     /* display file's attribute, size and time stamp */
; 0000 00D7     //display_status(path);
; 0000 00D8 
; 0000 00D9 
; 0000 00DA     /* change file's attributes, set the file to be Read-Only */
; 0000 00DB     /*
; 0000 00DC     if ((res=f_chmod(path,AM_RDO,AM_RDO))==FR_OK)
; 0000 00DD        printf("Read-Only attribute set OK\r\n",path);
; 0000 00DE     else
; 0000 00DF        // an error occured, display it and stop
; 0000 00E0        error(res,7);
; 0000 00E1     */
; 0000 00E2   return 1;
; 0000 00E3 }

	.DSEG
_0x15:
	.BYTE 0x10
;void main( void ){
; 0000 00E4 void main( void ){

	.CSEG
_main:
; .FSTART _main
; 0000 00E5   unsigned char testBuffer1[PAGESIZE];      // Declares variables for testing
; 0000 00E6   //unsigned char testBuffer2[PAGESIZE];      // Note. Each array uses PAGESIZE bytes of
; 0000 00E7                                             // code stack
; 0000 00E8   static unsigned char testChar; // A warning will come saying that this var is set but never used. Ignore it.
; 0000 00E9   int index;
; 0000 00EA 
; 0000 00EB   /* globally enable interrupts */
; 0000 00EC     #asm("sei")
	SUBI R29,1
;	testBuffer1 -> Y+0
;	index -> R16,R17
	sei
; 0000 00ED 
; 0000 00EE   DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 00EF   PORTC=0xFF;
	OUT  0x15,R30
; 0000 00F0   /* initialize the LCD for 2 lines & 16 columns */
; 0000 00F1     lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00F2   /* switch to writing in Display RAM */
; 0000 00F3     //lcd_gotoxy(0,0);
; 0000 00F4     lcd_clear();
	CALL _lcd_clear
; 0000 00F5     //lcd_putsf("User char 0:");
; 0000 00F6 
; 0000 00F7   //disk_timerproc();
; 0000 00F8   lcd_clear();
	CALL _lcd_clear
; 0000 00F9   lcd_putsf("pff Test.");
	__POINTD2FN _0x0,384
	CALL _lcd_putsf
; 0000 00FA   delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 00FB   //UnitTest1();
; 0000 00FC 
; 0000 00FD   //RenameTest();
; 0000 00FE   //UpdateTest();
; 0000 00FF   //WriteDataTest();
; 0000 0100   //ReadDataTest();
; 0000 0101 
; 0000 0102   /* switch to writing in Display RAM */
; 0000 0103     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0104     lcd_putsf("Test2 done.");
	__POINTD2FN _0x0,394
	CALL _lcd_putsf
; 0000 0105   do
_0x27:
; 0000 0106     {
; 0000 0107       PORTC.0=0;
	CBI  0x15,0
; 0000 0108       PORTC.1=0;
	CALL SUBOPT_0x0
; 0000 0109       delay_ms(500);
; 0000 010A       PORTC.1=1;
; 0000 010B       PORTC.0=1;
	SBI  0x15,0
; 0000 010C       delay_ms(500);
	CALL SUBOPT_0x1
; 0000 010D       PORTC=0xFC;
	LDI  R30,LOW(252)
	OUT  0x15,R30
; 0000 010E     }
; 0000 010F   while(1);
	RJMP _0x27
; 0000 0110   for(index=0; index<PAGESIZE; index++){
_0x32:
	__CPWRN 16,17,256
	BRGE _0x33
; 0000 0111     testBuffer1[index]=index;//(unsigned char)0xFF; // Fills testBuffer1 with values FF
	MOVW R30,R16
	MOVW R26,R28
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R16
; 0000 0112   }
	__ADDWRN 16,17,1
	RJMP _0x32
_0x33:
; 0000 0113   if(WriteFlashBytes(0x2, testBuffer1,PAGESIZE)){     // Writes testbuffer1 to Flash page 2
	CALL SUBOPT_0x2
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(256)
	LDI  R27,HIGH(256)
	RCALL _WriteFlashBytes
	CPI  R30,0
	BREQ _0x34
; 0000 0114     PORTC.2=0;
	CBI  0x15,2
; 0000 0115   }                                            // Same as byte 4 on page 2
; 0000 0116   //MCUCR &= ~(1<<IVSEL);
; 0000 0117   ReadFlashBytes(0x2,&testChar,1);        // Reads back value from address 0x204
_0x34:
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 0118   if(testChar==0x00)
	LDS  R30,_testChar_S0000004000
	CPI  R30,0
	BRNE _0x37
; 0000 0119   {
; 0000 011A       ReadFlashBytes(0x3,&testChar,1);        // Reads back value from address 0x204
	__GETD1N 0x3
	CALL SUBOPT_0x4
; 0000 011B       if(testChar==0x01)
	LDS  R26,_testChar_S0000004000
	CPI  R26,LOW(0x1)
	BRNE _0x38
; 0000 011C         ReadFlashBytes(0x100,&testChar,1);        // Reads back value from address 0x204
	__GETD1N 0x100
	CALL SUBOPT_0x4
; 0000 011D         if(testChar==0xFE)
_0x38:
	LDS  R26,_testChar_S0000004000
	CPI  R26,LOW(0xFE)
	BRNE _0x39
; 0000 011E             ReadFlashBytes(0x101,&testChar,1);        // Reads back value from address 0x204
	__GETD1N 0x101
	CALL SUBOPT_0x4
; 0000 011F             if(testChar==0xFF)
_0x39:
	LDS  R26,_testChar_S0000004000
	CPI  R26,LOW(0xFF)
	BRNE _0x3A
; 0000 0120               while(1)
_0x3B:
; 0000 0121               {
; 0000 0122                   PORTC.0=0;
	CBI  0x15,0
; 0000 0123                   delay_ms(500);
	CALL SUBOPT_0x1
; 0000 0124                   PORTC.0=1;
	SBI  0x15,0
; 0000 0125                   delay_ms(500);
	CALL SUBOPT_0x1
; 0000 0126               }
	RJMP _0x3B
; 0000 0127   }
_0x3A:
; 0000 0128 
; 0000 0129   while(1)
_0x37:
_0x42:
; 0000 012A   {
; 0000 012B       PORTC.1=0;
	CALL SUBOPT_0x0
; 0000 012C       delay_ms(500);
; 0000 012D       PORTC.1=1;
; 0000 012E       delay_ms(500);
	CALL SUBOPT_0x1
; 0000 012F   }
	RJMP _0x42
; 0000 0130   //}
; 0000 0131 }
_0x49:
	RJMP _0x49
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
	CALL SUBOPT_0x5
; 0001 0045   return (unsigned char)*((MyFlashCharPointer)flashStartAdr);
	CALL SUBOPT_0x5
	__GETBRPF 30
	RJMP _0x20C0002
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
	CALL SUBOPT_0x6
;	flashStartAdr -> Y+4
;	*dataPage -> Y+2
;	index -> R16,R17
	CALL SUBOPT_0x7
; 0001 0052   if(!(flashStartAdr & (PAGESIZE-1))){      // If input address is a page address
	CALL SUBOPT_0x7
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
	CALL SUBOPT_0x8
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
	RJMP _0x20C0003
; 0001 0057   }
; 0001 0058   else{
_0x20005:
; 0001 0059     return FALSE;                           // Return FALSE if not valid page address
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C0003
; 0001 005A   }
; 0001 005B }
; .FEND
;unsigned char ReadFlashBytes(MyAddressType flashStartAdr, unsigned char *dataPage, unsigned int length){
; 0001 005C unsigned char ReadFlashBytes(MyAddressType flashStartAdr, unsigned char *dataPage, unsigned int length){
_ReadFlashBytes:
; .FSTART _ReadFlashBytes
; 0001 005D   	unsigned int index;
; 0001 005E   	flashStartAdr+=ADR_LIMIT_LOW;
	CALL SUBOPT_0x6
;	flashStartAdr -> Y+6
;	*dataPage -> Y+4
;	length -> Y+2
;	index -> R16,R17
	__GETD1S 6
	__ADDD1N 57344
	__PUTD1S 6
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
	RJMP _0x2000B
_0x2000C:
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
	CALL SUBOPT_0x6
;	flashStartAdr -> Y+4
;	*dataPage -> Y+2
;	index -> R16,R17
	CALL SUBOPT_0x7
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
	CALL SUBOPT_0x8
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
	RJMP _0x20C0003
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
	RJMP _0x20C0003
; 0001 006F   }
; 0001 0070   else{
_0x2000D:
; 0001 0071     PORTC.7=0;
	CBI  0x15,7
; 0001 0072     return FALSE;                           // Return FALSE if not valid page address
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C0003
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
	CALL SUBOPT_0x9
	SBIW R30,0
	BRNE PC+2
	RJMP _0x20019
; 0001 007B     {
; 0001 007C         flashAdrStart= flashAdr-(flashAdr%PAGESIZE);//0x1F0-(0x1F0%0x100)=0x0100                        //
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CALL __SUBD21
	__PUTD2S 8
; 0001 007D         flashAdrNext = flashAdrStart+PAGESIZE;          //0x0100+0x100=0x200
	CALL SUBOPT_0xC
	__ADDD1N 256
	__PUTD1S 4
; 0001 007E         if((flashAdrNext - flashAdr) >= length)    //enough space case
	CALL SUBOPT_0xB
	CALL SUBOPT_0x7
	CALL __SUBD12
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x9
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
	CALL SUBOPT_0x9
	SUB  R30,R16
	SBC  R31,R17
	__PUTW1SX 268
; 0001 0087         }
_0x2001B:
; 0001 0088         if(ReadFlashPage(flashAdrStart,tempBuffer)==FALSE) //read flash page to tempBuffer
	CALL SUBOPT_0xC
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
	RJMP _0x20C0005
; 0001 008C         }
; 0001 008D         for(lengthIndex=(flashAdr%PAGESIZE);lengthIndex<((flashAdr%PAGESIZE)+lengthStart);lengthIndex++)
_0x2001C:
	__GETW1SX 272
	ANDI R31,HIGH(0xFF)
	MOVW R18,R30
_0x20020:
	CALL SUBOPT_0xA
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
	CALL SUBOPT_0x7
	__PUTD1SX 272
; 0001 0092         if(WriteFlashPage(flashAdrStart+ADR_LIMIT_LOW,tempBuffer)==FALSE) //write tempBuffer to flash page
	CALL SUBOPT_0xC
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
	RJMP _0x20C0005
; 0001 0096         }
; 0001 0097     }
_0x20022:
	RJMP _0x20017
_0x20019:
; 0001 0098     return TRUE;
	LDI  R30,LOW(1)
_0x20C0005:
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
	CALL SUBOPT_0xD
; 0001 00E5   if( AddressCheck(flashStartAdr) ){
	CALL SUBOPT_0xE
	RCALL _AddressCheck
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20033
; 0001 00E6     if(eepromBackup(flashStartAdr,PAGESIZE,dataPage)==0)
	CALL SUBOPT_0xD
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
	RJMP _0x20C0004
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
	CALL SUBOPT_0xE
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
	CALL SUBOPT_0xE
	MOVW R30,R12
	ICALL
; 0001 0108     if(VerifyFlashPage(flashStartAdr,dataPage)==FALSE)
	CALL SUBOPT_0xD
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
	RJMP _0x20C0004
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
	RJMP _0x20C0004
; 0001 0117   }
; 0001 0118   else
_0x20033:
; 0001 0119     return FALSE;                           // Return FALSE if not address not
	LDI  R30,LOW(0)
; 0001 011A                                             // valid for writing
; 0001 011B }
_0x20C0004:
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
	CALL SUBOPT_0x7
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
	CALL SUBOPT_0xF
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
	CALL SUBOPT_0xF
	CP   R30,R0
	BREQ _0x20040
; 0001 0125          {
; 0001 0126             return FALSE;//error during backup on eeprom
	LDI  R30,LOW(0)
	RJMP _0x20C0003
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
_0x20C0003:
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
	CALL SUBOPT_0x5
	CPI  R30,0
	BREQ _0x20043
_0x20042:
	RJMP _0x20041
_0x20043:
; 0001 0166     return TRUE;                            // Address is a valid page address
	LDI  R30,LOW(1)
	RJMP _0x20C0002
; 0001 0167   else
_0x20041:
; 0001 0168     return FALSE;                           // Address is not a valid page address
	LDI  R30,LOW(0)
; 0001 0169   #endif
; 0001 016A }
_0x20C0002:
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
;#include "pff.h"		/* Petit FatFs configurations and declarations */
;#include "diskio.h"		/* Declarations of low level disk I/O functions */
;
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
; 0002 002C void mem_set (void* dst, int val, int cnt) {

	.CSEG
; 0002 002D 	char *d = (char*)dst;
; 0002 002E 	while (cnt--) *d++ = (char)val;
;	*dst -> Y+6
;	val -> Y+4
;	cnt -> Y+2
;	*d -> R16,R17
; 0002 002F }
;
;/* Compare memory to memory */
;static
;int mem_cmp (const void* dst, const void* src, int cnt) {
; 0002 0033 int mem_cmp (const void* dst, const void* src, int cnt) {
; 0002 0034 	const char *d = (const char *)dst, *s = (const char *)src;
; 0002 0035 	int r = 0;
; 0002 0036 	while (cnt-- && (r = *d++ - *s++) == 0) ;
;	*dst -> Y+10
;	*src -> Y+8
;	cnt -> Y+6
;	*d -> R16,R17
;	*s -> R18,R19
;	r -> R20,R21
; 0002 0037 	return r;
; 0002 0038 }
;
;
;
;/*-----------------------------------------------------------------------*/
;/* FAT access - Read value of a FAT entry                                */
;/*-----------------------------------------------------------------------*/
;
;static
;CLUST get_fat (	/* 1:IO error, Else:Cluster status */
; 0002 0042 	CLUST clst	/* Cluster# to get the link information */
; 0002 0043 )
; 0002 0044 {
; 0002 0045 	WORD wc, bc, ofs;
; 0002 0046 	BYTE buf[4];
; 0002 0047 	FATFS *fs = FatFs;
; 0002 0048 
; 0002 0049 
; 0002 004A 	if (clst < 2 || clst >= fs->max_clust)	/* Range check */
;	clst -> Y+12
;	wc -> R16,R17
;	bc -> R18,R19
;	ofs -> R20,R21
;	buf -> Y+8
;	*fs -> Y+6
; 0002 004B 		return 1;
; 0002 004C 
; 0002 004D 	switch (fs->fs_type) {
; 0002 004E 	case FS_FAT12 :
; 0002 004F 		bc = (WORD)clst; bc += bc / 2;
; 0002 0050 		ofs = bc % 512; bc /= 512;
; 0002 0051 		if (ofs != 511) {
; 0002 0052 			if (disk_readp(buf, fs->fatbase + bc, ofs, 2)) break;
; 0002 0053 		} else {
; 0002 0054 			if (disk_readp(buf, fs->fatbase + bc, 511, 1)) break;
; 0002 0055 			if (disk_readp(buf+1, fs->fatbase + bc + 1, 0, 1)) break;
; 0002 0056 		}
; 0002 0057 		wc = LD_WORD(buf);
; 0002 0058 		return (clst & 1) ? (wc >> 4) : (wc & 0xFFF);
; 0002 0059 
; 0002 005A 	case FS_FAT16 :
; 0002 005B 		if (disk_readp(buf, fs->fatbase + clst / 256, (WORD)(((WORD)clst % 256) * 2), 2)) break;
; 0002 005C 		return LD_WORD(buf);
; 0002 005D #if _FS_FAT32
; 0002 005E 	case FS_FAT32 :
; 0002 005F 		if (disk_readp(buf, fs->fatbase + clst / 128, (WORD)(((WORD)clst % 128) * 4), 4)) break;
; 0002 0060 		return LD_DWORD(buf) & 0x0FFFFFFF;
; 0002 0061 #endif
; 0002 0062 	}
; 0002 0063 
; 0002 0064 	return 1;	/* An error occured at the disk I/O layer */
; 0002 0065 }
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
; 0002 0070 	CLUST clst		/* Cluster# to be converted */
; 0002 0071 )
; 0002 0072 {
; 0002 0073 	FATFS *fs = FatFs;
; 0002 0074 
; 0002 0075 
; 0002 0076 	clst -= 2;
;	clst -> Y+2
;	*fs -> R16,R17
; 0002 0077 	if (clst >= (fs->max_clust - 2)) return 0;		/* Invalid cluster# */
; 0002 0078 	return (DWORD)clst * fs->csize + fs->database;
; 0002 0079 }
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
; 0002 0084 	DIR *dj			/* Pointer to directory object */
; 0002 0085 )
; 0002 0086 {
; 0002 0087 	CLUST clst;
; 0002 0088 	FATFS *fs = FatFs;
; 0002 0089 
; 0002 008A 
; 0002 008B 	dj->index = 0;
;	*dj -> Y+6
;	clst -> Y+2
;	*fs -> R16,R17
; 0002 008C 	clst = dj->sclust;
; 0002 008D 	if (clst == 1 || clst >= fs->max_clust)	/* Check start cluster range */
; 0002 008E 		return FR_DISK_ERR;
; 0002 008F #if _FS_FAT32
; 0002 0090 	if (!clst && fs->fs_type == FS_FAT32)	/* Replace cluster# 0 with root cluster# if in FAT32 */
; 0002 0091 		clst = fs->dirbase;
; 0002 0092 #endif
; 0002 0093 	dj->clust = clst;						/* Current cluster */
; 0002 0094 	dj->sect = clst ? clust2sect(clst) : fs->dirbase;	/* Current sector */
; 0002 0095 
; 0002 0096 	return FR_OK;	/* Seek succeeded */
; 0002 0097 }
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
; 0002 00A2 	DIR *dj			/* Pointer to directory object */
; 0002 00A3 )
; 0002 00A4 {
; 0002 00A5 	CLUST clst;
; 0002 00A6 	WORD i;
; 0002 00A7 	FATFS *fs = FatFs;
; 0002 00A8 
; 0002 00A9 
; 0002 00AA 	i = dj->index + 1;
;	*dj -> Y+8
;	clst -> Y+4
;	i -> R16,R17
;	*fs -> R18,R19
; 0002 00AB 	if (!i || !dj->sect)	/* Report EOT when index has reached 65535 */
; 0002 00AC 		return FR_NO_FILE;
; 0002 00AD 
; 0002 00AE 	if (!(i & (16-1))) {	/* Sector changed? */
; 0002 00AF 		dj->sect++;			/* Next sector */
; 0002 00B0 
; 0002 00B1 		if (dj->clust == 0) {	/* Static table */
; 0002 00B2 			if (i >= fs->n_rootdir)	/* Report EOT when end of table */
; 0002 00B3 				return FR_NO_FILE;
; 0002 00B4 		}
; 0002 00B5 		else {					/* Dynamic table */
; 0002 00B6 			if (((i / 16) & (fs->csize-1)) == 0) {	/* Cluster changed? */
; 0002 00B7 				clst = get_fat(dj->clust);		/* Get next cluster */
; 0002 00B8 				if (clst <= 1) return FR_DISK_ERR;
; 0002 00B9 				if (clst >= fs->max_clust)		/* When it reached end of dynamic table */
; 0002 00BA 					return FR_NO_FILE;			/* Report EOT */
; 0002 00BB 				dj->clust = clst;				/* Initialize data for new cluster */
; 0002 00BC 				dj->sect = clust2sect(clst);
; 0002 00BD 			}
; 0002 00BE 		}
; 0002 00BF 	}
; 0002 00C0 
; 0002 00C1 	dj->index = i;
; 0002 00C2 
; 0002 00C3 	return FR_OK;
; 0002 00C4 }
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
; 0002 00CF 	DIR *dj			/* Pointer to the directory object linked to the file name */
; 0002 00D0 )
; 0002 00D1 {
; 0002 00D2 	FRESULT res;
; 0002 00D3 	BYTE c, *dir;
; 0002 00D4 
; 0002 00D5 
; 0002 00D6 	res = dir_rewind(dj);			/* Rewind directory object */
;	*dj -> Y+4
;	res -> R17
;	c -> R16
;	*dir -> R18,R19
; 0002 00D7 	if (res != FR_OK) return res;
; 0002 00D8 
; 0002 00D9 	dir = FatFs->buf;
; 0002 00DA 	do {
; 0002 00DB 		res = disk_readp(dir, dj->sect, (WORD)((dj->index % 16) * 32), 32)	/* Read an entry */
; 0002 00DC 			? FR_DISK_ERR : FR_OK;
; 0002 00DD 		if (res != FR_OK) break;
; 0002 00DE 		c = dir[DIR_Name];	/* First character */
; 0002 00DF 		if (c == 0) { res = FR_NO_FILE; break; }	/* Reached to end of table */
; 0002 00E0 		if (!(dir[DIR_Attr] & AM_VOL) && !mem_cmp(dir, dj->fn, 11)) /* Is it a valid entry? */
; 0002 00E1 			break;
; 0002 00E2 		res = dir_next(dj);							/* Next entry */
; 0002 00E3 	} while (res == FR_OK);
; 0002 00E4 
; 0002 00E5 	return res;
; 0002 00E6 }
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
; 0002 00F1 	DIR *dj			/* Pointer to the directory object to store read object name */
; 0002 00F2 )
; 0002 00F3 {
; 0002 00F4 	FRESULT res;
; 0002 00F5 	BYTE a, c, *dir;
; 0002 00F6 
; 0002 00F7 
; 0002 00F8 	res = FR_NO_FILE;
;	*dj -> Y+6
;	res -> R17
;	a -> R16
;	c -> R19
;	*dir -> R20,R21
; 0002 00F9 	dir = FatFs->buf;
; 0002 00FA 	while (dj->sect) {
; 0002 00FB 		res = disk_readp(dir, dj->sect, (WORD)((dj->index % 16) * 32), 32)	/* Read an entry */
; 0002 00FC 			? FR_DISK_ERR : FR_OK;
; 0002 00FD 		if (res != FR_OK) break;
; 0002 00FE 		c = dir[DIR_Name];
; 0002 00FF 		if (c == 0) { res = FR_NO_FILE; break; }	/* Reached to end of table */
; 0002 0100 		a = dir[DIR_Attr] & AM_MASK;
; 0002 0101 		if (c != 0xE5 && c != '.' && !(a & AM_VOL))	/* Is it a valid entry? */
; 0002 0102 			break;
; 0002 0103 		res = dir_next(dj);				/* Next entry */
; 0002 0104 		if (res != FR_OK) break;
; 0002 0105 	}
; 0002 0106 
; 0002 0107 	if (res != FR_OK) dj->sect = 0;
; 0002 0108 
; 0002 0109 	return res;
; 0002 010A }
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
; 0002 0119 	DIR *dj,			/* Pointer to the directory object */
; 0002 011A 	const char **path	/* Pointer to pointer to the segment in the path string */
; 0002 011B )
; 0002 011C {
; 0002 011D 	BYTE c, d, ni, si, i, *sfn;
; 0002 011E 	const char *p;
; 0002 011F 
; 0002 0120 	/* Create file name in directory form */
; 0002 0121 	sfn = dj->fn;
;	*dj -> Y+12
;	*path -> Y+10
;	c -> R17
;	d -> R16
;	ni -> R19
;	si -> R18
;	i -> R21
;	*sfn -> Y+8
;	*p -> Y+6
; 0002 0122 	mem_set(sfn, ' ', 11);
; 0002 0123 	si = i = 0; ni = 8;
; 0002 0124 	p = *path;
; 0002 0125 	for (;;) {
; 0002 0126 		c = p[si++];
; 0002 0127 		if (c <= ' ' || c == '/') break;	/* Break on end of segment */
; 0002 0128 		if (c == '.' || i >= ni) {
; 0002 0129 			if (ni != 8 || c != '.') break;
; 0002 012A 			i = 8; ni = 11;
; 0002 012B 			continue;
; 0002 012C 		}
; 0002 012D #ifdef _EXCVT
; 0002 012E 		if (c >= 0x80)					/* To upper extended char (SBCS) */
; 0002 012F 			c = cvt[c - 0x80];
; 0002 0130 #endif
; 0002 0131 		if (IsDBCS1(c) && i >= ni - 1) {	/* DBC 1st byte? */
; 0002 0132 			d = p[si++];					/* Get 2nd byte */
; 0002 0133 			sfn[i++] = c;
; 0002 0134 			sfn[i++] = d;
; 0002 0135 		} else {						/* Single byte code */
; 0002 0136 			if (IsLower(c)) c -= 0x20;	/* toupper */
; 0002 0137 			sfn[i++] = c;
; 0002 0138 		}
; 0002 0139 	}
; 0002 013A 	*path = &p[si];						/* Rerurn pointer to the next segment */
; 0002 013B 
; 0002 013C 	sfn[11] = (c <= ' ') ? 1 : 0;		/* Set last segment flag if end of path */
; 0002 013D 
; 0002 013E 	return FR_OK;
; 0002 013F }
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
; 0002 014A 	DIR *dj,			/* Pointer to the directory object */
; 0002 014B 	FILINFO *fno	 	/* Pointer to store the file information */
; 0002 014C )
; 0002 014D {
; 0002 014E 	BYTE i, c, *dir;
; 0002 014F 	char *p;
; 0002 0150 
; 0002 0151 
; 0002 0152 	p = fno->fname;
;	*dj -> Y+8
;	*fno -> Y+6
;	i -> R17
;	c -> R16
;	*dir -> R18,R19
;	*p -> R20,R21
; 0002 0153 	if (dj->sect) {
; 0002 0154 		dir = FatFs->buf;
; 0002 0155 		for (i = 0; i < 8; i++) {	/* Copy file name body */
; 0002 0156 			c = dir[i];
; 0002 0157 			if (c == ' ') break;
; 0002 0158 			if (c == 0x05) c = 0xE5;
; 0002 0159 			*p++ = c;
; 0002 015A 		}
; 0002 015B 		if (dir[8] != ' ') {		/* Copy file name extension */
; 0002 015C 			*p++ = '.';
; 0002 015D 			for (i = 8; i < 11; i++) {
; 0002 015E 				c = dir[i];
; 0002 015F 				if (c == ' ') break;
; 0002 0160 				*p++ = c;
; 0002 0161 			}
; 0002 0162 		}
; 0002 0163 		fno->fattrib = dir[DIR_Attr];				/* Attribute */
; 0002 0164 		fno->fsize = LD_DWORD(dir+DIR_FileSize);	/* Size */
; 0002 0165 		fno->fdate = LD_WORD(dir+DIR_WrtDate);		/* Date */
; 0002 0166 		fno->ftime = LD_WORD(dir+DIR_WrtTime);		/* Time */
; 0002 0167 	}
; 0002 0168 	*p = 0;
; 0002 0169 }
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
; 0002 0174 	DIR *dj,			/* Directory object to return last directory and found object */
; 0002 0175 	const char *path	/* Full-path string to find a file or directory */
; 0002 0176 )
; 0002 0177 {
; 0002 0178 	FRESULT res;
; 0002 0179 	BYTE *dir;
; 0002 017A 
; 0002 017B 
; 0002 017C 	while (*path == ' ') path++;		/* Skip leading spaces */
;	*dj -> Y+6
;	*path -> Y+4
;	res -> R17
;	*dir -> R18,R19
; 0002 017D if (*path == '/') path++;
; 0002 017E 	dj->sclust = 0;						/* Set start directory (always root dir) */
; 0002 017F 
; 0002 0180 	if ((BYTE)*path <= ' ') {			/* Null path means the root directory */
; 0002 0181 		res = dir_rewind(dj);
; 0002 0182 		FatFs->buf[0] = 0;
; 0002 0183 
; 0002 0184 	} else {							/* Follow path */
; 0002 0185 		for (;;) {
; 0002 0186 			res = create_name(dj, &path);	/* Get a segment */
; 0002 0187 			if (res != FR_OK) break;
; 0002 0188 			res = dir_find(dj);				/* Find it */
; 0002 0189 			if (res != FR_OK) {				/* Could not find the object */
; 0002 018A 				if (res == FR_NO_FILE && !*(dj->fn+11))
; 0002 018B 					res = FR_NO_PATH;
; 0002 018C 				break;
; 0002 018D 			}
; 0002 018E 			if (*(dj->fn+11)) break;		/* Last segment match. Function completed. */
; 0002 018F 			dir = FatFs->buf;				/* There is next segment. Follow the sub directory */
; 0002 0190 			if (!(dir[DIR_Attr] & AM_DIR)) { /* Cannot follow because it is a file */
; 0002 0191 				res = FR_NO_PATH; break;
; 0002 0192 			}
; 0002 0193 			dj->sclust =
; 0002 0194 #if _FS_FAT32
; 0002 0195 				((DWORD)LD_WORD(dir+DIR_FstClusHI) << 16) |
; 0002 0196 #endif
; 0002 0197 				LD_WORD(dir+DIR_FstClusLO);
; 0002 0198 		}
; 0002 0199 	}
; 0002 019A 
; 0002 019B 	return res;
; 0002 019C }
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
; 0002 01A7 	BYTE *buf,	/* Working buffer */
; 0002 01A8 	DWORD sect	/* Sector# (lba) to check if it is an FAT boot record or not */
; 0002 01A9 )
; 0002 01AA {
; 0002 01AB 	if (disk_readp(buf, sect, 510, 2))		/* Read the boot sector */
;	*buf -> Y+4
;	sect -> Y+0
; 0002 01AC 		return 3;
; 0002 01AD 	if (LD_WORD(buf) != 0xAA55)				/* Check record signature */
; 0002 01AE 		return 2;
; 0002 01AF 
; 0002 01B0 	if (!disk_readp(buf, sect, BS_FilSysType, 2) && LD_WORD(buf) == 0x4146)	/* Check FAT12/16 */
; 0002 01B1 		return 0;
; 0002 01B2 #if _FS_FAT32
; 0002 01B3 	if (!disk_readp(buf, sect, BS_FilSysType32, 2) && LD_WORD(buf) == 0x4146)	/* Check FAT32 */
; 0002 01B4 		return 0;
; 0002 01B5 #endif
; 0002 01B6 	return 1;
; 0002 01B7 }
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
; 0002 01C9 	FATFS *fs		/* Pointer to new file system object (NULL: Unmount) */
; 0002 01CA )
; 0002 01CB {
; 0002 01CC 	BYTE fmt, buf[36];
; 0002 01CD 	DWORD bsect, fsize, tsect, mclst;
; 0002 01CE 
; 0002 01CF 
; 0002 01D0 	FatFs = 0;
;	*fs -> Y+53
;	fmt -> R17
;	buf -> Y+17
;	bsect -> Y+13
;	fsize -> Y+9
;	tsect -> Y+5
;	mclst -> Y+1
; 0002 01D1 	if (!fs) return FR_OK;				/* Unregister fs object */
; 0002 01D2 
; 0002 01D3 	if (disk_initialize() & STA_NOINIT)	/* Check if the drive is ready or not */
; 0002 01D4 		return FR_NOT_READY;
; 0002 01D5 
; 0002 01D6 	/* Search FAT partition on the drive */
; 0002 01D7 	bsect = 0;
; 0002 01D8 	fmt = check_fs(buf, bsect);			/* Check sector 0 as an SFD format */
; 0002 01D9 	if (fmt == 1) {						/* Not an FAT boot record, it may be FDISK format */
; 0002 01DA 		/* Check a partition listed in top of the partition table */
; 0002 01DB 		if (disk_readp(buf, bsect, MBR_Table, 16)) {	/* 1st partition entry */
; 0002 01DC 			fmt = 3;
; 0002 01DD 		} else {
; 0002 01DE 			if (buf[4]) {					/* Is the partition existing? */
; 0002 01DF 				bsect = LD_DWORD(&buf[8]);	/* Partition offset in LBA */
; 0002 01E0 				fmt = check_fs(buf, bsect);	/* Check the partition */
; 0002 01E1 			}
; 0002 01E2 		}
; 0002 01E3 	}
; 0002 01E4 	if (fmt == 3) return FR_DISK_ERR;
; 0002 01E5 	if (fmt) return FR_NO_FILESYSTEM;	/* No valid FAT patition is found */
; 0002 01E6 
; 0002 01E7 	/* Initialize the file system object */
; 0002 01E8 	if (disk_readp(buf, bsect, 13, sizeof(buf))) return FR_DISK_ERR;
; 0002 01E9 
; 0002 01EA 	fsize = LD_WORD(buf+BPB_FATSz16-13);				/* Number of sectors per FAT */
; 0002 01EB 	if (!fsize) fsize = LD_DWORD(buf+BPB_FATSz32-13);
; 0002 01EC 
; 0002 01ED 	fsize *= buf[BPB_NumFATs-13];						/* Number of sectors in FAT area */
; 0002 01EE 	fs->fatbase = bsect + LD_WORD(buf+BPB_RsvdSecCnt-13); /* FAT start sector (lba) */
; 0002 01EF 	fs->csize = buf[BPB_SecPerClus-13];					/* Number of sectors per cluster */
; 0002 01F0 	fs->n_rootdir = LD_WORD(buf+BPB_RootEntCnt-13);		/* Nmuber of root directory entries */
; 0002 01F1 	tsect = LD_WORD(buf+BPB_TotSec16-13);				/* Number of sectors on the file system */
; 0002 01F2 	if (!tsect) tsect = LD_DWORD(buf+BPB_TotSec32-13);
; 0002 01F3 	mclst = (tsect						/* Last cluster# + 1 */
; 0002 01F4 		- LD_WORD(buf+BPB_RsvdSecCnt-13) - fsize - fs->n_rootdir / 16
; 0002 01F5 		) / fs->csize + 2;
; 0002 01F6 	fs->max_clust = (CLUST)mclst;
; 0002 01F7 
; 0002 01F8 	fmt = FS_FAT12;							/* Determine the FAT sub type */
; 0002 01F9 	if (mclst >= 0xFF7) fmt = FS_FAT16;		/* Number of clusters >= 0xFF5 */
; 0002 01FA 	if (mclst >= 0xFFF7)					/* Number of clusters >= 0xFFF5 */
; 0002 01FB #if _FS_FAT32
; 0002 01FC 		fmt = FS_FAT32;
; 0002 01FD #else
; 0002 01FE 		return FR_NO_FILESYSTEM;
; 0002 01FF #endif
; 0002 0200 
; 0002 0201 	fs->fs_type = fmt;		/* FAT sub-type */
; 0002 0202 #if _FS_FAT32
; 0002 0203 	if (fmt == FS_FAT32)
; 0002 0204 		fs->dirbase = LD_DWORD(buf+(BPB_RootClus-13));	/* Root directory start cluster */
; 0002 0205 	else
; 0002 0206 #endif
; 0002 0207 		fs->dirbase = fs->fatbase + fsize;				/* Root directory start sector (lba) */
; 0002 0208 	fs->database = fs->fatbase + fsize + fs->n_rootdir / 16;	/* Data start sector (lba) */
; 0002 0209 
; 0002 020A 	fs->flag = 0;
; 0002 020B 	FatFs = fs;
; 0002 020C 
; 0002 020D 	return FR_OK;
; 0002 020E }
;
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Open or Create a File                                                 */
;/*-----------------------------------------------------------------------*/
;
;FRESULT pf_open (
; 0002 0218 	const char *path	/* Pointer to the file name */
; 0002 0219 )
; 0002 021A {
; 0002 021B 	FRESULT res;
; 0002 021C 	DIR dj;
; 0002 021D 	BYTE sp[12], dir[32];
; 0002 021E 	FATFS *fs = FatFs;
; 0002 021F 
; 0002 0220 
; 0002 0221 	if (!fs)						/* Check file system */
;	*path -> Y+64
;	res -> R17
;	dj -> Y+48
;	sp -> Y+36
;	dir -> Y+4
;	*fs -> R18,R19
; 0002 0222 		return FR_NOT_ENABLED;
; 0002 0223 
; 0002 0224 	fs->flag = 0;
; 0002 0225 	fs->buf = dir;
; 0002 0226 	dj.fn = sp;
; 0002 0227 	res = follow_path(&dj, path);	/* Follow the file path */
; 0002 0228 	if (res != FR_OK) return res;	/* Follow failed */
; 0002 0229 	if (!dir[0] || (dir[DIR_Attr] & AM_DIR))	/* It is a directory */
; 0002 022A 		return FR_NO_FILE;
; 0002 022B 
; 0002 022C 	fs->org_clust =						/* File start cluster */
; 0002 022D #if _FS_FAT32
; 0002 022E 		((DWORD)LD_WORD(dir+DIR_FstClusHI) << 16) |
; 0002 022F #endif
; 0002 0230 		LD_WORD(dir+DIR_FstClusLO);
; 0002 0231 	fs->fsize = LD_DWORD(dir+DIR_FileSize);	/* File size */
; 0002 0232 	fs->fptr = 0;						/* File pointer */
; 0002 0233 	fs->flag = FA_OPENED;
; 0002 0234 
; 0002 0235 	return FR_OK;
; 0002 0236 }
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
; 0002 0241 	void* buff,		/* Pointer to the read buffer (NULL:Forward data to the stream)*/
; 0002 0242 	WORD btr,		/* Number of bytes to read */
; 0002 0243 	WORD* br		/* Pointer to number of bytes read */
; 0002 0244 )
; 0002 0245 {
; 0002 0246 	DRESULT dr;
; 0002 0247 	CLUST clst;
; 0002 0248 	DWORD sect, remain;
; 0002 0249 	BYTE *rbuff = buff;
; 0002 024A 	WORD rcnt;
; 0002 024B 	FATFS *fs = FatFs;
; 0002 024C 
; 0002 024D 
; 0002 024E 	*br = 0;
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
; 0002 024F 	if (!fs) return FR_NOT_ENABLED;		/* Check file system */
; 0002 0250 	if (!(fs->flag & FA_OPENED))		/* Check if opened */
; 0002 0251 		return FR_NOT_OPENED;
; 0002 0252 
; 0002 0253 	remain = fs->fsize - fs->fptr;
; 0002 0254 	if (btr > remain) btr = (WORD)remain;			/* Truncate btr by remaining bytes */
; 0002 0255 
; 0002 0256 	while (btr)	{									/* Repeat until all data transferred */
; 0002 0257 		if ((fs->fptr % 512) == 0) {				/* On the sector boundary? */
; 0002 0258 			if ((fs->fptr / 512 % fs->csize) == 0) {	/* On the cluster boundary? */
; 0002 0259 				clst = (fs->fptr == 0) ?			/* On the top of the file? */
; 0002 025A 					fs->org_clust : get_fat(fs->curr_clust);
; 0002 025B 				if (clst <= 1) goto fr_abort;
; 0002 025C 				fs->curr_clust = clst;				/* Update current cluster */
; 0002 025D 				fs->csect = 0;						/* Reset sector offset in the cluster */
; 0002 025E 			}
; 0002 025F 			sect = clust2sect(fs->curr_clust);		/* Get current sector */
; 0002 0260 			if (!sect) goto fr_abort;
; 0002 0261 			fs->dsect = sect + fs->csect++;
; 0002 0262 		}
; 0002 0263 		rcnt = 512 - ((WORD)fs->fptr % 512);		/* Get partial sector data from sector buffer */
; 0002 0264 		if (rcnt > btr) rcnt = btr;
; 0002 0265 		dr = disk_readp(!buff ? 0 : rbuff, fs->dsect, (WORD)(fs->fptr % 512), rcnt);
; 0002 0266 		if (dr) goto fr_abort;
; 0002 0267 		fs->fptr += rcnt; rbuff += rcnt;			/* Update pointers and counters */
; 0002 0268 		btr -= rcnt; *br += rcnt;
; 0002 0269 	}
; 0002 026A 
; 0002 026B 	return FR_OK;
; 0002 026C 
; 0002 026D fr_abort:
; 0002 026E 	fs->flag = 0;
; 0002 026F 	return FR_DISK_ERR;
; 0002 0270 }
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
; 0002 027B 	const void* buff,	/* Pointer to the data to be written */
; 0002 027C 	WORD btw,			/* Number of bytes to write (0:Finalize the current write operation) */
; 0002 027D 	WORD* bw			/* Pointer to number of bytes written */
; 0002 027E )
; 0002 027F {
; 0002 0280 	CLUST clst;
; 0002 0281 	DWORD sect, remain;
; 0002 0282 	const BYTE *p = buff;
; 0002 0283 	WORD wcnt;
; 0002 0284 	FATFS *fs = FatFs;
; 0002 0285 
; 0002 0286 
; 0002 0287 	*bw = 0;
;	*buff -> Y+22
;	btw -> Y+20
;	*bw -> Y+18
;	clst -> Y+14
;	sect -> Y+10
;	remain -> Y+6
;	*p -> R16,R17
;	wcnt -> R18,R19
;	*fs -> R20,R21
; 0002 0288 	if (!fs) return FR_NOT_ENABLED;		/* Check file system */
; 0002 0289 	if (!(fs->flag & FA_OPENED))		/* Check if opened */
; 0002 028A 		return FR_NOT_OPENED;
; 0002 028B 
; 0002 028C 	if (!btw) {		/* Finalize request */
; 0002 028D 		if ((fs->flag & FA__WIP) && disk_writep(0, 0)) goto fw_abort;
; 0002 028E 		fs->flag &= ~FA__WIP;
; 0002 028F 		return FR_OK;
; 0002 0290 	} else {		/* Write data request */
; 0002 0291 		if (!(fs->flag & FA__WIP))		/* Round down fptr to the sector boundary */
; 0002 0292 			fs->fptr &= 0xFFFFFE00;
; 0002 0293 	}
; 0002 0294 	remain = fs->fsize - fs->fptr;
; 0002 0295 	if (btw > remain) btw = (WORD)remain;			/* Truncate btw by remaining bytes */
; 0002 0296 
; 0002 0297 	while (btw)	{									/* Repeat until all data transferred */
; 0002 0298 		if (((WORD)fs->fptr % 512) == 0) {				/* On the sector boundary? */
; 0002 0299 			if ((fs->fptr / 512 % fs->csize) == 0) {	/* On the cluster boundary? */
; 0002 029A 				clst = (fs->fptr == 0) ?			/* On the top of the file? */
; 0002 029B 					fs->org_clust : get_fat(fs->curr_clust);
; 0002 029C 				if (clst <= 1) goto fw_abort;
; 0002 029D 				fs->curr_clust = clst;				/* Update current cluster */
; 0002 029E 				fs->csect = 0;						/* Reset sector offset in the cluster */
; 0002 029F 			}
; 0002 02A0 			sect = clust2sect(fs->curr_clust);		/* Get current sector */
; 0002 02A1 			if (!sect) goto fw_abort;
; 0002 02A2 			fs->dsect = sect + fs->csect++;
; 0002 02A3 			if (disk_writep(0, fs->dsect)) goto fw_abort;	/* Initiate a sector write operation */
; 0002 02A4 			fs->flag |= FA__WIP;
; 0002 02A5 		}
; 0002 02A6 		wcnt = 512 - ((WORD)fs->fptr % 512);		/* Number of bytes to write to the sector */
; 0002 02A7 		if (wcnt > btw) wcnt = btw;
; 0002 02A8 		if (disk_writep(p, wcnt)) goto fw_abort;	/* Send data to the sector */
; 0002 02A9 		fs->fptr += wcnt; p += wcnt;				/* Update pointers and counters */
; 0002 02AA 		btw -= wcnt; *bw += wcnt;
; 0002 02AB 		if (((WORD)fs->fptr % 512) == 0) {
; 0002 02AC 			if (disk_writep(0, 0)) goto fw_abort;	/* Finalize the currtent secter write operation */
; 0002 02AD 			fs->flag &= ~FA__WIP;
; 0002 02AE 		}
; 0002 02AF 	}
; 0002 02B0 
; 0002 02B1 	return FR_OK;
; 0002 02B2 
; 0002 02B3 fw_abort:
; 0002 02B4 	fs->flag = 0;
; 0002 02B5 	return FR_DISK_ERR;
; 0002 02B6 }
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
; 0002 02C1 	DWORD ofs		/* File pointer from top of file */
; 0002 02C2 )
; 0002 02C3 {
; 0002 02C4 	CLUST clst;
; 0002 02C5 	DWORD bcs, sect, ifptr;
; 0002 02C6 	FATFS *fs = FatFs;
; 0002 02C7 
; 0002 02C8 
; 0002 02C9 	if (!fs) return FR_NOT_ENABLED;		/* Check file system */
;	ofs -> Y+18
;	clst -> Y+14
;	bcs -> Y+10
;	sect -> Y+6
;	ifptr -> Y+2
;	*fs -> R16,R17
; 0002 02CA 	if (!(fs->flag & FA_OPENED))		/* Check if opened */
; 0002 02CB 			return FR_NOT_OPENED;
; 0002 02CC 
; 0002 02CD 	if (ofs > fs->fsize) ofs = fs->fsize;	/* Clip offset with the file size */
; 0002 02CE 	ifptr = fs->fptr;
; 0002 02CF 	fs->fptr = 0;
; 0002 02D0 	if (ofs > 0) {
; 0002 02D1 		bcs = (DWORD)fs->csize * 512;	/* Cluster size (byte) */
; 0002 02D2 		if (ifptr > 0 &&
; 0002 02D3 			(ofs - 1) / bcs >= (ifptr - 1) / bcs) {	/* When seek to same or following cluster, */
; 0002 02D4 			fs->fptr = (ifptr - 1) & ~(bcs - 1);	/* start from the current cluster */
; 0002 02D5 			ofs -= fs->fptr;
; 0002 02D6 			clst = fs->curr_clust;
; 0002 02D7 		} else {							/* When seek to back cluster, */
; 0002 02D8 			clst = fs->org_clust;			/* start from the first cluster */
; 0002 02D9 			fs->curr_clust = clst;
; 0002 02DA 		}
; 0002 02DB 		while (ofs > bcs) {				/* Cluster following loop */
; 0002 02DC 			clst = get_fat(clst);		/* Follow cluster chain */
; 0002 02DD 			if (clst <= 1 || clst >= fs->max_clust) goto fe_abort;
; 0002 02DE 			fs->curr_clust = clst;
; 0002 02DF 			fs->fptr += bcs;
; 0002 02E0 			ofs -= bcs;
; 0002 02E1 		}
; 0002 02E2 		fs->fptr += ofs;
; 0002 02E3 		sect = clust2sect(clst);		/* Current sector */
; 0002 02E4 		if (!sect) goto fe_abort;
; 0002 02E5 		fs->csect = (BYTE)(ofs / 512);	/* Sector offset in the cluster */
; 0002 02E6 		if (ofs % 512)
; 0002 02E7 			fs->dsect = sect + fs->csect++;
; 0002 02E8 	}
; 0002 02E9 
; 0002 02EA 	return FR_OK;
; 0002 02EB 
; 0002 02EC fe_abort:
; 0002 02ED 	fs->flag = 0;
; 0002 02EE 	return FR_DISK_ERR;
; 0002 02EF }
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
; 0002 02FA 	DIR *dj,			/* Pointer to directory object to create */
; 0002 02FB 	const char *path	/* Pointer to the directory path */
; 0002 02FC )
; 0002 02FD {
; 0002 02FE 	FRESULT res;
; 0002 02FF 	BYTE sp[12], dir[32];
; 0002 0300 	FATFS *fs = FatFs;
; 0002 0301 
; 0002 0302 
; 0002 0303 	if (!fs) {				/* Check file system */
;	*dj -> Y+50
;	*path -> Y+48
;	res -> R17
;	sp -> Y+36
;	dir -> Y+4
;	*fs -> R18,R19
; 0002 0304 		res = FR_NOT_ENABLED;
; 0002 0305 	} else {
; 0002 0306 		fs->buf = dir;
; 0002 0307 		dj->fn = sp;
; 0002 0308 		res = follow_path(dj, path);			/* Follow the path to the directory */
; 0002 0309 		if (res == FR_OK) {						/* Follow completed */
; 0002 030A 			if (dir[0]) {						/* It is not the root dir */
; 0002 030B 				if (dir[DIR_Attr] & AM_DIR) {	/* The object is a directory */
; 0002 030C 					dj->sclust =
; 0002 030D #if _FS_FAT32
; 0002 030E 					((DWORD)LD_WORD(dir+DIR_FstClusHI) << 16) |
; 0002 030F #endif
; 0002 0310 					LD_WORD(dir+DIR_FstClusLO);
; 0002 0311 				} else {						/* The object is not a directory */
; 0002 0312 					res = FR_NO_PATH;
; 0002 0313 				}
; 0002 0314 			}
; 0002 0315 			if (res == FR_OK)
; 0002 0316 				res = dir_rewind(dj);			/* Rewind dir */
; 0002 0317 		}
; 0002 0318 		if (res == FR_NO_FILE) res = FR_NO_PATH;
; 0002 0319 	}
; 0002 031A 
; 0002 031B 	return res;
; 0002 031C }
;
;
;
;
;/*-----------------------------------------------------------------------*/
;/* Read Directory Entry in Sequense                                      */
;/*-----------------------------------------------------------------------*/
;
;FRESULT pf_readdir (
; 0002 0326 	DIR *dj,			/* Pointer to the open directory object */
; 0002 0327 	FILINFO *fno		/* Pointer to file information to return */
; 0002 0328 )
; 0002 0329 {
; 0002 032A 	FRESULT res;
; 0002 032B 	BYTE sp[12], dir[32];
; 0002 032C 	FATFS *fs = FatFs;
; 0002 032D 
; 0002 032E 
; 0002 032F 	if (!fs) {				/* Check file system */
;	*dj -> Y+50
;	*fno -> Y+48
;	res -> R17
;	sp -> Y+36
;	dir -> Y+4
;	*fs -> R18,R19
; 0002 0330 		res = FR_NOT_ENABLED;
; 0002 0331 	} else {
; 0002 0332 		fs->buf = dir;
; 0002 0333 		dj->fn = sp;
; 0002 0334 		if (!fno) {
; 0002 0335 			res = dir_rewind(dj);
; 0002 0336 		} else {
; 0002 0337 			res = dir_read(dj);
; 0002 0338 			if (res == FR_NO_FILE) {
; 0002 0339 				dj->sect = 0;
; 0002 033A 				res = FR_OK;
; 0002 033B 			}
; 0002 033C 			if (res == FR_OK) {				/* A valid entry is found */
; 0002 033D 				get_fileinfo(dj, fno);		/* Get the object information */
; 0002 033E 				res = dir_next(dj);			/* Increment index for next */
; 0002 033F 				if (res == FR_NO_FILE) {
; 0002 0340 					dj->sect = 0;
; 0002 0341 					res = FR_OK;
; 0002 0342 				}
; 0002 0343 			}
; 0002 0344 		}
; 0002 0345 	}
; 0002 0346 
; 0002 0347 	return res;
; 0002 0348 }
;
;#endif /* _USE_DIR */
;
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
; 0003 0027 void INIT_SPI(void) {

	.CSEG
; 0003 0028 #ifdef hardware_spi
; 0003 0029 	/*настройка портов ввода-вывода
; 0003 002A 	 все выводы, кроме MISO выходы*/
; 0003 002B 	SPI_DDRX |= (1 << SPI_MOSI) | (1 << SPI_SCK) | (1 << SPI_SS) | (0 << SPI_MISO);
; 0003 002C 	SPI_PORTX |= (1 << SPI_MOSI) | (1 << SPI_SCK) | (1 << SPI_SS) | (1 << SPI_MISO);
; 0003 002D 
; 0003 002E 	/*разрешение spi,старший бит вперед,мастер, режим 0*/
; 0003 002F 	SPCR = (1 << SPE) | (0 << DORD) | (1 << MSTR) | (0 << CPOL) | (0 << CPHA) | (0 << SPR1) | (0 << SPR0);
; 0003 0030 	SPSR = (1 << SPI2X);
; 0003 0031 #else
; 0003 0032 	PORTB |= (1<<SD_CS) | (1<<SD_DO) | (1<<SD_DI)/* | (1<<SD_WP) | (1<<SD_INS)*/;
; 0003 0033 	DDRB |=(1<<SD_CS) | (1<<SD_DI) | (1<<SD_CLK);
; 0003 0034 #endif
; 0003 0035 }
;
;void xmit_spi(BYTE data) {		// Send a byte
; 0003 0037 void xmit_spi(BYTE data) {
; 0003 0038 #ifdef hardware_spi
; 0003 0039 	SPDR = data;
;	data -> Y+0
; 0003 003A 	while (!(SPSR & (1 << SPIF)));
; 0003 003B #else
; 0003 003C 	BYTE i;
; 0003 003D 
; 0003 003E 	for (i = 0; i < 8; i++) {
; 0003 003F 		if ((data & 0x80) == 0x00)
; 0003 0040 			PORTB &= ~(1<<SD_DI);
; 0003 0041 		else
; 0003 0042 			PORTB |= (1<<SD_DI);
; 0003 0043 		data = data << 1;
; 0003 0044 		PORTB |= (1<<SD_CLK);
; 0003 0045 		#asm("nop")
; 0003 0046 		PORTB &= ~(1<<SD_CLK);
; 0003 0047 	}
; 0003 0048 #endif
; 0003 0049 }
;
;BYTE rcv_spi(void) {				// Send 0xFF and receive a byte
; 0003 004B BYTE rcv_spi(void) {
; 0003 004C #ifdef hardware_spi
; 0003 004D 	unsigned char data;
; 0003 004E 	SPDR = 0xFF;
;	data -> R17
; 0003 004F 	while (!(SPSR & (1 << SPIF)));
; 0003 0050 	data = SPDR;
; 0003 0051 	return data;
; 0003 0052 #else
; 0003 0053 	BYTE i, res = 0;
; 0003 0054 
; 0003 0055 	PORTB |= (1<<SD_DI);
; 0003 0056 
; 0003 0057 	for (i = 0; i < 8; i++) {
; 0003 0058 		PORTB |= (1<<SD_CLK);
; 0003 0059 		res = res << 1;
; 0003 005A 		if ((PINB & (1<<SD_DO))!=0x00)
; 0003 005B 		res = res | 0x01;
; 0003 005C 		PORTB &= ~(1<<SD_CLK);
; 0003 005D 		#asm("nop")
; 0003 005E 	}
; 0003 005F 	return res;
; 0003 0060 #endif
; 0003 0061 } /* Send 0xFF and receive a byte */
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
; 0003 0070 {
; 0003 0071 	rcv_spi();
; 0003 0072 }
;
;//-----------------------------------------------------------------------
;// Send a command packet to MMC
;//-----------------------------------------------------------------------
;static
;BYTE send_cmd (
; 0003 0079 	BYTE cmd,		// Command byte
; 0003 007A 	DWORD arg		// Argument
; 0003 007B )
; 0003 007C {
; 0003 007D 	BYTE n, res;
; 0003 007E 
; 0003 007F 
; 0003 0080 	if (cmd & 0x80) {	// ACMD<n> is the command sequense of CMD55-CMD<n>
;	cmd -> Y+6
;	arg -> Y+2
;	n -> R17
;	res -> R16
; 0003 0081 		cmd &= 0x7F;
; 0003 0082 		res = send_cmd(CMD55, 0);
; 0003 0083 		if (res > 1) return res;
; 0003 0084 	}
; 0003 0085 
; 0003 0086 	// Select the card
; 0003 0087 	DESELECT();
; 0003 0088 	rcv_spi();
; 0003 0089 	SELECT();
; 0003 008A 	rcv_spi();
; 0003 008B 
; 0003 008C 	// Send a command packet
; 0003 008D 	xmit_spi(cmd);						// Start + Command index
; 0003 008E 	xmit_spi((BYTE)(arg >> 24));		// Argument[31..24]
; 0003 008F 	xmit_spi((BYTE)(arg >> 16));		// Argument[23..16]
; 0003 0090 	xmit_spi((BYTE)(arg >> 8));			// Argument[15..8]
; 0003 0091 	xmit_spi((BYTE)arg);				// Argument[7..0]
; 0003 0092 	n = 0x01;							// Dummy CRC + Stop
; 0003 0093 	if (cmd == CMD0) n = 0x95;			// Valid CRC for CMD0(0)
; 0003 0094 	if (cmd == CMD8) n = 0x87;			// Valid CRC for CMD8(0x1AA)
; 0003 0095 	xmit_spi(n);
; 0003 0096 
; 0003 0097 	// Receive a command response
; 0003 0098 	n = 10;								// Wait for a valid response in timeout of 10 attempts
; 0003 0099 	do {
; 0003 009A 		res = rcv_spi();
; 0003 009B 	} while ((res & 0x80) && --n);
; 0003 009C 
; 0003 009D 	return res;			// Return with the response value
; 0003 009E }
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
; 0003 00AA {
; 0003 00AB 	BYTE n, cmd, ty, ocr[4];
; 0003 00AC 	WORD tmr;
; 0003 00AD 
; 0003 00AE 
; 0003 00AF 	INIT_SPI();
;	n -> R17
;	cmd -> R16
;	ty -> R19
;	ocr -> Y+6
;	tmr -> R20,R21
; 0003 00B0 
; 0003 00B1 //	if ((PINB&_BV(SD_INS))!=0x00) return STA_NOINIT;
; 0003 00B2 
; 0003 00B3 #if _WRITE_FUNC
; 0003 00B4 	if (MMC_SEL) disk_writep(0, 0);		// Finalize write process if it is in progress
; 0003 00B5 #endif
; 0003 00B6 	for (n = 100; n; n--) rcv_spi();	// Dummy clocks
; 0003 00B8 ty = 0;
; 0003 00B9 	if (send_cmd(CMD0, 0) == 1) {			// Enter Idle state
; 0003 00BA 		if (send_cmd(CMD8, 0x1AA) == 1) {	// SDv2
; 0003 00BB 			for (n = 0; n < 4; n++) ocr[n] = rcv_spi();		// Get trailing return value of R7 resp
; 0003 00BC if (ocr[2] == 0x01 && ocr[3] == 0xAA) {
; 0003 00BD 				for (tmr = 12000; tmr && send_cmd(ACMD41, 1UL << 30); tmr--) ;	// Wait for leaving idle state (ACMD41 with HCS bit)
; 0003 00BE 				if (tmr && send_cmd(CMD58, 0) == 0) {		// Check CCS bit in the OCR
; 0003 00BF 					for (n = 0; n < 4; n++) ocr[n] = rcv_spi();
; 0003 00C0 ty = (ocr[0] & 0x40) ? 0x04	 | 0x08	 : 0x04	;
; 0003 00C1 				}
; 0003 00C2 			}
; 0003 00C3 		} else {							// SDv1 or MMCv3
; 0003 00C4 			if (send_cmd(ACMD41, 0) <= 1) 	{
; 0003 00C5 				ty = CT_SD1; cmd = ACMD41;	// SDv1
; 0003 00C6 			} else {
; 0003 00C7 				ty = CT_MMC; cmd = CMD1;	// MMCv3
; 0003 00C8 			}
; 0003 00C9 			for (tmr = 25000; tmr && send_cmd(cmd, 0); tmr--) ;	// Wait for leaving idle state
; 0003 00CA 			if (!tmr || send_cmd(CMD16, 512) != 0)			// Set R/W block length to 512
; 0003 00CB 				ty = 0;
; 0003 00CC 		}
; 0003 00CD 	}
; 0003 00CE 	CardType = ty;
; 0003 00CF 	release_spi();
; 0003 00D0 
; 0003 00D1 #ifdef hardware_spi
; 0003 00D2 	//для аппаратного SPI!!!--------------------------------------------
; 0003 00D3 	SPCR &= ~((1 << SPR1) | (1 << SPR0)); // убираем предделитель
; 0003 00D4 	SPSR |= (1 << SPI2X); // удваиваем частоту
; 0003 00D5 	//------------------------------------------------------------------
; 0003 00D6 #endif
; 0003 00D7 
; 0003 00D8 	return ty ? 0 : STA_NOINIT;
; 0003 00D9 }
;//-----------------------------------------------------------------------
;// Read partial sector
;//-----------------------------------------------------------------------
;
;DRESULT disk_readp (
; 0003 00DF 	BYTE *buff,		// Pointer to the read buffer (NULL:Read bytes are forwarded to the stream)
; 0003 00E0 	DWORD lba,		// Sector number (LBA)
; 0003 00E1 	WORD ofs,		// Byte offset to read from (0..511)
; 0003 00E2 	WORD cnt		// Number of bytes to read (ofs + cnt mus be <= 512)
; 0003 00E3 )
; 0003 00E4 {
; 0003 00E5 	DRESULT res;
; 0003 00E6 	BYTE rc;
; 0003 00E7 	WORD bc;
; 0003 00E8 
; 0003 00E9 //	if ((PINB&_BV(SD_INS))!=0x00) return RES_ERROR;
; 0003 00EA 
; 0003 00EB 	if (!(CardType & CT_BLOCK)) lba *= 512;		// Convert to byte address if needed
;	*buff -> Y+12
;	lba -> Y+8
;	ofs -> Y+6
;	cnt -> Y+4
;	res -> R17
;	rc -> R16
;	bc -> R18,R19
; 0003 00EC 
; 0003 00ED 	res = RES_ERROR;
; 0003 00EE 	if (send_cmd(CMD17, lba) == 0) {		// READ_SINGLE_BLOCK
; 0003 00EF 
; 0003 00F0 		bc = 30000;
; 0003 00F1 		do {							// Wait for data packet in timeout of 100ms
; 0003 00F2 			rc = rcv_spi();
; 0003 00F3 		} while (rc == 0xFF && --bc);
; 0003 00F4 
; 0003 00F5 		if (rc == 0xFE) {				// A data packet arrived
; 0003 00F6 			bc = 514 - ofs - cnt;
; 0003 00F7 
; 0003 00F8 			// Skip leading bytes
; 0003 00F9 			if (ofs) {
; 0003 00FA 				do rcv_spi(); while (--ofs);
; 0003 00FB 			}
; 0003 00FC 
; 0003 00FD 			// Receive a part of the sector
; 0003 00FE 			if (buff) {	// Store data to the memory
; 0003 00FF 				do
; 0003 0100 					*buff++ = rcv_spi();
; 0003 0101 				while (--cnt);
; 0003 0102 			} else {	// Forward data to the outgoing stream (depends on the project)
; 0003 0103 				do
; 0003 0104                 ;//uart_transmit(rcv_spi());		// (Console output)
; 0003 0105 				while (--cnt);
; 0003 0106 			}
; 0003 0107 
; 0003 0108 			// Skip trailing bytes and CRC
; 0003 0109 			do rcv_spi(); while (--bc);
; 0003 010A 
; 0003 010B 			res = RES_OK;
; 0003 010C 		}
; 0003 010D 	}
; 0003 010E 
; 0003 010F 	release_spi();
; 0003 0110 
; 0003 0111 	return res;
; 0003 0112 }
;
;//-----------------------------------------------------------------------
;// Write partial sector
;//-----------------------------------------------------------------------
;#if _WRITE_FUNC
;
;DRESULT disk_writep (
; 0003 011A 	const BYTE *buff,	// Pointer to the bytes to be written (NULL:Initiate/Finalize sector write)
; 0003 011B 	DWORD sa			// Number of bytes to send, Sector number (LBA) or zero
; 0003 011C )
; 0003 011D {
; 0003 011E 	DRESULT res;
; 0003 011F 	WORD bc;
; 0003 0120 	static WORD wc;
; 0003 0121 
; 0003 0122 //	if ((PINB&_BV(SD_INS))!=0x00) return RES_ERROR;
; 0003 0123 //	if ((PINB&_BV(SD_WP))!=0x00) return RES_ERROR;
; 0003 0124 
; 0003 0125 	res = RES_ERROR;
;	*buff -> Y+8
;	sa -> Y+4
;	res -> R17
;	bc -> R18,R19
; 0003 0126 
; 0003 0127 	if (buff) {		// Send data bytes
; 0003 0128 		bc = (WORD)sa;
; 0003 0129 		while (bc && wc) {		// Send data bytes to the card
; 0003 012A 			xmit_spi(*buff++);
; 0003 012B 			wc--; bc--;
; 0003 012C 		}
; 0003 012D 		res = RES_OK;
; 0003 012E 	} else {
; 0003 012F 		if (sa) {	// Initiate sector write process
; 0003 0130 			if (!(CardType & CT_BLOCK)) sa *= 512;	// Convert to byte address if needed
; 0003 0131 			if (send_cmd(CMD24, sa) == 0) {			// WRITE_SINGLE_BLOCK
; 0003 0132 				xmit_spi(0xFF); xmit_spi(0xFE);		// Data block header
; 0003 0133 				wc = 512;							// Set byte counter
; 0003 0134 				res = RES_OK;
; 0003 0135 			}
; 0003 0136 		} else {	// Finalize sector write process
; 0003 0137 			bc = wc + 2;
; 0003 0138 			while (bc--) xmit_spi(0);	// Fill left bytes and CRC with zeros
; 0003 0139 if ((rcv_spi() & 0x1F) == 0x05) {
; 0003 013A 				for (bc = 65000; rcv_spi() != 0xFF && bc; bc--) ;	// Wait ready
; 0003 013B 				if (bc) res = RES_OK;
; 0003 013C 			}
; 0003 013D 			release_spi();
; 0003 013E 		}
; 0003 013F 	}
; 0003 0140 
; 0003 0141 	return res;
; 0003 0142 }
;#endif
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

	.CSEG

	.DSEG

	.CSEG

	.CSEG
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
	CALL SUBOPT_0x10
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x10
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
_lcd_putsf:
; .FSTART _lcd_putsf
	CALL __PUTPARD2
	ST   -Y,R17
_0x206000B:
	MOVW R26,R28
	ADIW R26,1
	CALL __GETD1P_INC
	__ADDD1N 1
	CALL __PUTDP1_DEC
	__SUBD1N 1
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
	CALL SUBOPT_0x11
	CALL SUBOPT_0x11
	CALL SUBOPT_0x11
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
_testChar_S0000004000:
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
_FatFs_G002:
	.BYTE 0x2
_CardType_G003:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4
__base_y_G103:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	CBI  0x15,1
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
	SBI  0x15,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	__GETD1N 0x2
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(_testChar_S0000004000)
	LDI  R31,HIGH(_testChar_S0000004000)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _ReadFlashBytes

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CALL __PUTPARD1
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8:
	MOVW R30,R16
	__GETD2S 4
	CLR  R22
	CLR  R23
	CALL __ADDD21
	JMP  _ReadFlashByte

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	__GETW1SX 268
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	__GETD1SX 272
	__ANDD1N 0xFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	__GETD2SX 272
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11:
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

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
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
