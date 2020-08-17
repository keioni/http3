# syntax = docker/dockerfile:1.1-experimental
#######################################################################
## build patched-openssl
#######################################################################
FROM alpine:3 AS build-openssl

LABEL maintaner="Kei Onimaru <otegami@devel.keys.jp>"

ARG PATCHED_BRANCH=OpenSSL_1_1_1g-quic-draft-29

RUN set -eux; \
    apk update && apk add --no-cache --virtual .build-deps \
        perl \
        make \
        gcc \
        git \
        musl-dev \
        pkgconf \
        linux-headers \
    ; \
    git clone --depth 1 -b $PATCHED_BRANCH https://github.com/tatsuhiro-t/openssl

ARG TARGETOS
ARG TARGETARCH

RUN set -eux; cd openssl; \
    if [ $TARGETARCH = "arm64" ]; then \
        arch="aarch64"; \
    else \
        arch="x86_64"; \
    fi; \
    ./Configure \
        no-aria \
        no-bf \
        no-blake2 \
        no-camellia \
        no-cast \
        no-cms \
        no-comp \
        no-deprecated \
        no-des \
        no-err \
        no-hw-padlock \
        no-gost \
        no-idea \
        no-md4 \
        no-psk \
        no-rc2 \
        no-rc4 \
        no-rmd160 \
        no-scrypt \
        no-sctp \
        no-seed \
        no-siphash \
        no-sm2 \
        no-sm3 \
        no-sm4 \
        no-srp \
        no-ssl \
        no-tests \
        no-tls1 \
        no-tls1_1 \
        no-tls1-method \
        no-tls1_1-method \
        no-ui-console \
        no-weak-ssl-ciphers \
        no-whirlpool \
        -Wl,-rpath=/usr/local/lib \
        -Os \
        linux-x86_64 \
    ; \
    make; \
    make install_sw; \
    cd ..; \
    rm -rf openssl; \
    apk del --no-network .build-deps



#######################################################################
## build nghttp3
#######################################################################
FROM alpine:3 AS build-nghttp3

RUN set -eux; \
    apk update && apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        libtool \
        gcc \
        git \
        g++ \
        make \
        libc-dev \
        pkgconf \
    ; \
    git clone --depth 1 https://github.com/ngtcp2/nghttp3

RUN set -eux;  cd nghttp3; \
    autoreconf -i -v; \
    ./configure --enable-lib-only CFLAGS=-Os CXXFLAGS=-Os; \
    make; \
    make install; \
    cd ..; \
    rm -rf nghttp3; \
    apk del --no-network .build-deps



#######################################################################
## build ngtcp2 and curl
#######################################################################
FROM alpine:3 AS build-curl

# ARG CURL_VERSION=curl-7.71.1
#
# RUN set -eux; curl_path=`echo -n $CURL_VERSION | sed -E 's/\./_/g'`; \
#     wget https://github.com/curl/curl/releases/download/$curl_path/$CURL_VERSION.tar.gz; \
#     tar zxvf $CURL_VERSION.tar.gz; \
#     mv $CURL_VERSION curl

RUN set -eux; apk update && apk add --virtual .build-deps \
        autoconf \
        automake \
        curl \
        libtool \
        gcc \
        git \
        g++ \
        make \
        libc-dev \
        nghttp2-dev \
        pkgconf \
        pcre-dev \
        libev-dev \
        zlib-dev \
    ; \
    git clone https://github.com/curl/curl.git; \
    git clone --depth 1 https://github.com/ngtcp2/ngtcp2

COPY --from=build-openssl /usr/local /usr/local/
COPY --from=build-nghttp3 /usr/local /usr/local/

RUN set -eux; cd ngtcp2; \
    autoreconf -i -v; \
    ./configure CFLAGS=-Os CXXFLAGS=-Os; \
    make; \
    make install; \
    cd ..

RUN set -eux; cd curl; \
    ./buildconf; \
    ./configure \
        CFLAGS=-Os \
        CPPFLAGS=-Os \
        LDFLAGS="-Wl,-rpath,/usr/local/lib" \
        PKG_CONFIG_PATH="/usr/local/lib/pkgconfig" \
        --enable-alt-svc \
        --disable-ftp \
        --disable-file \
        --disable-dict \
        --disable-ldap \
        --disable-ldaps \
        --disable-rtsp \
        --disable-telnet \
        --disable-tftp \
        --disable-pop3 \
        --disable-imap \
        --disable-smb \
        --disable-smtp \
        --disable-gopher \
        --disable-mqtt \
        --disable-manual \
        --disable-tls-srp \
        --disable-unix-sockets \
        --disable-http-auth \
        --disable-crypto-auth \
    ; \
    make; \
    make install; \
    cd ..; \
    rm -rf ngtcp2 curl; \
    apk del --no-network .build-deps



#######################################################################
## reduce container image size
#######################################################################
FROM alpine:3 AS reduce

COPY --from=build-curl /usr/local/bin /usr/local/bin/
COPY --from=build-curl /usr/local/lib /usr/local/lib/

RUN set -eux; apk add nghttp2-libs; \
    apk del musl-utils libc-utils

COPY reduce.sh /
RUN /reduce.sh



#######################################################################
## build the final image
#######################################################################
FROM scratch AS post-process

COPY --from=reduce /bin /bin/
COPY --from=reduce /sbin /sbin/
COPY --from=reduce /lib /lib/
COPY --from=reduce /etc /etc/
COPY --from=reduce /usr /usr/

RUN set -eux; mkdir /root /tmp /var

WORKDIR /usr/local/bin
CMD ["/bin/sh"]
