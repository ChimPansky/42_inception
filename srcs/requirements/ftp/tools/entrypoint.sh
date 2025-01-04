#!/bin/bash
echo "Starting vsftpd..."

echo "changing shell to bash for www-data"
chsh -s /bin/bash www-data
echo "changing password for www-data"
echo "www-data:$FTP_USER_PW" | chpasswd
echo "www-data user added to vsftpd.userlist for FTP login."
echo "www-data" >> /etc/vsftpd.userlist

exec "$@"