# MUST update PATH so that x264 can find nasm
export PATH := $(shell pwd)/build/bin:$(PATH)
export MACOSX_DEPLOYMENT_TARGET := 10.12
export CMAKE_OSX_ARCHITECTURES := x86_64

.PHONY: all build clean distclean

all: build

build:
	mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && $(MAKE) -j4
	../tools/pack.sh "$(shell pwd)/build" "$(shell pwd)/output"

clean:
	-test -d build && cd build && make clean

distclean:
	rm -rf build output
