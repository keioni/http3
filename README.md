# Curl and Nginx with HTTP/3 support

## Details (Japanese)

HTTP/3 対応の curl を作る - Qiita<br>
https://qiita.com/keys/items/611d949ca26d6ca848c2

HTTP/3 対応の nginx を作る - Qiita<br>
https://qiita.com/keys/items/bf492ef543fde3d8d822

# Pull Container Image from docker hub

## curl

https://hub.docker.com/r/keioni/curl-http3

```
docker pull keioni/curl-http3
```

## nginx

https://hub.docker.com/r/keioni/nginx-http3

```
docker pull keioni/nginx-http3
```

# How to use Dockerfile

## Build from

**IMPORTANT**: I strongly recommend using BuildKit.

```
DOCKER_BUILDKIT=1 docker build -t image_name:tag .
```

# Usage

## curl

```
docker run --rm keioni/curl-http3 curl -s -v --http3 https://quic.tech:8443
```

IMPORTANT: `--alt-svc` is not working. alt-svc cache was made in ephemeral container. If you try to test `--alt-svc`, do not run without `--rm` option and `exec` into the container.

## nginx

```
docker run --dit keioni/nginx-http3
```

# Welcome!

Feel free to contact us with anything!

otegami@devel.keys.jp or [my twitter](https://twitter.com/keionim).
