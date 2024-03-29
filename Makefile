PHONY: help
.DEFAULT_GOAL = help

dc = docker-compose
de = $(dc) exec
dec = $(de) php bash
la = artisan
composer = $(dec) php -d memory_limit=-1 /usr/local/bin/composer
npm = npm install

## —— Docker 🐳  ———————————————————————————————————————————————————————————————
.PHONY: start
start:	## Start docker stack
	$(dc) up -d
	$(composer) install
	$(dc) exec php bash -c 'npm install && npm run dev'
	$(dc) exec php bash -c 'php artisan key:generate'
	$(dc) exec php bash -c 'php artisan migrate'

.PHONY: in-dc
in-dc:	## Run into php container
	$(de) php bash

.PHONY: dev ## Run dev server
dev:
	$(dc) up

.PHONY: deploy ## Run dev server
deploy:
	$(dc) up -d
	$(composer) install
	$(dc) exec php bash -c 'npm install && npm run prod'
	$(dc) exec php bash -c 'php artisan key:generate'
	$(dc) exec php bash -c 'php artisan migrate'


## —— Laravel ———————————————————————————————————————————————————————————————

.PHONY: vendor-install
vendor-install: ## Install composer dependencies
	$(COMPOSER) install

.PHONY: vendor-update
vendor-update:	## Update composer dependencies
	$(COMPOSER) update

.PHONY: ui ## install laravel ui
ui:
	$(composer) require laravel/ui

.PHONY: user ## make auth
user:
	$(de) composer require laravel/ui

.PHONY: controller ## make controller
controller:
	$(la) make:controller

.PHONY: controller ## make model and migration
controller:
	$(la) make:model -m

## —— Others 🛠️️ ———————————————————————————————————————————————————————————————
help: ## Show help
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
