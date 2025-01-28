global MOVIMENTA_BOLA
extern cor, game_over, x1_p1, y1_p1, x2_p1, y2_p1, x1_p2, y1_p2, x2_p2, y2_p2, x_centro_bola, y_centro_bola, r_bola, vel_bola_x, vel_bola_y, status_blocos_p1, status_blocos_p2, DESENHA_BOLA, DESENHA_LINHA_DELIMIT_INF, DESENHA_LINHA_DELIMIT_SUP, RETANGULO, DESENHA_P1, DESENHA_P2

INVERTE_VELOCIDADE:
    PUSH BP
    MOV BP, SP

    PUSHF
    PUSH AX
    PUSH BX

    MOV AX, [BP+4]
    MOV BX, AX
    MOV AX, [BX]
    NOT AX
    INC AX
    MOV [BX], AX

    POP BX
    POP AX
    POPF

    POP BP
    RET 2

MOVIMENTA_BOLA:
    ; Salva contexto
    PUSHF
    PUSH AX
    PUSH BX

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
    MOV AX, vel_bola_y
    PUSH AX
    CALL INVERTE_VELOCIDADE

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
    MOV AX, vel_bola_y
    PUSH AX
    CALL INVERTE_VELOCIDADE
    ; ajusta linha inferior
    CALL DESENHA_LINHA_DELIMIT_INF
    JMP MOVER ; --------------------------------

    colisao_p1: ; ------------------------------
    
    XOR AX, AX
    MOV AX, [x_centro_bola]
    SUB AX, [r_bola]
    CMP AX, [x2_p1]
    JG NEAR colisao_p2

    XOR BX, BX
    XOR AX, AX
    MOV BX, [x2_p1]
    MOV AX, [x_centro_bola]
    SUB AX, [r_bola]
    SUB BX, AX
    CMP BX, 5
    JL NEAR colisao_meio_p1

    colisao_topo_p1:
    XOR AX, AX
    XOR BX, BX
    MOV AX, [y_centro_bola]
    SUB AX, [r_bola] 
    MOV BX, [y2_p1]
    SUB BX, AX
    CMP BX, 6
    JG  colisao_base_p1
    CMP BX, 0
    JL NEAR colisao_p2

    ;verifica se a bola vem de tras e passa o bloco caso ss
    MOV AX, [vel_bola_x]
    CMP AX, 0
    JG NEAR inverte_y_p1

    MOV AX, vel_bola_x
    PUSH AX
    CALL INVERTE_VELOCIDADE
    inverte_y_p1:
    MOV AX, vel_bola_y
    PUSH AX
    CALL INVERTE_VELOCIDADE
    JMP fim_colisao_p1

    colisao_base_p1:
    XOR AX, AX
    XOR BX, BX
    MOV AX, [y_centro_bola]
    ADD AX, [r_bola] 
    MOV BX, [y1_p1]
    SUB AX, BX
    CMP AX, 6
    JG  colisao_meio_p1
    CMP AX, 0
    JL  colisao_p2

    ;verifica se a bola vem de tras e passa o bloco caso ss
    MOV AX, [vel_bola_x]
    CMP AX, 0
    JG NEAR inverte_y_p1

    MOV AX, vel_bola_x
    PUSH AX
    CALL INVERTE_VELOCIDADE
    MOV AX, vel_bola_y
    PUSH AX
    CALL INVERTE_VELOCIDADE
    JMP fim_colisao_p1

    colisao_meio_p1:
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
    
    ;verifica se a bola vem de tras e passa o bloco caso ss
    MOV AX, [vel_bola_x]
    CMP AX, 0
    JG NEAR fim_colisao_p1

    ; ajusta velocidade
    MOV AX, vel_bola_x
    PUSH AX
    CALL INVERTE_VELOCIDADE

    fim_colisao_p1:
    CALL DESENHA_P1
    JMP NEAR MOVER ; --------------------------------

    colisao_p2: ; ------------------------------
    XOR AX, AX
    MOV AX, [x_centro_bola]
    ADD AX, [r_bola]
    CMP AX, [x1_p2]
    JL NEAR verifica_blocos_p1

    XOR BX, BX
    XOR AX, AX
    MOV BX, [x1_p2]
    MOV AX, [x_centro_bola]
    ADD AX, [r_bola]
    SUB AX, BX
    CMP AX, 5
    JL NEAR colisao_meio_p2

    colisao_topo_p2:
    XOR AX, AX
    XOR BX, BX
    MOV AX, [y_centro_bola]
    SUB AX, [r_bola] 
    MOV BX, [y2_p2]
    SUB BX, AX
    CMP BX, 6
    JG  colisao_base_p2
    CMP BX, 0
    JL NEAR verifica_blocos_p1

    ;verifica se a bola vem de tras e passa o bloco caso ss
    MOV AX, [vel_bola_x]
    CMP AX, 0
    JL NEAR inverte_y_p2

    MOV AX, vel_bola_x
    PUSH AX
    CALL INVERTE_VELOCIDADE
    inverte_y_p2:
    MOV AX, vel_bola_y
    PUSH AX
    CALL INVERTE_VELOCIDADE
    JMP fim_colisao_p2

    colisao_base_p2:
    XOR AX, AX
    XOR BX, BX
    MOV AX, [y_centro_bola]
    ADD AX, [r_bola] 
    MOV BX, [y1_p2]
    SUB AX, BX
    CMP AX, 6
    JG colisao_meio_p2
    CMP AX, 0
    JL  verifica_blocos_p1

    ;verifica se a bola vem de tras e passa o bloco caso ss
    MOV AX, [vel_bola_x]
    CMP AX, 0
    JL NEAR inverte_y_p2

    MOV AX, vel_bola_x
    PUSH AX
    CALL INVERTE_VELOCIDADE
    MOV AX, vel_bola_y
    PUSH AX
    CALL INVERTE_VELOCIDADE
    JMP fim_colisao_p2

    colisao_meio_p2:
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

    ;verifica se a bola vem de tras e passa o bloco caso ss
    MOV AX, [vel_bola_x]
    CMP AX, 0
    JL NEAR fim_colisao_p2

    ; ajusta velocidade
    MOV AX, vel_bola_x
    PUSH AX
    CALL INVERTE_VELOCIDADE
    ; ajusta p2
    fim_colisao_p2:
    CALL DESENHA_P2
    JMP MOVER ; --------------------------------

    verifica_blocos_p1: ; ----------------------
    XOR AX, AX
    MOV AX, [x_centro_bola]
    SUB AX, [r_bola]
    CMP AX, X2_Blocos_P1
    JG NEAR verifica_blocos_p2

    ; ajusta velocidade
    MOV AX, vel_bola_x
    PUSH AX
    CALL INVERTE_VELOCIDADE
    
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
    XOR AX, AX
    MOV AX, [y_centro_bola]
    ADD AX, [r_bola]
    CMP AX, Y1_Bloco2
    JL verifica_bloco3_p1

    ; verifica se bloco 2 existe
    XOR AX, AX
    MOV AL, byte[status_blocos_p1+1]
    CMP AL, 1
    JE apaga_bloco2_p1
    MOV WORD[game_over], 1
    JMP fim_cmp

    apaga_bloco2_p1:
    MOV byte[status_blocos_p1+1], 0
    
    MOV byte[cor], preto
    MOV AX, X1_Blocos_P1
    PUSH AX
    MOV AX, Y1_Bloco2
    PUSH AX
    MOV AX, X2_Blocos_P1
    PUSH AX
    MOV AX, Y2_Bloco2
    PUSH AX
    CALL RETANGULO
    JMP fim_cmp ; ******************************

    ; verifica bloco 3
    verifica_bloco3_p1:
    XOR AX, AX
    MOV AX, [y_centro_bola]
    ADD AX, [r_bola]
    CMP AX, Y1_Bloco3
    JL verifica_bloco4_p1

    ; verifica se bloco 2 existe
    XOR AX, AX
    MOV AL, byte[status_blocos_p1+2]
    CMP AL, 1
    JE apaga_bloco3_p1
    MOV WORD[game_over], 1
    JMP fim_cmp

    apaga_bloco3_p1:
    MOV byte[status_blocos_p1+2], 0
    
    MOV byte[cor], preto
    MOV AX, X1_Blocos_P1
    PUSH AX
    MOV AX, Y1_Bloco3
    PUSH AX
    MOV AX, X2_Blocos_P1
    PUSH AX
    MOV AX, Y2_Bloco3
    PUSH AX
    CALL RETANGULO
    JMP fim_cmp ; ******************************

    ; verifica bloco 4
    verifica_bloco4_p1:
    XOR AX, AX
    MOV AX, [y_centro_bola]
    ADD AX, [r_bola]
    CMP AX, Y1_Bloco4
    JL verifica_bloco5_p1

    ; verifica se bloco 2 existe
    XOR AX, AX
    MOV AL, byte[status_blocos_p1+3]
    CMP AL, 1
    JE apaga_bloco4_p1
    MOV WORD[game_over], 1
    JMP fim_cmp

    apaga_bloco4_p1:
    MOV byte[status_blocos_p1+3], 0
    
    MOV byte[cor], preto
    MOV AX, X1_Blocos_P1
    PUSH AX
    MOV AX, Y1_Bloco4
    PUSH AX
    MOV AX, X2_Blocos_P1
    PUSH AX
    MOV AX, Y2_Bloco4
    PUSH AX
    CALL RETANGULO
    JMP fim_cmp ; ******************************

    ; verifica bloco 5
    verifica_bloco5_p1:
    XOR AX, AX
    MOV AX, [y_centro_bola]
    ADD AX, [r_bola]
    CMP AX, Y1_Bloco5
    JL near MOVER

    ; verifica se bloco 2 existe
    XOR AX, AX
    MOV AL, byte[status_blocos_p1+4]
    CMP AL, 1
    JE apaga_bloco5_p1
    MOV WORD[game_over], 1
    JMP fim_cmp

    apaga_bloco5_p1:
    MOV byte[status_blocos_p1+4], 0
    
    MOV byte[cor], preto
    MOV AX, X1_Blocos_P1
    PUSH AX
    MOV AX, Y1_Bloco5
    PUSH AX
    MOV AX, X2_Blocos_P1
    PUSH AX
    MOV AX, Y2_Bloco5
    PUSH AX
    CALL RETANGULO
    JMP fim_cmp ; ******************************

    JMP MOVER ; --------------------------------

    verifica_blocos_p2:
    XOR AX, AX
    MOV AX, [x_centro_bola]
    ADD AX, [r_bola]
    CMP AX, X1_Blocos_P2
    JL NEAR fim_cmp

    ; ajusta velocidade
    MOV AX, vel_bola_x
    PUSH AX
    CALL INVERTE_VELOCIDADE

        ; verifica bloco 1 ; ***********************
    verifica_bloco1_p2:

    ; compara topo da bola com a base do bloco
    XOR AX, AX
    MOV AX, [y_centro_bola]
    ADD AX, [r_bola]
    CMP AX, Y1_Bloco1
    JL verifica_bloco2_p2

    ; verifica se bloco 1 existe
    XOR AX, AX
    MOV AL, byte[status_blocos_p2]
    CMP AL, 1
    JE apaga_bloco1_p2
    MOV WORD[game_over], 1
    JMP fim_cmp

    apaga_bloco1_p2:
    MOV byte[status_blocos_p2], 0
    
    MOV byte[cor], preto
    MOV AX, X1_Blocos_P2
    PUSH AX
    MOV AX, Y1_Bloco1
    PUSH AX
    MOV AX, X2_Blocos_P2
    PUSH AX
    MOV AX, Y2_Bloco1
    PUSH AX
    CALL RETANGULO
    JMP fim_cmp ; ******************************

    ; verifica bloco 2 SÓ COPIAR E COLAR PROS OUTROS
    verifica_bloco2_p2:
    XOR AX, AX
    MOV AX, [y_centro_bola]
    ADD AX, [r_bola]
    CMP AX, Y1_Bloco2
    JL verifica_bloco3_p2

    ; verifica se bloco 2 existe
    XOR AX, AX
    MOV AL, byte[status_blocos_p2+1]
    CMP AL, 1
    JE apaga_bloco2_p2
    MOV WORD[game_over], 1
    JMP fim_cmp

    apaga_bloco2_p2:
    MOV byte[status_blocos_p2+1], 0
    
    MOV byte[cor], preto
    MOV AX, X1_Blocos_P2
    PUSH AX
    MOV AX, Y1_Bloco2
    PUSH AX
    MOV AX, X2_Blocos_P2
    PUSH AX
    MOV AX, Y2_Bloco2
    PUSH AX
    CALL RETANGULO
    JMP fim_cmp ; ******************************

    ; verifica bloco 3
    verifica_bloco3_p2:
    XOR AX, AX
    MOV AX, [y_centro_bola]
    ADD AX, [r_bola]
    CMP AX, Y1_Bloco3
    JL verifica_bloco4_p2

    ; verifica se bloco 2 existe
    XOR AX, AX
    MOV AL, byte[status_blocos_p2+2]
    CMP AL, 1
    JE apaga_bloco3_p2
    MOV WORD[game_over], 1
    JMP fim_cmp

    apaga_bloco3_p2:
    MOV byte[status_blocos_p2+2], 0
    
    MOV byte[cor], preto
    MOV AX, X1_Blocos_P2
    PUSH AX
    MOV AX, Y1_Bloco3
    PUSH AX
    MOV AX, X2_Blocos_P2
    PUSH AX
    MOV AX, Y2_Bloco3
    PUSH AX
    CALL RETANGULO
    JMP fim_cmp ; ******************************

    ; verifica bloco 4
    verifica_bloco4_p2:
    XOR AX, AX
    MOV AX, [y_centro_bola]
    ADD AX, [r_bola]
    CMP AX, Y1_Bloco4
    JL verifica_bloco5_p2

    ; verifica se bloco 2 existe
    XOR AX, AX
    MOV AL, byte[status_blocos_p2+3]
    CMP AL, 1
    JE apaga_bloco4_p2
    MOV WORD[game_over], 1
    JMP fim_cmp

    apaga_bloco4_p2:
    MOV byte[status_blocos_p2+3], 0
    
    MOV byte[cor], preto
    MOV AX, X1_Blocos_P2
    PUSH AX
    MOV AX, Y1_Bloco4
    PUSH AX
    MOV AX, X2_Blocos_P2
    PUSH AX
    MOV AX, Y2_Bloco4
    PUSH AX
    CALL RETANGULO
    JMP fim_cmp ; ******************************

    ; verifica bloco 5
    verifica_bloco5_p2:
    XOR AX, AX
    MOV AX, [y_centro_bola]
    ADD AX, [r_bola]
    CMP AX, Y1_Bloco5
    JL MOVER

    ; verifica se bloco 2 existe
    XOR AX, AX
    MOV AL, byte[status_blocos_p2+4]
    CMP AL, 1
    JE apaga_bloco5_p2
    MOV WORD[game_over], 1
    JMP fim_cmp

    apaga_bloco5_p2:
    MOV byte[status_blocos_p2+4], 0
    
    MOV byte[cor], preto
    MOV AX, X1_Blocos_P2
    PUSH AX
    MOV AX, Y1_Bloco5
    PUSH AX
    MOV AX, X2_Blocos_P2
    PUSH AX
    MOV AX, Y2_Bloco5
    PUSH AX
    CALL RETANGULO
    JMP fim_cmp ; ******************************



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
    POP BX
    POP AX
    POPF

    RET


%include "src\defs.asm"