#!/bin/bash
echo "Starting Wordpress..."

# Check if WordPress is already installed
if [ ! -d "/var/www/html" ] || [ -z "$(ls -A /var/www/html)" ]; then
    echo "WordPress not found. Downloading..."
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    rm latest.tar.gz
    mv wordpress/* /var/www/html
    rm -r wordpress
else
    echo "WordPress already exists. Skipping download."
fi

# Create wp-config.php if it doesn't exist
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "WordPress config not found. Generating wp-config.php..."
    cat <<EOF > /var/www/html/wp-config.php
<?php
define('DB_NAME', 'wordpress');
define('DB_USER', 'wpuser');
define('DB_PASSWORD', 'wpuser123');
define('DB_HOST', 'mariadb');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
define('AUTH_KEY',         '$(openssl rand -base64 32)');
define('SECURE_AUTH_KEY',  '$(openssl rand -base64 32)');
define('LOGGED_IN_KEY',    '$(openssl rand -base64 32)');
define('NONCE_KEY',        '$(openssl rand -base64 32)');
define('AUTH_SALT',        '$(openssl rand -base64 32)');
define('SECURE_AUTH_SALT', '$(openssl rand -base64 32)');
define('LOGGED_IN_SALT',   '$(openssl rand -base64 32)');
define('NONCE_SALT',       '$(openssl rand -base64 32)');
\$table_prefix = 'wp_';
define('WP_DEBUG', false);
if ( !defined('ABSPATH') ) {
    define('ABSPATH', dirname(__FILE__) . '/');
}
require_once(ABSPATH . 'wp-settings.php');
EOF
    echo "wp-config.php generated successfully."
else
    echo "WordPress config already exists. Skipping generation."
fi

# Perform WP installation if not already installed
if ! wp core is-installed --path=/var/www/html --allow-root; then
    echo "Installing WordPress..."
    wp core install --path=/var/www/html \
        --url="https://${DOMAIN_NAME}" \
        --title="My Inception Site" \
        --admin_user="important_user" \
        --admin_password="1" \
        --admin_email="thomas.kasbarian@gmail.com" --allow-root
    echo "WordPress installed successfully."
else
    echo "WordPress already installed. Skipping installation."
fi

# echo "Setting permissions for wordpress..."
chown -R www-data:www-data /var/www/html

exec "$@" # Important for making the container run as PID 1
