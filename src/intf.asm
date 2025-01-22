; Arquivo com as funções de interface

global MENU, RETANGULO, DESENHA_LINHA_DELIMIT_SUP, DESENHA_LINHA_DELIMIT_INF, DESENHA_BLOCOS_P1_E_P2, DESENHA_P1, DESENHA_P2, SOBE_P1, SOBE_P2, DESCE_P1, DESCE_P2, DESENHA_BOLA, MOVIMENTA_BOLA
extern cor, game_over, line, cursor, caracter, full_circle, x1_p1, x2_p1, y1_p1, y2_p1, x1_p2, x2_p2, y1_p2, y2_p2, x_centro_bola, y_centro_bola, r_bola, vel_bola_x, vel_bola_y, status_blocos_p1, status_blocos_p2

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

DESENHA_LINHA_DELIMIT_SUP:
  PUSHF
  PUSH AX

		;cria linha delimitadora superior
    MOV		byte[cor], branco_intenso					
		XOR 	AX, AX
		MOV 	AX, 40
		PUSH 	AX
		MOV 	AX, 440
		PUSH 	AX
		MOV 	AX, 600
		PUSH 	AX
		MOV 	AX, 440
		PUSH 	AX
		CALL 	line

    POP AX
    POPF

    RET

DESENHA_LINHA_DELIMIT_INF:
  PUSHF
  PUSH AX

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

    POP AX
    POPF

    RET

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

    ; Restaura contexto
    POP AX
    MOV byte[cor], AL
    POP AX
    RET

DESENHA_P1:
    ; Salva contexto
    PUSHF
    PUSH AX

    ; player 1
    MOV byte[cor], azul

    MOV 	AX, word[x1_p1]
    PUSH 	AX
    MOV 	AX, word[y1_p1]
    PUSH	AX
    MOV		AX, word[x2_p1]
    PUSH	AX
    MOV		AX, word[y2_p1]
    PUSH  AX
    CALL	RETANGULO

    ; Restaura contexto
    POP AX
    POPF

    RET

DESENHA_P2:
    ; Salva contexto
    PUSHF
    PUSH AX

    ; player 1
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
    POPF

    RET

SOBE_P1:
    ; Salva contexto
    PUSHF
    PUSH AX
    
    ;verifica se atingiu o limite do mapa
		CMP     word[y2_p1], 439
		JE ignorar_sobe_p1

		;apaga parte debaixo da posiçao atual
		MOV		byte[cor], preto
		MOV		AX, [x1_p1]
		PUSH	AX
		MOV		AX, [y1_p1]
		PUSH	AX
		MOV		AX, [x2_p1]
		PUSH	AX
		MOV		AX, [y1_p1]
    ADD AX, 4
		PUSH	AX
		CALL RETANGULO
		
		;move
		MOV		byte[cor], azul
		ADD		word[y2_p1], 4	
		ADD		word[y1_p1], 4

		;printa parte de cima na nova posiçao
		MOV		AX, [x1_p1]
		PUSH	AX
		MOV		AX, [y2_p1]
    SUB AX, 4
		PUSH	AX
		MOV		AX, [x2_p1]
		PUSH	AX
		MOV		AX, [y2_p1]
		PUSH	AX
		CALL RETANGULO

    ignorar_sobe_p1:
    ; Restaura contexto
    POP AX
    POPF

    RET


SOBE_P2:
		; Salva contexto
    PUSHF
    PUSH AX
    
    ;verifica se atingiu o limite do mapa
		CMP     word[y2_p2], 439
		JE	ignorar_sobe_p2
		
    ;apaga parte de baixo da posiçao atual
		MOV		byte[cor], preto
		MOV		AX, [x1_p2]
		PUSH	AX
		MOV		AX, [y1_p2]
		PUSH	AX
		MOV		AX, [x2_p2]
		PUSH	AX
		MOV		AX, [y1_p2]
    ADD AX, 4
		PUSH	AX
		CALL RETANGULO
		
		;move
		MOV		byte[cor], magenta
		ADD		word[y2_p2], 4	
		ADD		word[y1_p2], 4

		;printa em nova posiçao
		MOV		AX, [x1_p2]
		PUSH	AX
		MOV		AX, [y2_p2]
    SUB AX, 4
		PUSH	AX
		MOV		AX, [x2_p2]
		PUSH	AX
		MOV		AX, [y2_p2]
		PUSH	AX
		CALL RETANGULO

    ignorar_sobe_p2:
    ; Restaura contexto
    POP AX
    POPF

		RET

DESCE_P1:
    ; Salva contexto
    PUSHF
    PUSH AX

		;verifica se atingiu o limite do mapa
		CMP     word[y1_p1], 41
		JE	ignorar_desce_p1

		;apaga topo posiçao atual
		MOV		byte[cor], preto
		MOV		AX, [x1_p1]
		PUSH	AX
		MOV		AX, [y2_p1]
    SUB AX, 4
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

		;printa base na nova posiçao
		MOV		AX, [x1_p1]
		PUSH	AX
		MOV		AX, [y1_p1]
		PUSH	AX
		MOV		AX, [x2_p1]
		PUSH	AX
		MOV		AX, [y1_p1]
    ADD AX, 4
		PUSH	AX
		CALL RETANGULO

    ignorar_desce_p1:
    ; Restaura contexto
    POP AX
    POPF

		RET

DESCE_P2:
		; Salva contexto
    PUSHF
    PUSH AX
    
    ;verifica se atingiu o limite do mapa
		CMP     word[y1_p2], 41
		JE	ignorar_desce_p2

		;apaga o topo posiçao atual
		MOV		byte[cor], preto
		MOV		AX, [x1_p2]
		PUSH	AX
		MOV		AX, [y2_p2]
    SUB AX, 4
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
		MOV		AX, [y1_p2]
    ADD AX, 4
		PUSH	AX
		CALL RETANGULO

    ignorar_desce_p2:
    ; Restaura contexto
    POP AX
    POPF

		RET

DESENHA_BOLA:
    ; Salva contexto
    PUSHF
    PUSH AX

    MOV AX, [x_centro_bola]
    PUSH AX
    MOV AX, [y_centro_bola]
    PUSH AX
    MOV AX, [r_bola]
    PUSH AX
    CALL full_circle

    ; Restaura contexto
    POP AX
    POPF

    RET

MOVIMENTA_BOLA:
    ; Salva contexto
    PUSHF
    PUSH AX

    ; Apaga a bola
    MOV byte[cor], preto
    CALL DESENHA_BOLA

    ; Colisao parede superior ------------------
    colisao_parede_sup:
    XOR AX, AX
    MOV AX, [y_centro_bola]
    ADD AX, [r_bola]
    CMP AX, cmp_delimit_sup
    JL colisao_parede_inf

    ; ajusta velocidade
    MOV AX, [vel_bola_y]
    NOT AX
    INC AX
    MOV [vel_bola_y], AX
    ; ajusta linha superior
    CALL DESENHA_LINHA_DELIMIT_SUP
    JMP MOVER ; --------------------------------

    ; Colisao parede inferior ------------------
    colisao_parede_inf:
    XOR AX, AX
    MOV AX, [y_centro_bola]
    SUB AX, [r_bola]
    CMP AX, cmp_delimit_inf
    JG colisao_p1

    ; ajusta velocidade
    MOV AX, [vel_bola_y]
    NOT AX
    INC AX
    MOV [vel_bola_y], AX
    ; ajusta linha inferior
    CALL DESENHA_LINHA_DELIMIT_INF
    JMP MOVER ; --------------------------------

    colisao_p1: ; ------------------------------
    XOR AX, AX
    MOV AX, [x_centro_bola]
    SUB AX, [r_bola]
    CMP AX, [x2_p1]
    JG colisao_p2

    XOR AX, AX
    MOV AX, [y_centro_bola]
    ADD AX, [r_bola]
    CMP AX, [y1_p1]
    JL colisao_p2

    XOR AX, AX
    MOV AX, [y_centro_bola]
    SUB AX, [r_bola]
    CMP AX, [y2_p1]
    JG colisao_p2

    ; ajusta velocidade
    MOV AX, [vel_bola_x]
    NOT AX
    INC AX
    MOV [vel_bola_x], AX

    fim_colisao_p1:
    CALL DESENHA_P1
    JMP MOVER ; --------------------------------

    colisao_p2: ; ------------------------------
    XOR AX, AX
    MOV AX, [x_centro_bola]
    ADD AX, [r_bola]
    CMP AX, [x1_p2]
    JL verifica_blocos_p1

    XOR AX, AX
    MOV AX, [y_centro_bola]
    ADD AX, [r_bola]
    CMP AX, [y1_p2]
    JL verifica_blocos_p1

    XOR AX, AX
    MOV AX, [y_centro_bola]
    SUB AX, [r_bola]
    CMP AX, [y2_p2]
    JG verifica_blocos_p1

    ; ajusta velocidade
    MOV AX, [vel_bola_x]
    NOT AX
    INC AX
    MOV [vel_bola_x], AX
    ; ajusta p2
    CALL DESENHA_P2
    JMP MOVER ; --------------------------------

    verifica_blocos_p1: ; ----------------------
    XOR AX, AX
    MOV AX, [x_centro_bola]
    SUB AX, [r_bola]
    CMP AX, X2_Blocos_P1
    JG verifica_blocos_p2

    ; ajusta velocidade
    MOV AX, [vel_bola_x]
    NOT AX
    INC AX
    MOV [vel_bola_x], AX
    
    ; verifica bloco 1 ; ***********************
    verifica_bloco1_p1:

    ; compara topo da bola com a base do bloco
    XOR AX, AX
    MOV AX, [y_centro_bola]
    ADD AX, [r_bola]
    CMP AX, Y1_Bloco1
    JL verifica_bloco2_p1

    ; verifica se bloco 1 existe
    XOR AX, AX
    MOV AL, byte[status_blocos_p1]
    CMP AL, 1
    JE apaga_bloco1_p1
    MOV WORD[game_over], 1
    JMP fim_cmp

    apaga_bloco1_p1:
    MOV byte[status_blocos_p1], 0
    
    MOV byte[cor], preto
    MOV AX, X1_Blocos_P1
    PUSH AX
    MOV AX, Y1_Bloco1
    PUSH AX
    MOV AX, X2_Blocos_P1
    PUSH AX
    MOV AX, Y2_Bloco1
    PUSH AX
    CALL RETANGULO
    JMP fim_cmp ; ******************************

    ; verifica bloco 2 SÓ COPIAR E COLAR PROS OUTROS
    verifica_bloco2_p1:

    ; verifica bloco 3
    verifica_bloco3_p1:

    ; verifica bloco 4
    verifica_bloco4_p1:

    ; verifica bloco 5
    verifica_bloco5_p1:

    JMP MOVER ; --------------------------------

    verifica_blocos_p2:
    XOR AX, AX
    MOV AX, [x_centro_bola]
    ADD AX, [r_bola]
    CMP AX, X1_Blocos_P2
    JL fim_cmp

    ; ajusta velocidade
    MOV AX, [vel_bola_x]
    NOT AX
    INC AX
    MOV [vel_bola_x], AX
    ; destroi bloco
    JMP MOVER ; --------------------------------

    fim_cmp:

    MOVER:
    ; Move a bola
    MOV AX, [x_centro_bola]
    ADD AX, [vel_bola_x]
    MOV [x_centro_bola], AX

    MOV AX, [y_centro_bola]
    ADD AX, [vel_bola_y]
    MOV [y_centro_bola], AX

    ; Desenha a bola
    MOV byte[cor], branco
    CALL DESENHA_BOLA

    ; Restaura contexto
    POP AX
    POPF

    RET


%include "src\defs.asm"
