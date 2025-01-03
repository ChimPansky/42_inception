FROM debian:bullseye

RUN apt update && apt install -y \
    redis-server \
    && apt clean && rm -rf /var/lib/apt/lists/*

COPY ./conf/redis.conf /etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "/etc/redis/redis.conf"]

# to see if cache is active: docker exec -it inception-redis redis-cli monitor