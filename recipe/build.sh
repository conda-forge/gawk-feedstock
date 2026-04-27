#!/usr/bin/env bash
set -eux

# Ensure the timestamp dependencies do not cause us to need
# to run autoreconf-y stuff (which I tried but it is not in
# a working state at present with gawk 4.2.1).
mv "bootstrap.sh?h=${PKG_NAME}-${PKG_VERSION}" bootstrap.sh
chmod +x ./bootstrap.sh
./bootstrap.sh

./configure \
  --prefix="${PREFIX}" \
  --with-readline="${PREFIX}"

make "-j${CPU_COUNT}" AM_V=99

rm test/localenl.*

make check

make install
