FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    && apt clean && rm -rf /var/lib/apt/lists/*

# COPY - copies from host to container
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/demo_site /var/www/demo_site

EXPOSE 443

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]