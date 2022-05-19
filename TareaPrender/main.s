SYSTICK				EQU 0XE000E000	
SYSTICK_CTRL		EQU 0xE000E010	;direccion del registro CTRL de systick
GPIO_PORTN_DATO  	EQU 0x40064004	;mascara del puerto c

		

		AREA |.text|, CODE, READONLY, ALIGN = 2
		THUMB
		
		IMPORT ConfN
		IMPORT prender
		IMPORT apagar
		EXPORT Start
			
Start
		BL ConfN
		MOV R8, #0x01
		LDR R0, =GPIO_PORTN_DATO
		STR R8, [R0]
		BL prender
		
Interruptor
		TST R8, #0x01
		BEQ APAGA
		B PRENDE
		
PRENDE
		MOV R8, #0x01
		LDR R0, =GPIO_PORTN_DATO
		STR R8, [R0]
		BL prender
		B Interruptor	
		
APAGA
		MOV R8, #0x00
		LDR R0, =GPIO_PORTN_DATO
		STR R8, [R0]
		BL apagar
		B Interruptor
		
		ALIGN 
		END