FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    vim \
    mariadb-server \
    iputils-ping \
    && apt clean && rm -rf /var/lib/apt/lists/*

# mariadb-server installs the following (among others):
    # mysqld - (engine of car) the daemon that runs the MySQL server
    # mariadb - (ignition system of car) the service that starts up / shuts down mysqld
    # mysql - the MySQL command-line client
    # mysqladmin - useful for shutting down the server
    # mysqlshow - shows database structure
    # ...

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

EXPOSE 3306

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld", "--bind-address=0.0.0.0"]