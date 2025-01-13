; Arquivo com as funções de entrada e saida (I/O)

global CONFIG_VIDEO, LEITURA_TECLA
extern tecla, tecla_primida, save_offset, save_segment, verifica1, verifica2, modo_anterior

LEITURA_TECLA:
		PUSHF
		PUSH AX
		PUSH BX
    
ESPERA:	
    MOV	AX, [verifica1]	
		CMP AX, [verifica2]
		JE ESPERA
		INC WORD [verifica2]
		AND WORD [verifica2], 7

		POP BX
		POP AX
		POPF

		RET

INTERRUPCAO_TECLADO:
		PUSHF  
		PUSH	AX	
		PUSH	BX	
		PUSH	CX	
		PUSH	DX	
		PUSH	DS
		PUSH	ES	

		;faz a leitura do teclado e armazena o valor
		IN 		AL, 0x60
		INC     WORD [verifica1]
		AND     WORD [verifica1], 7
		;MOV		BX, [verifica1]
		MOV		[1+tecla], AL
		MOV		AL, [1+tecla]
		MOV		[tecla_primida], AL

		; Limpa a interrupção do teclado
		IN      AL, kb_ctl				
    OR      AL, 80h					
    OUT     kb_ctl, AL				
    AND     AL, 7Fh					
    OUT     kb_ctl, AL	
		
		; notifica fim da interrupçao ao PIC			
    MOV     AL, eoi					
    OUT     pictrl, AL
		
		POP		ES
		POP		DS
		POP 	DX
		POP 	CX
		POP 	BX
		POP 	AX
		POPF
		IRET

;Salva o endereço do tratamento padrao da interrupçao 9h	
CONFIG_PIC:	
  PUSHF  
	PUSH	AX	
	PUSH	BX	
	PUSH	CX	
	PUSH	DX	
	PUSH	DS
	PUSH	ES

  
  CLI
	MOV AX, 0
	MOV ES, AX

	CLI
	MOV		AX, [ES:INTr*4]
	MOV 	[save_offset], AX
	MOV		AX, [ES:INTr*4+2]
	MOV		[save_segment], AX
	MOV		[ES:INTr*4+2], CS
	MOV		word[ES:INTr*4], INTERRUPCAO_TECLADO
	STI

  POP		ES
	POP		DS
	POP 	DX
	POP 	CX
	POP 	BX
	POP 	AX
	POPF

  RET

CONFIG_VIDEO:
    PUSHF
    PUSH AX
    
    ;Salvar modo corrente de video(vendo como esta o modo de video da maquina)
    MOV AH, 0Fh
    INT 10h
    MOV [modo_anterior], AL   

    ;Alterar modo de video para grafico 640x480 16 cores
    MOV 	AL, 12h
    MOV 	AH, 0
    INT 	10h

    POP AX
    POPF

    RET

%include "src\defs.asm"
