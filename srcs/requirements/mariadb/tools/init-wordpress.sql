CREATE DATABASE IF NOT EXISTS wordpress;

CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY 'wpuser123';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';

-- Ensure root user exists for external connections
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'inception';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

ALTER USER 'root'@'localhost' IDENTIFIED BY 'inception';
FLUSH PRIVILEGES;