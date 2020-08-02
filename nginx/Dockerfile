
#######################################################################
## download nginx and quiche, and patch it.
#######################################################################
FROM alpine:3 as download

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
        pcre-dev \
        rust \
        tar \
        zlib-dev \
    ;

COPY --from=download /nginx /nginx
COPY --from=download /quiche /quiche

RUN set -eux; \
    cd /nginx; \
    ./configure --prefix=/usr/local/nginx --build=quiche-alpine --with-http_ssl_module --with-http_v2_module --with-http_v3_module --with-openssl=../quiche/deps/boringssl --with-quiche=../quiche; \
    make; \
    make install; \
    strip /usr/local/nginx/sbin/nginx; \
    cd ..; \
    rm -rf /nginx /quiche; \
    apk del --no-network .build-deps



#######################################################################
## make private key and self-signed certificate for localhost
#######################################################################
FROM alpine:3 as makecert

RUN set -eux; \
    apk update && apk add --no-cache openssl; \
    mkdir -p /usr/local/nginx/conf; \
    cd /usr/local/nginx/conf; \
    openssl genrsa 2048 > cert.key; \
    openssl req -new -subj "/CN=localhost" -key cert.key > cert.csr; \
    openssl x509 -days 3650 -req -signkey cert.key < cert.csr > cert.crt; \
    rm cert.csr; \
    apk del --no-network openssl



#######################################################################
## build the final image
#######################################################################
FROM alpine:3 AS post-process

ARG NGINX_PATH="/usr/local/nginx"

COPY --from=build $NGINX_PATH $NGINX_PATH
COPY --from=makecert $NGINX_PATH $NGINX_PATH

COPY nginx.conf nginx_http3_only.conf $NGINX_PATH/conf/
COPY nginx-runner /usr/local/sbin/

RUN set -eux; \
    apk update && apk add --virtual .nginx-rundeps pcre libgcc

EXPOSE 443/udp
EXPOSE 443/tcp

WORKDIR $NGINX_PATH

CMD ["nginx-runner"]

