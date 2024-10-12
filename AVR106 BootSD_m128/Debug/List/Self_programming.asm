
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Boot Loader
;Clock frequency        : 10.000000 MHz
;Memory model           : Medium
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 2048 byte(s)
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
	.EQU __DSTACK_SIZE=0x0800
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
	.DEF ___AddrToZ24ByteToSPMCR_SPM_W_Test=R4
	.DEF ___AddrToZ24ByteToSPMCR_SPM_W_Test_msb=R5
	.DEF ___AddrToZ24WordToR1R0ByteToSPMCR_SPM_F_Test=R6
	.DEF ___AddrToZ24WordToR1R0ByteToSPMCR_SPM_F_Test_msb=R7
	.DEF _token=R9
	.DEF _SectorsPerCluster=R8
	.DEF _pagesCnt=R11
	.DEF _appPages=R12
	.DEF _appPages_msb=R13

	.CSEG
	.ORG 0xF000

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000
	JMP  0xF000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0xE0,0xF9,0xB4,0xF9

_0x40000:
	.DB  0x30,0x0,0x55,0x50,0x44,0x41,0x54,0x45
	.DB  0x0,0x5B,0x73,0x65,0x74,0x74,0x69,0x6E
	.DB  0x67,0x73,0x5D,0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x04
	.DD  __REG_VARS*2

	.DW  0x02
	.DW  _0x40003
	.DD  _0x40000*2

	.DW  0x07
	.DW  _0x40003+2
	.DD  _0x40000*2+2

	.DW  0x0B
	.DW  _0x40003+9
	.DD  _0x40000*2+9

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF THE BOOT LOADER
	LDI  R31,1
	OUT  MCUCR,R31
	LDI  R31,2
	OUT  MCUCR,R31
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
	.ORG 0x900

	.CSEG
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
;#include "flash.h"
     #define WR_SPMCR_REG_R22 sts 0x68,r22
;#include <delay.h>
;
;
;void (*__AddrToZ24ByteToSPMCR_SPM_W_Test)(void flash *addr)= (void(*)(void flash *)) 0x0F9E0;
;void (*__AddrToZ24WordToR1R0ByteToSPMCR_SPM_F_Test)(void flash *addr, unsigned int data)= (void(*)(void flash *, unsigne ...
;
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
;void MY_FILL_TEMP_WORD(unsigned long addr,unsigned int data)
; 0000 003A {

	.CSEG
; 0000 003B      _FILL_TEMP_WORD(addr,data);
;	addr -> Y+2
;	data -> Y+0
; 0000 003C }
;void MY_PAGE_ERASE(unsigned long addr)
; 0000 003E {
; 0000 003F      _PAGE_ERASE(addr);
;	addr -> Y+0
; 0000 0040 }
;void MY_PAGE_WRITE(unsigned long addr)
; 0000 0042 {
; 0000 0043      _PAGE_WRITE(addr);
;	addr -> Y+0
; 0000 0044 }
;/*!
;* The function Returns one byte located on Flash address given by ucFlashStartAdr.
;**/
;unsigned char ReadFlashByte(MyAddressType flashStartAdr){
; 0000 0048 unsigned char ReadFlashByte(MyAddressType flashStartAdr){
; 0000 0049 //#pragma diag_suppress=Pe1053 // Suppress warning for conversion from long-type address to flash ptr.
; 0000 004A   return (unsigned char)*((MyFlashCharPointer)flashStartAdr);
;	flashStartAdr -> Y+0
; 0000 004B //#pragma diag_default=Pe1053 // Back to default.
; 0000 004C } // Returns data from Flash
;
;/*!
;* The function reads one Flash page from address flashStartAdr and stores data
;* in array dataPage[]. The number of bytes stored is depending upon the
;* Flash page size. The function returns FALSE if input address is not a Flash
;* page address, else TRUE.
;**/
;unsigned char ReadFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage){
; 0000 0054 unsigned char ReadFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage){
; 0000 0055   unsigned int index;
; 0000 0056   if(!(flashStartAdr & (PAGESIZE-1))){      // If input address is a page address
;	flashStartAdr -> Y+4
;	*dataPage -> Y+2
;	index -> R16,R17
; 0000 0057     for(index = 0; index < PAGESIZE; index++){
; 0000 0058       dataPage[index] = ReadFlashByte(flashStartAdr + index);
; 0000 0059     }
; 0000 005A     return TRUE;                            // Return TRUE if valid page address
; 0000 005B   }
; 0000 005C   else{
; 0000 005D     return FALSE;                           // Return FALSE if not valid page address
; 0000 005E   }
; 0000 005F }
;
;/*!
;* The function writes byte data to Flash address flashAddr. Returns FALSE if
;* input address is not valid Flash byte address for writing, else TRUE.
;**/
;unsigned char WriteFlashByte(MyAddressType flashAddr, unsigned char data){
; 0000 0065 unsigned char WriteFlashByte(MyAddressType flashAddr, unsigned char data){
; 0000 0066   MyAddressType  pageAdr;
; 0000 0067   unsigned char eepromInterruptSettings,sregSettings;
; 0000 0068   if( AddressCheck( flashAddr & ~(PAGESIZE-1) )){
;	flashAddr -> Y+7
;	data -> Y+6
;	pageAdr -> Y+2
;	eepromInterruptSettings -> R17
;	sregSettings -> R16
; 0000 0069 
; 0000 006A     eepromInterruptSettings= EECR & (1<<EERIE); // Stores EEPROM interrupt mask
; 0000 006B     EECR &= ~(1<<EERIE);                    // Disable EEPROM interrupt
; 0000 006C     while(EECR & (1<<EEWE));                // Wait if ongoing EEPROM write
; 0000 006D 
; 0000 006E     sregSettings= SREG;
; 0000 006F     #asm("cli");
; 0000 0070     pageAdr=flashAddr & ~(PAGESIZE-1);      // Gets Flash page address from byte address
; 0000 0071 
; 0000 0072     #ifdef __FLASH_RECOVER
; 0000 0073     FlashBackup.status=0;                   // Inicate that Flash buffer does
; 0000 0074                                             // not contain data for writing
; 0000 0075     while(EECR & (1<<EEWE));
; 0000 0076     LpmReplaceSpm(flashAddr, data);         // Fills Flash write buffer
; 0000 0077     WriteBufToFlash(ADR_FLASH_BUFFER);      // Writes to Flash recovery buffer
; 0000 0078     FlashBackup.pageNumber = (unsigned int) (pageAdr/PAGESIZE); // Stores page address
; 0000 0079                                                        // data should be written to
; 0000 007A     FlashBackup.status = FLASH_BUFFER_FULL_ID; // Indicates that Flash recovery buffer
; 0000 007B                                                // contains unwritten data
; 0000 007C     while(EECR & (1<<EEWE));
; 0000 007D     #endif
; 0000 007E 
; 0000 007F     LpmReplaceSpm(flashAddr, data);         // Fills Flash write buffer
; 0000 0080 
; 0000 0081 
; 0000 0082     WriteBufToFlash(pageAdr);               // Writes to Flash
; 0000 0083 
; 0000 0084     #ifdef __FLASH_RECOVER
; 0000 0085     FlashBackup.status = 0;                 // Indicates that Flash recovery buffer
; 0000 0086                                             // does not contain unwritten data
; 0000 0087     while(EECR & (1<<EEWE));
; 0000 0088     #endif
; 0000 0089 
; 0000 008A     EECR |= eepromInterruptSettings;        // Restore EEPROM interrupt mask
; 0000 008B     SREG = sregSettings;
; 0000 008C     return TRUE;                            // Return TRUE if address
; 0000 008D                                             // valid for writing
; 0000 008E   }
; 0000 008F   else
; 0000 0090     return FALSE;                           // Return FALSE if address not
; 0000 0091                                             // valid for writing
; 0000 0092 }
;
;/*!
;* The function writes data from array dataPage[] to Flash page address
;* flashStartAdr. The Number of bytes written is depending upon the Flash page
;* size. Returns FALSE if input argument ucFlashStartAdr is not a valid Flash
;* page address for writing, else TRUE.
;**/
;unsigned char WriteFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage)
; 0000 009B {
_WriteFlashPage:
; .FSTART _WriteFlashPage
; 0000 009C   unsigned int index;
; 0000 009D   unsigned char eepromInterruptSettings,sregSettings;
; 0000 009E   if( AddressCheck(flashStartAdr) ){
	CALL SUBOPT_0x0
;	flashStartAdr -> Y+6
;	*dataPage -> Y+4
;	index -> R16,R17
;	eepromInterruptSettings -> R19
;	sregSettings -> R18
	__GETD2S 6
	RCALL _AddressCheck
	CPI  R30,0
	BRNE PC+2
	RJMP _0xD
; 0000 009F     eepromInterruptSettings = EECR & (1<<EERIE); // Stoes EEPROM interrupt mask
	IN   R30,0x1C
	ANDI R30,LOW(0x8)
	MOV  R19,R30
; 0000 00A0     EECR &= ~(1<<EERIE);                    // Disable EEPROM interrupt
	CBI  0x1C,3
; 0000 00A1     while(EECR & (1<<EEWE));                // Wait if ongoing EEPROM write
_0xE:
	SBIC 0x1C,1
	RJMP _0xE
; 0000 00A2 
; 0000 00A3     sregSettings= SREG;
	IN   R18,63
; 0000 00A4     #asm("cli");
	cli
; 0000 00A5 
; 0000 00A6     #ifdef __FLASH_RECOVER
; 0000 00A7     FlashBackup.status=0;                   // Inicate that Flash buffer does
; 0000 00A8                                             // not contain data for writing
; 0000 00A9     while(EECR & (1<<EEWE));
; 0000 00AA 
; 0000 00AB     //_ENABLE_RWW_SECTION();
; 0000 00AC 
; 0000 00AD     _WAIT_FOR_SPM();
; 0000 00AE     //_PAGE_ERASE( flashStartAdr );
; 0000 00AF 
; 0000 00B0     for(index = 0; index < PAGESIZE; index+=2){ // Fills Flash write buffer
; 0000 00B1       //_WAIT_FOR_SPM();
; 0000 00B2       //MY_FILL_TEMP_WORD(index, (unsigned int)dataPage[index]+((unsigned int)dataPage[index+1] << 8));
; 0000 00B3       _FILL_TEMP_WORD(index, (unsigned int)dataPage[index]+((unsigned int)dataPage[index+1] << 8));
; 0000 00B4     }
; 0000 00B5 
; 0000 00B6     WriteBufToFlash(ADR_FLASH_BUFFER);      // Writes to Flash recovery buffer
; 0000 00B7     FlashBackup.pageNumber=(unsigned int)(flashStartAdr/PAGESIZE);
; 0000 00B8     FlashBackup.status = FLASH_BUFFER_FULL_ID; // Indicates that Flash recovery buffer
; 0000 00B9                                            // contains unwritten data
; 0000 00BA     while(EECR & (1<<EEWE));
; 0000 00BB     #endif
; 0000 00BC 
; 0000 00BD     if(index==0xFFF1)
	LDI  R30,LOW(65521)
	LDI  R31,HIGH(65521)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x11
; 0000 00BE     {
; 0000 00BF         __AddrToZ24WordToR1R0ByteToSPMCR_SPM_F(0,0);
	CALL SUBOPT_0x1
	LDI  R26,LOW(0)
	LDI  R27,0
	CALL ___AddrToZ24WordToR1R0ByteToSPMCR_SPM_F
; 0000 00C0         __AddrToZ24ByteToSPMCR_SPM_W((void flash *)0x1EF00);
	CALL SUBOPT_0x2
	CALL ___AddrToZ24ByteToSPMCR_SPM_W
; 0000 00C1         __AddrToZ24ByteToSPMCR_SPM_E((void flash *)0x1EF00);
	CALL SUBOPT_0x2
	CALL ___AddrToZ24ByteToSPMCR_SPM_E
; 0000 00C2         __AddrToZ24ByteToSPMCR_SPM_EW((void flash *)0x1EF00);
	CALL SUBOPT_0x2
	CALL ___AddrToZ24ByteToSPMCR_SPM_EW
; 0000 00C3     }
; 0000 00C4     _WAIT_FOR_SPM();
_0x11:
_0x12:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x12
; 0000 00C5     //_PAGE_ERASE( flashStartAdr );
; 0000 00C6     //_ENABLE_RWW_SECTION();
; 0000 00C7 
; 0000 00C8     for(index = 0; index < PAGESIZE; index+=2){ // Fills Flash write buffer
	__GETWRN 16,17,0
_0x16:
	__CPWRN 16,17,256
	BRSH _0x17
; 0000 00C9       //_WAIT_FOR_SPM();
; 0000 00CA       //MY_FILL_TEMP_WORD(index, (unsigned int)dataPage[index]+((unsigned int)dataPage[index+1] << 8));
; 0000 00CB       _FILL_TEMP_WORD(index, (unsigned int)dataPage[index]+((unsigned int)dataPage[index+1] << 8));
	MOVW R30,R16
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOVW R30,R16
	CALL SUBOPT_0x3
	LD   R0,X
	CLR  R1
	MOVW R30,R16
	ADIW R30,1
	CALL SUBOPT_0x3
	LD   R30,X
	MOV  R31,R30
	LDI  R30,0
	MOVW R26,R0
	ADD  R26,R30
	ADC  R27,R31
	CALL ___AddrToZ24WordToR1R0ByteToSPMCR_SPM_F
; 0000 00CC     }
	__ADDWRN 16,17,2
	RJMP _0x16
_0x17:
; 0000 00CD     //_PAGE_WRITE( flashStartAdr );
; 0000 00CE     WriteBufToFlash(flashStartAdr);         // Writes to Flash
	__GETD2S 6
	RCALL _WriteBufToFlash
; 0000 00CF     #ifdef __FLASH_RECOVER
; 0000 00D0       FlashBackup.status=0;                 // Inicate that Flash buffer does
; 0000 00D1                                             // not contain data for writing
; 0000 00D2       while(EECR & (1<<EEWE));
; 0000 00D3     #endif
; 0000 00D4 
; 0000 00D5     EECR |= eepromInterruptSettings;        // Restore EEPROM interrupt mask
	IN   R30,0x1C
	OR   R30,R19
	OUT  0x1C,R30
; 0000 00D6     SREG = sregSettings;
	OUT  0x3F,R18
; 0000 00D7     return TRUE;                            // Return TRUE if address
	LDI  R30,LOW(1)
	RJMP _0x200000B
; 0000 00D8                                             // valid for writing
; 0000 00D9   }
; 0000 00DA   else
_0xD:
; 0000 00DB     return FALSE;                           // Return FALSE if not address not
	LDI  R30,LOW(0)
; 0000 00DC                                             // valid for writing
; 0000 00DD }
_0x200000B:
	CALL __LOADLOCR4
	ADIW R28,10
	RET
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
; 0000 00E6 unsigned char RecoverFlash(){
; 0000 00E7 #ifdef __FLASH_RECOVER
; 0000 00E8   unsigned int index;
; 0000 00E9   unsigned long flashStartAdr = (MyAddressType)FlashBackup.pageNumber * PAGESIZE;
; 0000 00EA   if(FlashBackup.status == FLASH_BUFFER_FULL_ID){ // Checks if Flash recovery
; 0000 00EB                                                   //  buffer contains data
; 0000 00EC 
; 0000 00ED     for(index=0; index < PAGESIZE; index+=2){     // Writes to Flash write buffer
; 0000 00EE         _WAIT_FOR_SPM();
; 0000 00EF         MY_FILL_TEMP_WORD( index, *((MyFlashIntPointer)(ADR_FLASH_BUFFER+index)) );
; 0000 00F0     }
; 0000 00F1 
; 0000 00F2 
; 0000 00F3     //WriteBufToFlash((MyAddressType)FlashBackup.pageNumber * PAGESIZE);
; 0000 00F4     _WAIT_FOR_SPM();
; 0000 00F5     MY_PAGE_ERASE( flashStartAdr );
; 0000 00F6     _WAIT_FOR_SPM();
; 0000 00F7     MY_PAGE_WRITE( flashStartAdr );
; 0000 00F8     _WAIT_FOR_SPM();
; 0000 00F9     _ENABLE_RWW_SECTION();
; 0000 00FA     FlashBackup.status=0;                   // Inicate that Flash buffer does
; 0000 00FB                                             // not contain data for writing
; 0000 00FC     while(EECR & (1<<EEWE));
; 0000 00FD     return TRUE;                            // Returns TRUE if recovery has
; 0000 00FE                                             // taken place
; 0000 00FF   }
; 0000 0100 #endif
; 0000 0101   return FALSE;
; 0000 0102 }
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
; 0000 010E unsigned char AddressCheck(MyAddressType flashAdr){
_AddressCheck:
; .FSTART _AddressCheck
; 0000 010F   #ifdef __FLASH_RECOVER
; 0000 0110   // The next line gives a warning 'pointless comparison with zero' if ADR_LIMIT_LOW is 0. Ignore it.
; 0000 0111   if( (flashAdr >= ADR_LIMIT_LOW) && (flashAdr <= ADR_LIMIT_HIGH) &&
; 0000 0112       (flashAdr != ADR_FLASH_BUFFER) && !(flashAdr & (PAGESIZE-1)) )
; 0000 0113     return TRUE;                            // Address is a valid page address
; 0000 0114   else
; 0000 0115     return FALSE;                           // Address is not a valid page address
; 0000 0116   #else
; 0000 0117   if((flashAdr >= ADR_LIMIT_LOW) && (flashAdr <= ADR_LIMIT_HIGH) && !(flashAdr & (PAGESIZE-1) ) )
	CALL SUBOPT_0x4
;	flashAdr -> Y+0
	CALL __CPD20
	BRLO _0x1A
	CALL SUBOPT_0x5
	__CPD2N 0x1F000
	BRSH _0x1A
	CALL __GETD1S0
	CPI  R30,0
	BREQ _0x1B
_0x1A:
	RJMP _0x19
_0x1B:
; 0000 0118     return TRUE;                            // Address is a valid page address
	LDI  R30,LOW(1)
	JMP  _0x200000A
; 0000 0119   else
_0x19:
; 0000 011A   {
; 0000 011B     /*
; 0000 011C     while(1)
; 0000 011D     {
; 0000 011E       PORTC.5=0;
; 0000 011F       delay_ms(500);
; 0000 0120       PORTC.5=1;
; 0000 0121       delay_ms(500);
; 0000 0122     }
; 0000 0123     */
; 0000 0124     return FALSE;                           // Address is not a valid page address
	LDI  R30,LOW(0)
	JMP  _0x200000A
; 0000 0125   }
; 0000 0126   #endif
; 0000 0127 }
; .FEND
;
;
;/*!
;* The function writes Flash temporary buffer to Flash page address given by
;* input argument.
;**/
;
;void WriteBufToFlash(MyAddressType flashStartAdr) {
; 0000 012F void WriteBufToFlash(MyAddressType flashStartAdr) {
_WriteBufToFlash:
; .FSTART _WriteBufToFlash
; 0000 0130     //_WAIT_FOR_SPM();
; 0000 0131     //MY_PAGE_ERASE( flashStartAdr );
; 0000 0132     //_PAGE_ERASE( flashStartAdr );
; 0000 0133     //_WAIT_FOR_SPM();
; 0000 0134     //_ENABLE_RWW_SECTION();
; 0000 0135     //MY_PAGE_WRITE( flashStartAdr );
; 0000 0136     _PAGE_WRITE( flashStartAdr );
	CALL SUBOPT_0x4
;	flashStartAdr -> Y+0
	CALL ___AddrToZ24ByteToSPMCR_SPM_EW
; 0000 0137     //_WAIT_FOR_SPM();
; 0000 0138     //_ENABLE_RWW_SECTION();
; 0000 0139 /*
; 0000 013A #pragma diag_suppress=Pe1053 // Suppress warning for conversion from long-type address to flash ptr.
; 0000 013B   #ifdef __HAS_RAMPZ__
; 0000 013C   RAMPZ = (unsigned char)(flashStartAdr >> 16);
; 0000 013D   #endif
; 0000 013E   _PAGE_ERASE(flashStartAdr);
; 0000 013F   while( SPMControllRegister & (1<<SPMEN) ); // Wait until Flash write completed
; 0000 0140   _PAGE_WRITE(flashStartAdr);
; 0000 0141   while( SPMControllRegister & (1<<SPMEN) ); // Wait until Flash write completed
; 0000 0142   #ifdef RWWSRE
; 0000 0143   __DataToR0ByteToSPMCR_SPM( 0, (unsigned char)(1<<RWWSRE)|(1<<SPMEN)); // Enable RWW
; 0000 0144   #endif
; 0000 0145 #pragma diag_default=Pe1053 // Back to default.
; 0000 0146 */
; 0000 0147 }
	JMP  _0x200000A
; .FEND
;
;/*!
;* The function reads Flash page given by flashAddr, replaces one byte given by
;* flashAddr with data, and stores entire page in Flash temporary buffer.
;**/
;void LpmReplaceSpm(MyAddressType flashAddr, unsigned char data){
; 0000 014D void LpmReplaceSpm(MyAddressType flashAddr, unsigned char data){
; 0000 014E //#pragma diag_suppress=Pe1053 // Suppress warning for conversion from long-type address to flash ptr.
; 0000 014F     unsigned int index, oddByte, pcWord;
; 0000 0150 
; 0000 0151     MyAddressType  pageAdr;
; 0000 0152     oddByte=(unsigned char)flashAddr & 1;
;	flashAddr -> Y+11
;	data -> Y+10
;	index -> R16,R17
;	oddByte -> R18,R19
;	pcWord -> R20,R21
;	pageAdr -> Y+6
; 0000 0153     pcWord=(unsigned int)flashAddr & (PAGESIZE-2); // Used when writing FLASH temp buffer
; 0000 0154     pageAdr=flashAddr & ~(PAGESIZE-1);        // Get FLASH page address from byte address
; 0000 0155     //while( SPMCR_REG & (1<<SPMEN) );
; 0000 0156     //_ENABLE_RWW_SECTION();
; 0000 0157 
; 0000 0158     for(index=0; index < PAGESIZE; index+=2){
; 0000 0159         if(index==pcWord){
; 0000 015A           if(oddByte){
; 0000 015B             //MY_FILL_TEMP_WORD( index, (*(MyFlashCharPointer)(flashAddr & ~1) | ((unsigned int)data<<8)) );
; 0000 015C             _FILL_TEMP_WORD( index, (*(MyFlashCharPointer)(flashAddr & ~1) | ((unsigned int)data<<8)) );
; 0000 015D           }                                     // Write odd byte in temporary buffer
; 0000 015E           else{
; 0000 015F             //MY_FILL_TEMP_WORD( index, ( (*( (MyFlashCharPointer)flashAddr+1)<<8)  | data ) );
; 0000 0160             _FILL_TEMP_WORD( index, ( (*( (MyFlashCharPointer)flashAddr+1)<<8)  | data ) );
; 0000 0161           }                                     // Write even byte in temporary buffer
; 0000 0162         }
; 0000 0163         else{
; 0000 0164           //MY_FILL_TEMP_WORD(index, *( (MyFlashIntPointer)(pageAdr+index) ) );
; 0000 0165           _FILL_TEMP_WORD(index, *( (MyFlashIntPointer)(pageAdr+index) ) );
; 0000 0166         }                                       // Write Flash word directly to temporary buffer
; 0000 0167     }
; 0000 0168 //#pragma diag_default=Pe1053 // Back to default.
; 0000 0169 }
;/*****************************************************************************
;*
;* (C) 2010, HP InfoTech srl, www.hpinfotech.com
;*
;* File              : flash.c
;* Compiler          : CodeVisionAVR V2.xx
;* Revision          : $Revision: 1.0 $
;* Date              : $Date: December 9, 2010 $
;* Updated by        : $Author: HP InfoTech $
;*
;* Target platform   : All AVRs with bootloader support
;*
;* AppNote           : AVR109 - Self-programming
;*
;* Description       : Flash operations for AVR109 Self-programming
;****************************************************************************/
;
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
;#include "flash.h"
     #define WR_SPMCR_REG_R22 sts 0x68,r22
;
;//#define	SPMCR_REG	SPMCSR
;
;void dospmew(void)
; 0001 0018 {

	.CSEG
_dospmew:
; .FSTART _dospmew
; 0001 0019     #asm
; 0001 001A          ldi   r22,$03
         ldi   r22,$03
; 0001 001B          WR_SPMCR_REG_R22
         WR_SPMCR_REG_R22
; 0001 001C          spm
         spm
; 0001 001D     #endasm
; 0001 001E     _WAIT_FOR_SPM();
_0x20003:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x20003
; 0001 001F     #asm
; 0001 0020         ldi   r22,$05
        ldi   r22,$05
; 0001 0021         WR_SPMCR_REG_R22
        WR_SPMCR_REG_R22
; 0001 0022         spm
        spm
; 0001 0023     #endasm
; 0001 0024     _WAIT_FOR_SPM();
_0x20006:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x20006
; 0001 0025     while( SPMCR_REG & (1<<RWWSB) )
_0x20009:
	LDS  R30,104
	ANDI R30,LOW(0x40)
	BREQ _0x2000B
; 0001 0026     {
; 0001 0027     #asm
; 0001 0028         ldi   r22,$11
        ldi   r22,$11
; 0001 0029         WR_SPMCR_REG_R22
        WR_SPMCR_REG_R22
; 0001 002A         spm
        spm
; 0001 002B     #endasm
; 0001 002C         _WAIT_FOR_SPM();
_0x2000C:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x2000C
; 0001 002D     }
	RJMP _0x20009
_0x2000B:
; 0001 002E }
	RET
; .FEND
;
;void dospmw(void)
; 0001 0031 {
_dospmw:
; .FSTART _dospmw
; 0001 0032     #asm
; 0001 0033         ldi   r22,$05
        ldi   r22,$05
; 0001 0034         WR_SPMCR_REG_R22
        WR_SPMCR_REG_R22
; 0001 0035         spm
        spm
; 0001 0036     #endasm
; 0001 0037     _WAIT_FOR_SPM();
_0x2000F:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x2000F
; 0001 0038     while( SPMCR_REG & (1<<RWWSB) )
_0x20012:
	LDS  R30,104
	ANDI R30,LOW(0x40)
	BREQ _0x20014
; 0001 0039     {
; 0001 003A     #asm
; 0001 003B         ldi   r22,$11
        ldi   r22,$11
; 0001 003C         WR_SPMCR_REG_R22
        WR_SPMCR_REG_R22
; 0001 003D         spm
        spm
; 0001 003E     #endasm
; 0001 003F         _WAIT_FOR_SPM();
_0x20015:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x20015
; 0001 0040     }
	RJMP _0x20012
_0x20014:
; 0001 0041 }
	RET
; .FEND
;
;void dospme(void)
; 0001 0044 {
_dospme:
; .FSTART _dospme
; 0001 0045     #asm
; 0001 0046         ldi   r22,$03
        ldi   r22,$03
; 0001 0047         WR_SPMCR_REG_R22
        WR_SPMCR_REG_R22
; 0001 0048         spm
        spm
; 0001 0049     #endasm
; 0001 004A     _WAIT_FOR_SPM();
_0x20018:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x20018
; 0001 004B     while( SPMCR_REG & (1<<RWWSB) )
_0x2001B:
	LDS  R30,104
	ANDI R30,LOW(0x40)
	BREQ _0x2001D
; 0001 004C     {
; 0001 004D     #asm
; 0001 004E         ldi   r22,$11
        ldi   r22,$11
; 0001 004F         WR_SPMCR_REG_R22
        WR_SPMCR_REG_R22
; 0001 0050         spm
        spm
; 0001 0051     #endasm
; 0001 0052         _WAIT_FOR_SPM();
_0x2001E:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x2001E
; 0001 0053     }
	RJMP _0x2001B
_0x2001D:
; 0001 0054 }
	RET
; .FEND
;
;void dospm(void)
; 0001 0057 {
_dospm:
; .FSTART _dospm
; 0001 0058     #asm
; 0001 0059          ldi   r22,$01
         ldi   r22,$01
; 0001 005A          WR_SPMCR_REG_R22
         WR_SPMCR_REG_R22
; 0001 005B          spm
         spm
; 0001 005C     #endasm
; 0001 005D     _WAIT_FOR_SPM();
_0x20021:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x20021
; 0001 005E     while( SPMCR_REG & (1<<RWWSB) )
_0x20024:
	LDS  R30,104
	ANDI R30,LOW(0x40)
	BREQ _0x20026
; 0001 005F     {
; 0001 0060     #asm
; 0001 0061         ldi   r22,$11
        ldi   r22,$11
; 0001 0062         WR_SPMCR_REG_R22
        WR_SPMCR_REG_R22
; 0001 0063         spm
        spm
; 0001 0064     #endasm
; 0001 0065         _WAIT_FOR_SPM();
_0x20027:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x20027
; 0001 0066     }
	RJMP _0x20024
_0x20026:
; 0001 0067 }
	RET
; .FEND
;
;#pragma warn-
;
;unsigned char __AddrToZByteToSPMCR_LPM(void flash *addr, unsigned char ctrl)
; 0001 006C {
; 0001 006D #asm
;	*addr -> Y+1
;	ctrl -> Y+0
; 0001 006E      ldd  r30,y+1
; 0001 006F      ldd  r31,y+2
; 0001 0070      ld   r22,y
; 0001 0071      WR_SPMCR_REG_R22
; 0001 0072      lpm
; 0001 0073      mov  r30,r0
; 0001 0074 #endasm
; 0001 0075 }
;
;void __DataToR0ByteToSPMCR_SPM(unsigned char data, unsigned char ctrl)
; 0001 0078 {
; 0001 0079 #asm
;	data -> Y+1
;	ctrl -> Y+0
; 0001 007A      ldd  r0,y+1
; 0001 007B      ld   r22,y
; 0001 007C      WR_SPMCR_REG_R22
; 0001 007D      spm
; 0001 007E #endasm
; 0001 007F }
;
;void __AddrToZWordToR1R0ByteToSPMCR_SPM(void flash *addr, unsigned int data, unsigned char ctrl)
; 0001 0082 {
; 0001 0083     #asm
;	*addr -> Y+3
;	data -> Y+1
;	ctrl -> Y+0
; 0001 0084          ldd  r30,y+3
; 0001 0085          ldd  r31,y+4
; 0001 0086          ldd  r0,y+1
; 0001 0087          ldd  r1,y+2
; 0001 0088          ld   r22,y
; 0001 0089          WR_SPMCR_REG_R22
; 0001 008A          spm
; 0001 008B     #endasm
; 0001 008C }
;
;void __AddrToZWordToR1R0ByteToSPMCR_SPM_F(void flash *addr, unsigned int data)
; 0001 008F {
; 0001 0090 _WAIT_FOR_SPM();
;	*addr -> Y+2
;	data -> Y+0
; 0001 0091     #asm
; 0001 0092          ldd  r30,y+2
; 0001 0093          ldd  r31,y+3
; 0001 0094          ldd  r0,y+0
; 0001 0095          ldd  r1,y+1
; 0001 0096          //ldi   r22,LOW(1)
; 0001 0097          //WR_SPMCR_REG_R22
; 0001 0098          //spm
; 0001 0099     #endasm
; 0001 009A dospm();
; 0001 009B }
;
;void __AddrToZByteToSPMCR_SPM(void flash *addr, unsigned char ctrl)
; 0001 009E {
; 0001 009F #asm
;	*addr -> Y+1
;	ctrl -> Y+0
; 0001 00A0      ldd  r30,y+1
; 0001 00A1      ldd  r31,y+2
; 0001 00A2      ld   r22,y
; 0001 00A3      WR_SPMCR_REG_R22
; 0001 00A4      spm
; 0001 00A5 #endasm
; 0001 00A6 }
;
;void __AddrToZByteToSPMCR_SPM_W(void flash *addr)
; 0001 00A9 {
; 0001 00AA _WAIT_FOR_SPM();
;	*addr -> Y+0
; 0001 00AB #asm
; 0001 00AC      ldd  r30,y+0
; 0001 00AD      ldd  r31,y+1
; 0001 00AE      //ld   r22,y
; 0001 00AF      //WR_SPMCR_REG_R22
; 0001 00B0      //spm
; 0001 00B1 #endasm
; 0001 00B2 dospmew();
; 0001 00B3 }
;
;
;void __AddrToZ24WordToR1R0ByteToSPMCR_SPM(void flash *addr, unsigned int data, unsigned char ctrl)
; 0001 00B7 {
; 0001 00B8 #asm
;	*addr -> Y+3
;	data -> Y+1
;	ctrl -> Y+0
; 0001 00B9      ldd  r30,y+3
; 0001 00BA      ldd  r31,y+4
; 0001 00BB      ldd  r22,y+5
; 0001 00BC      out  rampz,r22
; 0001 00BD      ldd  r0,y+1
; 0001 00BE      ldd  r1,y+2
; 0001 00BF      ld   r22,y
; 0001 00C0      WR_SPMCR_REG_R22
; 0001 00C1      spm
; 0001 00C2 #endasm
; 0001 00C3 }
;
;void __AddrToZ24WordToR1R0ByteToSPMCR_SPM_F(void flash *addr, unsigned int data)
; 0001 00C6 {
___AddrToZ24WordToR1R0ByteToSPMCR_SPM_F:
; .FSTART ___AddrToZ24WordToR1R0ByteToSPMCR_SPM_F
; 0001 00C7 _WAIT_FOR_SPM();
	ST   -Y,R27
	ST   -Y,R26
;	*addr -> Y+2
;	data -> Y+0
_0x20030:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x20030
; 0001 00C8 #asm
; 0001 00C9      ldd  r30,y+2
     ldd  r30,y+2
; 0001 00CA      ldd  r31,y+3
     ldd  r31,y+3
; 0001 00CB      ldd  r22,y+4
     ldd  r22,y+4
; 0001 00CC      out  rampz,r22
     out  rampz,r22
; 0001 00CD      ldd  r0,y+0
     ldd  r0,y+0
; 0001 00CE      ldd  r1,y+1
     ldd  r1,y+1
; 0001 00CF      //ld   r22,y
     //ld   r22,y
; 0001 00D0      //WR_SPMCR_REG_R22
     //WR_SPMCR_REG_R22
; 0001 00D1      //spm
     //spm
; 0001 00D2 #endasm
; 0001 00D3 dospm();
	CALL _dospm
; 0001 00D4 }
	JMP  _0x2000004
; .FEND
;
;void __AddrToZ24ByteToSPMCR_SPM(void flash *addr, unsigned char ctrl)
; 0001 00D7 {
; 0001 00D8 #asm
;	*addr -> Y+1
;	ctrl -> Y+0
; 0001 00D9      ldd  r30,y+1
; 0001 00DA      ldd  r31,y+2
; 0001 00DB      ldd  r22,y+3
; 0001 00DC      out  rampz,r22
; 0001 00DD      ld   r22,y
; 0001 00DE      WR_SPMCR_REG_R22
; 0001 00DF      spm
; 0001 00E0 #endasm
; 0001 00E1 }
;
;void __AddrToZ24ByteToSPMCR_SPM_W(void flash *addr)
; 0001 00E4 {
___AddrToZ24ByteToSPMCR_SPM_W:
; .FSTART ___AddrToZ24ByteToSPMCR_SPM_W
; 0001 00E5 _WAIT_FOR_SPM();
	CALL __PUTPARD2
;	*addr -> Y+0
_0x20033:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x20033
; 0001 00E6 #asm
; 0001 00E7      ldd  r30,y+0
     ldd  r30,y+0
; 0001 00E8      ldd  r31,y+1
     ldd  r31,y+1
; 0001 00E9      ldd  r22,y+2
     ldd  r22,y+2
; 0001 00EA      out  rampz,r22
     out  rampz,r22
; 0001 00EB      //ld   r22,y
     //ld   r22,y
; 0001 00EC      //WR_SPMCR_REG_R22
     //WR_SPMCR_REG_R22
; 0001 00ED      //spm
     //spm
; 0001 00EE #endasm
; 0001 00EF dospmw();
	CALL _dospmw
; 0001 00F0 }
	JMP  _0x200000A
; .FEND
;
;void __AddrToZ24ByteToSPMCR_SPM_E(void flash *addr)
; 0001 00F3 {
___AddrToZ24ByteToSPMCR_SPM_E:
; .FSTART ___AddrToZ24ByteToSPMCR_SPM_E
; 0001 00F4 _WAIT_FOR_SPM();
	CALL __PUTPARD2
;	*addr -> Y+0
_0x20036:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x20036
; 0001 00F5 #asm
; 0001 00F6      ldd  r30,y+0
     ldd  r30,y+0
; 0001 00F7      ldd  r31,y+1
     ldd  r31,y+1
; 0001 00F8      ldd  r22,y+2
     ldd  r22,y+2
; 0001 00F9      out  rampz,r22
     out  rampz,r22
; 0001 00FA      //ld   r22,y
     //ld   r22,y
; 0001 00FB      //WR_SPMCR_REG_R22
     //WR_SPMCR_REG_R22
; 0001 00FC      //spm
     //spm
; 0001 00FD #endasm
; 0001 00FE dospme();
	CALL _dospme
; 0001 00FF }
	JMP  _0x200000A
; .FEND
;
;void __AddrToZ24ByteToSPMCR_SPM_EW(void flash *addr)
; 0001 0102 {
___AddrToZ24ByteToSPMCR_SPM_EW:
; .FSTART ___AddrToZ24ByteToSPMCR_SPM_EW
; 0001 0103 _WAIT_FOR_SPM();
	CALL __PUTPARD2
;	*addr -> Y+0
_0x20039:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x20039
; 0001 0104 #asm
; 0001 0105      ldd  r30,y+0
     ldd  r30,y+0
; 0001 0106      ldd  r31,y+1
     ldd  r31,y+1
; 0001 0107      ldd  r22,y+2
     ldd  r22,y+2
; 0001 0108      out  rampz,r22
     out  rampz,r22
; 0001 0109      //ld   r22,y
     //ld   r22,y
; 0001 010A      //WR_SPMCR_REG_R22
     //WR_SPMCR_REG_R22
; 0001 010B      //spm
     //spm
; 0001 010C #endasm
; 0001 010D dospmew();
	CALL _dospmew
; 0001 010E }
	JMP  _0x200000A
; .FEND
;
;#ifdef _WARNINGS_ON_
;#pragma warn+
;#endif
;
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
;#include "flash.h"
     #define WR_SPMCR_REG_R22 sts 0x68,r22
;#include "Self_programming.h"
;#include "spi_sdcard.h"
;
;#define SDBUF_SIZE  512
;#define PAGES_PER_SDBUF (SDBUF_SIZE/PAGESIZE)
;
;//#define DEBUGLED
;//#define DEBUG_ERRSD
;//#define DEBUG_LCD
;
;#ifdef DEBUG_LCD
;
;/* printf */
;#include <stdio.h>
;#include <stdlib.h>
;/* string functions */
;#include <string.h>
;#include <alcd.h>
;
;#endif
;
;unsigned char result[5], sdBuf[SDBUF_SIZE], testBuf[PAGESIZE], token, SectorsPerCluster, pagesCnt;
;unsigned long appStartAdr,adr,SectorsPerFat,fat_begin_lba;
;unsigned long cluster_begin_lba,root_dir_first_cluster,fat_file_adr,fat_file_next_adr,filesize,readbytes;
;unsigned int appPages,bytesChecksum,checksumCnt;
;unsigned int Number_of_Reserved_Sectors;
;
;//(unsigned long)fat_begin_lba = Partition_LBA_Begin + Number_of_Reserved_Sectors;
;//(unsigned long)cluster_begin_lba = Partition_LBA_Begin + Number_of_Reserved_Sectors + (Number_of_FATs * Sectors_Per_FA ...
;//(unsigned char)sectors_per_cluster = BPB_SecPerClus;
;//(unsigned long)root_dir_first_cluster = BPB_RootClus;
;//void testWrite();
;
;#ifdef DEBUG_ERRSD
;void errorSD(unsigned char err);
;#endif
;#ifdef DEBUG_LCD
;lcd_printhex(unsigned long num32, char size);
;char cnum[10];
;#endif
;
;//function prototypes
;unsigned char fat_init();//0=sucess, 1,2,3 errors
;unsigned char dir_open(const char *dirname); //0=sucess, 4 error
;unsigned char file_open_update(const char *filename); //0=sucess, 5,6 errors
;unsigned long buf2num(unsigned char *buf,unsigned char len);
;unsigned char compbuf(const unsigned char *src,unsigned char *dest);
;void (*app_pointer)(void) = (void(*)(void))0x0000;
;
;
;
;void main( void ){
; 0002 0052 void main( void ){

	.CSEG
_main:
; .FSTART _main
; 0002 0053   unsigned int i,j,k;
; 0002 0054   unsigned char rollnum;
; 0002 0055   unsigned char rollbuf[11];
; 0002 0056 /* globally enable interrupts */
; 0002 0057 #asm("sei")
	SBIW R28,12
;	i -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
;	rollnum -> Y+11
;	rollbuf -> Y+0
	sei
; 0002 0058 #ifdef DEBUG_LCD
; 0002 0059     DDRC.0=1;
; 0002 005A     PORTC.0=1;
; 0002 005B     /* initialize the LCD for 2 lines & 16 columns */
; 0002 005C     lcd_init(16);
; 0002 005D     /* switch to writing in Display RAM */
; 0002 005E     lcd_gotoxy(0,0);
; 0002 005F     lcd_clear();
; 0002 0060     lcd_putsf("BootSdTest.");
; 0002 0061     lcd_gotoxy(0,1);
; 0002 0062     lcd_putsf("0");
; 0002 0063     delay_ms(500);
; 0002 0064     //while(1);
; 0002 0065 #endif
; 0002 0066 #ifdef DEBUGLED
; 0002 0067   DDRC=0xFF;
; 0002 0068   PORTC=0xFF;
; 0002 0069     //do
; 0002 006A     {
; 0002 006B       PORTC.0=0;
; 0002 006C       PORTC.1=1;
; 0002 006D       delay_ms(500);
; 0002 006E       PORTC.1=0;
; 0002 006F       PORTC.0=1;
; 0002 0070       delay_ms(500);
; 0002 0071       PORTC=0xFF;
; 0002 0072     }
; 0002 0073     //while(1);
; 0002 0074 #endif
; 0002 0075     //fat init function
; 0002 0076     //init SD
; 0002 0077     fat_init();
	RCALL _fat_init
; 0002 0078 
; 0002 0079 
; 0002 007A     //dir open function
; 0002 007B   dir_open("0");
	__POINTW2MN _0x40003,0
	RCALL _dir_open
; 0002 007C 
; 0002 007D 
; 0002 007E   //fat_file_adr is hold the files records cluster in found dir
; 0002 007F   //file open func. read first cluster where data about filenames in dir
; 0002 0080   file_open_update("UPDATE");
	__POINTW2MN _0x40003,2
	RCALL _file_open_update
; 0002 0081 
; 0002 0082 
; 0002 0083 
; 0002 0084   //check FAT for chain of clusters to read
; 0002 0085   readbytes=0;
	LDI  R30,LOW(0)
	STS  _readbytes,R30
	STS  _readbytes+1,R30
	STS  _readbytes+2,R30
	STS  _readbytes+3,R30
; 0002 0086   while(fat_file_adr != 0x0FFFFFFFUL)
_0x40004:
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	BRNE PC+2
	RJMP _0x40006
; 0002 0087   {
; 0002 0088     //read where next cluster from FAT, check that not EOF
; 0002 0089     //if((result[0]=SD_readSingleBlock(fat_begin_lba, sdBuf, &token))!=SD_SUCCESS){
; 0002 008A 
; 0002 008B     if((result[0]=SD_readSingleBlock(fat_begin_lba+((fat_file_adr*4)/512), sdBuf, &token))!=SD_SUCCESS){
	CALL SUBOPT_0x8
	CALL __LSLD1
	CALL __LSLD1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x200
	CALL __DIVD21U
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	CPI  R30,0
	BREQ _0x40007
; 0002 008C     #ifdef DEBUG_ERRSD
; 0002 008D         errorSD(7);
; 0002 008E     #endif
; 0002 008F         while(1);//do watchdog reset on error
_0x40008:
	RJMP _0x40008
; 0002 0090     }
; 0002 0091     //next cluster address, of file data, read from current cluster record.each record 4 bytes (32bits)
; 0002 0092     //fat_file_next_adr=buf2num(&sdBuf[fat_file_adr*4],4);
; 0002 0093     fat_file_next_adr=buf2num(&sdBuf[(fat_file_adr*4)%512],4);
_0x40007:
	LDS  R26,_fat_file_adr
	LDS  R27,_fat_file_adr+1
	LDI  R30,LOW(4)
	CALL __MULB1W2U
	ANDI R31,HIGH(0x1FF)
	SUBI R30,LOW(-_sdBuf)
	SBCI R31,HIGH(-_sdBuf)
	CALL SUBOPT_0xB
	STS  _fat_file_next_adr,R30
	STS  _fat_file_next_adr+1,R31
	STS  _fat_file_next_adr+2,R22
	STS  _fat_file_next_adr+3,R23
; 0002 0094     #ifdef DEBUG_LCD
; 0002 0095       lcd_clear();
; 0002 0096       lcd_putsf("beglba");
; 0002 0097       lcd_printhex(fat_begin_lba,sizeof(fat_begin_lba));
; 0002 0098       delay_ms(1000);
; 0002 0099       lcd_clear();
; 0002 009A       lcd_putsf("curcls");
; 0002 009B       lcd_printhex(fat_file_adr,sizeof(fat_file_adr));
; 0002 009C       lcd_gotoxy(0,1);
; 0002 009D       lcd_putsf("nxtcls");
; 0002 009E       lcd_printhex(fat_file_next_adr,sizeof(fat_file_next_adr));
; 0002 009F       delay_ms(1000);
; 0002 00A0     #endif
; 0002 00A1     adr=cluster_begin_lba +(fat_file_adr-2)*SectorsPerCluster;
	CALL SUBOPT_0xC
; 0002 00A2     for(i=0;i<SectorsPerCluster;i++)
_0x4000C:
	CALL SUBOPT_0xD
	BRLO PC+2
	RJMP _0x4000D
; 0002 00A3     {
; 0002 00A4         //read data from next sector of file cluster
; 0002 00A5         if((result[0]=SD_readSingleBlock(adr, sdBuf, &token))!=SD_SUCCESS){
	CALL SUBOPT_0xE
; 0002 00A6         #ifdef DEBUG_ERRSD
; 0002 00A7             errorSD(8);
; 0002 00A8         #endif
; 0002 00A9         }
; 0002 00AA         #ifdef DEBUG_LCD
; 0002 00AB           lcd_clear();
; 0002 00AC           lcd_putsf("sector ");
; 0002 00AD           lcd_printhex(i,sizeof(i));
; 0002 00AE           //delay_ms(500);
; 0002 00AF           //if(readbytes==2048){
; 0002 00B0           lcd_gotoxy(0,1);
; 0002 00B1           lcd_putsf("data0 ");
; 0002 00B2           lcd_printhex(sdBuf[0],sizeof(sdBuf[0]));
; 0002 00B3           delay_ms(1000);
; 0002 00B4         //}
; 0002 00B5         #endif
; 0002 00B6         //address 2000 = start adr flash app 3 bytes, flash pages 2 bytes, checksum 2 bytes
; 0002 00B7         //app bytes starts from 2048, roll 0x88
; 0002 00B8         if(readbytes<512){
	CALL SUBOPT_0xF
	__CPD2N 0x200
	BRSH _0x4000F
; 0002 00B9             //j=0x99;
; 0002 00BA             for(j=0;j<256;j++){//find roll  0x00...0xFF
	__GETWRN 18,19,0
_0x40011:
	__CPWRN 18,19,256
	BRSH _0x40012
; 0002 00BB                if(j>0){
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRSH _0x40013
; 0002 00BC                    for(k=0;k<10;k++){//[settings]
	__GETWRN 20,21,0
_0x40015:
	__CPWRN 20,21,10
	BRSH _0x40016
; 0002 00BD                         rollbuf[k]=(sdBuf[k]<<1)|(sdBuf[k]>>7);  //ROL
	MOVW R30,R20
	MOVW R26,R28
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDI  R26,LOW(_sdBuf)
	LDI  R27,HIGH(_sdBuf)
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	LSL  R30
	MOV  R0,R30
	LDI  R26,LOW(_sdBuf)
	LDI  R27,HIGH(_sdBuf)
	ADD  R26,R20
	ADC  R27,R21
	CALL SUBOPT_0x10
; 0002 00BE                         rollbuf[k]^=j;  //XOR   j=roll
	MOVW R26,R28
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	EOR  R30,R18
	ST   X,R30
; 0002 00BF                    }
	__ADDWRN 20,21,1
	RJMP _0x40015
_0x40016:
; 0002 00C0                }
; 0002 00C1                result[1]=compbuf("[settings]",&rollbuf[0]);
_0x40013:
	__POINTW1MN _0x40003,9
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	CALL SUBOPT_0x11
; 0002 00C2                if(result[1]!=0){
	__GETB1MN _result,1
	CPI  R30,0
	BREQ _0x40017
; 0002 00C3                     rollnum=j;
	__PUTBSR 18,11
; 0002 00C4                     #ifdef DEBUG_LCD
; 0002 00C5                       lcd_clear();
; 0002 00C6                       lcd_putsf("roll ");
; 0002 00C7                       lcd_printhex(rollnum,sizeof(rollnum));
; 0002 00C8                       delay_ms(1000);
; 0002 00C9                     #endif
; 0002 00CA                     break;
	RJMP _0x40012
; 0002 00CB                }
; 0002 00CC             }
_0x40017:
	__ADDWRN 18,19,1
	RJMP _0x40011
_0x40012:
; 0002 00CD             if(result[1]==0){//roll didn't found
; 0002 00CE                 #ifdef DEBUG_ERRSD
; 0002 00CF                 errorSD(9);
; 0002 00D0                 #endif
; 0002 00D1                 //return;
; 0002 00D2             }
; 0002 00D3         }
; 0002 00D4 
; 0002 00D5         for(j=0;j<512;j++)
_0x4000F:
	__GETWRN 18,19,0
_0x4001A:
	__CPWRN 18,19,512
	BRSH _0x4001B
; 0002 00D6         {
; 0002 00D7             if(rollnum!=0){
	LDD  R30,Y+11
	CPI  R30,0
	BREQ _0x4001C
; 0002 00D8                 sdBuf[j]=(sdBuf[j]<<1)|(sdBuf[j]>>7);  //ROL
	MOVW R30,R18
	SUBI R30,LOW(-_sdBuf)
	SBCI R31,HIGH(-_sdBuf)
	MOVW R22,R30
	CALL SUBOPT_0x12
	LD   R30,X
	LSL  R30
	MOV  R0,R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x10
; 0002 00D9                 sdBuf[j]^=rollnum;//0x88;  //XOR
	MOVW R30,R18
	SUBI R30,LOW(-_sdBuf)
	SBCI R31,HIGH(-_sdBuf)
	MOVW R0,R30
	LD   R30,Z
	LDD  R26,Y+11
	EOR  R30,R26
	MOVW R26,R0
	ST   X,R30
; 0002 00DA             }
; 0002 00DB             checksumCnt+=sdBuf[j];
_0x4001C:
	CALL SUBOPT_0x12
	LD   R30,X
	LDI  R31,0
	LDS  R26,_checksumCnt
	LDS  R27,_checksumCnt+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _checksumCnt,R30
	STS  _checksumCnt+1,R31
; 0002 00DC         }
	__ADDWRN 18,19,1
	RJMP _0x4001A
_0x4001B:
; 0002 00DD         readbytes+=512;
	LDS  R30,_readbytes
	LDS  R31,_readbytes+1
	LDS  R22,_readbytes+2
	LDS  R23,_readbytes+3
	__ADDD1N 512
	STS  _readbytes,R30
	STS  _readbytes+1,R31
	STS  _readbytes+2,R22
	STS  _readbytes+3,R23
; 0002 00DE         //read app data
; 0002 00DF         if(readbytes>2048)
	CALL SUBOPT_0xF
	__CPD2N 0x801
	BRLO _0x4001D
; 0002 00E0         {
; 0002 00E1            for(pagesCnt=0;pagesCnt<PAGES_PER_SDBUF;pagesCnt++)
	CLR  R11
_0x4001F:
	LDI  R30,LOW(2)
	CP   R11,R30
	BRSH _0x40020
; 0002 00E2            {
; 0002 00E3                #ifdef DEBUG_LCD
; 0002 00E4                   lcd_clear();
; 0002 00E5                   lcd_putsf("appage ");
; 0002 00E6                   lcd_printhex(appPages,sizeof(appPages));
; 0002 00E7                   delay_ms(1000);
; 0002 00E8                   lcd_clear();
; 0002 00E9                   lcd_putsf("apstrt ");
; 0002 00EA                   lcd_printhex(appStartAdr,sizeof(appStartAdr));
; 0002 00EB                   delay_ms(1000);
; 0002 00EC                 #endif
; 0002 00ED                #asm("wdr")
	wdr
; 0002 00EE                if(WriteFlashPage(appStartAdr, &sdBuf[pagesCnt*PAGESIZE])==0)
	CALL SUBOPT_0x13
	CALL __PUTPARD1
	MOV  R26,R11
	LDI  R27,0
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	CALL __MULW12
	SUBI R30,LOW(-_sdBuf)
	SBCI R31,HIGH(-_sdBuf)
	MOVW R26,R30
	CALL _WriteFlashPage
	CPI  R30,0
	BRNE _0x40021
; 0002 00EF                {
; 0002 00F0                     //after error during flash write page. wait for watchdog to reset
; 0002 00F1                     #ifdef DEBUGLED
; 0002 00F2                     do
; 0002 00F3                     {
; 0002 00F4                       PORTC.6=0;
; 0002 00F5                       delay_ms(500);
; 0002 00F6                       PORTC.6=1;
; 0002 00F7                       delay_ms(500);
; 0002 00F8                     }
; 0002 00F9                     #endif
; 0002 00FA                     while(1);
_0x40022:
	RJMP _0x40022
; 0002 00FB                }
; 0002 00FC                appStartAdr+=PAGESIZE;
_0x40021:
	CALL SUBOPT_0x13
	__ADDD1N 256
	CALL SUBOPT_0x14
; 0002 00FD                appPages--;
	MOVW R30,R12
	SBIW R30,1
	MOVW R12,R30
; 0002 00FE                if(appPages==0)
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x40025
; 0002 00FF                {
; 0002 0100                     #ifdef DEBUG_LCD
; 0002 0101                       lcd_clear();
; 0002 0102                       lcd_putsf("jump to app");
; 0002 0103                       delay_ms(2000);
; 0002 0104                     #endif
; 0002 0105                     app_pointer();//go to app address 0
	__CALL1MN _app_pointer,0
; 0002 0106                     /*
; 0002 0107                     do
; 0002 0108                     {
; 0002 0109                       #ifdef DEBUGLED
; 0002 010A                       PORTC.5=0;
; 0002 010B                       delay_ms(500);
; 0002 010C                       PORTC.5=1;
; 0002 010D                       delay_ms(500);
; 0002 010E                       #endif
; 0002 010F                     }while(1);
; 0002 0110                     */
; 0002 0111                }
; 0002 0112            }
_0x40025:
	INC  R11
	RJMP _0x4001F
_0x40020:
; 0002 0113         }
; 0002 0114         //read app start adr, num of pages, checksum
; 0002 0115         else if(readbytes>=2000){//Offset=512-48=464
	RJMP _0x40026
_0x4001D:
	CALL SUBOPT_0xF
	__CPD2N 0x7D0
	BRLO _0x40027
; 0002 0116            appStartAdr=(unsigned long)sdBuf[464]<<16;
	__GETB1MN _sdBuf,464
	CALL SUBOPT_0x15
	CALL SUBOPT_0x14
; 0002 0117            appStartAdr|=(unsigned long)sdBuf[465]<<8;
	__GETB1MN _sdBuf,465
	LDI  R31,0
	CALL __CWD1
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSLD12
	CALL SUBOPT_0x16
; 0002 0118            appStartAdr|=(unsigned long)sdBuf[466];
	__GETB1MN _sdBuf,466
	LDI  R31,0
	CALL __CWD1
	CALL SUBOPT_0x16
; 0002 0119            appPages=(unsigned int)sdBuf[467]<<8;
	__GETBRMN 31,_sdBuf,467
	LDI  R30,LOW(0)
	MOVW R12,R30
; 0002 011A            appPages|=(unsigned int)sdBuf[468];
	__GETB1MN _sdBuf,468
	LDI  R31,0
	__ORWRR 12,13,30,31
; 0002 011B            bytesChecksum=(unsigned int)sdBuf[469]<<8;
	__GETBRMN 31,_sdBuf,469
	LDI  R30,LOW(0)
	STS  _bytesChecksum,R30
	STS  _bytesChecksum+1,R31
; 0002 011C            bytesChecksum|=(unsigned int)sdBuf[470];
	__GETB1MN _sdBuf,470
	LDI  R31,0
	LDS  R26,_bytesChecksum
	LDS  R27,_bytesChecksum+1
	OR   R30,R26
	OR   R31,R27
	STS  _bytesChecksum,R30
	STS  _bytesChecksum+1,R31
; 0002 011D            checksumCnt=0;
	LDI  R30,LOW(0)
	STS  _checksumCnt,R30
	STS  _checksumCnt+1,R30
; 0002 011E            #ifdef DEBUG_LCD
; 0002 011F               lcd_clear();
; 0002 0120               lcd_putsf("appags ");
; 0002 0121               lcd_printhex(appPages,sizeof(appPages));
; 0002 0122               delay_ms(500);
; 0002 0123             #endif
; 0002 0124         }
; 0002 0125         if(fat_file_next_adr == 0x0FFFFFFFUL){
_0x40027:
_0x40026:
	LDS  R26,_fat_file_next_adr
	LDS  R27,_fat_file_next_adr+1
	LDS  R24,_fat_file_next_adr+2
	LDS  R25,_fat_file_next_adr+3
	CALL SUBOPT_0x7
	BRNE _0x40028
; 0002 0126 
; 0002 0127 
; 0002 0128             if(readbytes >= filesize){
	LDS  R30,_filesize
	LDS  R31,_filesize+1
	LDS  R22,_filesize+2
	LDS  R23,_filesize+3
	CALL SUBOPT_0xF
	CALL __CPD21
	BRSH _0x4000D
; 0002 0129                 break;
; 0002 012A             }
; 0002 012B             else
; 0002 012C             {
; 0002 012D                 /*
; 0002 012E                 if(  WriteFlashPage(0x1EF00, sdBuf)){//;     // Writes testbuffer1 to Flash page 2
; 0002 012F                     #ifdef DEBUGLED
; 0002 0130                     PORTC.5=0;
; 0002 0131                     #endif
; 0002 0132                 }                                          // Function returns TRUE
; 0002 0133                 if(  ReadFlashPage (0x1EF00, testBuf)){//;      // Reads back Flash page 2 to TestBuffer2
; 0002 0134                     #ifdef DEBUGLED
; 0002 0135                     PORTC.6=0;
; 0002 0136                     #endif
; 0002 0137                 }
; 0002 0138                 */
; 0002 0139             }
; 0002 013A 
; 0002 013B         }
; 0002 013C         adr++;
_0x40028:
	CALL SUBOPT_0x17
; 0002 013D     }
	__ADDWRN 16,17,1
	RJMP _0x4000C
_0x4000D:
; 0002 013E     fat_file_adr = fat_file_next_adr;
	LDS  R30,_fat_file_next_adr
	LDS  R31,_fat_file_next_adr+1
	LDS  R22,_fat_file_next_adr+2
	LDS  R23,_fat_file_next_adr+3
	CALL SUBOPT_0x18
; 0002 013F   }
	RJMP _0x40004
_0x40006:
; 0002 0140   while(1);
_0x4002B:
	RJMP _0x4002B
; 0002 0141 }
_0x4002E:
	RJMP _0x4002E
; .FEND

	.DSEG
_0x40003:
	.BYTE 0x14
;
;unsigned char compbuf(const unsigned char *src,unsigned char *dest)
; 0002 0144 {

	.CSEG
_compbuf:
; .FSTART _compbuf
; 0002 0145     while(*src)
	ST   -Y,R27
	ST   -Y,R26
;	*src -> Y+2
;	*dest -> Y+0
_0x4002F:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x40031
; 0002 0146     {
; 0002 0147         if(*src++ != *dest++)
	LD   R0,X+
	STD  Y+2,R26
	STD  Y+2+1,R27
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	CP   R30,R0
	BREQ _0x40032
; 0002 0148             return 0;
	LDI  R30,LOW(0)
	RJMP _0x200000A
; 0002 0149         //src++;dest++;
; 0002 014A         //len--;
; 0002 014B     }
_0x40032:
	RJMP _0x4002F
_0x40031:
; 0002 014C     return 1;
	LDI  R30,LOW(1)
	RJMP _0x200000A
; 0002 014D }
; .FEND
;
;#ifdef DEBUG_ERRSD
;void errorSD(unsigned char err)
;{
;#ifdef DEBUGLED
;    unsigned int repeat=10;
;    do{
;       PORTC &= ~(1<<err);
;       delay_ms(500);
;       PORTC = 0xFF;
;       delay_ms(500);
;    }
;    while(repeat--);
;#endif
;#ifdef DEBUG_LCD
;  char strnum[5];
;    if(err>100){
;       err=100;
;    }
;    itoa(err,strnum);
;    lcd_gotoxy(0,0);
;    lcd_putsf("SD ERROR: ");
;    lcd_puts(strnum);
;    while(1);
;#else
;    app_pointer();
;#endif
;    //while(1);
;}
;#endif
;
;//convert bytes buffer to 32bit UL value
;unsigned long buf2num(unsigned char *buf,unsigned char len)
; 0002 016F {
_buf2num:
; .FSTART _buf2num
; 0002 0170     unsigned long num=0;
; 0002 0171     //unsigned char i;
; 0002 0172     /*
; 0002 0173     if(len>4){
; 0002 0174        len=4;// 4bytes max 32bit UL
; 0002 0175     }
; 0002 0176     */
; 0002 0177     for(;((len>0));len--)
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
;	*buf -> Y+5
;	len -> Y+4
;	num -> Y+0
_0x40034:
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRLO _0x40035
; 0002 0178     {
; 0002 0179         num<<=8;
	CALL SUBOPT_0x5
	LDI  R30,LOW(8)
	CALL __LSLD12
	CALL __PUTD1S0
; 0002 017A         num|=buf[len-1];
	LDD  R30,Y+4
	LDI  R31,0
	SBIW R30,1
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CALL SUBOPT_0x5
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	CALL __PUTD1S0
; 0002 017B     }
	LDD  R30,Y+4
	SUBI R30,LOW(1)
	STD  Y+4,R30
	RJMP _0x40034
_0x40035:
; 0002 017C     return num;
	CALL __GETD1S0
	ADIW R28,7
	RET
; 0002 017D }
; .FEND
;
;
;#ifdef DEBUG_LCD
;lcd_printhex(unsigned long num32, char size){
;    char i,nible;
;    //num32>>=((4-size)*8);//0x12345678 >>24 -> 0x00000012
;    //lcd_putchar(size+'0');
;    for(i=1;i<=(size*2);i++){
;        nible=((num32)>>(32-((4-size)*8)-((i)*4)))&0x0F;
;        if(nible>9){
;          nible-=0x0A;
;          nible+='A';
;        }
;        else{
;          nible+='0';
;        }
;        lcd_putchar(nible);
;    }
;}
;#endif
;
;//fat32 sd initialization 0=sucess, 1,2,3 errors
;unsigned char fat_init(){
; 0002 0194 unsigned char fat_init(){
_fat_init:
; .FSTART _fat_init
; 0002 0195   if((result[0]=SD_init())!=SD_SUCCESS){
	RCALL _SD_init
	STS  _result,R30
	CPI  R30,0
	BREQ _0x40036
; 0002 0196 #ifdef DEBUG_ERRSD
; 0002 0197     errorSD(1);
; 0002 0198 #endif
; 0002 0199     return 1;
	LDI  R30,LOW(1)
	RET
; 0002 019A     //app_pointer();//jump to app 0 on error
; 0002 019B   }
; 0002 019C   #ifdef DEBUG_LCD
; 0002 019D   lcd_putsf("1");
; 0002 019E   delay_ms(500);
; 0002 019F   #endif
; 0002 01A0   // read MBR get FAT start sector
; 0002 01A1   if((result[0]=SD_readSingleBlock(0, sdBuf, &token))!=SD_SUCCESS){
_0x40036:
	CALL SUBOPT_0x1
	CALL SUBOPT_0x19
	RCALL _SD_readSingleBlock
	STS  _result,R30
	CPI  R30,0
	BREQ _0x40037
; 0002 01A2 #ifdef DEBUG_ERRSD
; 0002 01A3     errorSD(2);
; 0002 01A4 #endif
; 0002 01A5     return 2;
	LDI  R30,LOW(2)
	RET
; 0002 01A6     //app_pointer();//jump to app 0 on error
; 0002 01A7   }
; 0002 01A8   #ifdef DEBUG_LCD
; 0002 01A9   lcd_putsf("2");
; 0002 01AA   delay_ms(500);
; 0002 01AB   #endif
; 0002 01AC   adr=buf2num(&sdBuf[445+9],4);//FAT start sector. 1 sector = 512 bytes
_0x40037:
	__POINTW1MN _sdBuf,454
	CALL SUBOPT_0xB
	CALL SUBOPT_0x1A
; 0002 01AD 
; 0002 01AE   //load and read FAT ID (1st) sector. Get FAT info. Secors per Cluster and etc..
; 0002 01AF   if((result[0]=SD_readSingleBlock(adr, sdBuf, &token))!=SD_SUCCESS){
	CALL SUBOPT_0xE
	CPI  R30,0
	BREQ _0x40038
; 0002 01B0     #ifdef DEBUG_ERRSD
; 0002 01B1     errorSD(3);
; 0002 01B2     #endif
; 0002 01B3     return 3;
	LDI  R30,LOW(3)
	RET
; 0002 01B4     //app_pointer();//jump to app 0 on error
; 0002 01B5   }
; 0002 01B6   #ifdef DEBUG_LCD
; 0002 01B7   lcd_putsf("3");
; 0002 01B8   delay_ms(500);
; 0002 01B9   #endif
; 0002 01BA   SectorsPerCluster=sdBuf[0x0D];// 8 sectors per cluster
_0x40038:
	__GETBRMN 8,_sdBuf,13
; 0002 01BB   SectorsPerFat=buf2num(&sdBuf[0x24],4); // 0xF10 for test sdcard
	__POINTW1MN _sdBuf,36
	CALL SUBOPT_0xB
	STS  _SectorsPerFat,R30
	STS  _SectorsPerFat+1,R31
	STS  _SectorsPerFat+2,R22
	STS  _SectorsPerFat+3,R23
; 0002 01BC   Number_of_Reserved_Sectors=buf2num(&sdBuf[0x0E],2); // 0x20 usually
	__POINTW1MN _sdBuf,14
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _buf2num
	STS  _Number_of_Reserved_Sectors,R30
	STS  _Number_of_Reserved_Sectors+1,R31
; 0002 01BD   //read the FAT fils/directories info from Root Directory cluster (usually 2),Number_of_Reserved_Sectors (usually 0x20) ...
; 0002 01BE   //(unsigned long)fat_begin_lba = Partition_LBA_Begin + Number_of_Reserved_Sectors;
; 0002 01BF   fat_begin_lba=adr+Number_of_Reserved_Sectors;//0x20;//first sector of FAT data
	LDS  R26,_adr
	LDS  R27,_adr+1
	LDS  R24,_adr+2
	LDS  R25,_adr+3
	CLR  R22
	CLR  R23
	CALL __ADDD12
	STS  _fat_begin_lba,R30
	STS  _fat_begin_lba+1,R31
	STS  _fat_begin_lba+2,R22
	STS  _fat_begin_lba+3,R23
; 0002 01C0   //(unsigned long)cluster_begin_lba = Partition_LBA_Begin + Number_of_Reserved_Sectors + (Number_of_FATs * Sectors_Per_ ...
; 0002 01C1   //Number_of_FATs always 2. Offset 0x10 8bit
; 0002 01C2   cluster_begin_lba=fat_begin_lba+(2*SectorsPerFat);//number of sector where data begin
	LDS  R30,_SectorsPerFat
	LDS  R31,_SectorsPerFat+1
	LDS  R22,_SectorsPerFat+2
	LDS  R23,_SectorsPerFat+3
	CALL __LSLD1
	RCALL SUBOPT_0x9
	STS  _cluster_begin_lba,R30
	STS  _cluster_begin_lba+1,R31
	STS  _cluster_begin_lba+2,R22
	STS  _cluster_begin_lba+3,R23
; 0002 01C3   //read root dir (sector 2 but always offset 2 too then 0) to find folder 0 FAT reference. and find Flash.dat sector
; 0002 01C4   //lba_addr = cluster_begin_lba + (cluster_number - 2) * sectors_per_cluster;
; 0002 01C5   adr=cluster_begin_lba +(2-2)*SectorsPerCluster;
	CALL SUBOPT_0x1A
; 0002 01C6   //adr*=512UL;
; 0002 01C7   return 0;
	LDI  R30,LOW(0)
	RET
; 0002 01C8 }
; .FEND
;
;//dir open function 0=sucess, 4 error
;unsigned char dir_open(const char *dirname){
; 0002 01CB unsigned char dir_open(const char *dirname){
_dir_open:
; .FSTART _dir_open
; 0002 01CC   unsigned int i,j;
; 0002 01CD   result[1]=0;
	RCALL SUBOPT_0x0
;	*dirname -> Y+4
;	i -> R16,R17
;	j -> R18,R19
	LDI  R30,LOW(0)
	__PUTB1MN _result,1
; 0002 01CE   for(i=0;i<SectorsPerCluster;i++)
	__GETWRN 16,17,0
_0x4003A:
	CALL SUBOPT_0xD
	BRSH _0x4003B
; 0002 01CF   {
; 0002 01D0 
; 0002 01D1       if((result[0]=SD_readSingleBlock(adr, sdBuf, &token))!=SD_SUCCESS){
	CALL SUBOPT_0xE
	CPI  R30,0
	BREQ _0x4003C
; 0002 01D2     #ifdef DEBUG_ERRSD
; 0002 01D3         errorSD(4);
; 0002 01D4     #endif
; 0002 01D5         return 4;
	LDI  R30,LOW(4)
	CALL __LOADLOCR4
	RJMP _0x2000004
; 0002 01D6         //app_pointer();//jump to app 0 on error
; 0002 01D7       }
; 0002 01D8       for(j=0;j<(16);j++)//search 16*32bit records in 512bytes sector
_0x4003C:
	__GETWRN 18,19,0
_0x4003E:
	__CPWRN 18,19,16
	BRSH _0x4003F
; 0002 01D9       {
; 0002 01DA            //if((result[1]=compbuf("0          ",&sdBuf[j*32]))!=0)
; 0002 01DB            if((result[1]=compbuf(dirname,&sdBuf[j*32]))!=0)
	CALL SUBOPT_0x1B
	CPI  R30,0
	BRNE _0x4003F
; 0002 01DC            {
; 0002 01DD                 break;//dir 0 is found
; 0002 01DE            }
; 0002 01DF       }
	__ADDWRN 18,19,1
	RJMP _0x4003E
_0x4003F:
; 0002 01E0       if(result[1]!=0)
	__GETB1MN _result,1
	CPI  R30,0
	BREQ _0x40041
; 0002 01E1       {
; 0002 01E2         fat_file_adr =(unsigned long)sdBuf[j*32+0x14]<<16;
	CALL SUBOPT_0x1C
	__ADDW1MN _sdBuf,20
	LD   R30,Z
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1D
; 0002 01E3         fat_file_adr|=(unsigned long)sdBuf[j*32+0x1A];
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x18
; 0002 01E4         break;
	RJMP _0x4003B
; 0002 01E5       }
; 0002 01E6       else
_0x40041:
; 0002 01E7         adr++;
	CALL SUBOPT_0x17
; 0002 01E8   }
	__ADDWRN 16,17,1
	RJMP _0x4003A
_0x4003B:
; 0002 01E9   if(result[1]==0){
	__GETB1MN _result,1
	CPI  R30,0
	BRNE _0x40043
; 0002 01EA      //app_pointer();//jump to app on error dir not found
; 0002 01EB      return 5; //jump to app on error dir not found
	LDI  R30,LOW(5)
	CALL __LOADLOCR4
	RJMP _0x2000004
; 0002 01EC   }
; 0002 01ED   #ifdef DEBUG_LCD
; 0002 01EE   lcd_putsf("4");//dir found ok
; 0002 01EF   delay_ms(500);
; 0002 01F0   #endif
; 0002 01F1   return 0;
_0x40043:
	LDI  R30,LOW(0)
	CALL __LOADLOCR4
	RJMP _0x2000004
; 0002 01F2 }
; .FEND
;
;//file open function 0=sucess, 5,6 errors
;unsigned char file_open_update(const char *filename){
; 0002 01F5 unsigned char file_open_update(const char *filename){
_file_open_update:
; .FSTART _file_open_update
; 0002 01F6   unsigned int i,j;
; 0002 01F7   adr=cluster_begin_lba +(fat_file_adr-2)*SectorsPerCluster;
	RCALL SUBOPT_0x0
;	*filename -> Y+4
;	i -> R16,R17
;	j -> R18,R19
	RCALL SUBOPT_0xC
; 0002 01F8   for(i=0;i<SectorsPerCluster;i++)
_0x40045:
	RCALL SUBOPT_0xD
	BRSH _0x40046
; 0002 01F9   {
; 0002 01FA 
; 0002 01FB       if((result[0]=SD_readSingleBlock(adr, sdBuf, &token))!=SD_SUCCESS){
	RCALL SUBOPT_0xE
	CPI  R30,0
	BREQ _0x40047
; 0002 01FC     #ifdef DEBUG_ERRSD
; 0002 01FD         errorSD(6);
; 0002 01FE     #endif
; 0002 01FF         return 6;
	LDI  R30,LOW(6)
	CALL __LOADLOCR4
	RJMP _0x2000004
; 0002 0200         //app_pointer();//jump to app on error
; 0002 0201       }
; 0002 0202       for(j=0;j<(16);j++)//search 16 * 32 filename records
_0x40047:
	__GETWRN 18,19,0
_0x40049:
	__CPWRN 18,19,16
	BRSH _0x4004A
; 0002 0203       {
; 0002 0204            //if((result[1]=compbuf("UPDATE",&sdBuf[j*32]))!=0)
; 0002 0205            if((result[1]=compbuf(filename,&sdBuf[j*32]))!=0)
	CALL SUBOPT_0x1B
	CPI  R30,0
	BRNE _0x4004A
; 0002 0206            {
; 0002 0207                 break;//file Flash... is found
; 0002 0208            }
; 0002 0209       }
	__ADDWRN 18,19,1
	RJMP _0x40049
_0x4004A:
; 0002 020A       if(result[1]!=0)
	__GETB1MN _result,1
	CPI  R30,0
	BREQ _0x4004C
; 0002 020B       {
; 0002 020C         //read 1st number of cluster where data placed
; 0002 020D         fat_file_adr =(unsigned long)sdBuf[j*32+0x14]<<16;
	CALL SUBOPT_0x1C
	__ADDW1MN _sdBuf,20
	LD   R30,Z
	RCALL SUBOPT_0x15
	CALL SUBOPT_0x1D
; 0002 020E         fat_file_adr|=(unsigned long)sdBuf[j*32+0x1A];
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1D
; 0002 020F         filesize = buf2num(&sdBuf[j*32+0x1C],8);
	__ADDW1MN _sdBuf,28
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	RCALL _buf2num
	STS  _filesize,R30
	STS  _filesize+1,R31
	STS  _filesize+2,R22
	STS  _filesize+3,R23
; 0002 0210         break;
	RJMP _0x40046
; 0002 0211       }
; 0002 0212       else
_0x4004C:
; 0002 0213         adr++;
	RCALL SUBOPT_0x17
; 0002 0214   }
	__ADDWRN 16,17,1
	RJMP _0x40045
_0x40046:
; 0002 0215   if(result[1]==0){// error if file not found
	__GETB1MN _result,1
	CPI  R30,0
	BRNE _0x4004E
; 0002 0216     #ifdef DEBUG_ERRSD
; 0002 0217     errorSD(6);
; 0002 0218     #endif
; 0002 0219     return 6;
	LDI  R30,LOW(6)
	CALL __LOADLOCR4
	RJMP _0x2000004
; 0002 021A     //app_pointer();//jump to app on error
; 0002 021B   }
; 0002 021C   #ifdef DEBUG_LCD
; 0002 021D   lcd_putsf("5");//file found ok
; 0002 021E   delay_ms(500);
; 0002 021F   #endif
; 0002 0220 
; 0002 0221 
; 0002 0222   //check UPDATE0 or UPDATE1...UPDATE9
; 0002 0223   if((sdBuf[j*32+6])=='0'){
_0x4004E:
	CALL SUBOPT_0x1C
	__ADDW1MN _sdBuf,6
	LD   R26,Z
	CPI  R26,LOW(0x30)
	BRNE _0x4004F
; 0002 0224     //return 1;//error if update reach 0
; 0002 0225     #ifdef DEBUG_ERRSD
; 0002 0226     errorSD(7);
; 0002 0227     #endif
; 0002 0228     #ifdef DEBUG_LCD
; 0002 0229     lcd_putsf("ret0");
; 0002 022A     delay_ms(500);
; 0002 022B     #endif
; 0002 022C     return 7;  //if no more retry
	LDI  R30,LOW(7)
	CALL __LOADLOCR4
	RJMP _0x2000004
; 0002 022D     //app_pointer();//jump to app if no more retry
; 0002 022E   }
; 0002 022F   else if(((sdBuf[j*32+6])>'0')||((sdBuf[j*32+6])<='9')){
_0x4004F:
	CALL SUBOPT_0x1C
	__ADDW1MN _sdBuf,6
	LD   R26,Z
	CPI  R26,LOW(0x31)
	BRSH _0x40052
	CPI  R26,LOW(0x3A)
	BRSH _0x40051
_0x40052:
; 0002 0230     sdBuf[j*32+6]--;//decrement 1 retry.
	RCALL SUBOPT_0x1C
	__ADDW1MN _sdBuf,6
	MOVW R26,R30
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
; 0002 0231   }
; 0002 0232   else{
	RJMP _0x40054
_0x40051:
; 0002 0233     sdBuf[j*32+6]='9';
	RCALL SUBOPT_0x1C
	__ADDW1MN _sdBuf,6
	LDI  R26,LOW(57)
	STD  Z+0,R26
; 0002 0234   }
_0x40054:
; 0002 0235   result[0]=SD_writeSingleBlock(adr, sdBuf, &token);//save new UPDATE(num) filename.
	LDS  R30,_adr
	LDS  R31,_adr+1
	LDS  R22,_adr+2
	LDS  R23,_adr+3
	CALL __PUTPARD1
	RCALL SUBOPT_0x19
	RCALL _SD_writeSingleBlock
	STS  _result,R30
; 0002 0236   #ifdef DEBUG_LCD
; 0002 0237   lcd_putsf("7");
; 0002 0238   delay_ms(500);
; 0002 0239   #endif
; 0002 023A   return 0;
	LDI  R30,LOW(0)
	CALL __LOADLOCR4
	RJMP _0x2000004
; 0002 023B }
; .FEND
;#include "spi_sdcard.h"
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
;
;
;void SPI_init()
; 0003 0007 {

	.CSEG
_SPI_init:
; .FSTART _SPI_init
; 0003 0008     // set CS, MOSI and SCK to output
; 0003 0009     DDR_SPI = (1 << CS) | (1 << MOSI) | (1 << SCK);
	LDI  R30,LOW(7)
	OUT  0x17,R30
; 0003 000A     PORT_SPI|=(1 << CS);
	SBI  0x18,0
; 0003 000B     // enable pull up resistor in MISO
; 0003 000C     DDR_SPI &= ~(1 << MISO);
	CBI  0x17,3
; 0003 000D     PORT_SPI &= ~(1 << MISO);
	CBI  0x18,3
; 0003 000E     //PORT_SPI |= (1 << MISO);
; 0003 000F 
; 0003 0010     // enable SPI, set as master, and clock to fosc/128
; 0003 0011     SPCR = (1 << SPE) | (1 << MSTR) | (0 << SPR1) | (0 << SPR0);
	LDI  R30,LOW(80)
	OUT  0xD,R30
; 0003 0012 }
	RET
; .FEND
;
;unsigned char SPI_transfer(unsigned char data)
; 0003 0015 {
_SPI_transfer:
; .FSTART _SPI_transfer
; 0003 0016     // load data into register
; 0003 0017     SPDR = data;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0003 0018 
; 0003 0019     // Wait for transmission complete
; 0003 001A     while(!(SPSR & (1 << SPIF)));
_0x60003:
	SBIS 0xE,7
	RJMP _0x60003
; 0003 001B 
; 0003 001C     // return SPDR
; 0003 001D     return SPDR;
	IN   R30,0xF
	ADIW R28,1
	RET
; 0003 001E }
; .FEND
;
;
;void SD_powerUpSeq()
; 0003 0022 {
_SD_powerUpSeq:
; .FSTART _SD_powerUpSeq
; 0003 0023     unsigned char i;
; 0003 0024 
; 0003 0025     SPI_init();
	ST   -Y,R17
;	i -> R17
	RCALL _SPI_init
; 0003 0026 
; 0003 0027     // make sure card is deselected
; 0003 0028     CS_DISABLE();
	SBI  0x18,0
; 0003 0029 
; 0003 002A     // give SD card time to power up
; 0003 002B     delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0003 002C 
; 0003 002D     // send 80 clock cycles to synchronize
; 0003 002E     for(i = 0; i < 10; i++)
	LDI  R17,LOW(0)
_0x60007:
	CPI  R17,10
	BRSH _0x60008
; 0003 002F         SPI_transfer(0xFF);
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
	SUBI R17,-1
	RJMP _0x60007
_0x60008:
; 0003 0032 PORTB |= (1 << 0       );
	RCALL SUBOPT_0x1F
; 0003 0033     SPI_transfer(0xFF);
; 0003 0034 }
	RJMP _0x2000007
; .FEND
;
;unsigned char SD_command(unsigned char cmd, unsigned long arg, unsigned char crc)
; 0003 0037 {
_SD_command:
; .FSTART _SD_command
; 0003 0038     unsigned char res,count;
; 0003 0039     // transmit command to sd card
; 0003 003A     SPI_transfer(cmd|0x40);
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	cmd -> Y+7
;	arg -> Y+3
;	crc -> Y+2
;	res -> R17
;	count -> R16
	LDD  R30,Y+7
	ORI  R30,0x40
	RCALL SUBOPT_0x20
; 0003 003B 
; 0003 003C     // transmit argument
; 0003 003D     SPI_transfer((unsigned char)(arg >> 24));
	LDI  R30,LOW(24)
	CALL __LSRD12
	MOV  R26,R30
	RCALL _SPI_transfer
; 0003 003E     SPI_transfer((unsigned char)(arg >> 16));
	__GETD1S 3
	CALL __LSRD16
	RCALL SUBOPT_0x20
; 0003 003F     SPI_transfer((unsigned char)(arg >> 8));
	LDI  R30,LOW(8)
	CALL __LSRD12
	MOV  R26,R30
	RCALL _SPI_transfer
; 0003 0040     SPI_transfer((unsigned char)(arg));
	LDD  R26,Y+3
	RCALL _SPI_transfer
; 0003 0041 
; 0003 0042     // transmit crc
; 0003 0043     SPI_transfer(crc|0x01);
	LDD  R30,Y+2
	ORI  R30,1
	MOV  R26,R30
	RCALL _SPI_transfer
; 0003 0044 
; 0003 0045     //wait response R1
; 0003 0046     res = SD_readRes1();
	RCALL _SD_readRes1
	MOV  R17,R30
; 0003 0047     /*
; 0003 0048     do {
; 0003 0049      res=SPI_transfer(0xFF);;
; 0003 004A      count++;
; 0003 004B     } while ( ((res&0x80)!=0x00)&&(count<0xff) );
; 0003 004C     */
; 0003 004D     return res;
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
; 0003 004E }
; .FEND
;
;
;unsigned char SD_readRes1()
; 0003 0052 {
_SD_readRes1:
; .FSTART _SD_readRes1
; 0003 0053     unsigned char res1;
; 0003 0054     unsigned int i = 0;
; 0003 0055 
; 0003 0056     // keep polling until actual data received
; 0003 0057     //while((res1 = SPI_transfer(0xFF)) == 0xFF)
; 0003 0058     while(((res1 = SPI_transfer(0xFF))&0x80) != 0x00)
	CALL __SAVELOCR4
;	res1 -> R17
;	i -> R18,R19
	__GETWRN 18,19,0
_0x60009:
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
	MOV  R17,R30
	ANDI R30,LOW(0x80)
	BREQ _0x6000B
; 0003 0059     {
; 0003 005A         i++;
	__ADDWRN 18,19,1
; 0003 005B 
; 0003 005C         // if no data received for (254)8 bytes, break
; 0003 005D         if(i > 0x1FF) break;
	__CPWRN 18,19,512
	BRLO _0x60009
; 0003 005E     }
_0x6000B:
; 0003 005F 
; 0003 0060     return res1;
	MOV  R30,R17
	CALL __LOADLOCR4
_0x200000A:
	ADIW R28,4
	RET
; 0003 0061 }
; .FEND
;
;unsigned char SD_goIdleState()
; 0003 0064 {
_SD_goIdleState:
; .FSTART _SD_goIdleState
; 0003 0065     unsigned char res1;
; 0003 0066     // assert chip select
; 0003 0067     SPI_transfer(0xFF);
	RCALL SUBOPT_0x21
;	res1 -> R17
; 0003 0068     CS_ENABLE();
; 0003 0069     //SPI_transfer(0xFF);
; 0003 006A 
; 0003 006B     // send CMD0
; 0003 006C     res1 = SD_command(CMD0, CMD0_ARG, CMD0_CRC);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL SUBOPT_0x1
	LDI  R26,LOW(148)
	RJMP _0x2000006
; 0003 006D 
; 0003 006E     // read response
; 0003 006F     //res1 = SD_readRes1();
; 0003 0070 
; 0003 0071     // deassert chip select
; 0003 0072     SPI_transfer(0xFF);
; 0003 0073     CS_DISABLE();
; 0003 0074     SPI_transfer(0xFF);
; 0003 0075 
; 0003 0076     return res1;
; 0003 0077 }
; .FEND
;
;void SD_readRes7(unsigned char *res)
; 0003 007A {
_SD_readRes7:
; .FSTART _SD_readRes7
; 0003 007B     // read response 1 in R7
; 0003 007C     //res[0] = SD_readRes1();
; 0003 007D 
; 0003 007E     // if error reading R1, return
; 0003 007F     if(res[0] > 1) return;
	ST   -Y,R27
	ST   -Y,R26
;	*res -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	LD   R26,X
	CPI  R26,LOW(0x2)
	BRSH _0x2000009
; 0003 0080 
; 0003 0081     // read remaining bytes
; 0003 0082     res[1] = SPI_transfer(0xFF);
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
	__PUTB1SNS 0,1
; 0003 0083     res[2] = SPI_transfer(0xFF);
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
	__PUTB1SNS 0,2
; 0003 0084     res[3] = SPI_transfer(0xFF);
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
	__PUTB1SNS 0,3
; 0003 0085     res[4] = SPI_transfer(0xFF);
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
	__PUTB1SNS 0,4
; 0003 0086 }
	RJMP _0x2000009
; .FEND
;
;void SD_sendIfCond(unsigned char *res)
; 0003 0089 {
_SD_sendIfCond:
; .FSTART _SD_sendIfCond
; 0003 008A     // assert chip select
; 0003 008B     SPI_transfer(0xFF);
	RCALL SUBOPT_0x22
;	*res -> Y+0
; 0003 008C     CS_ENABLE();
; 0003 008D     //SPI_transfer(0xFF);
; 0003 008E 
; 0003 008F     // send CMD8
; 0003 0090     res[0]=SD_command(CMD8, CMD8_ARG, CMD8_CRC);
	LDI  R30,LOW(8)
	ST   -Y,R30
	__GETD1N 0x1AA
	CALL __PUTPARD1
	LDI  R26,LOW(134)
	RJMP _0x2000008
; 0003 0091 
; 0003 0092     // read response
; 0003 0093     SD_readRes7(res);
; 0003 0094 
; 0003 0095     // deassert chip select
; 0003 0096     SPI_transfer(0xFF);
; 0003 0097     CS_DISABLE();
; 0003 0098     SPI_transfer(0xFF);
; 0003 0099 }
; .FEND
;
;/*
;void SD_readRes3_7(unsigned char *res)
;{
;    // read R1
;    //res[0] = SD_readRes1();
;
;    // if error reading R1, return
;    if(res[0] > 1) return;
;
;    // read remaining bytes
;    res[1] = SPI_transfer(0xFF);
;    res[2] = SPI_transfer(0xFF);
;    res[3] = SPI_transfer(0xFF);
;    res[4] = SPI_transfer(0xFF);
;}
;*/
;
;void SD_readOCR(unsigned char *res)
; 0003 00AD {
_SD_readOCR:
; .FSTART _SD_readOCR
; 0003 00AE     // assert chip select
; 0003 00AF     SPI_transfer(0xFF);
	RCALL SUBOPT_0x22
;	*res -> Y+0
; 0003 00B0     CS_ENABLE();
; 0003 00B1     //SPI_transfer(0xFF);
; 0003 00B2 
; 0003 00B3     // send CMD58
; 0003 00B4     res[0] = SD_command(CMD58, CMD58_ARG, CMD58_CRC);
	LDI  R30,LOW(58)
	ST   -Y,R30
	RCALL SUBOPT_0x1
	LDI  R26,LOW(0)
_0x2000008:
	RCALL _SD_command
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
; 0003 00B5 
; 0003 00B6     // read response
; 0003 00B7     //SD_readRes3_7(res);
; 0003 00B8     SD_readRes7(res);
	RCALL _SD_readRes7
; 0003 00B9 
; 0003 00BA     // deassert chip select
; 0003 00BB     SPI_transfer(0xFF);
	RCALL SUBOPT_0x23
; 0003 00BC     CS_DISABLE();
; 0003 00BD     SPI_transfer(0xFF);
; 0003 00BE }
_0x2000009:
	ADIW R28,2
	RET
; .FEND
;
;unsigned char SD_sendApp()
; 0003 00C1 {
_SD_sendApp:
; .FSTART _SD_sendApp
; 0003 00C2     unsigned char res1;
; 0003 00C3     // assert chip select
; 0003 00C4     SPI_transfer(0xFF);
	RCALL SUBOPT_0x21
;	res1 -> R17
; 0003 00C5     CS_ENABLE();
; 0003 00C6     //SPI_transfer(0xFF);
; 0003 00C7 
; 0003 00C8     // send CMD0
; 0003 00C9     res1 = SD_command(CMD55, CMD55_ARG, CMD55_CRC);
	LDI  R30,LOW(55)
	ST   -Y,R30
	__GETD1N 0x0
	RJMP _0x2000005
; 0003 00CA 
; 0003 00CB     // read response
; 0003 00CC     //res1 = SD_readRes1();
; 0003 00CD 
; 0003 00CE     // deassert chip select
; 0003 00CF     SPI_transfer(0xFF);
; 0003 00D0     CS_DISABLE();
; 0003 00D1     SPI_transfer(0xFF);
; 0003 00D2 
; 0003 00D3     return res1;
; 0003 00D4 }
; .FEND
;
;unsigned char SD_sendOpCond()
; 0003 00D7 {
_SD_sendOpCond:
; .FSTART _SD_sendOpCond
; 0003 00D8     unsigned char res1;
; 0003 00D9     // assert chip select
; 0003 00DA     SPI_transfer(0xFF);
	RCALL SUBOPT_0x21
;	res1 -> R17
; 0003 00DB     CS_ENABLE();
; 0003 00DC     //SPI_transfer(0xFF);
; 0003 00DD 
; 0003 00DE     // send CMD0
; 0003 00DF     res1 =  SD_command(ACMD41, ACMD41_ARG, ACMD41_CRC);
	LDI  R30,LOW(41)
	ST   -Y,R30
	__GETD1N 0x40000000
_0x2000005:
	CALL __PUTPARD1
	LDI  R26,LOW(0)
_0x2000006:
	RCALL _SD_command
	MOV  R17,R30
; 0003 00E0 
; 0003 00E1     // read response
; 0003 00E2     //res1 = SD_readRes1();
; 0003 00E3 
; 0003 00E4     // deassert chip select
; 0003 00E5     SPI_transfer(0xFF);
	RCALL SUBOPT_0x23
; 0003 00E6     CS_DISABLE();
; 0003 00E7     SPI_transfer(0xFF);
; 0003 00E8 
; 0003 00E9     return res1;
	MOV  R30,R17
_0x2000007:
	LD   R17,Y+
	RET
; 0003 00EA }
; .FEND
;
;unsigned char SD_init()
; 0003 00ED {
_SD_init:
; .FSTART _SD_init
; 0003 00EE     unsigned char res[5], cmdAttempts = 0;
; 0003 00EF 
; 0003 00F0     SD_powerUpSeq();
	SBIW R28,5
	ST   -Y,R17
;	res -> Y+1
;	cmdAttempts -> R17
	LDI  R17,0
	RCALL _SD_powerUpSeq
; 0003 00F1 
; 0003 00F2     // command card to idle
; 0003 00F3     while((res[0] = SD_goIdleState()) != 0x01)
_0x6000E:
	RCALL _SD_goIdleState
	STD  Y+1,R30
	CPI  R30,LOW(0x1)
	BREQ _0x60010
; 0003 00F4     {
; 0003 00F5         cmdAttempts++;
	SUBI R17,-1
; 0003 00F6         if(cmdAttempts > 100) return SD_ERROR;
	CPI  R17,101
	BRLO _0x60011
	LDI  R30,LOW(1)
	RJMP _0x2000003
; 0003 00F7     }
_0x60011:
	RJMP _0x6000E
_0x60010:
; 0003 00F8 
; 0003 00F9     // send interface conditions
; 0003 00FA     SD_sendIfCond(res);
	MOVW R26,R28
	ADIW R26,1
	RCALL _SD_sendIfCond
; 0003 00FB     if(res[0] != 0x01)
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BREQ _0x60012
; 0003 00FC     {
; 0003 00FD         return SD_ERROR;
	LDI  R30,LOW(1)
	RJMP _0x2000003
; 0003 00FE     }
; 0003 00FF 
; 0003 0100     // check echo pattern
; 0003 0101     if(res[4] != 0xAA)
_0x60012:
	LDD  R26,Y+5
	CPI  R26,LOW(0xAA)
	BREQ _0x60013
; 0003 0102     {
; 0003 0103         return SD_ERROR;
	LDI  R30,LOW(1)
	RJMP _0x2000003
; 0003 0104     }
; 0003 0105 
; 0003 0106     // attempt to initialize card
; 0003 0107     cmdAttempts = 0;
_0x60013:
	LDI  R17,LOW(0)
; 0003 0108     do
_0x60015:
; 0003 0109     {
; 0003 010A         if(cmdAttempts > 100) return SD_ERROR;
	CPI  R17,101
	BRLO _0x60017
	LDI  R30,LOW(1)
	RJMP _0x2000003
; 0003 010B 
; 0003 010C         // send app cmd
; 0003 010D         res[0] = SD_sendApp();
_0x60017:
	RCALL _SD_sendApp
	STD  Y+1,R30
; 0003 010E 
; 0003 010F         // if no error in response
; 0003 0110         if(res[0] < 2)
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRSH _0x60018
; 0003 0111         {
; 0003 0112             res[0] = SD_sendOpCond();
	RCALL _SD_sendOpCond
	STD  Y+1,R30
; 0003 0113         }
; 0003 0114 
; 0003 0115         // wait
; 0003 0116         if(res[0] != SD_READY)
_0x60018:
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x60019
; 0003 0117             delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0003 0118 
; 0003 0119         cmdAttempts++;
_0x60019:
	SUBI R17,-1
; 0003 011A     }
; 0003 011B     while(res[0] != SD_READY);
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x60015
; 0003 011C 
; 0003 011D     // read OCR
; 0003 011E     SD_readOCR(res);
	MOVW R26,R28
	ADIW R26,1
	RCALL _SD_readOCR
; 0003 011F 
; 0003 0120     // check card is ready
; 0003 0121     if(!(res[1] & 0x80)) return SD_ERROR;
	LDD  R30,Y+2
	ANDI R30,LOW(0x80)
	BRNE _0x6001A
	LDI  R30,LOW(1)
	RJMP _0x2000003
; 0003 0122 
; 0003 0123     return SD_SUCCESS;
_0x6001A:
	LDI  R30,LOW(0)
_0x2000003:
	LDD  R17,Y+0
_0x2000004:
	ADIW R28,6
	RET
; 0003 0124 }
; .FEND
;
;#define CMD17                   17
;#define CMD17_CRC               0x00
;#define SD_MAX_READ_ATTEMPTS    1563
;
;/*******************************************************************************
; Read single 512 byte block
; token = 0xFE - Successful read
; token = 0x0X - Data error
; token = 0xFF - Timeout
;*******************************************************************************/
;unsigned char SD_readSingleBlock(unsigned long addr, unsigned char *buf, unsigned char *token)
; 0003 0131 {
_SD_readSingleBlock:
; .FSTART _SD_readSingleBlock
; 0003 0132     unsigned char res1, read;
; 0003 0133     unsigned int i, readAttempts;
; 0003 0134     #asm("wdr")
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
;	addr -> Y+10
;	*buf -> Y+8
;	*token -> Y+6
;	res1 -> R17
;	read -> R16
;	i -> R18,R19
;	readAttempts -> R20,R21
	wdr
; 0003 0135     addr*=512UL;
	RCALL SUBOPT_0x24
; 0003 0136     // set token to none
; 0003 0137     *token = 0xFF;
; 0003 0138 
; 0003 0139     // assert chip select
; 0003 013A     SPI_transfer(0xFF);
; 0003 013B     CS_ENABLE();
; 0003 013C     //SPI_transfer(0xFF);
; 0003 013D 
; 0003 013E     // send CMD17
; 0003 013F     res1 = SD_command(CMD17, addr, CMD17_CRC);
	LDI  R30,LOW(17)
	RCALL SUBOPT_0x25
; 0003 0140 
; 0003 0141     // read R1
; 0003 0142     //res1 = SD_readRes1();
; 0003 0143 
; 0003 0144     // if response received from card
; 0003 0145     if(res1 != 0xFF)
	CPI  R17,255
	BREQ _0x6001B
; 0003 0146     {
; 0003 0147         // wait for a response token (timeout = 100ms)
; 0003 0148         readAttempts = 0;
	__GETWRN 20,21,0
; 0003 0149         while(++readAttempts != SD_MAX_READ_ATTEMPTS)
_0x6001C:
	MOVW R30,R20
	ADIW R30,1
	MOVW R20,R30
	CPI  R30,LOW(0x61B)
	LDI  R26,HIGH(0x61B)
	CPC  R31,R26
	BREQ _0x6001E
; 0003 014A             if((read = SPI_transfer(0xFF)) != 0xFF) break;
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
	MOV  R16,R30
	CPI  R30,LOW(0xFF)
	BREQ _0x6001C
; 0003 014B 
; 0003 014C         // if response token is 0xFE
; 0003 014D         if(read == 0xFE)
_0x6001E:
	CPI  R16,254
	BRNE _0x60020
; 0003 014E         {
; 0003 014F             // read 512 byte block
; 0003 0150             for(i = 0; i < 512; i++) *buf++ = SPI_transfer(0xFF);
	__GETWRN 18,19,0
_0x60022:
	__CPWRN 18,19,512
	BRSH _0x60023
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	PUSH R31
	PUSH R30
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
	POP  R26
	POP  R27
	ST   X,R30
	__ADDWRN 18,19,1
	RJMP _0x60022
_0x60023:
; 0003 0153 SPI_transfer(0xFF);
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
; 0003 0154             SPI_transfer(0xFF);
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
; 0003 0155         }
; 0003 0156 
; 0003 0157         // set token to card response
; 0003 0158         *token = read;
_0x60020:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R16
; 0003 0159     }
; 0003 015A 
; 0003 015B     // deassert chip select
; 0003 015C     SPI_transfer(0xFF);
_0x6001B:
	RCALL SUBOPT_0x23
; 0003 015D     CS_DISABLE();
; 0003 015E     SPI_transfer(0xFF);
; 0003 015F     if(read==0xFE)
	CPI  R16,254
	BRNE _0x60024
; 0003 0160         return res1;
	RJMP _0x2000002
; 0003 0161     else
_0x60024:
; 0003 0162         return SD_ERROR;
	LDI  R30,LOW(1)
	RJMP _0x2000001
; 0003 0163 }
; .FEND
;
;#define SD_BLOCK_LEN            512
;#define SD_START_TOKEN          0xFE
;#define CMD24_CRC           0x00
;#define CMD24                   24
;#define CMD24_ARG               0x00
;#define SD_MAX_WRITE_ATTEMPTS   3907
;/*******************************************************************************
; Write single 512 byte block
; token = 0x00 - busy timeout
; token = 0x05 - data accepted
; token = 0xFF - response timeout
;*******************************************************************************/
;
;unsigned char SD_writeSingleBlock(unsigned long addr, unsigned char *buf, unsigned char *token)
; 0003 0173 {
_SD_writeSingleBlock:
; .FSTART _SD_writeSingleBlock
; 0003 0174     unsigned char res1, read;
; 0003 0175     unsigned int i, readAttempts;
; 0003 0176     #asm("wdr")
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
;	addr -> Y+10
;	*buf -> Y+8
;	*token -> Y+6
;	res1 -> R17
;	read -> R16
;	i -> R18,R19
;	readAttempts -> R20,R21
	wdr
; 0003 0177     addr*=512UL;
	RCALL SUBOPT_0x24
; 0003 0178     // set token to none
; 0003 0179     *token = 0xFF;
; 0003 017A 
; 0003 017B     // assert chip select
; 0003 017C     SPI_transfer(0xFF);
; 0003 017D     CS_ENABLE();
; 0003 017E     SPI_transfer(0xFF);
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
; 0003 017F 
; 0003 0180     // send CMD24
; 0003 0181     res1=SD_command(CMD24, addr, CMD24_CRC);
	LDI  R30,LOW(24)
	RCALL SUBOPT_0x25
; 0003 0182 
; 0003 0183     // read response
; 0003 0184     //res1 = SD_readRes1();
; 0003 0185 
; 0003 0186     // if no error
; 0003 0187     if(res1 == SD_READY)
	CPI  R17,0
	BRNE _0x60026
; 0003 0188     {
; 0003 0189         // send start token
; 0003 018A         SPI_transfer(SD_START_TOKEN);
	LDI  R26,LOW(254)
	RCALL _SPI_transfer
; 0003 018B 
; 0003 018C         // write buffer to card
; 0003 018D         for(i = 0; i < SD_BLOCK_LEN; i++) SPI_transfer(buf[i]);
	__GETWRN 18,19,0
_0x60028:
	__CPWRN 18,19,512
	BRSH _0x60029
	MOVW R30,R18
	RCALL SUBOPT_0x3
	LD   R26,X
	RCALL _SPI_transfer
	__ADDWRN 18,19,1
	RJMP _0x60028
_0x60029:
; 0003 0190 readAttempts = 0;
	__GETWRN 20,21,0
; 0003 0191         while(++readAttempts != SD_MAX_WRITE_ATTEMPTS)
_0x6002A:
	RCALL SUBOPT_0x26
	BREQ _0x6002C
; 0003 0192             if((read = SPI_transfer(0xFF)) != 0xFF) { *token = 0xFF; break; }
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
	MOV  R16,R30
	CPI  R30,LOW(0xFF)
	BREQ _0x6002D
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(255)
	ST   X,R30
	RJMP _0x6002C
; 0003 0193 
; 0003 0194         // if data accepted
; 0003 0195         if((read & 0x1F) == 0x05)
_0x6002D:
	RJMP _0x6002A
_0x6002C:
	MOV  R30,R16
	ANDI R30,LOW(0x1F)
	CPI  R30,LOW(0x5)
	BRNE _0x6002E
; 0003 0196         {
; 0003 0197             // set token to data accepted
; 0003 0198             *token = 0x05;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(5)
	ST   X,R30
; 0003 0199 
; 0003 019A             // wait for write to finish (timeout = 250ms)
; 0003 019B             readAttempts = 0;
	__GETWRN 20,21,0
; 0003 019C             while(SPI_transfer(0xFF) == 0x00){
_0x6002F:
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
	CPI  R30,0
	BRNE _0x60031
; 0003 019D                 if(++readAttempts == SD_MAX_WRITE_ATTEMPTS){
	RCALL SUBOPT_0x26
	BRNE _0x60032
; 0003 019E                     *token = 0x00;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
; 0003 019F                     break;
	RJMP _0x60031
; 0003 01A0                 }
; 0003 01A1             }
_0x60032:
	RJMP _0x6002F
_0x60031:
; 0003 01A2         }
; 0003 01A3     }
_0x6002E:
; 0003 01A4 
; 0003 01A5     // deassert chip select
; 0003 01A6     SPI_transfer(0xFF);
_0x60026:
	RCALL SUBOPT_0x23
; 0003 01A7     CS_DISABLE();
; 0003 01A8     SPI_transfer(0xFF);
; 0003 01A9 
; 0003 01AA     return res1;
_0x2000002:
	MOV  R30,R17
_0x2000001:
	CALL __LOADLOCR6
	ADIW R28,14
	RET
; 0003 01AB }
; .FEND

	.DSEG
_result:
	.BYTE 0x5
_sdBuf:
	.BYTE 0x200
_appStartAdr:
	.BYTE 0x4
_adr:
	.BYTE 0x4
_SectorsPerFat:
	.BYTE 0x4
_fat_begin_lba:
	.BYTE 0x4
_cluster_begin_lba:
	.BYTE 0x4
_fat_file_adr:
	.BYTE 0x4
_fat_file_next_adr:
	.BYTE 0x4
_filesize:
	.BYTE 0x4
_readbytes:
	.BYTE 0x4
_bytesChecksum:
	.BYTE 0x2
_checksumCnt:
	.BYTE 0x2
_Number_of_Reserved_Sectors:
	.BYTE 0x2
_app_pointer:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	__GETD1N 0x0
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	__GETD2N 0x1EF00
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CALL __PUTPARD2
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDS  R26,_fat_file_adr
	LDS  R27,_fat_file_adr+1
	LDS  R24,_fat_file_adr+2
	LDS  R25,_fat_file_adr+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	__CPD2N 0xFFFFFFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	LDS  R30,_fat_file_adr
	LDS  R31,_fat_file_adr+1
	LDS  R22,_fat_file_adr+2
	LDS  R23,_fat_file_adr+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	LDS  R26,_fat_begin_lba
	LDS  R27,_fat_begin_lba+1
	LDS  R24,_fat_begin_lba+2
	LDS  R25,_fat_begin_lba+3
	CALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xA:
	CALL __PUTPARD1
	LDI  R30,LOW(_sdBuf)
	LDI  R31,HIGH(_sdBuf)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	RCALL _SD_readSingleBlock
	STS  _result,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	JMP  _buf2num

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xC:
	RCALL SUBOPT_0x8
	__SUBD1N 2
	MOVW R26,R30
	MOVW R24,R22
	MOV  R30,R8
	LDI  R31,0
	CALL __CWD1
	CALL __MULD12U
	LDS  R26,_cluster_begin_lba
	LDS  R27,_cluster_begin_lba+1
	LDS  R24,_cluster_begin_lba+2
	LDS  R25,_cluster_begin_lba+3
	CALL __ADDD12
	STS  _adr,R30
	STS  _adr+1,R31
	STS  _adr+2,R22
	STS  _adr+3,R23
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	MOV  R30,R8
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xE:
	LDS  R30,_adr
	LDS  R31,_adr+1
	LDS  R22,_adr+2
	LDS  R23,_adr+3
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xF:
	LDS  R26,_readbytes
	LDS  R27,_readbytes+1
	LDS  R24,_readbytes+2
	LDS  R25,_readbytes+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LD   R30,X
	ROL  R30
	LDI  R30,0
	ROL  R30
	OR   R30,R0
	MOVW R26,R22
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	CALL _compbuf
	__PUTB1MN _result,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(_sdBuf)
	LDI  R27,HIGH(_sdBuf)
	ADD  R26,R18
	ADC  R27,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDS  R30,_appStartAdr
	LDS  R31,_appStartAdr+1
	LDS  R22,_appStartAdr+2
	LDS  R23,_appStartAdr+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x14:
	STS  _appStartAdr,R30
	STS  _appStartAdr+1,R31
	STS  _appStartAdr+2,R22
	STS  _appStartAdr+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDI  R31,0
	CALL __CWD1
	CALL __LSLD16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	LDS  R26,_appStartAdr
	LDS  R27,_appStartAdr+1
	LDS  R24,_appStartAdr+2
	LDS  R25,_appStartAdr+3
	CALL __ORD12
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(_adr)
	LDI  R27,HIGH(_adr)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x18:
	STS  _fat_file_adr,R30
	STS  _fat_file_adr+1,R31
	STS  _fat_file_adr+2,R22
	STS  _fat_file_adr+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(_sdBuf)
	LDI  R31,HIGH(_sdBuf)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	STS  _adr,R30
	STS  _adr+1,R31
	STS  _adr+2,R22
	STS  _adr+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	__MULBNWRU 18,19,32
	SUBI R30,LOW(-_sdBuf)
	SBCI R31,HIGH(-_sdBuf)
	MOVW R26,R30
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1C:
	__MULBNWRU 18,19,32
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	RCALL SUBOPT_0x18
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	__ADDW1MN _sdBuf,26
	LD   R30,Z
	LDI  R31,0
	CALL __CWD1
	RCALL SUBOPT_0x6
	CALL __ORD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	SBI  0x18,0
	LDI  R26,LOW(255)
	RJMP _SPI_transfer

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	MOV  R26,R30
	RCALL _SPI_transfer
	__GETD2S 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	ST   -Y,R17
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
	CBI  0x18,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	ST   -Y,R27
	ST   -Y,R26
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
	CBI  0x18,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x23:
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x24:
	__GETD1S 10
	__GETD2N 0x200
	CALL __MULD12U
	__PUTD1S 10
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(255)
	ST   X,R30
	LDI  R26,LOW(255)
	RCALL _SPI_transfer
	CBI  0x18,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x25:
	ST   -Y,R30
	__GETD1S 11
	CALL __PUTPARD1
	LDI  R26,LOW(0)
	RCALL _SD_command
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	MOVW R30,R20
	ADIW R30,1
	MOVW R20,R30
	CPI  R30,LOW(0xF43)
	LDI  R26,HIGH(0xF43)
	CPC  R31,R26
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

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
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

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
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

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
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

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
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

__CPD20:
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
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

;END OF CODE MARKER
__END_OF_CODE:
