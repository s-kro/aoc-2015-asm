aoc_2015-1a: aoc_2015-1a.asm
	nasm -f elf64 -o aoc_2015-1a.o $^
#	nasm -f elf64 -F dwarf -g -o aoc_2015-1a.o $^ # debug
	ld -m elf_x86_64 -o aoc_2015-1a aoc_2015-1a.o 

aoc_2015-1b: aoc_2015-1b.asm
	nasm -f elf64 -o aoc_2015-1b.o $^
#	nasm -f elf64 -F dwarf -g -o aoc_2015-1a.o $^ # debug
	ld -m elf_x86_64 -o aoc_2015-1b aoc_2015-1b.o 

