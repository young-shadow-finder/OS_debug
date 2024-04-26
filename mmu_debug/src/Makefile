CC = aarch64-none-linux-gnu-gcc
LD = aarch64-none-linux-gnu-ld
CFLAGS = -c -O0 -g 
OBJECTS = serial_init.o Start.o main.o
LINKER_SCRIPT = linker.ld
OUTPUT = mmu_debug.elf

all: $(OUTPUT)

$(OUTPUT): $(OBJECTS)
	$(LD) -T $(LINKER_SCRIPT) $(OBJECTS) -o $@

serial_init.o: serial_init.c
	$(CC) $(CFLAGS) $< -o $@

main.o: main.c
	$(CC) $(CFLAGS) $< -o $@

Start.o: Start.S
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -f $(OBJECTS) $(OUTPUT)