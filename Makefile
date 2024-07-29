# Load environment variables from .env file
include .env
export

# Variables
DB_CONTAINER_NAME := ai_code_gen_db
PYTHON := python3
PIP := pip3
DOCKER := docker

# Colors for pretty output
CYAN := \033[0;36m
GREEN := \033[0;32m
YELLOW := \033[0;33m
NC := \033[0m # No Color

# Phony targets
.PHONY: all install env db-start db-stop db-restart db-logs db-clean db-seed \
        list-ungraded code-python ollama mistral help

# Default target
## Display system information
all: env
	@echo "$(CYAN)System Information:$(NC)"
	@uname -a

# Environment setup
## Install Python dependencies
install:
	@echo "$(CYAN)Installing Python dependencies...$(NC)"
	$(PIP) install -r requirements.txt

## Create .env file from .env.example
env: .env
.env:
	@echo "$(YELLOW)Creating .env file from .env.example$(NC)"
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "$(GREEN)Created .env file. Please update it with your specific configurations.$(NC)"; \
	else \
		echo "$(YELLOW).env file already exists. Skipping creation.$(NC)"; \
	fi

# Database operations
## Start PostgreSQL database in Docker
db-start:
	@echo "$(CYAN)Starting PostgreSQL database...$(NC)"
	@$(DOCKER) build -t ai-code-gen-postgres .
	@$(DOCKER) run --name $(DB_CONTAINER_NAME) \
		-e POSTGRES_DB=$(PGDATABASE) \
		-e POSTGRES_USER=$(PGUSER) \
		-e POSTGRES_PASSWORD=$(PGPASSWORD) \
		-p $(PGPORT):5432 \
		-d ai-code-gen-postgres
	@echo "$(GREEN)Database started successfully.$(NC)"

## Stop and remove database container
db-stop:
	@echo "$(CYAN)Stopping PostgreSQL database...$(NC)"
	@$(DOCKER) stop $(DB_CONTAINER_NAME)
	@$(DOCKER) rm $(DB_CONTAINER_NAME)
	@echo "$(GREEN)Database stopped and container removed.$(NC)"

## Restart database container
db-restart: db-stop db-start

## View database container logs
db-logs:
	@echo "$(CYAN)Viewing database logs:$(NC)"
	@$(DOCKER) logs $(DB_CONTAINER_NAME)

## Clean the database (placeholder)
db-clean:
	@echo "$(YELLOW)Cleaning database...$(NC)"
	@echo "TODO: Add commands to clean the database"

## Seed the database (placeholder)
db-seed: env
	@echo "$(CYAN)Seeding database...$(NC)"
	@echo "TODO: Add commands to seed the database"

# Application commands
## List ungraded code generations
list-ungraded:
	@echo "$(CYAN)Listing ungraded code generations:$(NC)"
	$(PYTHON) ai_code_generation_grader.py list-ungraded

## Generate Python code using Anthropic's Claude-2
code-python:
	@echo "$(CYAN)Generating Python code using Anthropic's Claude-2:$(NC)"
	$(PYTHON) ai_code_generation_logs.py \
		--template prompt.md.tmpl \
		--language Python \
		--provider Anthropic \
		--model claude-2

## Run Ollama with llama3.1
ollama:
	@echo "$(CYAN)Running Ollama with llama3.1:$(NC)"
	cat llm-prompt.md | ollama run llama3.1

## Run Mistral
mistral:
	@echo "$(CYAN)Running Mistral:$(NC)"
	cat llm-prompt.md | mistral run mistral

# Help target
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
