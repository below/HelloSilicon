TOOLPATH = $(shell dirname $(shell xcodebuild -find clang))

HelloWorld: HelloWorld.o
	$(TOOLPATH)/ld -o HelloWorld HelloWorld.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64

HelloWorld.o: HelloWorld.s
	$(TOOLPATH)/as -o HelloWorld.o HelloWorld.s
