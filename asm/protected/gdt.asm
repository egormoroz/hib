gdt_64_start:

gdt_64_null:
    ; 0th segment (must be zeros)
    dd 0
    dd 0

gdt_64_code:
    dw 0xFFFF ; Limit (bits 0-15)
    dw 0x0000 ; Base  (bits 0-15)
    
    db 0x00   ; Base  (bits 16-23)

    db 10011010b ; 1st type flags
    db 10101111b ; 2nd type flags + limit (bits 16-19)

    db 0x00      ; base

gdt_64_data:
    dw 0xFFFF ; Limit (bits 0-15)
    dw 0x0000 ; Base  (bits 0-15)
    
    db 0x00   ; Base  (bits 16-23)

    db 10010010b ; 1st type flags
    db 10101111b ; 2nd type flags + limit (bits 16-19)

    db 0x00      ; base

gdt_64_end:

gdt_64_descriptor:
    dw gdt_64_end - gdt_64_start - 1
    dq gdt_64_start


code_seg_64 equ gdt_64_code - gdt_64_start
data_seg_64 equ gdt_64_data - gdt_64_start

