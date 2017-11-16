#!make

PWD=$(shell pwd)

all: init build up-dev
#all: dotfiles up
.PHONY: all

init:

build: build-api

build-api:
	docker run -it --rm --name my-maven-project \
		-v $(PWD):/usr/src/mymaven \
		-v $(PWD)/m2:/root/.m2 \
		-w /usr/src/mymaven \
		maven:3 bash -c "mvn package"
	make -C collections-api

up-dev:
	#docker-compose up -d#
	docker-compose -f docker-compose.dev.yml up -d proxy
	docker-compose -f docker-compose.dev.yml up -d db
	docker-compose -f docker-compose.dev.yml up -d api

up-prod:
	#docker-compose up -d#
	docker-compose -f docker-compose.yml up -d db
	docker-compose -f docker-compose.yml up -d api

down-dev:
	docker-compose -f docker-compose.dev.yml down

down-prod:
	docker-compose -f docker-compose.yml down

# docker login
release:
	docker push dina/collections:v0.1

