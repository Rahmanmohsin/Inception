<<<<<<< HEAD
FROM debian:bullseye

RUN apt update && apt install -y nginx
RUN ufw allow 'Nginx HTTPS'
RUN ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//' 
RUN mkdir -p /var/www/mohrahma.42.fr/html
RUN chown -R $USER:$USER /var/www/mohrahma.42.fr/html
RUN chmod -R 755 /var/www/mohrahma.42.fr

COPY default /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/mohrahma.42.fr /etc/nginx/sites-enabled/

# sudo nano /etc/nginx/nginx.conf
# Find the server_names_hash_bucket_size directive and remove the # symbol to uncomment the line:
# /etc/nginx/nginx.conf
# ...
# http {
#     ...
#     server_names_hash_bucket_size 64;
#     ...
# }
# ...
# Save and close the file when you are finished.
=======
FROM debian:latest

RUN apt update && apt upgrade -y && apt install -y nginx

COPY default /etc/nginx/sites-available/.
>>>>>>> 1b2461b6e95417ef717de677eb055e18728ea82d

CMD ["nginx", "-g", "daemon off;"]