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

;Salvar modo corrente de video(vendo como esta o modo de video da maquina)
    MOV AH, 0Fh
    INT 10h
    MOV [modo_anterior], AL   

;Alterar modo de video para grafico 640x480 16 cores
    MOV AL, 12h
   	MOV AH, 0
    INT 10h

;Gera menu
MENU:
		MOV CX, 30						;número de caracteres
		MOV BX, 0
		MOV	byte [cor], branco_intenso
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
		MOV DL, 14 ;salva informaçoes para printar a seta de seleçao
		MOV	BX, 0

SELECAO:
		MOV	byte[cor], branco_intenso
		CALL cursor
    MOV  AL, [BX+selecao]
		CALL caracter

		MOV 	AH, 00h        				; Função 00h do INT 16h, para leitura do teclado
    INT 	16h
		CMP		AH, 4Dh						;seta para a direita foi apertada
		JE		TROCA_DIREITA
		CMP		AH, 4Bh						; seta para a esquerda foi apertada
		JE		TROCA_ESQUERDA
		CMP		AH, 1Ch						; enter foi apertado
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
		;cria linha delimitadora inferior 
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

		;apaga a seleçao de dificuldade
		MOV		byte [cor], preto
		;passa x1, y1 e x2, y2
		MOV 	AX, 40
		PUSH 	AX
		MOV 	AX, 41
		PUSH	AX
		MOV		AX, 600
		PUSH	AX
		MOV		AX, 439
    PUSH  AX
		CALL RETANGULO

    ;desenha os blocos dos jogadores
    CALL DESENHA_BLOCOS_P1_E_P2

FIM:
;sai do modo de video
		MOV AH, 08h
		INT 21h
	  MOV AH, 0   						; set video mode
	  MOV AL, [modo_anterior]   		; modo anterior
	  INT 10h
		MOV AX, 4c00h
		INT 21h

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
;*************************************************************************
segment stack stack
    DW 		512
stacktop:
