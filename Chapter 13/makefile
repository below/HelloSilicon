
ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif

CFLAGS = -lc -e main

all: distance matrixmultneon

%.o : %.s
	as $(DEBUGFLGS) $(LSTFLGS) $< -o $@

distance: distance.s main.s
	clang $(CFLAGS) $(DEBUGFLGS) -o distance distance.s main.s

matrixmultneon: matrixmultneon.s
	clang $(CFLAGS) $(DEBUGFLGS) -o matrixmultneon matrixmultneon.s

