[bits 64]

[extern _start]
call _start

mov ah, 0x0e ; yellow fg, black bg
mov rsi, WARN_MSG
mov rdi, VGA_START
warn_next_ch:
    lodsb
    stosw
    test al, al
    jnz warn_next_ch

jmp $

VGA_START equ 0x000B8000
WARN_MSG db 'Exited kernel. Daun?', 0

