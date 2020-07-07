CSOBJS = codesnippets.o
UPPEROBJS = upper.o

ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif
LSTFLGS =

all: codesnippets upper

%.o : %.s
	as $(DEBUGFLGS) $(LSTFLGS) $< -o $@
codesnippets: $(CSOBJS)
	ld -o codesnippets $(CSOBJS)

upper: $(UPPEROBJS)
	ld -o upper $(UPPEROBJS)
