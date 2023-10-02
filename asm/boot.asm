[bits 16]
[org 0x7c00]

cld ; reset direction bit
cli ; disable interrupts

; reset cs to 0
jmp 0:here
here:

; reset remaining segment registers
xor ax, ax
mov es, ax
mov ds, ax
mov ss, ax


mov ah, 0x02           ; BIOS read sector routine
mov al, KERNEL_SECTORS ; read this number of sectors
mov bx, 0x07e00        ; read the data into es:bx, i.e. 0:0x7e00
mov cx, 0x0002         ; ch=0x00 -> cylinder 0; cl=0x02 -> start reading from 2nd sector
; nop                  ; BIOS puts the drive in dl on startup
mov dh, 0x00           ; select head 0

int 0x13               ; invoke the utility

jc disk_load_failure  ; carry is set if read utility failed
cmp al, KERNEL_SECTORS ; BIOS sets al to number of read sectors
jne disk_load_failure ; fail if read less than KERNEL_SECTORS


lgdt [gdt_32_descriptor] ; now, set up basic GDT

mov eax, cr0
or eax, 0x1
mov cr0, eax ; and enable it by switching the lowest bit

jmp code_seg_32:protected_entry ; long jump to clear pipeline and enter 32bit mode

disk_load_failure:
    mov ah, 0x0E
    mov si, DL_FAIL_MSG
    dl_next_ch:
        lodsb
        int 0x10
        test al, al
        jnz dl_next_ch

    jmp $

DL_FAIL_MSG db 'Disk load failure', 0

%include 'gdt32.asm'

[bits 32]
protected_entry:

; set up segment registers
mov ax, data_seg_32
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax

; set up stack, since we do calls now
mov esp, 0x90000

; clear screen (fill VGA memory w/ spaces)
mov ax, 0x0F20 ; ah=0x0F (wb style), al=' '
mov edi, VGA_START
mov ecx, VGA_EXTENT / 2
rep stosw

call init_pt
call detect_lm_protected

jmp elevate_protected


VGA_START equ 0x000B8000
VGA_EXTENT equ 80 * 25 * 2
VGA_END equ (VGA_START + VGA_EXTENT)
STYLE_WB equ 0x0F

%include 'protected/init_pt.asm'
%include 'protected/detect_lm.asm'
%include 'protected/gdt.asm'
%include 'protected/elevate.asm'

[bits 64]
second_sector_entry:
long_mode_entry:

mov rbp, MAPPED_MEM_END
mov rsp, rbp

jmp kernel_entry

MAPPED_MEM_END equ 0x1000 * 512 ; only 512 pages are mapped

times 510 - ($ - $$) db 0
dw 0xaa55 ; last two bytes must be the magic number


; @ 0x7e00, second sector
kernel_entry:
incbin 'kernel.bin'
binary_end:

KERNEL_SIZE equ binary_end - kernel_entry
KERNEL_SECTORS equ (KERNEL_SIZE + 511) / 512

; pad the last sector w/ zeros
times 512 - KERNEL_SIZE % 512 db 0

