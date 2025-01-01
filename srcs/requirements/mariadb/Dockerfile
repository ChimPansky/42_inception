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
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Ensure the /run/mysqld directory exists with correct permissions
RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

COPY tools/init-wordpress.sql /docker-entrypoint-initdb.d/

# Use MariaDB's entrypoint script to ensure initdb logic works
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]