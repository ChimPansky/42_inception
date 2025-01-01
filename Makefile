
YML_FILE = srcs/docker-compose.yml
# IMG_NGINX = inception-nginx-image
# IMG_FOLDER = srcs/requirements/
# CNT_NGINX = inception-nginx-container

all: build up

build: wordpress-volume mariadb-volume
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


# copies the fresh wordpress to the wordpress volume in subfolder data/wordpress of home directory and grants rights to www-data on it  if it doesnt exist yet; else: echo that it already exists
wordpress-volume:
	@if [ ! -d ~/data/wordpress ]; then \
		echo "creating wordpress volume on host"; \
		mkdir -p ~/data/wordpress; \
		sudo chown -R www-data:www-data ~/data/wordpress; \
	else \
		echo "wordpress volume already exists"; \
	fi

clear-wordpress:
	sudo rm -rf ~/data/wordpress

mariadb-volume:
	@if [ ! -d ~/data/mariadb ]; then \
		echo "creating mariadb volume on host"; \
		mkdir -p ~/data/mariadb; \
		sudo chown -R mysql:mysql ~/data/mariadb; \
	else \
		echo "mariadb volume already exists"; \
	fi

clear-mariadb:
	sudo rm -rf ~/data/mariadb