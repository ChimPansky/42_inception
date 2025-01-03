#!/bin/bash
echo "Starting vsftpd..."

# Create FTP user if not exists
if ! id "$FTP_USER" >/dev/null 2>&1; then
    echo "Creating FTP user $FTP_USER..."
    useradd -m -d /var/www/html -s /usr/sbin/nologin $FTP_USER
    echo "$FTP_USER:1" | chpasswd
    echo "$FTP_USER" >> /etc/vsftpd.userlist
else
    echo "FTP user $FTP_USER already exists. Skipping creation."
fi

exec "$@"
