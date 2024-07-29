# Church numerals
zero = lambda f: lambda x: x
one = lambda f: lambda x: f(x)
two = lambda f: lambda x: f(f(x))

# Successor function
succ = lambda n: lambda f: lambda x: f(n(f)(x))

# Addition
add = lambda m: lambda n: lambda f: lambda x: m(f)(n(f)(x))

# Multiplication
mult = lambda m: lambda n: lambda f: m(n(f))

# Church numeral to integer
to_int = lambda n: n(lambda x: x + 1)(0)

# Usage
print(to_int(zero))  # Output: 0
print(to_int(one))   # Output: 1
print(to_int(two))   # Output: 2
print(to_int(add(one)(two)))  # Output: 3
print(to_int(mult(two)(two)))  # Output: 4
