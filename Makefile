
YML_FILE = srcs/docker-compose.yml
# IMG_NGINX = inception-nginx-image
# IMG_FOLDER = srcs/requirements/
# CNT_NGINX = inception-nginx-container

all: build up

build:
	docker-compose --verbose -f $(YML_FILE) build

up:
	docker-compose -f $(YML_FILE) up -d

down:
	docker-compose -f $(YML_FILE) down

restart:
	docker-compose -f $(YML_FILE) restart

fclean: down
	docker-compose -f $(YML_FILE) down --volumes --rmi all

re: fclean all