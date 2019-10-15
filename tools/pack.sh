#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "usage: pack.sh SRC_DIR DST_DIR"
    exit 1
fi

set -Eeuo pipefail

TOOL_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_PROJECT_DIR="$(dirname "$TOOL_DIR")"

SRC_DIR="$1"
DST_DIR="$2"
OUT_DIR=${DST_DIR}/ffmpeg

rm -rf ${OUT_DIR}
mkdir -p ${OUT_DIR}/bin ${OUT_DIR}/lib ${OUT_DIR}/include

rm -rf ${SRC_DIR}/include/freetype2/freetype/freetype2

echo "copying executable binary files ..."
cp -r ${SRC_DIR}/bin/ffmpeg ${OUT_DIR}/bin/
cp -r ${SRC_DIR}/bin/ffprobe ${OUT_DIR}/bin/

echo "copying library files ..."
cp -r ${SRC_DIR}/lib/*.a ${OUT_DIR}/lib/

echo "copying header files ..."
cp -r ${SRC_DIR}/include/* ${OUT_DIR}/include/

echo "done"
echo "${OUT_DIR} is ready to publish"

