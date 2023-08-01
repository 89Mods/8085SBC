#!/bin/bash
set -e

../asm gol.asm -C i8085 -l gol.lst -o gol.hex && ../hex2bin gol.hex
java Makerom gol.bin conv_gol.bin
