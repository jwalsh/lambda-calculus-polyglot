# Lambda Calculus Implementation in Python
# Author: Claude 3.5 Sonnet (Anthropic, PBC)
# Date: July 29, 2024
# Filename: lambda_calculus.py
# Usage: Run this file in a Python interpreter to use the Lambda Calculus functions interactively

# Step 1: Understand Lambda Expressions
identity = lambda x: x
# Usage: identity(5) returns 5

# Step 2: Implement Church Booleans
lc_true = lambda x: lambda y: x
lc_false = lambda x: lambda y: y
lc_if = lambda condition: lambda then: lambda else_: condition(then)(else_)
# Usage: lc_if(lc_true)("yes")("no") returns "yes"

# Step 3: Implement Basic Combinators
I = lambda x: x
K = lambda x: lambda y: x
KI = lambda x: lambda y: y

# Step 4: Create Church Numerals
lc_zero = lambda f: lambda x: x
lc_succ = lambda n: lambda f: lambda x: f(n(f)(x))

def church_to_int(n):
    return n(lambda x: x + 1)(0)

# Step 5: Implement Basic Arithmetic
lc_add = lambda m: lambda n: lambda f: lambda x: m(f)(n(f)(x))
lc_mult = lambda m: lambda n: lambda f: m(n(f))

lc_one = lc_succ(lc_zero)
lc_two = lc_succ(lc_one)

# Step 6: Implement Pairs
lc_pair = lambda x: lambda y: lambda f: f(x)(y)
lc_first = lambda p: p(lambda x: lambda y: x)
lc_second = lambda p: p(lambda x: lambda y: y)

# Step 7: Build Lists Using Pairs
lc_nil = lambda x: lc_true
lc_cons = lc_pair
lc_is_nil = lambda l: l(lambda h: lambda t: lc_false)
lc_head = lc_first
lc_tail = lc_second

# Step 8: Implement Comparison Operations
lc_is_zero = lambda n: n(lambda x: lc_false)(lc_true)
lc_leq = lambda m: lambda n: lc_is_zero(lc_sub(m)(n))
lc_eq = lambda m: lambda n: lc_and(lc_leq(m)(n))(lc_leq(n)(m))

# Helper functions for comparison operations
lc_and = lambda x: lambda y: x(y)(lc_false)
lc_sub = lambda m: lambda n: n(lambda n: lambda f: lambda x: n(lambda g: lambda h: h(g(f)))(lambda y: x)(lambda y: y))(m)

# Step 9: Implement Higher-Order List Operations
lc_map = lambda f: lambda l: lc_if(lc_is_nil(l))(lc_nil)(lambda: lc_cons(f(lc_head(l)))(lc_map(f)(lc_tail(l))))()
lc_filter = lambda p: lambda l: lc_if(lc_is_nil(l))(lc_nil)(lambda: lc_if(p(lc_head(l)))(lambda: lc_cons(lc_head(l))(lc_filter(p)(lc_tail(l))))(lambda: lc_filter(p)(lc_tail(l))))()
lc_fold = lambda f: lambda acc: lambda l: lc_if(lc_is_nil(l))(acc)(lambda: lc_fold(f)(f(acc)(lc_head(l)))(lc_tail(l)))()

# Step 10: Explore Recursion and Fixed-Point Combinators
Y = lambda f: (lambda x: f(lambda y: x(x)(y)))(lambda x: f(lambda y: x(x)(y)))

# Example usage of Y combinator for factorial
factorial = Y(lambda f: lambda n: lc_if(lc_is_zero(n))(lc_one)(lambda: lc_mult(n)(f(lc_sub(n)(lc_one))))())

# Helper function to convert Python list to Church-encoded list
def list_to_church(lst):
    if not lst:
        return lc_nil
    return lc_cons(lst[0])(list_to_church(lst[1:]))

# Helper function to convert Church-encoded list to Python list
def church_to_list(l):
    result = []
    while not lc_is_nil(l)(True):
        result.append(lc_head(l))
        l = lc_tail(l)
    return result

# Example usage
if __name__ == "__main__":
    print("Church numeral 3:", church_to_int(lc_add(lc_one)(lc_two)))
    print("2 * 3 =", church_to_int(lc_mult(lc_two)(lc_succ(lc_two))))
    
    my_pair = lc_pair(1)(2)
    print("First of pair:", lc_first(my_pair))
    print("Second of pair:", lc_second(my_pair))
    
    my_list = list_to_church([1, 2, 3])
    print("Original list:", church_to_list(my_list))
    
    doubled_list = lc_map(lambda x: x * 2)(my_list)
    print("Doubled list:", church_to_list(doubled_list))
    
    filtered_list = lc_filter(lambda x: x > 1)(my_list)
    print("Filtered list:", church_to_list(filtered_list))
    
    sum_list = lc_fold(lambda x: lambda y: x + y)(0)(my_list)
    print("Sum of list:", sum_list)
    
    print("Factorial of 5:", church_to_int(factorial(lc_add(lc_two)(lc_succ(lc_two)))))
