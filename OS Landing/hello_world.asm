[bits 16]  ;tell assembler to produce 16 bit binary format
[org 0x7c00]  ; the address where bios will load our bootloader

start:
    xor ax, ax
    mov ds, ax
    mov es, ax     ;these 3 lines will clear the ax, ds & es register
    mov bx, 0x8000 ; we will start from address 0x8000

    mov si, hello_world   ; set source index points to hello_world string
    call print_string     ; call print_string function


    hello_world db 'Hello World!' ,13,0 ;define string

;define function here
print_string:
    mov ah, 0x0E ; value to tell interrupt handler to take value from al & print it on screen

.repeat_next_char:
    lodsb    ; load first character of hello_world string to al register
    cmp al, 0
    je .done_print
    int 0x10   ; call bios video interrupt
    jmp .repeat_next_char

.done_print:
    ret


times (510 -($ - $$)) db 0x00 ; 512 bytes $$ are 2 bytes, this tells the bios that this file contain bootloader components
dw 0xAA55     ; boot signature tells bios that this file contains boot components that need to boot