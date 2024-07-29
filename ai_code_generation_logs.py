import os
from typing import Optional, Dict, Any
import openai
import psycopg2
from psycopg2 import sql
import click
from jinja2 import Template

# Set up OpenAI API key
openai.api_key = os.getenv("OPENAI_API_KEY")

# Database connection parameters
db_params: Dict[str, Any] = {
    "dbname": os.getenv("PGDATABASE"),
    "user": os.getenv("PGUSER"),
    "password": os.getenv("PGPASSWORD"),
    "host": os.getenv("PGHOST"),
    "port": os.getenv("PGPORT")
}


def get_code_from_openai(system_prompt: str,
                         user_prompt: str,
                         model: str = "gpt-3.5-turbo") -> str:
    """
    Generate code using OpenAI's API based on the given prompts.

    Args:
        system_prompt (str): The system prompt for setting context.
        user_prompt (str): The user prompt for specific instructions.
        model (str): The OpenAI model to use. Defaults to "gpt-3.5-turbo".

    Returns:
        str: The generated code.
    """
    response = openai.ChatCompletion.create(model=model,
                                            messages=[{
                                                "role": "system",
                                                "content": system_prompt
                                            }, {
                                                "role": "user",
                                                "content": user_prompt
                                            }])
    return response.choices[0].message.content


def setup_database() -> None:
    """
    Set up the database by creating necessary tables if they don't exist.
    """
    conn = psycopg2.connect(**db_params)
    cur = conn.cursor()

    # Create ai_code_generation_logs table if it doesn't exist
    cur.execute("""
    CREATE TABLE IF NOT EXISTS ai_code_generation_logs (
        id SERIAL PRIMARY KEY,
        provider VARCHAR(50) NOT NULL,
        model VARCHAR(50) NOT NULL,
        system_prompt TEXT NOT NULL,
        user_prompt TEXT NOT NULL,
        generated_code TEXT NOT NULL,
        language VARCHAR(50) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    """)

    conn.commit()
    cur.close()
    conn.close()


def save_to_database(provider: str, model: str, system_prompt: str,
                     user_prompt: str, generated_code: str,
                     language: str) -> None:
    """
    Save the generated code and associated information to the database.

    Args:
        provider (str): The AI provider (e.g., "OpenAI").
        model (str): The model used for generation.
        system_prompt (str): The system prompt used.
        user_prompt (str): The user prompt used.
        generated_code (str): The generated code.
        language (str): The programming language of the generated code.
    """
    conn = psycopg2.connect(**db_params)
    cur = conn.cursor()

    insert_query = sql.SQL("""
    INSERT INTO ai_code_generation_logs 
    (provider, model, system_prompt, user_prompt, generated_code, language)
    VALUES (%s, %s, %s, %s, %s, %s)
    """)
    cur.execute(insert_query, (provider, model, system_prompt, user_prompt,
                               generated_code, language))

    conn.commit()
    cur.close()
    conn.close()


def read_template(template_file: str) -> str:
    """
    Read the content of a template file.

    Args:
        template_file (str): Path to the template file.

    Returns:
        str: Content of the template file.
    """
    with open(template_file, 'r') as file:
        return file.read()


@click.command()
@click.option('--template',
              default='prompt.md.tmpl',
              help='Template file for the prompt')
@click.option('--language',
              default='Scheme',
              help='Programming language for code generation')
@click.option('--model', default='gpt-3.5-turbo', help='OpenAI model to use')
def main(template: str, language: str, model: str) -> None:
    """
    Main function to generate code from a template and save it to the database.

    Args:
        template (str): Path to the template file.
        language (str): Programming language for code generation.
        model (str): OpenAI model to use for generation.
    """
    setup_database()

    try:
        template_content = read_template(template)
    except FileNotFoundError:
        click.echo(
            f"Template file '{template}' not found. Using default prompt.")
        template_content = "Generate {{language}} code to {{task}}"

    # Render the template
    rendered_template = Template(template_content).render(language=language)

    # Get user input for the task
    task = click.prompt("Enter the coding task")

    # Generate the final prompt
    user_prompt = rendered_template.replace("{{task}}", task)
    system_prompt = f"You are a helpful assistant that generates {language} code."

    click.echo(f"Generating {language} code using {model} for: {user_prompt}")

    generated_code = get_code_from_openai(system_prompt, user_prompt, model)
    click.echo("Generated Code:")
    click.echo(generated_code)

    save_to_database("OpenAI", model, system_prompt, user_prompt,
                     generated_code, language)
    click.echo("Code and metadata saved to database.")


if __name__ == "__main__":
    main()
