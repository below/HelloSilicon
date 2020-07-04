HelloWorld: HelloWorld.o
	ld -arch arm64 -syslibroot $(shell xcrun -sdk macosx --show-sdk-path) -o HelloWorld HelloWorld.o -lSystem

HelloWorld.o: main.s
	as -arch arm64 -o HelloWorld.o main.s
