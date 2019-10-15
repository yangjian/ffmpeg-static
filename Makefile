# MUST update PATH so that x264 can find nasm
export PATH := $(shell pwd)/ffmpeg-full/release/bin:$(PATH)
export PATH := $(shell pwd)/ffmpeg-lite/release/bin:$(PATH)
export MACOSX_DEPLOYMENT_TARGET := 10.12

.PHONY: full lite build clean distclean

all: build

full:
	make -C ffmpeg-full build

lite:
	make -C ffmpeg-lite build

build: full lite

docker-image-debian-8:
	docker build -t ffmpeg-static-builder-debian-8 -f docker/debian-8.dockerfile .

docker-image-debian-9:
	docker build -t ffmpeg-static-builder-debian-9 -f docker/debian-9.dockerfile .

full-debian-8:
	docker run -it --rm -v "$(shell pwd)":/mount -e SRC_DIR=ffmpeg-full -e DST_DIR=/mount/ffmpeg-full/debian-8-output ffmpeg-static-builder-debian-8

lite-debian-8:
	docker run -it --rm -v "$(shell pwd)":/mount -e SRC_DIR=ffmpeg-lite -e DST_DIR=/mount/ffmpeg-lite/debian-8-output ffmpeg-static-builder-debian-8

clean:
	make -C ffmpeg-full clean
	make -C ffmpeg-lite clean

distclean:
	make -C ffmpeg-full distclean
	make -C ffmpeg-lite distclean
