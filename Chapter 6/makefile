CSOBJS = codesnippets.o
UPPEROBJS = main.o upper.o
UPPERMACOBJS = mainmacro.o

ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif
LSTFLGS =

all: codesnippets upper uppermacro

%.o : %.s
	as $(DEBUGFLGS) $(LSTFLGS) $< -o $@
codesnippets: $(CSOBJS)
	ld -o codesnippets $(CSOBJS)

upper: $(UPPEROBJS)
	ld -o upper $(UPPEROBJS)

uppermacro: $(UPPERMACOBJS)
	ld -o uppermacro $(UPPERMACOBJS)
