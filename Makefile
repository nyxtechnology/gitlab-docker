include docker.mk

.PHONY: hlp getpass runner-setup shell-runner

FILE_MATCH ?=

BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
RUNNER_CONTAINER = $(shell docker ps --filter name='runner' --format "{{ .ID }}")

## hlp	:	Print commands help.
hlp : Makefile
	@sed -n 's/^##//p' $<

## getpass :	Get the default password of Gitlab root account.
getpass :
	@make exec "grep -r 'Password' /etc/gitlab/"

runner-setup :
	@docker exec -it $(RUNNER_CONTAINER) gitlab-runner register --url "http://$(GITLAB_HOST)" --clone-url "http://$(GITLAB_HOST)"

shell-runner :
	@docker exec -it $(RUNNER_CONTAINER) bash
