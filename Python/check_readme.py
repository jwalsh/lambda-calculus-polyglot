import os

def check_and_update_readme(language_dir):
    readme_path = os.path.join(language_dir, "README.org")
    if os.path.exists(readme_path):
        with open(readme_path, 'r') as file:
            content = file.read().strip()
        if not content:
            overview = f"""
* Overview
:PROPERTIES:
:CUSTOM_ID: overview
:END:
This directory contains implementations of Lambda Calculus concepts in {language_dir}.

** Structure
:PROPERTIES:
:CUSTOM_ID: structure
:END:
- =src/=: Contains the source code for Lambda Calculus implementations in {language_dir}.
- =examples/=: Contains example usage of the Lambda Calculus implementations.

** Running the examples
:PROPERTIES:
:CUSTOM_ID: running-the-examples
:END:
Run each example file using the appropriate command for {language_dir}.
"""
            with open(readme_path, 'w') as file:
                file.write(overview)

def main():
    language_dirs = ["Python", "Scheme", "Node.js", "C", "Go", "Ruby", "Julia", "Kotlin", "Bash", "TypeScript", "Haskell"]
    for language_dir in language_dirs:
        check_and_update_readme(language_dir)

if __name__ == "__main__":
    main()
