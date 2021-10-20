.DEFAULT_GOAL := build

scaffold: CMakeLists.txt
	cmake -S . -B scaffold -G "Unix Makefiles"

.PHONY := build
build: scaffold
	cmake --build scaffold

.PHONY := run
run: build
ifeq ($(OS),Windows_NT)
	./scaffold/example-carp.exe
else
	./scaffold/example-carp
endif

.PHONY := clean
clean:
	rm -rf scaffold
