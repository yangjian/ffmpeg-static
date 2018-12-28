.PHONY: full lite release

all: release

# export PATH := $(shell pwd)/release/bin:$(PATH)
export MACOSX_DEPLOYMENT_TARGET := 10.12

full:
	@mkdir -p ffmpeg-full/release && cd ffmpeg-full/release && cmake -DCMAKE_BUILD_TYPE=Release .. && make
	./tools/pack.sh ffmpeg-full

lite:
	@mkdir -p ffmpeg-lite/release && cd ffmpeg-lite/release && cmake -DCMAKE_BUILD_TYPE=Release .. && make
	./tools/pack.sh ffmpeg-lite

release: full lite

clean:
	@cd ffmpeg-full/release && make clean
	@cd ffmpeg-lite/release && make clean

distclean:
	@rm -rf ffmpeg-full/release
	@rm -rf ffmpeg-lite/release
