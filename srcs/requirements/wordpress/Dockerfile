FROM debian:bullseye


RUN apt update && apt upgrade -y && apt install -y php-fpm php-mysqli curl

COPY www.conf /etc/php/8.2/fpm/pool.d/.
COPY wpscript.sh .

RUN chmod +x wpscript.sh

CMD ["./wpscript.sh"]