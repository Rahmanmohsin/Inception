DC = docker compose
DC_FILE = srcs/docker-compose.yml
MARIADB_DIR = /home/mohrahma/data/mariadb
WORDPRESS_DIR = /home/mohrahma/data/wordpress

make:
	@mkdir -p $(MARIADB_DIR) $(WORDPRESS_DIR)
	@$(DC) -f $(DC_FILE) build
	@$(DC) -f $(DC_FILE) up -d

down:
	@$(DC) -f $(DC_FILE) down

start:
	@$(DC) -f $(DC_FILE) start

stop:
	@$(DC) -f $(DC_FILE) stop

restart:
	@$(DC) -f $(DC_FILE) restart

logs:
	@$(DC) -f $(DC_FILE) logs

volumes:
	@docker volume ls

clean:
	@$(DC) -f $(DC_FILE) down --rmi all --volumes --remove-orphans
	@$(DC) -f $(DC_FILE) kill
	@docker system prune -af

fclean: clean
	@sudo rm -rf $(MARIADB_DIR)
	@sudo rm -rf $(WORDPRESS_DIR)
ps:
	@$(DC) -f $(DC_FILE) ps

debug: logs ps volumes

re: fclean make

.PHONY: build  down start stop restart logs clean fclean re ps
