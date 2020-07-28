
ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif

LDFLAGS = -lc -e main

all: distance matrixmultneon

%.o : %.s
	as $(DEBUGFLGS) $(LSTFLGS) $< -o $@

distance: distance.s main.s
	clang $(LDFLAGS) -g -o distance distance.s main.s

matrixmultneon: matrixmultneon.s
	clang $(LDFLAGS) -g -o matrixmultneon matrixmultneon.s

