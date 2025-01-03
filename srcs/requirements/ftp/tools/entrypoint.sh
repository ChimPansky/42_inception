#!/bin/bash
echo "Starting vsftpd..."

# Create FTP user if not exists
if ! id "$FTP_USER" >/dev/null 2>&1; then
    echo "Creating FTP user $FTP_USER..."
    useradd -m -d /var/www/html $FTP_USER
fi
echo "$FTP_USER:$FTP_USER_PW" | chpasswd
chown $FTP_USER:$FTP_USER -R /var/www/html
echo "$FTP_USER" >> /etc/vsftpd.userlist
echo "User $FTP_USER added to vsftpd.userlist"

exec "$@"