FROM debian:bullseye

ARG MARIADB_VERSION=10.5
ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_DATABASE
ARG MYSQL_USER
ARG MYSQL_PASSWORD

RUN apt-get update && apt-get install -y \
    vim \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 3306

CMD ["mysqld"]