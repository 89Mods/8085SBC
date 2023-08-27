#!/bin/bash
set -e

../asm menu.asm -C i8085 -l menu.lst -o menu.hex && ./hex2bin menu.hex
java Makerom menu.bin conv_menu.bin
java Makemenu conv_menu.bin menu_all.bin ../GOL/gol.bin "Game of life" ../DivMul/divmul.bin "Div & Mul Test" ../Mandel/mandel.bin "Mandelbrot renderer" ../IntTest/test.bin "Timer Int Test"
