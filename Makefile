.PHONY: release

all: release

export PATH := $(shell pwd)/release/bin:$(PATH)
export MACOSX_DEPLOYMENT_TARGET := 10.12

release:
	@mkdir -p release && cd release && cmake -DCMAKE_BUILD_TYPE=Release .. && make
	./tools/pack.sh

clean:
	@cd release && make clean

distclean:
	@rm -rf release
