SHELL := /bin/bash

build:
	docker build -t rvben/killproxy:dev .

run: build
	docker run -d --cap-add=NET_ADMIN --net=host killproxy 192.168.1.182 8888

push:
	docker push rvben/killproxy:dev

cleantest:
	iptables-save | grep -v KILLPROXY | iptables-restore
	@docker stop alpine-test || true
	@docker stop tinyproxy-test || true
	@docker stop killproxy-test || true

test: cleantest
	docker run -d --rm --name alpine-test alpine sleep 294000
	docker run -d --rm --name tinyproxy-test dannydirect/tinyproxy ANY
	docker exec -t alpine-test apk add curl
	bash test.sh
