PROJECT(ffmpeg_static)

CMAKE_MINIMUM_REQUIRED(VERSION 3.2)

INCLUDE(ExternalProject)

INCLUDE_DIRECTORIES(BEFORE ${CMAKE_BINARY_DIR}/include)
LINK_DIRECTORIES(${CMAKE_BINARY_DIR}/lib)

SET(ENV{PATH} ${CMAKE_BINARY_DIR}/bin:$ENV{PATH})
SET(ENV{PKG_CONFIG_PATH} ${CMAKE_BINARY_DIR}/lib/pkgconfig)

if(APPLE)
    SET(OPENSSL_ARCH "darwin64-x86_64-cc")
    SET(FFMPEG_CONFIG_ARGS "")
else(APPLE)
    SET(OPENSSL_ARCH "linux-x86_64")
    SET(FFMPEG_CONFIG_ARGS "--extra-libs=-luuid")
endif(APPLE)

SET_PROPERTY(GLOBAL PROPERTY DOWNLOAD_NO_PROGRESS 1)
SET_PROPERTY(GLOBAL PROPERTY BUILD_ALWAYS 0)

EXTERNALPROJECT_ADD(
  yasm
  URL http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR}
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  nasm
  # URL http://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.bz2
  URL ${CMAKE_SOURCE_DIR}/vendor/nasm-2.13.03.tar.bz2
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR}
  DOWNLOAD_NO_PROGRESS 0
  BUILD_ALWAYS 0
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  gperf
  URL http://ftp.gnu.org/pub/gnu/gperf/gperf-3.1.tar.gz
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR}
  DOWNLOAD_NO_PROGRESS 0
  BUILD_ALWAYS 0
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  zlib
  URL https://github.com/madler/zlib/archive/v1.2.11.tar.gz
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --static
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  bzip2
  URL http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz
  URL_MD5 00b516f4704d4a7cb50a1d97e6e8e15b
  CONFIGURE_COMMAND ""
  INSTALL_COMMAND make install PREFIX=${CMAKE_BINARY_DIR}
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  libpng
  DEPENDS zlib
  URL https://download.sourceforge.net/libpng/libpng-1.6.34.tar.gz
  CONFIGURE_COMMAND CFLAGS=-I${CMAKE_BINARY_DIR}/include CPPFLAGS=-I${CMAKE_BINARY_DIR}/include LDFLAGS=-L${CMAKE_BINARY_DIR}/lib ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --enable-static
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  openssl
  URL http://www.openssl.org/source/openssl-1.0.2-latest.tar.gz
  CONFIGURE_COMMAND ./Configure ${OPENSSL_ARCH} no-shared no-idea no-mdc2 no-rc5 --prefix=${CMAKE_BINARY_DIR}
  BUILD_COMMAND make depend && make
  INSTALL_COMMAND make install_sw
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  fdkaac
  URL http://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.5.tar.gz
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --enable-static
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  lame
  URL https://newcontinuum.dl.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  libogg
  URL http://downloads.xiph.org/releases/ogg/libogg-1.3.3.tar.gz
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  speex
  DEPENDS libogg
  URL http://downloads.xiph.org/releases/speex/speex-1.2.0.tar.gz
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --enable-sse --disable-oggtest --with-ogg=${CMAKE_BINARY_DIR}
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  libvorbis
  DEPENDS libogg
  URL http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.6.tar.gz
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --disable-oggtest
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  opus
  URL https://archive.mozilla.org/pub/opus/opus-1.2.1.tar.gz
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --disable-doc
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  x264
  DEPENDS nasm
  GIT_REPOSITORY http://git.videolan.org/git/x264.git
  GIT_TAG 7d0ff22e8c96de126be9d3de4952edd6d1b75a8c
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --enable-static
  BUILD_COMMAND make
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  freetype
  DEPENDS bzip2 libpng gperf
  URL https://download.savannah.gnu.org/releases/freetype/freetype-2.9.tar.bz2
  CONFIGURE_COMMAND PKG_CONFIG_PATH=$ENV{PKG_CONFIG_PATH} ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --enable-static
  INSTALL_COMMAND make install && ln -s ${CMAKE_BINARY_DIR}/include/freetype2 ${CMAKE_BINARY_DIR}/include/freetype2/freetype
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  fribidi
  URL https://github.com/fribidi/fribidi/releases/download/0.19.7/fribidi-0.19.7.tar.bz2
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --enable-static
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  expat
  URL http://downloads.sourceforge.net/project/expat/expat/2.2.0/expat-2.2.0.tar.bz2
  CONFIGURE_COMMAND PKG_CONFIG_PATH=$ENV{PKG_CONFIG_PATH} ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --enable-static
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  fontconfig
  DEPENDS freetype expat
  URL https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.93.tar.gz
  CONFIGURE_COMMAND PKG_CONFIG_PATH=$ENV{PKG_CONFIG_PATH} ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --enable-static
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  libass
  DEPENDS nasm freetype fribidi fontconfig
  URL https://github.com/libass/libass/releases/download/0.13.7/libass-0.13.7.tar.gz
  CONFIGURE_COMMAND PKG_CONFIG_PATH=$ENV{PKG_CONFIG_PATH} ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --enable-static
  BUILD_COMMAND make
  BUILD_IN_SOURCE 1
)

EXTERNALPROJECT_ADD(
  ffmpeg
  DEPENDS yasm nasm fdkaac lame libogg speex libvorbis opus x264 freetype libass openssl libpng
  URL http://www.ffmpeg.org/releases/ffmpeg-3.4.2.tar.bz2
  CONFIGURE_COMMAND PKG_CONFIG_PATH=$ENV{PKG_CONFIG_PATH} ./configure --prefix=${CMAKE_BINARY_DIR} --datadir=${CMAKE_BINARY_DIR}/etc --disable-doc --disable-debug --disable-outdevs --disable-ffplay --disable-ffserver --disable-sdl2 --disable-lzma --disable-iconv --enable-gpl --enable-version3 --enable-nonfree --enable-libfdk-aac --enable-libmp3lame --enable-libspeex --enable-libx264 --enable-libopus --enable-libfreetype --enable-libass --enable-openssl --extra-cflags=-I${CMAKE_BINARY_DIR}/include --extra-ldflags=-L${CMAKE_BINARY_DIR}/lib --extra-libs=-lstdc++ --extra-libs=-lm --extra-libs=-lz --extra-libs=-lexpat --extra-libs=-lpng --extra-libs=-ldl ${FFMPEG_CONFIG_ARGS}
  BUILD_COMMAND make
  BUILD_IN_SOURCE 1
)
