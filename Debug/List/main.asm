
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	.DEF _adcPin=R4
	.DEF _adcPin_msb=R5
	.DEF _hour=R7
	.DEF _minn=R6
	.DEF _sec=R9
	.DEF _day=R8
	.DEF _date=R11
	.DEF _month=R10
	.DEF _year=R13
	.DEF _mode=R12

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
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x57,0x65,0x6C,0x63,0x6F,0x6D,0x65,0x0
	.DB  0x43,0x54,0x41,0x20,0x47,0x72,0x6F,0x75
	.DB  0x70,0x0,0x43,0x41,0x49,0x20,0x50,0x48
	.DB  0x55,0x54,0x0,0x43,0x41,0x49,0x20,0x47
	.DB  0x49,0x4F,0x0,0x43,0x41,0x49,0x20,0x4E
	.DB  0x47,0x41,0x59,0x0,0x43,0x41,0x49,0x20
	.DB  0x54,0x48,0x41,0x4E,0x47,0x0,0x43,0x41
	.DB  0x49,0x20,0x4E,0x41,0x4D,0x0,0x43,0x41
	.DB  0x49,0x20,0x50,0x48,0x55,0x54,0x20,0x42
	.DB  0x41,0x54,0x0,0x43,0x41,0x49,0x20,0x47
	.DB  0x49,0x4F,0x20,0x42,0x41,0x54,0x0,0x43
	.DB  0x41,0x49,0x20,0x50,0x48,0x55,0x54,0x20
	.DB  0x54,0x41,0x54,0x0,0x43,0x41,0x49,0x20
	.DB  0x47,0x49,0x4F,0x20,0x54,0x41,0x54,0x0
	.DB  0x43,0x48,0x45,0x20,0x44,0x4F,0x20,0x48
	.DB  0x45,0x4E,0x20,0x47,0x49,0x4F,0x0,0x54
	.DB  0x5F,0x4F,0x4E,0x3A,0x20,0x0,0x54,0x5F
	.DB  0x4F,0x46,0x46,0x3A,0x0,0x25,0x32,0x2E
	.DB  0x30,0x66,0x0,0x25,0x0,0x2F,0x0,0x43
	.DB  0x4E,0x2D,0x0,0x54,0x32,0x2D,0x0,0x54
	.DB  0x33,0x2D,0x0,0x54,0x34,0x2D,0x0,0x54
	.DB  0x35,0x2D,0x0,0x54,0x36,0x2D,0x0,0x54
	.DB  0x37,0x2D,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2060003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x08
	.DW  _0x8
	.DW  _0x0*2

	.DW  0x0A
	.DW  _0x8+8
	.DW  _0x0*2+8

	.DW  0x09
	.DW  _0x8+18
	.DW  _0x0*2+18

	.DW  0x08
	.DW  _0x8+27
	.DW  _0x0*2+27

	.DW  0x09
	.DW  _0x8+35
	.DW  _0x0*2+35

	.DW  0x0A
	.DW  _0x8+44
	.DW  _0x0*2+44

	.DW  0x08
	.DW  _0x8+54
	.DW  _0x0*2+54

	.DW  0x0D
	.DW  _0x8+62
	.DW  _0x0*2+62

	.DW  0x0C
	.DW  _0x8+75
	.DW  _0x0*2+75

	.DW  0x0D
	.DW  _0x8+87
	.DW  _0x0*2+87

	.DW  0x0C
	.DW  _0x8+100
	.DW  _0x0*2+100

	.DW  0x0F
	.DW  _0x8+112
	.DW  _0x0*2+112

	.DW  0x04
	.DW  _0x8+127
	.DW  _0x0*2+71

	.DW  0x04
	.DW  _0x8+131
	.DW  _0x0*2+96

	.DW  0x07
	.DW  _0x39
	.DW  _0x0*2+127

	.DW  0x07
	.DW  _0x39+7
	.DW  _0x0*2+134

	.DW  0x02
	.DW  _0x56
	.DW  _0x0*2+147

	.DW  0x02
	.DW  _0x61
	.DW  _0x0*2+139

	.DW  0x02
	.DW  _0x61+2
	.DW  _0x0*2+139

	.DW  0x02
	.DW  _0x62
	.DW  _0x0*2+149

	.DW  0x02
	.DW  _0x62+2
	.DW  _0x0*2+149

	.DW  0x04
	.DW  _0x8B
	.DW  _0x0*2+151

	.DW  0x04
	.DW  _0x8B+4
	.DW  _0x0*2+155

	.DW  0x04
	.DW  _0x8B+8
	.DW  _0x0*2+159

	.DW  0x04
	.DW  _0x8B+12
	.DW  _0x0*2+163

	.DW  0x04
	.DW  _0x8B+16
	.DW  _0x0*2+167

	.DW  0x04
	.DW  _0x8B+20
	.DW  _0x0*2+171

	.DW  0x04
	.DW  _0x8B+24
	.DW  _0x0*2+175

	.DW  0x02
	.DW  _0x93
	.DW  _0x0*2+139

	.DW  0x02
	.DW  _0x94
	.DW  _0x0*2+139

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

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
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
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
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 12/19/2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <i2c.h>
;#include <ds1307.h>
;#include <stdlib.h>
;#include <stdio.h>
;#include <alcd.h>
;
;#define ON_PIN  PORTD.3
;#define RELAY   PORTD.2
;#define LOAD    PORTD.4
;
;#define MODE    PINB.0
;#define UP      PINB.1
;#define DOWN    PINB.3
;#define LOSS_PHASE    690
;
;char buzz[4];
;unsigned int adcPin;
;bit Charge_Flag = 0;
;unsigned char hour,minn,sec,day,date,month,year,mode,No_date,index=0;
;eeprom unsigned char hour_on,min_on,hour_off,min_off,alarm_flag;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0033 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 0034 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 0035 // Delay needed for the stabilization of the ADC input voltage
; 0000 0036 delay_us(10);
	__DELAY_USB 27
; 0000 0037 // Start the AD conversion
; 0000 0038 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0039 // Wait for the AD conversion to complete
; 0000 003A while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 003B ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 003C return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 003D }
; .FEND
;
;interrupt [EXT_INT2] void ext_int2_isr(void)
; 0000 0040 {
_ext_int2_isr:
; .FSTART _ext_int2_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0041        LOAD = ~ LOAD;
	SBIS 0x12,4
	RJMP _0x6
	CBI  0x12,4
	RJMP _0x7
_0x6:
	SBI  0x12,4
_0x7:
; 0000 0042        delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0043 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void readPin(void);
;void display_PIN(unsigned char x, unsigned char y);
;unsigned int read_phase(unsigned char n);
;void check_phase(void);
;void getTime();
;void timeDisplay(unsigned char x, unsigned char y);
;void dateDisplay(unsigned char x, unsigned char y);
;void dayDisplay(unsigned char x, unsigned char y);
;void so_ngay(void);
;void setting(void);
;void button(void);
;void alarmOnDisplay(unsigned char x, unsigned char y);
;void alarmOffDisplay(unsigned char x, unsigned char y);
;void alarm(void);
;
;void main(void)
; 0000 0055 {
_main:
; .FSTART _main
; 0000 0056 // Declare your local variables here
; 0000 0057 
; 0000 0058 // Input/Output Ports initialization
; 0000 0059 // Port A initialization
; 0000 005A // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 005B DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 005C // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 005D PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 005E 
; 0000 005F // Port B initialization
; 0000 0060 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0061 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0062 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 0063 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(15)
	OUT  0x18,R30
; 0000 0064 
; 0000 0065 // Port C initialization
; 0000 0066 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0067 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0068 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0069 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 006A 
; 0000 006B // Port D initialization
; 0000 006C // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=In Bit2=Out Bit1=Out Bit0=In
; 0000 006D DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (1<<DDD4) | (0<<DDD3) | (1<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(22)
	OUT  0x11,R30
; 0000 006E // State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=T
; 0000 006F PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 0070 
; 0000 0071 // Timer/Counter 0 initialization
; 0000 0072 // Clock source: System Clock
; 0000 0073 // Clock value: Timer 0 Stopped
; 0000 0074 // Mode: Normal top=0xFF
; 0000 0075 // OC0 output: Disconnected
; 0000 0076 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0077 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0078 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0079 
; 0000 007A // Timer/Counter 1 initialization
; 0000 007B // Clock source: System Clock
; 0000 007C // Clock value: Timer1 Stopped
; 0000 007D // Mode: Normal top=0xFFFF
; 0000 007E // OC1A output: Disconnected
; 0000 007F // OC1B output: Disconnected
; 0000 0080 // Noise Canceler: Off
; 0000 0081 // Input Capture on Falling Edge
; 0000 0082 // Timer1 Overflow Interrupt: Off
; 0000 0083 // Input Capture Interrupt: Off
; 0000 0084 // Compare A Match Interrupt: Off
; 0000 0085 // Compare B Match Interrupt: Off
; 0000 0086 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0087 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0088 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0089 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 008A ICR1H=0x00;
	OUT  0x27,R30
; 0000 008B ICR1L=0x00;
	OUT  0x26,R30
; 0000 008C OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 008D OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 008E OCR1BH=0x00;
	OUT  0x29,R30
; 0000 008F OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0090 
; 0000 0091 // Timer/Counter 2 initialization
; 0000 0092 // Clock source: System Clock
; 0000 0093 // Clock value: Timer2 Stopped
; 0000 0094 // Mode: Normal top=0xFF
; 0000 0095 // OC2 output: Disconnected
; 0000 0096 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0097 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0098 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0099 OCR2=0x00;
	OUT  0x23,R30
; 0000 009A 
; 0000 009B // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 009C TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 009D 
; 0000 009E // External Interrupt(s) initialization
; 0000 009F // INT0: Off
; 0000 00A0 // INT1: Off
; 0000 00A1 // INT2: On
; 0000 00A2 // INT2 Mode: Rising Edge
; 0000 00A3 GICR|=(0<<INT1) | (0<<INT0) | (1<<INT2);
	IN   R30,0x3B
	ORI  R30,0x20
	OUT  0x3B,R30
; 0000 00A4 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00A5 MCUCSR=(1<<ISC2);
	LDI  R30,LOW(64)
	OUT  0x34,R30
; 0000 00A6 GIFR=(0<<INTF1) | (0<<INTF0) | (1<<INTF2);
	LDI  R30,LOW(32)
	OUT  0x3A,R30
; 0000 00A7 
; 0000 00A8 // USART initialization
; 0000 00A9 // USART disabled
; 0000 00AA UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 00AB 
; 0000 00AC // Analog Comparator initialization
; 0000 00AD // Analog Comparator: Off
; 0000 00AE // The Analog Comparator's positive input is
; 0000 00AF // connected to the AIN0 pin
; 0000 00B0 // The Analog Comparator's negative input is
; 0000 00B1 // connected to the AIN1 pin
; 0000 00B2 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00B3 
; 0000 00B4 // ADC initialization
; 0000 00B5 // ADC Clock frequency: 1000.000 kHz
; 0000 00B6 // ADC Voltage Reference: AREF pin
; 0000 00B7 // ADC Auto Trigger Source: ADC Stopped
; 0000 00B8 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 00B9 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 00BA SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00BB 
; 0000 00BC // SPI initialization
; 0000 00BD // SPI disabled
; 0000 00BE SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00BF 
; 0000 00C0 // TWI initialization
; 0000 00C1 // TWI disabled
; 0000 00C2 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00C3 
; 0000 00C4 // Bit-Banged I2C Bus initialization
; 0000 00C5 // I2C Port: PORTD
; 0000 00C6 // I2C SDA bit: 7
; 0000 00C7 // I2C SCL bit: 6
; 0000 00C8 // Bit Rate: 100 kHz
; 0000 00C9 // Note: I2C settings are specified in the
; 0000 00CA // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 00CB i2c_init();
	CALL _i2c_init
; 0000 00CC 
; 0000 00CD // DS1307 Real Time Clock initialization
; 0000 00CE // Square wave output on pin SQW/OUT: Off
; 0000 00CF // SQW/OUT pin state: 0
; 0000 00D0 rtc_init(0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _rtc_init
; 0000 00D1 
; 0000 00D2 // Alphanumeric LCD initialization
; 0000 00D3 // Connections are specified in the
; 0000 00D4 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00D5 // RS - PORTC Bit 0
; 0000 00D6 // RD - PORTC Bit 1
; 0000 00D7 // EN - PORTC Bit 2
; 0000 00D8 // D4 - PORTC Bit 4
; 0000 00D9 // D5 - PORTC Bit 5
; 0000 00DA // D6 - PORTC Bit 6
; 0000 00DB // D7 - PORTC Bit 7
; 0000 00DC // Characters/line: 16
; 0000 00DD lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00DE lcd_gotoxy(4,0);
	CALL SUBOPT_0x0
; 0000 00DF lcd_puts("Welcome");
	__POINTW2MN _0x8,0
	CALL _lcd_puts
; 0000 00E0 lcd_gotoxy(3,1);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x1
; 0000 00E1 lcd_puts("CTA Group");
	__POINTW2MN _0x8,8
	CALL _lcd_puts
; 0000 00E2 delay_ms(800);
	LDI  R26,LOW(800)
	LDI  R27,HIGH(800)
	CALL _delay_ms
; 0000 00E3 lcd_clear();
	CALL _lcd_clear
; 0000 00E4 readPin();
	RCALL _readPin
; 0000 00E5 
; 0000 00E6 // Global enable interrupts
; 0000 00E7 #asm("sei")
	sei
; 0000 00E8 while (1)
_0x9:
; 0000 00E9     {
; 0000 00EA       button();
	RCALL _button
; 0000 00EB      /*************************************************/
; 0000 00EC      if(index==0)
	LDS  R30,_index
	CPI  R30,0
	BREQ PC+2
	RJMP _0xC
; 0000 00ED      {
; 0000 00EE           if(mode==0){
	TST  R12
	BRNE _0xD
; 0000 00EF               getTime();
	RCALL _getTime
; 0000 00F0               timeDisplay(2,0);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _timeDisplay
; 0000 00F1               dateDisplay(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _dateDisplay
; 0000 00F2 
; 0000 00F3               display_PIN(12,0);
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _display_PIN
; 0000 00F4               check_phase();
	RCALL _check_phase
; 0000 00F5               if(minn%3==0 && sec<10) readPin();
	MOV  R26,R6
	CLR  R27
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __MODW21
	SBIW R30,0
	BRNE _0xF
	LDI  R30,LOW(10)
	CP   R9,R30
	BRLO _0x10
_0xF:
	RJMP _0xE
_0x10:
	RCALL _readPin
; 0000 00F6               else{
	RJMP _0x11
_0xE:
; 0000 00F7                 if(Charge_Flag==0) DDRD.3=0;
	SBRS R2,0
	CBI  0x11,3
; 0000 00F8               }
_0x11:
; 0000 00F9               if(alarm_flag==1){
	LDI  R26,LOW(_alarm_flag)
	LDI  R27,HIGH(_alarm_flag)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x15
; 0000 00FA                 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x2
; 0000 00FB                 lcd_putchar(255);
	LDI  R26,LOW(255)
	RJMP _0x128
; 0000 00FC               }else{
_0x15:
; 0000 00FD                 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x2
; 0000 00FE                 lcd_putchar(0);
	LDI  R26,LOW(0)
_0x128:
	CALL _lcd_putchar
; 0000 00FF               }
; 0000 0100 
; 0000 0101           }else{
	RJMP _0x17
_0xD:
; 0000 0102             setting();
	RCALL _setting
; 0000 0103             if(mode==1){
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x18
; 0000 0104               lcd_gotoxy(4,0);
	CALL SUBOPT_0x0
; 0000 0105               lcd_puts("CAI PHUT");
	__POINTW2MN _0x8,18
	CALL SUBOPT_0x3
; 0000 0106               timeDisplay(4,1);
; 0000 0107             }
; 0000 0108             else if(mode==2){
	RJMP _0x19
_0x18:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x1A
; 0000 0109               lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x2
; 0000 010A               lcd_puts("CAI GIO");
	__POINTW2MN _0x8,27
	CALL SUBOPT_0x3
; 0000 010B               timeDisplay(4,1);
; 0000 010C             }
; 0000 010D             else if(mode==3) {
	RJMP _0x1B
_0x1A:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0x1C
; 0000 010E               lcd_gotoxy(4,0);
	CALL SUBOPT_0x0
; 0000 010F               lcd_puts("CAI NGAY");
	__POINTW2MN _0x8,35
	RJMP _0x129
; 0000 0110               dateDisplay(3,1);
; 0000 0111             }
; 0000 0112             else if(mode==4) {
_0x1C:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x1E
; 0000 0113               lcd_gotoxy(4,0);
	CALL SUBOPT_0x0
; 0000 0114               lcd_puts("CAI THANG");
	__POINTW2MN _0x8,44
	RJMP _0x129
; 0000 0115               dateDisplay(3,1);
; 0000 0116             }
; 0000 0117             else if(mode==5) {
_0x1E:
	LDI  R30,LOW(5)
	CP   R30,R12
	BRNE _0x20
; 0000 0118               lcd_gotoxy(4,0);
	CALL SUBOPT_0x0
; 0000 0119               lcd_puts("CAI NAM");
	__POINTW2MN _0x8,54
_0x129:
	CALL _lcd_puts
; 0000 011A               dateDisplay(3,1);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _dateDisplay
; 0000 011B             }
; 0000 011C           }
_0x20:
_0x1B:
_0x19:
_0x17:
; 0000 011D 
; 0000 011E      }else{
	RJMP _0x21
_0xC:
; 0000 011F         alarm();
	RCALL _alarm
; 0000 0120         if(index==1)
	LDS  R26,_index
	CPI  R26,LOW(0x1)
	BRNE _0x22
; 0000 0121         {
; 0000 0122            lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2
; 0000 0123            lcd_puts("CAI PHUT BAT");
	__POINTW2MN _0x8,62
	CALL SUBOPT_0x4
; 0000 0124            alarmOnDisplay(5,1);
; 0000 0125         }
; 0000 0126         else if(index==2)
	RJMP _0x23
_0x22:
	LDS  R26,_index
	CPI  R26,LOW(0x2)
	BRNE _0x24
; 0000 0127         {
; 0000 0128            lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2
; 0000 0129            lcd_puts("CAI GIO BAT");
	__POINTW2MN _0x8,75
	CALL SUBOPT_0x4
; 0000 012A            alarmOnDisplay(5,1);
; 0000 012B         }
; 0000 012C         else if(index==3)
	RJMP _0x25
_0x24:
	LDS  R26,_index
	CPI  R26,LOW(0x3)
	BRNE _0x26
; 0000 012D         {
; 0000 012E            lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2
; 0000 012F            lcd_puts("CAI PHUT TAT");
	__POINTW2MN _0x8,87
	CALL SUBOPT_0x5
; 0000 0130            alarmOffDisplay(5,1);
; 0000 0131         }
; 0000 0132         else if(index==4)
	RJMP _0x27
_0x26:
	LDS  R26,_index
	CPI  R26,LOW(0x4)
	BRNE _0x28
; 0000 0133         {
; 0000 0134            lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2
; 0000 0135            lcd_puts("CAI GIO TAT");
	__POINTW2MN _0x8,100
	CALL SUBOPT_0x5
; 0000 0136            alarmOffDisplay(5,1);
; 0000 0137         }
; 0000 0138         else if(index==5)
	RJMP _0x29
_0x28:
	LDS  R26,_index
	CPI  R26,LOW(0x5)
	BRNE _0x2A
; 0000 0139         {
; 0000 013A            lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2
; 0000 013B            lcd_puts("CHE DO HEN GIO");
	__POINTW2MN _0x8,112
	CALL _lcd_puts
; 0000 013C            if(alarm_flag==1){
	CALL SUBOPT_0x6
	CPI  R30,LOW(0x1)
	BRNE _0x2B
; 0000 013D                 lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x1
; 0000 013E                 lcd_puts("BAT");
	__POINTW2MN _0x8,127
	RJMP _0x12A
; 0000 013F            }
; 0000 0140            else{
_0x2B:
; 0000 0141                 lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x1
; 0000 0142                 lcd_puts("TAT");
	__POINTW2MN _0x8,131
_0x12A:
	CALL _lcd_puts
; 0000 0143            }
; 0000 0144         }
; 0000 0145      }
_0x2A:
_0x29:
_0x27:
_0x25:
_0x23:
_0x21:
; 0000 0146       /****************************************************/
; 0000 0147 
; 0000 0148     }
	RJMP _0x9
; 0000 0149 }
_0x2D:
	RJMP _0x2D
; .FEND

	.DSEG
_0x8:
	.BYTE 0x87
;
;/**************************************************************************/
;void button(void)
; 0000 014D {

	.CSEG
_button:
; .FSTART _button
; 0000 014E   if(index==0){
	LDS  R30,_index
	CPI  R30,0
	BRNE _0x2E
; 0000 014F     if(MODE==0)
	SBIC 0x16,0
	RJMP _0x2F
; 0000 0150     {
; 0000 0151         lcd_clear();
	CALL _lcd_clear
; 0000 0152         mode++;
	INC  R12
; 0000 0153         if(mode>5) mode=0;
	LDI  R30,LOW(5)
	CP   R30,R12
	BRSH _0x30
	CLR  R12
; 0000 0154         while(!MODE);
_0x30:
_0x31:
	SBIS 0x16,0
	RJMP _0x31
; 0000 0155     }
; 0000 0156     if(UP==0)
_0x2F:
	SBIC 0x16,1
	RJMP _0x34
; 0000 0157     {
; 0000 0158         lcd_clear();
	CALL _lcd_clear
; 0000 0159         index=1;
	LDI  R30,LOW(1)
	STS  _index,R30
; 0000 015A         while(!UP);
_0x35:
	SBIS 0x16,1
	RJMP _0x35
; 0000 015B     }
; 0000 015C     if(DOWN==0)
_0x34:
	SBIC 0x16,3
	RJMP _0x38
; 0000 015D     {
; 0000 015E         lcd_clear();
	CALL _lcd_clear
; 0000 015F         lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2
; 0000 0160         lcd_puts("T_ON: ");
	__POINTW2MN _0x39,0
	CALL _lcd_puts
; 0000 0161         alarmOnDisplay(8,0);
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _alarmOnDisplay
; 0000 0162 
; 0000 0163         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1
; 0000 0164         lcd_puts("T_OFF:");
	__POINTW2MN _0x39,7
	CALL _lcd_puts
; 0000 0165         alarmOffDisplay(8,1);
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _alarmOffDisplay
; 0000 0166 
; 0000 0167         while(!DOWN);
_0x3A:
	SBIS 0x16,3
	RJMP _0x3A
; 0000 0168         lcd_clear();
	CALL _lcd_clear
; 0000 0169     }
; 0000 016A   }else{
_0x38:
	RJMP _0x3D
_0x2E:
; 0000 016B     if(MODE==0)
	SBIC 0x16,0
	RJMP _0x3E
; 0000 016C     {
; 0000 016D         lcd_clear();
	CALL _lcd_clear
; 0000 016E         index++;
	LDS  R30,_index
	SUBI R30,-LOW(1)
	STS  _index,R30
; 0000 016F         if(index>5) index=0;
	LDS  R26,_index
	CPI  R26,LOW(0x6)
	BRLO _0x3F
	LDI  R30,LOW(0)
	STS  _index,R30
; 0000 0170         while(!MODE);
_0x3F:
_0x40:
	SBIS 0x16,0
	RJMP _0x40
; 0000 0171     }
; 0000 0172   }
_0x3E:
_0x3D:
; 0000 0173 
; 0000 0174 }
	RET
; .FEND

	.DSEG
_0x39:
	.BYTE 0xE
;
;void readPin(void)
; 0000 0177 {

	.CSEG
_readPin:
; .FSTART _readPin
; 0000 0178     char i;
; 0000 0179     unsigned long ad=0;
; 0000 017A     DDRD.3=1;
	CALL SUBOPT_0x7
	LDI  R30,LOW(0)
	STD  Y+3,R30
	ST   -Y,R17
;	i -> R17
;	ad -> Y+1
	SBI  0x11,3
; 0000 017B     for(i=0;i<100;i++)
	LDI  R17,LOW(0)
_0x46:
	CPI  R17,100
	BRSH _0x47
; 0000 017C     {
; 0000 017D       ad+=read_adc(3);
	LDI  R26,LOW(3)
	RCALL _read_adc
	__GETD2S 1
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 1
; 0000 017E       delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
; 0000 017F     }
	SUBI R17,-1
	RJMP _0x46
_0x47:
; 0000 0180     adcPin=ad/100;
	__GETD2S 1
	__GETD1N 0x64
	CALL __DIVD21U
	MOVW R4,R30
; 0000 0181 }
	LDD  R17,Y+0
	RJMP _0x210000B
; .FEND
;unsigned int read_phase(unsigned char n)
; 0000 0183 {
_read_phase:
; .FSTART _read_phase
; 0000 0184   unsigned int ad=0;
; 0000 0185   unsigned char i;
; 0000 0186   for(i=0;i<30;i++)
	ST   -Y,R26
	CALL __SAVELOCR4
;	n -> Y+4
;	ad -> R16,R17
;	i -> R19
	__GETWRN 16,17,0
	LDI  R19,LOW(0)
_0x49:
	CPI  R19,30
	BRSH _0x4A
; 0000 0187   {
; 0000 0188     ad+=read_adc(n);
	LDD  R26,Y+4
	RCALL _read_adc
	__ADDWRR 16,17,30,31
; 0000 0189     delay_ms(4);
	LDI  R26,LOW(4)
	LDI  R27,0
	CALL _delay_ms
; 0000 018A   }
	SUBI R19,-1
	RJMP _0x49
_0x4A:
; 0000 018B   return (ad/30);
	MOVW R26,R16
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL __DIVW21U
	CALL __LOADLOCR4
_0x210000B:
	ADIW R28,5
	RET
; 0000 018C }
; .FEND
;void check_phase(void)
; 0000 018E {
_check_phase:
; .FSTART _check_phase
; 0000 018F   if(read_phase(0)<LOSS_PHASE || read_phase(1)<LOSS_PHASE || read_phase(2)<LOSS_PHASE)
	LDI  R26,LOW(0)
	CALL SUBOPT_0x8
	BRLO _0x4C
	LDI  R26,LOW(1)
	CALL SUBOPT_0x8
	BRLO _0x4C
	LDI  R26,LOW(2)
	CALL SUBOPT_0x8
	BRSH _0x4B
_0x4C:
; 0000 0190   {
; 0000 0191     RELAY=0;
	CBI  0x12,2
; 0000 0192     lcd_gotoxy(14,1);
	LDI  R30,LOW(14)
	CALL SUBOPT_0x1
; 0000 0193     lcd_putchar(0xff);
	LDI  R26,LOW(255)
	CALL _lcd_putchar
; 0000 0194     lcd_putchar(0xff);
	LDI  R26,LOW(255)
	RJMP _0x12B
; 0000 0195   }
; 0000 0196   else{
_0x4B:
; 0000 0197     RELAY=1;
	SBI  0x12,2
; 0000 0198     lcd_gotoxy(14,1);
	LDI  R30,LOW(14)
	CALL SUBOPT_0x1
; 0000 0199     lcd_putchar(0);
	LDI  R26,LOW(0)
	CALL _lcd_putchar
; 0000 019A     lcd_putchar(0);
	LDI  R26,LOW(0)
_0x12B:
	CALL _lcd_putchar
; 0000 019B   }
; 0000 019C }
	RET
; .FEND
;
;void display_PIN(unsigned char x, unsigned char y)
; 0000 019F {
_display_PIN:
; .FSTART _display_PIN
; 0000 01A0     /*
; 0000 01A1         %pin = 100*((ADC - ADCmin)/(ADCmax-ADCmin))
; 0000 01A2         ADC: adc hien tai
; 0000 01A3         ADCmax: adc khi pin o muc maximum theo datasheet
; 0000 01A4         ADCmin: adc khi pin o muc pin can theo datasheet
; 0000 01A5     */
; 0000 01A6     float percent;
; 0000 01A7     char pinBuffer[2];
; 0000 01A8     //percent=100*((878-767)/(920-767));
; 0000 01A9     if(adcPin<767) percent=0;
	ST   -Y,R26
	SBIW R28,6
;	x -> Y+7
;	y -> Y+6
;	percent -> Y+2
;	pinBuffer -> Y+0
	LDI  R30,LOW(767)
	LDI  R31,HIGH(767)
	CP   R4,R30
	CPC  R5,R31
	BRSH _0x53
	LDI  R30,LOW(0)
	__CLRD1S 2
; 0000 01AA     else{
	RJMP _0x54
_0x53:
; 0000 01AB         percent=((adcPin-767)*100)/153;
	MOVW R30,R4
	SUBI R30,LOW(767)
	SBCI R31,HIGH(767)
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12U
	MOVW R26,R30
	LDI  R30,LOW(153)
	LDI  R31,HIGH(153)
	CALL __DIVW21U
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL SUBOPT_0x9
; 0000 01AC         if(percent>100) percent=100;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x55
	CALL SUBOPT_0xB
	CALL SUBOPT_0x9
; 0000 01AD     }
_0x55:
_0x54:
; 0000 01AE     lcd_gotoxy(x,y);
	LDD  R30,Y+7
	ST   -Y,R30
	LDD  R26,Y+7
	CALL _lcd_gotoxy
; 0000 01AF     sprintf(pinBuffer,"%2.0f",percent);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,141
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 6
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 01B0     lcd_puts(pinBuffer);
	MOVW R26,R28
	CALL _lcd_puts
; 0000 01B1     lcd_puts("%");
	__POINTW2MN _0x56,0
	CALL _lcd_puts
; 0000 01B2 
; 0000 01B3     if(percent<30 && Charge_Flag==0){
	CALL SUBOPT_0xA
	__GETD1N 0x41F00000
	CALL __CMPF12
	BRSH _0x58
	SBRS R2,0
	RJMP _0x59
_0x58:
	RJMP _0x57
_0x59:
; 0000 01B4        DDRD.5=1; // output
	SBI  0x11,5
; 0000 01B5        Charge_Flag=1;
	SET
	BLD  R2,0
; 0000 01B6     }
; 0000 01B7     if(percent>=100){
_0x57:
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CALL __CMPF12
	BRLO _0x5C
; 0000 01B8        DDRD.5=0; // input
	CBI  0x11,5
; 0000 01B9        Charge_Flag=0;
	CLT
	BLD  R2,0
; 0000 01BA     }
; 0000 01BB     if(Charge_Flag){
_0x5C:
	SBRS R2,0
	RJMP _0x5F
; 0000 01BC         readPin();
	RCALL _readPin
; 0000 01BD         lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x2
; 0000 01BE         lcd_putchar(0xB7);
	LDI  R26,LOW(183)
	RJMP _0x12C
; 0000 01BF     }else{
_0x5F:
; 0000 01C0         lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x2
; 0000 01C1         lcd_putchar(0);
	LDI  R26,LOW(0)
_0x12C:
	CALL _lcd_putchar
; 0000 01C2     }
; 0000 01C3 }
	RJMP _0x2100008
; .FEND

	.DSEG
_0x56:
	.BYTE 0x2
;
;/*******************************************************
;  ----------------TIME & DATE-----------------------
;*********************************************************/
;void getTime()
; 0000 01C9 {

	.CSEG
_getTime:
; .FSTART _getTime
; 0000 01CA     rtc_get_time(&hour,&minn,&sec);
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	RCALL _rtc_get_time
; 0000 01CB     rtc_get_date(&day,&date,&month,&year);
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(13)
	LDI  R27,HIGH(13)
	RCALL _rtc_get_date
; 0000 01CC }
	RET
; .FEND
;void timeDisplay(unsigned char x, unsigned char y)
; 0000 01CE {
_timeDisplay:
; .FSTART _timeDisplay
; 0000 01CF   lcd_gotoxy(x,y);
	CALL SUBOPT_0xC
;	x -> Y+1
;	y -> Y+0
	CALL _lcd_gotoxy
; 0000 01D0   lcd_putchar(48+(hour/10));
	MOV  R26,R7
	CALL SUBOPT_0xD
; 0000 01D1   lcd_putchar(48+(hour%10));
	MOV  R26,R7
	CALL SUBOPT_0xE
; 0000 01D2   lcd_puts(":");
	__POINTW2MN _0x61,0
	CALL _lcd_puts
; 0000 01D3   lcd_putchar(48+(minn/10));
	MOV  R26,R6
	CALL SUBOPT_0xD
; 0000 01D4   lcd_putchar(48+(minn%10));
	MOV  R26,R6
	CALL SUBOPT_0xE
; 0000 01D5   lcd_puts(":");
	__POINTW2MN _0x61,2
	CALL _lcd_puts
; 0000 01D6   lcd_putchar(48+(sec/10));
	MOV  R26,R9
	CALL SUBOPT_0xD
; 0000 01D7   lcd_putchar(48+(sec%10));
	MOV  R26,R9
	CLR  R27
	RJMP _0x210000A
; 0000 01D8 }
; .FEND

	.DSEG
_0x61:
	.BYTE 0x4
;void dateDisplay(unsigned char x, unsigned char y)
; 0000 01DA {

	.CSEG
_dateDisplay:
; .FSTART _dateDisplay
; 0000 01DB   //lcd_gotoxy(x,y);
; 0000 01DC   dayDisplay(x,y);
	CALL SUBOPT_0xC
;	x -> Y+1
;	y -> Y+0
	RCALL _dayDisplay
; 0000 01DD   lcd_putchar(48+(date/10));
	MOV  R26,R11
	CALL SUBOPT_0xD
; 0000 01DE   lcd_putchar(48+(date%10));
	MOV  R26,R11
	CALL SUBOPT_0xE
; 0000 01DF   lcd_puts("/");
	__POINTW2MN _0x62,0
	CALL _lcd_puts
; 0000 01E0   lcd_putchar(48+(month/10));
	MOV  R26,R10
	CALL SUBOPT_0xD
; 0000 01E1   lcd_putchar(48+(month%10));
	MOV  R26,R10
	CALL SUBOPT_0xE
; 0000 01E2   lcd_puts("/");
	__POINTW2MN _0x62,2
	CALL _lcd_puts
; 0000 01E3   lcd_putchar(48+(year/10));
	MOV  R26,R13
	CALL SUBOPT_0xD
; 0000 01E4   lcd_putchar(48+(year%10));
	MOV  R26,R13
	CLR  R27
	RJMP _0x210000A
; 0000 01E5 }
; .FEND

	.DSEG
_0x62:
	.BYTE 0x4
;void dayDisplay(unsigned char x, unsigned char y)
; 0000 01E7 { int C;

	.CSEG
_dayDisplay:
; .FSTART _dayDisplay
; 0000 01E8 switch (month)
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	x -> Y+3
;	y -> Y+2
;	C -> R16,R17
	MOV  R30,R10
	LDI  R31,0
; 0000 01E9              {
; 0000 01EA              case 1: C=date;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x66
	MOV  R16,R11
	CLR  R17
; 0000 01EB                      break;
	RJMP _0x65
; 0000 01EC              case 2: C=31+date;
_0x66:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x67
	MOV  R30,R11
	LDI  R31,0
	ADIW R30,31
	MOVW R16,R30
; 0000 01ED                      break;
	RJMP _0x65
; 0000 01EE              case 3: if(year%4==0) C=60+date;
_0x67:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x68
	CALL SUBOPT_0xF
	BRNE _0x69
	MOV  R30,R11
	LDI  R31,0
	ADIW R30,60
	RJMP _0x12D
; 0000 01EF                      else C=59+date;
_0x69:
	MOV  R30,R11
	LDI  R31,0
	ADIW R30,59
_0x12D:
	MOVW R16,R30
; 0000 01F0                      break;
	RJMP _0x65
; 0000 01F1              case 4: if((year%4)==0) C=91+date;
_0x68:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x6B
	CALL SUBOPT_0xF
	BRNE _0x6C
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-91)
	SBCI R31,HIGH(-91)
	RJMP _0x12E
; 0000 01F2                      else C=90+date;
_0x6C:
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-90)
	SBCI R31,HIGH(-90)
_0x12E:
	MOVW R16,R30
; 0000 01F3                      break;
	RJMP _0x65
; 0000 01F4              case 5: if((year%4)==0) C=121+date;
_0x6B:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x6E
	CALL SUBOPT_0xF
	BRNE _0x6F
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-121)
	SBCI R31,HIGH(-121)
	RJMP _0x12F
; 0000 01F5                      else C=120+date;
_0x6F:
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-120)
	SBCI R31,HIGH(-120)
_0x12F:
	MOVW R16,R30
; 0000 01F6                      break;
	RJMP _0x65
; 0000 01F7              case 6: if((year%4)==0) C=152+date;
_0x6E:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x71
	CALL SUBOPT_0xF
	BRNE _0x72
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-152)
	SBCI R31,HIGH(-152)
	RJMP _0x130
; 0000 01F8                      else C=151+date;
_0x72:
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-151)
	SBCI R31,HIGH(-151)
_0x130:
	MOVW R16,R30
; 0000 01F9                      break;
	RJMP _0x65
; 0000 01FA              case 7: if((year%4)==0) C=182+date;
_0x71:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x74
	CALL SUBOPT_0xF
	BRNE _0x75
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-182)
	SBCI R31,HIGH(-182)
	RJMP _0x131
; 0000 01FB                      else C=181+date;
_0x75:
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-181)
	SBCI R31,HIGH(-181)
_0x131:
	MOVW R16,R30
; 0000 01FC                      break;
	RJMP _0x65
; 0000 01FD              case 8: if((year%4)==0) C=213+date;
_0x74:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x77
	CALL SUBOPT_0xF
	BRNE _0x78
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-213)
	SBCI R31,HIGH(-213)
	RJMP _0x132
; 0000 01FE                      else C=212+date;
_0x78:
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-212)
	SBCI R31,HIGH(-212)
_0x132:
	MOVW R16,R30
; 0000 01FF                      break;
	RJMP _0x65
; 0000 0200              case 9: if((year%4)==0) C=244+date;
_0x77:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x7A
	CALL SUBOPT_0xF
	BRNE _0x7B
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-244)
	SBCI R31,HIGH(-244)
	RJMP _0x133
; 0000 0201                      else C=243+date;
_0x7B:
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-243)
	SBCI R31,HIGH(-243)
_0x133:
	MOVW R16,R30
; 0000 0202                      break;
	RJMP _0x65
; 0000 0203              case 10:if((year%4)==0) C=274+date;
_0x7A:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x7D
	CALL SUBOPT_0xF
	BRNE _0x7E
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-274)
	SBCI R31,HIGH(-274)
	RJMP _0x134
; 0000 0204                      else C=273+date;
_0x7E:
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-273)
	SBCI R31,HIGH(-273)
_0x134:
	MOVW R16,R30
; 0000 0205                      break;
	RJMP _0x65
; 0000 0206              case 11:if((year%4)==0) C=305+date;
_0x7D:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x80
	CALL SUBOPT_0xF
	BRNE _0x81
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-305)
	SBCI R31,HIGH(-305)
	RJMP _0x135
; 0000 0207                      else C=304+date;
_0x81:
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-304)
	SBCI R31,HIGH(-304)
_0x135:
	MOVW R16,R30
; 0000 0208                      break;
	RJMP _0x65
; 0000 0209              case 12:if((year%4)==0) C=335+date;
_0x80:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x86
	CALL SUBOPT_0xF
	BRNE _0x84
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-335)
	SBCI R31,HIGH(-335)
	RJMP _0x136
; 0000 020A                      else C=334+date;
_0x84:
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-334)
	SBCI R31,HIGH(-334)
_0x136:
	MOVW R16,R30
; 0000 020B                      break;
; 0000 020C              default:
_0x86:
; 0000 020D              }
_0x65:
; 0000 020E              lcd_gotoxy(x,y);
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+3
	CALL _lcd_gotoxy
; 0000 020F              //cong thuc tinh thu:
; 0000 0210             // n=((years-1)+((years-1)/4)-((years-1)/100)+((years-1)/400)+C)%7
; 0000 0211             // n: thu trong tuan (0=CN;1=T2.....6=t7)
; 0000 0212             // C: ngay thu bao nhieu tu dau nam den hien tai
; 0000 0213  switch(((2000+year-1)+((2000+year-1)/4)-((2000+year-1)/100)+((2000+year-1)/400)+C)%7)
	CALL SUBOPT_0x10
	MOVW R22,R30
	MOVW R26,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	__ADDWRR 22,23,30,31
	CALL SUBOPT_0x10
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	__SUBWRR 22,23,30,31
	CALL SUBOPT_0x10
	MOVW R26,R30
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL __DIVW21
	ADD  R30,R22
	ADC  R31,R23
	ADD  R30,R16
	ADC  R31,R17
	MOVW R26,R30
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL __MODW21
; 0000 0214             {
; 0000 0215                 case 0: lcd_puts("CN-"); break;
	SBIW R30,0
	BRNE _0x8A
	__POINTW2MN _0x8B,0
	CALL _lcd_puts
	RJMP _0x89
; 0000 0216                 case 1: lcd_puts("T2-"); break;
_0x8A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x8C
	__POINTW2MN _0x8B,4
	CALL _lcd_puts
	RJMP _0x89
; 0000 0217                 case 2: lcd_puts("T3-"); break;
_0x8C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x8D
	__POINTW2MN _0x8B,8
	CALL _lcd_puts
	RJMP _0x89
; 0000 0218                 case 3: lcd_puts("T4-"); break;
_0x8D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x8E
	__POINTW2MN _0x8B,12
	CALL _lcd_puts
	RJMP _0x89
; 0000 0219                 case 4: lcd_puts("T5-"); break;
_0x8E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x8F
	__POINTW2MN _0x8B,16
	CALL _lcd_puts
	RJMP _0x89
; 0000 021A                 case 5: lcd_puts("T6-"); break;
_0x8F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x90
	__POINTW2MN _0x8B,20
	CALL _lcd_puts
	RJMP _0x89
; 0000 021B                 case 6: lcd_puts("T7-"); break;
_0x90:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x92
	__POINTW2MN _0x8B,24
	CALL _lcd_puts
; 0000 021C                 default:
_0x92:
; 0000 021D             }
_0x89:
; 0000 021E }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND

	.DSEG
_0x8B:
	.BYTE 0x1C
;void alarmOnDisplay(unsigned char x, unsigned char y)
; 0000 0220 {

	.CSEG
_alarmOnDisplay:
; .FSTART _alarmOnDisplay
; 0000 0221     lcd_gotoxy(x,y);
	CALL SUBOPT_0xC
;	x -> Y+1
;	y -> Y+0
	CALL _lcd_gotoxy
; 0000 0222     lcd_putchar(48+(hour_on/10));
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
; 0000 0223     lcd_putchar(48+(hour_on%10));
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
; 0000 0224     lcd_puts(":");
	__POINTW2MN _0x93,0
	CALL _lcd_puts
; 0000 0225     lcd_putchar(48+(min_on/10));
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
; 0000 0226     lcd_putchar(48+(min_on%10));
	LDI  R26,LOW(_min_on)
	LDI  R27,HIGH(_min_on)
	RJMP _0x2100009
; 0000 0227 }
; .FEND

	.DSEG
_0x93:
	.BYTE 0x2
;void alarmOffDisplay(unsigned char x, unsigned char y)
; 0000 0229 {

	.CSEG
_alarmOffDisplay:
; .FSTART _alarmOffDisplay
; 0000 022A     lcd_gotoxy(x,y);
	CALL SUBOPT_0xC
;	x -> Y+1
;	y -> Y+0
	CALL _lcd_gotoxy
; 0000 022B     lcd_putchar(48+(hour_off/10));
	CALL SUBOPT_0x16
	CALL SUBOPT_0x15
; 0000 022C     lcd_putchar(48+(hour_off%10));
	CALL SUBOPT_0x16
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x13
; 0000 022D     lcd_puts(":");
	__POINTW2MN _0x94,0
	CALL _lcd_puts
; 0000 022E     lcd_putchar(48+(min_off/10));
	CALL SUBOPT_0x17
	CALL SUBOPT_0x15
; 0000 022F     lcd_putchar(48+(min_off%10));
	LDI  R26,LOW(_min_off)
	LDI  R27,HIGH(_min_off)
_0x2100009:
	CALL __EEPROMRDB
	LDI  R31,0
	MOVW R26,R30
_0x210000A:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x13
; 0000 0230 }
	ADIW R28,2
	RET
; .FEND

	.DSEG
_0x94:
	.BYTE 0x2
;void so_ngay(void)
; 0000 0232 {

	.CSEG
_so_ngay:
; .FSTART _so_ngay
; 0000 0233   if(month==2)     // thang 2 nam nhuan co 29 ngay, nam thuong co 28 ngay
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x95
; 0000 0234   {
; 0000 0235    if(year%4==0)   //&&year%100!=0||year%400==0)
	CALL SUBOPT_0xF
	BRNE _0x96
; 0000 0236    {
; 0000 0237     No_date=29;
	LDI  R30,LOW(29)
	RJMP _0x137
; 0000 0238    }
; 0000 0239    else
_0x96:
; 0000 023A    {
; 0000 023B     No_date=28;
	LDI  R30,LOW(28)
_0x137:
	STS  _No_date,R30
; 0000 023C    };
; 0000 023D   }
; 0000 023E 
; 0000 023F   else
	RJMP _0x98
_0x95:
; 0000 0240   {
; 0000 0241    if(month==4||month==6||month==9||month==11)
	LDI  R30,LOW(4)
	CP   R30,R10
	BREQ _0x9A
	LDI  R30,LOW(6)
	CP   R30,R10
	BREQ _0x9A
	LDI  R30,LOW(9)
	CP   R30,R10
	BREQ _0x9A
	LDI  R30,LOW(11)
	CP   R30,R10
	BRNE _0x99
_0x9A:
; 0000 0242    {
; 0000 0243     No_date=30;
	LDI  R30,LOW(30)
	RJMP _0x138
; 0000 0244    }
; 0000 0245 
; 0000 0246    else
_0x99:
; 0000 0247    {
; 0000 0248     if(month==1||month==3||month==5||month==7||month==8||month==10||month==12)
	LDI  R30,LOW(1)
	CP   R30,R10
	BREQ _0x9E
	LDI  R30,LOW(3)
	CP   R30,R10
	BREQ _0x9E
	LDI  R30,LOW(5)
	CP   R30,R10
	BREQ _0x9E
	LDI  R30,LOW(7)
	CP   R30,R10
	BREQ _0x9E
	LDI  R30,LOW(8)
	CP   R30,R10
	BREQ _0x9E
	LDI  R30,LOW(10)
	CP   R30,R10
	BREQ _0x9E
	LDI  R30,LOW(12)
	CP   R30,R10
	BRNE _0x9D
_0x9E:
; 0000 0249     {
; 0000 024A      No_date=31;
	LDI  R30,LOW(31)
_0x138:
	STS  _No_date,R30
; 0000 024B     }
; 0000 024C    };
_0x9D:
; 0000 024D   };
_0x98:
; 0000 024E 
; 0000 024F }
	RET
; .FEND
;void setting(void)
; 0000 0251 {
_setting:
; .FSTART _setting
; 0000 0252 //================================================
; 0000 0253  if(mode==1)   //chinh phut
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0xA0
; 0000 0254  {
; 0000 0255    if(UP==0)  // phim "UP" nhan
	SBIC 0x16,1
	RJMP _0xA1
; 0000 0256         {
; 0000 0257         if(minn==59)
	LDI  R30,LOW(59)
	CP   R30,R6
	BRNE _0xA2
; 0000 0258             {
; 0000 0259             minn=0;
	CLR  R6
; 0000 025A             }
; 0000 025B         else
	RJMP _0xA3
_0xA2:
; 0000 025C             {
; 0000 025D             minn++;
	INC  R6
; 0000 025E             };
_0xA3:
; 0000 025F         rtc_set_time(hour,minn,sec);
	CALL SUBOPT_0x18
; 0000 0260         while(!UP); // doi nha phim
_0xA4:
	SBIS 0x16,1
	RJMP _0xA4
; 0000 0261         }
; 0000 0262    //==============
; 0000 0263    if(DOWN==0)        // phim "DOWN" nhan
_0xA1:
	SBIC 0x16,3
	RJMP _0xA7
; 0000 0264         {
; 0000 0265         if(minn==0)
	TST  R6
	BRNE _0xA8
; 0000 0266             {
; 0000 0267             minn=59;
	LDI  R30,LOW(59)
	MOV  R6,R30
; 0000 0268             }
; 0000 0269         else
	RJMP _0xA9
_0xA8:
; 0000 026A             {
; 0000 026B             minn--;
	DEC  R6
; 0000 026C             };
_0xA9:
; 0000 026D         rtc_set_time(hour,minn,sec);
	CALL SUBOPT_0x18
; 0000 026E         while(!DOWN);
_0xAA:
	SBIS 0x16,3
	RJMP _0xAA
; 0000 026F         }
; 0000 0270  }
_0xA7:
; 0000 0271  //===============================
; 0000 0272   if(mode==2)   //chinh gio
_0xA0:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0xAD
; 0000 0273     {
; 0000 0274    if(UP==0)  // phim "UP" nhan
	SBIC 0x16,1
	RJMP _0xAE
; 0000 0275         {
; 0000 0276         if(hour==23)
	LDI  R30,LOW(23)
	CP   R30,R7
	BRNE _0xAF
; 0000 0277             {
; 0000 0278             hour=0;
	CLR  R7
; 0000 0279             }
; 0000 027A         else
	RJMP _0xB0
_0xAF:
; 0000 027B             {
; 0000 027C             hour++;
	INC  R7
; 0000 027D             };
_0xB0:
; 0000 027E         rtc_set_time(hour,minn,sec);
	CALL SUBOPT_0x18
; 0000 027F         while(!UP); // doi nha phim
_0xB1:
	SBIS 0x16,1
	RJMP _0xB1
; 0000 0280         }
; 0000 0281    //==============
; 0000 0282    if(DOWN==0)        // phim "DOWN" nhan
_0xAE:
	SBIC 0x16,3
	RJMP _0xB4
; 0000 0283         {
; 0000 0284         if(hour==0)
	TST  R7
	BRNE _0xB5
; 0000 0285             {
; 0000 0286             hour=23;
	LDI  R30,LOW(23)
	MOV  R7,R30
; 0000 0287             }
; 0000 0288         else
	RJMP _0xB6
_0xB5:
; 0000 0289             {
; 0000 028A             hour--;
	DEC  R7
; 0000 028B             };
_0xB6:
; 0000 028C         rtc_set_time(hour,minn,sec);
	CALL SUBOPT_0x18
; 0000 028D         while(!DOWN);
_0xB7:
	SBIS 0x16,3
	RJMP _0xB7
; 0000 028E         }
; 0000 028F     }
_0xB4:
; 0000 0290  //===============================
; 0000 0291  if(mode==3) //chinh ngay
_0xAD:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0xBA
; 0000 0292     {
; 0000 0293     so_ngay();
	RCALL _so_ngay
; 0000 0294     //================================
; 0000 0295     if(UP==0) // phim "UP" nhan
	SBIC 0x16,1
	RJMP _0xBB
; 0000 0296         {
; 0000 0297         if(date==No_date)
	LDS  R30,_No_date
	CP   R30,R11
	BRNE _0xBC
; 0000 0298             {
; 0000 0299             date=1;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 029A             }
; 0000 029B         else
	RJMP _0xBD
_0xBC:
; 0000 029C             {
; 0000 029D             date++;
	INC  R11
; 0000 029E             };
_0xBD:
; 0000 029F         rtc_set_date(day,date,month,year);
	CALL SUBOPT_0x19
; 0000 02A0         while(!UP);
_0xBE:
	SBIS 0x16,1
	RJMP _0xBE
; 0000 02A1         }
; 0000 02A2     //=========================================
; 0000 02A3     if(DOWN==0)        // phim "DOWN" nhan
_0xBB:
	SBIC 0x16,3
	RJMP _0xC1
; 0000 02A4         {
; 0000 02A5 
; 0000 02A6         if(date==1)
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0xC2
; 0000 02A7             {
; 0000 02A8             date=No_date;
	LDS  R11,_No_date
; 0000 02A9             }
; 0000 02AA         else
	RJMP _0xC3
_0xC2:
; 0000 02AB             {
; 0000 02AC             date--;
	DEC  R11
; 0000 02AD             };
_0xC3:
; 0000 02AE         rtc_set_date(day,date,month,year);
	CALL SUBOPT_0x19
; 0000 02AF         while(!DOWN);
_0xC4:
	SBIS 0x16,3
	RJMP _0xC4
; 0000 02B0         }
; 0000 02B1     }
_0xC1:
; 0000 02B2  //================================================
; 0000 02B3     if(mode==4)  //chinh thang
_0xBA:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0xC7
; 0000 02B4     {
; 0000 02B5         //==================================
; 0000 02B6     if(UP==0)
	SBIC 0x16,1
	RJMP _0xC8
; 0000 02B7         {
; 0000 02B8         if(month==12)
	LDI  R30,LOW(12)
	CP   R30,R10
	BRNE _0xC9
; 0000 02B9             {
; 0000 02BA             month=1;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 02BB             }
; 0000 02BC         else
	RJMP _0xCA
_0xC9:
; 0000 02BD             {
; 0000 02BE             month++;
	INC  R10
; 0000 02BF             };
_0xCA:
; 0000 02C0         rtc_set_date(day,date,month,year);
	CALL SUBOPT_0x19
; 0000 02C1         while(!UP);                                       // bao co phim nhan
_0xCB:
	SBIS 0x16,1
	RJMP _0xCB
; 0000 02C2         }
; 0000 02C3 /////////////////////////////////////////////////////////////
; 0000 02C4     if(DOWN==0)
_0xC8:
	SBIC 0x16,3
	RJMP _0xCE
; 0000 02C5         {
; 0000 02C6         if(month==1)
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0xCF
; 0000 02C7             {
; 0000 02C8             month=12;
	LDI  R30,LOW(12)
	MOV  R10,R30
; 0000 02C9             }
; 0000 02CA         else
	RJMP _0xD0
_0xCF:
; 0000 02CB             {
; 0000 02CC             month--;
	DEC  R10
; 0000 02CD             };
_0xD0:
; 0000 02CE         rtc_set_date(day,date,month,year);
	CALL SUBOPT_0x19
; 0000 02CF         while(!DOWN);
_0xD1:
	SBIS 0x16,3
	RJMP _0xD1
; 0000 02D0         }
; 0000 02D1     }
_0xCE:
; 0000 02D2     //=================================
; 0000 02D3     if(mode==5) //chinh nam
_0xC7:
	LDI  R30,LOW(5)
	CP   R30,R12
	BRNE _0xD4
; 0000 02D4     {
; 0000 02D5     if(UP==0)
	SBIC 0x16,1
	RJMP _0xD5
; 0000 02D6         {
; 0000 02D7         if(year==99)
	LDI  R30,LOW(99)
	CP   R30,R13
	BRNE _0xD6
; 0000 02D8             {
; 0000 02D9             year=0;
	CLR  R13
; 0000 02DA             }
; 0000 02DB         else
	RJMP _0xD7
_0xD6:
; 0000 02DC             {
; 0000 02DD             year++;
	INC  R13
; 0000 02DE             };
_0xD7:
; 0000 02DF         rtc_set_date(day,date,month,year);
	CALL SUBOPT_0x19
; 0000 02E0         while(!UP);
_0xD8:
	SBIS 0x16,1
	RJMP _0xD8
; 0000 02E1         }
; 0000 02E2 ///////////////////////////////////////////////////////////////
; 0000 02E3     if(DOWN==0)
_0xD5:
	SBIC 0x16,3
	RJMP _0xDB
; 0000 02E4         {
; 0000 02E5         if(year==00)
	TST  R13
	BRNE _0xDC
; 0000 02E6             {
; 0000 02E7             year=99;
	LDI  R30,LOW(99)
	MOV  R13,R30
; 0000 02E8             }
; 0000 02E9         else
	RJMP _0xDD
_0xDC:
; 0000 02EA             {
; 0000 02EB             year--;
	DEC  R13
; 0000 02EC             };
_0xDD:
; 0000 02ED         rtc_set_date(day,date,month,year);
	CALL SUBOPT_0x19
; 0000 02EE         while(!DOWN);
_0xDE:
	SBIS 0x16,3
	RJMP _0xDE
; 0000 02EF         }
; 0000 02F0     }
_0xDB:
; 0000 02F1 }
_0xD4:
	RET
; .FEND
;
;void alarm(void)
; 0000 02F4 {
_alarm:
; .FSTART _alarm
; 0000 02F5    switch(index)
	LDS  R30,_index
	LDI  R31,0
; 0000 02F6    {
; 0000 02F7     case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xE4
; 0000 02F8         if(UP==0)
	SBIC 0x16,1
	RJMP _0xE5
; 0000 02F9         {
; 0000 02FA             if(min_on==59)
	CALL SUBOPT_0x14
	CPI  R30,LOW(0x3B)
	BRNE _0xE6
; 0000 02FB                 {
; 0000 02FC                 min_on=0;
	LDI  R26,LOW(_min_on)
	LDI  R27,HIGH(_min_on)
	LDI  R30,LOW(0)
	RJMP _0x139
; 0000 02FD                 }
; 0000 02FE             else
_0xE6:
; 0000 02FF                 {
; 0000 0300                 min_on++;
	CALL SUBOPT_0x14
	SUBI R30,-LOW(1)
_0x139:
	CALL __EEPROMWRB
; 0000 0301                 };
; 0000 0302             while(!UP); // doi nha phim
_0xE8:
	SBIS 0x16,1
	RJMP _0xE8
; 0000 0303         }
; 0000 0304         else if(DOWN==0)
	RJMP _0xEB
_0xE5:
	SBIC 0x16,3
	RJMP _0xEC
; 0000 0305         {
; 0000 0306             if(min_on==0)
	CALL SUBOPT_0x14
	CPI  R30,0
	BRNE _0xED
; 0000 0307                 {
; 0000 0308                 min_on=59;
	LDI  R26,LOW(_min_on)
	LDI  R27,HIGH(_min_on)
	LDI  R30,LOW(59)
	RJMP _0x13A
; 0000 0309                 }
; 0000 030A             else
_0xED:
; 0000 030B                 {
; 0000 030C                 min_on--;
	CALL SUBOPT_0x14
	SUBI R30,LOW(1)
_0x13A:
	CALL __EEPROMWRB
; 0000 030D                 };
; 0000 030E             while(!DOWN); // doi nha phim
_0xEF:
	SBIS 0x16,3
	RJMP _0xEF
; 0000 030F         }
; 0000 0310         break;
_0xEC:
_0xEB:
	RJMP _0xE3
; 0000 0311     case 2:
_0xE4:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xF2
; 0000 0312         if(UP==0)
	SBIC 0x16,1
	RJMP _0xF3
; 0000 0313         {
; 0000 0314             if(hour_on==23)
	CALL SUBOPT_0x1A
	CPI  R30,LOW(0x17)
	BRNE _0xF4
; 0000 0315                 {
; 0000 0316                 hour_on=0;
	LDI  R26,LOW(_hour_on)
	LDI  R27,HIGH(_hour_on)
	LDI  R30,LOW(0)
	RJMP _0x13B
; 0000 0317                 }
; 0000 0318             else
_0xF4:
; 0000 0319                 {
; 0000 031A                 hour_on++;
	CALL SUBOPT_0x1A
	SUBI R30,-LOW(1)
_0x13B:
	CALL __EEPROMWRB
; 0000 031B                 };
; 0000 031C             while(!UP); // doi nha phim
_0xF6:
	SBIS 0x16,1
	RJMP _0xF6
; 0000 031D         }
; 0000 031E         else if(DOWN==0)
	RJMP _0xF9
_0xF3:
	SBIC 0x16,3
	RJMP _0xFA
; 0000 031F         {
; 0000 0320             if(hour_on==0)
	CALL SUBOPT_0x1A
	CPI  R30,0
	BRNE _0xFB
; 0000 0321                 {
; 0000 0322                 hour_on=23;
	LDI  R26,LOW(_hour_on)
	LDI  R27,HIGH(_hour_on)
	LDI  R30,LOW(23)
	RJMP _0x13C
; 0000 0323                 }
; 0000 0324             else
_0xFB:
; 0000 0325                 {
; 0000 0326                 hour_on--;
	CALL SUBOPT_0x1A
	SUBI R30,LOW(1)
_0x13C:
	CALL __EEPROMWRB
; 0000 0327                 };
; 0000 0328             while(!DOWN); // doi nha phim
_0xFD:
	SBIS 0x16,3
	RJMP _0xFD
; 0000 0329         }
; 0000 032A         break;
_0xFA:
_0xF9:
	RJMP _0xE3
; 0000 032B     case 3:
_0xF2:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x100
; 0000 032C         if(UP==0)
	SBIC 0x16,1
	RJMP _0x101
; 0000 032D         {
; 0000 032E             if(min_off==59)
	CALL SUBOPT_0x17
	CPI  R30,LOW(0x3B)
	BRNE _0x102
; 0000 032F                 {
; 0000 0330                 min_off=0;
	LDI  R26,LOW(_min_off)
	LDI  R27,HIGH(_min_off)
	LDI  R30,LOW(0)
	RJMP _0x13D
; 0000 0331                 }
; 0000 0332             else
_0x102:
; 0000 0333                 {
; 0000 0334                 min_off++;
	CALL SUBOPT_0x17
	SUBI R30,-LOW(1)
_0x13D:
	CALL __EEPROMWRB
; 0000 0335                 };
; 0000 0336             while(!UP); // doi nha phim
_0x104:
	SBIS 0x16,1
	RJMP _0x104
; 0000 0337         }
; 0000 0338         else if(DOWN==0)
	RJMP _0x107
_0x101:
	SBIC 0x16,3
	RJMP _0x108
; 0000 0339         {
; 0000 033A             if(min_off==0)
	CALL SUBOPT_0x17
	CPI  R30,0
	BRNE _0x109
; 0000 033B                 {
; 0000 033C                 min_off=59;
	LDI  R26,LOW(_min_off)
	LDI  R27,HIGH(_min_off)
	LDI  R30,LOW(59)
	RJMP _0x13E
; 0000 033D                 }
; 0000 033E             else
_0x109:
; 0000 033F                 {
; 0000 0340                 min_off--;
	CALL SUBOPT_0x17
	SUBI R30,LOW(1)
_0x13E:
	CALL __EEPROMWRB
; 0000 0341                 };
; 0000 0342             while(!DOWN); // doi nha phim
_0x10B:
	SBIS 0x16,3
	RJMP _0x10B
; 0000 0343         }
; 0000 0344         break;
_0x108:
_0x107:
	RJMP _0xE3
; 0000 0345     case 4:
_0x100:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x10E
; 0000 0346         if(UP==0)
	SBIC 0x16,1
	RJMP _0x10F
; 0000 0347         {
; 0000 0348             if(hour_off==23)
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x17)
	BRNE _0x110
; 0000 0349                 {
; 0000 034A                 hour_off=0;
	LDI  R26,LOW(_hour_off)
	LDI  R27,HIGH(_hour_off)
	LDI  R30,LOW(0)
	RJMP _0x13F
; 0000 034B                 }
; 0000 034C             else
_0x110:
; 0000 034D                 {
; 0000 034E                 hour_off++;
	CALL SUBOPT_0x16
	SUBI R30,-LOW(1)
_0x13F:
	CALL __EEPROMWRB
; 0000 034F                 };
; 0000 0350             while(!UP); // doi nha phim
_0x112:
	SBIS 0x16,1
	RJMP _0x112
; 0000 0351         }
; 0000 0352         else if(DOWN==0)
	RJMP _0x115
_0x10F:
	SBIC 0x16,3
	RJMP _0x116
; 0000 0353         {
; 0000 0354             if(hour_off==0)
	CALL SUBOPT_0x16
	CPI  R30,0
	BRNE _0x117
; 0000 0355                 {
; 0000 0356                 hour_off=23;
	LDI  R26,LOW(_hour_off)
	LDI  R27,HIGH(_hour_off)
	LDI  R30,LOW(23)
	RJMP _0x140
; 0000 0357                 }
; 0000 0358             else
_0x117:
; 0000 0359                 {
; 0000 035A                 hour_off--;
	CALL SUBOPT_0x16
	SUBI R30,LOW(1)
_0x140:
	CALL __EEPROMWRB
; 0000 035B                 };
; 0000 035C             while(!DOWN); // doi nha phim
_0x119:
	SBIS 0x16,3
	RJMP _0x119
; 0000 035D         }
; 0000 035E         break;
_0x116:
_0x115:
	RJMP _0xE3
; 0000 035F     case 5:
_0x10E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xE3
; 0000 0360         if(UP==0)
	SBIC 0x16,1
	RJMP _0x11D
; 0000 0361         {
; 0000 0362             alarm_flag++;
	CALL SUBOPT_0x6
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 0363             if(alarm_flag>1) alarm_flag=0;
	CALL SUBOPT_0x6
	CPI  R30,LOW(0x2)
	BRLO _0x11E
	LDI  R26,LOW(_alarm_flag)
	LDI  R27,HIGH(_alarm_flag)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0364             while(!UP); // doi nha phim
_0x11E:
_0x11F:
	SBIS 0x16,1
	RJMP _0x11F
; 0000 0365         }
; 0000 0366         else if(DOWN==0)
	RJMP _0x122
_0x11D:
	SBIC 0x16,3
	RJMP _0x123
; 0000 0367         {
; 0000 0368             alarm_flag--;
	CALL SUBOPT_0x6
	SUBI R30,LOW(1)
	CALL __EEPROMWRB
; 0000 0369             if(alarm_flag<0) alarm_flag=1;
	CALL SUBOPT_0x6
	MOV  R26,R30
; 0000 036A             while(!DOWN); // doi nha phim
_0x125:
	SBIS 0x16,3
	RJMP _0x125
; 0000 036B         }
; 0000 036C         break;
_0x123:
_0x122:
; 0000 036D 
; 0000 036E    }
_0xE3:
; 0000 036F }
	RET
; .FEND

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2000003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2000003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2000004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2000004:
	CALL SUBOPT_0x1B
	LDI  R26,LOW(7)
	CALL _i2c_write
	LDD  R26,Y+2
	CALL SUBOPT_0x1C
	ADIW R28,3
	RET
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x1B
	LDI  R26,LOW(0)
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	MOV  R26,R30
	CALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL _i2c_stop
	ADIW R28,6
	RET
; .FEND
_rtc_set_time:
; .FSTART _rtc_set_time
	ST   -Y,R26
	CALL SUBOPT_0x1B
	LDI  R26,LOW(0)
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1C
	JMP  _0x2100003
; .FEND
_rtc_get_date:
; .FSTART _rtc_get_date
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x1B
	LDI  R26,LOW(3)
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	CALL SUBOPT_0x1F
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1E
	CALL _i2c_stop
_0x2100008:
	ADIW R28,8
	RET
; .FEND
_rtc_set_date:
; .FSTART _rtc_set_date
	ST   -Y,R26
	CALL SUBOPT_0x1B
	LDI  R26,LOW(3)
	CALL _i2c_write
	LDD  R26,Y+3
	CALL SUBOPT_0x23
	CALL SUBOPT_0x22
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1C
	JMP  _0x2100001
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x7
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x202000D
	CALL SUBOPT_0x24
	__POINTW2FN _0x2020000,0
	CALL _strcpyf
	RJMP _0x2100007
_0x202000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x202000C
	CALL SUBOPT_0x24
	__POINTW2FN _0x2020000,1
	CALL _strcpyf
	RJMP _0x2100007
_0x202000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x202000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	LDI  R30,LOW(45)
	ST   X,R30
_0x202000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2020010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2020010:
	LDD  R17,Y+8
_0x2020011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2020013
	CALL SUBOPT_0x27
	CALL SUBOPT_0x9
	RJMP _0x2020011
_0x2020013:
	CALL SUBOPT_0x28
	CALL __ADDF12
	CALL SUBOPT_0x25
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	CALL SUBOPT_0x9
_0x2020014:
	CALL SUBOPT_0x28
	CALL __CMPF12
	BRLO _0x2020016
	CALL SUBOPT_0xA
	CALL SUBOPT_0x29
	CALL SUBOPT_0x9
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2020017
	CALL SUBOPT_0x24
	__POINTW2FN _0x2020000,5
	CALL _strcpyf
	RJMP _0x2100007
_0x2020017:
	RJMP _0x2020014
_0x2020016:
	CPI  R17,0
	BRNE _0x2020018
	CALL SUBOPT_0x26
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2020019
_0x2020018:
_0x202001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x202001C
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2A
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x9
	CALL SUBOPT_0x28
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x26
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	CALL SUBOPT_0xA
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	RJMP _0x202001A
_0x202001C:
_0x2020019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x2100006
	CALL SUBOPT_0x26
	LDI  R30,LOW(46)
	ST   X,R30
_0x202001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2020020
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x29
	CALL SUBOPT_0x25
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x26
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	CALL SUBOPT_0x2B
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x2C
	RJMP _0x202001E
_0x2020020:
_0x2100006:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2100007:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G102:
; .FSTART _put_buff_G102
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x2D
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2040013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	CALL SUBOPT_0x2D
_0x2040014:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__ftoe_G102:
; .FSTART __ftoe_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2040019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2040000,0
	CALL _strcpyf
	RJMP _0x2100005
_0x2040019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2040018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2040000,1
	CALL _strcpyf
	RJMP _0x2100005
_0x2040018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x204001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x204001B:
	LDD  R17,Y+11
_0x204001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x204001E
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	RJMP _0x204001C
_0x204001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x204001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	RJMP _0x2040020
_0x204001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x30
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040021
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
_0x2040022:
	CALL SUBOPT_0x30
	BRLO _0x2040024
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
	RJMP _0x2040022
_0x2040024:
	RJMP _0x2040025
_0x2040021:
_0x2040026:
	CALL SUBOPT_0x30
	BRSH _0x2040028
	CALL SUBOPT_0x31
	CALL SUBOPT_0x29
	CALL SUBOPT_0x33
	SUBI R19,LOW(1)
	RJMP _0x2040026
_0x2040028:
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
_0x2040025:
	__GETD1S 12
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x33
	CALL SUBOPT_0x30
	BRLO _0x2040029
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
_0x2040029:
_0x2040020:
	LDI  R17,LOW(0)
_0x204002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRSH PC+2
	RJMP _0x204002C
	__GETD2S 4
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	CALL SUBOPT_0x2A
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x2F
	__GETD1S 4
	CALL SUBOPT_0x31
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x34
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x31
	CALL __SWAPD12
	CALL __SUBF12
	CALL SUBOPT_0x33
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x204002A
	CALL SUBOPT_0x34
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x204002A
_0x204002C:
	CALL SUBOPT_0x35
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x204002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2040113
_0x204002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2040113:
	ST   X,R30
	CALL SUBOPT_0x35
	CALL SUBOPT_0x35
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x35
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2100005:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x2D
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2040036
	CPI  R18,37
	BRNE _0x2040037
	LDI  R17,LOW(1)
	RJMP _0x2040038
_0x2040037:
	CALL SUBOPT_0x36
_0x2040038:
	RJMP _0x2040035
_0x2040036:
	CPI  R30,LOW(0x1)
	BRNE _0x2040039
	CPI  R18,37
	BRNE _0x204003A
	CALL SUBOPT_0x36
	RJMP _0x2040114
_0x204003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x204003B
	LDI  R16,LOW(1)
	RJMP _0x2040035
_0x204003B:
	CPI  R18,43
	BRNE _0x204003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2040035
_0x204003C:
	CPI  R18,32
	BRNE _0x204003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2040035
_0x204003D:
	RJMP _0x204003E
_0x2040039:
	CPI  R30,LOW(0x2)
	BRNE _0x204003F
_0x204003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040040
	ORI  R16,LOW(128)
	RJMP _0x2040035
_0x2040040:
	RJMP _0x2040041
_0x204003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2040042
_0x2040041:
	CPI  R18,48
	BRLO _0x2040044
	CPI  R18,58
	BRLO _0x2040045
_0x2040044:
	RJMP _0x2040043
_0x2040045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2040035
_0x2040043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2040046
	LDI  R17,LOW(4)
	RJMP _0x2040035
_0x2040046:
	RJMP _0x2040047
_0x2040042:
	CPI  R30,LOW(0x4)
	BRNE _0x2040049
	CPI  R18,48
	BRLO _0x204004B
	CPI  R18,58
	BRLO _0x204004C
_0x204004B:
	RJMP _0x204004A
_0x204004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2040035
_0x204004A:
_0x2040047:
	CPI  R18,108
	BRNE _0x204004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2040035
_0x204004D:
	RJMP _0x204004E
_0x2040049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2040035
_0x204004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2040053
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
	CALL SUBOPT_0x37
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x39
	RJMP _0x2040054
_0x2040053:
	CPI  R30,LOW(0x45)
	BREQ _0x2040057
	CPI  R30,LOW(0x65)
	BRNE _0x2040058
_0x2040057:
	RJMP _0x2040059
_0x2040058:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x204005A
_0x2040059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x3A
	CALL __GETD1P
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3C
	LDD  R26,Y+13
	TST  R26
	BRMI _0x204005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x204005D
	CPI  R26,LOW(0x20)
	BREQ _0x204005F
	RJMP _0x2040060
_0x204005B:
	CALL SUBOPT_0x3D
	CALL __ANEGF1
	CALL SUBOPT_0x3B
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x204005D:
	SBRS R16,7
	RJMP _0x2040061
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x39
	RJMP _0x2040062
_0x2040061:
_0x204005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2040062:
_0x2040060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2040064
	CALL SUBOPT_0x3D
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2040065
_0x2040064:
	CALL SUBOPT_0x3D
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G102
_0x2040065:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x3E
	RJMP _0x2040066
_0x204005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2040068
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x3E
	RJMP _0x2040069
_0x2040068:
	CPI  R30,LOW(0x70)
	BRNE _0x204006B
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3F
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x204006D
	CP   R20,R17
	BRLO _0x204006E
_0x204006D:
	RJMP _0x204006C
_0x204006E:
	MOV  R17,R20
_0x204006C:
_0x2040066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x204006F
_0x204006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2040072
	CPI  R30,LOW(0x69)
	BRNE _0x2040073
_0x2040072:
	ORI  R16,LOW(4)
	RJMP _0x2040074
_0x2040073:
	CPI  R30,LOW(0x75)
	BRNE _0x2040075
_0x2040074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2040076
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x40
	LDI  R17,LOW(10)
	RJMP _0x2040077
_0x2040076:
	__GETD1N 0x2710
	CALL SUBOPT_0x40
	LDI  R17,LOW(5)
	RJMP _0x2040077
_0x2040075:
	CPI  R30,LOW(0x58)
	BRNE _0x2040079
	ORI  R16,LOW(8)
	RJMP _0x204007A
_0x2040079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20400B8
_0x204007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x204007C
	__GETD1N 0x10000000
	CALL SUBOPT_0x40
	LDI  R17,LOW(8)
	RJMP _0x2040077
_0x204007C:
	__GETD1N 0x1000
	CALL SUBOPT_0x40
	LDI  R17,LOW(4)
_0x2040077:
	CPI  R20,0
	BREQ _0x204007D
	ANDI R16,LOW(127)
	RJMP _0x204007E
_0x204007D:
	LDI  R20,LOW(1)
_0x204007E:
	SBRS R16,1
	RJMP _0x204007F
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3A
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2040115
_0x204007F:
	SBRS R16,2
	RJMP _0x2040081
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3F
	CALL __CWD1
	RJMP _0x2040115
_0x2040081:
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3F
	CLR  R22
	CLR  R23
_0x2040115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2040083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2040084
	CALL SUBOPT_0x3D
	CALL __ANEGD1
	CALL SUBOPT_0x3B
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2040084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2040085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2040086
_0x2040085:
	ANDI R16,LOW(251)
_0x2040086:
_0x2040083:
	MOV  R19,R20
_0x204006F:
	SBRC R16,0
	RJMP _0x2040087
_0x2040088:
	CP   R17,R21
	BRSH _0x204008B
	CP   R19,R21
	BRLO _0x204008C
_0x204008B:
	RJMP _0x204008A
_0x204008C:
	SBRS R16,7
	RJMP _0x204008D
	SBRS R16,2
	RJMP _0x204008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x204008F
_0x204008E:
	LDI  R18,LOW(48)
_0x204008F:
	RJMP _0x2040090
_0x204008D:
	LDI  R18,LOW(32)
_0x2040090:
	CALL SUBOPT_0x36
	SUBI R21,LOW(1)
	RJMP _0x2040088
_0x204008A:
_0x2040087:
_0x2040091:
	CP   R17,R20
	BRSH _0x2040093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2040094
	CALL SUBOPT_0x41
	BREQ _0x2040095
	SUBI R21,LOW(1)
_0x2040095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2040094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x39
	CPI  R21,0
	BREQ _0x2040096
	SUBI R21,LOW(1)
_0x2040096:
	SUBI R20,LOW(1)
	RJMP _0x2040091
_0x2040093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2040097
_0x2040098:
	CPI  R19,0
	BREQ _0x204009A
	SBRS R16,3
	RJMP _0x204009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x204009C
_0x204009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x204009C:
	CALL SUBOPT_0x36
	CPI  R21,0
	BREQ _0x204009D
	SUBI R21,LOW(1)
_0x204009D:
	SUBI R19,LOW(1)
	RJMP _0x2040098
_0x204009A:
	RJMP _0x204009E
_0x2040097:
_0x20400A0:
	CALL SUBOPT_0x42
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20400A2
	SBRS R16,3
	RJMP _0x20400A3
	SUBI R18,-LOW(55)
	RJMP _0x20400A4
_0x20400A3:
	SUBI R18,-LOW(87)
_0x20400A4:
	RJMP _0x20400A5
_0x20400A2:
	SUBI R18,-LOW(48)
_0x20400A5:
	SBRC R16,4
	RJMP _0x20400A7
	CPI  R18,49
	BRSH _0x20400A9
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20400A8
_0x20400A9:
	RJMP _0x20400AB
_0x20400A8:
	CP   R20,R19
	BRSH _0x2040116
	CP   R21,R19
	BRLO _0x20400AE
	SBRS R16,0
	RJMP _0x20400AF
_0x20400AE:
	RJMP _0x20400AD
_0x20400AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20400B0
_0x2040116:
	LDI  R18,LOW(48)
_0x20400AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20400B1
	CALL SUBOPT_0x41
	BREQ _0x20400B2
	SUBI R21,LOW(1)
_0x20400B2:
_0x20400B1:
_0x20400B0:
_0x20400A7:
	CALL SUBOPT_0x36
	CPI  R21,0
	BREQ _0x20400B3
	SUBI R21,LOW(1)
_0x20400B3:
_0x20400AD:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x42
	CALL __MODD21U
	CALL SUBOPT_0x3B
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x40
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20400A1
	RJMP _0x20400A0
_0x20400A1:
_0x204009E:
	SBRS R16,0
	RJMP _0x20400B4
_0x20400B5:
	CPI  R21,0
	BREQ _0x20400B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x39
	RJMP _0x20400B5
_0x20400B7:
_0x20400B4:
_0x20400B8:
_0x2040054:
_0x2040114:
	LDI  R17,LOW(0)
_0x2040035:
	RJMP _0x2040030
_0x2040032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x43
	SBIW R30,0
	BRNE _0x20400B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2100004
_0x20400B9:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x43
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2100004:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
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
	__DELAY_USB 13
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	RJMP _0x2100002
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
	__DELAY_USB 133
	RJMP _0x2100002
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
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x44
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x44
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2060005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
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
	RJMP _0x2100002
_0x2060007:
_0x2060004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2100002
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
_0x2100003:
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
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
	CALL SUBOPT_0x45
	CALL SUBOPT_0x45
	CALL SUBOPT_0x45
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G103
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2100002:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_bcd2bin:
; .FSTART _bcd2bin
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
; .FEND
_bin2bcd:
; .FSTART _bin2bcd
	ST   -Y,R26
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret
; .FEND

	.CSEG

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x2100001
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x2100001:
	ADIW R28,4
	RET
; .FEND

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
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
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_No_date:
	.BYTE 0x1
_index:
	.BYTE 0x1

	.ESEG
_hour_on:
	.BYTE 0x1
_min_on:
	.BYTE 0x1
_hour_off:
	.BYTE 0x1
_min_off:
	.BYTE 0x1
_alarm_flag:
	.BYTE 0x1

	.DSEG
__seed_G101:
	.BYTE 0x4
__base_y_G103:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	CALL _lcd_puts
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _timeDisplay

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	CALL _lcd_puts
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _alarmOnDisplay

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	CALL _lcd_puts
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _alarmOffDisplay

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(_alarm_flag)
	LDI  R27,HIGH(_alarm_flag)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	CALL _read_phase
	CPI  R30,LOW(0x2B2)
	LDI  R26,HIGH(0x2B2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	__GETD1N 0x42C80000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0xD:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xE:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0xF:
	MOV  R26,R13
	CLR  R27
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __MODW21
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	MOV  R30,R13
	LDI  R31,0
	SUBI R30,LOW(-2000)
	SBCI R31,HIGH(-2000)
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(_hour_on)
	LDI  R27,HIGH(_hour_on)
	CALL __EEPROMRDB
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(_min_on)
	LDI  R27,HIGH(_min_on)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(_hour_off)
	LDI  R27,HIGH(_hour_off)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(_min_off)
	LDI  R27,HIGH(_min_off)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18:
	ST   -Y,R7
	ST   -Y,R6
	MOV  R26,R9
	JMP  _rtc_set_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x19:
	ST   -Y,R8
	ST   -Y,R11
	ST   -Y,R10
	MOV  R26,R13
	JMP  _rtc_set_date

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(_hour_on)
	LDI  R27,HIGH(_hour_on)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	CALL _i2c_start
	LDI  R26,LOW(208)
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	CALL _i2c_write
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	CALL _i2c_start
	LDI  R26,LOW(209)
	CALL _i2c_write
	LDI  R26,LOW(1)
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	MOV  R26,R30
	CALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R26,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	CALL _i2c_write
	LD   R26,Y
	CALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	CALL _i2c_write
	LDD  R26,Y+1
	CALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	CALL _i2c_write
	LDD  R26,Y+2
	CALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x25:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x26:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	RCALL SUBOPT_0xA
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x29:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2A:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	CALL __SWAPD12
	CALL __SUBF12
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2E:
	__GETD2S 4
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x30:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x32:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x35:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x36:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x37:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x38:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x39:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3A:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3C:
	RCALL SUBOPT_0x37
	RJMP SUBOPT_0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3E:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3F:
	RCALL SUBOPT_0x3A
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x40:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x41:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x42:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x45:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G103
	__DELAY_USW 200
	RET


	.CSEG
	.equ __sda_bit=7
	.equ __scl_bit=6
	.equ __i2c_port=0x12 ;PORTD
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

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

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

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

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
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

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
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

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
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
