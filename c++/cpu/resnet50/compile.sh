#!/bin/bash
set +x
set -e

work_path=${PWD}

# 1. check paddle_inference exists
if [ ! -d "${work_path}/../../lib/paddle_inference" ]; then
  echo "Please download paddle_inference lib and move it in Paddle-Inference-Demo/lib"
  exit 1
fi

# 2. check CMakeLists exists
if [ ! -f "${work_path}/CMakeLists.txt" ]; then
  cp -a "${work_path}/../../lib/CMakeLists.txt" "${work_path}/"
fi

# 3. compile
mkdir -p build
cd build
rm -rf *

# same with the resnet50_test.cc
DEMO_NAME=resnet50_test

WITH_MKL=ON
WITH_ONNXRUNTIME=OFF
WITH_OPENVINO=OFF
WITH_ARM=OFF
WITH_MIPS=OFF
WITH_LOONGARCH=OFF
WITH_SW=OFF
WITH_SHARED_PHI=ON

LIB_DIR=${work_path}/../../lib/paddle_inference

cmake .. -DPADDLE_LIB=${LIB_DIR} \
  -DDEMO_NAME=${DEMO_NAME} \
  -DWITH_MKL=${WITH_MKL} \
  -DWITH_ONNXRUNTIME=${WITH_ONNXRUNTIME} \
  -DWITH_OPENVINO=${WITH_OPENVINO} \
  -DWITH_ARM=${WITH_ARM} \
  -DWITH_MIPS=${WITH_MIPS} \
  -DWITH_LOONGARCH=${WITH_LOONGARCH} \
  -DWITH_SW=${WITH_SW} \
  -DWITH_STATIC_LIB=OFF \
  -DWITH_SHARED_PHI=${WITH_SHARED_PHI}

if [ "$WITH_ARM" == "ON" ];then
  make TARGET=ARMV8 -j
else
  make -j
fi
