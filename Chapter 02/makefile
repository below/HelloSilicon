MEOBJS = movexamps.o
AE1OBJS = addexamp1.o
AE2OBJS = addexamp2.o
CSOBJS = codesnippets.o

ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif

LDFLAGS = -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64

%.o : %.s
	as $(DEBUGFLGS) $< -o $@

all: movexamps addexamp1 addexamp2 codesnippets

movexamps: $(MEOBJS)
	ld -o movexamps $(LDFLAGS) $(MEOBJS)

addexamp1: $(AE1OBJS)
	ld -o addexamp1 $(LDFLAGS) $(AE1OBJS)

addexamp2: $(AE2OBJS)
	ld -o addexamp2 $(LDFLAGS) $(AE2OBJS)

codesnippets: $(CSOBJS)
	ld -o codesnippets $(LDFLAGS) $(CSOBJS)

clean:
	rm *.o movexamps addexamp1 addexamp2
