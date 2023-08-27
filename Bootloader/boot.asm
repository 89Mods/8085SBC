IO_CS equ 0
PORTA equ 1
PORTB equ 2
PORTC equ 3
TCOUNT_LOW equ 4
TCOUNT_HI equ 5

; PORTB is UART data
; 573 bit 5 is UART CS
; PC3 is WE
; PC2 is RE
; PC1 is C/D
; PC0 is RES

; PORTA desc:
; 0: SPI DI (device’s DO)
; 1: I²C SDA
; 2 - 7: User inputs

SPI_DI equ 1
I2C_SDA_I equ 2

; PORTB desc:
; 0 - 7: Slowbus data

; PORTC desc:
; 0: Slowbus RES
; 1: Slowbus C/D
; 2: Slowbus RE
; 3: Slowbus WE
; 4: Slowbus CS0 (J5)
; 5: Timer int enable

SL_RES equ 1
SL_CD equ 2
SL_RE equ 4
SL_WE equ 8
SL_CS0 equ 16

; 573 "extra outputs" desc:
; 0: SPI CS
; 1: SPI CLK
; 2: SPI DO (device’s DI)
; 3: I²C SCL
; 4: I²C SDA
; 5: Slowbus CS1 (J7)
; 6 - 7: User outputs / LEDs

SPI_CS equ 1
SPI_CLK equ 2
SPI_DO equ 4
I2C_SCL equ 8
I2C_SDA_O equ 16
SL_CS1 equ 32

MEM_START equ 32768
HI_MEM_START equ 33024
E_OUT_SHADOW equ 0
CS_SHADOW equ 1
PC_SHADOW equ 2
COUNTER equ 3
BREAKPOINT equ 4
ROM_SEL equ 5

MD_TEMP0 equ MEM_START+6
MD_TEMP1 equ MEM_START+7
MD_TEMP2 equ MEM_START+8
MD_TEMP3 equ MEM_START+9
MD_TEMP4 equ MEM_START+10
MD_TEMP5 equ MEM_START+11
MD_TEMP6 equ MEM_START+12
MD_TEMP7 equ MEM_START+13
MD_TEMP8 equ MEM_START+14
MD_TEMP9 equ MEM_START+15
MD_TEMP10 equ MEM_START+16
GR_TEMP0 equ MEM_START+17
GR_TEMP1 equ MEM_START+18
GR_TEMP2 equ MEM_START+19
GR_TEMP3 equ MEM_START+20
GR_TEMP4 equ MEM_START+21
GR_TEMP5 equ MEM_START+22
GR_TEMP6 equ MEM_START+23
GR_TEMP7 equ MEM_START+24
MIN00 equ MEM_START+25
MIN01 equ MEM_START+26
MIN02 equ MEM_START+27
MIN03 equ MEM_START+28
MIN10 equ MEM_START+29
MIN11 equ MEM_START+30
MIN12 equ MEM_START+31
MIN13 equ MEM_START+32
MRES0 equ MEM_START+33
MRES1 equ MEM_START+34
MRES2 equ MEM_START+35
MRES3 equ MEM_START+36
MRES4 equ MEM_START+37
MRES5 equ MEM_START+38
MRES6 equ MEM_START+39
MRES7 equ MEM_START+40
DIN00 equ MEM_START+41
DIN01 equ MEM_START+42
DIN02 equ MEM_START+43
DIN03 equ MEM_START+44
DIN04 equ MEM_START+45
DIN05 equ MEM_START+46
DIN10 equ MEM_START+47
DIN11 equ MEM_START+48
DIN12 equ MEM_START+49
DIN13 equ MEM_START+50
DRES0 equ MEM_START+51
DRES1 equ MEM_START+52
DRES2 equ MEM_START+53
DRES3 equ MEM_START+54
DRES4 equ MEM_START+55
DRES5 equ MEM_START+56
REM0 equ MEM_START+57
REM1 equ MEM_START+58
REM2 equ MEM_START+59
REM3 equ MEM_START+60
FOUT0 equ MEM_START+61
FOUT1 equ MEM_START+62
FOUT2 equ MEM_START+63
FOUT3 equ MEM_START+64
XS_STATE0 equ MEM_START+65
XS_STATE1 equ MEM_START+66
XS_STATE2 equ MEM_START+67
XS_STATE3 equ MEM_START+68
XS_STATE4 equ MEM_START+69
XS_STATE5 equ MEM_START+70
XS_STATE6 equ MEM_START+71
XS_STATE7 equ MEM_START+72
STRBUFF equ MEM_START+73 ; Length 16

start	org 0
	di
	mvi l, 255
	mvi h, 128
	sphl
	jmp main

trap_int org 36
	jmp trap_handler
unused_int0 org 44
	ei
	ret
unused_int1 org 52
	ei
	ret
timer_int org 60
	jmp timer_int_handler
function_table: org 64
	jmp write_8251 ;0
	jmp breakpoint ;3
	jmp i2c_begin ;6
	jmp i2c_end ;9
	jmp i2c_transfer ;12
	jmp i2c_receive ;15
	jmp i2c_rom_read_absolute ;18
	jmp i2c_rom_read_next ;21
	jmp spi_transfer ;24
	jmp spi_receive ;27
	jmp spi_rom_select ;30
	jmp spi_rom_deselect ;33
	jmp spi_rom_read_begin ;36
	jmp print_hex ;39
	jmp read_8251 ;42
	jmp print_str ;45
	jmp mul_8x8 ; 48
	jmp mule_8x8 ; 51
	jmp mul_16x16 ; 54
	jmp div_8x8 ; 57
	jmp div_16x16 ; 60
	jmp itoa16 ; 63
	jmp printint16 ; 66
	jmp mule_16x16 ; 69
	jmp mule_32x32 ; 72
	jmp div_32x32 ; 75
	jmp div_48x32 ; 78
	jmp itoa32 ; 81
	jmp printint32 ; 84
	jmp mul_8x8_signed ; 87
	jmp mule_8x8_signed ; 90
	jmp mul_16x16_signed ; 93
	jmp mule_16x16_signed ; 96
	jmp mule_32x32_signed ; 99
	jmp div_8x8_signed ; 102
	jmp div_16x16_signed ; 105
	jmp div_32x32_signed ; 108
	jmp div_48x32_signed ; 111
	jmp mul_fixed ; 114
	jmp div_fixed ; 117
	jmp fitoa ; 120
	jmp sqrt_fixed ; 123
	jmp xorshift ; 126
	org 196
main:
	; Interrupt config - Disable all.
	mvi a, 11011111b
	sim
	ei
	
	; Init XORSHIFT seed
	lxi h, XS_STATE0
	mvi a, 0x08
	mov m, a
	inx h
	mvi a, 0xAC
	mov m, a
	inx h
	mvi a, 0x38
	mov m, a
	inx h
	mvi a, 0x21
	mov m, a
	inx h
	mvi a, 0x0A
	mov m, a
	inx h
	mvi a, 0xC0
	mov m, a
	inx h
	mvi a, 0xCF
	mov m, a
	inx h
	mvi a, 0x21
	mov m, a
	
	lxi h, MEM_START+ROM_SEL
	mvi a, 0
	mov m, a
	; PORTA = input
	; PORTB = output
	; PORTC = ALT2 (outputs)
	; No interrupts (not wired up anyways)
	; Stop timer
	mvi h, 128
	mvi l, CS_SHADOW
	mvi a, 01001110b
	out IO_CS
	mov m, a

	; Clear PORTB
	mvi a, 0
	out PORTB

	; 573 - SPI Idle, I²C Idle, de-select second slowbus device
	mvi h, 255
	mov l, h
	mvi a, 00111001b
	mov m, a
	lxi h, MEM_START+E_OUT_SHADOW
	mov m, a
	; Start timer, clear COUNTER value
	mvi a, 255
	out TCOUNT_LOW
	mvi a, 11000111b
	out TCOUNT_HI
	lxi h, MEM_START+CS_SHADOW
	mov a, m
	ori 11000000b
	mov m, a
	out IO_CS
	lxi h, MEM_START+COUNTER
	mvi a, 0
	mov m, a

	; PORTC: Select no slowbus devices, enable timer int signal, reset slowbus
	mvi a, 00111101b
	out PORTC
	mvi l, PC_SHADOW
	mov m, a

	call init_8251
	lxi h, init_text
	call print_str

	lxi h, scan_i2c_text
	call print_str
	call delay
	call delay
	call delay
	call delay
	lxi d, 0
	call i2c_rom_read_absolute
	jc no_i2c_rom
	lxi h, supported_rom_text
	call print_str
	call check_i2c_bootrecord
	cpi 255
	jz i2c_do_boot
	lxi h, inv_bootrecord_text
	call print_str
	jmp boot_continue_no_i2c
no_i2c_rom:
	lxi h, no_dev_text
	call print_str

boot_continue_no_i2c:
	lxi h, scan_spi_text
	call print_str
	call delay
	call delay
	call delay
	call delay
	call spi_rom_get_id
	mov b, a
	cpi 255
	jz no_spi_rom
	lxi h, acceptable_spi_rom_ids
check_rom_id_loop:
	mov a, m
	inx h
	cpi 0
	jz invalid_rom_id
	cmp b
	jnz check_rom_id_loop
	lxi h, supported_rom_text
	call print_str
	call check_spi_bootrecord
	cpi 255
	jz spi_do_boot
	lxi h, inv_bootrecord_text
	call print_str
	jmp boot_continue_no_spi
no_spi_rom:
	lxi h, no_dev_text
	call print_str
	jmp boot_continue_no_spi
invalid_rom_id:
	lxi h, invalid_dev_text
	call print_str
boot_continue_no_spi:
	lxi h, no_boot_dev_text
	call print_str

halt:
	hlt
	call delay
	jmp halt

timer_int_handler:
	push psw
	call HI_MEM_START+3
	mvi a, 16
	sim
	pop psw
	ei
	ret

trap_handler:
	push h
	push psw
	lxi h, MEM_START+BREAKPOINT
	mov a, m
	xri 1
	mov m, a
	pop psw
	pop h
	ei
	ret

print_str:
	mov a, m
	cpi 0
	jm print_exit
	jz print_exit
	inx h
	call write_8251
	jmp print_str
print_exit:
	ret

print_hex:
	push d
	push h
	push psw
	mov d, a

	rrc
	rrc
	rrc
	rrc
	ani 15
	adi low(hex_chars)
	mov l, a
	xra a
	aci high(hex_chars)
	mov h, a
	mov a, m
	call write_8251

	mov a, d
	ani 15
	adi low(hex_chars)
	mov l, a
	xra a
	aci high(hex_chars)
	mov h, a
	mov a, m
	call write_8251

	mov a, d
	pop psw
	pop h
	pop d
	ret

delay:
	push h
	mov h, a
	push h
	mvi a, 0
delay_loop:
	adi 1
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	jnc delay_loop
	pop h
	mov a, h
	pop h
	ret

breakpoint:
	push psw
	push h
	push b
	lxi h, MEM_START+BREAKPOINT
	mov b, m
	mvi a, 11000000b
	sim
breakpoint_loop:
	mov a, m
	cmp b
	jz breakpoint_loop

	mvi a, 01000000b
	sim
	call delay
	call delay
	call delay
	call delay

	pop b
	pop h
	pop psw
	ret

check_i2c_bootrecord:
	push h
	lxi h, magic_header
	mov a, m
	mov c, a
	lxi d, 0
	call i2c_rom_read_absolute
	jc check_i2c_bootrecord_fail
	cmp c
	jnz check_i2c_bootrecord_fail
check_i2c_bootrecord_loop:
	inx h
	mov a, m
	mov c, a
	call i2c_rom_read_next
	jc check_i2c_bootrecord_fail
	cmp c
	jnz check_i2c_bootrecord_fail
	cpi 0
	jnz check_i2c_bootrecord_loop
	call i2c_rom_read_next
	jc check_i2c_bootrecord_fail
	mov d, a
	call i2c_rom_read_next
	jc check_i2c_bootrecord_fail
	mov e, a

	ora d
	jz check_i2c_bootrecord_fail

check_i2c_bootrecord_success:
	mvi a, 255
	pop h
	ret
check_i2c_bootrecord_fail:
	mvi a, 0
	pop h
	ret

check_spi_bootrecord:
	push h
	lxi h, magic_header
	lxi d, 0
	mvi c, 0
	call spi_rom_read_begin
check_spi_bootrecord_loop:
	mov a, m
	mov c, a
	call spi_receive
	cmp c
	jnz check_spi_bootrecord_fail
	inx h
	cpi 0
	jnz check_spi_bootrecord_loop
	call spi_receive
	mov d, a
	call spi_receive
	mov e, a

	ora d
	jz check_spi_bootrecord_fail

check_spi_bootrecord_success:
	call spi_rom_deselect
	mvi a, 255
	pop h
	ret
check_spi_bootrecord_fail:
	call spi_rom_deselect
	mvi a, 0
	pop h
	ret

print_boot_info:
	push d
	lxi h, valid_bootrecord_text
	call print_str
	lxi h, size_text
	call print_str
	mov a, d
	call print_hex
	mov a, e
	call print_hex
	mvi a, 'h'
	call write_8251
	mvi a, 13
	call write_8251
	mvi a, 10
	call write_8251
	mvi a, 13
	call write_8251
	mvi a, 10
	call write_8251

	pop d
	ret

i2c_do_boot:
	call print_boot_info
	lxi h, HI_MEM_START
i2c_copy_binary_loop:
	call i2c_rom_read_next
	mov m, a
	inx h
	dcx d
	mov a, d
	ora e
	jnz i2c_copy_binary_loop

	jmp HI_MEM_START

spi_do_boot:
	call print_boot_info
	push d
	mvi c, 0
	lxi d, 8
	call spi_rom_read_begin
	lxi h, HI_MEM_START
	pop d
spi_copy_binary_loop:
	call spi_receive
	mov m, a
	inx h
	dcx d
	mov a, d
	ora e
	jnz spi_copy_binary_loop

	jmp HI_MEM_START

spi_transfer:
	push d
	push h
	push b

	mov e, a

	lxi h, MEM_START+E_OUT_SHADOW
	mov a, m
	ani 255-SPI_CLK-SPI_DO
	mov m, a
	mvi h, 255
	mov l, h
	mov m, a
	mov d, a
	mvi b, 8
spi_transfer_loop:
	mov a, e
	ani 128
	mov a, d
	jz spi_transfer_zero
spi_transfer_one:
	ori SPI_DO
spi_transfer_zero:
	mov m, a
	ori SPI_CLK
	mov m, a
	ani 255-SPI_CLK
	mov m, a

	mov a, e
	rlc
	mov e, a

	dcr b
	jnz spi_transfer_loop

	mov a, d
	mov m, a

	xra a

	pop b
	pop h
	pop d
	ret

spi_receive:
	push d
	push h
	push b

	mvi e, 0

	lxi h, MEM_START+E_OUT_SHADOW
	mov a, m
	ani 255-SPI_CLK-SPI_DO
	mov m, a
	mvi h, 255
	mov l, h
	mov m, a
	mov d, a

	mvi b, 8
	mov a, d
spi_receive_loop:
	ori SPI_CLK
	mov m, a
	mov a, e
	add a
	mov e, a
	in PORTA
	ani 1
	add e
	mov e, a
	mov a, d
	mov m, a

	dcr b
	jnz spi_receive_loop

	mov a, d
	mov m, a

	mov a, e

	pop b
	pop h
	pop d
	ret

	; Should be enough for standard speed I²C with the 8085 at 6MHz
i2c_delay:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ret

i2c_begin:
	push h
	push d

	; Ensure PORTA are inputs
	lxi h, MEM_START+CS_SHADOW
	mov a, m
	ani 254
	out IO_CS
	mov m, a

	mvi l, E_OUT_SHADOW
	mov a, m
	ani 255-I2C_SDA_O
	mvi h, 255
	mov l, h
	mov m, a
	call i2c_delay
	ani 255-I2C_SCL
	mov m, a
	call i2c_delay

	pop d
	pop h
	ret

i2c_end:
	push h

	lxi h, MEM_START+E_OUT_SHADOW
	mov a, m
	ani 255-I2C_SDA_O
	mvi h, 255
	mov l, h
	call i2c_delay
	ori I2C_SCL
	mov m, a
	call i2c_delay
	ori I2C_SDA_O
	mov m, a
	lxi h, MEM_START+E_OUT_SHADOW
	mov m, a
	call i2c_delay

	pop h
	ret

i2c_restart:
	push h

	lxi h, MEM_START+E_OUT_SHADOW
	mov a, m
	ori I2C_SDA_O
	mvi h, 255
	mov l, h
	mov m, a
	call i2c_delay
	ori I2C_SCL
	mov m, a
	call i2c_delay
	ani 255-I2C_SDA_O
	mov m, a
	call i2c_delay

	ani 255-I2C_SCL
	mov m, a
	lxi h, MEM_START+E_OUT_SHADOW
	mov m, a
	call i2c_delay

	pop h
	ret

	; Transfers the value in A. State of ACK/NACK is returned in A. (0 = ACK, 1 = NACK)
i2c_transfer:
	push h
	push d
	push b

	mov e, a

	lxi h, MEM_START+E_OUT_SHADOW
	mov a, m
	ani 255-I2C_SDA_O-I2C_SCL
	mov d, a
	mov m, a
	mvi h, 255
	mov l, h
	mov m, a
	call i2c_delay

	mvi b, 8
i2c_transfer_loop:
	mov a, e
	ani 128
	mov a, d
	jz i2c_transfer_zero
i2c_transfer_one:
	ori I2C_SDA_O
i2c_transfer_zero:
	mov m, a
	call i2c_delay
	ori I2C_SCL
i2c_transfer_end:
	mov m, a
	call i2c_delay
	mov a, d
	mov m, a
	call i2c_delay

	mov a, e
	rlc
	mov e, a

	dcr b
	jnz i2c_transfer_loop

	; Check acknowledge
	mov a, d
	ori I2C_SDA_O
	mov m, a
	call i2c_delay
	ori I2C_SCL
	mov m, a
	call i2c_delay
	in PORTA
	; Fancy way of transfering received bit into carry, and then rotating it into A
	ani I2C_SDA_I
	adi 255
	ral
	ani 1
	mov e, a

	mov a, d
	mov m, a
	lxi h, MEM_START+E_OUT_SHADOW
	mov m, a
	call i2c_delay

	mov a, e
	pop b
	pop d
	pop h
	ret

	; Receives a byte from I²C. The value in A decides wether to send a ACK or NACK (0 = ACK, 1 = NACK)
i2c_receive:
	push h
	push d
	push b

	mov b, a

	lxi h, MEM_START+E_OUT_SHADOW
	mov a, m
	ani 255-I2C_SCL
	ori I2C_SDA_O
	mov d, a
	mov m, a
	mvi h, 255
	mov l, h
	mov m, a

	mvi c, 8
	mvi e, 0
i2c_receive_loop:
	mov a, d
	call i2c_delay
	ori I2C_SDA_O+I2C_SCL
	mov m, a
	call i2c_delay
	; Get the received bit into the carry
	in PORTA
	ani I2C_SDA_I
	adi 255
	; Shift carry into E
	mov a, e
	ral
	mov e, a

	mov m, d

	dcr c
	jnz i2c_receive_loop

	; Send ACK/NACK
	mov a, d
	ani 255-I2C_SDA_O
	mov d, a
	
	mov a, b
	cpi 0
	mov a, d
	jz i2c_receive_ack
i2c_receive_nack:
	ori I2C_SDA_O
i2c_receive_ack:
	mov m, a
	call i2c_delay
	ori I2C_SCL
	mov m, a
	call i2c_delay
	ani 255-I2C_SCL
	mov m, a
	call i2c_delay
	ani 255-I2C_SDA_O
	mov m, a
	lxi h, MEM_START+E_OUT_SHADOW
	mov m, a
	call i2c_delay

	mov a, e

	pop b
	pop d
	pop h
	ret

sl_delay:
	nop
	nop
	nop
	nop
	nop
	ret

	; Writes contents of A to SL device 1. C/D must be set beforehand
sl_write:
	push h
	push d
	push b

	mov c, a

	; Make PORTB outputs
	lxi h, MEM_START+CS_SHADOW
	mov a, m
	ori 2
	out IO_CS

	; Set value to be written
	mov a, c
	out PORTB

	mvi l, PC_SHADOW
	mov e, m ; PORTC shadow in E

	; Select
	mvi l, E_OUT_SHADOW
	mov a, m
	mov d, a ; Back-up 573 shadow in D
	ani 255-SL_CS1
	lxi h, 65535
	mov m, a

	; Write
	mov a, e
	ani 255-SL_WE
	out PORTC
	call sl_delay

	; De-select
	ori SL_WE
	out PORTC
	mov a, d
	ori SL_CS1
	mov m, a
	lxi h, MEM_START+E_OUT_SHADOW
	mov m, a
	call sl_delay

	; Restore IO config
	lxi h, MEM_START+CS_SHADOW
	mov a, m
	out IO_CS

	pop b
	pop d
	pop h
	ret

	; Reads from SL device 1 int A. C/D must be set beforehand
sl_read:
	push h
	push d
	push b

	; Make PORTB inputs
	lxi h, MEM_START+CS_SHADOW
	mov a, m
	ani 255-2
	mov m, a ; Persist PORTB inputs (intended default state)
	out IO_CS

	mvi l, PC_SHADOW
	mov e, m ; PORTC shadow in E

	; Select
	mvi l, E_OUT_SHADOW
	mov a, m
	mov d, a ; Back-up 573 shadow in D
	ani 255-SL_CS1
	lxi h, 65534
	mov m, a

	; Read
	mov a, e
	ani 255-SL_RE
	out PORTC
	call sl_delay

	in PORTB
	mov b, a
	mvi h, 255

	; De-select
	mov a, d
	ori SL_CS1
	mov m, a

	; TEMP
	lxi h, E_OUT_SHADOW
	mov m, a

	mov a, e
	ori SL_RE
	out PORTC

	; TEMP
	mvi l, PC_SHADOW
	mov m, a

	call sl_delay

	mov a, b

	pop b
	pop d
	pop h
	ret

	; DEVICE-SPECIFIC DRIVERS HERE

i2c_rom_read_next:
	push h
	push d

	call i2c_begin
	mvi a, 10100001b
	call i2c_transfer
	ani 255
	jnz i2c_rom_read_abort

	mvi a, 1
	call i2c_receive
	mov h, a
	call i2c_end
	mov a, h

	stc
	cmc
	pop d
	pop h
	ret

	; Reads a single byte from connected SPI ROM. Address in DE. Returns byte in A, success status in carry (0 = success, 1 = failure)
i2c_rom_read_absolute:
	push h
	push d

	call i2c_begin
	mvi a, 10100000b
	call i2c_transfer
	ani 255
	jnz i2c_rom_read_abort

	mov a, d
	ani 15
	call i2c_transfer
	ani 255
	jnz i2c_rom_read_abort

	mov a, e
	call i2c_transfer
	ani 255
	jnz i2c_rom_read_abort

	call i2c_end
	call i2c_begin
	;call i2c_restart
	mvi a, 10100001b
	call i2c_transfer
	ani 255
	jnz i2c_rom_read_abort

	mvi a, 1
	call i2c_receive
	mov h, a
	call i2c_end
	mov a, h

	stc
	cmc
	pop d
	pop h
	ret
i2c_rom_read_abort:
	call i2c_end
	mvi a, 0
	pop d
	pop h
	stc
	ret

spi_rom_get_id:
	push h
	push d

	lxi h, MEM_START+E_OUT_SHADOW
	mov a, m
	ani 255-SPI_CS-SPI_DO-SPI_CLK
	mov m, a
	mvi h, 255
	mov l, h
	mov m, a

	mvi a, 90h
	call spi_transfer
	call spi_receive
	call spi_receive
	call spi_receive

	call spi_receive
	mov d, a

	lxi h, MEM_START+E_OUT_SHADOW
	mov a, m
	ori SPI_CS
	mov m, a
	mvi l, 255
	mov h, l
	mov m, a

	mov a, d

	pop d
	pop h
	ret

	; Address in DE and C
spi_rom_read_begin:
	push h

	lxi h, MEM_START+E_OUT_SHADOW
	mov a, m
	ani 255-SPI_CS-SPI_DO-SPI_CLK
	mov m, a
	mvi h, 255
	mov l, h
	mov m, a

	mvi a, 03h
	call spi_transfer
	mov a, c
	call spi_transfer
	mov a, d
	call spi_transfer
	mov a, e
	call spi_transfer

	pop h
	ret

spi_rom_select:
	push h

	lxi h, MEM_START+E_OUT_SHADOW
	mov a, m
	ani 255-SPI_CS-SPI_DO-SPI_CLK
	mov m, a
	mvi h, 255
	mov l, h
	mov m, a

	pop h
	ret

spi_rom_deselect:
	push h

	lxi h, MEM_START+E_OUT_SHADOW
	mov a, m
	ori SPI_CS
	mov m, a
	mvi l, 255
	mov h, l
	mov m, a

	pop h
	ret

init_8251:
	push d
	; Reset & put into command mode
	lxi h, MEM_START+PC_SHADOW
	mov a, m
	ori SL_RES+SL_CD
	out PORTC
	call delay
	ani 255-SL_RES
	out PORTC
	; Persist command mode + no reset
	mov m, a

	mvi a, 01001110b ; 1 stop bit, no parity, 8-bit, 16X baud rate divisor
	call sl_write
	mvi a, 00010111b ; Enable TX, RX
	call sl_write

	pop d
	ret

	; Write contents of register A to the 8251 as data
write_8251:
	push h
	push psw

write_8251_delay:
	; Put into command mode
	lxi h, MEM_START+PC_SHADOW
	mov a, m
	ori SL_CD
	out PORTC
	mov m, a ; Persist command mode
	mvi h, 0
write_8251_delay_loop:
	mov a, h
	adi 1
	jc write_8251_delay_abort
	mov h, a

	nop
	call sl_read
	ani 4
	jz write_8251_delay_loop
write_8251_delay_abort:

	; Put into data mode
	lxi h, MEM_START+PC_SHADOW
	mov a, m
	ani 255-SL_CD
	out PORTC
	mov m, a ; Persist data mode

	pop psw
	call sl_write

	pop h

	ret
	
read_8251:
	push h
	push d
	
	lxi h, MEM_START+PC_SHADOW
	mov a, m
	ori SL_CD
	out PORTC
	mov m, a
	call sl_delay
	call sl_read
	mov d, a
	mov a, m
	ani 255-SL_CD
	out PORTC
	mov m, a
	call sl_delay
	
	mov a, d
	ani 2
	jz read_8251_no_new
	call sl_read
	
	pop d
	pop h
	ret
read_8251_no_new:
	mvi a, 0
	pop d
	pop h
	ret
	
; STDLIB STUFFS!

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
	lhld MD_TEMP8
	mov a, l
	ral
	mov l, a
	mov a, h
	ral
	mov h, a
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
	
printint16:
	push h
	lxi h, STRBUFF
	call itoa16
	call print_str
	pop h
	ret

printint32:
	push h
	lxi h, STRBUFF
	call itoa32
	call print_str
	pop h
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
	add a
	add a
	add c
	mov c, a
	mvi a, 0
	adc b
	mov b, a
	lxi d, DIN10
	ldax b
	stax d
	inx b
	inx d
	ldax b
	stax d
	inx b
	inx d
	ldax b
	stax d
	inx b
	inx d
	ldax b
	stax d
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
	mvi d, 6
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

init_text:
	db 13
	db 10
	db 'Tholin'
	db 0x27
	db 's 8085 computer - Bootloader & stdlib v0.1 - SPI & I2C'
	db 13
	db 10
	db 13
	db 10
	db 0
scan_i2c_text:
	db 'Trying I2C... '
	db 0
scan_spi_text:
	db 'Trying SPI... '
	db 0
no_dev_text:
	db 'No device detected!'
	db 13
	db 10
	db 0
invalid_dev_text:
	db 'Invalid device!'
	db 13
	db 10
	db 0
supported_rom_text:
	db 'Supported ROM found!'
	db 13
	db 10
	db 0
inv_bootrecord_text:
	db 'Invalid bootrecord!'
	db 13
	db 10
	db 0
valid_bootrecord_text:
	db 'Valid bootrecord found, booting!'
	db 13
	db 10
	db 0
size_text:
	db 'Size '
	db 0
no_boot_dev_text:
	db 13
	db 10
	db 'FATAL: No usable boot devices found!'
	db 13
	db 10
	db 0
hex_chars:
	db '0123456789ABCDEF'
acceptable_spi_rom_ids:
	db 0xEF
	db 0xC2
	db 0
magic_header:
	db 'CHIRP'
	db 0
	end
