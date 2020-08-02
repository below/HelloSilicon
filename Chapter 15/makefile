
all: upper upperghidra

upper: upper.c
	# gcc -O3 -mcmodel=tiny -o upper upper.c
	# gcc -O3 -momit-leaf-frame-pointer -o upper upper.c
	gcc -O3 -g -o upper upper.c
	gcc -O3 -S -fverbose-asm -g  -o upper.s upper.c
	objdump -d -s upper >od.txt

upperghidra: upperghidra.c
	gcc -O3 -o upperghidra upperghidra.c
