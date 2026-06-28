#!/bin/bash

# Start MySQL service
service mysql start

# Wait for MySQL to be ready
until mysqladmin ping >/dev/null 2>&1; do
  echo "Waiting for MySQL to start..."
  sleep 1
done

# Initialize database and import schema
mysql -e "CREATE DATABASE IF NOT EXISTS instafoods;"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'newpassword123'; FLUSH PRIVILEGES;"
mysql -u root -p'newpassword123' instafoods < /app/schema.sql

# Start Tomcat
/opt/tomcat/bin/catalina.sh run
