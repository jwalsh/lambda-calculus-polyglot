g#!/bin/bash

# Exit on error
set -e

# Create the Clojure project
if [ ! -d "codeevaluatepro" ]; then
	echo "Creating new Clojure/ClojureScript project..."
	lein new reagent codeevaluatepro +spec +sass +devcards +cider +figwheel
else
	echo "Project directory already exists. Skipping project creation..."
fi

# Move into the project directory
cd codeevaluatepro

# Create necessary directories
echo "Creating directory structure..."
mkdir -p src/clj/codeevaluatepro/{ai,routes}
mkdir -p src/cljs/codeevaluatepro/components
mkdir -p src/cljc/codeevaluatepro
mkdir -p resources/sql


# Copy SQL files
echo "Copying SQL files..."
cp ../ai_code_generation_create.sql resources/sql/
cp ../ai_code_generation_list.sql resources/sql/
cp ../ai_code_generation_seed.sql resources/sql/

# Create basic files
echo "Creating basic files..."
touch src/clj/codeevaluatepro/config.clj
touch src/clj/codeevaluatepro/db.clj
touch src/clj/codeevaluatepro/server.clj
touch src/clj/codeevaluatepro/handler.clj
touch src/clj/codeevaluatepro/ai/{openai,azure_openai,anthropic,ollama}.clj
touch src/clj/codeevaluatepro/routes/{logs,evaluations}.clj
touch src/cljc/codeevaluatepro/models.cljc
touch src/cljs/codeevaluatepro/components/{grader_interface,example_log_entry,grading_rubric}.cljs

# Update .gitignore
echo "Updating .gitignore..."
echo "
# Clojure
/target
/classes
/checkouts
profiles.clj
pom.xml
pom.xml.asc
*.jar
*.class
/.lein-*
/.nrepl-port
/.prepl-port
.hgignore
.hg/

# ClojureScript
/resources/public/js/compiled/
/resources/public/css/compiled/
figwheel_server.log
pom.xml
*-init.clj
*.swp
*.swo

# Environment variables
.env

# IDE/Editor folders
/.idea
/.vscode
/*.iml

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
" >> .gitignore

echo "Setup complete! Your Clojure/ClojureScript project is ready in the 'codeevaluatepro' directory."
