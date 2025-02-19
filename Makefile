ENV_FILE := ./srcs/.env
SSL_FOLDER := ./secrets/ssl
SSL_FILES = $(SSL_FOLDER)/chain.pem \
			$(SSL_FOLDER)/fullchain.pem \
			$(SSL_FOLDER)/privkey.pem
COMPOSE_FILE := ./srcs/docker-compose.yml

all: $(ENV_FILE) $(SSL_FILES) run


$(ENV_FILE):
	@cp ~/.env ./srcs

$(SSL_FILES):
	@mkdir -p secrets
	@cp -r ~/ssl ./secrets

build:
	@docker-compose -f $(COMPOSE_FILE) build

run:
	@docker-compose -f $(COMPOSE_FILE) up -d

stop:
	@docker-compose -f $(COMPOSE_FILE) down

clean: stop
	@docker system prune -f

fclean: clean
	-@docker rm -fv $(shell docker ps -aq)
	-@docker rmi $(shell docker image ls -q)
	-@docker volume rm $(shell docker volume ls -q)
	-@rm -rf secrets ./srcs/wp-content ./srcs/.env


.PHONY: all build run stop clean fclean
