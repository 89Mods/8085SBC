#!/bin/bash
set -e

../asm boot.asm -C i8085 -l boot.lst -o boot.hex && ../hex2bin boot.hex
