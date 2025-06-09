FROM	debian:bullseye

RUN		apt update -y && apt upgrade -y && \
		apt install -y mariadb-server openssl && \
		rm -rf /var/lib/apt/lists/*

COPY 	./tools/mariadb.sh /mariadb.sh

RUN 	chmod +x /mariadb.sh

EXPOSE 	3306

CMD		["sh", "-c", "./mariadb.sh"]
