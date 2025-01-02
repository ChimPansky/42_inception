#!/bin/bash
echo "Starting Wordpress..."
echo "mysql_wp_database: $MYSQL_WP_DATABASE"
echo "domain_name: "$DOMAIN_NAME
echo "mariadb_host_name: "$MARIADB_HOST_NAME
echo "mysql_wp_user: "$MYSQL_WP_USER
echo "mysql_wp_pw: "$MYSQL_WP_PW
echo "wp_admin_user: "$WP_ADMIN_USER
echo "wp_admin_pw: "$WP_ADMIN_PW
echo "wp_admin_email: "$WP_ADMIN_EMAIL
echo "wp_regular_user: "$WP_REGULAR_USER
echo "wp_regular_pw: "$WP_REGULAR_PW
echo "wp_regular_email: "$WP_REGULAR_EMAIL

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
        exit 1
    else
        echo "WordPress installed successfully."
    fi
    echo "Creating regular user..."
    wp user create $WP_REGULAR_USER $WP_REGULAR_EMAIL --role=editor --user_pass="$WP_REGULAR_PW" --path=/var/www/html --allow-root
    if [ $? -eq 0 ]; then
        echo "User $WP_REGULAR_USER created successfully."
    else
        echo "Failed to create user $WP_REGULAR_USER."
    fi
else
    echo "WordPress already installed. Skipping installation."
fi

# echo "Setting permissions for wordpress..."
chown -R www-data:www-data /var/www/html

exec "$@" # Important for making the container run as PID 1
