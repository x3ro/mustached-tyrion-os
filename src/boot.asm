[org 0x7c00]


%macro func 1
    %1:
    pusha
%endmacro

%macro end 0
    popa
    ret
%endmacro

    mov [BOOT_DRIVE], dl    ; Save our boot drive so that we can read from it later

    mov bp, 0x8000          ; Set up the stack safely away at 0x8000
    mov sp, bp

    mov bx, HELLO_MSG
    call print_string

    mov dx, 0x1fb6 ; store the value to print in dx
    call print_hex ; call the function


    mov bx, 0x9000 ; Load 5 sectors starting at 0x0000(ES):0x9000(BX) from the boot disk
    mov dh, 5
    mov dl, [BOOT_DRIVE]
    call floppy_load

    mov dx, [0x9000] ; Print out the first loaded word, should be 0xdada
    call print_hex

    mov dx, [0x9000 + 512]  ; This should be 0xface
    call print_hex


    jmp $  ; Loop forever



%include "print_functions.asm"
%include "disk_io.asm"

; Global variables
BOOT_DRIVE: db 0

; Data
HELLO_MSG:
    db 'It is booting...', 0


; Padding and magic BIOS number.
times 510-($-$$) db 0       ; Pad the boot sector out with zeros
dw 0xaa55                   ; Last two bytes form the magic number,
                            ; so BIOS knows we are a boot sector.

; BIOS will only load the first 512 bytes, so after the bootsector we can
; write some recognizable memory pattern to try loading data from disk
times 256 dw 0xdada
times 256 dw 0xface
