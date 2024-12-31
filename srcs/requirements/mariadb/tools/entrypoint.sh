#!/bin/bash
set -e

echo "Setting permissions for mysql..."
chown -R 999:999 /var/lib/mysql

# Initialize database if empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mysqld --initialize-insecure --user=mysql
    mysqld --skip-networking &
    PID=$!

    # Wait for MariaDB to start
    while ! mysqladmin ping --silent; do
        sleep 1
    done

    echo "Running initialization scripts..."
    mysql -u root < /docker-entrypoint-initdb.d/init.sql
    mysqladmin shutdown
    wait $PID
fi

exec "$@"
