TOOLPATH = /usr/aarch64-linux-gnu/bin

HelloWorld: HelloWorld.o
	$(TOOLPATH)/ld -o HelloWorld HelloWorld.o

HelloWorld.o: HelloWorld.s
	$(TOOLPATH)/as -o HelloWorld.o HelloWorld.s
