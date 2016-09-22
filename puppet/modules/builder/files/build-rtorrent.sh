#!/bin/bash

export CXX="g++-4.8"
export CXXFLAGS="-Wno-error=strict-aliasing -I/data/shared/pkg/usr/local/include"
export PKG_CONFIG_PATH="/data/shared/pkg/usr/local/lib/pkgconfig"
export LD_LIBRARY_PATH="/data/shared/pkg/usr/local/lib:$LD_LIBRARY_PATH"

export BUILD_DIR=/data/shared/pkg/

# Build libTorrent.
cd /data/local/libtorrent
./autogen.sh && ./configure && make || exit 1
sudo DESTDIR=$BUILD_DIR make install || exit 1

# Build rTorrent.
cd /data/local/rtorrent
./autogen.sh && ./configure && make || exit 1
sudo DESTDIR=$BUILD_DIR make install || exit 1
