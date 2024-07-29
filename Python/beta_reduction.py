def beta_reduce(func, arg):
    return func(arg)

# Example
add_one = lambda x: x + 1
result = beta_reduce(add_one, 5)
print(result)  # Output: 6
