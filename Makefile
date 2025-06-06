DC = docker compose
DC_FILE = srcs/docker-compose.yml
DATA_DIR = /home/mohrahma/data
SSL_DIR = srcs/requirements/nginx/ssl

.PHONY: build up down start stop restart logs clean fclean re ps debug volumes

debug: build up logs ps volumes

build:
	@sudo mkdir -p $(DATA_DIR)/{mariadb,wordpress}
	@sudo mkdir -p $(SSL_DIR)/{certs,private}
	@sudo chmod -R 755 $(DATA_DIR) $(SSL_DIR)
	$(DC) -f $(DC_FILE) build

up:
	$(DC) -f $(DC_FILE) up -d

down:
	$(DC) -f $(DC_FILE) down

start:
	$(DC) -f $(DC_FILE) start

stop:
	$(DC) -f $(DC_FILE) stop

restart:
	$(DC) -f $(DC_FILE) restart

logs:
	$(DC) -f $(DC_FILE) logs

volumes:
	docker volume ls

clean:
	$(DC) -f $(DC_FILE) down --rmi all --volumes --remove-orphans

fclean: clean
	@if [ -d "$(DATA_DIR)" ]; then \
		sudo rm -rf $(DATA_DIR); \
		echo "Removed $(DATA_DIR)"; \
	else \
		echo "$(DATA_DIR) does not exist - skipping"; \
	fi
	@if [ -d "$(SSL_DIR)" ]; then \
		sudo rm -rf $(SSL_DIR); \
		echo "Removed $(SSL_DIR)"; \
	else \
		echo "$(SSL_DIR) does not exist - skipping"; \
	fi
	sudo docker system prune -af

re: fclean
	@sudo mkdir -p $(DATA_DIR)/{mariadb,wordpress}
	@sudo mkdir -p $(SSL_DIR)/{certs,private}
	@sudo chmod -R 755 $(DATA_DIR) $(SSL_DIR)
	sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout $(SSL_DIR)/private/nginx.key \
		-out $(SSL_DIR)/certs/nginx.crt \
		-subj "/CN=localhost"
	$(DC) -f $(DC_FILE) build
	$(DC) -f $(DC_FILE) up -d

ps:
	$(DC) -f $(DC_FILE) ps
