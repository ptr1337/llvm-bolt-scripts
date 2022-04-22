#!/bin/bash

export TOPLEV=~/toolchain/llvm

Change your compiler PATH here to compare them

COMPIlER_PATH=${TOPLEV}/stage2-prof-use-lto/install/bin

export PATH=${COMPIlER_PATH}:${PATH}

mkdir -p measure-build-time || (echo "Could not create build-directory!"; exit 1)
cd measure-build-time
echo "== Clean old build-artifacts"
rm -r *

echo "== Configure reference Clang-build with tools from ${CPATH}"

  cmake 	-G Ninja \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$(pwd)/install" \
  -DCMAKE_C_COMPILER=${COMPIlER_PATH}/clang \
  -DCMAKE_CXX_COMPILER=${COMPIlER_PATH}/clang++ \
  -DLLVM_USE_LINKER=${COMPIlER_PATH}/lld \
  -DLLVM_ENABLE_PROJECTS="clang" \
  -DLLVM_PARALLEL_COMPILE_JOBS="$(nproc)"\
  -DLLVM_PARALLEL_LINK_JOBS="$(nproc)" \
  ../llvm-project/llvm || (echo "Could not configure project!"; exit 1)

echo
echo "== Start Build"
time ninja clang || (echo "Could not build project!"; exit 1)
