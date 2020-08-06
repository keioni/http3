# Nginx with HTTP/3 (draft)

[Quiche](https://docs.quic.tech/quiche) is one of the implementations of [QUIC](https://datatracker.ietf.org/doc/draft-ietf-quic-transport/) created by [Cloudflare](https://www.cloudflare.com/).

Cloudflare also provides an unofficial nginx patch that can use QUIC. This is a docker image built according to the [Cloudflare documentation](https://github.com/cloudflare/quiche/tree/master/extras/nginx).


## Details (Japanese)

HTTP/3 対応の nginx を作る - Qiita<br>
https://qiita.com/keys/items/bf492ef543fde3d8d822

## GitHub

https://github.com/keioni/http3

```
git clone https://github.com/keioni/http3.git
```

## Docker Hub

https://hub.docker.com/r/keioni/nginx-http3

```
docker pull keioni/nginx-http3
```

# Usage

```
docker run --dit keioni/nginx-http3
```

## Options

### `HTTP3_ONLY`

Default: "`off`".

When this value is "`on`", nginx runs at HTTP/3 support only mode (not listen 443/tcp port).

If you use other HTTP/2 and HTTP/1.1 server at the same time, you MUST turn "on".

### `IPv6`

Default is "`yes`".

When this value is "`no`", nginx doesn't treat IPv6.<br>

### Example

```
docker run --dit --env HTTP3_ONLY=on keioni/nginx-http3
```

# Contact

Feel free to ask anything!

Also, I'm not good at English, so suggestions for bad English are very welcome 😃.

* email:<br>[`otegami@devel.keys.jp`](mailto:otegami@devel.keys.jp)
* Twitter:<br>[`@keionim`](https://twitter.com/keionim)
