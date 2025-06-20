FROM	debian:bullseye

RUN		apt update -y && apt upgrade -y && \
		apt install -y nginx openssl && \
		apt install -y sudo curl && \
		rm -rf /etc/nginx/sites-enabled/*

COPY 	./tools/nginx.sh /nginx.sh

RUN 	chmod +x /nginx.sh

EXPOSE	443

CMD		["sh", "-c", "/nginx.sh && nginx -g 'daemon off;'"]
