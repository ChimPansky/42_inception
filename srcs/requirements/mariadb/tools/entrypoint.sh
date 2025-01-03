#!/bin/bash
echo "Starting Mariadb..."

# echo "Updating bind-address to 0.0.0.0..."
# sed -i 's/bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

echo "WP_DATABASE: ${MYSQL_WP_DATABASE}"
if [ -z "${MYSQL_WP_DATABASE}" ]; then
    echo "No WP-Database specified. Exiting..."
    exit 1
fi

if [ ! -d "/var/lib/mysql/${MYSQL_WP_DATABASE}" ]; then
    echo "Initializing Wordpress Database..."
    # service mariadb start

    # Start MariaDB safely
    echo "Starting MariaDB..."
    mysqld_safe --datadir=/var/lib/mysql &

    echo "Waiting for MariaDB to fully start..."
    until mysqladmin ping --silent ; do
        echo "Sleeping for 1 sec..."
        sleep 1
    done
    echo "MariaDB started successfully."

    echo "Setting mysql root password..."
    mysqladmin -u root password "${MYSQL_ROOT_PW}"

    echo "Making sure that MariaDb is running after setting root password..."
    until mysqladmin ping ; do
        sleep 1
    done

    echo "Creating Wordpress Database..."
    mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_WP_DATABASE};"
    echo "Creating Wordpress User..."
    mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_WP_USER}'@'%' IDENTIFIED BY '${MYSQL_WP_PW}';"
    echo "Granting Privileges for user..."
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_WP_DATABASE}.* TO '${MYSQL_WP_USER}'@'%';"
    echo "Granting Privileges for root..."
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_WP_DATABASE}.* TO 'root'@'localhost';"
    echo "Flushing Privileges..."
    mysql -e "FLUSH PRIVILEGES;"

    echo "Stopping MariaDB..."
    mysqladmin -uroot -p"${MYSQL_ROOT_PW}" shutdown
else
    echo "Wordpress Database already exists.";
fi



exec "$@"