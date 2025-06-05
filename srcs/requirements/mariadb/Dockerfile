<<<<<<< HEAD
FROM debian:bullseye
=======
FROM debian:latest
>>>>>>> 1b2461b6e95417ef717de677eb055e18728ea82d

RUN apt update && apt upgrade -y && apt install -y mariadb-server

COPY 50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY init.sql /etc/mysql/init.sql

RUN mkdir /run/mysqld

EXPOSE 3306

CMD ["mysqld", "--console"]