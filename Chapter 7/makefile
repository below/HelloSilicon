UPPEROBJS = main.o upper.o

ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif
LSTFLGS =

all: upper

%.o : %.S
	gcc $(DEBUGFLGS) $(LSTFLGS) -c $< -o $@

%.o : %.s
	as $(DEBUGFLGS) $(LSTFLGS) $< -o $@

upper: $(UPPEROBJS)
	ld -o upper $(UPPEROBJS)

