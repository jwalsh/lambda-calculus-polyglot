def identity(x):
    return x

def apply_to_self(f):
    return f(f)

# Usage
print(identity(5))  # Output: 5
print(apply_to_self(lambda x: x + 1))  # Output: <function <lambda> at ...>
