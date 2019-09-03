#!/bin/#!/usr/bin/env bash

export IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' tinyproxy-test)
function request {
  docker exec -t alpine-test curl -x ${IP}:8888 tinyproxy.stats | grep "Number of requests" -A1
}

echo "First request:"
curl -s -x ${IP}:8888 tinyproxy.stats | grep "Number of requests" -A1
request
request
request
request
echo "Sixth request:"
curl -s -x ${IP}:8888 tinyproxy.stats | grep "Number of requests" -A1

docker run -d --rm --cap-add=NET_ADMIN --net=host --name killproxy-test rvben/killproxy:dev ${IP} 8888 && echo "Killproxy started."
curl -s -x localhost:8888 tinyproxy.stats | grep "Number of requests" -A1 | grep 1
request
request
echo "Killproxy: (Third request)"
curl -s -x localhost:8888 tinyproxy.stats | grep "Number of requests" -A1 | grep 3
echo "Tinyproxy: (Seventh request)"
curl -s -x ${IP}:8888 tinyproxy.stats | grep "Number of requests" -A1
