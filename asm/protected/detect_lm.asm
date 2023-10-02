[bits 32]

detect_lm_protected:
    pushfd ; back up EFLAGS

    ; pop EFLAGS and switch the ID bit
    pushfd
    xor dword[esp], 1 << 21
    popfd ; set EFLAGS with switched bit

    ; pop the new EFLAGS
    pushfd
    pop eax
    xor eax, dword[esp]

    popfd ; restore original EFLAGS

    ; eax == 0 if nothing changed
    test eax, eax
    jz _lm_not_supported ; CPUID is unavailable

    ; CPUID is available. Use it to check LM availability
    mov eax, 0x80000000
    cpuid

    ; if eax is > 0x80000001, then it is possible to enter long mode
    cmp eax, 0x80000001
    jb _lm_not_supported

    ret

_lm_not_supported:
    mov ah, STYLE_WB
    mov edi, VGA_START
    mov esi, LM_FAIL_MSG
    _lm_fail_next_char:
        lodsb
        stosw
        test al, al
        jnz _lm_fail_next_char

    jmp $


LM_FAIL_MSG db 'Long mode not supported', 0

