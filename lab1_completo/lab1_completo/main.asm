;
; lab1_completo.asm
;
; Created: 29/09/2017 10:13:23 a.m.
; Author : Guillermo
;

//////////////////////////////////////////////////////////////
///////////////definicones/////////////////////////////
			.EQU SW1=0
			.EQU SW2=1
			.equ VAL=9
			.DEF TEMP1=R16
			.DEF TEMP2=R17
			.DEF SAL= R18
			.DEF cont=R22
		.EQU	VAL_1=0X10
		.EQU	VAL_2=0XC6
		.EQU	VAL_3=0XC9
		.EQU	VAL_4=0X30	;VALORES PARA EL DELAY
		.EQU	VAL_5=255
		.EQU	VAL_6=200	;VALORES PARA EL DELAY2



//////////////inicializacion///////////////////
			.org 0x0000
			LDI TEMP1,0XFF
			OUT DDRA, TEMP1
			CLR TEMP1
			OUT PORTA, TEMP1
			LDI TEMP1, 0XFC
			OUT DDRC, TEMP1

/////////////secuencia de inicio///////////////
/////////BARRIDO DE LOS LEDS//////////
		LDI cont, 0x01
		OUT PORTA, cont
ida:	lsl cont
		OUT PORTA, cont
		CPI cont, 0x80
		BREQ volta
		RJMP ida
volta:  LSR cont
		OUT PORTA,cont
		CPI cont, 0x01
		BREQ fangio
		rjmp volta
fangio:		CLR TEMP1
			RJMP LOOP
//////////////////////////////////////
			LDI TEMP1, 1
			LDI TEMP2, 0
			LDI SAL, 0

/////////////programa //////////////////////
LOOP:		SBIS PINC, SW1   ;evalúo si el swtich1 esta activado
			rjmp SUMA
			SBIS PINC, SW2
			CALL CLEAR
			RJMP LOOP

SUMA:	
	
SEG:	MOV SAL, TEMP1		;copiar contenido de temp1 a sal
		SWAP SAL			;se cambian los nibbles sal
		ADD SAL, TEMP2		;suma el contendio de temp2 con sal para tener una palabra completa
		OUT PORTA, SAL		;postea el valor de sal al puerto A
		CLR SAL				;borra el contenido de sal
		CPI TEMP2,VAL		;compara valores de temp con 10
		BRGE PRI			;si es menor ssalta a la siguiente instruccion sino salta a pri
		INC TEMP2			;incrementa el contadot temp2=temp2+1
		RJMP LOOP			;salta a etiqueta sef
PRI:	CLR TEMP2			;limpia el contenido del registro temp2
		CPI TEMP1,VAL		;compara el contenido de temp2 y val
		BRGE LOOP			;si es menor que 10 siguea la siguiente instruccion sino salta a fin
		INC TEMP1			;incrementa el contador de temp1 en 1 temp1=temp1+1


		RJMP SEG			;salta a la etiqueta seg
CLEAR:	CLR TEMP1
		OUT PORTA,TEMP1
		RET

		;DELAY EXTENSO PARA HACER EL BARRIDO DE LOS LED
DELAY:	LDI		R20,VAL_1
ACA0:	LDI		R21,VAL_2
ACA1:	LDI		R19,VAL_3
ACA2:	DEC		R19
		BRNE	ACA2
		DEC		R21
		BRNE	ACA1
		DEC		R20
		BRNE	ACA0
		LDI		R20,VAL_4
ACA3:	DEC		R20
		BRNE	ACA3
		RET

;DELAY CORTO PARA EVITAR EL REBOTE DE LOS PULSADORES
;APROXIMADAMENTE 11 ms
DELAY2:	LDI		R20,VAL_5
LOOP1:	LDI		R21,VAL_6
LOOP2:	DEC		R21
		BRNE	LOOP2
		DEC		R20
		BRNE	LOOP1
		RET
