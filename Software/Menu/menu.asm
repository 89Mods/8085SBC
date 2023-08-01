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

MEM_START equ 32768
c_addr equ MEM_START+16
addr_table equ 33027
addr_table_ptr equ MEM_START+20
temp equ MEM_START+22
pgmspace equ 33024
copy_loop_loc equ 57600

start	org 33024
	jmp aaa
	
	org 33024+128
aaa:
	lxi h, intro_text
	call FUNC_TABLE+PUTS
	
	lxi h, addr_table
	shld addr_table_ptr
	
	; List programs
	lxi h, c_addr
	mvi a, 0
	mov m, a
	inx h
	mvi a, 8
	mov m, a
	mvi a, 0
	inx h
	mov m, a
	mvi a, 0
	inx h
	mov m, a
	
	mvi b, 0
	mov c, b
print_programs_loop:
	call FUNC_TABLE+SPI_ROM_DESEL
	lxi h, c_addr
	mov a, m
	add c
	mov m, a
	mov e, a
	inx h
	mov a, m
	adc b
	mov m, a
	mov d, a
	inx h
	mov a, m
	aci 0
	mov m, a
	mov c, a
	inx h
	
	lhld addr_table_ptr
	mov a, c
	mov m, a
	inx h
	mov a, d
	mov m, a
	inx h
	mov a, e
	mov m, a
	inx h
	shld addr_table_ptr

	call FUNC_TABLE+SPI_ROM_SEL
	nop
	call FUNC_TABLE+SPI_ROM_READ_BEGIN
	
	call FUNC_TABLE+SPI_RECEIVE
	cpi 22
	jz print_programs_loop_exit
	cpi 33
	jz no_invalid_header
	lxi h, inv_header_text
	call FUNC_TABLE+PUTS
	jmp halt
no_invalid_header:
	; Print program index
	lda c_addr+3
	inr a
	sta c_addr+3
	dcr a
	adi '0'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ':'
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, ' '
	call FUNC_TABLE+SERIAL_WRITE

	call FUNC_TABLE+SPI_RECEIVE
	mov b, a
	ani 128
	jnz invalid_size
	call FUNC_TABLE+SPI_RECEIVE
	mov c, a
	ora b
	jnz no_invalid_size
invalid_size:
	lxi h, invalid_size_text
	call FUNC_TABLE+PUTS
	jmp halt
no_invalid_size:
	mvi l, 125
print_pgm_name_loop:
	call FUNC_TABLE+SPI_RECEIVE
	cpi 0
	jm print_pgm_name_exit
	jz print_pgm_name_exit
	call FUNC_TABLE+SERIAL_WRITE
	dcr l
	jnz print_pgm_name_loop
	lxi h, invalid_size_text
	call FUNC_TABLE+PUTS
	jmp halt
print_pgm_name_exit:
	call FUNC_TABLE+SPI_ROM_DESEL
	call newline
	jmp print_programs_loop
print_programs_loop_exit:
	call FUNC_TABLE+SPI_ROM_DESEL
	call newline
	
wait_for_key:
	call FUNC_TABLE+SERIAL_READ
	cpi 0
	jz wait_for_key
	sbi '0'
	jm wait_for_key
	mov d, a
	
	lxi h, c_addr + 3
	cmp m
	jp wait_for_key
boot_selected_program:
	mov a, d
	adi '0'
	call FUNC_TABLE+SERIAL_WRITE
	call newline
	lxi h, booting_text
	call FUNC_TABLE+PUTS
	
	lxi h, addr_table
	mov a, l
	add d
	mov l, a
	mov a, h
	aci 0
	mov h, a
	mov a, l
	add d
	mov l, a
	mov a, h
	aci 0
	mov h, a
	mov a, l
	add d
	mov l, a
	mov a, h
	aci 0
	mov h, a
	
	mov a, m
	mov c, a
	inx h
	mov a, m
	mov d, a
	inx h
	mov a, m
	mov e, a
	
	call FUNC_TABLE+SPI_ROM_SEL
	nop
	call FUNC_TABLE+SPI_ROM_READ_BEGIN
	
	call FUNC_TABLE+SPI_RECEIVE
	cpi 33
	jnz unexpected_err
	call FUNC_TABLE+SPI_RECEIVE
	mov b, a
	call FUNC_TABLE+SPI_RECEIVE
	mov c, a
	dcx b
	dcx b
	dcx b
	
skip_name_loop:
	call FUNC_TABLE+SPI_RECEIVE
	dcx b
	cpi 0
	jm skip_name_loop_exit
	jnz skip_name_loop
skip_name_loop_exit:

	lxi h, size_text
	call FUNC_TABLE+PUTS
	mov a, b
	call FUNC_TABLE+PRINT_HEX
	mov a, c
	call FUNC_TABLE+PRINT_HEX
	mvi a, 'h'
	call FUNC_TABLE+SERIAL_WRITE
	call newline
	
	lxi h, copy_loop_loc
	shld temp
	lxi d, copy_loop
	mvi l, copy_loop_end-copy_loop
copy_the_copy_loop_loop:
	push h
	lhld temp
	ldax d
	inx d
	mov m, a
	inx h
	shld temp
	pop h
	dcr l
	jnz copy_the_copy_loop_loop
	
	lxi d, pgmspace
	jmp copy_loop_loc

unexpected_err:
	lxi h, unexpected_err_text
	call FUNC_TABLE+PUTS
halt:
	call FUNC_TABLE+SPI_ROM_DESEL
	nop
	nop
	nop
	jmp halt
	
newline:
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	ret

	; Copy loop will be copied to another location in RAM
copy_loop:
	call FUNC_TABLE+SPI_RECEIVE
	stax d
	inx d
	dcx b
	mov a, b
	ora c
	jnz copy_loop_loc
	
	call FUNC_TABLE+SPI_ROM_DESEL
	mvi a, 13
	call FUNC_TABLE+SERIAL_WRITE
	mvi a, 10
	call FUNC_TABLE+SERIAL_WRITE
	jmp pgmspace
copy_loop_end:
	
intro_text:
	db '~~~~~~~~~~~~~~~~~'
	db 13
	db 10
	db 'Program selection'
	db 13
	db 10
	db '~~~~~~~~~~~~~~~~~'
	db 13
	db 10
	db 13
	db 10
	db 0
	
inv_header_text:
	db 'FATAL: Invalid magic no.'
	db 13
	db 10
	db 0
	
invalid_size_text:
	db 'FATAL: Invalid program size'
	db 13
	db 10
	db 0
	
booting_text:
	db 'Booting selected program...'
	db 13
	db 10
	db 0
	
unexpected_err_text:
	db 'FATAL: An unexpected error has occured. What?'
	db 13
	db 10
	db 0
	
size_text:
	db 'Size: '
	db 0
	end
