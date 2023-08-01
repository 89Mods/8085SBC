#!/bin/bash
set -e

../asm -C i8085 mandel.asm -l mandel.lst -o mandel.hex && ../hex2bin mandel.hex
java Makerom mandel.bin conv_mandel.bin
