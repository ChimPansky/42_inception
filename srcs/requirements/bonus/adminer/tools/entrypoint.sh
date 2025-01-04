#!/bin/bash
echo "Starting PHP server..."
trap "kill 1" SIGTERM
exec "$@"
# php -S 0.0.0.0:8080 -t /var/www/html &

# pid="$!"

# Trap SIGTERM and gracefully terminate the PHP server

# Wait for PHP process to finish
# wait "$pid"