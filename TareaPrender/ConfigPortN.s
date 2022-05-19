;***********************************************
;Configuro Puerto N pin 0 como salida
;***********************************************
GPION EQU 0x40064000		;puerto N dir base
	
	
GPIO_PORTN_DIR  	EQU GPION + 0x400	;registro para configurar direccion de datos
GPIO_PORTN_AFSEL 	EQU GPION + 0x420	;selecciona función alternativa
GPIO_PORTN_DEN  	EQU GPION + 0x51C	;coloca el puerto como digital
GPIO_PORTN_PCTL 	EQU GPION +	0x52C

	
SYSCT_RCGCGPIO		EQU 0x400FE608		;Dirección para activar puertos
SYSCT_RCGCGPIO_R12	EQU 0x00001000		;valor para activar el puerto N
SYSCTL_PRGPIO		EQU	0x400FEA08		;dirección para verificar puerto listo
SYSCTL_PRGPIO_R12	EQU 0x00001000
	
		AREA    |.text|, CODE, READONLY, ALIGN=2
		THUMB
		EXPORT ConfN
		
ConfN
	LDR R1, =SYSCT_RCGCGPIO     	; R1 = SYSCT_RCGCGPIO (puntero)
    LDR R0, [R1]                    ; R0 = [R1] (leo valor)
    ORR R0, R0, #SYSCT_RCGCGPIO_R12  ; R0 = R0|SYSCTL_RCGCGPIO_R12
    STR R0, [R1]                    ; [R1] = R0	
	
	;---------------------------------------------------------------------------	
	;Espero hasta que el puerto se estabilice
    
    LDR R1, =SYSCTL_PRGPIO       	; R1 = SYSCTL_PRGPIO (puntero)
GPIOCinitloop
    LDR R0, [R1]                    ; R0 = [R1] (lee valor)
    ANDS R0, R0, #SYSCTL_PRGPIO_R12  ; R0 = R0&SYSCTL_PRGPIO_R%
    ;BEQ GPIOCinitloop 
	
;-----------------------------------------------------------------------------	
    ; Coloca pin N0 como salida
	
    LDR R1, =GPIO_PORTN_DIR         ; R1 = GPIO_PORTN_DIR (puntero)
    LDR R0, [R1]                    ; R0 = [R1] (lee valor)
    ORR R0, R0, #0x01               ; R0 = (Configuro pin 0 del puerto N como salida)
    STR R0, [R1]	
;-------------------------------------------------------------------------------
    ;Selección de funcion alternativa 
	
    LDR R1, =GPIO_PORTN_AFSEL       ; R1 = GPIO_PORTN_AFSEL (puntero)
    LDR R0, [R1]                    ; R0 = [R1] (lee valor)
    BIC R0, R0, #0x00               ; R0 = R0&~0x01 (dehabilitafunción alternativa de PF0)
    STR R0, [R1] 	
;-------------------------------------------------------------------------------	
    ; set digital enable register
    LDR R1, =GPIO_PORTN_DEN       ; R1 = GPIO_PORTN_DEN_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #0x01               ; R0 = R0|0x01 (enable digital I/O on PF0)
    STR R0, [R1]    				; [R1] = R0
	BX LR
;*****************************************************************************************
					
	
	ALIGN                           ; make sure the end of this section is aligned
	END                             ; end of file