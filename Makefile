osname := $(shell uname -s)

CROSS_PREFIX=aarch64-none-linux-gnu-

all: test.elf

test.o: test.c
	$(CROSS_PREFIX)gcc -c $< -o $@

startup64.o: startup64.s
	$(CROSS_PREFIX)as -c $< -o $@

test.elf: test.o startup64.o
	$(CROSS_PREFIX)ld -Tlinkerscript.ld $^ -o $@

test64.bin: test.elf
	$(CROSS_PREFIX)objcopy -O binary $< $@

clean:
	rm -f test.bin test.elf startup64.o test.o

QEMU=qemu-system-aarch64
QEMU_OPTS=-M virt -cpu cortex-a53 -nographic -kernel test.elf

run:
	~/qemu-8.0.3/build/qemu-system-aarch64 $(QEMU_OPTS)

debug:
	qemu-system-aarch64 $(QEMU_OPTS) -S -s
