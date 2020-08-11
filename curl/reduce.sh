#!/bin/sh -x

set -eux

LOCAL_DIR="/usr/local"
BIN_DIR="$LOCAL_DIR/bin"
LIB_DIR="$LOCAL_DIR/lib"

rm -f $BIN_DIR/openssl
rm -f $BIN_DIR/c_rehash
rm -f $BIN_DIR/curl-config
rm -f $LIB_DIR/*.a
rm -f $LIB_DIR/*.la
rm -rf $LIB_DIR/pkgconfig

apk add --no-cache binutils
find $LOCAL_DIR -type f -executable | xargs strip
apk del --no-network binutils

rm /lib/libcrypto.so.1.1
ln -sf $LIB_DIR/libcrypto.so.1.1 /lib
ln -sf $LIB_DIR/libcrypto.so.1.1 /usr/lib
rm /lib/libssl.so.1.1
ln -sf $LIB_DIR/libssl.so.1.1 /lib
ln -sf $LIB_DIR/libssl.so.1.1 /usr/lib
rm -rf /usr/lib/engines-1.1
ln -sf $LIB_DIR/engines-1.1 /usr/lib

apk add nghttp2-libs
apk del musl-utils libc-utils

rm -rf /usr/share $LOCAL_DIR/share
