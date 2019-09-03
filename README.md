# Docker Killproxy
A Tinyproxy-based Docker image to transparently remove proxy usage from Docker-containers.

Used the work done for [dannydirect/tinyproxy](https://github.com/monokal/docker-tinyproxy) as a base.

### Why?
** Containers with proxy configurations **

Running these containers in environments where:
- Proxy is unavailable
- Proxy use is undesirable

Especially when working with corporate proxies, you sometimes encounter docker containers with proxy configurations present.
This container can help you deal with it.

### Usage
Let's say your company uses a proxy at 10.10.10.10, port 8888:
```
docker run -d --name killproxy --cap-add=NET_ADMIN --net=host rvben/killproxy 10.10.10.10 8888
```
