.DEFAULT_GOAL := help

CONTAINER_NAME=vault

all: build tests		## build and test 
build:	## Build the container
	docker build -t ${CONTAINER_NAME} .

tests:	## Launch the tests
	bundle install; bundle exec rspec --color

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
