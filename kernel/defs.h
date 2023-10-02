#ifndef DEFS_H
#define DEFS_H


#define VGA_COLS 80
#define VGA_ROWS 25
#define VGA_SPAN 2000 // in words

#define VGA_START ((u16*)0xb8000ull)
#define VGA_END ((u16*)(VGA_START + VGA_SPAN))

#define STYLE_WB 0x0F


#define REG_SCREEN_CTRL 0x3d4


typedef signed char i8;
typedef signed short i16;
typedef signed int i32;
typedef signed long long i64;

typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
typedef unsigned long long u64;

#endif
