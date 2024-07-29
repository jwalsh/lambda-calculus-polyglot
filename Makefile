# TODO: Swap out to llama3.1:70b
ollama:
	cat llm-prompt.md | ollama run llama3.1

mistral:
	cat llm-prompt.md | mistral run mistral
