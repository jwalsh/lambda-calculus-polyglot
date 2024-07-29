# Makefile for Lambda Calculus project

# Scheme implementations (uncomment the one you want to use)
SCHEME = guile
# SCHEME = chez --script
# SCHEME = chicken-csi -s
# SCHEME = racket -f
# SCHEME = mit-scheme --load

# Other variables
PYTHON = poetry run python
# PYTHON = python3
PIP = poetry run pip
# PIP = pip3
SCHEME_FILE = lc.scm
UTILS_FILE = lc-utils.scm
EXAMPLES_FILE = lc-examples.scm
PARSER = scheme_parser.py

# Phony targets
.PHONY: all install lint clean examples

# Default target
all: lint examples

# Install dependencies
install:
	$(PIP) install click

# Lint target to check for purity of lambda calculus implementation
lint:
	@echo "Checking purity of lambda calculus implementation..."
	@$(PYTHON) $(PARSER) $(SCHEME_FILE)

# Run examples
examples:
	@echo "Running Lambda Calculus examples using $(SCHEME)..."
	@$(SCHEME) $(EXAMPLES_FILE)

# Clean up any generated files (if any)
clean:
	@echo "Cleaning up..."
	@find . -type f -name '*.pyc' -delete
	@find . -type d -name '__pycache__' -delete

# Help target
help:
	@echo "Available targets:"
	@echo "  all      : Run the lint and examples targets (default)"
	@echo "  install  : Install required Python dependencies"
	@echo "  lint     : Check purity of lambda calculus implementation"
	@echo "  examples : Run Lambda Calculus examples"
	@echo "  clean    : Remove generated files"
	@echo "  help     : Show this help message"
	@echo ""
	@echo "To change the Scheme implementation, edit the SCHEME variable in the Makefile."
	@echo "Current SCHEME is set to: $(SCHEME)"
