# penultimate (second to last) debian version. latest is bookworm (as of 2024-12-29)
FROM debian:bullseye

# -y means yes to all prompts
# rm -rf /var/lib/apt/lists/* is to remove the cache of the package manager (reduces image size)
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    vim \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# COPY - copies from host to container
COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/ssl/private/inception-nginx-selfsigned.key \
-out /etc/ssl/certs/inception-nginx-selfsigned.crt \
-subj "/C=AT/ST=Austria/L=Vienna/O=42Vienna/OU=monkey_business/CN=chimpansky/emailAddress=thomas.kasbarian@gmail.com"
RUN echo "user: " ${USER}


# EXPOSE - tells docker that the container listens on the specified network ports at runtime. this does not make the ports of the container accessible to the host
EXPOSE 443
# to make nginx content reachable through custom domain edit /etc/hosts file on host machine (e.g. 127.0.0.1    tkasbari.42.fr)

# CMD - specifies what command to run at container startup
# "nginx" - starts the nginx server
# "-g" - allows passing nginx configuration directives
# "daemon off;" - runs nginx in the foreground. by default, nginx runs in the background and the container would exit immediately after starting
# ENTRYPOINT ["./entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]