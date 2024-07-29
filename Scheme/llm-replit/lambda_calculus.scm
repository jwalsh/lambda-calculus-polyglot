; =============================================================================
; Filename: lambda_calculus.scm
; Description: A 10-Step Guide to Lambda Calculus in Scheme
; Created by: Claude (Anthropic, PBC), 2024
; Model Information: 
; Usage Instructions: 
;   Load this file into a Scheme REPL and evaluate the expressions.
; =============================================================================

; Step 1: Understand Lambda Expressions
; Define simple lambda expressions and apply them
(define identity (lambda (x) x))
(display (identity 5)) ; Should output 5
(newline)

; Step 2: Implement Church Booleans
; Church encodings for boolean values and an if function
(define lc-true (lambda (x y) x))
(define lc-false (lambda (x y) y))
(define lc-if (lambda (condition then else) (condition then else)))

; Test Church booleans
(display (lc-if lc-true 'yes 'no)) ; Should output 'yes
(newline)

; Step 3: Implement Basic Combinators
; Identity (I), Kestrel (K), Kite (KI)
(define I identity)
(define K (lambda (x) (lambda (y) x)))
(define KI (lambda (x) (lambda (y) y)))

; Step 4: Create Church Numerals
; Church numerals and helper functions
(define lc-zero (lambda (f x) x))
(define lc-succ (lambda (n) (lambda (f x) (f (n f x)))))

(define (church-to-int n)
  (n (lambda (x) (+ x 1)) 0))

; Test Church numerals
(display (church-to-int (lc-succ lc-zero))) ; Should output 1
(newline)

; Step 5: Implement Basic Arithmetic
; Addition and multiplication using Church numerals
(define lc-add (lambda (m n) (lambda (f x) (m f (n f x)))))
(define lc-mult (lambda (m n) (lambda (f) (m (n f)))))

(define lc-one (lc-succ lc-zero))
(define lc-two (lc-succ lc-one))

; Test Church arithmetic
(display (church-to-int (lc-add lc-one lc-two))) ; Should output 3
(newline)

; Step 6: Implement Pairs
; Pairs constructor and accessors
(define lc-pair (lambda (x y) (lambda (f) (f x y))))
(define lc-first (lambda (p) (p (lambda (x y) x))))
(define lc-second (lambda (p) (p (lambda (x y) y))))

; Test pairs
(define my-pair (lc-pair 'hello 'world))
(display (lc-first my-pair)) ; Should output 'hello
(newline)

; Step 7: Build Lists Using Pairs
; Lists using pairs
(define lc-nil (lambda (x) x))
(define lc-cons (lambda (h t) (lc-pair h t)))
(define lc-is-nil? (lambda (l) (if (eq? l lc-nil) #t #f)))
(define lc-head (lambda (l) (lc-first l)))
(define lc-tail (lambda (l) (lc-second l)))

; Step 8: Implement Comparison Operations
; Comparison operations for Church numerals
(define lc-is-zero? (lambda (n) (n (lambda (_) lc-false) lc-true)))

(define lc-leq
  (lambda (m n)
    ((n lc-succ) (lambda (_) lc-false) m)))

(define lc-eq
  (lambda (m n)
    (and (lc-leq m n) (lc-leq n m))))

(define lc-and
  (lambda (p q)
    (lc-if p q lc-false)))

; Step 9: Implement Higher-Order List Operations
; Higher-order functions for lists
(define lc-map
  (lambda (f l)
    (if (lc-is-nil? l)
        lc-nil
        (lc-cons (f (lc-head l)) (lc-map f (lc-tail l))))))

(define lc-filter
  (lambda (pred l)
    (if (lc-is-nil? l)
        lc-nil
        (if (pred (lc-head l))
            (lc-cons (lc-head l) (lc-filter pred (lc-tail l)))
            (lc-filter pred (lc-tail l))))))

(define lc-fold
  (lambda (f acc l)
    (if (lc-is-nil? l)
        acc
        (lc-fold f (f acc (lc-head l)) (lc-tail l)))))

; Step 10: Explore Recursion and Fixed-Point Combinators
; Y combinator and recursive functions
(define Y
  (lambda (f)
    ((lambda (x) (x x))
     (lambda (x)
       (f (lambda (y) ((x x) y)))))))

(define factorial
  (Y (lambda (f)
       (lambda (n)
         (if (zero? n)
             1
             (* n (f (- n 1))))))))

; Test Y combinator (factorial)
(display (factorial 5)) ; Should output 120
(newline); =============================================================================
; Filename: lambda_calculus.scm
; Description: A 10-Step Guide to Lambda Calculus in Scheme
; Created by: Claude (Anthropic, PBC), 2024
; Model Information: 
; Usage Instructions: 
;   Load this file into a Scheme REPL and evaluate the expressions.
; =============================================================================

; Step 1: Understand Lambda Expressions
; Define simple lambda expressions and apply them
(define identity (lambda (x) x))
(display (identity 5)) ; Should output 5
(newline)

; Step 2: Implement Church Booleans
; Church encodings for boolean values and an if function
(define lc-true (lambda (x y) x))
(define lc-false (lambda (x y) y))
(define lc-if (lambda (condition then else) (condition then else)))

; Test Church booleans
(display (lc-if lc-true 'yes 'no)) ; Should output 'yes
(newline)

; Step 3: Implement Basic Combinators
; Identity (I), Kestrel (K), Kite (KI)
(define I identity)
(define K (lambda (x) (lambda (y) x)))
(define KI (lambda (x) (lambda (y) y)))

; Step 4: Create Church Numerals
; Church numerals and helper functions
(define lc-zero (lambda (f x) x))
(define lc-succ (lambda (n) (lambda (f x) (f (n f x)))))

(define (church-to-int n)
  (n (lambda (x) (+ x 1)) 0))

; Test Church numerals
(display (church-to-int (lc-succ lc-zero))) ; Should output 1
(newline)

; Step 5: Implement Basic Arithmetic
; Addition and multiplication using Church numerals
(define lc-add (lambda (m n) (lambda (f x) (m f (n f x)))))
(define lc-mult (lambda (m n) (lambda (f) (m (n f)))))

(define lc-one (lc-succ lc-zero))
(define lc-two (lc-succ lc-one))

; Test Church arithmetic
(display (church-to-int (lc-add lc-one lc-two))) ; Should output 3
(newline)

; Step 6: Implement Pairs
; Pairs constructor and accessors
(define lc-pair (lambda (x y) (lambda (f) (f x y))))
(define lc-first (lambda (p) (p (lambda (x y) x))))
(define lc-second (lambda (p) (p (lambda (x y) y))))

; Test pairs
(define my-pair (lc-pair 'hello 'world))
(display (lc-first my-pair)) ; Should output 'hello
(newline)

; Step 7: Build Lists Using Pairs
; Lists using pairs
(define lc-nil (lambda (x) x))
(define lc-cons (lambda (h t) (lc-pair h t)))
(define lc-is-nil? (lambda (l) (if (eq? l lc-nil) #t #f)))
(define lc-head (lambda (l) (lc-first l)))
(define lc-tail (lambda (l) (lc-second l)))

; Step 8: Implement Comparison Operations
; Comparison operations for Church numerals
(define lc-is-zero? (lambda (n) (n (lambda (_) lc-false) lc-true)))

(define lc-leq
  (lambda (m n)
    ((n lc-succ) (lambda (_) lc-false) m)))

(define lc-eq
  (lambda (m n)
    (and (lc-leq m n) (lc-leq n m))))

(define lc-and
  (lambda (p q)
    (lc-if p q lc-false)))

; Step 9: Implement Higher-Order List Operations
; Higher-order functions for lists
(define lc-map
  (lambda (f l)
    (if (lc-is-nil? l)
        lc-nil
        (lc-cons (f (lc-head l)) (lc-map f (lc-tail l))))))

(define lc-filter
  (lambda (pred l)
    (if (lc-is-nil? l)
        lc-nil
        (if (pred (lc-head l))
            (lc-cons (lc-head l) (lc-filter pred (lc-tail l)))
            (lc-filter pred (lc-tail l))))))

(define lc-fold
  (lambda (f acc l)
    (if (lc-is-nil? l)
        acc
        (lc-fold f (f acc (lc-head l)) (lc-tail l)))))

; Step 10: Explore Recursion and Fixed-Point Combinators
; Y combinator and recursive functions
(define Y
  (lambda (f)
    ((lambda (x) (x x))
     (lambda (x)
       (f (lambda (y) ((x x) y)))))))

(define factorial
  (Y (lambda (f)
       (lambda (n)
         (if (zero? n)
             1
             (* n (f (- n 1))))))))

; Test Y combinator (factorial)
(display (factorial 5)) ; Should output 120
(newline)