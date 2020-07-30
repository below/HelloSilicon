

ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif
LSTFLGS =

LDFLAGS = -syslibroot `xcrun -sdk macosx --show-sdk-path` -lSystem -e _start -arch arm64
CFLAGS = -lc -e main

all: codesnippets distance fpcomp

%.o : %.s
	as -march="armv8.2-a+fp16" $(DEBUGFLGS) $(LSTFLGS) $< -o $@

codesnippets: codesnippets.o
	ld $(LDFLAGS) -o codesnippets codesnippets.o

distance: distance.s main.s
	clang $(CFLAGS) -g -o distance distance.s main.s

fpcomp: fpcomp.s maincomp.s
	clang $(CFLAGS) -g -o fpcomp fpcomp.s maincomp.s
