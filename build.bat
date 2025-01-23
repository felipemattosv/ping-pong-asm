@echo off

if not exist bin mkdir bin

echo Compiling...
call tools\nasm16 -f obj -o bin\main.obj -l bin\main.lst src\main.asm
call tools\nasm16 -f obj -o bin\draw.obj -l bin\draw.lst src\draw.asm
call tools\nasm16 -f obj -o bin\ios.obj -l bin\ios.lst src\ios.asm
call tools\nasm16 -f obj -o bin\intf.obj -l bin\intf.lst src\intf.asm
call tools\nasm16 -f obj -o bin\ctrl.obj -l bin\ctrl.lst src\ctrl.asm

echo Linking...
call tools\freelink bin\main.obj bin\draw.obj bin\ios.obj bin\intf.obj bin\ctrl.obj, main

echo Done! Run 'main' to start the program.
