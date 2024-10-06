# Makefile

ENV_FILE ?= ./environments/.env.docker

up:
	@docker compose --env-file $(ENV_FILE) up -d --force-recreate

up-local:
	@docker compose --env-file $(ENV_FILE) -f docker-compose.yml -f docker-compose.local.yml up -d --force-recreate

down:
	@docker compose --env-file $(ENV_FILE) down

build:
	@docker compose --env-file $(ENV_FILE) build

.PHONY: up down build up-local
