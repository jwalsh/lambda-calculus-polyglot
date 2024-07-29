# Y Combinator
Y = lambda f: (lambda x: f(lambda y: x(x)(y)))(lambda x: f(lambda y: x(x)(y)))

# Factorial using Y Combinator
factorial = Y(lambda f: lambda n: 1 if n == 0 else n * f(n - 1))

# Usage
print(factorial(5))  # Output: 120
