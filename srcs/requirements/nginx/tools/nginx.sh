#!/bin/bash

DOMAIN="mohrahma.42.fr"
SSL_DIR="/etc/nginx/ssl"
SITES_DIR="/etc/nginx/sites-available"

mkdir -p "$SSL_DIR"

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    	-keyout "$SSL_DIR/key.pem" \
    	-out "$SSL_DIR/fullchain.pem" \
	-subj "/C=DE/ST=Baden-Wuerttemberg/L=Heilbronn/OU=42 Heilbronn Students/CN=$DOMAIN"

cat > "$SITES_DIR/default" <<EOF
server {
    listen 80 default_server;
    server_name _;
    return 444;
}

server {
    listen 80;
    server_name mohrahma.42.fr;
    return 444;
}

server {
    listen 443 ssl default_server;
    server_name _;
    ssl_certificate $SSL_DIR/fullchain.pem;
    ssl_certificate_key $SSL_DIR/key.pem;
    return 444;
}

server {
    listen 443 ssl;
    server_name $DOMAIN www.$DOMAIN;
    root /var/www/html;
    index index.php;

    ssl_certificate $SSL_DIR/fullchain.pem;
    ssl_certificate_key $SSL_DIR/key.pem;
    ssl_protocols TLSv1.3;

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass wordpress:9000;
    }
}
EOF

ln -sf "$SITES_DIR/default" "/etc/nginx/sites-enabled/default"
nginx -t
