include .env

.PHONY: up down stop prune ps shell exec logs

default: up

## help	:	Print commands help.
help : docker.mk
	@sed -n 's/^##//p' $<

## up	:	Start up containers.
up:
	@echo "Starting up containers for Gitlab..."
	docker-compose pull
	docker-compose up -d --remove-orphans

## down	:	Stop containers.
down: stop

## start	:	Start containers without updating.
start:
	@echo "Starting containers for Gitlab from where you left off..."
	@docker-compose start

## stop	:	Stop containers.
stop:
	@echo "Stopping containers for Gitlab..."
	@docker-compose stop

## prune	:	Remove containers and their volumes.
##		You can optionally pass an argument with the service name to prune single container
##		prune gitlab	: Prune `gitlab` container and remove its volumes.
##		prune gitlab runner	: Prune `gitlab` and `runner` containers and remove their volumes.
prune:
	@echo "Removing containers for Gitlab..."
	@docker-compose down -v $(filter-out $@,$(MAKECMDGOALS))

## ps	:	List running containers.
ps:
	@docker-compose ps

## shell	:	Access `gitlab` container via shell.
shell:
	docker exec -ti -e COLUMNS=$(shell tput cols) -e LINES=$(shell tput lines) $(shell docker ps --filter name='$(PROJECT_NAME)_gitlab' --format "{{ .ID }}") bash

## exec	:	Executes any command in gitlab container WORKDIR (default is `/`).
## 		Doesn't support --flag arguments unless command is wrapped by quotes.
exec:
	docker-compose exec gitlab $(filter-out $@,$(MAKECMDGOALS))

## logs	:	View containers logs.
##		You can optinally pass an argument with the service name to limit logs
##		logs gitlab	: View `gitlab` container logs.
##		logs runner gitlab	: View `runner` and `gitlab` containers logs.
logs:
	@docker-compose logs -f $(filter-out $@,$(MAKECMDGOALS))

# https://stackoverflow.com/a/6273809/1826109
%:
	@:
