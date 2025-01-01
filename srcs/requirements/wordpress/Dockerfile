FROM debian:bullseye

RUN apt update && apt install -y \
    php php-fpm php-mysql php-curl php-mbstring php-xml php-gd php-zip \
    curl tar mariadb-client iputils-ping && \
    apt clean && rm -rf /var/lib/apt/lists/*

# to automate the installation of WordPress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/www/html

COPY ./conf/php-fpm.conf /etc/php/7.4/fpm/pool.d/www.conf

# Ensure /run/php exists at runtime
RUN mkdir -p /run/php && chown -R www-data:www-data /run/php

# Expose php-fpm port
EXPOSE 9000

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm7.4", "-F"]