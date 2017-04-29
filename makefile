PLATFORM=$(shell uname -s)
ARCH=$(shell uname -m)
SCHEME=chez

ifeq ($(PLATFORM),Darwin)
  FORMAT=macho64
  NASM=/usr/local/bin/nasm
  CC=/usr/local/bin/gcc-6
  ENTRY=_scheme_entry
endif

test: test.o boot.o
	$(CC) -o $@ $^
#	$(CC) -Wl,-no_new_main -Wl,-e,$(ENTRY) -nostdlib -o $@ $^

boot.o: boot.c
	$(CC) -c -o boot.o boot.c

test.o: test.asm
	$(NASM) -g -f $(FORMAT) $^ -o $@

test.asm: test.scm
	$(SCHEME) --script $^ > $@

clean:
	rm -v boot.o test.o test.asm
