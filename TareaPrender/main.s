SYSTICK				EQU 0XE000E000	
SYSTICK_CTRL		EQU 0xE000E010	;direccion del registro CTRL de systick
GPIO_PORTC_DATO  	EQU 0x4005D004	;mascara del puerto c

		

		AREA |.text|, CODE, READONLY, ALIGN = 2
		THUMB
		
		IMPORT ConfC
		IMPORT prender
		IMPORT apagar
		EXPORT Start
			
Start
		BL ConfC
		MOV R8, #0x01
		LDR R0, =GPIO_PORTC_DATO
		STR R8, [R0]
		BL prender
		
Interruptor
		TST R8, #0x01
		BEQ APAGA
		B PRENDE
		
PRENDE
		MOV R8, #0x01
		LDR R0, =GPIO_PORTC_DATO
		STR R8, [R0]
		BL prender
		B Interruptor	
		
APAGA
		MOV R8, #0x00
		LDR R0, =GPIO_PORTC_DATO
		STR R8, [R0]
		BL apagar
		BL Interruptor
		
		
		
		ALIGN 
		END