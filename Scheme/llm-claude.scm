; Step 1: Understand Lambda Expressions
(define identity (lambda (x) x))
(display (identity 5)) ; Should output 5
(newline)

; Step 2: Implement Church Booleans
(define lc-true (lambda (x y) x))
(define lc-false (lambda (x y) y))
(define lc-if (lambda (condition then else) (condition then else)))
(display (lc-if lc-true 'yes 'no)) ; Should output 'yes
(newline)

; Step 3: Implement Basic Combinators
(define I (lambda (x) x))
(define K (lambda (x y) x))
(define KI (lambda (x y) y))

; Step 4: Create Church Numerals
(define lc-zero (lambda (f x) x))
(define lc-succ (lambda (n) (lambda (f x) (f (n f x)))))
(define (church-to-int n)
  (n (lambda (x) (+ x 1)) 0))
(display (church-to-int (lc-succ lc-zero))) ; Should output 1
(newline)

; Step 5: Implement Basic Arithmetic
(define lc-add (lambda (m n) (lambda (f x) (m f (n f x)))))
(define lc-mult (lambda (m n) (lambda (f) (m (n f)))))
(define lc-one (lc-succ lc-zero))
(define lc-two (lc-succ lc-one))
(display (church-to-int (lc-add lc-one lc-two))) ; Should output 3
(newline)

; Step 6: Implement Pairs
(define lc-pair (lambda (x y) (lambda (f) (f x y))))
(define lc-first (lambda (p) (p (lambda (x y) x))))
(define lc-second (lambda (p) (p (lambda (x y) y))))
(define my-pair (lc-pair 'hello 'world))
(display (lc-first my-pair)) ; Should output 'hello
(newline)

; We'll continue with the remaining steps in subsequent iterations...
