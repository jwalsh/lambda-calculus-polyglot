all:
	uname -a

install:
	pip install openai psycopg2-binary click jinja2

.env: # .env.example
	@echo "cp .env.example .env"
	touch .env

list-ungraded:
	python ai_code_generation_grader.py list-ungraded

code-python:
	python ai_code_generation_logs.py --template prompt.md.tmpl --language Python --provider Anthropic --model claude-2

# Load environment variables from .env file
include .env
export

# Database name for Docker container
DB_CONTAINER_NAME = ai_code_gen_db

.PHONY: db-start db-stop db-restart db-logs

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
	
db-start:
	@echo "Starting Postgres..."

db-clean:
	@echo "Cleaning database..."

db-seed: .env
	@echo "Seeding database..."
