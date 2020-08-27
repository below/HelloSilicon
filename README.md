# HelloSilicon
An attempt with assembly on the _Machine We Must Not Speak About_.

## News

@jrosengarden [asked](https://github.com/below/HelloSilicon/issues/22#issue-687491010) me how to read the command line, and I gladly [answered](https://github.com/below/HelloSilicon/issues/22#issuecomment-682205151) the question. 

Sample code can be found in Chapter 4, `case.s`.

## Introduction

In this repository, I will code along with the book [Programming with 64-Bit ARM Assembly Language](https://www.apress.com/gp/book/9781484258804), adjusting all sample code for a new platform that might be very, very popular soon. The original sourcecode can be found [here](https://github.com/Apress/programming-with-64-bit-ARM-assembly-language).

## Prerequisites

While I pretty much assume that people who made it here meet most if not all required prerequisites, it doesn't hurt to list them. 

* You need [Xcode 12](https://developer.apple.com/xcode/), and to make things easier, the command line tools should be installed. I believe they are when you say "Yes" to "Install additional components", but I might be wrong. This ensures that the tools are found in default locations (namely `/usr/bin`). If you are not sure, check _Preferences → Locations_ in Xcode.

* All application samples also require [macOS Big Sur](https://developer.apple.com/macos/), [iOS 14](https://developer.apple.com/ios/) or their respective watchOS or tvOS equivalents. Especially for the later three systems it is not a necessity per-se (neither is Xcode 12), but it makes things a lot simpler.

* Finally, while all samples can be adjusted to work on Apple's current production ARM64 devices, for best results you should have access to a [MWMNSA](https://developer.apple.com/programs/universal/).

## Changes To The Book

With the exception of the existing iOS samples, the book is based on the Linux operating system. Apple's operating systems (macOS, iOS, watchOS and tvOS) are actually just flavors of the [Darwin](https://en.wikipedia.org/wiki/Darwin_(operating_system)) operating system, so they share a set of common core components. 
While Linux and Darwin are based on a similar idea and may appear to be very similar, some changes are needed to make the samples run on Apple hardware.

### Tools

The book uses Linux GNU tools, such as the GNU `as` assembler. While there is an `as` command on macOS, it will invoke the integrated [LLVM Clang](https://clang.llvm.org) assembler by default. And even if there is the `-Q` option to use the GNU based assembler, this was only ever an option for x86_64 — and this will be deprecated as well.
```
% as -Q -arch arm64
/usr/bin/as: can't specifiy -Q with -arch arm64
```
Thus, the GNU assembler syntax is not an option for Darwin, and the code will have to be adjusted for the Clang assembler syntax.

Likewise, while there is a `gcc` command on macOS, this simply calls the Clang C-compiler. For transparancy, all calls to `gcc` will be replaced with `clang`.

```
% gcc --version
Configured with: --prefix=/Applications/Xcode-beta.app/Contents/Developer/usr --with-gxx-include-dir=/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/c++/4.2.1
Apple clang version 12.0.0 (clang-1200.0.26.2)
```

### Operating System

Linux and Darwin, which were both inspired by [AT&T Unix System V](http://www.unix.org/what_is_unix/history_timeline.html), are significantly different at the level we are looking at. For the listings in the book, this mostly concerns system calls (i.e. when we want the Kernel to do someting for us), and the way Darwin accesses memory. 

The changes will be explained in details below.

## Chapter 1

If you are reading this, I assume you know that the macOS Terminal can be found in _Applications → Utilities → Terminal.app_. But if you didn't I feel honored to tell you and I wish you lots of fun on this journey! Don't be afraid to ask questions.

The default Calculator.app on macOS has a "Programmer Mode", too. You enable it with _View → Programmer_ (⌘3).

### Listing 1-1

To make "Hello World" run on the MWMNSA, first the changes from page 78 (Chapter 3) have to be applied to account for the differences between Darwin and the Linux kernel.
The next trick is to insert `.align 4` (or `.p2align 2`), because Darwin likes things to be aligned on even boundaries. Thanks to @m-schmidt and @zhuowei! The books mentions this in Aligning Data in Chapter 5, page 114.

To make the linker work, a little more is needed, most of it should look familiar to Mac/iOS developers. These changes need to be applied to the `makefile` and to the `build` file. The complete call to the linker looks like this:

```
ld -o HelloWorld HelloWorld.o \
	-lSystem \
	-syslibroot `xcrun -sdk macosx --show-sdk-path` \
	-e _start \
	-arch arm64
```

We know the `-o` switch, let's examine the others:


* `-lSystem` tells the linker to link our executable with `libSystem.dylib`. We do that to add the `LC_MAIN` load command to the executable. Generally, Darwin does not support [statically linked executables](https://developer.apple.com/library/archive/qa/qa1118/_index.html). It is [possible](https://stackoverflow.com/questions/32453849/minimal-mach-o-64-binary/32659692#32659692), if not especially elegant to create executables without using `libSystem.dylib`. I will go deeper into that topic when time permits. For people who read _Mac OS X Internals_ I will just add that this replaced `LC_UNIXTHREAD` as of MacOS X 10.7. 
* `-sysroot`: In order to find `libSystem.dylib`, it is mandatory to tell our linker where to find it. It seems this was not necessary on macOS 10.15 because _"New in macOS Big Sur 11 beta, the system ships with a built-in dynamic linker cache of all system-provided libraries. As part of this change, copies of dynamic libraries are no longer present on the filesystem."_. We use `xcrun -sdk macosx --show-sdk-path` to dynamically use the currently active version of Xcode.
* `-e _start`: Darwin expects an entrypoint `_main`. In order to keep the sample both as close as possible to the book, and to allow it's use within the C-Sample from _Chapter 3_, I opted to keep `_start` and tell the linker that this is the entry point we want to use
* `-arch arm64` for good measure, let's throw in the option to cross-compile this from an Intel Mac

## Chapter 2

The changes from [Chapter 1](https://github.com/below/HelloSilicon#chapter-1) (makefile, alignment, system calls) have to be applied.

### Register and Shift

The Clang assembler does not understand `MOV X1, X2, LSL #1`, instead `LSL X1, X2, #1` (etc) is used. Apple has told me (FB7855327) that they are not planning to change this, and after all, both are just aliasses for the instruction `ORR X1, XZR, X2, LSL #1`.

### Register and Extension

Clang requires the source register to be 32-Bit. This makes sense, because with these extensions, the upper 32 Bit of a 64-Bit reqister will never be touched:
```
ADD X2, X1, W0, SXTB
```
 The GNU Assembler seems to ignore this and allows you to specifiy a 64-Bit source register.

## Chapter 3

### Beginning GDB

On macOS, `gdb` has been replaced with the [LLDB Debugger](https://lldb.llvm.org) `lldb` of the LLVM project. The syntax is not always the same as for gdb, so I will note the differences here. 

To start debugging our **movexamps** program, enter the command

```
lldb movexamps
```

This yields the abbreviated output:

```
(lldb) target create "movexamps"
Current executable set to 'movexamps' (arm64).
(lldb)
```

Commands like `run` or `list` work just the same, and there is a nice [GDB to LLDB command map](https://lldb.llvm.org/use/map.html).

To disassemble our program, a slightly different syntax is used for lldb:

```
disassemble --name start
```

Note that because we are linking a dynamic executable, the listing will be long and include other `start` functions. Our code will be listed under the line ``movexamps`start``.

Likewise, lldb wants the breakpoint name without the underscore: `b start`

To get the registers on lldb, we use **register read** (or **re r**). Without arguments, this command will print all registers, or you can specify just the registers you would like to see, like `re r SP X0 X1`.

We can see all the breakpoints with **breakpoint list** (or **br l**). We can delete a breakpoint with **breakpoint delete** (or **br de**) specifying the breakpoint number to delete.

**lldb** has even more powerful mechanisms to display memory. The main command is **memory read** (or **m read**). For starters, we will present the parameters used by the book:

```
memory read -fx -c4 -s4
```

where
* **-f** is the display format
* **-s** size of the data
* **-c** count

### Listing 3-1

As an excersise, I have added code to find the default Xcode toolchain on macOS. In the book they are using this to later switch from a Linux to an Android toolchain. This process is much different for macOS and iOS: It does not usually involve a different toolchain, but instead a different Software Development Kit (SDK). You can see that in [Listing 1-1](https://github.com/below/HelloSilicon#listing-1-1) where `-sysroot` is set. 

That said, while it is possible to build an iOS executable with the command line it is not a trivial process. So for building apps I will stick to Xcode.

### Listing 3-7

As [Chapter 10](https://github.com/below/HelloSilicon#chapter-10) focusses on building an app that will run on iOS, I have chosen to simply create a Command Line Tool here which is now using the same `HelloWorld.s` file.
Thankfully @saagarjha [suggested](https://github.com/below/HelloSilicon/issues/5) how it would be possible to build the sample with Xcode _without_ `libc`, and I might come back to try that later.

## Chapter 4

Besides the changes that are common, we face a new issue which is described in the book in Chapter 5: Darwin does not like `LSR X1, =symbol`, we will get the error `ld: Absolute addressing not allowed in arm64 code`. If we use `ASR X1, symbol`, as suggested in Chapter 3 of the book, our data has to be in the read-only `.text` section. In this sample however, we want writable data. 

The [Apple Documentation](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/MachOTopics/1-Articles/x86_64_code.html#//apple_ref/doc/uid/TP40005044-SW1) tells us that on Darwin:
> All large or possibly nonlocal data is accessed indirectly through a global offset table (GOT) entry. The GOT entry is accessed directly using RIP-relative addressing.

And by default, on Darwin all data contained in the `.data` section, where data is writeable, is "possibly nonlocal".

Thankfully, @claui gave me a pointer into the right direction, and the full answer can be found [here](https://reverseengineering.stackexchange.com/a/15324): 
> The `ADRP` instruction loads the address of the 4KB page anywhere in the +/-4GB (33 bits) range of the current instruction (which takes 21 high bits of the offset). This is denoted by the `@PAGE` operator. then, we can either use `LDR` or `STR` to read or write any address inside that page or `ADD` to to calculate the final address using the remaining 12 bits of the offset (denoted by `@PAGEOFF`).

So this: 

```
	LDR	X1, =outstr // address of output string
```

becomes this:

```
	ADRP	X1, outstr@PAGE	// address of output string 4k page
	ADD	X1, X1, outstr@PAGEOFF // offset to outstr within the page
```

## Chapter 5

The important differences in memory addressing for Darwin were already addresed above.

### Listing 5-1
The `quad`, `octa` and `fill` keywords must be in lowercase for the llvm assembler. (See bottom of this file)

### Listing 5-10

Changes like in Chapter 4.

## Chapter 6

As we learned in Chapter 5, all assembler directives (like `.equ`) must be in lowercase. 

## Chapter 7
`asm/unistd.h` does not exist in the Apple SDKs, instead `sys/syscalls.h` can be used.

It is also important to notice that while the calls and definitions look similar, Linux and Darwin are not the same: `AT_FDCWD` is -100 on Linux, but must be -2 on Darwin.

## Chapter 8

This chapter is specifically for the Raspberry Pi 4, so there is nothing to do here.

## Chapter 9

For transparency reasons, I replaced `gcc` with `clang`. On macOS it doesn't matter because:
```
% gcc --version
Apple clang version 12.0.0 (clang-1200.0.22.41)
```

### Listing 9-1
Apart from the usual changes, it appears that on Linux, printf will accept arguments passed in the registers. On Darwin, this is not the case, and we must pass the arguments on the stack.

```
str     X1, [SP, #-32]! // Move the stack pointer four doublewords (32 bytes) down and push X1 onto the stack
str     X2, [SP, #8]    // Push X2 to one doubleword above the current stack pointer
str     X3, [SP, #16]   // Push X3 to two doublewords above the current stack pointer
adrp    X0, ptfStr@PAGE // printf format str
add     X0, X0, ptfStr@PAGEOFF  // add offset for format str
bl      _printf // call printf
add     SP, SP, #32 // Clean up stack
```

So first, we are growing the stack downwards 32 bytes, to make room for three 64-Bit values. And because, as pointed out on page 137 in the book, ARM hardware requires the stack pointer to always be 16-byte aligned, we are creating space for a fourth value for padding.

In the same command, **X1** is stored at the new location of the stack pointer.

Now, we fill the rest of the space we just created by storing **X2** in a location eight bytes above, and **X3** 16 bytes above the stack pointer. Note that the **str** commands for **X2** and **X3** do not move **SP**.

We could fill the stack in different ways; what is important that the `printf` function expects the parameters as doubleword values in order, upwards from the current stackpointer. So in the case of the "debug.s" file, it expects the parameter for the `%c` to be at the location of **SP**, the parameter for `%32ld` at one doubleword above this, and finally the parameter for `%016lx` two doublewords, 16 bytes, above the current stack pointer.

What we have effectively done is [allocating memory on the stack](https://en.wikipedia.org/wiki/Stack-based_memory_allocation). As we, the caller, "own" that memory we need to release it after the function branch, in this case simply by shrinking the stack (upwards) by the 32 bytes we allocated. The instruction `add SP, SP, #32` will do that.

It took me quite a while to figure this out, and there is minimal `test.s` and corresponding `build` script to see the printf call in isolation. I have no idea why this is the case, as the [Procedure Call Standard for the ARM 64-bit Architecture ](https://developer.arm.com/documentation/ihi0055/c/) clearly describes the Linux way. I'd be thankful for a hint why Apple is diverting from the PCS, or if I have overlooked something.

### Listing 9-5
`mytoupper` was prefixed with `_` as this is necessary for C on Darwin to find it.

### Listing 9-6

No change was required.

### Listing 9-7
Instead of a shared `.so` ELF library, a dynamic Mach-O libary is created. Further information can be found here: [Creating Dynamic Libraries](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/DynamicLibraries/100-Articles/CreatingDynamicLibraries.html)

### Listing 9-8
The size of one variable had to be changed from int to long to make the assembler happy.

More importantly, I had to change the `loop` label to a numeric label, and branch to it with the `f` — forward — option. If anyone has an idea how a non-numeric label can be used here, that would be apprecated.

### Listing 9-9

While the `uppertst5.py` file only needed a minimal change, calling the code was more challenging than I had thought: On the MWMNSA, python is a Mach-O universal binary with two architectures: x86_64 and arm64e. Notably absent is the arm64 architecture we were building for up to this point. This makes our dylib unusable with python.

arm64e is the [Armv-8 architecture](https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/armv8-a-architecture-2016-additions), which Apple is using since the A12 chip. If you want to address devices prior to the A12, you must stick to arm64. It is public knowledge that the MWMNSA runs on an A12Z Bionic, thus Apple decided to take advangage of the new features.

So, what to do? We could compile everything as arm64e, but that would make the library useless on any iPhone but the very latest, and we would like to support those, too.

Above, you read something about _universal binary_. For a very long time, the Mach-O executable format had support for several processor architectures in a single file. This includes, but is not limited to, Motorola 68k (on NeXT computers), PowerPC, Intel x86, as well ARM code, each with their 32 and 64 bit variantes where applicable. In this case, I am building a universal dynamic library which includes both arm64 and arm64e code. More information can be found [here](https://developer.apple.com/documentation/xcode/building_a_universal_macos_binary).

## Chapter 10
No changes in the core code were required, but instead of just an iOS app I created a SwiftUI app that will work on macOS, iOS, watchOS (Series 4 and later), and tvOS.

The only issue I found was that I had to prevent Xcode 12 Beta 3 from attempting to build x386 and x86_64 binaries for the watch App. I would assume that is a bug.

## Chapter 11
At this point, the changes should be self-explainatory. The usual makefile adjustments, `.align 4`, address mode changes, and `_printf` adjustments.

## Chapter 12

Like in Chapter 11, all the chages have been introduced already. Nothing new here.

## Chapter 13

Once again, the Clang assembler seems to want a slightly different syntax: Where gcc accepts

```
MUL V6.4H, V0.4H, V3.4H[0]
```

the Clang assembler expects

```
MUL.4H V6, V0, V3[0]
```

All other changes to the code should be trivial at this point.

## Chapter 14

No unusal changes here.

## Chapter 15

### Copying a Page of Memory

Some place to start reading ARM64 code in the Darwin Kernel can be found in [bcopy.s](https://github.com/apple/darwin-xnu/blob/master/osfmk/arm64/bcopy.s). There is a lot more in that directory and the repository in general.

### Code Created by GCC

No changes were required. The "tiny" code model is not supported for Mach-O excecutables:

```
% clang -O3 -mcmodel=tiny -o upper upper.c
fatal error: error in backend: tiny code model is only supported on ELF
```

## Chapter 16

All that can be said is that clang automatically enables position-independent executables, and the option `-no-pie` does not work. Therefore, the exploit shown in the `upper.s` file can not be reproduced.

## Additional references

* [Mach-O Programming Topics](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/MachOTopics/0-Introduction/introduction.html#//apple_ref/doc/uid/TP40001827-SW1), an excellent introduction to the Mach-O executable format and how it differs from ELF. Even if it still refrences PowerPC 64-Bit architecture and says nothing about ARM, most of it is still true.
* [What is required for a Mach-O executable to load?](https://stackoverflow.com/a/42399119/1600891)
* [Mac OS X Internals, A Systems Approach](https://www.pearson.ch/Informatik/Macintosh/EAN/9780134426549/Mac-OS-X-Internals) Amit Singh, 2007. For better or worse, this is still the definite compendium on the core of macOS and it's siblings.
* [Darwin Source Code](https://opensource.apple.com/source/xnu/)
* [ARM Archicture Reference Manual](https://static.docs.arm.com/ddi0487/ca/DDI0487C_a_armv8_arm.pdf)

## One More Thing…
_"The C language is case-sensitive. Compilers are case-sensitive. The Unix command line, ufs, and nfs file systems are case-sensitive. I'm case-sensitive too, especially about product names. The IDE is called Xcode. Big X, little c. Not XCode or xCode or X-Code. Remember that now."_ — Chris Espinosa
