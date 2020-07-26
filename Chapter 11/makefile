
ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif
LSTFLGS =

all: divexamp mulexamp matrixmult

%.o : %.s
	as $(DEBUGFLGS) $(LSTFLGS) $< -o $@

divexamp: divexamp.s debug.s
	gcc -o divexamp divexamp.s

mulexamp: mulexamp.s debug.s
	gcc -o mulexamp mulexamp.s

matrixmult: matrixmult.s
	gcc -g -o matrixmult matrixmult.s


