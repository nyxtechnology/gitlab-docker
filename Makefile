include docker.mk

.PHONY: hlp getpass runner-setup runner-shell runner-network

FILE_MATCH ?=

RUNNER_CONTAINER = $(shell docker ps --filter name='runner' --format "{{ .ID }}")

## hlp	:	Print commands help.
hlp : Makefile
	@sed -n 's/^##//p' $<

## getpass	:	Get the default password of Gitlab root account.
getpass :
	@make exec "grep -r 'Password:' /etc/gitlab/"

## runner-setup	:	Get the default password of Gitlab root account.
runner-setup :
	@docker exec -it $(RUNNER_CONTAINER) gitlab-runner register --url "http://$(GITLAB_HOST)" --clone-url "http://$(GITLAB_HOST)"

## runner-network	:	Setup gitlab-runner to use docker internal network.
runner-network :
	@docker-compose exec runner bash -c "echo '    network_mode = \"gitlab-network\"' >> /etc/gitlab-runner/config.toml"

## runner-exec	:	Executes any command in runner container WORKDIR (default is `/`).
## 		Doesn't support --flag arguments unless command is wrapped by quotes.
runner-exec:
	@docker-compose exec runner $(filter-out $@,$(MAKECMDGOALS))

## runner-shell	:	Access `runner` container via bash.
runner-shell :
	@docker exec -it -e COLUMNS=$(shell tput cols) -e LINES=$(shell tput lines) $(RUNNER_CONTAINER) bash
