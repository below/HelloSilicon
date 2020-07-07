LIBOBJS = upper.o

ifdef DEBUG
DEBUGFLGS = -g
else
DEBUGFLGS =
endif
LSTFLGS =

all: addexamp2 uppertst uppertst2 uppertst3 uppertst4

%.o : %.s
	as $(DEBUGFLGS) $(LSTFLGS) $< -o $@

addexamp2: addexamp2.s debug.s
	gcc -o addexamp2 addexamp2.s

uppertst: uppertst.c upper.s
	gcc -o uppertst uppertst.c upper.s

libupper.a: $(LIBOBJS)
	ar -cvq libupper.a upper.o

uppertst2: uppertst.c libupper.a
	gcc -o uppertst2 uppertst.c libupper.a

libup.so.1.0: $(LIBOBJS)
	gcc -shared -Wl,-soname,libup.so.1 -o libup.so.1.0 $(LIBOBJS)
	mv libup.so.1.0 /usr/local/lib
	ln -sf /usr/local/lib/libup.so.1.0 /usr/local/lib/libup.so.1
	ln -sf /usr/local/lib/libup.so.1.0 /usr/local/lib/libup.so
	ldconfig

uppertst3: libup.so.1.0
	gcc -o uppertst3 uppertst.c -lup

uppertst4: uppertst4.c
	gcc -o uppertst4 uppertst4.c 