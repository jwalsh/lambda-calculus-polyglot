# TODO: Swap out to llama3.1:70b
ollama:
	cat llm-prompt.md | ollama run llama3.1

mistral:
	cat llm-prompt.md | mistral run mistral

all:
	uname -a

install:
	pip install openai psycopg2-binary click jinja2

list-ungraded:
	python ai_code_generation_grader.py list-ungraded

code-python:
	python ai_code_generation_logs.py --template prompt.md.tmpl --language Python --provider Anthropic --model claude-2

