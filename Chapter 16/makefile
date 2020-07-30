UPPEROBJS = main.o upper.o

ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif

all: upper upperpie uppercanary

LDFLAGS = -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64

%.o : %.s
	as $(DEBUGFLGS) $(LSTFLGS) $< -o $@


upper: $(UPPEROBJS)
	ld $(LDFLAGS) -no_pie -o upper $(UPPEROBJS)

upperpie: $(UPPEROBJS)
	ld $(LDFLAGS) -pie -o upperpie $(UPPEROBJS)

uppercanary: upper.c
	clang -o uppercanary -fstack-protector-all -O3 upper.c
