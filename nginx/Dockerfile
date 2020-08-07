# syntax = docker/dockerfile:experimental
#######################################################################
## download nginx and quiche, and patch it.
#######################################################################
FROM alpine:3 as download

LABEL maintaner="Kei Onimaru <otegami@devel.keys.jp>"

RUN set -eux; \
    apk update && apk add --no-cache --virtual .build-deps \
        curl \
        git \
        patch \
        tar \
    ; \
    \
    curl -O https://nginx.org/download/nginx-1.16.1.tar.gz; \
    tar zxvf nginx-1.16.1.tar.gz; \
    git clone --depth 1 --recursive https://github.com/cloudflare/quiche; \
    cd nginx-1.16.1; \
    patch -p01 < ../quiche/extras/nginx/nginx-1.16.patch; \
    cd ..; \
    mv nginx-1.16.1 nginx; \
    apk del --no-network .build-deps



#######################################################################
## build nginx with quiche
#######################################################################
FROM alpine:3 AS build

RUN set -eux; \
    apk update && apk add --no-cache --virtual .build-deps \
        binutils \
        cargo \
        cmake \
        curl \
        gcc \
        g++ \
        make \
        nghttp2-dev \
        openssl \
        pcre-dev \
        rust \
        tar \
        zlib-dev \
    ;

COPY --from=download /nginx /nginx
COPY --from=download /quiche /quiche

RUN set -eux; \
    cd /nginx; \
    ./configure \
        --prefix=/usr/local/nginx \
        --build=quiche-alpine \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_v3_module \
        --with-openssl=../quiche/deps/boringssl \
        --with-quiche=../quiche \
    ; \
    make; \
    make install; \
    strip /usr/local/nginx/sbin/nginx; \
    ; \
    cd /usr/local/nginx/conf; \
    openssl genrsa 2048 > cert.key; \
    chmod 600 cert.key; \
    openssl req -new -subj "/CN=localhost" -key cert.key > cert.csr; \
    openssl x509 -days 3650 -req -signkey cert.key < csr > cert.crt; \
    rm cert.csr; \
    \
    rm -rf /nginx /quiche; \
    apk del --no-network .build-deps



#######################################################################
## build the final image
#######################################################################
FROM alpine:3 AS post-process

LABEL maintaner="Kei Onimaru <otegami@devel.keys.jp>"
LABEL name="nginx-http3"
LABEL docker.cmd="docker run -dit keioni/nginx-http3"

ARG NGINX_PATH="/usr/local/nginx"

COPY --from=build /usr/local/nginx $NGINX_PATH
COPY ./conf $NGINX_PATH/conf
COPY ./nginx-runner $NGINX_PATH/sbin

RUN set -eux; apk update && apk add --virtual .nginx-rundeps pcre libgcc

EXPOSE 80/tcp 443/tcp 443/udp

ENV IPv6=yes
ENV HTTP3_ONLY=no

ENV PATH=$NGINX_PATH/sbin:$PATH
WORKDIR $NGINX_PATH

CMD ["nginx-runner"]
