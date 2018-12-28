PROJECT(ffmpeg_lite_static)

CMAKE_MINIMUM_REQUIRED(VERSION 3.2)

set(POSITION_INDEPENDENT_CODE TRUE)

INCLUDE(ExternalProject)

INCLUDE_DIRECTORIES(BEFORE ${CMAKE_BINARY_DIR}/include)
LINK_DIRECTORIES(${CMAKE_BINARY_DIR}/lib)

SET(ENV{PATH} ${CMAKE_BINARY_DIR}/bin:$ENV{PATH})
SET(ENV{PKG_CONFIG_PATH} ${CMAKE_BINARY_DIR}/lib/pkgconfig)

if(APPLE)
    SET(OPENSSL_ARCH "darwin64-x86_64-cc")
else(APPLE)
    SET(OPENSSL_ARCH "linux-x86_64")
endif(APPLE)

EXTERNALPROJECT_ADD(
  nasm
  # URL http://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.bz2
  URL ${CMAKE_SOURCE_DIR}/../vendor/nasm-2.13.03.tar.bz2
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR}
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  gperf
  URL http://ftp.gnu.org/pub/gnu/gperf/gperf-3.1.tar.gz
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR}
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  zlib
  URL https://github.com/madler/zlib/archive/v1.2.11.tar.gz
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --static
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  libpng
  DEPENDS zlib
  URL https://download.sourceforge.net/libpng/libpng-1.6.36.tar.gz
  CONFIGURE_COMMAND CFLAGS=-I${CMAKE_BINARY_DIR}/include CPPFLAGS=-I${CMAKE_BINARY_DIR}/include LDFLAGS=-L${CMAKE_BINARY_DIR}/lib ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --enable-static
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  fdkaac
  URL http://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-2.0.0.tar.gz
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --enable-static
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  x264
  DEPENDS nasm
  GIT_REPOSITORY http://git.videolan.org/git/x264.git
  GIT_TAG 545de2ffec6ae9a80738de1b2c8cf820249a2530
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --bit-depth=8 --chroma-format=all --enable-static --enable-lto --enable-pic --enable-strip --disable-cli --disable-gpl --disable-avs --disable-ffms --disable-swscale --disable-gpac --disable-lsmash
  BUILD_COMMAND make
  BUILD_ALWAYS 0
  BUILD_IN_SOURCE 1
)

SET(FFMPEG_COMPONENTS --disable-everything --disable-postproc --disable-doc --disable-debug)
LIST(APPEND FFMPEG_COMPONENTS --disable-indevs --disable-outdevs --disable-ffplay --disable-sdl2 --disable-lzma --disable-iconv)
LIST(APPEND FFMPEG_COMPONENTS --enable-gpl --enable-nonfree --enable-pic --enable-lto)
LIST(APPEND FFMPEG_COMPONENTS --enable-libfdk-aac --enable-libx264 --enable-ffmpeg --enable-ffprobe)
LIST(APPEND FFMPEG_COMPONENTS --enable-avcodec --enable-avformat --enable-avfilter --enable-swresample --enable-swscale)
LIST(APPEND FFMPEG_COMPONENTS --enable-demuxer=mov,mpegts)
LIST(APPEND FFMPEG_COMPONENTS --enable-muxer=rawvideo,mp4,mov,mpegts,dash,hls,segment,tee)
LIST(APPEND FFMPEG_COMPONENTS --enable-decoder=h264 --enable-decoder=aac)
LIST(APPEND FFMPEG_COMPONENTS --enable-encoder=libx264,libfdk_aac,png)
LIST(APPEND FFMPEG_COMPONENTS --enable-filter=copy,concat,scale,split,setpts)
LIST(APPEND FFMPEG_COMPONENTS --enable-bsf=h264_mp4toannexb --enable-parser=h264)
LIST(APPEND FFMPEG_COMPONENTS --enable-protocol=file,pipe,unix,concat)
LIST(APPEND FFMPEG_COMPONENTS --extra-cflags=-I${CMAKE_BINARY_DIR}/include --extra-ldflags=-L${CMAKE_BINARY_DIR}/lib --extra-libs=-lpng\ -lz\ -lstdc++\ -lm\ -ldl)

EXTERNALPROJECT_ADD(
  ffmpeg
  DEPENDS nasm fdkaac x264 libpng
  URL http://www.ffmpeg.org/releases/ffmpeg-4.1.tar.bz2
  CONFIGURE_COMMAND PKG_CONFIG_PATH=$ENV{PKG_CONFIG_PATH} ./configure --prefix=${CMAKE_BINARY_DIR} --datadir=${CMAKE_BINARY_DIR}/etc ${FFMPEG_COMPONENTS}
  BUILD_COMMAND make
  BUILD_ALWAYS 0
  BUILD_IN_SOURCE 1
)
