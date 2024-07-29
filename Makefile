# Load environment variables from .env file
include .env
export

# Variables
DB_CONTAINER_NAME = ai_code_gen_db
PYTHON = python
PIP = pip

# Phony targets
.PHONY: all install env db-start db-stop db-restart db-logs db-clean db-seed \
        list-ungraded code-python

# Default target
all:
	uname -a

# Environment setup
install:
	$(PIP) install openai psycopg2-binary click jinja2

env: .env

.env:
	@echo "Creating .env file from .env.example"
	@echo "cp .env.example .env"
	touch .env
	@echo "Please update .env with your specific configurations"

# Database operations
db-start:
	@echo "Starting PostgreSQL database..."
	@docker build -t ai-code-gen-postgres .
	@docker run --name $(DB_CONTAINER_NAME) \
		-e POSTGRES_DB=$(PGDATABASE) \
		-e POSTGRES_USER=$(PGUSER) \
		-e POSTGRES_PASSWORD=$(PGPASSWORD) \
		-p $(PGPORT):5432 \
		-d ai-code-gen-postgres

db-stop:
	@echo "Stopping PostgreSQL database..."
	@docker stop $(DB_CONTAINER_NAME)
	@docker rm $(DB_CONTAINER_NAME)

db-restart: db-stop db-start

db-logs:
	@docker logs $(DB_CONTAINER_NAME)

db-clean:
	@echo "Cleaning database..."
	# Add commands to clean the database if needed

db-seed: env
	@echo "Seeding database..."
	# Add commands to seed the database

# Application commands
list-ungraded:
	$(PYTHON) ai_code_generation_grader.py list-ungraded

code-python:
	$(PYTHON) ai_code_generation_logs.py \
		--template prompt.md.tmpl \
		--language Python \
		--provider Anthropic \
		--model claude-2

# Help target
help:
	@echo "Available targets:"
	@echo "  all            - Display system information"
	@echo "  install        - Install Python dependencies"
	@echo "  env            - Create .env file from .env.example"
	@echo "  db-start       - Start PostgreSQL database in Docker"
	@echo "  db-stop        - Stop and remove database container"
	@echo "  db-restart     - Restart database container"
	@echo "  db-logs        - View database container logs"
	@echo "  db-clean       - Clean the database (placeholder)"
	@echo "  db-seed        - Seed the database (placeholder)"
	@echo "  list-ungraded  - List ungraded code generations"
	@echo "  code-python    - Generate Python code using Anthropic's Claude-2"
	@echo "  help           - Display this help message"