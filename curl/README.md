# Curl with HTTP/3 (draft)

## Details (Japanese)

HTTP/3 対応の curl を作る - Qiita<br>
https://qiita.com/keys/items/611d949ca26d6ca848c2

## GitHub

https://github.com/keioni/http3

```
git clone https://github.com/keioni/http3.git
```

## Docker Hub

https://hub.docker.com/r/keioni/curl-http3

```
docker pull keioni/curl-http3
```

# Usage

```
docker run -dit keioni/curl-http3
```

## Example

```
docker run --rm keioni/curl-http3 curl -s -L -v --http3 https://quic.tech:8443
```

**IMPORTANT**: `--alt-svc` is not working. alt-svc cache was made in ephemeral container. If you try to test `--alt-svc`, do not run without `--rm` option and `exec` into the container.

```
docker run -dit --name foobar keioni/curl-http3
docker exec -it foobar /bin/sh
```

in the container, run curl.

```
curl -s -L -v --alt-svc alt-svc.cache
```

# Contact

Feel free to ask anything!

Also, I'm not good at English, so suggestions for bad English are very welcome 😃.

* email:<br>[`otegami@devel.keys.jp`](mailto:otegami@devel.keys.jp)
* Twitter:<br>[`@keionim`](https://twitter.com/keionim)
