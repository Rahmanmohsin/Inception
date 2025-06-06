FROM	debian:bullseye

RUN	apt update -y && apt upgrade -y && \
	apt install -y nginx openssl && \
	apt install -y sudo curl

COPY 	./tools/nginx.sh /nginx.sh

RUN 	chmod +x /nginx.sh

CMD	["sh", "-c", "/nginx.sh && nginx -g 'daemon off;'"]
