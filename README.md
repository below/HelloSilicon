# HelloSilicon
An attempt with assembly on the machine we must not speak about

## Latest News

For now, I am throwing in the towel on [Chapter 7](https://github.com/below/HelloSilicon#chapter-7).

## Introduction

In this repository, I will code along with the book [Programming with 64-Bit ARM Assembly Language](https://www.apress.com/gp/book/9781484258804), adjusting all sample code for a new platform that might be very, very popular soon. The original sourcecode can be found [here](https://github.com/Apress/programming-with-64-bit-ARM-assembly-language).

Below I will document the required changes

## Listing 1-1

To make "Hello World" run on the MWMNSA, first the changes from page 78 have to be applied to account for the differences between the Darwin and the Linux kernel.
The next trick is to insert `.align 2` (or `.p2align 2`), because Darwin likes things to be aligned on even boundaries. Thanks to @m-schmidt and @zhuowei!

To make the linker work, a little more is needed, that should be known to Mac developers. The complete call to the linker looks like this:
```
ld -o HelloWorld HelloWorld.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64
```

We know the `-o` switch, let's examine the others:


* `-lSystem` tells the linker to link our executable with `libSystem.dylib`. We do that to add the `LC_MAIN` load command to the executable. Generally, Darwin does not support [statically linked executables](https://developer.apple.com/library/archive/qa/qa1118/_index.html). It is [possible](https://stackoverflow.com/questions/32453849/minimal-mach-o-64-binary/32659692#32659692), if not especially elegant to create executables without using `libSystem.dylib`. I will go deeper into that topic when time permits. For people who read _Mac OS X Internals_ I will just add that this replaced `LC_UNIXTHREAD` as of MacOS X 10.7. 
* `-sysroot`: In order to find `libSystem.dylib`, is it mandatory to tell our linker where to find it. It seems this was not necessary on macOS 10.15 because _"New in macOS Big Sur 11 beta, the system ships with a built-in dynamic linker cache of all system-provided libraries. As part of this change, copies of dynamic libraries are no longer present on the filesystem."_. We use `xcrun -sdk macosx --show-sdk-path` to dynamically use the currently active version of Xcode.
* `-e _start`: Darwin expects an entrypoint `_main`. In order to keep the sample both as close as possible to the book, and to allow it's use with in the C-Sample from _Chapter 3_, I opted to keep `_start` and tell the linker that this is the entry point we want to use
* `-arch arm64` for good measure, let's throw in the option to cross-compile this from an Intel Mac

## Listing 2-1

Other than adding `.align 2` to silence the warning, it appears that the Clang assembler does not understand the `MOV X1, X2, LSL #1` alias, but requires `LSL X1, X2, #1`. If anyone has a hint where I can find the Clang assembly syntax reference guide, I'd be happy if you'd let me know.

Also, of course, exit call and the makefile had to be adjusted like in _Listing 1-1_.

## Listing 2-3, Listing 2-4

The exit call must be adjusted.

Please note that I have not yet update the ´codesnippets.s` file. Here Clang apparently also does not like the syntax.

## Listing 3-7

While it is of course possible to call our method from an App, I chose to simply create a Command Line Tool, which is now using the same `HelloWorld.s` file.
Thankfully @saagarjha [suggested](https://github.com/below/HelloSilicon/issues/5) how it would be possible to build the sample with Xcode _without_ `libc`, and I might come back to try that later.
Until then, I have removed the _AsMain_ target.

## Listing 4-8

Besides the changes that are common, we face a new issue, which is described in the book in Chapter 5: Darwin does not like `LSR X1, =symbol`, and in the case of `ASR X1, symbol` our data has to be in the read-only `.text` section. In this sample, we want writable data. 

On Darwin "All local and small data is accessed directly using addressing that’s relative to the instruction pointer (RIP-relative addressing). All large or possibly nonlocal data is accessed indirectly through a global offset table (GOT) entry. The GOT entry is accessed directly using RIP-relative addressing." [Apple Documentation](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/MachOTopics/1-Articles/x86_64_code.html#//apple_ref/doc/uid/TP40005044-SW1)

Thankfully, @claui pointed me to the working solution: 

```
ADRP X1, hexstr@GOTPAGE
```
[ARM Documentation](https://developer.arm.com/documentation/dui0802/b/A64-General-Instructions/ADRP)

## Listing 5-10

Changes like in Chapter 4, and the `quad`, `octa` and `fill` keywords apparently must be in lowercase for the llvm as. (See bottom of this file)

## Listing 6-3 to 6-5

Learned something new: `@GOTPAGE` operand worked for us, but only by chance: It gave us the base address of the Global Offest Table. When we debug the `upper` sample from Chapter 5, we see that actually the `instr` is converted in place, and the `outstr` is not touched.

The correct answer can be found [here](https://reverseengineering.stackexchange.com/a/15324): _"The `ADRP` instruction loads the address of the 4KB page anywhere in the +/-4GB (33 bits) range of the current instruction (which takes 21 high bits of the offset). This is denoted by the `@PAGE` operator. then, we can either use `LDR` or `STR` to read or write any address inside that page or `ADD` to to calculate the final address using the remaining 12 bits of the offset (denoted by `@PAGEOFF`)."_

So this: 
```
	LDR	X1, =outstr // address of output string
```

becomes this:
```
	ADRP	X1, outstr@PAGE	// address of output string
	ADD	X1, X1, outstr@PAGEOFF
```

Unrelated, the Darwin `write` system call apparently requires the length of the output to be stored in `X2`, whereas this is either a bug in the original code (unlikely), or Linux can work with zero-termination:
```
	MOV	X2, X0	// First, save the length into X2
```

## Chapter 7

As of right now, I will skip this chapter. Linux, by design, is made for tinkering, and Darwin is not. `unistd.h` is not part of the userland MacOS SDK, and the whole system call mechanism is considered private and subject to change. As @sagaarjha said: _"Go used to create static binaries on macOS but they would constantly break whenever an update came out"_.

When I find the time I may look deeper into this. Or maybe someone else wants to?

## Listing 10-4, 10-5
No changes in the core code were required, but I created a SwiftUI app that will work on macOS, iOS, and later on watchOS and tvOS, too.

## Additional references

* [What is required for a Mach-O executable to load?](https://stackoverflow.com/a/42399119/1600891)
* Mac OS X Internals, A Systems Approach. Amit Singh, 2007 
* [Darwin Source Code](https://opensource.apple.com/source/xnu/)

## One More Thing…
"The C language is case-sensitive. Compilers are case-sensitive. The Unix command line, ufs, and nfs file systems are case-sensitive. I'm case-sensitive too, especially about product names. The IDE is called Xcode. Big X, little c. Not XCode or xCode or X-Code. Remember that now."
_— Chris Espinosa_
