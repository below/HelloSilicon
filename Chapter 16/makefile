UPPEROBJS = main.o upper.o

ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif

all: upper upperpie uppercanary

%.o : %.s
	as $(DEBUGFLGS) $(LSTFLGS) $< -o $@


upper: $(UPPEROBJS)
	ld -o upper $(UPPEROBJS)

upperpie: $(UPPEROBJS)
	ld -pie -o upperpie $(UPPEROBJS)

uppercanary: upper.c
	gcc -o uppercanary -fstack-protector-all -O3 upper.c