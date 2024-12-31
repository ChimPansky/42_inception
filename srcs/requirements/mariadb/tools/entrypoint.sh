#!/bin/bash
set -e

echo "Setting permissions for mysql..."
chown -R mysql:mysql /var/lib/mysql

exec "$@"
