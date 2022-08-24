NAME = inception

all: create-volume-dir build up

build:
	docker-compose -f srcs/docker-compose.yml build

up:
	docker-compose -f srcs/docker-compose.yml up --detach

down:
	docker-compose -f srcs/docker-compose.yml down

force-build: 
	docker-compose -f srcs/docker-compose.yml build --force-rm

reload: down force-build up

create-volume-dir:
	mkdir -p /home/jberredj/data
	mkdir -p /home/jberredj/data/wordpress
	mkdir -p /home/jberredj/data/mariadb

clean-volumes-content:
	rm -rf /home/jberredj/data/wordpress/*
	rm -rf /home/jberredj/data/mariadb/*

fclean:
	docker stop $$(docker ps -qa); docker rm $$(docker ps -qa);
	docker rmi -f $$(docker images -qa); docker volume rm $$(docker volume ls -q);
	docker network rm $$(docker network ls -q) 2>/dev/null

hostname-set:
	sudo echo "127.0.0.1 jberredj.42.fr" >> /etc/hosts

.PHONY: all build up down force-build reload hostname-set clean-volumes-content fclean create-volume-dir
