SHELL:=/bin/bash
IMAGE?=rvben/killproxy:dev

run.sh:
	wget https://raw.githubusercontent.com/monokal/docker-tinyproxy/master/run.sh
	sed -i 's/sbin/bin/g' run.sh

build: run.sh
	docker build -t ${IMAGE} .

run: build
	docker run -d --rm --name killproxy-run --cap-add=NET_ADMIN --net=host ${IMAGE} 10.10.10.10 8888

run-interactive: build
	docker run -ti --rm --name killproxy-run --cap-add=NET_ADMIN --net=host ${IMAGE} 10.10.10.10 8888

exec:
	docker run -ti --rm ${IMAGE}

push-dev:
	docker push ${IMAGE}

push:
	docker tag ${IMAGE} rvben/killproxy:latest
	docker push rvben/killproxy:latest

cleantest:
	@docker stop alpine-test || true
	@docker stop tinyproxy-test || true
	@docker stop killproxy-test || true

test: cleantest
	docker run -d --rm --name alpine-test alpine sleep 294000
	docker run -d --rm --name tinyproxy-test dannydirect/tinyproxy ANY
	docker exec -t alpine-test apk add curl
	bash test.sh
