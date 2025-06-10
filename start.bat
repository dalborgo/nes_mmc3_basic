ca65 src/main.asm && ^
ca65 src/reset.asm && ^
ca65 src/background.asm && ^
ld65 src/reset.o src/main.o src/background.o -C nes.cfg -o display.nes && ^
e:\Downloads\sand\hack\emulators\mesen\Mesen.exe display.nes
del src\*.o
