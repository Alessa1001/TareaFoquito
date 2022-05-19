

SYSTICK	EQU 0XE000E000				;dirección base de systema 
	
SYSTICK_CTRL	EQU SYSTICK + 0X010	;direccion del registro CTRL de systick
SYSTICK_RELOAD	EQU SYSTICK + 0X014	;direccion del registro RELOAD de systick
SYSTICK_CURRENT	EQU SYSTICK + 0X018	;direccion del registro CURRENT de systick
;--------------------------------------------------------

		AREA    |.text|, CODE, READONLY, ALIGN=2		;Inicia código
        THUMB											;activa generar código de 16 bits
		EXPORT prender
		EXPORT apagar									;función definida en esta sección
;------------------------------------------------------------------------------------------
prender	
		LDR R1, =SYSTICK_CTRL							;toma direrción de SYSTICKCTRL
		LDR R0, [R1]									;le el registro SYSTICKCTRL
		BIC R0, R0, #0X0F								;se desactiva systick ENABLE=0
		STR R0, [R1]									;se almacena el dato
;-------------------------------------------------------------------------------------------
		LDR R1, =SYSTICK_CURRENT						;toma direrción de SYSTICKCURRENT
		LDR R0, [R1]									;Lee el registro SYSTICKCURRENT
		BIC R0, #0X0FFFFFF								;lo pone en ceros
		STR R0, [R1]									;almacena el valor
;-------------------------------------------------------------------------------------------
		;Operaciones:
		;Cuenta = (4x10^6) - 1=3999999 -> 3D08FF
		;Cuenta + 1 = (1 seg)(4x10^6) = 4x10^6
		;Tiempo = (Cuenta + 1)/frecuencia -> Sea 1 seg = 3999999
		;entonces si quiero hacer mi tiempo igual a 2 seg hago: 3999999*2= 7999998
		LDR R1, =SYSTICK_RELOAD							;toma direrción de SYSTICKRELOAD
		MOV32 R0, #7999998								;carga R0 con el valor para 2 segundos
		STR R0, [R1]									;almacena el valor en SYSTICKRELOAD
;--------------------------------------------------------------------------------------------
		LDR R1, =SYSTICK_CTRL							;carga la direrción de SYSTICKCTRL en R1
		LDR R0, [R1]									;le el registro SYSTICKCTRL
		ORR R0, R0, #0X01								;activa systick ENABLE=1
		STR R0, [R1]									;se almacena ese valor en SYSTICKCTRL
		LDR R1, =SYSTICK_CTRL							;carga la direrción de SYSTICKCTRL en R1
loop
		LDR R0, [R1]									;se lee el registro SYSTICKCTRL 
		ANDS R0, #0X010000								;convierte valor en cero o uno dependiendo de CLK_SRC
		BEQ loop										;si CLK_SRC=0 salta a loop
		LDR R1, =SYSTICK_CTRL							;toma direrción de SYSTICKCTRL
		LDR R0, [R1]									;le el registro SYSTICKCTRL
		BIC R0, R0, #0X01								;se desactiva systick ENABLE=0
		STR R0, [R1]									;se almacena el dato
		BX LR											;regresa utilizando LR
	
;******************************rutina para apagar**************************
apagar

	LDR R1, =SYSTICK_CTRL
		LDR R0, [R1]
		BIC R0, R0, #0X01
		STR R0, [R1]
;----------------------------------------------------
		LDR R1, =SYSTICK_CURRENT
		LDR R0, [R1]
		BIC R0, #0X0FFFFFF
		STR R0, [R1]
;-----------------------------------------------------
		;Tiempo = (Cuenta + 1)/frecuencia -> Sea 1 seg = 3999999
		;entonces si quiero hacer mi tiempo igual a 1/2 seg hago: 3999999/2= 1999999
		LDR R1, =SYSTICK_RELOAD
		MOV32 R0, #1999999
		STR R0, [R1]
;-----------------------------------------------------
		LDR R1, =SYSTICK_CTRL
		LDR R0, [R1]
		ORR R0, R0, #0X01
		STR R0, [R1]
;------------------------------------------------------
		LDR R1, =SYSTICK_CTRL
loop1
		LDR R0, [R1]
		ANDS R0, #0X010000
		BEQ loop1
		BX LR
		
		ALIGN                           ; make sure the end of this section is aligned
		END  