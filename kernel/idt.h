#ifndef IDT_H
#define IDT_H

#include "defs.h"

#define N_IDT_ENTRIES 256
#define KERNEL_SELECTOR 0x8

typedef struct IDTGate {
    u16 offset_1;
    u16 selector;

    u8 ist;
    u8 type_attribs;
    u16 offset_2;

    u32 offset_3;
    u32 zero;
} IDTGate;

typedef struct IDTRegister {
    u16 limit;
    u64 base;
} __attribute__((packed)) IDTRegister;

extern IDTGate g_idt[N_IDT_ENTRIES];
extern IDTRegister g_idt_reg;

void idt_init();
void set_idt_handler(u16 idx, u64 phandler);

#endif
