CONTAINER_NAME=vault

build: Dockerfile
	docker build -t ${CONTAINER_NAME} .
