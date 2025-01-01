FROM debian:bullseye

RUN apt update && apt install -y \
    php php-fpm php-mysql php-curl php-mbstring php-xml php-gd php-zip \
    curl tar mariadb-client iputils-ping && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www

RUN curl -O https://wordpress.org/latest.tar.gz && \
		tar -xzf latest.tar.gz && \
		rm latest.tar.gz && \
		mv wordpress /var/www/wordpress;

COPY ./conf/php-fpm.conf /etc/php/7.4/fpm/pool.d/www.conf

# Ensure /run/php exists at runtime
RUN mkdir -p /run/php && chown -R www-data:www-data /run/php

# Ensure WordPress files are owned by www-data during the build
RUN chown -R www-data:www-data /var/www/

# Expose php-fpm port
EXPOSE 9000

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm7.4", "-F"]