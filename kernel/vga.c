#include "vga.h"
#include "ports.h"

void vga_putchar(u32 pos, char ch, u8 style) {
    (VGA_START)[pos] = ((u16)style) << 8 | ch;
}

u32 get_cursor_pos() {
    port_byte_out(REG_SCREEN_CTRL, 14);
    u32 pos = port_byte_in(REG_SCREEN_CTRL+1) << 8;
    port_byte_out(REG_SCREEN_CTRL, 15);
    pos |= port_byte_in(REG_SCREEN_CTRL+1);
    return pos;
}

void set_cursor_pos(u32 pos) {
    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_CTRL+1, pos >> 8);
    port_byte_out(REG_SCREEN_CTRL, 15);
    port_byte_out(REG_SCREEN_CTRL+1, pos & 0xFF);
}

