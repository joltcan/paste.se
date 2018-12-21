CONTAINER	:= paste.se
HUB_USER	:= ${USER}
TAG			:= v0.1
IMAGE_NAME	:= ${CONTAINER}:${TAG}
PORT		:= 8800
VOLUME		:= data
BASE_DOMAIN	:= localhost

build:
	docker \
		build \
		--tag=${CONTAINER} \
		.

run:
	docker \
		run \
		--detach \
		--interactive \
		--tty \
		--hostname=${CONTAINER} \
		--name=${CONTAINER} \
		-e BASE_DOMAIN=${BASE_DOMAIN} \
		-p ${PORT}:8800 \
		-v ${VOLUME}:/data \
		${CONTAINER}

shell:
	docker \
		run \
		--rm \
		--interactive \
		--tty \
		--hostname=${CONTAINER} \
		--name=${CONTAINER} \
		-e BASE_DOMAIN=${BASE_DOMAIN} \
		-v ${VOLUME}:/data \
		${CONTAINER} \
		/bin/bash

exec:
	docker exec \
		--interactive \
		--tty \
		${CONTAINER} \
		/bin/sh

stop:
	docker \
		kill ${CONTAINER}

rm:
	docker \
		rm ${CONTAINER}

history:
	docker \
		history ${CONTAINER}

clean:
	-docker \
		rm ${CONTAINER}
	-docker \
		rmi ${CONTAINER}

commit:
	docker commit -m "Built version ${TAG}" -a "${USER}" ${CONTAINER} ${HUB_USER}/${CONTAINER}:${TAG}

push:
	docker tag ${CONTAINER} ${HUB_USER}/${CONTAINER}:${TAG}
	docker tag ${CONTAINER} ${HUB_USER}/${CONTAINER}:latest
	docker push ${HUB_USER}/${CONTAINER}:latest

restart: stop clean run
