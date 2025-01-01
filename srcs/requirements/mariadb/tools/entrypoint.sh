#!/bin/bash
echo "Starting MariaDB..."

echo "Setting permissions for mysql..."
chown -R mysql:mysql /var/lib/mysql

echo "Updating bind-address to 0.0.0.0..."
sed -i 's/bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Start MariaDB in the background
mysqld --user=mysql &

# Wait until MariaDB is ready
until mariadb -u root -e 'SELECT 1' 2>/dev/null; do
  echo "Waiting for MariaDB to start..."
  sleep 1
done

echo "MariaDB started."

# Check if WordPress DB exists, if not, initialize it
if ! mariadb -u root -e "USE wordpress;" 2>/dev/null; then
  echo "Initializing WordPress database..."
  mariadb -u root < /init-wordpress.sql
  echo "Database initialized."
else
  echo "WordPress database already exists. Skipping initialization."
fi

# Bring MariaDB to the foreground (PID 1)
wait
