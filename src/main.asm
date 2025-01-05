; versão de 18/10/2022
; Uso de diretivas extern e global 
; Professor Camilo Diaz

extern line, full_circle, circle, cursor, caracter, plot_xy 
global cor

segment code

;org 100h
..start:
        MOV     AX,data			;Inicializa os registradores
    	MOV 	DS,AX
    	MOV 	AX,stack
    	MOV 	SS,AX
    	MOV 	SP,stacktop

;Salvar modo corrente de video(vendo como esta o modo de video da maquina)
        MOV  	AH,0Fh
    	INT  	10h
    	MOV  	[modo_anterior],AL   

;Alterar modo de video para grafico 640x480 16 cores
    	MOV     AL,12h
   		MOV     AH,0
    	INT     10h


;Gera menu
MENU:
		MOV 	CX,30						;número de caracteres
		MOV    	BX,0
		MOV		byte [cor],branco_intenso
		MOV    	DH,25						;linha 0-29
    	MOV     DL,24						;coluna 0-79

INSTRUCAO:									;printa a instrucao de selecao
		CALL	cursor
		MOV     DI,DS
    	MOV     AL,[BX+menu_instruc]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
    	LOOP    INSTRUCAO


		MOV 	CX,5	
    	MOV    	DH,15						;linha 0-29
    	MOV     DL,16						;coluna 0-79
		MOV		BX,0
		

FACIL:                                      ;escreve a dificuldade facil
		CALL	cursor
    	MOV     AL,[BX+menu_facil]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
    	LOOP    FACIL
		MOV		CX,5
		MOV		DL,36
		MOV    	BX,0

MEDIO:										;printa a dificuldade media
		CALL	cursor
    	MOV     AL,[BX+menu_medio]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
    	LOOP    MEDIO
		MOV		CX,7
		MOV		DL,56
		MOV    	BX,0

DIFICIL:									;printa a dificuldade dificil
		CALL	cursor
    	MOV     AL,[BX+menu_dificil]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
    	LOOP    DIFICIL
		MOV 	DL,14						;salva informaçoes para printar a seta de  seleçao
		MOV		BX,0
SELECAO:
		MOV		byte [cor],branco_intenso
		CALL	cursor
    	MOV     AL,[BX+selecao]
		CALL	caracter

		MOV 	AH, 00h        				; Função 00h do INT 16h, para leitura do teclado
    	INT 	16h
		CMP		AH,4Dh						;seta para a direita foi apertada
		JE		TROCA_DIREITA
		CMP		AH,4Bh						; seta para a esquerda foi apertada
		JE		TROCA_ESQUERDA
		CMP		AH, 1Ch						; enter foi apertado
		JE		JOGO
		JMP 	SELECAO

TROCA_DIREITA:
		MOV		byte [cor],preto			;apaga seta		
		CALL	cursor
    	MOV     AL,[BX+selecao]
		CALL	caracter

		CMP		DL, 53						; compara para saber se esta na ultima dificuldade selecionavel
		JG		volta_dir
		ADD		DL, 20						; pula pra proxima dificuldade
		JMP		SELECAO

volta_dir:									; da a volta pela direita para a primeira dificuldade
		MOV		DL,14
		JMP		SELECAO

TROCA_ESQUERDA:
		MOV		byte [cor],preto			;apaga seta		
		CALL	cursor
    	MOV     AL,[BX+selecao]
		CALL	caracter

		CMP		DL,20						; compara para saber se esta na primeira dificuldade selecionavel
		JL		volta_esq
		SUB		DL, 20						; pula pra dificuldade anterior
		JMP		SELECAO

volta_esq:	
		MOV		DL,54						; da a volta pela direita para a ultima dificuldade
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
		MOV		byte [cor],preto
		;passa x1, y1 e x2, y2
		MOV 	AX, 40
		PUSH 	AX
		MOV 	AX, 41
		PUSH	AX
		MOV		AX, 600
		PUSH	AX
		MOV		AX, 439
		CALL	RETANGULO
		
		

FIM:
;sai do modo de video		
		MOV    	AH,08h
		INT     21h
	    MOV  	AH,0   						; set video mode
	    MOV  	AL,[modo_anterior]   		; modo anterior
	    INT  	10h
		MOV     AX,4c00h
		INT     21h

;desenha um retangulo preenchido. A cor ja deve estar definida.
RETANGULO:
		PUSH	BP
		MOV		BP, SP

		;salva o contexto
		PUSHF
		PUSH 	AX
		PUSH 	BX
		PUSH 	CX
		PUSH 	DX

		MOV		AX, [BP+8]			;x1
		MOV		BX, [BP+6]			;y1
		MOV		CX, [BP+4]			;x2
		MOV		DX, [BP+2]			;y2

PREENCHE:
		PUSH	AX
		PUSH	BX
		PUSH	AX
		PUSH	DX
		CALL line
		INC AX
		CMP	AX, CX
		JL	PREENCHE

		;retorna contexto e sai da funçao
		POP 	DX
		POP 	CX
		POP 	BX
		POP 	AX
		POPF
		POP 	BP
		RET

;*******************************************************************

segment data

cor		db		branco_intenso

;	I R G B COR
;	0 0 0 0 preto
;	0 0 0 1 azul
;	0 0 1 0 verde
;	0 0 1 1 cyan
;	0 1 0 0 vermelho
;	0 1 0 1 magenta
;	0 1 1 0 marrom
;	0 1 1 1 branco
;	1 0 0 0 cinza
;	1 0 0 1 azul claro
;	1 0 1 0 verde claro
;	1 0 1 1 cyan claro
;	1 1 0 0 rosa
;	1 1 0 1 magenta claro
;	1 1 1 0 amarelo
;	1 1 1 1 branco intenso

preto		    equ		0
azul		    equ		1
verde		    equ		2
cyan		    equ		3
vermelho	    equ		4
magenta		    equ		5
marrom		    equ		6
branco		    equ		7
cinza		    equ		8
azul_claro	    equ		9
verde_claro	    equ		10
cyan_claro	    equ		11
rosa		    equ		12
magenta_claro	equ		13
amarelo		    equ		14
branco_intenso	equ		15

modo_anterior	db		0
linha   	    dw  	0
coluna  	    dw  	0
deltax		    dw		0
deltay		    dw		0	
mens    		db  	'Funcao Grafica SE_I $' 
menu_facil		db 		'Facil $'
menu_medio 		db		'Medio $'
menu_dificil 	db		'Dificil $'
menu_instruc	db		'Aperte [ENTER] para selecionar $'
selecao			db 		'> $'
;*************************************************************************
segment stack stack
		DW 		512
stacktop:
