#!/bin/bash
set -e

../asm test.asm -C i8085 -l test.lst -o test.hex && ../hex2bin test.hex
java Makerom test.bin conv_test.bin
