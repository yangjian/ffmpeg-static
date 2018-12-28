#!/bin/bash

set -Eeuo pipefail

TOOL_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_PROJECT_DIR="$(dirname "$TOOL_DIR")"

BASE_DIR=$1
SRC_DIR="${BASE_DIR}/release"
OUT_DIR="${BASE_DIR}/output/ffmpeg"

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

