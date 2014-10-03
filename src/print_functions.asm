
; al is the character to be printed
print_char:
    pusha
    mov ah, 0x0e ; int 10/ah = 0eh -> scrolling teletype BIOS routine
    int 0x10
    popa
    ret

; bx is the address to be printed (null terminated)
print_string:
    pusha

print_string_loop:
    mov al, [bx]
    cmp al, 0x0                 ; End of string reached?
    je print_string_end
    call print_char
    add bx, 0x1                 ; Next character
    jmp print_string_loop

print_string_end:
    popa
    ret
