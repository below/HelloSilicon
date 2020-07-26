
ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif
LSTFLGS =

LDFLAGS = -lSystem -lc -e main -arch arm64

all: divexamp mulexamp matrixmult

%.o : %.s
	as $(DEBUGFLGS) $(LSTFLGS) $< -o $@

divexamp: divexamp.s debug.s
	clang $(LDFLAGS) -o divexamp divexamp.s

mulexamp: mulexamp.s debug.s
	clang $(LDFLAGS) -o mulexamp mulexamp.s

matrixmult: matrixmult.s
	clang $(LDFLAGS) -g -o matrixmult matrixmult.s


