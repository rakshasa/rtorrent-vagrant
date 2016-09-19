#!/bin/bash

# TODO: Replace with a shared build/package script.

set +x

export CXX="g++-4.8"
export CXX_FLAGS="-Wno-strict-aliasing"

# Build libTorrent.
cd /data/libtorrent

./autogen.sh && ./configure --enable-extra-debug --enable-werror && make && sudo make install || exit 1

# Build rTorrent.
cd /data/rtorrent

./autogen.sh && ./configure --enable-extra-debug --enable-werror --with-xmlrpc-c && make && sudo make install || exit 1
