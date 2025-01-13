; Arquivo com as funções de entrada e saida (I/O)

global CONFIG_VIDEO, LEITURA_TECLA
extern verifica1, verifica2, modo_anterior

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
