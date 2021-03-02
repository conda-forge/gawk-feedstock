#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./extension/build-aux
cp $BUILD_PREFIX/share/gnuconfig/config.* .
set -eux

# Ensure the timestamp dependencies do not cause us to need
# to run autoreconf-y stuff (which I tried but it is not in
# a working state at present with gawk 4.2.1).
mv "bootstrap.sh?h=${PKG_NAME}-${PKG_VERSION}" bootstrap.sh
chmod +x ./bootstrap.sh
./bootstrap.sh

./configure --prefix="${PREFIX}" \
            --with-readline="${PREFIX}"

make -j${CPU_COUNT} AM_V=99

rm test/localenl.*

# These tests fail under emulation, still run them but ignore their result
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
  if [[ ${target_platform} == linux-aarch64 ]]; then
    make check || true
  elif [[ ${target_platform} == linux-ppc64le ]]; then
    make check || true
  else
    make check
  fi
fi

make install
