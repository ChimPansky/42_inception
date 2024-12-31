#! /bin/bash
echo "Setting permissions for wordpress..."
chown -R www-data:www-data /var/www/wordpress
echo "Starting Wordpress..."
exec "$@" # important for making the container run as PID 1