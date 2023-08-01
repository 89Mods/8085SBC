#!/bin/bash
set -e

../asm divmul.asm -C i8085 -l divmul.lst -o divmul.hex && ../hex2bin divmul.hex
java Makerom divmul.bin conv_divmul.bin
