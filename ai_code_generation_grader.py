import os
from typing import Dict, Any, List, Tuple
import psycopg2
from psycopg2 import sql
import click
from tabulate import tabulate

# Database connection parameters
db_params: Dict[str, Any] = {
    "dbname": os.getenv("PGDATABASE"),
    "user": os.getenv("PGUSER"),
    "password": os.getenv("PGPASSWORD"),
    "host": os.getenv("PGHOST"),
    "port": os.getenv("PGPORT")
}

def setup_grading_table() -> None:
    """Set up the database table for storing grading information."""
    conn = psycopg2.connect(**db_params)
    cur = conn.cursor()

    cur.execute("""
    CREATE TABLE IF NOT EXISTS ai_response_evaluations (
        id SERIAL PRIMARY KEY,
        response_id INTEGER REFERENCES ai_code_generation_logs(id),
        model_grade FLOAT,
        human_grade FLOAT,
        rubric TEXT,
        feedback TEXT,
        graded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    """)

    conn.commit()
    cur.close()
    conn.close()

def grade_response(response_id: int, rubric: str, provider_id: str) -> float:
    """Grade a response using the specified model and rubric."""
    conn = psycopg2.connect(**db_params)
    cur = conn.cursor()
    cur.execute("SELECT generated_code FROM ai_code_generation_logs WHERE id = %s", (response_id,))
    response = cur.fetchone()[0]
    cur.close()
    conn.close()

    # Placeholder for actual model grading
    model_grade = placeholder_model_grading(response, rubric, provider_id)

    return model_grade

def save_evaluation(response_id: int, model_grade: float, rubric: str) -> None:
    """Save the evaluation to the database."""
    conn = psycopg2.connect(**db_params)
    cur = conn.cursor()

    cur.execute("""
    INSERT INTO ai_response_evaluations (response_id, model_grade, rubric)
    VALUES (%s, %s, %s)
    """, (response_id, model_grade, rubric))

    conn.commit()
    cur.close()
    conn.close()

def update_human_grade(evaluation_id: int, human_grade: float, feedback: str) -> None:
    """Update the evaluation with a human-provided grade and feedback."""
    conn = psycopg2.connect(**db_params)
    cur = conn.cursor()

    cur.execute("""
    UPDATE ai_response_evaluations
    SET human_grade = %s, feedback = %s
    WHERE id = %s
    """, (human_grade, feedback, evaluation_id))

    conn.commit()
    cur.close()
    conn.close()

def list_evaluations() -> List[Tuple]:
    """List all evaluations."""
    conn = psycopg2.connect(**db_params)
    cur = conn.cursor()

    cur.execute("""
    SELECT e.id, e.response_id, e.model_grade, e.human_grade, 
           LEFT(l.generated_code, 50) as snippet
    FROM ai_response_evaluations e
    JOIN ai_code_generation_logs l ON e.response_id = l.id
    ORDER BY e.id DESC
    """)

    evaluations = cur.fetchall()
    cur.close()
    conn.close()

    return evaluations

def view_evaluation(evaluation_id: int) -> Tuple:
    """View details of a specific evaluation."""
    conn = psycopg2.connect(**db_params)
    cur = conn.cursor()

    cur.execute("""
    SELECT e.id, e.response_id, e.model_grade, e.human_grade, 
           e.rubric, e.feedback, l.generated_code
    FROM ai_response_evaluations e
    JOIN ai_code_generation_logs l ON e.response_id = l.id
    WHERE e.id = %s
    """, (evaluation_id,))

    evaluation = cur.fetchone()
    cur.close()
    conn.close()

    return evaluation

def list_ungraded_responses() -> List[Tuple]:
    """List responses that haven't been graded yet."""
    conn = psycopg2.connect(**db_params)
    cur = conn.cursor()

    cur.execute("""
    SELECT l.id, LEFT(l.generated_code, 50) as snippet
    FROM ai_code_generation_logs l
    LEFT JOIN ai_response_evaluations e ON l.id = e.response_id
    WHERE e.id IS NULL
    ORDER BY l.id DESC
    """)

    ungraded = cur.fetchall()
    cur.close()
    conn.close()

    return ungraded

@click.group()
def cli():
    pass

@cli.command()
@click.option('--response-id', type=int, required=True, help='ID of the response to grade')
@click.option('--rubric', type=str, required=True, help='Rubric for grading')
@click.option('--provider-id', type=str, required=True, help='ID of the provider to use for grading')
def grade(response_id: int, rubric: str, provider_id: str):
    """Grade a response using the specified model and rubric."""
    setup_grading_table()
    model_grade = grade_response(response_id, rubric, provider_id)
    save_evaluation(response_id, model_grade, rubric)
    click.echo(f"Response {response_id} graded. Model grade: {model_grade}")

@cli.command()
@click.option('--evaluation-id', type=int, required=True, help='ID of the evaluation to update')
@click.option('--human-grade', type=float, required=True, help='Grade provided by human reviewer')
@click.option('--feedback', type=str, required=True, help='Feedback from human reviewer')
def update_grade(evaluation_id: int, human_grade: float, feedback: str):
    """Update an evaluation with a human-provided grade and feedback."""
    update_human_grade(evaluation_id, human_grade, feedback)
    click.echo(f"Evaluation {evaluation_id} updated with human grade and feedback.")

@cli.command()
def list():
    """List all evaluations."""
    evaluations = list_evaluations()
    headers = ["ID", "Response ID", "Model Grade", "Human Grade", "Code Snippet"]
    click.echo(tabulate(evaluations, headers=headers))

@cli.command()
@click.option('--evaluation-id', type=int, required=True, help='ID of the evaluation to view')
def view(evaluation_id: int):
    """View details of a specific evaluation."""
    evaluation = view_evaluation(evaluation_id)
    if evaluation:
        click.echo(f"Evaluation ID: {evaluation[0]}")
        click.echo(f"Response ID: {evaluation[1]}")
        click.echo(f"Model Grade: {evaluation[2]}")
        click.echo(f"Human Grade: {evaluation[3]}")
        click.echo(f"Rubric: {evaluation[4]}")
        click.echo(f"Feedback: {evaluation[5]}")
        click.echo("Generated Code:")
        click.echo(evaluation[6])
    else:
        click.echo(f"No evaluation found with ID {evaluation_id}")

@cli.command()
def list_ungraded():
    """List responses that haven't been graded yet."""
    ungraded = list_ungraded_responses()
    headers = ["Response ID", "Code Snippet"]
    click.echo(tabulate(ungraded, headers=headers))

def placeholder_model_grading(response: str, rubric: str, provider_id: str) -> float:
    """Placeholder function for model grading."""
    import random
    return random.random()

if __name__ == "__main__":
    cli()