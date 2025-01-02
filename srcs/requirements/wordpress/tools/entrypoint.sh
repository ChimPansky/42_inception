#!/bin/bash
echo "Starting Wordpress..."

# Check if WordPress is already installed
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "WordPress not found. Downloading and moving to /var/www/html..."
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    rm latest.tar.gz
    mv wordpress/* /var/www/html
    rm -r wordpress
    echo "Generating wp-config.php..."
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
    if [ -f "/var/www/html/wp-config.php" ]; then
        echo "wp-config.php generated successfully."
    else
        echo "Failed to generate wp-config.php."
        exit 1
    fi
else
    echo "WordPress already exists. Skipping download."
fi

# Perform WP installation if not already installed
if ! wp core is-installed --path=/var/www/html --allow-root; then
    echo "Installing WordPress..."
    wp core install --path=/var/www/html \
        --url="https://tkasbari.42.fr" \
        --title="My Inception Site" \
        --admin_user="important_user" \
        --admin_password="1" \
        --admin_email="thomas.kasbarian@gmail.com" --allow-root
    if ! wp core is-installed --path=/var/www/html --allow-root; then
        echo "Failed to install WordPress."
        exit 1
    else
        echo "WordPress installed successfully."
    fi
    echo "Creating user..."
    wp user create tkasbari tkasbari@gmail.com --role=editor --user_pass="1" --path=/var/www/html --allow-root
    if [ $? -eq 0 ]; then
        echo "User tkasbari created successfully."
    else
        echo "Failed to create user tkasbari."
    fi
else
    echo "WordPress already installed. Skipping installation."
fi

# echo "Setting permissions for wordpress..."
chown -R www-data:www-data /var/www/html

exec "$@" # Important for making the container run as PID 1
