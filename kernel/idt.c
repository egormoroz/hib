#include "idt.h"
#include "lib.h"

IDTGate g_idt[N_IDT_ENTRIES];
IDTRegister g_idt_reg;

void idt_init() {
    memset(g_idt, 0, sizeof(g_idt));
    g_idt_reg.limit = sizeof(g_idt);
    g_idt_reg.base = (u64)&g_idt;

}

void set_idt_handler(u16 idx, u64 phandler) {
    IDTGate *g = &g_idt[idx];

    g->offset_1 = phandler & 0xFFFF;
    g->offset_2 = (phandler >> 16) & 0xFFFF;
    g->offset_3 = phandler >> 32;

    g->selector = KERNEL_SELECTOR;
    g->ist = 0;
    g->type_attribs = 0x8e; // interrupt gate
    g->zero = 0;
}


