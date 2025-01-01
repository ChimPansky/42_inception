#! /bin/bash
echo "Nginx entrypoint script..."
echo "Starting Nginx with domain: $DOMAIN_NAME"
envsubst '$DOMAIN_NAME' < /etc/nginx/nginx.template > /etc/nginx/nginx.conf
exec "$@" # important for making the container run as PID 1