
YML_FILE = srcs/docker-compose.yml
WP_VOLUME = ~/data/wordpress
DB_VOLUME = ~/data/mariadb

all: build up

build: build-volumes
	docker-compose --verbose -f $(YML_FILE) build

up:
	docker-compose -f $(YML_FILE) up -d

down:
	docker-compose -f $(YML_FILE) down

restart:
	docker-compose -f $(YML_FILE) restart

fclean: down clean-volumes
	docker-compose -f $(YML_FILE) down --rmi all

re: fclean all

# creates a volume for wordpress
build-volumes: build-wp-volume build-db-volume

clean-volumes: clean-wp-volume clean-db-volume

build-wp-volume:
	@if [ ! -d $(WP_VOLUME) ]; then \
		echo "creating wordpress volume on host"; \
		mkdir -p $(WP_VOLUME); \
		sudo chown -R www-data:www-data $(WP_VOLUME); \
	else \
		echo "wordpress volume already exists"; \
	fi


build-db-volume:
	@if [ ! -d $(DB_VOLUME) ]; then \
		echo "creating mariadb volume on host"; \
		mkdir -p $(DB_VOLUME); \
		sudo chown -R mysql:mysql $(DB_VOLUME); \
	else \
		echo "mariadb volume already exists"; \
	fi

# dont use variables here just to make sure to not accidently rm -rf something that should not be rm -rfed
clean-wp-volume:
	sudo rm -rf ~/data/wordpress

clean-db-volume:
	sudo rm -rf ~/data/mariadb