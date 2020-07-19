CSOBJS = codesnippets.o
UPPEROBJS = main.o upper.o
UPPERMACOBJS = mainmacro.o

ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif
LSTFLGS =

all: upper uppermacro # codesnippets

LDFLAGS = -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64  

%.o : %.s
	as $(DEBUGFLGS) $(LSTFLGS) -arch arm64 $< -o $@
codesnippets: $(CSOBJS)
	ld -o codesnippets $(LDFLAGS) $(CSOBJS)

upper: $(UPPEROBJS)
	ld -o upper $(LDFLAGS) $(UPPEROBJS)

uppermacro: $(UPPERMACOBJS)
	ld -o uppermacro $(LDFLAGS) $(UPPERMACOBJS)

clean:
	rm $(CSOBJS) $(UPPERMACOBJS) $(UPPEROBJS) upper uppermacro uppermacro.o codesnippets
