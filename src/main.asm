; Felipe Albuquerque e Jordano Furtado

extern line, full_circle, circle, cursor, caracter, plot_xy, MENU, RETANGULO, DESENHA_BLOCOS_P1_E_P2, DESENHA_P1, DESENHA_P2, DESENHA_LINHA_DELIMIT_SUP, DESENHA_LINHA_DELIMIT_INF, CONFIG_VIDEO, SOBE_P1, SOBE_P2, DESCE_P1, DESCE_P2, DESENHA_BOLA, MOVIMENTA_BOLA, FIM_DE_JOGO, LIMPA_FIM_DE_JOGO
global cor, key_state_buffer,game_over, verifica1, verifica2, modo_anterior, x1_p1, x2_p1, y1_p1, y2_p1, x1_p2, x2_p2, y1_p2, y2_p2, x_centro_bola, y_centro_bola, r_bola, vel_bola_x, vel_bola_y, status_blocos_p1, status_blocos_p2

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

; Inicializa o key_state_buffer com zeros
INICIO_JOGO:
    MOV CX, 11              ; Número de posições a inicializar
    MOV DI, 0               ; Inicializa o índice no buffer

init_loop:
    MOV BYTE [key_state_buffer + DI], 0 ; Define a posição atual do buffer como 0
    INC DI                              ; Incrementa o índice (DI)
    LOOP init_loop

; Inicializa o status dos blocos
    MOV CX, 5              ; Número de posições a inicializar
    MOV DI, 0               ; Inicializa o índice no array de status dos blocos

init_loop_blocos:
    MOV BYTE [status_blocos_p1 + DI], 1
    MOV BYTE [status_blocos_p2 + DI], 1
    INC DI
    LOOP init_loop_blocos
	
;Gera menu
	  MOV	byte [cor], branco_intenso
	  CALL MENU
	
  ;salva informaçoes para printar a seta de seleçao
	MOV DL, 14
	MOV DH, 15
	MOV	BX, 0

;Seleciona a dificuldade
SELECAO:
		MOV		byte[cor], branco_intenso
		CALL 	cursor
    	MOV  	AL, [BX+selecao]
		CALL 	caracter		 

		CMP		byte[key_state_buffer + MAP_DIREITA], 1
		JE		TROCA_DIREITA
		CMP		byte[key_state_buffer + MAP_ESQUERDA], 1
		JE		TROCA_ESQUERDA
		CMP		byte[key_state_buffer + MAP_ENTER], 1
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
    ; dps passar o tamanho do loop externo como parametro (4) 
    CALL DELAY
		JMP		SELECAO

volta_dir:									; da a volta pela direita para a primeira dificuldade
		MOV		DL, 14
		; dps passar o tamanho do loop externo como parametro (4) 
    CALL DELAY
    JMP		SELECAO

TROCA_ESQUERDA:
		MOV	byte[cor], preto			;apaga seta		
		CALL cursor
    	MOV AL, [BX+selecao]
		CALL	caracter

		CMP		DL, 20						; compara para saber se esta na primeira dificuldade selecionavel
		JL		volta_esq
		SUB		DL, 20						; pula pra dificuldade anterior
    ; dps passar o tamanho do loop externo como parametro (4) 
    CALL DELAY
		JMP		SELECAO

volta_esq:	
		MOV		DL, 54						; da a volta pela direita para a ultima dificuldade
		; dps passar o tamanho do loop externo como parametro (4) 
    CALL DELAY
    JMP		SELECAO

;inicia o jogo, a dificuldade depende do valor de DL
JOGO:
    ; define velocidade da bola
    CMP DL, 14
    JE NEAR FACIL
    CMP DL, 34
    JE NEAR MEDIO
    CMP DL, 54
    JE NEAR DIFICIL
    retorno_config_vel:

		;apaga seta
		MOV		byte[cor], preto					
		CALL	cursor
   	    MOV     AL, [BX+selecao]
		CALL	caracter
		;apaga menu	
		CALL	MENU
		
    ;desenha linhas delimitadoras
    CALL   DESENHA_LINHA_DELIMIT_SUP
    CALL   DESENHA_LINHA_DELIMIT_INF

    ;desenha os blocos dos jogadores
    CALL 	DESENHA_BLOCOS_P1_E_P2

    ;desenha jogadores
    CALL DESENHA_P1
    CALL DESENHA_P2

    ;desenha bola no centro
    CALL DESENHA_BOLA

MOVIMENTOS:
		;verifica se foi pausado
		CMP		byte[key_state_buffer + MAP_P], 1
		JE		NEAR PAUSE

		;verifica se a tecla de saida foi primida e sai caso sim
		CMP 	byte[key_state_buffer + MAP_Q], 1
		JE 	NEAR MENU_FECHA

    ; Movimenta a bola
    CALL MOVIMENTA_BOLA

    ; Verifica fim de jogo
    CMP WORD[game_over], 1
    JE NEAR FIM

    test_only_player1:
    XOR AX, AX
    ;Verifica se o player2 se movimenta:
    MOV AL, byte[key_state_buffer + MAP_CIMA]
    OR AL, [key_state_buffer + MAP_BAIXO]
    CMP AL, 0
    JNE test_only_player2

    ;Apenas player1 se movimenta:
    CMP byte[key_state_buffer + MAP_W], 1
    JE HANDLE_SOBE_P1
    CMP byte[key_state_buffer + MAP_S], 1
    JE HANDLE_DESCE_P1
    JMP MOVIMENTOS

    test_only_player2:
    XOR AX, AX
    ;Verifica se o player1 se movimenta:
    MOV AL, byte[key_state_buffer + MAP_W]
    OR AL, [key_state_buffer + MAP_S]
    CMP AL, 0
    JNE test_both_move

    ;Apenas player2 se movimenta:
    CMP byte[key_state_buffer + MAP_CIMA], 1
    JE HANDLE_SOBE_P2
    CMP byte[key_state_buffer + MAP_BAIXO], 1
    JE HANDLE_DESCE_P2
    JMP MOVIMENTOS

    test_both_move:
    ;Ambos se movimentam:
    ; Player1 sobe e Player2 sobe
    XOR AX, AX
    MOV AL, byte[key_state_buffer + MAP_W]
    AND AL, [key_state_buffer + MAP_CIMA]
    CMP AL, 1
    JE HANDLE_SOBE_P1_SOBE_P2

    ; Player1 desce e Player2 desce
    XOR AX, AX
    MOV AL, byte[key_state_buffer + MAP_S]
    AND AL, [key_state_buffer + MAP_BAIXO]
    CMP AL, 1
    JE HANDLE_DESCE_P1_DESCE_P2

    ; Player1 sobe e Player2 desce
    XOR AX, AX
    MOV AL, byte[key_state_buffer + MAP_W]
    AND AL, [key_state_buffer + MAP_BAIXO]
    CMP AL, 1
    JE HANDLE_SOBE_P1_DESCE_P2

    ; Player1 desce e Player2 sobe
    XOR AX, AX
    MOV AL, byte[key_state_buffer + MAP_S]
    AND AL, [key_state_buffer + MAP_CIMA]
    CMP AL, 1
    JE HANDLE_DESCE_P1_SOBE_P2

		;nenhuma tecla primida, entao retorna ao inicio do loop	
		JMP		MOVIMENTOS

HANDLE_SOBE_P1:
    CALL SOBE_P1
    JMP MOVIMENTOS

HANDLE_DESCE_P1:
    CALL DESCE_P1
    JMP MOVIMENTOS

HANDLE_SOBE_P2:
    CALL SOBE_P2
    JMP MOVIMENTOS

HANDLE_DESCE_P2:
    CALL DESCE_P2
    JMP MOVIMENTOS

HANDLE_SOBE_P1_SOBE_P2:
    CALL SOBE_P1
    CALL SOBE_P2
    JMP MOVIMENTOS

HANDLE_DESCE_P1_DESCE_P2:
    CALL DESCE_P1
    CALL DESCE_P2
    JMP MOVIMENTOS

HANDLE_SOBE_P1_DESCE_P2:
    CALL SOBE_P1
    CALL DESCE_P2
    JMP MOVIMENTOS

HANDLE_DESCE_P1_SOBE_P2:
    CALL DESCE_P1
    CALL SOBE_P2
    JMP MOVIMENTOS


FIM:

        CALL FIM_DE_JOGO
        CMP byte[key_state_buffer + MAP_Y], 1
        JE REINICIA
    ;restaura o tratamento padrao da interrupçao 9h
    fecha_jogo:
		CLI								
        XOR     AX, AX					
        MOV     ES, AX					
        MOV     AX, [save_segment]			
        MOV     [ES:INTr*4+2], AX		
        MOV     AX, [save_offset]
        MOV     [ES:INTr*4], AX
		STI

    ;sai do modo de video
	 	MOV AH, 0   						; set video mode
	 	MOV AL, [modo_anterior]   		; modo anterior
	  INT 10h

    ;Retorna ao DOS
    MOV AX, 4c00h
		INT 21h

REINICIA:
    CALL LIMPA_FIM_DE_JOGO
    XOR AX, AX
    XOR BX, BX
    MOV word[x_centro_bola], 320
    MOV word[y_centro_bola], 240
    MOV word[x1_p1], 50
    MOV word[x2_p1], 70
    MOV word[y1_p1], 205
    MOV word[y2_p1], 275
    MOV word[x1_p2], 570
    MOV word[x2_p2], 590
    MOV word[y1_p2], 205
    MOV word[y2_p2], 275
    MOV byte[game_over], 0
    JMP NEAR INICIO_JOGO

ZERA:
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

    ; dps passar o tamanho do loop externo como parametro (6)
    CALL DELAY
    CALL DELAY
    paused:
      ;aguarda a leitura da tecla 'p' para despausar
      CMP		byte[key_state_buffer + MAP_P], 1
      JE		APAGA_PAUSE
		JMP		paused

APAGA_PAUSE:
    ; dps passar o tamanho do loop externo como parametro (6) 
    CALL DELAY
		CALL DELAY
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
		
TESTE:
		CMP		byte[key_state_buffer + MAP_Y], 1
		JE	NEAR fecha_jogo
		CMP     byte[key_state_buffer + MAP_N], 1
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

; Define dificuldade
FACIL:
    MOV WORD [vel_bola_x], 3
    MOV WORD [vel_bola_y], 3
    JMP retorno_config_vel

MEDIO:
    MOV WORD [vel_bola_x], 5
    MOV WORD [vel_bola_y], 5
    JMP retorno_config_vel

DIFICIL:
    MOV WORD [vel_bola_x], 7
    MOV WORD [vel_bola_y], 7
    JMP retorno_config_vel

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

INTERRUPCAO_TECLADO:
    ; Salva o contexto
    PUSHF  
    PUSH    AX	
    PUSH    BX	
    PUSH    CX	
    PUSH    DX	
    PUSH    DS
    PUSH    ES	

    ; Faz a leitura do teclado e armazena o scan code em AL
    IN      AL, 0x60

    ; Verifica se é um scan code de tecla pressionada (bit mais significativo = 0)
    TEST    AL, 80h
    JNE NEAR TECLA_LIBERADA

TECLA_PRESSIONADA:
    ; Identifica qual tecla foi pressionada e atualiza o estado para 1
    CMP     AL, TECLA_DIREITA
    JE      SET_DIREITA
    CMP     AL, TECLA_ESQUERDA
    JE      SET_ESQUERDA
    CMP     AL, TECLA_ENTER
    JE      SET_ENTER
    CMP     AL, TECLA_P
    JE      SET_P
    CMP     AL, TECLA_Q
    JE      SET_Q
    CMP     AL, TECLA_S
    JE      SET_S
    CMP     AL, TECLA_BAIXO
    JE      SET_BAIXO
    CMP     AL, TECLA_W
    JE      SET_W
    CMP     AL, TECLA_CIMA
    JE      SET_CIMA
    CMP     AL, TECLA_Y
    JE      SET_Y
    CMP     AL, TECLA_N
    JE      SET_N
    JMP     FIM_INT

SET_DIREITA:
    MOV     BYTE [key_state_buffer + MAP_DIREITA], 1
    JMP     FIM_INT
SET_ESQUERDA:
    MOV     BYTE [key_state_buffer + MAP_ESQUERDA], 1
    JMP     FIM_INT
SET_ENTER:
    MOV     BYTE [key_state_buffer + MAP_ENTER], 1
    JMP     FIM_INT
SET_P:
    MOV     BYTE [key_state_buffer + MAP_P], 1
    JMP     FIM_INT
SET_Q:
    MOV     BYTE [key_state_buffer + MAP_Q], 1
    JMP     FIM_INT
SET_S:
    MOV     BYTE [key_state_buffer + MAP_S], 1
    JMP     FIM_INT
SET_BAIXO:
    MOV     BYTE [key_state_buffer + MAP_BAIXO], 1
    JMP     FIM_INT
SET_W:
    MOV     BYTE [key_state_buffer + MAP_W], 1
    JMP     FIM_INT
SET_CIMA:
    MOV     BYTE [key_state_buffer + MAP_CIMA], 1
    JMP     FIM_INT
SET_Y:
    MOV     BYTE [key_state_buffer + MAP_Y], 1
    JMP     FIM_INT
SET_N:
    MOV     BYTE [key_state_buffer + MAP_N], 1
    JMP     FIM_INT

TECLA_LIBERADA:
    ; Remove o bit mais significativo para obter o scan code original
    AND     AL, 7Fh

    ; Identifica qual tecla foi liberada e atualiza o estado para 0
    CMP     AL, TECLA_DIREITA
    JE      RESET_DIREITA
    CMP     AL, TECLA_ESQUERDA
    JE      RESET_ESQUERDA
    CMP     AL, TECLA_ENTER
    JE      RESET_ENTER
    CMP     AL, TECLA_P
    JE      RESET_P
    CMP     AL, TECLA_Q
    JE      RESET_Q
    CMP     AL, TECLA_S
    JE      RESET_S
    CMP     AL, TECLA_BAIXO
    JE      RESET_BAIXO
    CMP     AL, TECLA_W
    JE      RESET_W
    CMP     AL, TECLA_CIMA
    JE      RESET_CIMA
    CMP     AL, TECLA_Y
    JE      RESET_Y
    CMP     AL, TECLA_N
    JE      RESET_N
    JMP     FIM_INT

RESET_DIREITA:
    MOV     BYTE [key_state_buffer + MAP_DIREITA], 0
    JMP     FIM_INT
RESET_ESQUERDA:
    MOV     BYTE [key_state_buffer + MAP_ESQUERDA], 0
    JMP     FIM_INT
RESET_ENTER:
    MOV     BYTE [key_state_buffer + MAP_ENTER], 0
    JMP     FIM_INT
RESET_P:
    MOV     BYTE [key_state_buffer + MAP_P], 0
    JMP     FIM_INT
RESET_Q:
    MOV     BYTE [key_state_buffer + MAP_Q], 0
    JMP     FIM_INT
RESET_S:
    MOV     BYTE [key_state_buffer + MAP_S], 0
    JMP     FIM_INT
RESET_BAIXO:
    MOV     BYTE [key_state_buffer + MAP_BAIXO], 0
    JMP     FIM_INT
RESET_W:
    MOV     BYTE [key_state_buffer + MAP_W], 0
    JMP     FIM_INT
RESET_CIMA:
    MOV     BYTE [key_state_buffer + MAP_CIMA], 0
    JMP     FIM_INT
RESET_Y:
    MOV     BYTE [key_state_buffer + MAP_Y], 0
    JMP     FIM_INT
RESET_N:
    MOV     BYTE [key_state_buffer + MAP_N], 0
    JMP     FIM_INT

FIM_INT:
    ; Limpa a interrupção do teclado
    IN      AL, kb_ctl				
    OR      AL, 80h					
    OUT     kb_ctl, AL
    AND     AL, 7Fh					
    OUT     kb_ctl, AL	

    ; Notifica fim da interrupção ao PIC			
    MOV     AL, eoi					
    OUT     pictrl, AL

    ; Restaura o contexto
    POP     ES
    POP     DS
    POP     DX
    POP     CX
    POP     BX
    POP     AX
    POPF
    IRET

DELAY:
    PUSHF
    PUSH BX
    PUSH CX

    MOV BX, 4

    outer_loop:
      MOV CX, 65535
      inner_loop:
        DEC cx
        JNZ inner_loop
    DEC BX
    JNZ outer_loop
    
    POP CX
    POP BX
    POPF
    RET

;*******************************************************************

segment data

cor db branco_intenso

modo_anterior db 0

key_state_buffer resb 11

verifica1 dw 0
verifica2 dw 0

save_segment dw 1
save_offset	dw 1

; game status
game_over dw 0

; player 1 posiçao
x1_p1 dw 50
x2_p1 dw 70
y1_p1 dw 205
y2_p1 dw 275
 
;player 2 posiçao
x1_p2 dw 570
x2_p2 dw 590
y1_p2 dw 205
y2_p2 dw 275

;bola
x_centro_bola dw 320
y_centro_bola dw 240
r_bola dw 20
vel_bola_x dw 1
vel_bola_y dw 1

; blocos
status_blocos_p1 resb 5
status_blocos_p2 resb 5

%include "src\defs.asm"

;*************************************************************************
segment stack stack
    DW 		512
stacktop:
