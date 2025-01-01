FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    vim \
    mariadb-server \
    mariadb-client \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Ensure the /run/mysqld directory exists with correct permissions
RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

# Use MariaDB's entrypoint script to ensure initdb logic works
COPY tools/init-wordpress.sql /init-wordpress.sql

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]