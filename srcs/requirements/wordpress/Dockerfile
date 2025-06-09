FROM	debian:bullseye

RUN	    apt update -y && apt upgrade -y && \
	    apt install -y curl php php-mysql  && \
		apt install -y php7.4-fpm mariadb-client

COPY    ./tools/wordpress.sh /wordpress.sh

RUN     chmod +x /wordpress.sh

CMD		["sh", "-c", "./wordpress.sh" ]