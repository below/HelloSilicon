HelloWorld: HelloWorld.o
	ld -o HelloWorld HelloWorld.o -syslibroot /Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk -lSystem

HelloWorld.o: main.s
	as -o HelloWorld.o main.s
