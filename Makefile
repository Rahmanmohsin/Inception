DC = docker compose
DC_FILE = srcs/docker-compose.yml
DATA_DIR = /home/mohrahma/data
SSL_DIR = srcs/requirements/nginx/ssl

.PHONY: build up down start stop restart logs clean fclean re ps

debug: build up log ps volumes

build:
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
	$(DC) -f $(DC_FILE) kill
	docker system prune -af

re: fclean build up

ps:
	$(DC) -f $(DC_FILE) ps
