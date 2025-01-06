@echo off

if not exist bin mkdir bin

echo Compiling...
call tools\nasm16 -f obj -o bin\main.obj -l bin\main.lst src\main.asm
call tools\nasm16 -f obj -o bin\line.obj -l bin\line.lst src\line.asm
call tools\nasm16 -f obj -o bin\fcircle.obj -l bin\fcircle.lst src\fcircle.asm
call tools\nasm16 -f obj -o bin\circle.obj -l bin\circle.lst src\circle.asm
call tools\nasm16 -f obj -o bin\cursor.obj -l bin\cursor.lst src\cursor.asm
call tools\nasm16 -f obj -o bin\caracter.obj -l bin\caracter.lst src\caracter.asm
call tools\nasm16 -f obj -o bin\plot_xy.obj -l bin\plot_xy.lst src\plot_xy.asm
call tools\nasm16 -f obj -o bin\intf.obj -l bin\intf.lst src\intf.asm

echo Linking...
call tools\freelink bin\main.obj bin\line.obj bin\fcircle.obj bin\circle.obj bin\cursor.obj bin\caracter.obj bin\plot_xy.obj bin\intf.obj, main

echo Done! Run 'main' to start the program.
