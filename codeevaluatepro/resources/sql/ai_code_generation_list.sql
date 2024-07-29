-- Display all contents of ai_code_generation_logs table
SELECT * FROM ai_code_generation_logs ORDER BY created_at DESC;

-- Display all contents of ai_response_evaluations table
SELECT * FROM ai_response_evaluations ORDER BY graded_at DESC;

-- Display a joined view of both tables
SELECT 
    l.id AS log_id,
    l.provider,
    l.model,
    LEFT(l.system_prompt, 50) AS system_prompt_preview,
    LEFT(l.user_prompt, 50) AS user_prompt_preview,
    LEFT(l.generated_code, 50) AS generated_code_preview,
    l.language,
    l.created_at,
    e.id AS evaluation_id,
    e.model_grade,
    e.human_grade,
    LEFT(e.rubric, 50) AS rubric_preview,
    LEFT(e.feedback, 50) AS feedback_preview,
    e.graded_at
FROM 
    ai_code_generation_logs l
LEFT JOIN 
    ai_response_evaluations e ON l.id = e.response_id
ORDER BY 
    l.created_at DESC, e.graded_at DESC;