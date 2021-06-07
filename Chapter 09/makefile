LIBOBJS = upper.o

ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif
LSTFLGS =

LDFLAGS = -lSystem -lc -e main -arch arm64

all: addexamp2 uppertst uppertst2 uppertst3 uppertst4

upper.e.o : upper.s
	as -arch arm64e $(DEBUGFLAG) $< -o upper.e.o

%.o : %.s
	as $(DEBUGFLGS) $(LSTFLGS) $< -o $@

addexamp2: addexamp2.s debug.s
	clang $(LDFLAGS) $(DEBUGFLGS) -o addexamp2 addexamp2.s

uppertst: uppertst.c upper.s
	clang -o uppertst uppertst.c upper.s

libupper.a: $(LIBOBJS)
	ar -cvq libupper.a upper.o

uppertst2: uppertst.c libupper.a
	clang -o uppertst2 uppertst.c libupper.a

libup.dylib: $(LIBOBJS) upper.e.o
	clang -current_version 1.0 -compatibility_version 1.0 -dynamiclib -o libup.arm64.dylib $(LIBOBJS)
	clang -arch arm64e -current_version 1.0 -compatibility_version 1.0 -dynamiclib -o libup.arm64e.dylib upper.e.o
	lipo -create -output libup.A.dylib libup.arm64.dylib libup.arm64e.dylib 
	mkdir -p ~/lib
	mv libup.A.dylib ~/lib/
	ln -sf ~/lib/libup.A.dylib ~/lib/libup.dylib

uppertst3: libup.dylib
	clang -o uppertst3 uppertst.c -L ~/lib -lup

uppertst4: uppertst4.c
	clang -o uppertst4 uppertst4.c 

clean:
	rm -f *.o addexamp2 uppertst libupper.a uppertst? ~/lib/libup.dylib ~/lib/libup.A.dylib
