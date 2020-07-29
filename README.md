# Curl and Nginx with HTTP/3 support

## Details (only Japanese)

HTTP/3 対応の curl を作る - Qiita<br>
https://qiita.com/keys/items/611d949ca26d6ca848c2

HTTP/3 対応の nginx を作る - Qiita<br>
https://qiita.com/keys/items/bf492ef543fde3d8d822

## curl

pached openssl + nghttp3 + ngtcp2

### How to build

I **strongly** recommend using BuildKit.

```
DOCKER_BUILDKIT=1 docker build -t image_name:tag .
```

### How to use

```
docker run --rm image_name:tag curl -s -v --http3 https://quic.tech:8443
```

IMPORTANT: `--alt-svc` is not working. alt-svc cache was made in ephemeral container. If you try to test `--alt-svc`, do not run without `--rm` option and `exec` into the container.

## nginx

nginx + quiche

### How to build

I **strongly** recommend using BuildKit.

```
DOCKER_BUILDKIT=1 docker build -t image_name:tag .
```

# Welcome!

Feel free to contact us with anything!

otegami@devel.keys.jp or [my twitter](https://twitter.com/keionim).
