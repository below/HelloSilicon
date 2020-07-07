OBJS = printdword.o
CSOBJS = codesnippets.o

ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif

LDFLAGS = -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64  

%.o : %.s
	as $(DEBUGFLGS) $< -o $@

all: printdword # codesnippets

printdword: $(OBJS)
	ld -o printdword $(LDFLAGS) $(OBJS)

codesnippets: $(CSOBJS)
	ld -o codesnippets $(LDFLAGS) $(CSOBJS)
