FROM	debian:bullseye

RUN		apt update -y && apt upgrade -y && \
		apt install -y mariadb-server openssl && \
		rm -rf /var/lib/apt/lists/*

RUN 	sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY 	./tools/mariadb.sh /mariadb.sh

RUN 	chmod +x /mariadb.sh

CMD 	["/mariadb.sh"]
