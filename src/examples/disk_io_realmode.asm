; Relies on the fact that BOOT_DRIVE is set to, well, the boot drive index
; e.g. through
mov [BOOT_DRIVE], dl    ; Save our boot drive so that we can read from it later
; directly at the beginning of the bootloader


mov bx, 0x9000 ; Load 5 sectors starting at 0x0000(ES):0x9000(BX) from the boot disk
mov dh, 5
mov dl, [BOOT_DRIVE]
call floppy_load

mov dx, [0x9000] ; Print out the first loaded word, should be 0xdada
call print_hex

mov dx, [0x9000 + 512]  ; This should be 0xface
call print_hex


; ---------------------------------
; es:bx - target memory to load to
; dh - number of sectors to load
; dl - disk to load from
func floppy_load

    push dx         ; save dx explicitly so that we can later check if we
                    ; read all the sectors we wanted to read

    mov ah, 0x02    ; BIOS read sector function
    mov al, dh      ; Read `dh` sectors
    mov ch, 0x00    ; select cylinder 0
    mov dh, 0x00    ; Select head 0
    mov cl, 0x02    ; Start reading from 2nd sector, i.e. after the boot sector

    int 0x13        ; BIOS interrupt

    jc .disk_error  ; Jump on error (i.e. carry flag is set by interrupt)

    pop dx
    cmp dh, al      ; if dh (sectors to be read) differs from al (sectors read)
    jne .disk_error

end

.disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $                       ; Freeze!


DISK_ERROR_MSG:
    db "Disk read error! Halting.", 0
