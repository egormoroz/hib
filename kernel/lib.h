#ifndef LIB_H
#define LIB_H

#include "defs.h"

extern u32 g_cursor_pos;

void putchar(char ch);
void printf(const char* fmt, ...);
void clearscreen();


void memcpy(void* restrict dst, const void* restrict src, u64 n);
void memset(void* s, u8 x, u64 n);

#endif
