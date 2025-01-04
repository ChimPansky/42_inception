#!/bin/bash
echo "Starting Nginx..."
echo "Setting Domain Name in Nginx configuration..."
sed -i "s/DOMAIN_NAME/$DOMAIN_NAME/g" /etc/nginx/nginx.conf

exec "$@"
