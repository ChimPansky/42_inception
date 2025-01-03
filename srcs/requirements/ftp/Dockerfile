FROM debian:bullseye

RUN apt update && apt install -y \
    vsftpd \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Create required chroot directory for vsftpd
RUN mkdir -p /var/run/vsftpd/empty

COPY ./conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 21 21000-21010

ENTRYPOINT ["/entrypoint.sh"]
# CMD ["vsftpd", "/etc/vsftpd.conf"]
CMD ["sleep", "infinity"]