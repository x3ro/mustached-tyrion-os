gdt_start:

gdt_null:       ; mandatory null descriptor
    dd 0x0      ; dd for double-word, i.e. 4 bytes
    dd 0x0

gdt_code:       ; code segment descriptor
    ; base 0x0, limit 0xffffff
    dw 0xffff   ; Limit (bits 0-15)
    dw 0x0      ; Base (bits 0-15)
    db 0x0      ; Base (bits 16-23)

    ; 1st flags: present (1) privilege (00) decriptor type (1) = 1001b
    ; type flags: code (1) conforming (0) readable (1) accessed (0) -> 1010b
    db 10011010b

    ; 2nd flags: granularity (1) 32bit default (1) 64-bit seg (0) AVL 0 -> 1100b
    ; plus bits 16-19 of the limit -> 1111b
    db 11001111b

    db 0x0      ; Base (bits 24-31)

gdt_data:       ; data segment descriptor
    ; Same as code except for the type flags
    ; Note that type flag indices have different meaning for code
    ; and data segments.
    dw 0xffff   ; Limit (bits 0-15)
    dw 0x0      ; Base (bits 0-15)
    db 0x0      ; Base (bits 16-23)

    ; code (0) expanddown (0) writable (1) accessed (0) -> 0010b
    db 10010010b

    db 11001111b
    db 0x0      ; Base (bits 24-31)

gdt_end:        ; End label so that the assembler can calculate the
                ; size of the GDT



gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Size of the GDT, counting from 0
                                ; (thus the -1)
    dd gdt_start                ; Start address of the GDT


; Define some handy constants
; are what segment registers must contain when in protected mode. For example,
; when we set DS = 0x10 in PM, the CPU knows that we mean it to use the
; segment described at offset 0x10 (i.e. 16 bytes) in our GDT, which in our
; case is the DATA segment (0x0 -> NULL; 0x08 -> CODE; 0x10 -> DATA)
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
