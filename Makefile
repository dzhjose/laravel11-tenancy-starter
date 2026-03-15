include ./environments/.env.docker

ENV_FILE ?= ./environments/.env.docker
DOCKER_COMPOSE := docker compose --env-file $(ENV_FILE)

.PHONY: up down build up-local reload

up:
	@$(DOCKER_COMPOSE) up -d --force-recreate

down:
	@$(DOCKER_COMPOSE) down

build:
	@$(DOCKER_COMPOSE) build

up-local:
	@$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.local.yml up -d --force-recreate

reload:
	@echo $(if $(filter local,$(strip $(subst ",,$(ENV)))), \
		"Reconstruyendo y levantando entorno LOCAL...", \
		$(if $(filter dev,$(ENVIRONMENT)), \
			"Reconstruyendo y levantando servidor de desarrollo...", \
			"Reconstruyendo y levantando servidor de producción..."))
	@$(MAKE) -s build
	@$(MAKE) -s down
	@$(MAKE) -s $(if $(filter local,$(ENV)),up-local,up)

initial-%:
	@docker exec -it $* sh -c "composer install --optimize-autoloader --no-dev"

artisan-cache-%:
	@docker exec -it $* sh -c "php artisan optimize && php artisan cache:clear"

exec-%:
	@docker exec -it $* sh -c "$(CMD)"
