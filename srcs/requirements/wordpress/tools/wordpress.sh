#!/bin/bash

MYSQL_PASS=$(cat /run/secrets/mysql_password)
WORDPRESS_R_PASS=$(cat /run/secrets/wordpress_root_password)
WORDPRESS_U_PASS=$(cat /run/secrets/wordpress_user_password)
export WP_CLI_DISABLE_MAIL=true

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

if [ ! -f index.php ]; then
    wp core download --allow-root
fi

if [ ! -f wp-config.php ]; then
    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASS} \
        --dbhost=mariadb:3306 --allow-root
fi

if ! wp core is-installed --allow-root; then
    wp core install \
        --url=${DOMAIN_NAME} \
        --title="${WORDPRESS_TITLE}" \
        --admin_user=${WORDPRESS_R_NAME} \
        --admin_password=${WORDPRESS_R_PASS} \
        --admin_email=${WORDPRESS_R_EMAIL} --allow-root 2> >(grep -v '/usr/sbin/sendmail: not found' >&2)
fi

if wp theme is-active twentytwentyfour --allow-root; then
    echo "Theme 'twentytwentyfour' already active."
elif wp theme is-installed twentytwentyfour --allow-root; then
    wp theme activate twentytwentyfour --allow-root
else
    wp theme install twentytwentyfour --activate --allow-root
fi

if ! wp user get "${WORDPRESS_U_NAME}" --allow-root > /dev/null 2>&1; then
    wp user create ${WORDPRESS_U_NAME} ${WORDPRESS_U_EMAIL} \
        --user_pass=${WORDPRESS_U_PASS} \
        --role=${WORDPRESS_U_ROLE} --allow-root
fi

chown -R www-data:www-data /var/www/html

mkdir -p /run/php
/usr/sbin/php-fpm7.4 -F
