# this will call docker-compose file

YML_FILE = srcs/docker-compose.yml

all: build up

build:
	docker-compose -f $(YML_FILE) --build

up:
	docker-compose -f $(YML_FILE) up

down:
	docker-compose -f $(YML_FILE) down

clean:
	docker-compose -f $(YML_FILE) down --volumes --rmi all

re: down build up

.PHONY: all build up down clean re
