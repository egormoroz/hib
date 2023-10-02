CC=x86_64-elf-gcc
LD=x86_64-elf-ld
OCPY=x86_64-elf-objcopy

INCDIRS=-I.
OPT=-O0
CFLAGS=-std=c99 -Wall -Wextra -ffreestanding -fno-stack-protector -mno-red-zone -m64 -g $(INCDIRS) $(OPT)

IMAGE=os.bin

COBJS=kmain.o print.o math.o ports.o vga.o memory.o idt.o
OBJS=stub.o $(COBJS)

BOOTSRC=asm/boot.asm asm/gdt32.asm $(wildcard asm/protected/*.asm)

all: $(IMAGE)

run: $(IMAGE)
	qemu-system-x86_64 -drive format=raw,file=$(IMAGE)

$(IMAGE): $(BOOTSRC) kernel.bin
	nasm asm/boot.asm -Iasm -f bin -o $(IMAGE)

kernel.bin: $(OBJS)
	$(LD) -nostdlib -Tlink.ld -o kernel.a $(OBJS)
	$(OCPY) -O binary kernel.a kernel.bin
	rm kernel.a

stub.o: asm/stub.asm
	nasm asm/stub.asm -wall -f elf64 -o stub.o

$(COBJS): %.o: kernel/%.c
	$(CC) $(CFLAGS) -c -o $@ $^

clean:
	rm kernel.bin $(IMAGE) $(OBJS)
