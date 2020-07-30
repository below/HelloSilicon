UPPEROBJS = main.o upper.o
UPPER2OBJS = main.o upper2.o
UPPER3OBJS = upper3.o
UPPER4OBJS = main.o upper4.o

ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif
LSTFLGS =

all: upper upper2 upper3 upper4

LDFLAGS = -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64  

%.o : %.s
	as $(DEBUGFLGS) $(LSTFLGS) $< -o $@

upper: $(UPPEROBJS)
	ld $(LDFLAGS) -o upper $(UPPEROBJS)

upper2: $(UPPER2OBJS)
	ld $(LDFLAGS) -o upper2 $(UPPER2OBJS)

upper3: $(UPPER3OBJS)
	ld $(LDFLAGS) -o upper3 $(UPPER3OBJS)

upper4: $(UPPER4OBJS)
	ld $(LDFLAGS) -o upper4 $(UPPER4OBJS)
