FROM alpine:3 AS download

RUN set -eux; \
    apk update && apk add --no-cache git; \
    git clone --depth 1 -b OpenSSL_1_1_1g-quic-draft-29 https://github.com/tatsuhiro-t/openssl; \
    git clone --depth 1 https://github.com/ngtcp2/nghttp3; \
    git clone --depth 1 https://github.com/ngtcp2/ngtcp2; \
    git clone --depth 1 https://github.com/curl/curl; \
    apk del --no-network git


FROM alpine:3 AS build-openssl

COPY --from=download /openssl /openssl/

RUN set -eux; \
    apk update && apk add --no-cache --virtual .build-deps \
        perl \
        make \
        gcc \
        musl-dev \
        linux-headers \
    ; \
    \
    cd openssl; \
    ./config -Wl,-rpath=/usr/local/lib; \
    make; \
    make install_sw; \
    \
    cd ..; \
    rm -rf openssl; \
    apk del --no-network .build-deps


FROM alpine:3 AS build-nghttp3

COPY --from=download /nghttp3 /nghttp3/

RUN set -eux; \
    apk update && apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        libtool \
        gcc \
        g++ \
        make \
        libc-dev \
        pkgconf \
    ; \
    \
    cd nghttp3; \
    autoreconf -i -v; \
    ./configure --enable-lib-only; \
    make; \
    make install; \
    \
    cd ..; \
    rm -rf nghttp3; \
    apk del --no-network .build-deps


FROM alpine:3 AS build

COPY --from=download /ngtcp2 /ngtcp2/
COPY --from=download /curl /curl/
COPY --from=build-openssl /usr/local/ /usr/local/
COPY --from=build-nghttp3 /usr/local/ /usr/local/

RUN set -eux; \
    apk update && apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        libtool \
        gcc \
        g++ \
        make \
        libc-dev \
        nghttp2-dev \
        pkgconf \
        pcre-dev \
        libev-dev \
        zlib-dev \
    ; \
    \
    cd ngtcp2; \
    autoreconf -i -v; \
    ./configure; \
    make; \
    make install; \
    cd ..; \
    \
    cd curl; \
    ./buildconf; \
    ./configure LDFLAGS="-Wl,-rpath,/usr/local/lib" PKG_CONFIG_PATH="/usr/local/lib/pkgconfig" --enable-alt-svc; \
    make; \
    make install; \
    cd ..; \
    \
    rm -rf ngtcp2 curl; \
    apk del --no-network .build-deps


FROM alpine:3 AS reduce

COPY --from=build /usr/local/bin /usr/local/bin/
COPY --from=build /usr/local/lib /usr/local/lib/

RUN set -eux; \
    apk add --no-cache binutils; \
    \
    cd /usr/local; \
    rm -rf \
        ./bin/openssl \
        ./lib/*.a \
        ./lib/*.la \
        ./lib/pkgconfig \
    ; \
    find ./lib -type f -executable | xargs strip; \
    strip ./bin/curl; \
    \
    apk del --no-network binutils


FROM alpine:3

COPY --from=reduce /usr/local/ /usr/local/

RUN set -eux; \
    apk add --virtual .nginx-rundeps nghttp2-libs

WORKDIR /usr/local/bin
CMD ["/bin/sh"]

