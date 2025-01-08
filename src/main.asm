; Felipe Albuquerque e Jordano Furtado

extern line, full_circle, circle, cursor, caracter, plot_xy, RETANGULO, DESENHA_BLOCOS_P1_E_P2
global cor

segment code
..start:
;Inicializa os registradores
    MOV AX, data
    MOV DS, AX
    MOV AX, stack
    MOV SS, AX
    MOV SP, stacktop
		
;salva o endereço do tratamento padrao da interrupçao 9h	
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
;Salvar modo corrente de video(vendo como esta o modo de video da maquina)
    MOV AH, 0Fh
    INT 10h
    MOV [modo_anterior], AL   

;Alterar modo de video para grafico 640x480 16 cores
    MOV 	AL, 12h
   	MOV 	AH, 0
    INT 	10h
	
;Gera menu
	MOV	byte [cor], branco_intenso
	CALL MENU
	MOV DL, 14 ;salva informaçoes para printar a seta de seleçao
	MOV DH, 15
	MOV	BX, 0

SELECAO:
		MOV		byte[cor], branco_intenso
		CALL 	cursor
    	MOV  	AL, [BX+selecao]
		CALL 	caracter		 
		
		CALL LEITURA_TECLA

		CMP		byte[tecla_primida], 4Dh						;seta para a direita foi apertada
		JE		TROCA_DIREITA
		CMP		byte[tecla_primida], 4Bh						; seta para a esquerda foi apertada
		JE		TROCA_ESQUERDA
		CMP		byte[tecla_primida], 1Ch						; enter foi apertado
		JE		JOGO
		JMP 	SELECAO

TROCA_DIREITA:
		MOV		byte[cor], preto			;apaga seta		
		CALL	cursor
   	    MOV     AL, [BX+selecao]
		CALL	caracter
		CMP		DL, 53						; compara para saber se esta na ultima dificuldade selecionavel
		JG		volta_dir
		ADD		DL, 20						; pula pra proxima dificuldade
		JMP		SELECAO

volta_dir:									; da a volta pela direita para a primeira dificuldade
		MOV		DL, 14
		JMP		SELECAO

TROCA_ESQUERDA:
		MOV	byte[cor], preto			;apaga seta		
		CALL cursor
    	MOV AL, [BX+selecao]
		CALL	caracter

		CMP		DL, 20						; compara para saber se esta na primeira dificuldade selecionavel
		JL		volta_esq
		SUB		DL, 20						; pula pra dificuldade anterior
		JMP		SELECAO

volta_esq:	
		MOV		DL, 54						; da a volta pela direita para a ultima dificuldade
		JMP		SELECAO

;inicia o jogo, a dificuldade depende do valor de DL
JOGO:	
		;apaga seta
		MOV		byte[cor], preto					
		CALL	cursor
   	    MOV     AL, [BX+selecao]
		CALL	caracter
		;apaga menu	
		CALL	MENU
		;cria linha delimitadora inferior 
		MOV		byte[cor], branco_intenso					
		XOR 	AX, AX
		MOV 	AX, 40
		PUSH 	AX
		MOV 	AX, 40
		PUSH 	AX
		MOV 	AX, 600
		PUSH 	AX
		MOV 	AX, 40
		PUSH 	AX
		CALL 	line

		;cria linha delimitadora superior
		MOV 	AX, 40
		PUSH 	AX
		MOV 	AX, 440
		PUSH 	AX
		MOV 	AX, 600
		PUSH 	AX
		MOV 	AX, 440
		PUSH 	AX
		CALL 	line

    ;desenha os blocos dos jogadores
    	CALL 	DESENHA_BLOCOS_P1_E_P2

MOVIMENTOS:
		;CALL	LEITURA_TECLA 
		MOV		AX, [verifica1]
		MOV		[verifica2], AX
		;verifica se foi pausado
		CMP		byte[tecla_primida], 19h
		JE		PAUSE
		;verifica se a tecla de saida foi primida e sai caso sim
		CMP 	byte[tecla_primida], 10h
		JE 		FIM
		JMP		MOVIMENTOS
FIM:
;sai do modo de video
		CLI								
        XOR     AX, AX					
        MOV     ES, AX					
        MOV     AX, [save_segment]			
        MOV     [ES:INTr*4+2], AX		
        MOV     AX, [save_offset]
        MOV     [ES:INTr*4], AX
		STI
	 	MOV AH, 0   						; set video mode
	 	MOV AL, [modo_anterior]   		; modo anterior
	  	INT 10h
		MOV AX, 4c00h
		INT 21h
ZERA:	
	MOV byte[tecla_primida], 0h
	JMP MOVIMENTOS

PAUSE:
		CALL LEITURA_TECLA
		CMP		byte[tecla_primida], 19h
		JE		ZERA
		JMP		PAUSE

INTERRUPCAO_TECLADO:
		PUSHF  
		PUSH	AX	
		PUSH	BX	
		PUSH	CX	
		PUSH	DX	
		PUSH	DS
		PUSH	ES	

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

MENU:
		PUSH DX
		PUSH CX
		PUSH BX
		PUSH AX

		MOV CX, 30						;número de caracteres
		MOV BX, 0
		MOV DH, 25						;linha 0-29
    MOV DL, 24						;coluna 0-79s

INSTRUCAO:									;printa a instrucao de selecao
		CALL cursor
		MOV DI, DS
    MOV AL, [BX+menu_instruc]  
		
		CALL caracter
    INC	BX							;proximo caracter 
		INC	DL							;avanca a coluna
    LOOP INSTRUCAO

		MOV CX, 5	
    MOV DH, 15						;linha 0-29
    MOV DL, 16						;coluna 0-79
		MOV BX, 0
		
;escreve a dificuldade facil
FACIL:
		CALL cursor
    MOV AL, [BX+menu_facil]
		CALL caracter
    INC BX ;proximo caracter
		INC	DL ;avanca a coluna
    LOOP FACIL
		MOV	CX, 5
		MOV DL, 36
		MOV BX, 0

;printa a dificuldade media
MEDIO:
		CALL cursor
    MOV AL, [BX+menu_medio]
		
		CALL caracter
    INC	BX	;proximo caracter
		INC	DL	;avanca a coluna
    LOOP MEDIO
		MOV	CX, 7
		MOV	DL, 56
		MOV BX, 0

;printa a dificuldade dificil
DIFICIL:
		CALL cursor
    	MOV AL, [BX+menu_dificil]
		CALL caracter
    	INC	BX ;proximo caracter
		INC	DL ;avanca a coluna
    	LOOP DIFICIL
		
		POP AX
		POP BX
		POP CX
		POP DX

		RET

LEITURA_TECLA:
		PUSHF
		PUSH AX
		PUSH BX
ESPERA:	MOV		AX, [verifica1]	
		CMP		AX, [verifica2]
		JE ESPERA
		INC     WORD [verifica2]
		AND     WORD [verifica2],7

		POP BX
		POP AX
		POPF

		RET

;*******************************************************************

segment data

%include "src\defs.asm"

cor db branco_intenso

modo_anterior db 0

linha dw 0
coluna dw 0
deltax dw	0
deltay dw 0	

mens db 'Funcao Grafica SE_I $' 
menu_facil db 'Facil $'
menu_medio db 'Medio $'
menu_dificil db	'Dificil $'
menu_instruc db	'Aperte [ENTER] para selecionar $'
selecao	db '> $'
save_segment dw 1
save_offset	dw 1
INTr equ 9h
tecla_primida db 0
kb_ctl	equ 61h
eoi		equ 20h
pictrl  equ 20h	
verifica1 dw 0
verifica2 dw 0
tecla resb  8
;*************************************************************************
segment stack stack
    DW 		512
stacktop:
