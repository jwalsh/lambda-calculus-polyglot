-- Table for storing AI-generated code logs
CREATE TABLE IF NOT EXISTS ai_code_generation_logs (
    id SERIAL PRIMARY KEY,
    provider VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    system_prompt TEXT NOT NULL,
    user_prompt TEXT NOT NULL,
    generated_code TEXT NOT NULL,
    language VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for storing evaluations of AI-generated code
CREATE TABLE IF NOT EXISTS ai_response_evaluations (
    id SERIAL PRIMARY KEY,
    response_id INTEGER REFERENCES ai_code_generation_logs(id),
    model_grade FLOAT,
    human_grade FLOAT,
    rubric TEXT,
    feedback TEXT,
    graded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for faster lookups on response_id
CREATE INDEX IF NOT EXISTS idx_response_id ON ai_response_evaluations(response_id);

-- Index for faster sorting by graded_at
CREATE INDEX IF NOT EXISTS idx_graded_at ON ai_response_evaluations(graded_at);