-- Seed data for ai_code_generation_logs
INSERT INTO ai_code_generation_logs (provider, model, system_prompt, user_prompt, generated_code, language, created_at) VALUES
('OpenAI', 'gpt-3.5-turbo', 'You are a helpful coding assistant.', 'Write a Python function to calculate the factorial of a number.', 
'def factorial(n):
    if n == 0 or n == 1:
        return 1
    else:
        return n * factorial(n-1)', 
'Python', '2023-07-15 10:00:00'),

('Anthropic', 'claude-3-opus-20240229', 'You are an AI specialized in Java programming.', 'Create a Java class for a simple bank account.',
'public class BankAccount {
    private String accountNumber;
    private double balance;

    public BankAccount(String accountNumber, double initialBalance) {
        this.accountNumber = accountNumber;
        this.balance = initialBalance;
    }

    public void deposit(double amount) {
        balance += amount;
    }

    public void withdraw(double amount) {
        if (amount <= balance) {
            balance -= amount;
        } else {
            System.out.println("Insufficient funds");
        }
    }

    public double getBalance() {
        return balance;
    }
}',
'Java', '2023-08-20 14:30:00'),

('Ollama', 'llama3.1-70b', 'You are a coding assistant specializing in JavaScript.', 'Write a JavaScript function to reverse a string.',
'function reverseString(str) {
    return str.split("").reverse().join("");
}',
'JavaScript', '2023-09-10 09:15:00'),

('Azure OpenAI', 'gpt-4', 'You are an AI assistant for C# programming.', 'Create a C# program to find the largest number in an array.',
'using System;

class Program
{
    static int FindLargest(int[] numbers)
    {
        if (numbers == null || numbers.Length == 0)
            throw new ArgumentException("Array is empty or null");

        int largest = numbers[0];
        for (int i = 1; i < numbers.Length; i++)
        {
            if (numbers[i] > largest)
                largest = numbers[i];
        }
        return largest;
    }

    static void Main(string[] args)
    {
        int[] numbers = { 10, 5, 8, 12, 3 };
        Console.WriteLine($"The largest number is: {FindLargest(numbers)}");
    }
}',
'C#', '2023-10-05 11:45:00');

-- Seed data for ai_response_evaluations
INSERT INTO ai_response_evaluations (response_id, model_grade, human_grade, rubric, feedback, graded_at) VALUES
(1, 0.85, 0.9, 'Evaluate code for correctness, efficiency, and readability', 'Good implementation of recursion. Could add error handling for negative inputs.', '2023-07-15 10:30:00'),
(2, 0.92, 0.88, 'Assess object-oriented design principles and code structure', 'Excellent encapsulation. Consider adding input validation in the constructor.', '2023-08-20 15:00:00'),
(3, 0.78, 0.82, 'Check for code simplicity and performance', 'Concise solution. Could mention potential issues with very long strings.', '2023-09-10 09:45:00'),
(4, 0.88, 0.85, 'Evaluate error handling and code efficiency', 'Good error handling. Consider using LINQ for a more concise solution.', '2023-10-05 12:15:00');