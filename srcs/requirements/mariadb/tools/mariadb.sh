#!/bin/bash

MYSQL_PASS=$(cat /run/secrets/mysql_password)

set -e

#service mariadb start

mysqld_safe --skip-networking &

until mariadb-admin ping --silent; do
  sleep 1
done

mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASS}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mysqladmin shutdown --socket=/var/run/mysqld/mysqld.sock -u root

exec mysqld
