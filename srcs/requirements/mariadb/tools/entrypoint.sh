#!/bin/bash
set -e

echo "Setting permissions for mysql..."
chown -R mysql:mysql /var/lib/mysql

echo "Updating bind-address to 0.0.0.0..."
sed -i 's/bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

exec "$@"
