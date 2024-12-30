FROM debian:bullseye

RUN apt update && apt install -y \
    php php-fpm php-mysql php-curl php-mbstring php-xml php-gd php-zip \
    curl tar mariadb-client && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www

RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz && \
    mv wordpress /var/www/wordpress

COPY ./conf/php-fpm.conf /etc/php/7.4/fpm/pool.d/www.conf

# to make sure nginx can access the files
RUN chown -R www-data:www-data /var/www/wordpress

# Expose php-fpm port
EXPOSE 9000

CMD ["php-fpm7.4", "-F"]