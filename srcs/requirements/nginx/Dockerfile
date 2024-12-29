# penultimate (second to last) debian version. latest is bookworm (as of 2024-12-29)
FROM debian:bullseye

# -y means yes to all prompts
# rm -rf /var/lib/apt/lists/* is to remove the cache of the package manager (reduces image size)
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# COPY - copies from host to container
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Copy ssl certificates to the container
COPY conf/ssl/inception-nginx-selfsigned.crt /etc/ssl/certs/inception-nginx-selfsigned.crt
COPY conf/ssl/inception-nginx-selfsigned.key /etc/ssl/private/inception-nginx-selfsigned.key

# copy files for example website
COPY www/html /var/www/html

# EXPOSE - tells docker that the container listens on the specified network ports at runtime. this does not make the ports of the container accessible to the host
EXPOSE 443

# CMD - specifies what command to run at container startup
# "nginx" - starts the nginx server
# "-g" - allows passing nginx configuration directives
# "daemon off;" - runs nginx in the foreground. by default, nginx runs in the background and the container would exit immediately after starting
CMD ["nginx", "-g", "daemon off;"]