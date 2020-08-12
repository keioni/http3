#!/bin/sh -x

set -eux

LOCAL_DIR="/usr/local"
BIN_DIR="$LOCAL_DIR/bin"
LIB_DIR="$LOCAL_DIR/lib"

rm -rf $BIN_DIR/openssl $BIN_DIR/c_rehash $BIN_DIR/curl-config
rm -rf $LIB_DIR/*.a $LIB_DIR/*.la $LIB_DIR/pkgconfig

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

rm -rf /usr/share $LOCAL_DIR/share
