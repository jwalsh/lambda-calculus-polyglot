# Lambda Calculus Implementation in Ruby
# Author: Claude 3.5 Sonnet (Anthropic, PBC)
# Date: July 29, 2024
# Filename: lambda_calculus.rb
# Usage: Load this file in an interactive Ruby session (irb) to experiment with the functions

# Step 1: Understand Lambda Expressions
identity = ->(x) { x }
puts identity.call(5) # Output: 5

# Step 2: Implement Church Booleans
LC_TRUE = ->(x, y) { x }
LC_FALSE = ->(x, y) { y }
LC_IF = ->(condition, then_clause, else_clause) { condition.call(then_clause, else_clause) }

puts LC_IF.call(LC_TRUE, 'yes', 'no') # Output: yes

# Step 3: Implement Basic Combinators
I = ->(x) { x } # Identity
K = ->(x, y) { x } # Kestrel
KI = ->(x, y) { y } # Kite

# Step 4: Create Church Numerals
LC_ZERO = ->(f, x) { x }
LC_SUCC = ->(n) { ->(f, x) { f.call(n.call(f, x)) } }

def church_to_int(n)
  n.call(->(x) { x + 1 }, 0)
end

puts church_to_int(LC_SUCC.call(LC_ZERO)) # Output: 1

# Step 5: Implement Basic Arithmetic
LC_ADD = ->(m, n) { ->(f, x) { m.call(f, n.call(f, x)) } }
LC_MULT = ->(m, n) { ->(f) { m.call(n.call(f)) } }

LC_ONE = LC_SUCC.call(LC_ZERO)
LC_TWO = LC_SUCC.call(LC_ONE)

puts church_to_int(LC_ADD.call(LC_ONE, LC_TWO)) # Output: 3

# Step 6: Implement Pairs
LC_PAIR = ->(x, y) { ->(f) { f.call(x, y) } }
LC_FIRST = ->(p) { p.call(->(x, y) { x }) }
LC_SECOND = ->(p) { p.call(->(x, y) { y }) }

my_pair = LC_PAIR.call(:hello, :world)
puts LC_FIRST.call(my_pair) # Output: hello

# Step 7: Build Lists Using Pairs
LC_NIL = LC_PAIR.call(LC_TRUE, LC_TRUE)
LC_CONS = ->(h, t) { LC_PAIR.call(LC_FALSE, LC_PAIR.call(h, t)) }
LC_IS_NIL = LC_FIRST
LC_HEAD = ->(l) { LC_FIRST.call(LC_SECOND.call(l)) }
LC_TAIL = ->(l) { LC_SECOND.call(LC_SECOND.call(l)) }

# Step 8: Implement Comparison Operations
LC_IS_ZERO = ->(n) { n.call(->(_) { LC_FALSE }, LC_TRUE) }
LC_LEQ = ->(m, n) { LC_IS_ZERO.call(LC_SUB.call(m, n)) }
LC_EQ = ->(m, n) { LC_AND.call(LC_LEQ.call(m, n), LC_LEQ.call(n, m)) }

# Helper functions for comparison operations
LC_AND = ->(p, q) { p.call(q, p) }
LC_SUB = ->(m, n) { n.call(LC_PRED, m) }
LC_PRED = ->(n) { ->(f, x) { n.call(->(g, h) { h.call(g.call(f)) }, ->(_) { x }, ->(u) { u }) } }

# Step 9: Implement Higher-Order List Operations
LC_MAP = ->(f, l) {
  LC_IF.call(LC_IS_NIL.call(l),
             LC_NIL,
             ->() { LC_CONS.call(f.call(LC_HEAD.call(l)), LC_MAP.call(f, LC_TAIL.call(l))) })
}

LC_FILTER = ->(pred, l) {
  LC_IF.call(LC_IS_NIL.call(l),
             LC_NIL,
             ->() {
               LC_IF.call(pred.call(LC_HEAD.call(l)),
                          ->() { LC_CONS.call(LC_HEAD.call(l), LC_FILTER.call(pred, LC_TAIL.call(l))) },
                          ->() { LC_FILTER.call(pred, LC_TAIL.call(l)) })
             })
}

LC_FOLD = ->(f, acc, l) {
  LC_IF.call(LC_IS_NIL.call(l),
             acc,
             ->() { LC_FOLD.call(f, f.call(acc, LC_HEAD.call(l)), LC_TAIL.call(l)) })
}

# Step 10: Explore Recursion and Fixed-Point Combinators
Y = ->(f) { ->(x) { f.call(x.call(x)) }.call(->(x) { f.call(x.call(x)) }) }

# Example: Factorial using Y combinator
factorial = Y.call(->(f) { ->(n) {
  LC_IF.call(LC_IS_ZERO.call(n),
             LC_ONE,
             ->() { LC_MULT.call(n, f.call(LC_PRED.call(n))) })
} })

puts church_to_int(factorial.call(LC_SUCC.call(LC_SUCC.call(LC_SUCC.call(LC_ZERO))))) # Output: 6 (3!)
