FUNC_TABLE equ 64
SERIAL_WRITE equ FUNC_TABLE+0
BREAKPOINT equ FUNC_TABLE+3
I2C_BEGIN equ FUNC_TABLE+6
I2C_END equ FUNC_TABLE+9
I2C_TRANSFER equ FUNC_TABLE+12
I2C_RECEIVE equ FUNC_TABLE+15
I2C_ROM_READ_ABS equ FUNC_TABLE+18
I2C_ROM_READ_NEXT equ FUNC_TABLE+21
SPI_TRANSFER equ FUNC_TABLE+24
SPI_RECEIVE equ FUNC_TABLE+27
SPI_ROM_SELECT equ FUNC_TABLE+30
SPI_ROM_DESELECT equ FUNC_TABLE+33
SPI_ROM_READ_BEGIN equ FUNC_TABLE+36
PRINT_HEX equ FUNC_TABLE+39
SERIAL_READ equ FUNC_TABLE+42
PUTS equ FUNC_TABLE+45
MUL_8x8 equ FUNC_TABLE+48
MULE_8x8 equ FUNC_TABLE+51
MUL_16x16 equ FUNC_TABLE+54
DIV_8x8 equ FUNC_TABLE+57
DIV_16x16 equ FUNC_TABLE+60
ITOA16 equ FUNC_TABLE+63
PRINTINT16 equ FUNC_TABLE+66
MULE_16x16 equ FUNC_TABLE+69
MULE_32x32 equ FUNC_TABLE+72
DIV_32x32 equ FUNC_TABLE+75
DIV_48x32 equ FUNC_TABLE+78
ITOA32 equ FUNC_TABLE+81
PRINTINT32 equ FUNC_TABLE+84
MUL_8x8_SIGNED equ FUNC_TABLE+87
MULE_8x8_SIGNED equ FUNC_TABLE+90
MUL_16x16_SIGNED equ FUNC_TABLE+93
MULE_16x16_SIGNED equ FUNC_TABLE+96
MULE_32x32_SIGNED equ FUNC_TABLE+99
DIV_8x8_SIGNED equ FUNC_TABLE+102
DIV_16x16_SIGNED equ FUNC_TABLE+105
DIV_32x32_SIGNED equ FUNC_TABLE+108
DIV_48x32_SIGNED equ FUNC_TABLE+111
MUL_FIXED equ FUNC_TABLE+114
DIV_FIXED equ FUNC_TABLE+117
FITOA equ FUNC_TABLE+120
SQRT_FIXED equ FUNC_TABLE+123
XORSHIFT equ FUNC_TABLE+126

LMEM_START equ 32768

E_OUT_SHADOW equ LMEM_START+0
MIN00 equ LMEM_START+25
MIN01 equ LMEM_START+26
MIN02 equ LMEM_START+27
MIN03 equ LMEM_START+28
MIN10 equ LMEM_START+29
MIN11 equ LMEM_START+30
MIN12 equ LMEM_START+31
MIN13 equ LMEM_START+32
MRES0 equ LMEM_START+33
MRES1 equ LMEM_START+34
MRES2 equ LMEM_START+35
MRES3 equ LMEM_START+36
MRES4 equ LMEM_START+37
MRES5 equ LMEM_START+38
MRES6 equ LMEM_START+39
MRES7 equ LMEM_START+40
DIN00 equ LMEM_START+41
DIN01 equ LMEM_START+42
DIN02 equ LMEM_START+43
DIN03 equ LMEM_START+44
DIN04 equ LMEM_START+45
DIN05 equ LMEM_START+46
DIN10 equ LMEM_START+47
DIN11 equ LMEM_START+48
DIN12 equ LMEM_START+49
DIN13 equ LMEM_START+50
DRES0 equ LMEM_START+51
DRES1 equ LMEM_START+52
DRES2 equ LMEM_START+53
DRES3 equ LMEM_START+54
DRES4 equ LMEM_START+55
DRES5 equ LMEM_START+56
REM0 equ LMEM_START+57
REM1 equ LMEM_START+58
REM2 equ LMEM_START+59
REM3 equ LMEM_START+60
FOUT0 equ LMEM_START+61
FOUT1 equ LMEM_START+62
FOUT2 equ LMEM_START+63
FOUT3 equ LMEM_START+64

MEM_START equ 55000

M_WIDTH equ 238
M_HEIGHT equ 48
W_D2 equ 119
H_D2 equ 24

ZOOM equ 16000000
RE equ 0
IMAG equ 0
MAX_ITERS equ 128

STRBUFF equ MEM_START+1024
C1 equ MEM_START+0
C2 equ MEM_START+4
C3 equ MEM_START+8
C4 equ MEM_START+12
COUNTER equ MEM_START+16
CURR_ROW equ MEM_START+17
CURR_COL equ MEM_START+18
C_IM equ MEM_START+19
C_RE equ MEM_START+23
MAN_X equ MEM_START+27
MAN_Y equ MEM_START+31
MAN_XX equ MEM_START+35
MAN_YY equ MEM_START+39
ITERATION equ MEM_START+43

start	org 33024
	nop
mandel_calc_constants_c1:
	; res = 4 / width
	xra a
	lxi h, DIN00
	mov m, a
	inx h
	mov m, a
	inx h
	inx h
	mov m, a
	dcx h
	mvi a, 4
	mov m, a
	lxi h, DIN10
	xra a
	mov m, a
	inx h
	mov m, a
	inx h
	inx h
	mov m, a
	dcx h
	mvi a, M_WIDTH
	mov m, a
	call DIV_FIXED
	; C1 = res * ZOOM
	xra a
	lxi h, MIN00
	mov m, a
	inx h
	lda FOUT0
	mov m, a
	inx h
	lda FOUT1
	mov m, a
	inx h
	lda FOUT2
	mov m, a
	inx h
	mvi a, ZOOM&255
	mov m, a
	inx h
	mvi a, (ZOOM>>8)&255
	mov m, a
	inx h
	mvi a, (ZOOM>>16)&255
	mov m, a
	inx h
	mvi a, (ZOOM>>24)&255
	mov m, a
	call mul_fixed_8_24
	lhld FOUT0
	shld C1+0
	shld MIN10
	lhld FOUT2
	shld C1+2
	shld MIN12
	; C2 = W_D2 * C1
	xra a
	lxi h, MIN00
	mov m, a
	inx h
	mov m, a
	inx h
	mov m, a
	inx h
	mvi a, W_D2
	mov m, a
	call mul_fixed_8_24
	lhld FOUT0
	shld C2+0
	lhld FOUT2
	shld C2+2
mandel_calc_constants_c4:
	; res = 2 / height
	xra a
	lxi h, DIN00
	mov m, a
	inx h
	mov m, a
	inx h
	inx h
	mov m, a
	dcx h
	mvi a, 2
	mov m, a
	lxi h, DIN10
	xra a
	mov m, a
	inx h
	mov m, a
	inx h
	inx h
	mov m, a
	dcx h
	mvi a, M_HEIGHT
	mov m, a
	call DIV_FIXED
	; C3 = res * ZOOM
	xra a
	lxi h, MIN00
	mov m, a
	inx h
	lda FOUT0
	mov m, a
	inx h
	lda FOUT1
	mov m, a
	inx h
	lda FOUT2
	mov m, a
	inx h
	mvi a, ZOOM&255
	mov m, a
	inx h
	mvi a, (ZOOM>>8)&255
	mov m, a
	inx h
	mvi a, (ZOOM>>16)&255
	mov m, a
	inx h
	mvi a, (ZOOM>>24)&255
	mov m, a
	call mul_fixed_8_24
	lhld FOUT0
	shld C3+0
	shld MIN10
	lhld FOUT2
	shld C3+2
	shld MIN12
	; C4 = H_D2 * C3
	xra a
	lxi h, MIN00
	mov m, a
	inx h
	mov m, a
	inx h
	mov m, a
	inx h
	mvi a, H_D2
	mov m, a
	call mul_fixed_8_24
	lhld FOUT0
	shld C4+0
	lhld FOUT2
	shld C4+2
	
	xra a
	lxi h, C1
cs_print_loop:
	sta COUNTER

	inx h
	mov a, m
	mov c, a
	inx h
	mov a, m
	mov b, a
	inx h
	mov a, m
	inx h
	mov e, a
	mvi d, 0
	mvi a, 'C'
	call SERIAL_WRITE
	lda COUNTER
	adi '1'
	call SERIAL_WRITE
	mvi a, ':'
	call SERIAL_WRITE
	mvi a, ' '
	call SERIAL_WRITE
	push h
	lxi h, STRBUFF
	call FITOA
	call PUTS
	call newl
	pop h
	
	lda COUNTER
	inr a
	cpi 4
	jnz cs_print_loop
	call newl
	
	mvi a, M_HEIGHT-1
mandel_loop_rows:
	sta CURR_ROW
	; res = row * C3
	sta MIN13
	lhld C3+0
	shld MIN00
	lhld C3+2
	shld MIN02
	xra a
	lxi h, MIN10
	mov m, a
	inx h
	mov m, a
	inx h
	mov m, a
	call mul_fixed_8_24_unsigned
	; C_IM = res + IMAG
	lxi h, FOUT0
	lxi b, C_IM
	mov a, m
	adi IMAG&255
	stax b
	inx h
	inx b
	mov a, m
	aci (IMAG>>8)&255
	stax b
	inx h
	inx b
	mov a, m
	aci (IMAG>>16)&255
	stax b
	inx h
	inx b
	mov a, m
	aci (IMAG>>24)&255
	stax b
	; C_IM = C_IM - C4
	lxi b, C_IM
	lxi h, C4
	ana a
	mvi e, 4
sub_loop_0:
	ldax b
	sbb m
	stax b
	inx b
	inx h
	dcr e
	jnz sub_loop_0
	
	; LED blinkenlights
	lda CURR_ROW
	rlc
	rlc
	rlc
	rlc
	rlc
	rlc
	ani 0b00111111
	mov c, a
	lda E_OUT_SHADOW
	ani 0b00111111
	ora c
	sta E_OUT_SHADOW
	sta 65535
	xra a
mandel_loop_cols:
	sta CURR_COL
	; res = col * C1
	sta MIN13
	lhld C1+0
	shld MIN00
	lhld C1+2
	shld MIN02
	xra a
	lxi h, MIN10
	mov m, a
	inx h
	mov m, a
	inx h
	mov m, a
	call mul_fixed_8_24_unsigned
	; C_RE = res + RE
	lxi h, FOUT0
	lxi b, C_RE
	mov a, m
	adi RE&255
	stax b
	inx h
	inx b
	mov a, m
	aci (RE>>8)&255
	stax b
	inx h
	inx b
	mov a, m
	aci (RE>>16)&255
	stax b
	inx h
	inx b
	mov a, m
	aci (RE>>24)&255
	stax b
	; C_RE = C_RE - C2
	lxi b, C_RE
	lxi h, C2
	ana a
	mvi e, 4
sub_loop_1:
	ldax b
	sbb m
	stax b
	inx b
	inx h
	dcr e
	jnz sub_loop_1
	
	; X = C_RE, Y = C_IM
	lhld C_RE+0
	shld MAN_X+0
	lhld C_RE+2
	shld MAN_X+2
	lhld C_IM+0
	shld MAN_Y+0
	lhld C_IM+2
	shld MAN_Y+2
	
	; iteration = 0
	lxi h, 0
	shld ITERATION
mandel_calc_loop:
	; YY = Y * Y
	lhld MAN_Y+0
	shld MIN00
	shld MIN10
	lhld MAN_Y+2
	shld MIN02
	shld MIN12
	call mul_fixed_8_24
	lhld FOUT0
	shld MAN_YY+0
	lhld FOUT2
	shld MAN_YY+2
	
	; res = X * Y
	lhld MAN_X+0
	shld MIN00
	lhld MAN_X+2
	shld MIN02
	lhld MAN_Y+0
	shld MIN10
	lhld MAN_Y+2
	shld MIN12
	call mul_fixed_8_24
	
	; regs = res << 1
	lxi h, FOUT0
	ana a
	mov a, m
	ral
	mov e, a
	inx h
	mov a, m
	ral
	mov d, a
	inx h
	mov a, m
	ral
	inx h
	mov c, a
	mov a, m
	ral
	mov b, a
	
	; Y = regs + C_IM
	lxi h, C_IM
	mov a, m
	add e
	sta MAN_Y
	inx h
	mov a, m
	adc d
	inx h
	sta MAN_Y+1
	mov a, m
	inx h
	adc c
	sta MAN_Y+2
	mov a, m
	adc b
	sta MAN_Y+3
	
	; XX = res = X * X
	lhld MAN_X+0
	shld MIN00
	shld MIN10
	lhld MAN_X+2
	shld MIN02
	shld MIN12
	call mul_fixed_8_24
	lhld FOUT0
	xchg
	shld MAN_XX+0
	lhld FOUT2
	mov c, l
	mov b, h
	shld MAN_XX+2
	
	; regs = regs - YY
	lxi h, MAN_YY
	mov a, e
	sub m
	inx h
	mov e, a
	mov a, d
	sbb m
	inx h
	mov d, a
	mov a, c
	sbb m
	inx h
	mov c, a
	mov a, b
	sbb m
	mov b, a
	
	; X = regs + C_RE
	lxi h, C_RE
	mov a, m
	inx h
	add e
	mov e, a
	mov a, m
	inx h
	adc d
	mov d, a
	mov a, m
	inx h
	adc c
	mov c, a
	mov a, m
	adc b
	mov b, a
	xchg
	shld MAN_X+0
	mov l, c
	mov h, b
	shld MAN_X+2
	
	; check if xx + yy <= 4
	lxi h, MAN_XX
	lxi b, MAN_YY
	mvi d, 4
	ora a
add_loop_0:
	ldax b
	inx b
	adc m
	inx h
	dcr d
	jnz add_loop_0
	cpi 4
	jp mandel_calc_loop_overflow
	
	; iteration++
	lhld ITERATION
	inx h
	shld ITERATION
	mov a, h
	cpi MAX_ITERS>>8
	jnz mandel_calc_loop
	mov a, l
	cpi MAX_ITERS&255
	jnz mandel_calc_loop
mandel_calc_loop_max_iters:
	mvi a, ' '
	call SERIAL_WRITE
	jmp mandel_calc_loop_exit
mandel_calc_loop_overflow:
	lda ITERATION
	ani 7
	add a
	add a
	add a
	adi mandel_colors&255
	mov l, a
	mvi a, 0
	aci mandel_colors>>8
	mov h, a
print_loop1:
	inx h
	mov a, m
	cpi 33
	jz print_loop1_exit
	call SERIAL_WRITE
	jmp print_loop1
print_loop1_exit:
	mvi a, '#'
	call SERIAL_WRITE
	;mvi a, 0xE2
	;call SERIAL_WRITE
	;mvi a, 0x96
	;call SERIAL_WRITE
	;mvi a, 0x88
	;call SERIAL_WRITE
mandel_calc_loop_exit:
	lda CURR_COL
	inr a
	cpi M_WIDTH
	jnz mandel_loop_cols
	call newl
	
	lda CURR_ROW
	dcr a
	cpi 255
	jnz mandel_loop_rows
mandel_finished:
	lda E_OUT_SHADOW
	ani 0b00111111
	sta E_OUT_SHADOW
	sta 65535
	
	lxi h, mandel_color_reset
print_loop2:
	mov a, m
	inx h
	cpi 0
	jz print_loop2_exit
	call SERIAL_WRITE
	jmp print_loop2
print_loop2_exit:
	
halt:
	nop
	hlt
	nop
	jmp halt

newl:
	mvi a, 13
	call SERIAL_WRITE
	mvi a, 10
	call SERIAL_WRITE
	ret

mul_fixed_8_24:
	call MULE_32x32_SIGNED
	push h
	lhld MRES3
	shld FOUT0
	lhld MRES5
	shld FOUT2
	pop h
	ret

mul_fixed_8_24_unsigned:
	call MULE_32x32
	push h
	lhld MRES3
	shld FOUT0
	lhld MRES5
	shld FOUT2
	pop h
	ret

c1_text:
	db 'C1: '
	db 0
c2_text:
	db 'C2: '
	db 0
c3_text:
	db 'C3: '
	db 0
c4_test:
	db 'C4: '
	db 0
mandel_colors:
	db 33,27,91,51,49,109,0,33
	db 33,27,91,51,49,109,0,33
	db 33,27,91,51,50,109,0,33
	db 33,27,91,51,51,109,0,33
	db 33,27,91,51,52,109,0,33
	db 33,27,91,51,53,109,0,33
	db 33,27,91,51,54,109,0,33
	db 33,27,91,51,55,109,0,33
mandel_color_reset:
	db 27,91,48,109
	db 'Done.'
	db 0x0D
	db 0x0A
	db 0
	end
