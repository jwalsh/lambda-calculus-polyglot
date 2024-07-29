import React, { useState } from 'react';
import { Card, CardHeader, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

const GraderInterface = () => {
  const [graderName, setGraderName] = useState('Alyssa P. Hacker');
  const [humanGrade, setHumanGrade] = useState('');
  const [feedback, setFeedback] = useState('');

  const defaultRubric = `1. Code Correctness (0-5 points)
2. Code Efficiency (0-5 points)
3. Code Readability (0-5 points)
4. Proper Use of Language Features (0-5 points)
5. Comments and Documentation (0-5 points)

Total: Sum of all categories (max 25 points)`;

  const exampleLogEntry = {
    id: 1,
    provider: "OpenAI",
    model: "GPT-4",
    system_prompt: "You are a Python coding assistant.",
    user_prompt: "Write a function to calculate the factorial of a number.",
    generated_code: `def factorial(n):
    if n == 0 or n == 1:
        return 1
    else:
        return n * factorial(n-1)`,
    language: "Python",
    created_at: "2024-07-29T10:30:00Z"
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log("Grader Name:", graderName);
    console.log("Submitted grade:", humanGrade);
    console.log("Submitted feedback:", feedback);
    // In a real application, this would send the data to the backend
  };

  return (
    <div className="p-4 max-w-4xl mx-auto">
      <Card className="mb-6">
        <CardHeader>
          <h2 className="text-lg font-semibold">Grade Submission</h2>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label htmlFor="name" className="block mb-2">Grader Name:</label>
              <Input
                id="name"
                type="text"
                value={graderName}
                onChange={(e) => setGraderName(e.target.value)}
                required
              />
            </div>
            <div>
              <label htmlFor="grade" className="block mb-2">Your Grade (0-25):</label>
              <Input
                id="grade"
                type="number"
                min="0"
                max="25"
                value={humanGrade}
                onChange={(e) => setHumanGrade(e.target.value)}
                required
              />
            </div>
            <div>
              <label htmlFor="feedback" className="block mb-2">Feedback:</label>
              <textarea
                id="feedback"
                value={feedback}
                onChange={(e) => setFeedback(e.target.value)}
                className="w-full p-2 border rounded"
                rows={4}
                required
              />
            </div>
            <Button type="submit">Submit Grade</Button>
          </form>
        </CardContent>
      </Card>

      <Card className="mb-6">
        <CardHeader>
          <h2 className="text-lg font-semibold">Example Log Entry</h2>
        </CardHeader>
        <CardContent>
          <pre className="bg-gray-100 p-4 rounded overflow-x-auto">
            {JSON.stringify(exampleLogEntry, null, 2)}
          </pre>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <h2 className="text-lg font-semibold">Grading Rubric</h2>
        </CardHeader>
        <CardContent>
          <pre className="bg-gray-100 p-4 rounded">{defaultRubric}</pre>
        </CardContent>
      </Card>
    </div>
  );
};

export default GraderInterface;
