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

# Ensure the /run/mysqld directory exists with correct permissions
RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

COPY tools/init.sql /docker-entrypoint-initdb.d/init.sql
# Docker won't substitute environment variables in the file, so we'll do it manually
RUN sed -i "s/\${MYSQL_DATABASE}/${MYSQL_DATABASE}/g" /docker-entrypoint-initdb.d/init.sql && \
    sed -i "s/\${MYSQL_USER}/${MYSQL_USER}/g" /docker-entrypoint-initdb.d/init.sql && \
    sed -i "s/\${MYSQL_PASSWORD}/${MYSQL_PASSWORD}/g" /docker-entrypoint-initdb.d/init.sql && \
    sed -i "s/\${MYSQL_ROOT_PASSWORD}/${MYSQL_ROOT_PASSWORD}/g" /docker-entrypoint-initdb.d/init.sql


# Use MariaDB's entrypoint script to ensure initdb logic works
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]