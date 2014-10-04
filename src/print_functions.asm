; -----------------
; al is the character to be printed
print_char:
    pusha
    mov ah, 0x0e ; int 10/ah = 0eh -> scrolling teletype BIOS routine
    int 0x10
    popa
    ret


; -----------------
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


; ------------------------------------------
; dx contains the value to be printed as hex
func print_hex
;    pusha
    mov al, '0'
    call print_char
    mov al, 'x'
    call print_char

    mov ax, dx
    shr ax, 8               ; Shift upper 8 bits to lower 8 bits
    call print_hex_short    ; and print them

    mov al, dl              ; Now we print the actual lower 8 bits
    call print_hex_short
end


; ------------------------------------------
; al - the short to be printed as hex
func print_hex_short
    mov dl, al              ; Save the input parameter value before shifting
    shr al, 4               ; We want to print the upper 4-bits first, so shift them
                            ; to the lower bits
    call print_hex_digit    ; And print them
    mov al, dl              ; Now we print the actual lower bits
    call print_hex_digit
end


; ------------------------------------------
; al - the lower 4 bits of al contain the digit to be printed as hex
func print_hex_digit
    and al, 0xF ; Make sure we only have the lower 4 bits as expected
    add al, 48  ; 0 in the ascii table is 48

    cmp al, 57  ; Is the digit greater than 9? (ASCII 57)
    jle .print
    add al, 7   ; Such that we get A-F instead of : to @ (see ASCII table)

    .print
    call print_char
end

