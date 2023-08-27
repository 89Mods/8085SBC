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
XS_STATE0 equ LMEM_START+65

F_WIDTH equ 160
F_WIDTH_BYTES equ (F_WIDTH>>3)
F_HEIGHT equ 50

MEM_START equ 55000

TEMP0 equ MEM_START+0
XPOS equ MEM_START+1
YPOS equ MEM_START+2
BYTE_HERE equ MEM_START+3
BYTE_ABOVE equ MEM_START+4
BYTE_BELOW equ MEM_START+5
CURR_ROW_PTR equ MEM_START+6
TEMP1 equ MEM_START+8
GOL_AND_AMOUNT equ MEM_START+9
ROW_BUFF_START equ MEM_START+10
ROW_BUFF2_START equ ROW_BUFF_START+F_WIDTH_BYTES

F_BUFF_START equ MEM_START+256
F_BUFF_LEN equ (F_WIDTH_BYTES*F_HEIGHT)
F_BUFF_END equ (F_BUFF_START+F_BUFF_LEN)

	org 33024
start:
	jmp actual_start
int_handler:
	nop
	ret
actual_start:
	
	lxi h, enter_seed_text
	call PUTS
	lxi h, XS_STATE0
	mvi d, 4
seed_read_loop:
wait_for_key:
	call SERIAL_READ
	cpi 0
	jz wait_for_key
	mov m, a
	inx h
	inx h
	mvi a, '*'
	call SERIAL_WRITE
	dcr d
	jnz seed_read_loop
	call newl
	
	lxi h, F_BUFF_START
init_loop:
	push h
	call XORSHIFT
	pop h
	mov a, d
	;mvi a, 0b01110101
	mov m, a
	inx h
	mov a, l
	cpi F_BUFF_END&255
	jnz init_loop
	mov a, h
	cpi F_BUFF_END>>8
	jnz init_loop
	
gol_loop:
	call print_field
	call newl
	mvi a, '>'
	call SERIAL_WRITE
	mvi b, F_HEIGHT
gol_spaces_loop:
	mvi a, ' '
	call SERIAL_WRITE
	dcr b
	jnz gol_spaces_loop
	mvi a, '<'
	call SERIAL_WRITE
	mvi a, 13
	call SERIAL_WRITE
	mvi a, '>'
	call SERIAL_WRITE
	
	lxi h, ROW_BUFF_START
	mvi e, F_WIDTH_BYTES+F_WIDTH_BYTES
	xra a
gol_fill_loop:
	mov m, a
	inx h
	dcr e
	jnz gol_fill_loop
	lxi h, F_BUFF_START
	shld CURR_ROW_PTR
	xra a
	sta YPOS
gol_loop_y:
	xra a
	sta XPOS
	
	;mvi a, 13
	;call SERIAL_WRITE
	;mvi a, 10
	;call SERIAL_WRITE
	mvi a, '-'
	call SERIAL_WRITE
	
	lxi h, ROW_BUFF2_START
	lxi b, ROW_BUFF_START
	mvi e, F_WIDTH_BYTES
gol_copy_loop0:
	mov a, m
	stax b
	inx h
	inx b
	dcr e
	jnz gol_copy_loop0
	lhld CURR_ROW_PTR
	lxi b, ROW_BUFF2_START
	mvi e, F_WIDTH_BYTES
gol_copy_loop1:
	mov a, m
	inx h
	stax b
	inx b
	dcr e
	jnz gol_copy_loop1
	
gol_loop_x:
	mvi b, 7
	lda XPOS
	cpi F_WIDTH-1
	jnz gol_no_right_edgex
	mvi b, 3
gol_no_right_edgex:
	mov a, b
	sta GOL_AND_AMOUNT
	
	lda XPOS
	dcr a
	mov e, a
	cpi 255
	jnz gol_no_left_edgex
	xra a
	mov e, a
	call gol_read
	lxi h, BYTE_HERE
	mvi e, 3
gol_edge_fix_loopx:
	mov a, m
	add a
	ani 6
	mov m, a
	inx h
	dcr e
	jnz gol_edge_fix_loopx
	jmp gol_left_edgex
gol_no_left_edgex:
	call gol_read
gol_left_edgex:
	mvi b, 0 ; Neighbor counter
	lda BYTE_HERE
	ani 5 ; Exclude self
	mov c, a
	ani 1
	add b
	mov b, a
	mov a, c
	rrc
	rrc
	ani 1
	add b
	mov b, a
	lda BYTE_ABOVE
	mov c, a
	ani 1
	add b
	mov b, a
	mov a, c
	rrc
	ani 1
	add b
	mov b, a
	mov a, c
	rrc
	rrc
	ani 1
	add b
	mov b, a
	lda BYTE_BELOW
	mov c, a
	ani 1
	add b
	mov b, a
	mov a, c
	rrc
	ani 1
	add b
	mov b, a
	mov a, c
	rrc
	rrc
	ani 1
	add b
	mov b, a
	
	lda BYTE_HERE
	ani 2
	jnz current_cell_alive
current_cell_dead:
	;mvi a, ' '
	;call SERIAL_WRITE
	mov a, b
	cpi 3
	cz flip_cell
	; Cell comes alive
	jmp gol_continue
current_cell_alive:
	;mvi a, '#'
	;call SERIAL_WRITE
	mov a, b
	cpi 2
	jz gol_continue
	cpi 3
	cnz flip_cell
gol_continue:

	;mov a, b
	;adi '0'
	;call SERIAL_WRITE
	;mvi a, ' '
	;call SERIAL_WRITE

	; End gol_loop_x
	lda XPOS
	inr a
	sta XPOS
	cpi F_WIDTH
	jnz gol_loop_x
	
	lhld CURR_ROW_PTR
	lxi b, F_WIDTH_BYTES
	dad b
	shld CURR_ROW_PTR
	; End gol_loop_y
	lda YPOS
	inr a
	sta YPOS
	cpi F_HEIGHT
	jnz gol_loop_y
	
	jmp gol_loop

newl:
	mvi a, 13
	call SERIAL_WRITE
	mvi a, 10
	call SERIAL_WRITE
	ret

	; At the current X and Y position, XOR (flip) the cell
flip_cell:
	lda XPOS
	mov c, a
	rrc
	rrc
	rrc
	ani 0b00011111
	mov e, a
	mvi d, 0
	lhld CURR_ROW_PTR
	dad d
	mov a, c
	mvi e, 1
	ani 7
	mov c, a
	cpi 0
	jz flip_cell_no_shift
	mvi a, 1
	ora a
flip_cell_shift_loop:
	ral
	dcr c
	jnz flip_cell_shift_loop
	mov e, a
flip_cell_no_shift:
	mov a, e
	xra m
	mov m, a
	ret

	; Obtain a 3x3 block of cells from memory at current row and specified X (in e)
gol_read:
	mov a, e
	rrc
	rrc
	rrc
	ani 0b00011111
	mov c, a
	mvi b, 0
	sta TEMP1
	lxi h, ROW_BUFF2_START
	dad b
	mov a, e
	ani 7
	sta TEMP0
	mov e, a ; Now contains shift amount
	mov a, m
	mov c, a
	inx h
	mov a, m
	mov b, a
	call gol_shift
	sta BYTE_HERE
	
	lda YPOS
	cpi F_HEIGHT-1
	jnz byte_below_not_zero
	xra a
	sta BYTE_BELOW
	jmp byte_below_zero
byte_below_not_zero:
	lhld CURR_ROW_PTR
	lxi d, F_WIDTH_BYTES
	dad d
	lda TEMP1
	mov e, a
	mvi d, 0
	dad d
	lda TEMP0
	mov e, a
	mov a, m
	mov c, a
	inx h
	mov a, m
	mov b, a
	call gol_shift
	sta BYTE_BELOW
byte_below_zero:
	
	lxi h, ROW_BUFF_START
	lda TEMP1
	mov e, a
	mvi d, 0
	dad d
	lda TEMP0
	mov e, a
	mov a, m
	mov c, a
	inx h
	mov a, m
	mov b, a
	call gol_shift
	sta BYTE_ABOVE
	
	ret
	
gol_shift:
	mov a, e
	cpi 0
	jz gol_shift_loop_skip
gol_shift_loop:
	mov a, b
	ana a
	rar
	mov b, a
	mov a, c
	rar
	mov c, a
	dcr e
	jnz gol_shift_loop
gol_shift_loop_skip:
	lda GOL_AND_AMOUNT
	ana c
	ret

print_field:
	lxi h, clrscreen
	mov a, m
clear_screen_print_loop:
	call SERIAL_WRITE
	inx h
	mov a, m
	ana a
	jnz clear_screen_print_loop
	
	mvi e, F_HEIGHT
	lxi h, F_BUFF_START
print_field_rows_loop:
	mvi d, F_WIDTH_BYTES
print_field_cols_loop:
	mov a, m
	inx h
	
	mvi c, 8
print_field_byte_loop:
	rar
	mov b, a
	mvi a, ' '
	jnc print_field_no_carry
	mvi a, '#'
print_field_no_carry:
	sta TEMP0
	call SERIAL_WRITE
	lda TEMP0
	;call SERIAL_WRITE
	mov a, b
	
	dcr c
	jnz print_field_byte_loop

	dcr d
	jnz print_field_cols_loop
	
	mvi a, 13
	call SERIAL_WRITE
	mvi a, 10
	call SERIAL_WRITE
	dcr e
	jnz print_field_rows_loop
	ret

clrscreen:
	db 0x1B,0x5B,0x32,0x4A,0x1B,0x5B,0x31,0x3B,0x31,0x48,0x00
enter_seed_text:
	db 'Enter seed for init (4 characters):'
	db 13
	db 10
	db 0
	end
