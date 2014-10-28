[org 0x7c00]


%macro func 1
    %1:
    pusha
%endmacro

%macro end 0
    popa
    ret
%endmacro

    mov bp, 0x8000          ; Set up the stack safely away at 0x8000
    mov sp, bp

    mov bx, MSG_REAL_MODE
    call print_string


    ; Switch to 32-bit protected mode
    cli                     ; Disable interrupts until we have made the switch
    lgdt [gdt_descriptor]   ; Load the GDT
    mov eax, cr0            ; We need to set the lowest bit in cr0
    or eax, 0x1             ; to switch modes, and we cannot do it
    mov cr0, eax            ; directly in cr0

    ; Make a far-jump so that the CPU pipeline, which might still contain
    ; 16-bit instruction now unusable in 32-bit mode, gets flushed.
    jmp CODE_SEG:start_protected_mode



%include "print_functions.asm"
%include "gdt.asm"
%include "protected_mode.asm"
%include "print_string_pm.asm"



; Global variables
MSG_REAL_MODE db "Booted 16-bit Real Mode", 0
MSG_PROT_MODE db "Switched to 32-bit Protected Mode", 0

; Padding and magic BIOS number.
times 510-($-$$) db 0       ; Pad the boot sector out with zeros
dw 0xaa55                   ; Last two bytes form the magic number,
                            ; so BIOS knows we are a boot sector.

; BIOS will only load the first 512 bytes, so after the bootsector we can
; write some recognizable memory pattern to try loading data from disk
times 256 dw 0xdada
times 256 dw 0xface
