# MUST update PATH so that x264 can find nasm
export PATH := $(shell pwd)/ffmpeg-full/release/bin:$(PATH)
export PATH := $(shell pwd)/ffmpeg-lite/release/bin:$(PATH)
export MACOSX_DEPLOYMENT_TARGET := 10.12

.PHONY: full lite release clean distclean

all: release

full:
	mkdir -p ffmpeg-full/release && cd ffmpeg-full/release && cmake -DCMAKE_BUILD_TYPE=Release .. && make
	./tools/pack.sh ffmpeg-full

lite:
	mkdir -p ffmpeg-lite/release && cd ffmpeg-lite/release && cmake -DCMAKE_BUILD_TYPE=Release .. && make
	./tools/pack.sh ffmpeg-lite

release: full lite

clean:
	-test -d ffmpeg-full/release && cd ffmpeg-full/release && make clean
	-test -d ffmpeg-lite/release && cd ffmpeg-lite/release && make clean

distclean:
	rm -rf ffmpeg-full/release
	rm -rf ffmpeg-lite/release
