#!/bin/bash
php-fpm7.4 -D
while ! mysqladmin ping -h"$DB_HOST" --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done
if [ ! -f /var/www/html/wp-config.php ]; then
    wp core download --allow-root
    wp config create  --dbname="$DB_NAME"  --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD"  --dbhost="$DB_HOST" --allow-root
    wp core install --url="$WP_URL" --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN" --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" --allow-root
    wp user create editor editor@example.com --role=editor \
        --user_pass=editorpass --allow-root
fi
tail -f /dev/null