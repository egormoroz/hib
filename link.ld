/*
 * Copypasted it from somewhere. 
 * Only changed tne text section address to 0x7e00 (i.e. 2nd sector)
 * */

OUTPUT_FORMAT("elf64-x86-64")
ENTRY(_start)

SECTIONS
{
    . = 0x7e00;
	
    .text : {
        *(.text)
    }

    .rodata : {
        *(.rodata)
    }

    . = ALIGN(16);
    .data : {
        *(.data)
    }

    .bss : {
        *(.bss)
    }
    
}
