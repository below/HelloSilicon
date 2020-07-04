# HelloSilicon
An attempt with assembly on the machine we must not speak about

So this is a little attempt to invoke syscalls on a machine running a Mach Kernel on an ARM64-like architecture.

The code is taken from the book _Programming with 64-Bit ARM Assembly Language_

## What Works

The _MacAs_ Target runs. Here, a C `main` calls the assembly routine `_start`.

## What Doesn't Work

Anything without C. In the _AsMain_ target there is a file ´main.s´, in which I renamed `_start` to `_main`.  I can successfully build, and even run, but the executable crashes with an `EXC_BAD_ACCESS`

Trying to build the file by itself fails.
```
% make
as -o HelloWorld.o main.s
ld -o HelloWorld HelloWorld.o
ld: warning: arm64 function not 4-byte aligned: _main from HelloWorld.o
ld: warning: arm64 function not 4-byte aligned: helloworld from HelloWorld.o
ld: dynamic main executables must link with libSystem.dylib for architecture arm64
```

Adding `-lSystem` doesn't make it much better:
```
make           
as -o HelloWorld.o main.s
ld -o HelloWorld HelloWorld.o -lSystem
ld: library not found for -lSystem
```

## Interesting:

The alignment warning only appears in the `AsMain` target not when the code is succesfully built.
