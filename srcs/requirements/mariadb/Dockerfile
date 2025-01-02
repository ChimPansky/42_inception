FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    vim \
    mariadb-server \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Use MariaDB's entrypoint script to ensure initdb logic works
COPY tools/init-wordpress.sql /init-wordpress.sql

# RUN service mariadb start && mysql < init-wordpress.sql

EXPOSE 3306

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]