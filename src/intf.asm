; Arquivo com as funções de interface

global MENU, RETANGULO, DESENHA_LINHA_DELIMIT_SUP, DESENHA_LINHA_DELIMIT_INF, DESENHA_BLOCOS_P1_E_P2, DESENHA_P1, DESENHA_P2, SOBE_P1, SOBE_P2, DESCE_P1, DESCE_P2, DESENHA_BOLA, LIMPA_FIM_DE_JOGO, FIM_DE_JOGO
extern cor, key_state_buffer,game_over, line, cursor, caracter, full_circle, circle, x1_p1, x2_p1, y1_p1, y2_p1, x1_p2, x2_p2, y1_p2, y2_p2, x_centro_bola, y_centro_bola, r_bola

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

FIM_DE_JOGO:
  MOV byte[cor], preto 
  MOV AX, 20
  PUSH AX 
  MOV AX, 20
  PUSH AX
  MOV AX, 620
  PUSH AX
  MOV AX, 440
  PUSH AX
  CALL RETANGULO

  MOV byte[cor], vermelho
  MOV CX, 11						;número de caracteres
	MOV BX, 0
	MOV DH, 12						;linha 0-29
  MOV DL, 33            ;coluna 0-79
  loop_msg_fim:
  	CALL cursor
    MOV AL, [BX+msg_fim]
		CALL caracter
    INC	BX 
		INC	DL
    LOOP loop_msg_fim

  MOV byte[cor], branco
  MOV CX, 29						;número de caracteres
	MOV BX, 0
	MOV DH, 20						;linha 0-29
  MOV DL, 24            ;coluna 0-79
  loop_msg_jogar_novamente:
  	CALL cursor
    MOV AL, [BX+msg_jogar_novamente]
		CALL caracter
    INC	BX 
		INC	DL
    LOOP loop_msg_jogar_novamente

    CMP word[x_centro_bola], 330
    JG  jogador1_venceu
    JMP jogador2_venceu

    loop_resposta:
    CMP byte[key_state_buffer + MAP_Y], 1
    JE saida_func
    CMP byte[key_state_buffer + MAP_N], 1
    JE saida_func
    JMP loop_resposta

    jogador1_venceu:
    MOV byte[cor], azul
    MOV CX, 19						;número de caracteres
	  MOV BX, 0
	  MOV DH, 16						;linha 0-29
    MOV DL, 28            ;coluna 0-79  
    msg_jogador_1:
    CALL cursor
    MOV AL, [BX+msg_jogador1_venceu]
		CALL caracter
    INC	BX 
		INC	DL
    LOOP msg_jogador_1
    JMP loop_resposta

    jogador2_venceu:
        MOV byte[cor], magenta
    MOV CX, 19						;número de caracteres
	  MOV BX, 0
	  MOV DH, 16						;linha 0-29
    MOV DL, 28            ;coluna 0-79  
    msg_jogador_2:
    CALL cursor
    MOV AL, [BX+msg_jogador2_venceu]
		CALL caracter
    INC	BX 
		INC	DL
    LOOP msg_jogador_2
    JMP loop_resposta

    saida_func:

    RET

LIMPA_FIM_DE_JOGO:
 MOV byte[cor], preto
  MOV CX, 11						;número de caracteres
	MOV BX, 0
	MOV DH, 12						;linha 0-29
  MOV DL, 33            ;coluna 0-79
  loop_limpa_msg_fim:
  	CALL cursor
    MOV AL, [BX+msg_fim]
		CALL caracter
    INC	BX 
		INC	DL
    LOOP loop_limpa_msg_fim

  MOV byte[cor], preto
  MOV CX, 29						;número de caracteres
	MOV BX, 0
	MOV DH, 20						;linha 0-29
  MOV DL, 24            ;coluna 0-79
  loop_limpa_msg_jogar_novamente:
  	CALL cursor
    MOV AL, [BX+msg_jogar_novamente]
		CALL caracter
    INC	BX 
		INC	DL
    LOOP loop_limpa_msg_jogar_novamente  

    limpa_jogador_venceu:
        MOV byte[cor], preto
    MOV CX, 19						;número de caracteres
	  MOV BX, 0
	  MOV DH, 16						;linha 0-29
    MOV DL, 28            ;coluna 0-79  
    limpa_msg_jogador:
    CALL cursor
    MOV AL, [BX+msg_jogador2_venceu]
		CALL caracter
    INC	BX 
		INC	DL
    LOOP limpa_msg_jogador
    JMP fim_limpa
    
    fim_limpa:
  
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

%include "src\defs.asm"
