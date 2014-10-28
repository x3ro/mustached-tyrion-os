[bits 32]

start_protected_mode:

    mov ax, DATA_SEG        ; In protected mode our old data segments
    mov ds, ax              ; are useless now, so we update all segment
    mov ss, ax              ; registers to use our new data segment
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000        ; Update our stack position so that it's
    mov esp, ebp            ; right on top of the free space

    mov ebx, MSG_PROT_MODE
    call print_string_pm

    jmp $ ; Loop forever
