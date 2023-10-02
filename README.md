# Description
A tiny os with self-written (i.e. shitty) bootloader.

# Compiling and running
A cross-compiler is suggested (though usual x86-64 linux gcc and ld works as well for now).
For assembly, nasm is used.

To build, run `make`. It would produce os.bin image, that could be loaded by qemu via `make run`.


