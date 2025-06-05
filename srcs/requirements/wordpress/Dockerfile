<<<<<<< HEAD
FROM debian:bullseye

=======
FROM debian:latest
>>>>>>> 1b2461b6e95417ef717de677eb055e18728ea82d

RUN apt update && apt upgrade -y && apt install -y php-fpm php-mysqli curl

COPY www.conf /etc/php/8.2/fpm/pool.d/.
COPY wpscript.sh .

RUN chmod +x wpscript.sh

CMD ["./wpscript.sh"]