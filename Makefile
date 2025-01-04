YML_FILE = srcs/docker-compose.yml
WP_VOLUME = ~/data/wordpress
DB_VOLUME = ~/data/mariadb
HOST_ENTRY = 127.0.0.1\ttkasbari.42.fr

all: build up

build: build-volumes check-hosts
	docker-compose --verbose -f $(YML_FILE) build

up:
	docker-compose -f $(YML_FILE) up -d

down:
	docker-compose -f $(YML_FILE) down --timeout 5

restart:
	docker-compose -f $(YML_FILE) restart --timeout 5

fclean:  clean-images

re: fclean all

clean-images:
	docker-compose -f $(YML_FILE) down --timeout 5 --rmi all

clean-volumes: clean-wp-volume clean-db-volume
	docker-compose -f $(YML_FILE) down --timeout 5 --volumes

build-volumes: build-wp-volume build-db-volume

build-wp-volume:
	@if [ ! -d $(WP_VOLUME) ]; then \
		echo "creating wordpress volume on host"; \
		mkdir -p $(WP_VOLUME); \
	else \
		echo "wordpress volume already exists"; \
	fi

build-db-volume:
	@if [ ! -d $(DB_VOLUME) ]; then \
		echo "creating mariadb volume on host"; \
		mkdir -p $(DB_VOLUME); \
	else \
		echo "mariadb volume already exists"; \
	fi

# dont use variables here just to make sure to not accidently rm -rf something that should not be rm -rfed
# need sudo because we are using volumes that are bound to the host and the containers using
# these volumes are changing permissions of the files in the volumes
clean-wp-volume:
	sudo rm -rf ~/data/wordpress

clean-db-volume:
	sudo rm -rf ~/data/mariadb

check-hosts:
	@if ! grep -q "^$(HOST_ENTRY)" /etc/hosts; then \
		echo "Adding $(HOST_ENTRY) to /etc/hosts"; \
		echo -e "$(HOST_ENTRY)" | sudo tee -a /etc/hosts; \
	else \
		echo "Host entry already exists in /etc/hosts"; \
	fi