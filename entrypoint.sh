#!/bin/bash

# Ensure directory for sockets exists and permissions are correct
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld /var/lib/mysql

# Initialize MySQL data directory if not already done
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initializing MySQL database..."
  mysqld --initialize-insecure --user=mysql
fi

# Start MySQL daemon in the background
echo "Starting MySQL daemon..."
mysqld_safe --user=mysql &

# Wait for MySQL to be ready
until mysqladmin ping >/dev/null 2>&1; do
  echo "Waiting for MySQL daemon to start..."
  sleep 1
done

# Initialize database and import schema
echo "Initializing instafoods database..."
mysql -e "CREATE DATABASE IF NOT EXISTS instafoods;"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'newpassword123'; FLUSH PRIVILEGES;"
mysql -u root -p'newpassword123' instafoods < /app/schema.sql

# Start Tomcat in the foreground
echo "Starting Apache Tomcat..."
/opt/tomcat/bin/catalina.sh run
