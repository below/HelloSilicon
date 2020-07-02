HelloWorld: HelloWorld.o
	ld -o HelloWorld HelloWorld.o -static

HelloWorld.o: HelloWorld.s
	as -o HelloWorld.o HelloWorld.s
