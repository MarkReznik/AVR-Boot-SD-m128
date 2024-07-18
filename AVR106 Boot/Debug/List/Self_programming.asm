
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Boot Loader
;Clock frequency        : 8.000000 MHz
;Memory model           : Medium
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
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
	.EQU __DSTACK_SIZE=0x0400
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

	.CSEG
	.ORG 0xF800

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800
	JMP  0xF800

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x6,0xFA,0xF6,0xF9


__GLOBAL_INI_TBL:
	.DW  0x04
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
	.ORG 0x500

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
;void (*__AddrToZ24ByteToSPMCR_SPM_W_Test)(void flash *addr)= (void(*)(void flash *)) 0x0FA06;
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
_ReadFlashByte:
; .FSTART _ReadFlashByte
; 0000 0049 //#pragma diag_suppress=Pe1053 // Suppress warning for conversion from long-type address to flash ptr.
; 0000 004A   return (unsigned char)*((MyFlashCharPointer)flashStartAdr);
	CALL __PUTPARD2
;	flashStartAdr -> Y+0
	CALL __GETD1S0
	__GETBRPF 30
	JMP  _0x2000001
; 0000 004B //#pragma diag_default=Pe1053 // Back to default.
; 0000 004C } // Returns data from Flash
; .FEND
;
;/*!
;* The function reads one Flash page from address flashStartAdr and stores data
;* in array dataPage[]. The number of bytes stored is depending upon the
;* Flash page size. The function returns FALSE if input address is not a Flash
;* page address, else TRUE.
;**/
;unsigned char ReadFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage){
; 0000 0054 unsigned char ReadFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage){
_ReadFlashPage:
; .FSTART _ReadFlashPage
; 0000 0055   unsigned int index;
; 0000 0056   if(!(flashStartAdr & (PAGESIZE-1))){      // If input address is a page address
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	flashStartAdr -> Y+4
;	*dataPage -> Y+2
;	index -> R16,R17
	__GETD1S 4
	CPI  R30,0
	BRNE _0x3
; 0000 0057     for(index = 0; index < PAGESIZE; index++){
	__GETWRN 16,17,0
_0x5:
	__CPWRN 16,17,256
	BRSH _0x6
; 0000 0058       dataPage[index] = ReadFlashByte(flashStartAdr + index);
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOVW R30,R16
	__GETD2S 4
	CLR  R22
	CLR  R23
	CALL __ADDD21
	RCALL _ReadFlashByte
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0059     }
	__ADDWRN 16,17,1
	RJMP _0x5
_0x6:
; 0000 005A     return TRUE;                            // Return TRUE if valid page address
	LDI  R30,LOW(1)
	RJMP _0x2000004
; 0000 005B   }
; 0000 005C   else{
_0x3:
; 0000 005D     return FALSE;                           // Return FALSE if not valid page address
	LDI  R30,LOW(0)
; 0000 005E   }
; 0000 005F }
_0x2000004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
; .FEND
;
;/*!
;* The function writes byte data to Flash address flashAddr. Returns FALSE if
;* input address is not valid Flash byte address for writing, else TRUE.
;**/
;unsigned char WriteFlashByte(MyAddressType flashAddr, unsigned char data){
; 0000 0065 unsigned char WriteFlashByte(MyAddressType flashAddr, unsigned char data){
_WriteFlashByte:
; .FSTART _WriteFlashByte
; 0000 0066   MyAddressType  pageAdr;
; 0000 0067   unsigned char eepromInterruptSettings;
; 0000 0068   if( AddressCheck( flashAddr & ~(PAGESIZE-1) )){
	ST   -Y,R26
	SBIW R28,4
	ST   -Y,R17
;	flashAddr -> Y+6
;	data -> Y+5
;	pageAdr -> Y+1
;	eepromInterruptSettings -> R17
	__GETD1S 6
	ANDI R30,LOW(0xFFFFFF00)
	MOVW R26,R30
	MOVW R24,R22
	RCALL _AddressCheck
	CPI  R30,0
	BREQ _0x8
; 0000 0069 
; 0000 006A     eepromInterruptSettings= EECR & (1<<EERIE); // Stores EEPROM interrupt mask
	IN   R30,0x1C
	ANDI R30,LOW(0x8)
	MOV  R17,R30
; 0000 006B     EECR &= ~(1<<EERIE);                    // Disable EEPROM interrupt
	CBI  0x1C,3
; 0000 006C     while(EECR & (1<<EEWE));                // Wait if ongoing EEPROM write
_0x9:
	SBIC 0x1C,1
	RJMP _0x9
; 0000 006D 
; 0000 006E     pageAdr=flashAddr & ~(PAGESIZE-1);      // Gets Flash page address from byte address
	__GETD1S 6
	ANDI R30,LOW(0xFFFFFF00)
	__PUTD1S 1
; 0000 006F 
; 0000 0070     #ifdef __FLASH_RECOVER
; 0000 0071     FlashBackup.status=0;                   // Inicate that Flash buffer does
; 0000 0072                                             // not contain data for writing
; 0000 0073     while(EECR & (1<<EEWE));
; 0000 0074     LpmReplaceSpm(flashAddr, data);         // Fills Flash write buffer
; 0000 0075     WriteBufToFlash(ADR_FLASH_BUFFER);      // Writes to Flash recovery buffer
; 0000 0076     FlashBackup.pageNumber = (unsigned int) (pageAdr/PAGESIZE); // Stores page address
; 0000 0077                                                        // data should be written to
; 0000 0078     FlashBackup.status = FLASH_BUFFER_FULL_ID; // Indicates that Flash recovery buffer
; 0000 0079                                                // contains unwritten data
; 0000 007A     while(EECR & (1<<EEWE));
; 0000 007B     #endif
; 0000 007C 
; 0000 007D     LpmReplaceSpm(flashAddr, data);         // Fills Flash write buffer
	__GETD1S 6
	CALL __PUTPARD1
	LDD  R26,Y+9
	RCALL _LpmReplaceSpm
; 0000 007E 
; 0000 007F 
; 0000 0080     WriteBufToFlash(pageAdr);               // Writes to Flash
	__GETD2S 1
	RCALL _WriteBufToFlash
; 0000 0081 
; 0000 0082     #ifdef __FLASH_RECOVER
; 0000 0083     FlashBackup.status = 0;                 // Indicates that Flash recovery buffer
; 0000 0084                                             // does not contain unwritten data
; 0000 0085     while(EECR & (1<<EEWE));
; 0000 0086     #endif
; 0000 0087 
; 0000 0088     EECR |= eepromInterruptSettings;        // Restore EEPROM interrupt mask
	IN   R30,0x1C
	OR   R30,R17
	OUT  0x1C,R30
; 0000 0089     return TRUE;                            // Return TRUE if address
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	RJMP _0x2000003
; 0000 008A                                             // valid for writing
; 0000 008B   }
; 0000 008C   else
_0x8:
; 0000 008D     return FALSE;                           // Return FALSE if address not
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2000003
; 0000 008E                                             // valid for writing
; 0000 008F }
; .FEND
;
;/*!
;* The function writes data from array dataPage[] to Flash page address
;* flashStartAdr. The Number of bytes written is depending upon the Flash page
;* size. Returns FALSE if input argument ucFlashStartAdr is not a valid Flash
;* page address for writing, else TRUE.
;**/
;unsigned char WriteFlashPage(MyAddressType flashStartAdr, unsigned char *dataPage)
; 0000 0098 {
_WriteFlashPage:
; .FSTART _WriteFlashPage
; 0000 0099   unsigned int index;
; 0000 009A   unsigned char eepromInterruptSettings;
; 0000 009B   if( AddressCheck(flashStartAdr) ){
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	flashStartAdr -> Y+6
;	*dataPage -> Y+4
;	index -> R16,R17
;	eepromInterruptSettings -> R19
	__GETD2S 6
	RCALL _AddressCheck
	CPI  R30,0
	BRNE PC+2
	RJMP _0xD
; 0000 009C     eepromInterruptSettings = EECR & (1<<EERIE); // Stoes EEPROM interrupt mask
	IN   R30,0x1C
	ANDI R30,LOW(0x8)
	MOV  R19,R30
; 0000 009D     EECR &= ~(1<<EERIE);                    // Disable EEPROM interrupt
	CBI  0x1C,3
; 0000 009E     while(EECR & (1<<EEWE));                // Wait if ongoing EEPROM write
_0xE:
	SBIC 0x1C,1
	RJMP _0xE
; 0000 009F 
; 0000 00A0     #ifdef __FLASH_RECOVER
; 0000 00A1     FlashBackup.status=0;                   // Inicate that Flash buffer does
; 0000 00A2                                             // not contain data for writing
; 0000 00A3     while(EECR & (1<<EEWE));
; 0000 00A4 
; 0000 00A5     //_ENABLE_RWW_SECTION();
; 0000 00A6 
; 0000 00A7     _WAIT_FOR_SPM();
; 0000 00A8     //_PAGE_ERASE( flashStartAdr );
; 0000 00A9 
; 0000 00AA     for(index = 0; index < PAGESIZE; index+=2){ // Fills Flash write buffer
; 0000 00AB       //_WAIT_FOR_SPM();
; 0000 00AC       //MY_FILL_TEMP_WORD(index, (unsigned int)dataPage[index]+((unsigned int)dataPage[index+1] << 8));
; 0000 00AD       _FILL_TEMP_WORD(index, (unsigned int)dataPage[index]+((unsigned int)dataPage[index+1] << 8));
; 0000 00AE     }
; 0000 00AF 
; 0000 00B0     WriteBufToFlash(ADR_FLASH_BUFFER);      // Writes to Flash recovery buffer
; 0000 00B1     FlashBackup.pageNumber=(unsigned int)(flashStartAdr/PAGESIZE);
; 0000 00B2     FlashBackup.status = FLASH_BUFFER_FULL_ID; // Indicates that Flash recovery buffer
; 0000 00B3                                            // contains unwritten data
; 0000 00B4     while(EECR & (1<<EEWE));
; 0000 00B5     #endif
; 0000 00B6 
; 0000 00B7     __AddrToZ24WordToR1R0ByteToSPMCR_SPM_F(0,0);
	__GETD1N 0x0
	CALL __PUTPARD1
	LDI  R26,LOW(0)
	LDI  R27,0
	CALL ___AddrToZ24WordToR1R0ByteToSPMCR_SPM_F
; 0000 00B8     __AddrToZ24ByteToSPMCR_SPM_W((void flash *)0x1EF00);
	CALL SUBOPT_0x0
	CALL ___AddrToZ24ByteToSPMCR_SPM_W
; 0000 00B9     __AddrToZ24ByteToSPMCR_SPM_E((void flash *)0x1EF00);
	CALL SUBOPT_0x0
	CALL ___AddrToZ24ByteToSPMCR_SPM_E
; 0000 00BA     __AddrToZ24ByteToSPMCR_SPM_EW((void flash *)0x1EF00);
	CALL SUBOPT_0x0
	CALL ___AddrToZ24ByteToSPMCR_SPM_EW
; 0000 00BB 
; 0000 00BC     _WAIT_FOR_SPM();
_0x11:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x11
; 0000 00BD     //_PAGE_ERASE( flashStartAdr );
; 0000 00BE     //_ENABLE_RWW_SECTION();
; 0000 00BF 
; 0000 00C0     for(index = 0; index < PAGESIZE; index+=2){ // Fills Flash write buffer
	__GETWRN 16,17,0
_0x15:
	__CPWRN 16,17,256
	BRSH _0x16
; 0000 00C1       //_WAIT_FOR_SPM();
; 0000 00C2       //MY_FILL_TEMP_WORD(index, (unsigned int)dataPage[index]+((unsigned int)dataPage[index+1] << 8));
; 0000 00C3       _FILL_TEMP_WORD(index, (unsigned int)dataPage[index]+((unsigned int)dataPage[index+1] << 8));
	CALL SUBOPT_0x1
	MOVW R30,R16
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X
	CLR  R1
	ADIW R30,1
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOV  R31,R30
	LDI  R30,0
	MOVW R26,R0
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R6
	ICALL
; 0000 00C4     }
	__ADDWRN 16,17,2
	RJMP _0x15
_0x16:
; 0000 00C5     //_PAGE_WRITE( flashStartAdr );
; 0000 00C6     WriteBufToFlash(flashStartAdr);         // Writes to Flash
	__GETD2S 6
	RCALL _WriteBufToFlash
; 0000 00C7     #ifdef __FLASH_RECOVER
; 0000 00C8       FlashBackup.status=0;                 // Inicate that Flash buffer does
; 0000 00C9                                             // not contain data for writing
; 0000 00CA       while(EECR & (1<<EEWE));
; 0000 00CB     #endif
; 0000 00CC 
; 0000 00CD     EECR |= eepromInterruptSettings;        // Restore EEPROM interrupt mask
	IN   R30,0x1C
	OR   R30,R19
	OUT  0x1C,R30
; 0000 00CE     return TRUE;                            // Return TRUE if address
	LDI  R30,LOW(1)
	RJMP _0x2000002
; 0000 00CF                                             // valid for writing
; 0000 00D0   }
; 0000 00D1   else
_0xD:
; 0000 00D2     return FALSE;                           // Return FALSE if not address not
	LDI  R30,LOW(0)
; 0000 00D3                                             // valid for writing
; 0000 00D4 }
_0x2000002:
	CALL __LOADLOCR4
_0x2000003:
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
; 0000 00DD unsigned char RecoverFlash(){
; 0000 00DE #ifdef __FLASH_RECOVER
; 0000 00DF   unsigned int index;
; 0000 00E0   unsigned long flashStartAdr = (MyAddressType)FlashBackup.pageNumber * PAGESIZE;
; 0000 00E1   if(FlashBackup.status == FLASH_BUFFER_FULL_ID){ // Checks if Flash recovery
; 0000 00E2                                                   //  buffer contains data
; 0000 00E3 
; 0000 00E4     for(index=0; index < PAGESIZE; index+=2){     // Writes to Flash write buffer
; 0000 00E5         _WAIT_FOR_SPM();
; 0000 00E6         MY_FILL_TEMP_WORD( index, *((MyFlashIntPointer)(ADR_FLASH_BUFFER+index)) );
; 0000 00E7     }
; 0000 00E8 
; 0000 00E9 
; 0000 00EA     //WriteBufToFlash((MyAddressType)FlashBackup.pageNumber * PAGESIZE);
; 0000 00EB     _WAIT_FOR_SPM();
; 0000 00EC     MY_PAGE_ERASE( flashStartAdr );
; 0000 00ED     _WAIT_FOR_SPM();
; 0000 00EE     MY_PAGE_WRITE( flashStartAdr );
; 0000 00EF     _WAIT_FOR_SPM();
; 0000 00F0     _ENABLE_RWW_SECTION();
; 0000 00F1     FlashBackup.status=0;                   // Inicate that Flash buffer does
; 0000 00F2                                             // not contain data for writing
; 0000 00F3     while(EECR & (1<<EEWE));
; 0000 00F4     return TRUE;                            // Returns TRUE if recovery has
; 0000 00F5                                             // taken place
; 0000 00F6   }
; 0000 00F7 #endif
; 0000 00F8   return FALSE;
; 0000 00F9 }
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
; 0000 0105 unsigned char AddressCheck(MyAddressType flashAdr){
_AddressCheck:
; .FSTART _AddressCheck
; 0000 0106   #ifdef __FLASH_RECOVER
; 0000 0107   // The next line gives a warning 'pointless comparison with zero' if ADR_LIMIT_LOW is 0. Ignore it.
; 0000 0108   if( (flashAdr >= ADR_LIMIT_LOW) && (flashAdr <= ADR_LIMIT_HIGH) &&
; 0000 0109       (flashAdr != ADR_FLASH_BUFFER) && !(flashAdr & (PAGESIZE-1)) )
; 0000 010A     return TRUE;                            // Address is a valid page address
; 0000 010B   else
; 0000 010C     return FALSE;                           // Address is not a valid page address
; 0000 010D   #else
; 0000 010E   if((flashAdr >= ADR_LIMIT_LOW) && (flashAdr <= ADR_LIMIT_HIGH) && !(flashAdr & (PAGESIZE-1) ) )
	CALL SUBOPT_0x2
;	flashAdr -> Y+0
	CALL __CPD20
	BRLO _0x19
	CALL __GETD2S0
	__CPD2N 0x1E000
	BRSH _0x19
	CALL __GETD1S0
	CPI  R30,0
	BREQ _0x1A
_0x19:
	RJMP _0x18
_0x1A:
; 0000 010F     return TRUE;                            // Address is a valid page address
	LDI  R30,LOW(1)
	JMP  _0x2000001
; 0000 0110   else
_0x18:
; 0000 0111   {
; 0000 0112     while(1)
_0x1C:
; 0000 0113     {
; 0000 0114       PORTC.5=0;
	CBI  0x15,5
; 0000 0115       delay_ms(500);
	CALL SUBOPT_0x3
; 0000 0116       PORTC.5=1;
	SBI  0x15,5
; 0000 0117       delay_ms(500);
	CALL SUBOPT_0x3
; 0000 0118     }
	RJMP _0x1C
; 0000 0119     return FALSE;                           // Address is not a valid page address
; 0000 011A   }
; 0000 011B   #endif
; 0000 011C }
; .FEND
;
;
;/*!
;* The function writes Flash temporary buffer to Flash page address given by
;* input argument.
;**/
;
;void WriteBufToFlash(MyAddressType flashStartAdr) {
; 0000 0124 void WriteBufToFlash(MyAddressType flashStartAdr) {
_WriteBufToFlash:
; .FSTART _WriteBufToFlash
; 0000 0125     //_WAIT_FOR_SPM();
; 0000 0126     //MY_PAGE_ERASE( flashStartAdr );
; 0000 0127     //_PAGE_ERASE( flashStartAdr );
; 0000 0128     //_WAIT_FOR_SPM();
; 0000 0129     //_ENABLE_RWW_SECTION();
; 0000 012A     //MY_PAGE_WRITE( flashStartAdr );
; 0000 012B     _PAGE_WRITE( flashStartAdr );
	CALL SUBOPT_0x2
;	flashStartAdr -> Y+0
	MOVW R30,R4
	ICALL
; 0000 012C     //_WAIT_FOR_SPM();
; 0000 012D     //_ENABLE_RWW_SECTION();
; 0000 012E /*
; 0000 012F #pragma diag_suppress=Pe1053 // Suppress warning for conversion from long-type address to flash ptr.
; 0000 0130   #ifdef __HAS_RAMPZ__
; 0000 0131   RAMPZ = (unsigned char)(flashStartAdr >> 16);
; 0000 0132   #endif
; 0000 0133   _PAGE_ERASE(flashStartAdr);
; 0000 0134   while( SPMControllRegister & (1<<SPMEN) ); // Wait until Flash write completed
; 0000 0135   _PAGE_WRITE(flashStartAdr);
; 0000 0136   while( SPMControllRegister & (1<<SPMEN) ); // Wait until Flash write completed
; 0000 0137   #ifdef RWWSRE
; 0000 0138   __DataToR0ByteToSPMCR_SPM( 0, (unsigned char)(1<<RWWSRE)|(1<<SPMEN)); // Enable RWW
; 0000 0139   #endif
; 0000 013A #pragma diag_default=Pe1053 // Back to default.
; 0000 013B */
; 0000 013C }
	JMP  _0x2000001
; .FEND
;
;/*!
;* The function reads Flash page given by flashAddr, replaces one byte given by
;* flashAddr with data, and stores entire page in Flash temporary buffer.
;**/
;void LpmReplaceSpm(MyAddressType flashAddr, unsigned char data){
; 0000 0142 void LpmReplaceSpm(MyAddressType flashAddr, unsigned char data){
_LpmReplaceSpm:
; .FSTART _LpmReplaceSpm
; 0000 0143 //#pragma diag_suppress=Pe1053 // Suppress warning for conversion from long-type address to flash ptr.
; 0000 0144     unsigned int index, oddByte, pcWord;
; 0000 0145 
; 0000 0146     MyAddressType  pageAdr;
; 0000 0147     oddByte=(unsigned char)flashAddr & 1;
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR6
;	flashAddr -> Y+11
;	data -> Y+10
;	index -> R16,R17
;	oddByte -> R18,R19
;	pcWord -> R20,R21
;	pageAdr -> Y+6
	LDD  R30,Y+11
	ANDI R30,LOW(0x1)
	MOV  R18,R30
	CLR  R19
; 0000 0148     pcWord=(unsigned int)flashAddr & (PAGESIZE-2); // Used when writing FLASH temp buffer
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ANDI R30,LOW(0xFE)
	ANDI R31,HIGH(0xFE)
	MOVW R20,R30
; 0000 0149     pageAdr=flashAddr & ~(PAGESIZE-1);        // Get FLASH page address from byte address
	__GETD1S 11
	ANDI R30,LOW(0xFFFFFF00)
	__PUTD1S 6
; 0000 014A     //while( SPMCR_REG & (1<<SPMEN) );
; 0000 014B     //_ENABLE_RWW_SECTION();
; 0000 014C 
; 0000 014D     for(index=0; index < PAGESIZE; index+=2){
	__GETWRN 16,17,0
_0x24:
	__CPWRN 16,17,256
	BRSH _0x25
; 0000 014E         if(index==pcWord){
	__CPWRR 20,21,16,17
	BRNE _0x26
; 0000 014F           if(oddByte){
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x27
; 0000 0150             //MY_FILL_TEMP_WORD( index, (*(MyFlashCharPointer)(flashAddr & ~1) | ((unsigned int)data<<8)) );
; 0000 0151             _FILL_TEMP_WORD( index, (*(MyFlashCharPointer)(flashAddr & ~1) | ((unsigned int)data<<8)) );
	CALL SUBOPT_0x1
	__GETD1S 15
	ANDI R30,LOW(0xFFFFFFFE)
	__GETBRPF 26
	LDI  R27,0
	LDI  R30,0
	LDD  R31,Y+14
	RJMP _0x2A
; 0000 0152           }                                     // Write odd byte in temporary buffer
; 0000 0153           else{
_0x27:
; 0000 0154             //MY_FILL_TEMP_WORD( index, ( (*( (MyFlashCharPointer)flashAddr+1)<<8)  | data ) );
; 0000 0155             _FILL_TEMP_WORD( index, ( (*( (MyFlashCharPointer)flashAddr+1)<<8)  | data ) );
	CALL SUBOPT_0x1
	__GETD1S 15
	__ADDD1N 1
	__GETBRPF 30
	MOV  R31,R30
	LDI  R30,0
	MOVW R26,R30
	LDD  R30,Y+14
	LDI  R31,0
_0x2A:
	OR   R30,R26
	OR   R31,R27
	MOVW R26,R30
	MOVW R30,R6
	ICALL
; 0000 0156           }                                     // Write even byte in temporary buffer
; 0000 0157         }
; 0000 0158         else{
	RJMP _0x29
_0x26:
; 0000 0159           //MY_FILL_TEMP_WORD(index, *( (MyFlashIntPointer)(pageAdr+index) ) );
; 0000 015A           _FILL_TEMP_WORD(index, *( (MyFlashIntPointer)(pageAdr+index) ) );
	CALL SUBOPT_0x1
	MOVW R30,R16
	__GETD2S 10
	CLR  R22
	CLR  R23
	CALL __ADDD12
	CALL __GETW2PF
	MOVW R30,R6
	ICALL
; 0000 015B         }                                       // Write Flash word directly to temporary buffer
_0x29:
; 0000 015C     }
	__ADDWRN 16,17,2
	RJMP _0x24
_0x25:
; 0000 015D //#pragma diag_default=Pe1053 // Back to default.
; 0000 015E }
	CALL __LOADLOCR6
	ADIW R28,15
	RET
; .FEND
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
; 0001 0019     #asm
; 0001 001A          ldi   r22,$03
; 0001 001B          WR_SPMCR_REG_R22
; 0001 001C          spm
; 0001 001D     #endasm
; 0001 001E     _WAIT_FOR_SPM();
; 0001 001F     #asm
; 0001 0020         ldi   r22,$05
; 0001 0021         WR_SPMCR_REG_R22
; 0001 0022         spm
; 0001 0023     #endasm
; 0001 0024     _WAIT_FOR_SPM();
; 0001 0025     while( SPMCR_REG & (1<<RWWSB) )
; 0001 0026     {
; 0001 0027     #asm
; 0001 0028         ldi   r22,$11
; 0001 0029         WR_SPMCR_REG_R22
; 0001 002A         spm
; 0001 002B     #endasm
; 0001 002C         _WAIT_FOR_SPM();
; 0001 002D     }
; 0001 002E }
;
;void dospmw(void)
; 0001 0031 {
; 0001 0032     #asm
; 0001 0033         ldi   r22,$05
; 0001 0034         WR_SPMCR_REG_R22
; 0001 0035         spm
; 0001 0036     #endasm
; 0001 0037     _WAIT_FOR_SPM();
; 0001 0038     while( SPMCR_REG & (1<<RWWSB) )
; 0001 0039     {
; 0001 003A     #asm
; 0001 003B         ldi   r22,$11
; 0001 003C         WR_SPMCR_REG_R22
; 0001 003D         spm
; 0001 003E     #endasm
; 0001 003F         _WAIT_FOR_SPM();
; 0001 0040     }
; 0001 0041 }
;
;void dospme(void)
; 0001 0044 {
; 0001 0045     #asm
; 0001 0046         ldi   r22,$03
; 0001 0047         WR_SPMCR_REG_R22
; 0001 0048         spm
; 0001 0049     #endasm
; 0001 004A     _WAIT_FOR_SPM();
; 0001 004B     while( SPMCR_REG & (1<<RWWSB) )
; 0001 004C     {
; 0001 004D     #asm
; 0001 004E         ldi   r22,$11
; 0001 004F         WR_SPMCR_REG_R22
; 0001 0050         spm
; 0001 0051     #endasm
; 0001 0052         _WAIT_FOR_SPM();
; 0001 0053     }
; 0001 0054 }
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
	ADIW R28,6
	RET
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
; 0001 00EF #asm
; 0001 00F0      ldi   r22,$05
     ldi   r22,$05
; 0001 00F1      WR_SPMCR_REG_R22
     WR_SPMCR_REG_R22
; 0001 00F2      spm
     spm
; 0001 00F3 #endasm
; 0001 00F4 _WAIT_FOR_SPM();
_0x20036:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x20036
; 0001 00F5 do
_0x2003A:
; 0001 00F6 {
; 0001 00F7 #asm
; 0001 00F8     ldi   r22,$11
    ldi   r22,$11
; 0001 00F9     WR_SPMCR_REG_R22
    WR_SPMCR_REG_R22
; 0001 00FA     spm
    spm
; 0001 00FB #endasm
; 0001 00FC     _WAIT_FOR_SPM();
_0x2003C:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x2003C
; 0001 00FD }
; 0001 00FE while( SPMCR_REG & (1<<RWWSB) );
	LDS  R30,104
	ANDI R30,LOW(0x40)
	BRNE _0x2003A
; 0001 00FF //dospmw();
; 0001 0100 }
	JMP  _0x2000001
; .FEND
;
;void __AddrToZ24ByteToSPMCR_SPM_E(void flash *addr)
; 0001 0103 {
___AddrToZ24ByteToSPMCR_SPM_E:
; .FSTART ___AddrToZ24ByteToSPMCR_SPM_E
; 0001 0104 _WAIT_FOR_SPM();
	CALL __PUTPARD2
;	*addr -> Y+0
_0x2003F:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x2003F
; 0001 0105 #asm
; 0001 0106      ldd  r30,y+0
     ldd  r30,y+0
; 0001 0107      ldd  r31,y+1
     ldd  r31,y+1
; 0001 0108      ldd  r22,y+2
     ldd  r22,y+2
; 0001 0109      out  rampz,r22
     out  rampz,r22
; 0001 010A      //ld   r22,y
     //ld   r22,y
; 0001 010B      //WR_SPMCR_REG_R22
     //WR_SPMCR_REG_R22
; 0001 010C      //spm
     //spm
; 0001 010D #endasm
; 0001 010E #asm
; 0001 010F      ldi   r22,$03
     ldi   r22,$03
; 0001 0110      WR_SPMCR_REG_R22
     WR_SPMCR_REG_R22
; 0001 0111      spm
     spm
; 0001 0112 #endasm
; 0001 0113 _WAIT_FOR_SPM();
_0x20042:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x20042
; 0001 0114 do
_0x20046:
; 0001 0115 {
; 0001 0116 #asm
; 0001 0117     ldi   r22,$11
    ldi   r22,$11
; 0001 0118     WR_SPMCR_REG_R22
    WR_SPMCR_REG_R22
; 0001 0119     spm
    spm
; 0001 011A #endasm
; 0001 011B     _WAIT_FOR_SPM();
_0x20048:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x20048
; 0001 011C }
; 0001 011D while( SPMCR_REG & (1<<RWWSB) );
	LDS  R30,104
	ANDI R30,LOW(0x40)
	BRNE _0x20046
; 0001 011E //dospme();
; 0001 011F }
	JMP  _0x2000001
; .FEND
;
;void __AddrToZ24ByteToSPMCR_SPM_EW(void flash *addr)
; 0001 0122 {
___AddrToZ24ByteToSPMCR_SPM_EW:
; .FSTART ___AddrToZ24ByteToSPMCR_SPM_EW
; 0001 0123 _WAIT_FOR_SPM();
	CALL __PUTPARD2
;	*addr -> Y+0
_0x2004B:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x2004B
; 0001 0124 #asm
; 0001 0125      ldd  r30,y+0
     ldd  r30,y+0
; 0001 0126      ldd  r31,y+1
     ldd  r31,y+1
; 0001 0127      ldd  r22,y+2
     ldd  r22,y+2
; 0001 0128      out  rampz,r22
     out  rampz,r22
; 0001 0129      //ld   r22,y
     //ld   r22,y
; 0001 012A      //WR_SPMCR_REG_R22
     //WR_SPMCR_REG_R22
; 0001 012B      //spm
     //spm
; 0001 012C #endasm
; 0001 012D #asm
; 0001 012E      ldi   r22,$03
     ldi   r22,$03
; 0001 012F      WR_SPMCR_REG_R22
     WR_SPMCR_REG_R22
; 0001 0130      spm
     spm
; 0001 0131 #endasm
; 0001 0132 _WAIT_FOR_SPM();
_0x2004E:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x2004E
; 0001 0133 do
_0x20052:
; 0001 0134 {
; 0001 0135 #asm
; 0001 0136     ldi   r22,$11
    ldi   r22,$11
; 0001 0137     WR_SPMCR_REG_R22
    WR_SPMCR_REG_R22
; 0001 0138     spm
    spm
; 0001 0139 #endasm
; 0001 013A     _WAIT_FOR_SPM();
_0x20054:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x20054
; 0001 013B }
; 0001 013C while( SPMCR_REG & (1<<RWWSB) );
	LDS  R30,104
	ANDI R30,LOW(0x40)
	BRNE _0x20052
; 0001 013D #asm
; 0001 013E     ldi   r22,$05
    ldi   r22,$05
; 0001 013F     WR_SPMCR_REG_R22
    WR_SPMCR_REG_R22
; 0001 0140     spm
    spm
; 0001 0141 #endasm
; 0001 0142 _WAIT_FOR_SPM();
_0x20057:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x20057
; 0001 0143 do
_0x2005B:
; 0001 0144 {
; 0001 0145 #asm
; 0001 0146     ldi   r22,$11
    ldi   r22,$11
; 0001 0147     WR_SPMCR_REG_R22
    WR_SPMCR_REG_R22
; 0001 0148     spm
    spm
; 0001 0149 #endasm
; 0001 014A     _WAIT_FOR_SPM();
_0x2005D:
	LDS  R30,104
	ANDI R30,LOW(0x1)
	BRNE _0x2005D
; 0001 014B }
; 0001 014C while( SPMCR_REG & (1<<RWWSB) );
	LDS  R30,104
	ANDI R30,LOW(0x40)
	BRNE _0x2005B
; 0001 014D //dospmew();
; 0001 014E }
_0x2000001:
	ADIW R28,4
	RET
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
;
;#include "Self_programming.h"
;void testWrite();
;
;
;void main( void ){
; 0002 0024 void main( void ){

	.CSEG
_main:
; .FSTART _main
; 0002 0025 
; 0002 0026   //static unsigned char testChar; // A warning will come saying that this var is set but never used. Ignore it.
; 0002 0027   //#asm("cli")
; 0002 0028   if(PORTA==0x55)
	IN   R30,0x1B
	CPI  R30,LOW(0x55)
	BRNE _0x40003
; 0002 0029     testWrite();                                          // Returns TRUE
	RCALL _testWrite
; 0002 002A   //__AddrToZ24WordToR1R0ByteToSPMCR_SPM_F(0,0);
; 0002 002B   //__AddrToZ24ByteToSPMCR_SPM_W((void flash *)0);
; 0002 002C   /*
; 0002 002D   unsigned char testBuffer1[PAGESIZE];      // Declares variables for testing
; 0002 002E   unsigned char testBuffer2[PAGESIZE];      // Note. Each array uses PAGESIZE bytes of
; 0002 002F                                             // code stack
; 0002 0030   int index;
; 0002 0031 
; 0002 0032   DDRC=0xFF;
; 0002 0033   PORTC=0xFF;
; 0002 0034   //DDRC=0x00;
; 0002 0035   //PORTC=0x00;
; 0002 0036   //MCUCR |= (1<<IVSEL);
; 0002 0037                         // Move interrupt vectors to boot
; 0002 0038   //RecoverFlash();
; 0002 0039 
; 0002 003A   dospm();
; 0002 003B 
; 0002 003C   for(index=0; index<PAGESIZE; index++){
; 0002 003D     testBuffer1[index]=(unsigned char)index; // Fills testBuffer1 with values 0,1,2..255
; 0002 003E   }
; 0002 003F   PORTC.4=0;
; 0002 0040   //for(;;){
; 0002 0041   if(  WriteFlashPage(0x1000, testBuffer1))//;     // Writes testbuffer1 to Flash page 2
; 0002 0042     PORTC.5=0;                                          // Function returns TRUE
; 0002 0043   if(  ReadFlashPage(0x1000, testBuffer2))//;      // Reads back Flash page 2 to TestBuffer2
; 0002 0044     PORTC.6=0;                                          // Function returns TRUE
; 0002 0045   if(  WriteFlashByte(0x1004, 0x38))//;            // Writes 0x38 to byte address 0x204
; 0002 0046     PORTC.5=0;                                          // Same as byte 4 on page 2
; 0002 0047   */
; 0002 0048 
; 0002 0049   //}
; 0002 004A }
_0x40003:
_0x40004:
	RJMP _0x40004
; .FEND
;
;
;void testWrite()
; 0002 004E {
_testWrite:
; .FSTART _testWrite
; 0002 004F   unsigned char testBuffer1[PAGESIZE];      // Declares variables for testing
; 0002 0050   unsigned char testBuffer2[PAGESIZE];      // Note. Each array uses PAGESIZE bytes of
; 0002 0051                                             // code stack
; 0002 0052 
; 0002 0053 
; 0002 0054   static unsigned char testChar; // A warning will come saying that this var is set but never used. Ignore it.
; 0002 0055   int index;
; 0002 0056 
; 0002 0057   //DDRC=0xFF;
; 0002 0058   //PORTC=0xFF;
; 0002 0059   //DDRC=0x00;
; 0002 005A   //PORTC=0x00;
; 0002 005B   //MCUCR |= (1<<IVSEL);
; 0002 005C                         // Move interrupt vectors to boot
; 0002 005D   //RecoverFlash();
; 0002 005E 
; 0002 005F   //dospm();
; 0002 0060 
; 0002 0061   for(index=0; index<PAGESIZE; index++){
	SUBI R29,2
	ST   -Y,R17
	ST   -Y,R16
;	testBuffer1 -> Y+258
;	testBuffer2 -> Y+2
;	index -> R16,R17
	__GETWRN 16,17,0
_0x40006:
	__CPWRN 16,17,256
	BRGE _0x40007
; 0002 0062     testBuffer1[index]=(unsigned char)index; // Fills testBuffer1 with values 0,1,2..255
	MOVW R30,R16
	MOVW R26,R28
	SUBI R26,LOW(-(258))
	SBCI R27,HIGH(-(258))
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R16
; 0002 0063   }
	__ADDWRN 16,17,1
	RJMP _0x40006
_0x40007:
; 0002 0064   PORTC.4=0;
	CBI  0x15,4
; 0002 0065   //for(;;){
; 0002 0066   if(  WriteFlashPage(0x1EF00, testBuffer1))//;     // Writes testbuffer1 to Flash page 2
	RCALL SUBOPT_0x4
	MOVW R26,R28
	SUBI R26,LOW(-(262))
	SBCI R27,HIGH(-(262))
	CALL _WriteFlashPage
	CPI  R30,0
	BREQ _0x4000A
; 0002 0067     PORTC.5=0;                                          // Function returns TRUE
	CBI  0x15,5
; 0002 0068   if(  ReadFlashPage(0x1EF00, testBuffer2))//;      // Reads back Flash page 2 to TestBuffer2
_0x4000A:
	RCALL SUBOPT_0x4
	MOVW R26,R28
	ADIW R26,6
	CALL _ReadFlashPage
	CPI  R30,0
	BREQ _0x4000D
; 0002 0069     PORTC.6=0;                                          // Function returns TRUE
	CBI  0x15,6
; 0002 006A   if(  WriteFlashByte(0x1EF04, 0x38))//;            // Writes 0x38 to byte address 0x204
_0x4000D:
	__GETD1N 0x1EF04
	CALL __PUTPARD1
	LDI  R26,LOW(56)
	CALL _WriteFlashByte
	CPI  R30,0
	BREQ _0x40010
; 0002 006B     PORTC.5=1;                                          // Same as byte 4 on page 2
	SBI  0x15,5
; 0002 006C   testChar = ReadFlashByte(0x1EF04);        // Reads back value from address 0x204
_0x40010:
	__GETD2N 0x1EF04
	CALL _ReadFlashByte
	STS  _testChar_S0020001000,R30
; 0002 006D 
; 0002 006E   if(testChar==0x38)
	LDS  R26,_testChar_S0020001000
	CPI  R26,LOW(0x38)
	BRNE _0x40013
; 0002 006F   {
; 0002 0070     while(1)
_0x40014:
; 0002 0071     {
; 0002 0072       PORTC.6=0;
	CBI  0x15,6
; 0002 0073       delay_ms(500);
	RCALL SUBOPT_0x3
; 0002 0074       PORTC.6=1;
	SBI  0x15,6
; 0002 0075       delay_ms(500);;
	RCALL SUBOPT_0x3
; 0002 0076     }
	RJMP _0x40014
; 0002 0077   }
; 0002 0078 }
_0x40013:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,2
	SUBI R29,-2
	RET
; .FEND

	.DSEG
_testChar_S0020001000:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	__GETD2N 0x1EF00
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	MOVW R30,R16
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	CALL __PUTPARD2
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	__GETD1N 0x1EF00
	CALL __PUTPARD1
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

__GETW2PF:
	OUT  RAMPZ,R22
	ELPM R26,Z+
	ELPM R27,Z
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

__CPD20:
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
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
