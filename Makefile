PLATFORM=$(shell uname -s)
ARCH=$(shell uname -m)
SCHEME=chez

ifeq ($(PLATFORM),Darwin)
  FORMAT=macho64
  NASM=/usr/local/bin/nasm
  CC=/usr/local/bin/gcc-6
  MAKE=/usr/bin/make
  ENTRY=_scheme_entry
endif

tests := $(wildcard test-*.scm)
bins := $(tests:.scm=.out)

# Run each test program and echo exit code
all: $(bins)
	for b in $(bins); do \
		./$$b; echo $$?; \
	done;

# Link objects into an executable
%.out: %.o boot.o
	$(CC) -o $@ $^

# Compile the boot wrapper. boot.c implements main()
boot.o: boot.c
	$(CC) -c -o boot.o boot.c

# Assemble each file into an object file
%.o: %.asm
	$(NASM) -g -f $(FORMAT) $^ -o $@

# Compile each scheme program into instructions for the assembler
%.asm: %.scm
	./tests-driver.scm $^ > $@

clean:
	rm -v *.o *.out *.asm

# Targets clean and all are not real artifacts
.PHONY: clean all

# Prevent automatic removal of intermediate files
.PRECIOUS: %.o %.out %.asm
