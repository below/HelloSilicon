MEOBJS = movexamps.o
AE1OBJS = addexamp1.o
AE2OBJS = addexamp2.o
CSOBJS = codesnippets.o

ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif

%.o : %.s
	as $(DEBUGFLGS) $< -o $@

all: movexamps addexamp1 addexamp2 codesnippets

movexamps: $(MEOBJS)
	ld -o movexamps $(MEOBJS)

addexamp1: $(AE1OBJS)
	ld -o addexamp1 $(AE1OBJS)

addexamp2: $(AE2OBJS)
	ld -o addexamp2 $(AE2OBJS)

codesnippets: $(CSOBJS)
	ld -o codesnippets $(CSOBJS)