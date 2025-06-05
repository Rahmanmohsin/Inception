FROM debian:bullseye

RUN apt update && apt install -y php-fpm php-mysql php-curl \
    php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc \
    php-zip curl wget mariadb-client

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY www.conf /etc/php/7.4/fpm/pool.d/
COPY wpscript.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/wpscript.sh

WORKDIR /var/www/html

CMD ["/usr/local/bin/wpscript.sh"]