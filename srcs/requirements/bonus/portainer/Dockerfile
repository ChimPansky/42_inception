FROM debian:bullseye

RUN apt update && apt install -y wget tar && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/portainer/portainer/releases/download/2.19.4/portainer-2.19.4-linux-amd64.tar.gz -O portainer.tar.gz

RUN tar xvzf portainer.tar.gz

RUN mv portainer /usr/local/bin/portainer

RUN chmod +x /usr/local/bin/portainer

RUN mkdir -p /data

EXPOSE 9090

CMD ["/usr/local/bin/portainer/portainer", "-H", "unix:///var/run/docker.sock", "--data", "/data"]
