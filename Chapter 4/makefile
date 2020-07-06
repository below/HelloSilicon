OBJS = printdword.o
CSOBJS = codesnippets.o

ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif

%.o : %.s
	as $(DEBUGFLGS) $< -o $@

all: printdword codesnippets

printdword: $(OBJS)
	ld -o printdword $(OBJS)

codesnippets: $(CSOBJS)
	ld -o codesnippets $(CSOBJS)