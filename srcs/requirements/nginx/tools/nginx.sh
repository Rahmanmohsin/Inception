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
    listen 443 ssl http2;
    server_name $DOMAIN;

    ssl_certificate $SSL_DIR/fullchain.pem;
    ssl_certificate_key $SSL_DIR/key.pem;
    
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;
    
    root /var/www/html;

    index index.php index.html index.htm index.nginx-debian.html;

    ssl_protocols TLSv1.3;
    ssl_prefer_server_ciphers off;
    
    location / {
        root /var/www/html;
        index index.html;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass wordpress:9000;
    }
}
EOF

ln -sf "$SITES_DIR/default" "/etc/nginx/sites-enabled/default"
nginx -t
