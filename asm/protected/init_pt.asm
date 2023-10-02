[bits 32]

init_pt:
    ; 4 tables, each 4Kb in size (i.e. 1 page)
    ; lvl 4: 0x1000:0x1FFF
    ; lvl 3: 0x2000:0x2FFF
    ; lvl 2: 0x3000:0x3FFF
    ; lvl 1: 0x4000:0x4FFF

    ; 1. Zero the memory
    ; 2. init 1st entry of tables lvl 4-2
    ; 3. ID map pages in lbl 1 (aka page table)
    ; set 2 lower bits to 1 (i.e. entry is present and R/W perms)

    mov edi, 0x1000
    mov cr3, edi

    ; 1. Zero the memory
    xor eax, eax
    mov edi, 0x1000
    mov ecx, 0x1000
    rep stosd

    ; 2. Init tables lvl 4-2
    mov edi, cr3
    mov dword[edi], 0x2003 ; lvl 4
    add edi, 0x1000
    mov dword[edi], 0x3003 ; lvl 3
    add edi, 0x1000
    mov dword[edi], 0x4003 ; lvl 2

    ; 3. ID map all 512 pages
    mov ecx, 512
    mov eax, 3
    mov edi, 0x4000
_map_next_page:
    mov dword[edi], eax
    add eax, 0x1000
    add edi, 8
    loop _map_next_page

    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax
    
    ret


