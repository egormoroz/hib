#include "lib.h"
#include "math.h"
#include "vga.h"

#include <stdarg.h>

#define _match2(x, y) (x[0] == y[0] && x[1] == y[1])
#define _match3(x, y) (x[0] == y[0] && x[1] == y[1] && x[2] == y[2])

u32 g_cursor_pos = 0;

static void _handle_scrolling() {
    if (g_cursor_pos < VGA_SPAN)
        return;

    u16* vmem = VGA_START;
    for (u32 i = 0; i < VGA_SPAN - VGA_COLS; ++i)
        vmem[i] = vmem[i + VGA_COLS];
    for (u32 i = VGA_SPAN - VGA_COLS; i < VGA_SPAN; ++i)
        vmem[i] = (((u16)STYLE_WB) << 8) | ' ';

    g_cursor_pos = VGA_SPAN - VGA_COLS;
}

void putchar(char ch) {
    _handle_scrolling();

    switch (ch) {
    case '\r':
        g_cursor_pos -= g_cursor_pos % VGA_COLS;
        break;
    case '\n': 
        g_cursor_pos += 80 - g_cursor_pos % 80;
        break;
    default:
        vga_putchar(g_cursor_pos, ch, STYLE_WB);
        ++g_cursor_pos;
        break;
    };

    set_cursor_pos(g_cursor_pos);
}

static void _print_str(const char *s) {
    while (*s)
        putchar(*s++);
}

static void _print_i65(u64 x, u8 neg) {
    char buf[16], *p = buf;

    do {
        *p++ = '0' + x % 10;
        x /= 10;
    } while(x);

    if (neg)
        putchar('-');

    while (p > buf)
        putchar(*--p);
}

static void _print_i32(i32 x) { _print_i65(abs(x), x < 0); }
static void _print_i64(i64 x) { _print_i65(abs(x), x < 0); }
static void _print_u32(u32 x) { _print_i65(x, 0); }
static void _print_u64(u64 x) { _print_i65(x, 0); }


void printf(const char* fmt, ...) {
    va_list args;
    va_start(args, fmt);

    while (*fmt) {
        if (*fmt != '%') {
            putchar(*fmt++);
            continue;
        }
        ++fmt;

        // Ugly AF
        if (fmt[0] == 's') {
            _print_str(va_arg(args, const char*));
            ++fmt;
        } else if (fmt[0] == 'd') {
            _print_i32(va_arg(args, i32));
            ++fmt;
        } else if (fmt[0] == 'u') {
            _print_u32(va_arg(args, u32));
            ++fmt;
        } else if (_match2(fmt, "ld")) {
            _print_i32(va_arg(args, i32));
            fmt += 2;
        } else if (_match2(fmt, "lu")) {
            _print_u32(va_arg(args, u32));
            fmt += 2;
        } else if (_match3(fmt, "lld")) {
            _print_i64(va_arg(args, i64));
            fmt += 3;
        } else if (_match3(fmt, "llu")) {
            _print_u64(va_arg(args, u64));
            fmt += 3;
        } else {
            // unrecognized fmt symbol
            putchar(fmt[1]);
            ++fmt;
        }
    }

    va_end(args);
}

void clearscreen() {
    g_cursor_pos = 0;
    set_cursor_pos(0);

    for (u16 i = 0; i < VGA_SPAN; ++i)
        vga_putchar(i, ' ', STYLE_WB);
}

