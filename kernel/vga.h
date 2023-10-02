#ifndef VGA_H
#define VGA_H

#include "defs.h"

void vga_putchar(u32 pos, char ch, u8 style);

u32 get_cursor_pos();
void set_cursor_pos(u32 pos);

#endif
