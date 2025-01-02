#!/bin/bash
echo "Starting Mariadb..."

echo "Updating bind-address to 0.0.0.0..."
sed -i 's/bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

if [ ! -d "/var/lib/mysql/${MYSQL_WP_DATABASE}" ]; then
    echo "Initializing Wordpress Database..."
    service mariadb start

    echo "Waiting for MariaDB to fully start..."
    while [ ! -S /run/mysqld/mysqld.sock ]; do
        sleep 1
    done
    echo "MariaDB started successfully."

    echo "Creating Wordpress Database..."
    mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_WP_DATABASE};"
    echo "Creating Wordpress User..."
    mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_WP_USER}'@'%' IDENTIFIED BY '${MYSQL_WP_PW}';"
    echo "Granting Privileges for user..."
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_WP_DATABASE}.* TO '${MYSQL_WP_USER}'@'%';"
    echo "Granting Privileges for root..."
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_WP_DATABASE}.* TO 'root'@'localhost';"
    echo "Flushing Privileges..."
    # mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PW}';"
    # mysql -uroot -p${MYSQL_ROOT_PW} -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PW}';"
    mysql -e "FLUSH PRIVILEGES;"
    echo "altering root password..."
    mysql -u root --skip-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PW}';"
    echo "Shutting down Mariadb..."
    mysqladmin -uroot --password=${MYSQL_ROOT_PW} shutdown
else
    echo "Wordpress Database already exists.";
fi



exec "$@"