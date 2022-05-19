;***********************************************
;Configuro Puerto C pin 0 como salida
;***********************************************
GPIOC EQU 0x4005D000		;puerto C dir base
	
	
GPIO_PORTC_DIR  	EQU GPIOC + 0x400	;registro para configurar direccion de datos
GPIO_PORTC_AFSEL 	EQU GPIOC + 0x420	;selecciona función alternativa
GPIO_PORTC_DEN  	EQU GPIOC + 0x51C	;coloca el puerto como digital
GPIO_PORTC_PCTL 	EQU GPIOC +	0x52C

	
SYSCT_RCGCGPIO		EQU 0x400FE608		;Dirección para activar puertos
SYSCT_RCGCGPIO_R2	EQU 0x00000020		;valor para activar el puerto C
SYSCTL_PRGPIO		EQU	0x400FEA08		;dirección para verificar puerto listo
SYSCTL_PRGPIO_R2	EQU 0x00000020
	
		AREA    |.text|, CODE, READONLY, ALIGN=2
		THUMB
		EXPORT ConfC
		
ConfC
	LDR R1, =SYSCT_RCGCGPIO     	; R1 = SYSCT_RCGCGPIO (puntero)
    LDR R0, [R1]                    ; R0 = [R1] (leo valor)
    ORR R0, R0, #SYSCT_RCGCGPIO_R2  ; R0 = R0|SYSCTL_RCGCGPIO_R3
    STR R0, [R1]                    ; [R1] = R0	
	
	;---------------------------------------------------------------------------	
	;Espero hasta que el puerto se estabilice
    
    LDR R1, =SYSCTL_PRGPIO       	; R1 = SYSCTL_PRGPIO (puntero)
GPIOCinitloop
    LDR R0, [R1]                    ; R0 = [R1] (lee valor)
    ANDS R0, R0, #SYSCTL_PRGPIO_R2  ; R0 = R0&SYSCTL_PRGPIO_R%
    ;BEQ GPIOCinitloop 
	
;-----------------------------------------------------------------------------	
    ; Coloca pin C2 como salida
	
    LDR R1, =GPIO_PORTC_DIR         ; R1 = GPIO_PORTF_DIR (puntero)
    LDR R0, [R1]                    ; R0 = [R1] (lee valor)
    ORR R0, R0, #0x01               ; R0 = (Configuro pin 2 del puerto C como salida)
    STR R0, [R1]	
;-------------------------------------------------------------------------------
    ;Selección de funcion alternativa 
	
    LDR R1, =GPIO_PORTC_AFSEL       ; R1 = GPIO_PORTF_AFSEL (puntero)
    LDR R0, [R1]                    ; R0 = [R1] (lee valor)
    BIC R0, R0, #0x00               ; R0 = R0&~0x01 (dehabilitafunción alternativa de PF0)
    STR R0, [R1] 	
;-------------------------------------------------------------------------------	
    ; set digital enable register
    LDR R1, =GPIO_PORTC_DEN       ; R1 = GPIO_PORTF_DEN_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #0x01               ; R0 = R0|0x01 (enable digital I/O on PF0)
    STR R0, [R1]    				; [R1] = R0
;------------------------------------------------------------------------------------
    ; set port control register
    ;LDR R1, =GPIO_PORTC_PCTL        ; R1 = GPIO_PORTJ_PCTL (puntero)
    ;LDR R0, [R1]                    ; R0 = [R1] (lee valor)
    ;BIC R0, R0, #0x0000000F         ; R0 = R0&0xFFFFFFF0 (pone en cero F0)
    ;STR R0, [R1]                    ; [R1] = R0
	BX LR
;*****************************************************************************************
					
	
			ALIGN                           ; make sure the end of this section is aligned
			END                             ; end of file