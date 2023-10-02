gdt_32_start:

gdt_32_null:
    ; 0th segment (must be zeros)
    dd 0
    dd 0

gdt_32_code:
    dw 0xFFFF ; Limit (bits 0-15)
    dw 0x0000 ; Base  (bits 0-15)
    
    db 0x00   ; Base  (bits 16-23)

    db 10011010b ; 1st type flags
    db 11001111b ; 2nd type flags + limit (bits 16-19)

    db 0x00      ; base

gdt_32_data:
    dw 0xFFFF ; Limit (bits 0-15)
    dw 0x0000 ; Base  (bits 0-15)
    
    db 0x00   ; Base  (bits 16-23)

    db 10010010b ; 1st type flags
    db 11001111b ; 2nd type flags + limit (bits 16-19)

    db 0x00      ; base

gdt_32_end:

gdt_32_descriptor:
    dw gdt_32_end - gdt_32_start - 1
    dd gdt_32_start


code_seg_32 equ gdt_32_code - gdt_32_start
data_seg_32 equ gdt_32_data - gdt_32_start

