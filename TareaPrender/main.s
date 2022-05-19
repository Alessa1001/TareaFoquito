;***********************************************
;Alessandra Andrade Ac
;***********************************************
GPIO_PORTN_DATO  	EQU 0x40064004	;mascara del puerto N

		

		AREA |.text|, CODE, READONLY, ALIGN = 2
		THUMB
		
		IMPORT ConfN
		IMPORT prender
		IMPORT apagar
		EXPORT Start
			
Start
		BL ConfN					;Salta a la funci�n ConfN en ConfigPortN
		MOV R8, #0x01				;Mueve el valor 0x01 a R8
		LDR R0, =GPIO_PORTN_DATO	;toma direcci�n de GPIO_PORTN_DATO
		STR R8, [R0]				;Almacena el dato
		BL prender					;Salta a la funci�n prender en systick
		
Interruptor
		TST R8, #0x01				;Verifica si el valor del bit 0 
		BEQ PRENDE					;Si es cero salta a la funci�n PRENDE
		B APAGA						;Si no lo es salta a la funci�n APAGA
		
PRENDE
		MOV R8, #0x01				;Mueve el valor 0x01 a R8
		LDR R0, =GPIO_PORTN_DATO	;toma direcci�n de GPIO_PORTN_DATO
		STR R8, [R0]				;Almacena el dato 
		BL prender					;Salta a la funcion prender en el systick
		B Interruptor				;Salta a la funcion Interruptor en el main
		
APAGA
		MOV R8, #0x00				;Mueve el valor 0x00 a R8
		LDR R0, =GPIO_PORTN_DATO	;toma la direcci�n de GPIO_PORTN_DATO
		STR R8, [R0]				;Almacena el dato
		BL apagar					;Salta a la funcion apagar
		B Interruptor				;Salta a la funcion Interruptor
		
		ALIGN 
		END