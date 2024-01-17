FUNC_TABLE equ 64
SERIAL_WRITE equ 0
BREAKPOINT equ 3
SPI_RECEIVE equ 27
SPI_ROM_SEL equ 30
SPI_ROM_DESEL equ 33
SPI_ROM_READ_BEGIN equ 36
PRINT_HEX equ 39
SERIAL_READ equ 42
PUTS equ 45

MEM_START equ 47000
MD_TEMP0 equ MEM_START
MD_TEMP1 equ MEM_START+1
MD_TEMP2 equ MEM_START+2
MD_TEMP3 equ MEM_START+3
MD_TEMP4 equ MEM_START+4
MD_TEMP5 equ MEM_START+5
MD_TEMP6 equ MEM_START+6
MD_TEMP7 equ MEM_START+7
MD_TEMP8 equ MEM_START+8
MD_TEMP9 equ MEM_START+9
MD_TEMP10 equ MEM_START+10
GR_TEMP0 equ MEM_START+11
GR_TEMP1 equ MEM_START+12
GR_TEMP2 equ MEM_START+13
GR_TEMP3 equ MEM_START+14
GR_TEMP4 equ MEM_START+15
GR_TEMP5 equ MEM_START+16
GR_TEMP6 equ MEM_START+17
GR_TEMP7 equ MEM_START+18
MIN00 equ MEM_START+19
MIN01 equ MEM_START+20
MIN02 equ MEM_START+21
MIN03 equ MEM_START+22
MIN10 equ MEM_START+23
MIN11 equ MEM_START+24
MIN12 equ MEM_START+25
MIN13 equ MEM_START+26
MRES0 equ MEM_START+27
MRES1 equ MEM_START+28
MRES2 equ MEM_START+29
MRES3 equ MEM_START+30
MRES4 equ MEM_START+31
MRES5 equ MEM_START+32
MRES6 equ MEM_START+33
MRES7 equ MEM_START+34
DIN00 equ MEM_START+35
DIN01 equ MEM_START+36
DIN02 equ MEM_START+37
DIN03 equ MEM_START+38
DIN04 equ MEM_START+39
DIN05 equ MEM_START+40
DIN10 equ MEM_START+41
DIN11 equ MEM_START+42
DIN12 equ MEM_START+43
DIN13 equ MEM_START+44
DRES0 equ MEM_START+45
DRES1 equ MEM_START+46
DRES2 equ MEM_START+47
DRES3 equ MEM_START+48
DRES4 equ MEM_START+49
DRES5 equ MEM_START+50
REM0 equ MEM_START+51
REM1 equ MEM_START+52
REM2 equ MEM_START+53
REM3 equ MEM_START+54
FOUT0 equ MEM_START+55
FOUT1 equ MEM_START+56
FOUT2 equ MEM_START+57
FOUT3 equ MEM_START+58
XS_STATE0 equ MEM_START+59
XS_STATE1 equ MEM_START+60
XS_STATE2 equ MEM_START+61
XS_STATE3 equ MEM_START+62
XS_STATE4 equ MEM_START+63
XS_STATE5 equ MEM_START+64
XS_STATE6 equ MEM_START+65
XS_STATE7 equ MEM_START+66
STRBUFF equ MEM_START+67 ; Length 16

start	org 33024
	lxi h, text
	call FUNC_TABLE+PUTS
	
print_loop_done:
	mvi d, 10
	mvi e, 3
	call mul_8x8_test
	mvi d, 0
	mvi e, 3
	call mul_8x8_test
	mvi d, 10
	mvi e, 0
	call mul_8x8_test
	mvi d, 5
	mov e, d
	call mul_8x8_test
	mvi d, 37
	mvi e, 15
	call mul_8x8_test
	mvi d, 37
	mvi e, 15
	call mule_8x8_test
	mvi d, 255
	mov e, d
	call mule_8x8_test
	mvi d, 37
	mvi e, 0
	call mule_8x8_test
	mvi d, 0
	mvi e, 15
	call mule_8x8_test
	mvi d, 88
	mvi e, 12
	call mule_8x8_test
	mvi d, 107
	mvi e, 208
	call mule_8x8_test
	call wait_for_key
	
	mvi d, 107
	mvi e, 5
	call div_8x8_test
	mvi d, 203
	mvi e, 15
	call div_8x8_test
	mvi d, 217
	mvi e, 50
	call div_8x8_test
	mvi d, 217
	mvi e, 1
	call div_8x8_test
	mvi d, 0
	mvi e, 50
	call div_8x8_test
	mvi d, 0
	mvi e, 0
	call div_8x8_test
	lxi d, 17688
	lxi b, 5
	call div_16x16_test
	lxi d, 27886
	lxi b, 178
	call div_16x16_test
	lxi d, 0
	lxi b, 178
	call div_16x16_test
	lxi d, 27886
	lxi b, 0
	call div_16x16_test
	lxi d, 2858
	lxi b, 1000
	call div_16x16_test
	call wait_for_key
	lxi d, 1000
	lxi b, 33
	call mul_16x16_test
	lxi d, 47
	lxi b, 2018
	call mul_16x16_test
	lxi d, 0
	lxi b, 2018
	call mul_16x16_test
	lxi d, 47
	lxi b, 0
	call mul_16x16_test
	lxi d, 0
	lxi b, 0
	call mul_16x16_test
	lxi d, 19381
	lxi b, 12
	call mul_16x16_test
	lxi d, 19381
	lxi b, 19382
	call mul_16x16_test
	lxi d, 19381
	lxi b, 12
	call mule_16x16_test
	lxi d, 19381
	lxi b, 19382
	call mule_16x16_test
	call wait_for_key
	
	lxi h, 19382
	shld MD_TEMP0
	lxi h, 33
	shld MD_TEMP2
	mvi d, 7
	call mul_8x32_test
	
	lxi h, 19382
	shld MIN00
	lxi h, 33
	shld MIN02
	lxi h, 7
	shld MIN10
	lxi h, 0
	shld MIN12
	call mule_32x32_test
	lxi h, 19382
	shld MIN00
	lxi h, 7688
	shld MIN02
	lxi h, 576
	shld MIN10
	lxi h, 10788
	shld MIN12
	call mule_32x32_test
	lxi h, 0
	shld MIN00
	shld MIN02
	lxi h, 576
	shld MIN10
	lxi h, 10788
	shld MIN12
	call mule_32x32_test
	lxi h, 19382
	shld MIN00
	lxi h, 7688
	shld MIN02
	lxi h, 0
	shld MIN10
	shld MIN12
	call mule_32x32_test
	lxi h, 0
	shld MIN00
	shld MIN02
	shld MIN10
	shld MIN12
	call mule_32x32_test
	lxi h, 1788
	shld MIN00
	lxi h, 367
	shld MIN02
	lxi h, 192
	shld MIN10
	lxi h, 53788
	shld MIN12
	call mule_32x32_test
	call wait_for_key
	
	lxi h, 19382
	shld DIN00
	lxi h, 33
	shld DIN02
	lxi h, 325
	shld DIN10
	lxi h, 0
	shld DIN12
	call div_32x32_test
	lxi h, 14221
	shld DIN00
	lxi h, 1879
	shld DIN02
	lxi h, 11111
	shld DIN10
	lxi h, 12
	shld DIN12
	call div_32x32_test
	lxi h, 1111
	shld DIN00
	lxi h, 11
	shld DIN02
	lxi h, 0
	shld DIN10
	shld DIN12
	call div_32x32_test
	lxi h, 0
	shld DIN00
	lxi h, 0
	shld DIN02
	lxi h, 32
	shld DIN10
	shld DIN12
	call div_32x32_test
	lxi h, 17577
	shld DIN00
	lxi h, 1
	shld DIN02
	lxi h, 3
	shld DIN10
	lxi h, 0
	shld DIN12
	call div_32x32_test
	lxi h, 17577
	shld DIN00
	lxi h, 10401
	shld DIN02
	lxi h, 307
	shld DIN04
	lxi h, 33
	shld DIN10
	lxi h, 123
	shld DIN12
	call div_48x32_test
	call wait_for_key
	
	mvi d, 19
L0:
	mvi a, '~'
	call FUNC_TABLE+SERIAL_WRITE
	dcr d
	jnz L0
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	
	lxi h, text2
	call FUNC_TABLE+PUTS
	call wait_for_key
	lxi h, text4
	call FUNC_TABLE+PUTS
	lxi d, 19382
	call printint
	lxi d, 1738
	call printint
	lxi d, 621
	call printint
	lxi d, 69
	call printint
	lxi d, 5
	call printint
	lxi d, 0
	call printint
	lxi d, 65536-100
	call printint
	lxi d, 65536-621
	call printint
	lxi d, 65536-17386
	call printint
	call wait_for_key
	lxi h, text5
	call FUNC_TABLE+PUTS
	; 24773686
	lxi d, 378
	lxi b, 1078
	call printint32
	; 768314
	lxi d, 11
	lxi b, 47418
	call printint32
	lxi d, 11
	lxi b, 47418
	mov a, c
	cma
	adi 1
	mov c, a
	mov a, b
	cma
	adi 0
	mov b, a
	mov a, e
	cma
	adi 0
	mov e, a
	mov a, d
	cma
	adi 0
	mov d, a
	call printint32
	lxi d, 0
	lxi b, 0
	call printint32
	lxi d, 0
	lxi b, 1
	call printint32
	lxi d, 1
	lxi b, 0
	call printint32
	lxi d, 29481
	lxi b, 32011
	call printint32
	call wait_for_key
	lxi h, text6
	call FUNC_TABLE+PUTS
	mvi d, 5
	mvi e, 6
	call mul_8x8_signed_test
	mvi a, 5
	cma
	inr a
	mov d, a
	mvi e, 6
	call mul_8x8_signed_test
	mvi d, 5
	mvi a, 6
	cma
	inr a
	mov e, a
	call mul_8x8_signed_test
	mvi a, 5
	cma
	inr a
	mov d, a
	mvi a, 6
	cma
	inr a
	mov e, a
	call mul_8x8_signed_test
	
	mvi d, 55
	mvi e, 66
	call mule_8x8_signed_test
	mvi a, 55
	cma
	inr a
	mov d, a
	mvi e, 66
	call mule_8x8_signed_test
	mvi d, 55
	mvi a, 66
	cma
	inr a
	mov e, a
	call mule_8x8_signed_test
	mvi a, 55
	cma
	inr a
	mov d, a
	mvi a, 66
	cma
	inr a
	mov e, a
	call mule_8x8_signed_test
	lxi d, 1005
	lxi b, 21
	call mul_16x16_signed_test
	lxi d, 65535-1005+1
	lxi b, 21
	call mul_16x16_signed_test
	lxi d, 1005
	lxi b, 65535-21+1
	call mul_16x16_signed_test
	lxi d, 65535-1005+1
	lxi b, 65535-21+1
	call mul_16x16_signed_test
	lxi d, 23768
	lxi b, 3005
	call mule_16x16_signed_test
	lxi d, 65535-23768+1
	lxi b, 3005
	call mule_16x16_signed_test
	lxi d, 23768
	lxi b, 65535-3005+1
	call mule_16x16_signed_test
	lxi d, 65535-23768+1
	lxi b, 65535-3005+1
	call mule_16x16_signed_test
	lxi h, 1788
	shld MIN00
	lxi h, 367
	shld MIN02
	lxi h, 192
	shld MIN10
	lxi h, 23788
	shld MIN12
	call mule_32x32_signed_test
	lxi h, 65535-1788+1
	shld MIN00
	lxi h, 65535-367
	shld MIN02
	lxi h, 192
	shld MIN10
	lxi h, 23788
	shld MIN12
	call mule_32x32_signed_test
	lxi h, 1788
	shld MIN00
	lxi h, 367
	shld MIN02
	lxi h, 65535-192+1
	shld MIN10
	lxi h, 65535-23788
	shld MIN12
	call mule_32x32_signed_test
	lxi h, 65535-1788+1
	shld MIN00
	lxi h, 65535-367
	shld MIN02
	lxi h, 65535-192+1
	shld MIN10
	lxi h, 65535-23788
	shld MIN12
	call mule_32x32_signed_test
	
	call wait_for_key
	lxi h, text7
	call FUNC_TABLE+PUTS
	
	mvi d, 33
	mvi e, 5
	call div_8x8_signed_test
	mvi d, 65535-33+1
	mvi e, 5
	call div_8x8_signed_test
	mvi d, 33
	mvi e, 65535-5+1
	call div_8x8_signed_test
	mvi d, 65535-33+1
	mvi e, 65535-5+1
	call div_8x8_signed_test
	lxi d, 17688
	lxi b, 5
	call div_16x16_signed_test
	lxi d, 65535-17688+1
	lxi b, 5
	call div_16x16_signed_test
	lxi d, 17688
	lxi b, 65535-5+1
	call div_16x16_signed_test
	lxi d, 65535-17688+1
	lxi b, 65535-5+1
	call div_16x16_signed_test
	
	lxi h, 19382
	shld DIN00
	lxi h, 33
	shld DIN02
	lxi h, 325
	shld DIN10
	lxi h, 0
	shld DIN12
	call div_32x32_signed_test
	lxi h, 65535-19382+1
	shld DIN00
	lxi h, 65535-33
	shld DIN02
	lxi h, 325
	shld DIN10
	lxi h, 0
	shld DIN12
	call div_32x32_signed_test
	lxi h, 19382
	shld DIN00
	lxi h, 33
	shld DIN02
	lxi h, 65535-325+1
	shld DIN10
	lxi h, 65535
	shld DIN12
	call div_32x32_signed_test
	lxi h, 65535-19382+1
	shld DIN00
	lxi h, 65535-33
	shld DIN02
	lxi h, 65535-325+1
	shld DIN10
	lxi h, 65535
	shld DIN12
	call div_32x32_signed_test
	lxi h, 17577
	shld DIN00
	lxi h, 10401
	shld DIN02
	lxi h, 307
	shld DIN04
	lxi h, 33
	shld DIN10
	lxi h, 123
	shld DIN12
	call div_48x32_signed_test
	lxi h, 65535-17577+1
	shld DIN00
	lxi h, 65535-10401
	shld DIN02
	lxi h, 65535-307
	shld DIN04
	lxi h, 33
	shld DIN10
	lxi h, 123
	shld DIN12
	call div_48x32_signed_test
	lxi h, 17577
	shld DIN00
	lxi h, 10401
	shld DIN02
	lxi h, 307
	shld DIN04
	lxi h, 65535-33+1
	shld DIN10
	lxi h, 65535-123
	shld DIN12
	call div_48x32_signed_test
	lxi h, 65535-17577+1
	shld DIN00
	lxi h, 65535-10401
	shld DIN02
	lxi h, 65535-307
	shld DIN04
	lxi h, 65535-33+1
	shld DIN10
	lxi h, 65535-123
	shld DIN12
	call div_48x32_signed_test
	
	call wait_for_key
	lxi h, text8
	call FUNC_TABLE+PUTS
	
	lxi d, 53
	lxi b, 30768
	lxi h, STRBUFF
	call fitoa
	call FUNC_TABLE+PUTS

	mvi a, '*'
	call FUNC_TABLE+SERIAL_WRITE

	lxi d, 65535-3
	lxi b, 65535-9279+1
	lxi h, STRBUFF
	call fitoa
	call FUNC_TABLE+PUTS
	
	mvi a, '/'
	call FUNC_TABLE+SERIAL_WRITE
	
	lxi d, 2
	lxi b, 16384
	lxi h, STRBUFF
	call fitoa
	call FUNC_TABLE+PUTS
	
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	
	lxi h, 53
	shld MIN02
	lxi h, 30768
	shld MIN00
	lxi h, 65535-3
	shld MIN12
	lxi h, 65535-9279+1
	shld MIN10
	call mul_fixed
	
	lhld FOUT0
	shld DIN00
	lhld FOUT2
	shld DIN02
	lxi h, 2
	shld DIN12
	lxi h, 16384
	shld DIN10
	call div_fixed
	lhld FOUT0
	mov b, h
	mov c, l
	lhld FOUT2
	mov d, h
	mov e, l
	lxi h, STRBUFF
	call fitoa
	call FUNC_TABLE+PUTS
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	
	lxi h, text9
	call FUNC_TABLE+PUTS
	lxi d, 47
	lxi b, 52429
	lxi h, STRBUFF
	call fitoa
	call FUNC_TABLE+PUTS
	mvi a, ')'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	
	lxi h, 47
	shld MIN02
	lxi h, 52429
	shld MIN00
	call sqrt_fixed
	lhld FOUT0
	mov b, h
	mov c, l
	lhld FOUT2
	mov d, h
	mov e, l
	lxi h, STRBUFF
	call fitoa
	call FUNC_TABLE+PUTS
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	
	lxi h, 19481
	shld XS_STATE0
	lxi h, 10459
	shld XS_STATE2
	lxi h, 3918
	shld XS_STATE4
	lxi h, 19407
	shld XS_STATE6
	
	lxi h, text10
	call FUNC_TABLE+PUTS
	call wait_for_key
	
	mvi d, 10
L30:
	push d
	call xorshift
	call printint32
	pop d
	dcr d
	jnz L30
	
	mvi d, 10
L31:
	push d
	call xorshift
	call printint
	pop d
	dcr d
	jnz L31
	
halt:
	nop
	nop
	nop
	hlt
	jmp halt
	
wait_for_key:
	lxi h, text3
	call FUNC_TABLE+PUTS
L4
	call FUNC_TABLE+SERIAL_READ
	ana a
	jz L4
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret
	
mul_8x8_test:
	mov a, d
	call FUNC_TABLE+PRINT_HEX
	mvi a, '*'
	call FUNC_TABLE+SERIAL_WRITE
	mov a, e
	call FUNC_TABLE+PRINT_HEX
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	call mul_8x8
	mov a, d
	call FUNC_TABLE+PRINT_HEX
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret

mul_8x8_signed_test:
	mov b, d
	mov c, e
	mov a, b
	mov e, a
	ral
	mvi a, 0
	sbi 0
	mov d, a
	lxi h, STRBUFF
	call itoa16
	call FUNC_TABLE+PUTS
	mvi a, '*'
	call FUNC_TABLE+SERIAL_WRITE
	mov a, c
	mov e, a
	ral
	mvi a, 0
	sbi 0
	mov d, a
	call itoa16
	call FUNC_TABLE+PUTS
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	mov d, b
	mov e, c
	call mul_8x8_signed
	mov a, d
	mov e, a
	ral
	mvi a, 0
	sbi 0
	mov d, a
	lxi h, STRBUFF
	call itoa16
	call FUNC_TABLE+PUTS
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret
	
mule_8x8_test:
	mov a, d
	call FUNC_TABLE+PRINT_HEX
	mvi a, '*'
	call FUNC_TABLE+SERIAL_WRITE
	mov a, e
	call FUNC_TABLE+PRINT_HEX
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	call mule_8x8
	mov a, b
	call FUNC_TABLE+PRINT_HEX
	mov a, c
	call FUNC_TABLE+PRINT_HEX
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret

mule_8x8_signed_test:
	mov b, d
	mov c, e
	mov a, b
	mov e, a
	ral
	mvi a, 0
	sbi 0
	mov d, a
	lxi h, STRBUFF
	call itoa16
	call FUNC_TABLE+PUTS
	mvi a, '*'
	call FUNC_TABLE+SERIAL_WRITE
	mov a, c
	mov e, a
	ral
	mvi a, 0
	sbi 0
	mov d, a
	call itoa16
	call FUNC_TABLE+PUTS
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	mov d, b
	mov e, c
	call mule_8x8_signed
	mov d, b
	mov e, c
	lxi h, STRBUFF
	call itoa16
	call FUNC_TABLE+PUTS
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret

mul_16x16_signed_test:
	lxi h, STRBUFF
	call itoa16
	call FUNC_TABLE+PUTS
	mvi a, '*'
	call FUNC_TABLE+SERIAL_WRITE
	push d
	mov d, b
	mov e, c
	call itoa16
	call FUNC_TABLE+PUTS
	pop d
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	call mul_16x16_signed
	lxi h, STRBUFF
	call itoa16
	call FUNC_TABLE+PUTS
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret

mule_16x16_signed_test:
	lxi h, STRBUFF
	call itoa16
	call FUNC_TABLE+PUTS
	mvi a, '*'
	call FUNC_TABLE+SERIAL_WRITE
	push d
	mov d, b
	mov e, c
	call itoa16
	call FUNC_TABLE+PUTS
	pop d
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	call mule_16x16_signed
	lxi h, MRES0
	mov a, m
	mov c, a
	inx h
	mov a, m
	mov b, a
	inx h
	mov a, m
	mov e, a
	inx h
	mov a, m
	mov d, a
	lxi h, STRBUFF
	call itoa32
	call FUNC_TABLE+PUTS
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret

div_8x8_signed_test:
	mov b, d
	mov c, e
	mov a, b
	mov e, a
	ral
	mvi a, 0
	sbi 0
	mov d, a
	lxi h, STRBUFF
	call itoa16
	call FUNC_TABLE+PUTS
	mvi a, '/'
	call FUNC_TABLE+SERIAL_WRITE
	mov a, c
	mov e, a
	ral
	mvi a, 0
	sbi 0
	mov d, a
	call itoa16
	call FUNC_TABLE+PUTS
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	mov d, b
	mov e, c
	call div_8x8_signed
	mov c, a
	mov a, d
	mov e, a
	ral
	mvi a, 0
	sbi 0
	mov d, a
	lxi h, STRBUFF
	call itoa16
	call FUNC_TABLE+PUTS
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 'R'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ':'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
	mov a, c
	mov e, a
	ral
	mvi a, 0
	sbi 0
	mov d, a
	lxi h, STRBUFF
	call itoa16
	call FUNC_TABLE+PUTS
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret

backup_nums:
	lhld DIN00
	shld MIN00
	lhld DIN02
	shld MIN02
	lhld DIN10
	shld MIN10
	lhld DIN12
	shld MIN12
	lhld REM0
	shld MRES0
	lhld REM2
	shld MRES2
	ret

restore_nums:
	lhld MIN00
	shld DIN00
	lhld MIN02
	shld DIN02
	lhld MIN10
	shld DIN10
	lhld MIN12
	shld DIN12
	lhld MRES0
	shld REM0
	lhld MRES2
	shld REM2
	ret

div_48x32_signed_test:
	lxi h, DIN05
	mvi d, 6
	call print_signed_hex
	mvi a, '/'
	call FUNC_TABLE+SERIAL_WRITE
	lxi h, DIN13
	mvi d, 4
	call print_signed_hex
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	call div_48x32_signed
	lxi h, DRES5
	mvi d, 6
	call print_signed_hex
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 'R'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ':'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
	lxi h, REM3
	mvi d, 4
	call print_signed_hex
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret

div_32x32_signed_test:
	call backup_nums
	lxi d, STRBUFF
	lhld DIN00
	mov b, h
	mov c, l
	lhld DIN02
	xchg
	call itoa32
	call FUNC_TABLE+PUTS
	mvi a, '/'
	call FUNC_TABLE+SERIAL_WRITE
	call restore_nums
	lxi d, STRBUFF
	lhld DIN10
	mov b, h
	mov c, l
	lhld DIN12
	xchg
	call itoa32
	call FUNC_TABLE+PUTS
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	call restore_nums
	call div_32x32_signed
	call backup_nums
	lxi d, STRBUFF
	lhld DRES0
	mov b, h
	mov c, l
	lhld DRES2
	xchg
	call itoa32
	call FUNC_TABLE+PUTS
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 'R'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ':'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
	call restore_nums
	lxi d, STRBUFF
	lhld REM0
	mov b, h
	mov c, l
	lhld REM2
	xchg
	call itoa32
	call FUNC_TABLE+PUTS
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret

div_16x16_signed_test:
	lxi h, STRBUFF
	call itoa16
	call FUNC_TABLE+PUTS
	mvi a, '/'
	call FUNC_TABLE+SERIAL_WRITE
	push d
	mov d, b
	mov e, c
	call itoa16
	call FUNC_TABLE+PUTS
	pop d
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	call div_16x16_signed
	shld MD_TEMP9
	lxi h, STRBUFF
	call itoa16
	call FUNC_TABLE+PUTS
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 'R'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ':'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
	lhld MD_TEMP9
	xchg
	lxi h, STRBUFF
	call itoa16
	call FUNC_TABLE+PUTS
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret
	
div_8x8_test:
	mov a, d
	call FUNC_TABLE+PRINT_HEX
	mvi a, '/'
	call FUNC_TABLE+SERIAL_WRITE
	mov a, e
	call FUNC_TABLE+PRINT_HEX
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	call div_8x8
	sta MD_TEMP0
	mov a, d
	call FUNC_TABLE+PRINT_HEX
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 'R'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ':'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
	lda MD_TEMP0
	call FUNC_TABLE+PRINT_HEX
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret
	
div_16x16_test:
	mov a, d
	call FUNC_TABLE+PRINT_HEX
	mov a, e
	call FUNC_TABLE+PRINT_HEX
	mvi a, '/'
	call FUNC_TABLE+SERIAL_WRITE
	mov a, b
	call FUNC_TABLE+PRINT_HEX
	mov a, c
	call FUNC_TABLE+PRINT_HEX
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	call div_16x16
	mov a, d
	call FUNC_TABLE+PRINT_HEX
	mov a, e
	call FUNC_TABLE+PRINT_HEX
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 'R'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ':'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
	mov a, h
	call FUNC_TABLE+PRINT_HEX
	mov a, l
	call FUNC_TABLE+PRINT_HEX
	;Print remainder here
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret
	
mul_16x16_test:
	mov a, d
	call FUNC_TABLE+PRINT_HEX
	mov a, e
	call FUNC_TABLE+PRINT_HEX
	mvi a, '*'
	call FUNC_TABLE+SERIAL_WRITE
	mov a, b
	call FUNC_TABLE+PRINT_HEX
	mov a, c
	call FUNC_TABLE+PRINT_HEX
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	call mul_16x16
	mov a, d
	call FUNC_TABLE+PRINT_HEX
	mov a, e
	call FUNC_TABLE+PRINT_HEX
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret
	
mule_16x16_test:
	mov a, d
	call FUNC_TABLE+PRINT_HEX
	mov a, e
	call FUNC_TABLE+PRINT_HEX
	mvi a, '*'
	call FUNC_TABLE+SERIAL_WRITE
	mov a, b
	call FUNC_TABLE+PRINT_HEX
	mov a, c
	call FUNC_TABLE+PRINT_HEX
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	call mule_16x16
	lxi h, MRES3
	mvi b, 4
L7
	mov a, m
	CALL FUNC_TABLE+PRINT_HEX
	dcx h
	dcr b
	jnz L7
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret
	
mul_8x32_test:
	lxi h, MD_TEMP3
	mvi e, 4
L5
	mov a, m
	dcx h
	call FUNC_TABLE+PRINT_HEX
	dcr e
	jnz L5
	mvi a, '*'
	call FUNC_TABLE+SERIAL_WRITE
	mov a, d
	call FUNC_TABLE+PRINT_HEX
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	call mul_8x32
	lxi h, MD_TEMP9
	mvi e, 5
L6
	mov a, m
	dcx h
	call FUNC_TABLE+PRINT_HEX
	dcr e
	jnz L6
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret
	
mule_32x32_test:
	lxi h, MIN03
	mvi d, 4
L3
	mov a, m
	dcx h
	call FUNC_TABLE+PRINT_HEX
	dcr d
	jnz L3
	mvi a, '*'
	call FUNC_TABLE+SERIAL_WRITE
	lxi h, MIN13
	mvi d, 4
L1
	mov a, m
	dcx h
	call FUNC_TABLE+PRINT_HEX
	dcr d
	jnz L1
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	call mule_32x32
	lxi h, MRES7
	mvi d, 8
L2
	mov a, m
	dcx h
	call FUNC_TABLE+PRINT_HEX
	dcr d
	jnz L2
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret

print_signed_hex:
	mov a, m
	ana a
	jp print_signed_hex_not_neg
	lxi b, STRBUFF
	mov a, l
	sub d
	mov l, a
	mov a, h
	sbi 0
	mov h, a
	push d
	stc
L20:
	inx h
	mov a, m
	cma
	aci 0
	stax b
	inx b
	dcr d
	jnz L20
	pop d
	dcx b
	mvi a, '-'
	call FUNC_TABLE+SERIAL_WRITE
L21:
	ldax b
	call FUNC_TABLE+PRINT_HEX
	dcx b
	dcr d
	jnz L21
	ret
print_signed_hex_not_neg:
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
L22:
	mov a, m
	call FUNC_TABLE+PRINT_HEX
	dcx h
	dcr d
	rz
	jmp L22

mule_32x32_signed_test:
	lxi h, MIN03
	mvi d, 4
	call print_signed_hex
	mvi a, '*'
	call FUNC_TABLE+SERIAL_WRITE
	lxi h, MIN13
	mvi d, 4
	call print_signed_hex
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	call mule_32x32_signed
	lxi h, MRES7
	mvi d, 8
	call print_signed_hex
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret

div_32x32_test:
	push b
	push d
	push h
	push psw
	lxi h, DIN03
	mvi d, 4
L10
	mov a, m
	dcx h
	call FUNC_TABLE+PRINT_HEX
	dcr d
	jnz L10
	mvi a, '/'
	call FUNC_TABLE+SERIAL_WRITE
	lxi h, DIN13
	mvi d, 4
L11
	mov a, m
	dcx h
	call FUNC_TABLE+PRINT_HEX
	dcr d
	jnz L11
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	call div_32x32
	lxi h, DRES3
	mvi d, 4
L12
	mov a, m
	dcx h
	call FUNC_TABLE+PRINT_HEX
	dcr d
	jnz L12
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 'R'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ':'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
	lxi h, REM3
	mvi d, 4
L14
	mov a, m
	dcx h
	call FUNC_TABLE+PRINT_HEX
	dcr d
	jnz L14
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE	
	pop psw
	pop h
	pop d
	pop b
	ret
	
div_48x32_test:
	lxi h, DIN05
	mvi d, 6
L15
	mov a, m
	dcx h
	call FUNC_TABLE+PRINT_HEX
	dcr d
	jnz L15
	mvi a, '/'
	call FUNC_TABLE+SERIAL_WRITE
	lxi h, DIN13
	mvi d, 4
L16
	mov a, m
	dcx h
	call FUNC_TABLE+PRINT_HEX
	dcr d
	jnz L16
	mvi a, '='
	call FUNC_TABLE+SERIAL_WRITE
	call div_48x32
	lxi h, DRES5
	mvi d, 6
L17
	mov a, m
	dcx h
	call FUNC_TABLE+PRINT_HEX
	dcr d
	jnz L17
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 'R'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ':'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE
	lxi h, REM3
	mvi d, 4
L18
	mov a, m
	dcx h
	call FUNC_TABLE+PRINT_HEX
	dcr d
	jnz L18
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	ret
	
	; Multiplies d by e
mul_8x8:
	push h
	mov h, e
	mvi l, 0
mul_8x8_loop:
	mov a, h
	ani 127
	jz mul_8x8_exit
	rrc
	mov h, a
	jnc mul_8x8_no_carry
	mov a, l
	add d
	mov l, a
mul_8x8_no_carry:
	mov a, d
	add a
	mov d, a
	jnz mul_8x8_loop
mul_8x8_exit:
	mov d, l
	pop h
	ret

mul_8x8_signed:
	push d
	push b
	mvi b, 0
	mov a, d
	ora a
	jp mul_8x8_signed_first_nn
	cma
	inr a
	mov d, a
	inr b
mul_8x8_signed_first_nn:
	mov a, e
	ora a
	jp mul_8x8_signed_second_nn
	cma
	inr a
	mov e, a
	inr b
mul_8x8_signed_second_nn:
	call mul_8x8
	mov a, b
	cpi 1
	mov a, d
	jnz mul_8x8_signed_no_inv_res
	cma
	inr a
mul_8x8_signed_no_inv_res:
	pop b
	pop d
	mov d, a
	ret
	
	; Multiplies d by e, 16-bit result in bc
mule_8x8:
	push d
	push h
	lxi b, 0
	mvi h, 0
mule_8x8_loop:
	mov a, e
	ana a
	jz mule_8x8_exit
	rar
	mov e, a
	jnc mule_8x8_no_carry
	mov a, c
	add d
	mov c, a
	mov a, h
	adc b
	mov b, a
mule_8x8_no_carry:
	mov a, d
	add a
	jz mule_8x8_exit
	mov d, a
	mov a, h
	adc a
	mov h, a
	jmp mule_8x8_loop
mule_8x8_exit:
	pop h
	pop d
	ret
	
mule_8x8_signed:
	push d
	push h
	mvi l, 0
	mov a, d
	ora a
	jp mule_8x8_signed_first_nn
	cma
	inr a
	mov d, a
	inr l
mule_8x8_signed_first_nn:
	mov a, e
	ora a
	jp mule_8x8_signed_second_nn
	cma
	inr a
	mov e, a
	inr l
mule_8x8_signed_second_nn:
	call mule_8x8
	mov a, l
	cpi 1
	jnz mule_8x8_signed_no_inv_res
	mov a, c
	cma
	adi 1
	mov c, a
	mov a, b
	cma
	aci 0
	mov b, a
mule_8x8_signed_no_inv_res:
	pop h
	pop d
	ret
	
	; Multiplies de by bc
mul_16x16:
	push b
	push h
	lxi h, 0
mul_16x16_loop:
	ana a
	mov a, d
	rar
	mov d, a
	mov a, e
	rar
	mov e, a
	jnc mul_16x16_no_carry
	mov a, l
	add c
	mov l, a
	mov a, h
	adc b
	mov h, a
mul_16x16_no_carry:
	mov a, d
	ora e
	jz mul_16x16_end
	mov a, c
	add a
	mov c, a
	mov a, b
	adc a
	mov b, a
	ora c
	jnz mul_16x16_loop
mul_16x16_end:
	xchg
	pop h
	pop b
	ret

mul_16x16_signed:
	push b
	push h
	
	mvi l, 0
	mov a, d
	ana a
	jp mul_16x16_signed_first_nn
	mov a, e
	cma
	adi 1
	mov e, a
	mov a, d
	cma
	aci 0
	mov d, a
	inr l
mul_16x16_signed_first_nn:
	mov a, b
	ana a
	jp mul_16x16_signed_second_nn
	mov a, c
	cma
	adi 1
	mov c, a
	mov a, b
	cma
	aci 0
	mov b, a
	inr l
mul_16x16_signed_second_nn:
	call mul_16x16
	mov a, l
	cpi 1
	jnz mul_16x16_signed_no_inv_res
	mov a, e
	cma
	adi 1
	mov e, a
	mov a, d
	cma
	aci 0
	mov d, a
mul_16x16_signed_no_inv_res:
	pop h
	pop b
	ret
	
	; Multiplies de by bc, result in MRES0-3
mule_16x16:
	push d
	push h
	push b
	lxi h, MRES0
	xra a
	mov m, a
	inx h
	mov m, a
	inx h
	mov m, a
	inx h
	mov m, a
	lxi h, 0
mule_16x16_loop:
	ana a
	mov a, d
	rar
	mov d, a
	mov a, e
	rar
	mov e, a
	jnc mule_16x16_no_carry
	push d
	lxi d, MRES0
	; 1
	ldax d
	add c
	stax d
	inx d
	; 2
	ldax d
	adc b
	stax d
	inx d
	; 3
	ldax d
	adc l
	stax d
	inx d
	; 4
	ldax d
	adc h
	stax d
	pop d
mule_16x16_no_carry:
	mov a, d
	ora e
	jz mule_16x16_end
	mov a, c
	add c
	mov c, a
	mov a, b
	adc b
	mov b, a
	mov a, l
	adc l
	mov l, a
	mov a, h
	adc h
	mov h, a
	ora l
	ora b
	ora c
	jnz mule_16x16_loop
mule_16x16_end:
	pop b
	pop h
	pop d
	ret

mule_16x16_signed:
	push b
	push h
	push d
	
	mvi l, 0
	mov a, d
	ana a
	jp mule_16x16_signed_first_nn
	mov a, e
	cma
	adi 1
	mov e, a
	mov a, d
	cma
	aci 0
	mov d, a
	inr l
mule_16x16_signed_first_nn:
	mov a, b
	ana a
	jp mule_16x16_signed_second_nn
	mov a, c
	cma
	adi 1
	mov c, a
	mov a, b
	cma
	aci 0
	mov b, a
	inr l
mule_16x16_signed_second_nn:
	call mule_16x16
	mov a, l
	cpi 1
	jnz mule_16x16_signed_no_inv_res
	mvi d, 0
	lxi h, MRES0
	mov a, m
	cma
	adi 1
	mov m, a
	inx h
	mov a, m
	cma
	adc d
	mov m, a
	inx h
	mov a, m
	cma
	adc d
	mov m, a
	inx h
	mov a, m
	cma
	adc d
	mov m, a
mule_16x16_signed_no_inv_res:
	pop d
	pop h
	pop b
	ret
	
	; Multiplies the MINxx memory locations, 64-bit result in MRESx locations
mule_32x32:
	push d
	push b
	push h
	
	lxi h, MRES0
	xra a
	mov m, a
	inx h
	mov m, a
	inx h
	mov m, a
	inx h
	mov m, a
	inx h
	mov m, a
	inx h
	mov m, a
	inx h
	mov m, a
	inx h
	mov m, a
	lxi h, MRES0
	lxi b, MIN10
	mvi e, 4
mul_32x32_loop:
	push h
	push b
	lxi h, MD_TEMP0
	lxi b, MIN00
	; 1
	ldax b
	mov m, a
	inx h
	inx b
	; 2
	ldax b
	mov m, a
	inx h
	inx b
	; 3
	ldax b
	mov m, a
	inx h
	inx b
	; 4
	ldax b
	mov m, a
	pop b
	pop h
	ldax b
	inx b
	mov d, a
	call mul_8x32
	push b
	push h
	; 1
	lxi b, MD_TEMP5
	ldax b
	add m
	mov m, a
	inx b
	inx h
	; 2
	ldax b
	adc m
	mov m, a
	inx b
	inx h
	; 3
	ldax b
	adc m
	mov m, a
	inx b
	inx h
	; 4
	ldax b
	adc m
	mov m, a
	inx b
	inx h
	; 5
	ldax b
	adc m
	mov m, a
	inx b
	inx h
	pop h
	pop b
	inx h
	
	dcr e
	jnz mul_32x32_loop
	
	pop h
	pop b
	pop d
	ret
	
	; TODO: Optimize
	; Mutiplies d by MD_TEMP0-3, 40-bit result in MD_TEMP5-9
mul_8x32:
	push b
	push h
	lxi h, MD_TEMP4
	xra a
	mov m, a
	inx h
	mov m, a
	inx h
	mov m, a
	inx h
	mov m, a
	inx h
	mov m, a
	inx h
	mov m, a
mul_8x32_loop:
	mov a, d
	rar
	mov d, a
	jnc mul_8x32_no_carry
	lxi h, MD_TEMP0
	lxi b, MD_TEMP5
	; 1
	ldax b
	add m
	stax b
	inx h
	inx b
	; 2
	ldax b
	adc m
	stax b
	inx h
	inx b
	; 3
	ldax b
	adc m
	stax b
	inx h
	inx b
	; 4
	ldax b
	adc m
	stax b
	inx h
	inx b
	; 5
	ldax b
	adc m
	stax b
mul_8x32_no_carry:
	mov a, d
	ora a
	jz mul_8x32_end
	; 1
	lxi h, MD_TEMP0
	mov a, m
	add a
	mov m, a
	inx h
	; 2
	mov a, m
	ral
	mov m, a
	inx h
	; 3
	mov a, m
	ral
	mov m, a
	inx h
	; 4
	mov a, m
	ral
	mov m, a
	inx h
	; 5
	mov a, m
	ral
	mov m, a
	jmp mul_8x32_loop
mul_8x32_end:
	pop h
	pop b
	ret

mule_32x32_signed:
	push d
	push h
	
	mvi d, 0
	lda MIN03
	ana a
	jp mule_32x32_signed_first_nn
	lhld MIN00
	mvi e, 0
	mov a, l
	cma
	aci 1
	mov l, a
	mov a, h
	cma
	adc e
	mov h, a
	shld MIN00
	lhld MIN02
	mov a, l
	cma
	adc e
	mov l, a
	mov a, h
	cma
	adc e
	mov h, a
	shld MIN02
	inr d
mule_32x32_signed_first_nn:
	lda MIN13
	ana a
	jp mule_32x32_signed_second_nn
	lhld MIN10
	mvi e, 0
	mov a, l
	cma
	aci 1
	mov l, a
	mov a, h
	cma
	adc e
	mov h, a
	shld MIN10
	lhld MIN12
	mov a, l
	cma
	adc e
	mov l, a
	mov a, h
	cma
	adc e
	mov h, a
	shld MIN12
	inr d
mule_32x32_signed_second_nn:
	call mule_32x32
	mov a, d
	cpi 1
	jnz mule_32x32_signed_no_inv_res
	mvi e, 0
	lhld MRES0
	mov a, l
	cma
	aci 1
	mov l, a
	mov a, h
	cma
	adc e
	mov h, a
	shld MRES0
	lhld MRES2
	mov a, l
	cma
	adc e
	mov l, a
	mov a, h
	cma
	adc e
	mov h, a
	shld MRES2
	lhld MRES4
	mov a, l
	cma
	adc e
	mov l, a
	mov a, h
	cma
	adc e
	mov h, a
	shld MRES4
	lhld MRES6
	mov a, l
	cma
	adc e
	mov l, a
	mov a, h
	cma
	adc e
	mov h, a
	shld MRES6
mule_32x32_signed_no_inv_res:
	pop h
	pop d
	ret
	
	; Divides d by e, remainder in a
div_8x8:
	push h
	push b
	mvi b, 8
	lxi h, 0
div_8x8_loop:
	mov a, l
	add l
	mov l, a
	mov a, d
	ral
	mov d, a
	mov a, h
	ral
	mov h, a
	sub e
	jm div_8x8_continue
	mov h, a
	inr l
div_8x8_continue:
	dcr b
	jnz div_8x8_loop
	mov d, l
	mov a, h
	pop b
	pop h
	ret

div_8x8_signed:
	push d
	push b
	mvi b, 0
	mov a, d
	ora a
	jp div_8x8_signed_first_nn
	cma
	inr a
	mov d, a
	mvi b, 129
div_8x8_signed_first_nn:
	mov a, e
	ora a
	jp div_8x8_signed_second_nn
	cma
	inr a
	mov e, a
	inr b
div_8x8_signed_second_nn:
	call div_8x8
	mov c, a
	mov a, b
	ani 1
	jz div_8x8_signed_no_inv_res
	mov a, d
	cma
	inr a
	mov d, a
div_8x8_signed_no_inv_res:
	mov a, b
	ani 128
	mov a, c
	jz div_8x8_signed_no_inv_rem
	cma
	inr a
	mov c, a
div_8x8_signed_no_inv_rem:
	sta MD_TEMP0
	mov a, d
	pop b
	pop d
	mov d, a
	lda MD_TEMP0
	ret

	; Divides de by bc, remainder in hl
div_16x16:
	push b
	lxi h, MD_TEMP0
	xra a
	mov m, a
	inx h
	mov m, a
	inx h
	inx h
	inx h
	mvi a, 16
	mov m, a
	xchg
	shld MD_TEMP2
	lxi d, 0
	
div_16x16_loop:
	lxi h, MD_TEMP0
	mov a, m
	add a
	mov m, a
	inx h
	mov a, m
	adc a
	mov m, a
	
	inx h ; MD_TEMP2
	mov a, m
	ral
	mov m, a
	inx h
	mov a, m
	ral
	mov m, a
	mov a, e
	ral
	mov e, a
	mov a, d
	ral
	mov d, a
	
	mov a, e
	sub c
	mov a, d
	sbb b
	jm div_16x16_continue
	mov d, a
	mov a, e
	sub c
	mov e, a
	lxi h, MD_TEMP0
	mov a, m
	adi 1
	mov m, a
	inx h
	mov a, m
	aci 0
	mov m, a
div_16x16_continue:
	lxi h, MD_TEMP4
	dcr m
	jnz div_16x16_loop
	lhld MD_TEMP0
	xchg
	pop b
	ret

div_16x16_signed:
	push b
	
	mvi l, 0
	mov a, d
	ana a
	jp div_16x16_signed_first_nn
	mov a, e
	cma
	adi 1
	mov e, a
	mov a, d
	cma
	aci 0
	mov d, a
	mvi l, 129
div_16x16_signed_first_nn:
	mov a, b
	ana a
	jp div_16x16_signed_second_nn
	mov a, c
	cma
	adi 1
	mov c, a
	mov a, b
	cma
	aci 0
	mov b, a
	inr l
div_16x16_signed_second_nn:
	mov a, l
	sta MD_TEMP10
	call div_16x16
	shld MD_TEMP8
	lda MD_TEMP10
	mov l, a
	ani 1
	jz div_16x16_signed_no_inv_res
	mov a, e
	cma
	adi 1
	mov e, a
	mov a, d
	cma
	aci 0
	mov d, a
div_16x16_signed_no_inv_res:
	mov a, l
	ani 128
	lhld MD_TEMP8
	jz div_16x16_signed_no_inv_rem
	mov a, l
	cma
	adi 1
	mov l, a
	mov a, h
	cma
	aci 0
	mov h, a
div_16x16_signed_no_inv_rem:
	pop b
	ret

	; Divides the value in DIN00-03 by DIN10-13, result in DRES0-3, remainder in REM0-3
div_32x32:
	push b
	push d
	push h
	lxi h, MD_TEMP0
	lxi b, DIN00
	; 1
	ldax b
	mov m, a
	inx b
	inx h
	; 2
	ldax b
	mov m, a
	inx b
	inx h
	; 3
	ldax b
	mov m, a
	inx b
	inx h
	; 4
	ldax b
	mov m, a
	inx h
	; 5
	xra a
	mov m, a
	inx h
	; 6
	mov m, a
	inx h
	; 7
	mov m, a
	inx h
	; 8
	mov m, a
	
	mvi a, 32
	sta MD_TEMP9
	
	lxi h, DRES3
	xra a
	mov m, a
	dcx h
	mov m, a
	dcx h
	mov m, a
	dcx h
	mov m, a
	
div_32x32_loop:
	; LSH result
	lxi h, DRES0
	mov a, m
	add a
	mov m, a
	inx h
	mov a, m
	adc a
	mov m, a
	inx h
	mov a, m
	adc a
	mov m, a
	inx h
	mov a, m
	adc a
	mov m, a
	; 64-bit left-shift
	lhld MD_TEMP0
	xchg
	lhld MD_TEMP2
	mov a, e
	ora a
	ral
	mov e, a
	mov a, d
	ral
	mov d, a
	mov a, l
	ral
	mov l, a
	mov a, h
	ral
	mov h, a
	shld MD_TEMP2
	xchg
	shld MD_TEMP0
	lhld MD_TEMP4
	xchg
	lhld MD_TEMP6
	mov a, e
	ral
	mov e, a
	mov a, d
	ral
	mov d, a
	mov a, l
	ral
	mov l, a
	mov a, h
	ral
	mov h, a
	shld MD_TEMP6
	xchg
	shld MD_TEMP4
	; 32-bit compare, 32-bit value still in HL (low), DE (high) at this point
	mov b, h
	mov c, l
	lxi h, DIN10
	; 1
	mov a, c
	sub m
	inx h
	mov c, a
	; 2
	mov a, b
	sbb m
	inx h
	mov b, a
	; 3
	mov a, e
	sbb m
	inx h
	mov e, a
	; 4
	mov a, d
	sbb m
	mov d, a
	jm div_32x32_continue
	
	mov h, b
	mov l, c
	shld MD_TEMP4
	xchg
	shld MD_TEMP6
	
	lxi h, DRES0
	mvi a, 1
	ora m
	mov m, a
div_32x32_continue:
	lda MD_TEMP9
	sui 1
	sta MD_TEMP9
	jnz div_32x32_loop
	
	lxi h, MD_TEMP4
	lxi b, REM0
	; 1
	mov a, m
	stax b
	inx h
	inx b
	; 2
	mov a, m
	stax b
	inx h
	inx b
	; 3
	mov a, m
	stax b
	inx h
	inx b
	; 4
	mov a, m
	stax b
	
div_32x32_end:
	pop h
	pop d
	pop b
	ret

div_32x32_signed:
	push d
	push h
	
	mvi d, 0
	lda DIN03
	ora a
	jp div_32x32_signed_first_nn
	mvi e, 0
	lxi h, DIN00
	mov a, m
	cma
	adi 1
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	mvi d, 129
div_32x32_signed_first_nn:
	lda DIN13
	ora a
	jp div_32x32_signed_second_nn
	mvi e, 0
	lxi h, DIN10
	mov a, m
	cma
	adi 1
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inr d
div_32x32_signed_second_nn:
	call div_32x32
	mov a, d
	ani 1
	jz div_32x32_signed_no_inv_res
	lxi h, DRES0
	mvi e, 0
	mov a, m
	cma
	adi 1
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
div_32x32_signed_no_inv_res:
	mov a, d
	ani 128
	jz div_32x32_signed_no_inv_rem
	lxi h, REM0
	mvi e, 0
	mov a, m
	cma
	adi 1
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
div_32x32_signed_no_inv_rem:
	
	pop h
	pop d
	ret
	
	; Divides the value in DIN00-05 by DIN10-13, result in DRES0-5, remainder in REM0-3
div_48x32:
	push b
	push d
	push h
	lxi h, MD_TEMP0
	lxi b, DIN00
	; 1
	ldax b
	mov m, a
	inx b
	inx h
	; 2
	ldax b
	mov m, a
	inx b
	inx h
	; 3
	ldax b
	mov m, a
	inx b
	inx h
	; 4
	ldax b
	mov m, a
	inx h
	inx b
	; 5
	ldax b
	mov m, a
	inx h
	inx b
	; 6
	ldax b
	mov m, a
	inx h
	; 7
	xra a
	mov m, a
	inx h
	; 8
	mov m, a
	inx h
	; 9
	mov m, a
	inx h
	; 10
	mov m, a
	
	mvi a, 48
	sta MD_TEMP10
	
	lxi h, DRES3
	xra a
	mov m, a
	dcx h
	mov m, a
	dcx h
	mov m, a
	dcx h
	mov m, a
	
div_48x32_loop:
	; LSH result
	lxi h, DRES0
	mov a, m
	add a
	mov m, a
	inx h
	mov a, m
	adc a
	mov m, a
	inx h
	mov a, m
	adc a
	mov m, a
	inx h
	mov a, m
	adc a
	mov m, a
	inx h
	mov a, m
	adc a
	mov m, a
	inx h
	mov a, m
	adc a
	mov m, a
	; 80-bit left-shift
	lhld MD_TEMP0
	xchg
	lhld MD_TEMP2
	ora a
	db 0x10 ;rdel
	xchg
	db 0x10 ;rdel
	shld MD_TEMP0
	xchg
	shld MD_TEMP2
	lhld MD_TEMP4
	xchg
	lhld MD_TEMP6
	db 0x10 ;rdel
	xchg
	db 0x10 ;rdel
	shld MD_TEMP4
	xchg
	shld MD_TEMP6
	xchg
	lhld MD_TEMP8
	xchg
	db 0x10 ;rdel
	xchg
	shld MD_TEMP8
	; 32-bit compare, 32-bit value still in HL (high), DE (low) at this point
	mov b, h
	mov c, l
	lxi h, DIN10
	; 1
	mov a, e
	sub m
	inx h
	mov e, a
	; 2
	mov a, d
	sbb m
	inx h
	mov d, a
	; 3
	mov a, c
	sbb m
	inx h
	mov c, a
	; 4
	mov a, b
	sbb m
	mov b, a
	jm div_48x32_continue
	
	mov h, b
	mov l, c
	shld MD_TEMP8
	xchg
	shld MD_TEMP6
	
	lxi h, DRES0
	mvi a, 1
	ora m
	mov m, a
div_48x32_continue:
	lda MD_TEMP10
	sui 1
	sta MD_TEMP10
	jnz div_48x32_loop
	
	lxi h, MD_TEMP6
	lxi b, REM0
	; 1
	mov a, m
	stax b
	inx h
	inx b
	; 2
	mov a, m
	stax b
	inx h
	inx b
	; 3
	mov a, m
	stax b
	inx h
	inx b
	; 4
	mov a, m
	stax b
	
div_48x32_end:
	pop h
	pop d
	pop b
	ret

div_48x32_signed:
	push d
	push h
	
	mvi d, 0
	lda DIN05
	ora a
	jp div_48x32_signed_first_nn
	mvi e, 0
	lxi h, DIN00
	mov a, m
	cma
	adi 1
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	mvi d, 129
div_48x32_signed_first_nn:
	lda DIN13
	ora a
	jp div_48x32_signed_second_nn
	mvi e, 0
	lxi h, DIN10
	mov a, m
	cma
	adi 1
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inr d
div_48x32_signed_second_nn:
	call div_48x32
	mov a, d
	ani 1
	jz div_48x32_signed_no_inv_res
	lxi h, DRES0
	mvi e, 0
	mov a, m
	cma
	adi 1
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
div_48x32_signed_no_inv_res:
	mov a, d
	ani 128
	jz div_48x32_signed_no_inv_rem
	lxi h, REM0
	mvi e, 0
	mov a, m
	cma
	adi 1
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
	inx h
	mov a, m
	cma
	adc e
	mov m, a
div_48x32_signed_no_inv_rem:
	
	pop h
	pop d
	ret

	; Multiplies a fixed-point number stored in MIN00-03 by a fixed-point number stored in MIN10-13, result in FOUT0-3
mul_fixed:
	call mule_32x32_signed
	push h
	lhld MRES2
	shld FOUT0
	lhld MRES4
	shld FOUT2
	pop h
	ret

	; Divides a fixed-point number stored in DIN00-03 by a fixed-point number stored in DIN10-13, result in FOUT0-3
div_fixed:
	push h
	lhld DIN02
	shld DIN04
	lhld DIN00
	shld DIN02
	lxi h, 0
	shld DIN00
	call div_48x32_signed
	lhld DRES0
	shld FOUT0
	lhld DRES2
	shld FOUT2
	pop h
	ret

	; Square-root of value in MIN00-03, result in FOUT0-3
sqrt_fixed:
	push h
	push b
	push d
	
	; Back-up S
	lhld MIN00
	shld GR_TEMP4
	lhld MIN02
	shld GR_TEMP6
	
	; x0
	lxi h, 1
	shld GR_TEMP2
	lxi h, 0
	shld GR_TEMP0
	
	mvi d, 4
sqrt_iters:
	push d
	; xn²
	lhld GR_TEMP0
	shld MIN00
	shld MIN10
	lhld GR_TEMP2
	shld MIN02
	shld MIN12
	call mul_fixed
	
	; S - xn²
	lhld GR_TEMP4
	xchg
	lhld FOUT0
	mov a, e
	sub l
	mov l, a
	mov a, d
	sbb h
	mov h, a
	shld DIN00
	lhld GR_TEMP6
	xchg
	lhld FOUT2
	mov a, e
	sbb l
	mov l, a
	mov a, d
	sbb h
	mov h, a
	shld DIN02
	
	; 2xn
	lhld GR_TEMP0
	mov a, l
	add l
	mov l, a
	mov a, h
	adc h
	mov h, a
	shld DIN10
	lhld GR_TEMP2
	mov a, l
	adc l
	mov l, a
	mov a, h
	adc h
	mov h, a
	shld DIN12
	
	; an = (S - xn²) / 2xn
	call div_fixed
	
	; xn = xn + an
	lhld FOUT0
	xchg
	lhld GR_TEMP0
	mov a, e
	add l
	mov l, a
	mov a, d
	adc h
	mov h, a
	shld GR_TEMP0
	lhld FOUT2
	xchg
	lhld GR_TEMP2
	mov a, e
	adc l
	mov l, a
	mov a, d
	adc h
	mov h, a
	shld GR_TEMP2
	
	; an²
	lhld FOUT0
	shld MIN00
	shld MIN10
	lhld FOUT2
	shld MIN02
	shld MIN12
	call mul_fixed
	lhld FOUT0
	shld DIN00
	lhld FOUT2
	shld DIN02
	
	; 2xn - now same as 2(xn + an)
	lhld GR_TEMP0
	mov a, l
	add l
	mov l, a
	mov a, h
	adc h
	mov h, a
	shld DIN10
	lhld GR_TEMP2
	mov a, l
	adc l
	mov l, a
	mov a, h
	adc h
	mov h, a
	shld DIN12
	
	; an² / 2(xn + an)
	call div_fixed
	
	; xn = xn - div_res - effectively xn + an - div_res
	lhld GR_TEMP0
	xchg
	lhld FOUT0
	mov a, e
	sub l
	mov l, a
	mov a, d
	sbb h
	mov h, a
	shld GR_TEMP0
	lhld GR_TEMP2
	xchg
	lhld FOUT2
	mov a, e
	sbb l
	mov l, a
	mov a, d
	sbb h
	mov h, a
	shld GR_TEMP2
	
	pop d
	dcr d
	jnz sqrt_iters
	
	lhld GR_TEMP0
	shld FOUT0
	lhld GR_TEMP2
	shld FOUT2
	
	pop d
	pop b
	pop h
	ret

printint:
	push h
	lxi h, STRBUFF
	call itoa16
	call FUNC_TABLE+PUTS
	pop h
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 10
	jmp FUNC_TABLE+SERIAL_WRITE
	
printint32:
	push h
	lxi h, STRBUFF
	call itoa32
	call FUNC_TABLE+PUTS
	pop h
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 10
	jmp FUNC_TABLE+SERIAL_WRITE

	; Converts 32-bit fixed-point number in DE (high), BC (low, fraction) to string at buffer pointed to by HL
fitoa:
	push d
	push b
	push h
	
	mov a, d
	ana a
	jp fitoa_not_neg
	mov a, c
	cma
	adi 1
	mov c, a
	mov a, b
	cma
	aci 0
	mov b, a
	mov a, e
	cma
	aci 0
	mov e, a
	mov a, d
	cma
	aci 0
	mov d, a
	mvi a, '-'
	mov m, a
	inx h
fitoa_not_neg:
	call itoa16
fitoa_forward:
	mov a, m
	ana a
	jz fitoa_forward_end
	inx h
	jmp fitoa_forward
fitoa_forward_end:
	mvi a, '.'
	mov m, a
	inx h
	; Load constant '10' into MIN10-13
	push h
	lxi h, 10
	shld MIN12
	lxi h, 0
	shld MIN10
	; Move fraction of number into MIN00-03
	shld MIN02
	mov l, c
	mov h, b
	shld MIN00
	pop h
	mvi d, 8
fitoa_conv_loop:
	call mul_fixed
	lda FOUT2
	adi '0'
	mov m, a
	inx h
	mov c, l
	mov b, h
	lhld FOUT0
	shld MIN00
	lxi h, 0
	shld MIN02
	mov l, c
	mov h, b
	dcr d
	jnz fitoa_conv_loop
	xra a
	mov m, a
	
	dcx h
fitoa_remove_zeroes_loop:
	mov a, m
	cpi '0'
	jnz fitoa_remove_zeroes_loop_end
	mov b, h
	mov c, l
	dcx h
	mov a, m
	cpi '.'
	jz fitoa_remove_zeroes_loop_end
	xra a
	stax b
	jmp fitoa_remove_zeroes_loop
fitoa_remove_zeroes_loop_end:
	
	pop h
	pop b
	pop d
	ret
	
itoa16_divs:
	dw 10000,1000,100,10,1
	; Converts 16-bit int in DE to string at buffer pointed to by HL
itoa16:
	push d
	push b
	push h
	mov a, d
	ana a
	jp itoa16_not_neg
	; if DE < 0: DE = ~DE + 1, '-' to buffer
itoa16_neg:
	mov a, e
	cma
	adi 1
	mov e, a
	mov a, d
	cma
	aci 0
	mov d, a
	mvi a, '-'
	mov m, a
	inx h
itoa16_not_neg:
 	; Zero counter and flag
	xra a
	sta GR_TEMP0
	sta GR_TEMP1
itoa16_conv_loop:
	; bc = divs[temp0+temp0]
	push h
	lxi h, itoa16_divs
	lda GR_TEMP0
	add a
	add l
	mov l, a
	mov a, h
	aci 0
	mov h, a
	mov c, m
	mov a, m
	inx h
	mov b, m
	pop h
	; hl to stack, de = de / bc, hl = de % bc
	push h
	call div_16x16
	; Remainder to RAM, hl from stack
	mov a, h
	sta GR_TEMP2
	mov a, l
	sta GR_TEMP3
	pop h
	
	; if flag or e > 0 or on final iteration...
	lda GR_TEMP1
	ana a
	jnz itoa16_add_char
	mov a, e
	ana a
	jnz itoa16_set_flag
	lda GR_TEMP0
	cpi 4
	jz itoa16_add_char
	jmp itoa16_continue
itoa16_set_flag:
	mvi a, 1
	sta GR_TEMP1
itoa16_add_char:
	; '0' + e to buffer
	mvi a, '0'
	add e
	mov m, a
	inx h
itoa16_continue:
	; DE from stack, de = remainder
	lda GR_TEMP3
	mov e, a
	lda GR_TEMP2
	mov d, a
	; while counter++ != 5
	lda GR_TEMP0
	inr a
	sta GR_TEMP0
	cpi 5
	jnz itoa16_conv_loop
	; Zero to buffer
	xra a
	mov m, a
	pop h
	pop b
	pop d
	ret
	
itoa32_divs:
	dw 51712, 15258, 57600, 1525, 38528, 152, 16960, 15, 34464, 1, 10000, 0, 1000, 0, 100, 0, 10, 0, 1, 0
	; Converts 32-bit int in DE (high), BC (low) to string at buffer pointed to by HL
itoa32:
	push d
	push b
	push h
	mov a, d
	ana a
	jp itoa32_not_neg
	; if DE,BC < 0: DE,BC = ~DE,BC + 1, '-' to buffer
itoa32_neg:
	mov a, c
	cma
	adi 1
	mov c, a
	mov a, b
	cma
	aci 0
	mov b, a
	mov a, e
	cma
	aci 0
	mov e, a
	mov a, d
	cma
	aci 0
	mov d, a
	mvi a, '-'
	mov m, a
	inx h
itoa32_not_neg:
 	; Zero counter and flag
	xra a
	sta GR_TEMP0
	sta GR_TEMP1
itoa32_conv_loop:
	; DIN00-DIN03 = DE,BC
	mov a, c
	sta DIN00
	mov a, b
	sta DIN01
	mov a, e
	sta DIN02
	mov a, d
	sta DIN03
	; DIN10-DIN13 = divs[temp0+temp0+temp0+temp0]
	lxi b, itoa32_divs
	lda GR_TEMP0
	push h
	add a
	add a
	add c
	mov c, a
	mvi a, 0
	adc b
	mov b, a
	lxi d, DIN10
	ldax b
	mov h, a
	inx b
	ldax b
	mov l, a
	inx b
	db 0xD9 ; shlx
	inx d
	inx d
	ldax b
	mov h, a
	inx b
	ldax b
	mov l, a
	db 0xD9 ; shlx
	pop h
	; run division, and obtain result
	call div_32x32
	lda DRES0
	mov e, a
	
	; if flag or e > 0 or on final iteration...
	lda GR_TEMP1
	ana a
	jnz itoa32_add_char
	mov a, e
	ana a
	jnz itoa32_set_flag
	lda GR_TEMP0
	cpi 9
	jz itoa32_add_char
	jmp itoa32_continue
itoa32_set_flag:
	mvi a, 1
	sta GR_TEMP1
itoa32_add_char:
	; '0' + e to buffer
	mvi a, '0'
	add e
	mov m, a
	inx h
itoa32_continue:
	; division remainder becomes new DE,BC
	push h
	lxi h, REM0
	mov a, m
	inx h
	mov c, a
	mov a, m
	inx h
	mov b, a
	mov a, m
	inx h
	mov e, a
	mov a, m
	mov d, a
	pop h
	; while counter++ != 5
	lda GR_TEMP0
	inr a
	sta GR_TEMP0
	cpi 10
	jnz itoa32_conv_loop
	; Zero to buffer
	xra a
	mov m, a
	pop h
	pop b
	pop d
	ret

	; Puts random numbers in all registers (hl, bc, de, a)
xorshift:
	; temp = state << 8
	lxi h, GR_TEMP1
	lxi b, XS_STATE0
	mvi d, 7
xs_cpy_l1:
	ldax b
	inx b
	mov m, a
	inx h
	dcr d
	jnz xs_cpy_l1
	; temp <<= 5, for a total left-shift of 13
	mvi d, 5
xs_sh_l1:
	ana a
	mvi e, 7
	lxi h, GR_TEMP1
xs_sh_l2:
	mov a, m
	ral
	mov m, a
	inx h
	dcr e
	jnz xs_sh_l2
	dcr d
	jnz xs_sh_l1
	; state ^= temp
	mvi d, 7
	lxi h, GR_TEMP1
	lxi b, XS_STATE1
xs_xor_l1:
	ldax b
	xra m
	stax b
	inx h
	inx b
	dcr d
	jnz xs_xor_l1
	; temp = state
	mvi d, 8
	lxi h, GR_TEMP0
	lxi b, XS_STATE0
xs_cpy_l2:
	ldax b
	mov m, a
	inx h
	inx b
	dcr d
	jnz xs_cpy_l2
	; temp >>= 7
	mvi d, 7
xs_sh_l3:
	ana a
	mvi e, 8
	lxi h, GR_TEMP7
xs_sh_l4:
	mov a, m
	rar
	mov m, a
	dcx h
	dcr e
	jnz xs_sh_l4
	dcr d
	jnz xs_sh_l3
	; state ^= temp
	mvi d, 8
	lxi h, GR_TEMP0
	lxi b, XS_STATE0
xs_xor_l2:
	ldax b
	xra m
	stax b
	inx h
	inx b
	dcr d
	jnz xs_xor_l2
	; temp = state << 16
	lxi h, GR_TEMP2
	lxi b, XS_STATE0
	mvi d, 6
xs_cpy_l3:
	ldax b
	inx b
	mov m, a
	inx h
	dcr d
	jnz xs_cpy_l3
	; One more left-shift on temp for a total shift of 17
	lxi d, 6
	xra a
	lxi h, GR_TEMP2
xs_sh_l5:
	mov a, m
	ral
	mov m, a
	inx h
	dcr d
	jnz xs_sh_l5
	; state ^= temp
	mvi d, 6
	lxi h, GR_TEMP2
	lxi b, XS_STATE2
xs_xor_l3:
	ldax b
	xra m
	stax b
	inx h
	inx b
	dcr d
	jnz xs_xor_l3
	
	lhld XS_STATE0
	xchg
	lhld XS_STATE3
	mov b, l
	mov c, h
	lhld XS_STATE6
	lda XS_STATE2
	ret

text:
	db 'div/mul tests'
	db 13
	db 10
	db 10
	db 0
text2:
	db 'int to string tests'
	db 13
	db 10
	db 10
	db 0
text3:
	db 'press a key to continue...'
	db 13
	db 10
	db 0
text4:
	db '~~~ 16-bit:'
	db 13
	db 10
	db 0
text5:
	db '~~~ 32-bit:'
	db 13
	db 10
	db 0
text6:
	db 13
	db 10
	db 'Test signed muls'
	db 13
	db 10
	db 0
text7:
	db 13
	db 10
	db 'Test signed divs'
	db 13
	db 10
	db 0
text8:
	db 13
	db 10
	db 'Fixed num tests'
	db 13
	db 10
	db 0
text9:
	db 'sqrt('
	db 0
text10:
	db 13
	db 10
	db 'RNG tests'
	db 13
	db 10
	db 0
	end
