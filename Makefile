DC = docker compose
DC_FILE = srcs/docker-compose.yml

.PHONY: build up down start stop restart logs clean fclean re ps

debug: build up log ps volumes

build:		# Build Docker containers 
	$(DC) -f $(DC_FILE) build

up:			# Start Docker containers in the background
	$(DC) -f $(DC_FILE) up -d

down:		# Stop and remove Docker containers
	$(DC) -f $(DC_FILE) down

start: 		# Start previously stopped containers
	$(DC) -f $(DC_FILE) start

stop:		# Stop running containers without removing them
	$(DC) -f $(DC_FILE) stop

restart:	# Restart running containers
	$(DC) -f $(DC_FILE) restart

log:		# Show logs from all containers
	$(DC) -f $(DC_FILE) logs

volumes:		# List all volumes
	$(DC) -f $(DC_FILE) volume ls

clean:		# Stop and remove containers, networks, images, volumes and orphaned containers
	$(DC) -f $(DC_FILE) down --rmi all --volumes --remove-orphans

fclean: 	# Force stop and remove containers, networks, images, volumes, and orphaned containers
	$(DC) -f $(DC_FILE) down --rmi all --volumes --remove-orphans
	$(DC) -f $(DC_FILE) rm -f
	$(DC) -f $(DC_FILE) kill
	# rm -r srcs/web

re: fclean build 	# Rebuild the containers
	$(DC) -f $(DC_FILE) up -d

ps:					# List containers
	$(DC) -f $(DC_FILE) ps