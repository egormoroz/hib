#include "lib.h"


void memcpy(void* restrict dst, const void* restrict src, u64 n) {
    u64 n_chunks = n / 8;
    for (u64 i = 0; i < n_chunks; ++i)
        ((u64*)dst)[i] = ((const u64*)src)[i];

    u32 rem = n % 8;
    dst += 8 * n_chunks;
    src += 8 * n_chunks;
    for (u32 i = 0; i < rem; ++i)
        ((char*)dst)[i] = ((const char*)src)[i];
}

void memset(void* s, u8 x, u64 n) {
    u64 n_chunks = n / 8;
    u64 t = x;
    t |= t << 8;
    t |= t << 16;
    t |= t << 32;

    for (u64 i = 0; i < n_chunks; ++i)
        ((u64*)s)[i] = t;

    u32 rem = n % 8;
    s += 8 * n_chunks;
    for (u32 i = 0; i < rem; ++i)
        ((char*)s)[i] = x;
}

