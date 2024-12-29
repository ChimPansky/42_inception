# this will call docker-compose file

YML_FILE = srcs/docker-compose.yml
IMG_NGINX = inception-nginx-image
IMG_FOLDER = srcs/requirements/
CNT_NGINX = inception-nginx-container

all: build up

nginx-build:
#docker rmi $(IMG_NGINX)
	docker build -t $(IMG_NGINX) $(IMG_FOLDER)nginx/

nginx-destroy:
	docker rmi $(IMG_NGINX)

nginx-up:
	docker run -d -p 443:443 --name $(CNT_NGINX) $(IMG_NGINX)

nginx-down:
	docker stop $(CNT_NGINX)
	docker rm $(CNT_NGINX)

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
