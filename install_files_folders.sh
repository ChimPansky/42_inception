#!/bin/bash

# Create directories
mkdir -p secrets
mkdir -p srcs/requirements/{nginx,wordpress,mariadb}

# Create files
touch Makefile
touch .env

# Secrets
touch secrets/credentials.txt
touch secrets/db_password.txt
touch secrets/db_root_password.txt

# Docker Compose
touch srcs/docker-compose.yml

# NGINX
touch srcs/requirements/nginx/{Dockerfile,.dockerignore}
mkdir -p srcs/requirements/nginx/conf

# WordPress
touch srcs/requirements/wordpress/{Dockerfile,.dockerignore}
mkdir -p srcs/requirements/wordpress/conf

# MariaDB
touch srcs/requirements/mariadb/{Dockerfile,.dockerignore}
mkdir -p srcs/requirements/mariadb/conf

# Confirm completion
echo "Project structure created successfully."