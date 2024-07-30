# Makefile for CodeEvaluatePro

# Variables
LEIN := lein
NPM := npm

# Colors for pretty output
CYAN := \033[0;36m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

.PHONY: all clean deps compile test run build deploy help

## Install dependencies, compile, and run tests
all: deps compile test

## Remove build artifacts
clean:
	@echo "$(CYAN)Cleaning project...$(NC)"
	$(LEIN) clean
	rm -rf target resources/public/js/compiled

## Install project dependencies
deps:
	@echo "$(CYAN)Installing dependencies...$(NC)"
	$(LEIN) deps
	$(NPM) install

## Compile ClojureScript for production
compile:
	@echo "$(CYAN)Compiling ClojureScript for production...$(NC)"
	$(LEIN) cljsbuild once min

## Run tests
test:
	@echo "$(CYAN)Running tests...$(NC)"
	$(LEIN) test

## Start development server
run:
	@echo "$(CYAN)Starting development server...$(NC)"
	$(LEIN) figwheel

## Build production JAR
build:
	@echo "$(CYAN)Building production JAR...$(NC)"
	$(LEIN) uberjar

## Deploy (placeholder, adjust as needed)
deploy:
	@echo "$(YELLOW)Deploying application...$(NC)"
	@echo "TODO: Add deployment steps here"

## Display this help message
help:
	@echo "$(CYAN)Available targets:$(NC)"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  $(YELLOW)%-15s$(NC) %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
