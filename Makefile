# Makefile - собирает boot.bin, kernel.bin, формирует floppy.img и запускает QEMU
FASM := fasm
QEMU := qemu-system-i386

BOOT_SRC := boot.asm
KERNEL_SRC := kernel.asm

BOOT_BIN := boot.bin
KERNEL_BIN := kernel.bin
IMG := floppy.img

.PHONY: all run clean

all: TT

# сборка .bin
$(BOOT_BIN): $(BOOT_SRC)
	@echo "Assembling $@..."
	$(FASM) $< $@

$(KERNEL_BIN): $(KERNEL_SRC)
	@echo "Assembling $@..."
	$(FASM) $< $@

# создание образа и запись boot+kernel
$(IMG): $(BOOT_BIN) $(KERNEL_BIN)
	@echo "Creating floppy image $(IMG)..."
	@dd if=/dev/zero of=$@ bs=512 count=2880 status=none
	@echo "Writing boot sector..."
	@dd if=$(BOOT_BIN) of=$@ conv=notrunc bs=512 seek=0 status=none
	@echo "Writing kernel..."
	@dd if=$(KERNEL_BIN) of=$@ conv=notrunc bs=512 seek=1 status=none
	@echo "Image ready."

# запуск
run: $(IMG)
	@echo "Starting QEMU..."
	$(QEMU) -fda $< -boot a -serial stdio

clean:
	@echo "Cleaning..."
	@rm -f $(BOOT_BIN) $(KERNEL_BIN) $(IMG)


TT: $(IMG) run clean
