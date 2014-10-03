[org 0x7c00]

    ; mov ah, 0x0e ; int 10/ah = 0eh -> scrolling teletype BIOS routine


    ; mov al, 'H'
    ; int 0x10
    ; mov al, 'e'
    ; int 0x10
    ; mov al, 'l'
    ; int 0x10
    ; ;
    ; mov al, 'l'
    ; int 0x10
    ; mov al, 'o'
    ; int 0x10

    ; xchg bx, bx
    ; mov al, the_secret
    ; mov al, [the_secret]
    ; mov al, [the_secret]
    ; int 0x10
;and ax, ax
mov bx, HELLO_MSG
;xchg bx, bx
call print_string



    jmp $  ; Loop forever

%include "print_functions.asm"

; Data
HELLO_MSG:
    db 'Booting...', 0

    ; Padding and magic BIOS number.
times 510-($-$$) db 0       ; Pad the boot sector out with zeros
dw 0xaa55                   ; Last two bytes form the magic number,
                                ; so BIOS knows we are a boot sector.
