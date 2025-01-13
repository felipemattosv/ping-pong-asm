; Felipe Albuquerque e Jordano Furtado

extern line, full_circle, circle, cursor, caracter, plot_xy, MENU, RETANGULO, DESENHA_BLOCOS_P1_E_P2, CONFIG_VIDEO
global cor, tecla, tecla_primida, save_offset, save_segment, verifica1, verifica2, modo_anterior

segment code
..start:
;Inicializa os registradores
    MOV AX, data
    MOV DS, AX
    MOV AX, stack
    MOV SS, AX
    MOV SP, stacktop
		
;Salva o endereço do tratamento padrao da interrupçao 9h e seta a nova interrupçao para teclado
    CALL CONFIG_PIC

;Salva o modo de video atual e muda para grafico 640x480 16 cores
    CALL CONFIG_VIDEO
	
;Gera menu
	  MOV	byte [cor], branco_intenso
	  CALL MENU
	
  ;salva informaçoes para printar a seta de seleçao
	MOV DL, 14
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
		MOV		AX, [verifica1]
		MOV		[verifica2], AX

		;verifica se foi pausado
		CMP		byte[tecla_primida], 19h
		JE		PAUSE

		;verifica se a tecla de saida foi primida e sai caso sim
		CMP 	byte[tecla_primida], 10h
		JE 	NEAR MENU_FECHA

		;move jogador 1 para baixo
		CMP		byte[tecla_primida], 1Fh
		JE	NEAR DESCE_P1

		;move jogador 2 para baixo
		CMP		byte[tecla_primida], 50h
		JE	NEAR DESCE_P2

		;move jogador 1 para cima
		CMP		byte[tecla_primida], 11h
		JE	NEAR SOBE_P1
		
		;move jogador 2 para cima
		CMP		byte[tecla_primida], 48h
		JE	NEAR SOBE_P2		

		;nenhuma tecla primida, entao retorna ao inicio do loop	
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
	;zera a variavel que armazena a tecla	
	MOV byte[tecla_primida], 0h
	JMP MOVIMENTOS

PAUSE:	
		;escreve aviso de pause
		MOV		byte[cor], branco_intenso
		MOV 	DL, 35
		MOV 	DH, 25
		MOV		BX, 0
		MOV 	CX, 7
MSG_PAUSE:
		CALL	cursor
		MOV 	DI, DS
    	MOV 	AL, [BX+msg_pause]  
		CALL	caracter
    	INC		BX							;proximo caracter 
		INC		DL							;avanca a coluna
    	LOOP 	MSG_PAUSE
		
		;aguarda a leitura da tecla 'p' para despausar
		CALL 	LEITURA_TECLA
		CMP		byte[tecla_primida], 19h
		JE		APAGA_PAUSE
		JMP		PAUSE
APAGA_PAUSE:
		;apaga aviso de pause
		MOV		byte[cor], preto
		MOV 	DL, 35
		MOV 	DH, 25
		MOV		BX, 0
		MOV 	CX, 7
MSG_DESPAUSE:
		CALL	cursor
		MOV 	DI, DS
    	MOV 	AL, [BX+msg_pause]  
		CALL	caracter
    	INC		BX 
		INC		DL							
    	LOOP 	MSG_DESPAUSE
		JMP ZERA

MENU_FECHA:
		MOV		byte[cor], branco_intenso
		MOV 	DL, 34			;coluna
		MOV 	DH, 15			;linha
		MOV		BX, 0
		MOV 	CX, 18
MSG_FECHA:
		CALL	cursor
		MOV 	DI, DS
    	MOV 	AL, [BX+msg_fecha]  
		CALL	caracter
    	INC		BX							;proximo caracter 
		INC		DL							;avanca a coluna
    	LOOP 	MSG_FECHA
		
		;aguarda a leitura da tecla 'y' ou 'n'
TESTE:
		CALL 	LEITURA_TECLA
		CMP		byte[tecla_primida], 15h
		JE	NEAR FIM
		CMP     byte[tecla_primida], 31h
		JE	NEAR APAGA_FECHA
		JMP	TESTE

APAGA_FECHA:
		MOV		byte[cor], preto
		MOV 	DL, 34			;coluna
		MOV 	DH, 15			;linha
		MOV		BX, 0
		MOV 	CX, 18
APAGA_MSG_FECHA:
		CALL	cursor
		MOV 	DI, DS
    	MOV 	AL, [BX+msg_fecha]  
		CALL	caracter
    	INC		BX							;proximo caracter 
		INC		DL							;avanca a coluna
    	LOOP 	APAGA_MSG_FECHA
		JMP	NEAR ZERA 

DESCE_P1:
		;verifica se atingiu o limite do mapa
		CMP     word[y1_p1], 41
		JE	NEAR ZERA
		;apaga posiçao atual
		MOV		byte[cor], preto
		MOV		AX, [x1_p1]
		PUSH	AX
		MOV		AX, [y1_p1]
		PUSH	AX
		MOV		AX, [x2_p1]
		PUSH	AX
		MOV		AX, [y2_p1]
		PUSH	AX
		CALL RETANGULO
		
		;move
		MOV		byte[cor], azul
		SUB		word[y2_p1], 4	
		SUB		word[y1_p1], 4

		;printa em nova posiçao
		MOV		AX, [x1_p1]
		PUSH	AX
		MOV		AX, [y1_p1]
		PUSH	AX
		MOV		AX, [x2_p1]
		PUSH	AX
		MOV		AX, [y2_p1]
		PUSH	AX
		CALL RETANGULO

		JMP		ZERA

DESCE_P2:
		;verifica se atingiu o limite do mapa
		CMP     word[y1_p2], 41
		JE	NEAR ZERA
		;apaga posiçao atual
		MOV		byte[cor], preto
		MOV		AX, [x1_p2]
		PUSH	AX
		MOV		AX, [y1_p2]
		PUSH	AX
		MOV		AX, [x2_p2]
		PUSH	AX
		MOV		AX, [y2_p2]
		PUSH	AX
		CALL RETANGULO
		
		;move
		MOV		byte[cor], magenta
		SUB		word[y2_p2], 4	
		SUB		word[y1_p2], 4

		;printa em nova posiçao
		MOV		AX, [x1_p2]
		PUSH	AX
		MOV		AX, [y1_p2]
		PUSH	AX
		MOV		AX, [x2_p2]
		PUSH	AX
		MOV		AX, [y2_p2]
		PUSH	AX
		CALL RETANGULO

		JMP	ZERA

SOBE_P2:
		;verifica se atingiu o limite do mapa
		CMP     word[y2_p2], 439
		JE	NEAR ZERA
		;apaga posiçao atual
		MOV		byte[cor], preto
		MOV		AX, [x1_p2]
		PUSH	AX
		MOV		AX, [y1_p2]
		PUSH	AX
		MOV		AX, [x2_p2]
		PUSH	AX
		MOV		AX, [y2_p2]
		PUSH	AX
		CALL RETANGULO
		
		;move
		MOV		byte[cor], magenta
		ADD		word[y2_p2], 4	
		ADD		word[y1_p2], 4

		;printa em nova posiçao
		MOV		AX, [x1_p2]
		PUSH	AX
		MOV		AX, [y1_p2]
		PUSH	AX
		MOV		AX, [x2_p2]
		PUSH	AX
		MOV		AX, [y2_p2]
		PUSH	AX
		CALL RETANGULO

		JMP	NEAR ZERA

SOBE_P1:
		;verifica se atingiu o limite do mapa
		CMP     word[y2_p1], 439
		JE NEAR ZERA
		;apaga posiçao atual
		MOV		byte[cor], preto
		MOV		AX, [x1_p1]
		PUSH	AX
		MOV		AX, [y1_p1]
		PUSH	AX
		MOV		AX, [x2_p1]
		PUSH	AX
		MOV		AX, [y2_p1]
		PUSH	AX
		CALL RETANGULO
		
		;move
		MOV		byte[cor], azul
		ADD		word[y2_p1], 4	
		ADD		word[y1_p1], 4

		;printa em nova posiçao
		MOV		AX, [x1_p1]
		PUSH	AX
		MOV		AX, [y1_p1]
		PUSH	AX
		MOV		AX, [x2_p1]
		PUSH	AX
		MOV		AX, [y2_p1]
		PUSH	AX
		CALL RETANGULO

		JMP	NEAR ZERA

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

;*******************************************************************

segment data

cor db branco_intenso

modo_anterior db 0

tecla resb  8
tecla_primida db 0

verifica1 dw 0
verifica2 dw 0

save_segment dw 1
save_offset	dw 1

%include "src\defs.asm"

;*************************************************************************
segment stack stack
    DW 		512
stacktop:
