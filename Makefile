.DEFAULT_GOAL := build

scaffold: CMakeLists.txt
	cmake -S . -B scaffold -G "Unix Makefiles"

.PHONY := build
build: scaffold
	cmake --build scaffold

.PHONY := run
run: build
	./scaffold/example-carp

.PHONY := clean
clean:
	rm -rf scaffold

