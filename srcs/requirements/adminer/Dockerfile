FROM debian:bullseye

RUN apt update && apt install -y \
    php php-cli php-mysqli wget \
    && apt clean && rm -rf /var/lib/apt/lists/*
RUN wget https://www.adminer.org/latest.php -O /var/www/html/adminer.php

RUN chown -R www-data:www-data /var/www/html

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html/"]