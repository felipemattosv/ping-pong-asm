; Arquivo com as funções de interface

global MENU, RETANGULO, DESENHA_BLOCOS_P1_E_P2
extern cor, line, cursor, caracter

; Gera o menu inicial
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

;desenha um retangulo preenchido. A cor ja deve estar definida.
RETANGULO:
		PUSH	BP
		MOV		BP, SP

		;salva o contexto
		PUSHF
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX

		MOV	AX, [BP+10]			;x1
		MOV	BX, [BP+8]			;y1
		MOV	CX, [BP+6]			;x2
		MOV	DX, [BP+4]			;y2

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
		RET   8

;desenha os blocos dos jogadores
DESENHA_BLOCOS_P1_E_P2:
    ; Salva contexto
    PUSH AX
    MOV AL, byte[cor]
    PUSH AX

    ; Player 1
    
    ; Bloco 1
    MOV byte[cor], vermelho

    MOV 	AX, X1_Blocos_P1
    PUSH 	AX
		MOV 	AX, Y1_Bloco1
		PUSH	AX
		MOV		AX, X2_Blocos_P1
		PUSH	AX
		MOV		AX, Y2_Bloco1
    PUSH  AX
		CALL	RETANGULO
    
    ; Bloco 2
    MOV byte[cor], amarelo

    MOV 	AX, X1_Blocos_P1
    PUSH 	AX
    MOV 	AX, Y1_Bloco2
    PUSH	AX
    MOV		AX, X2_Blocos_P1
    PUSH	AX
    MOV		AX, Y2_Bloco2
    PUSH  AX
    CALL	RETANGULO

    ; Bloco 3
    MOV byte[cor], verde

    MOV 	AX, X1_Blocos_P1
    PUSH 	AX
    MOV 	AX, Y1_Bloco3
    PUSH	AX
    MOV		AX, X2_Blocos_P1
    PUSH	AX
    MOV		AX, Y2_Bloco3
    PUSH  AX
    CALL	RETANGULO

    ; Bloco 4
    MOV byte[cor], cyan_claro
    
    MOV 	AX, X1_Blocos_P1
    PUSH 	AX
    MOV 	AX, Y1_Bloco4
    PUSH	AX
    MOV		AX, X2_Blocos_P1
    PUSH	AX
    MOV		AX, Y2_Bloco4
    PUSH  AX
    CALL	RETANGULO

    ; Bloco 5
    MOV byte[cor], azul_claro
    
    MOV 	AX, X1_Blocos_P1
    PUSH 	AX
    MOV 	AX, Y1_Bloco5
    PUSH	AX
    MOV		AX, X2_Blocos_P1
    PUSH	AX
    MOV		AX, Y2_Bloco5
    PUSH  AX
    CALL	RETANGULO

    ; Player 2

    ; Bloco 1
    MOV byte[cor], vermelho

    MOV 	AX, X1_Blocos_P2
    PUSH 	AX
    MOV 	AX, Y1_Bloco1
    PUSH	AX
    MOV		AX, X2_Blocos_P2
    PUSH	AX
    MOV		AX, Y2_Bloco1
    PUSH  AX
    CALL	RETANGULO

    ; Bloco 2
    MOV byte[cor], amarelo

    MOV 	AX, X1_Blocos_P2
    PUSH 	AX
    MOV 	AX, Y1_Bloco2
    PUSH	AX
    MOV		AX, X2_Blocos_P2
    PUSH	AX
    MOV		AX, Y2_Bloco2
    PUSH  AX
    CALL	RETANGULO

    ; Bloco 3
    MOV byte[cor], verde

    MOV 	AX, X1_Blocos_P2
    PUSH 	AX
    MOV 	AX, Y1_Bloco3
    PUSH	AX
    MOV		AX, X2_Blocos_P2
    PUSH	AX
    MOV		AX, Y2_Bloco3
    PUSH  AX
    CALL	RETANGULO

    ; Bloco 4
    MOV byte[cor], cyan_claro

    MOV 	AX, X1_Blocos_P2
    PUSH 	AX
    MOV 	AX, Y1_Bloco4
    PUSH	AX
    MOV		AX, X2_Blocos_P2
    PUSH	AX
    MOV		AX, Y2_Bloco4
    PUSH  AX
    CALL	RETANGULO

    ; Bloco 5
    MOV byte[cor], azul_claro

    MOV 	AX, X1_Blocos_P2
    PUSH 	AX
    MOV 	AX, Y1_Bloco5
    PUSH	AX
    MOV		AX, X2_Blocos_P2
    PUSH	AX
    MOV		AX, Y2_Bloco5
    PUSH  AX
    CALL	RETANGULO

    ; player 1
    MOV byte[cor], azul_claro

    MOV 	AX, word[x1_p1]
    PUSH 	AX
    MOV 	AX, word[y1_p1]
    PUSH	AX
    MOV		AX, word[x2_p1]
    PUSH	AX
    MOV		AX, word[y2_p1]
    PUSH  AX
    CALL	RETANGULO

    ; player 2
    MOV byte[cor], magenta

    MOV 	AX, word[x1_p2]
    PUSH 	AX
    MOV 	AX, word[y1_p2]
    PUSH	AX
    MOV		AX, word[x2_p2]
    PUSH	AX
    MOV		AX, word[y2_p2]
    PUSH  AX
    CALL	RETANGULO

    ; Restaura contexto
    POP AX
    MOV byte[cor], AL
    POP AX
    RET

%include "src\defs.asm"
