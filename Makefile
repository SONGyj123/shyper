osname := $(shell uname -s)

CROSS_PREFIX=aarch64-none-linux-gnu-

all: test.elf

test.o: test.c
	$(CROSS_PREFIX)gcc -c $< -o $@

trap.o: trap.c
	$(CROSS_PREFIX)gcc -c $< -o $@

startup64.o: startup64.S
	$(CROSS_PREFIX)as -c $< -o $@

exception.o: exception.S
	$(CROSS_PREFIX)as -c $< -o $@

test.elf: test.o startup64.o exception.o trap.o
	$(CROSS_PREFIX)ld -Tlinkerscript.ld $^ -o $@

test64.bin: test.elf
	$(CROSS_PREFIX)objcopy -O binary $< $@

clean:
	rm -f test.bin test.elf *.o

QEMU=qemu-system-aarch64
QEMU_OPTS=-M virt -cpu cortex-a53 -nographic -kernel test.elf
QEMU_EL=-machine virtualization=on -machine secure=on

run: clean all
	~/qemu-8.0.3/build/qemu-system-aarch64 $(QEMU_OPTS) $(QEMU_EL)

debug: clean all
	qemu-system-aarch64 $(QEMU_OPTS) $(QEMU_EL) -S -s
