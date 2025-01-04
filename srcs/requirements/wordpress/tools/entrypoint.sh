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
define('DB_NAME', '$MYSQL_WP_DATABASE');
define('DB_USER', '$MYSQL_WP_USER');
define('DB_PASSWORD', '$MYSQL_WP_PW');
define('DB_HOST', '$MARIADB_HOST_NAME');
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
define('WP_REDIS_HOST', 'redis');
define('WP_REDIS_PORT', '$REDIS_PORT');
define('WP_REDIS_DATABASE', 0);
define('WP_REDIS_TIMEOUT', 1);
define('WP_REDIS_READ_TIMEOUT', 1);
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
        --url="https://$DOMAIN_NAME" \
        --title="My Inception Site" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PW" \
        --admin_email="$WP_ADMIN_EMAIL" --allow-root
    if ! wp core is-installed --path=/var/www/html --allow-root; then
        echo "Failed to install WordPress."
        exit 2
    else
        echo "WordPress installed successfully."
    fi
    echo "Creating regular user $WP_REGULAR_USER..."
    wp user create $WP_REGULAR_USER $WP_REGULAR_EMAIL --role=editor --user_pass="$WP_REGULAR_PW" --path=/var/www/html --allow-root
    if [ $? -eq 0 ]; then
        echo "User $WP_REGULAR_USER created successfully."
    else
        echo "Failed to create user $WP_REGULAR_USER."
    fi
    wp plugin install redis-cache --activate --path=/var/www/html --allow-root
    wp redis enable --path=/var/www/html --allow-root
else
    echo "WordPress already installed. Skipping installation."
fi

# echo "Setting permissions for wordpress..."
chown -R www-data:www-data /var/www/html

exec "$@"
