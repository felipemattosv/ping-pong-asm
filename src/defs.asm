segment data

;----------------------------
; Cores
preto	equ	0
azul  equ 1
verde equ	2
cyan	equ	3
vermelho equ 4
magenta	equ 5
marrom equ 6
branco equ 7
cinza equ 8
azul_claro equ 9
verde_claro equ 10
cyan_claro equ 11
rosa equ 12
magenta_claro equ 13
amarelo	equ 14
branco_intenso equ 15
;---------------------------

; Textos do menu
menu_instruc db	'Aperte [ENTER] para selecionar $'
menu_facil db 'Facil $'
menu_medio db 'Medio $'
menu_dificil db	'Dificil $'

msg_pause db 'pausado $'
msg_fecha db 'deseja sair? [y/n] $'
selecao	db '> $'

; Scancode Teclas
TECLA_DIREITA equ 4Dh
TECLA_ESQUERDA equ 4Bh
TECLA_ENTER equ 1Ch
TECLA_P equ 19h
TECLA_Q equ 10h
TECLA_Y equ 15h
TECLA_N equ 31h
TECLA_S equ 1Fh
TECLA_W equ 11h
TECLA_BAIXO equ 50h
TECLA_CIMA equ 48h

; Mapeamento de teclas
MAP_DIREITA equ 0
MAP_ESQUERDA equ 1
MAP_ENTER equ 2
MAP_P equ 3
MAP_Q equ 4
MAP_S equ 5
MAP_BAIXO equ 6
MAP_W equ 7
MAP_CIMA equ 8
MAP_Y equ 9
MAP_N equ 10

;----------------------------
; Player1 (esquerda)
X1_Blocos_P1 equ 20
X2_Blocos_P1 equ 40

; Player2 (direita)
X1_Blocos_P2 equ 600
X2_Blocos_P2 equ 620

; Both Players
Y1_Bloco1 equ 369
Y2_Bloco1 equ 439

Y1_Bloco2 equ 287
Y2_Bloco2 equ 357

Y1_Bloco3 equ 205
Y2_Bloco3 equ 275

Y1_Bloco4 equ 123
Y2_Bloco4 equ 193

Y1_Bloco5 equ 41
Y2_Bloco5 equ 111
;----------------------------

linha dw 0
coluna dw 0
deltax dw	0
deltay dw 0	

INTr equ 9h
kb_ctl	equ 61h
eoi		equ 20h
pictrl  equ 20h	
save_registrador dw 0
save_cor db 0
