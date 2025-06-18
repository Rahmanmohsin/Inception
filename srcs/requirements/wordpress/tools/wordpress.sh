#!/bin/bash

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
cd /var/www/html
chmod -R 755 /var/www/html
sed -i '36 s/\/run\/php\/php7.4-fpm.sock/9000/' /etc/php/7.4/fpm/pool.d/www.conf

for ((i = 1; i <= 10; i++)); do
    if mariadb -h mariadb -P 3306 \
        -u "${MYSQL_USER}" \
        -p"${MYSQL_PASS}" -e "SELECT 1" > /dev/null 2>&1; then
        break
    else
        sleep 2
    fi
done

wp core download --allow-root
wp config create \
    --dbname=${MYSQL_DATABASE} \
    --dbuser=${MYSQL_USER} \
    --dbpass=${MYSQL_PASS} \
    --dbhost=mariadb:3306 --allow-root
wp core install \
    --url=${DOMAIN_NAME} \
    --title=${WORDPRESS_TITLE} \
    --admin_user=${WORDPRESS_A_NAME} \
    --admin_password=${WORDPRESS_A_PASS} \
    --admin_email=${WORDPRESS_A_EMAIL} --allow-root
wp user create ${WORDPRESS_U_NAME} ${WORDPRESS_U_EMAIL} \
    --user_pass=${WORDPRESS_U_PASS} \
    --role=${WORDPRESS_U_ROLE} --allow-root

chown -R www-data:www-data /var/www/html

mkdir -p /run/php
/usr/sbin/php-fpm7.4 -F
