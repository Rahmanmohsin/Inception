#!/bin/bash

set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

temp_server_start() {
    mysqld_safe --skip-networking --socket=/var/run/mysqld/mysqld.sock &
    MYSQLD_PID=$!
    for i in {1..30}; do
        if mysqladmin ping --socket=/var/run/mysqld/mysqld.sock --silent; then
            break
        fi
        sleep 1
    done
}

secure_installation() {
    ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-$(openssl rand -base64 24)}
    
    mysql --socket=/var/run/mysqld/mysqld.sock <<-EOF
        -- Modern MariaDB password setting
        SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$ROOT_PASSWORD');
        
        -- Alternative modern syntax if above fails
        ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASSWORD';
        
        -- Remove anonymous users
        DELETE FROM mysql.global_priv WHERE User='';
        
        -- Disallow remote root login
        DELETE FROM mysql.global_priv WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
        
        -- Remove test database
        DROP DATABASE IF EXISTS test;
        DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
        
        -- Apply changes
        FLUSH PRIVILEGES;
EOF

    echo "MariaDB root password: $ROOT_PASSWORD"
}

temp_server_start
secure_installation

kill $MYSQLD_PID
wait $MYSQLD_PID

exec mysqld_safe
