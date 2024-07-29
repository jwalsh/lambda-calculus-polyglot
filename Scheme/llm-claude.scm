; Lambda Calculus Implementation in Scheme
; Developed by: Claude 3.5 Sonnet (Anthropic, PBC)
; Date: July 29, 2024
; Description: A step-by-step implementation of Lambda Calculus concepts in Scheme

; Step 1: Understand Lambda Expressions
(define identity (lambda (x) x))
; Test: (display (identity 5))

; Step 2: Implement Church Booleans
(define lc-true (lambda (x y) x))
(define lc-false (lambda (x y) y))
(define lc-if (lambda (condition then else) (condition then else)))
; Test: (display (lc-if lc-true 'yes 'no))

; Step 3: Implement Basic Combinators
(define I (lambda (x) x))
(define K (lambda (x y) x))
(define KI (lambda (x y) y))

; Step 4: Create Church Numerals
(define lc-zero (lambda (f x) x))
(define lc-succ (lambda (n) (lambda (f x) (f (n f x)))))
(define (church-to-int n)
  (n (lambda (x) (+ x 1)) 0))
; Test: (display (church-to-int (lc-succ lc-zero)))

; Step 5: Implement Basic Arithmetic
(define lc-add (lambda (m n) (lambda (f x) (m f (n f x)))))
(define lc-mult (lambda (m n) (lambda (f) (m (n f)))))
(define lc-one (lc-succ lc-zero))
(define lc-two (lc-succ lc-one))
; Test: (display (church-to-int (lc-add lc-one lc-two)))

; Step 6: Implement Pairs
(define lc-pair (lambda (x y) (lambda (f) (f x y))))
(define lc-first (lambda (p) (p (lambda (x y) x))))
(define lc-second (lambda (p) (p (lambda (x y) y))))
; Test:
; (define my-pair (lc-pair 'hello 'world))
; (display (lc-first my-pair))

; Step 7: Build Lists Using Pairs
(define lc-nil (lambda (f) lc-true))
(define lc-cons lc-pair)
(define lc-is-nil? lc-first)
(define lc-head lc-second)
(define lc-tail (lambda (l) (l lc-false)))

; Step 8: Implement Comparison Operations
(define lc-is-zero? (lambda (n) (n (lambda (x) lc-false) lc-true)))
(define lc-leq (lambda (m n) (lc-is-zero? (lc-sub n m))))
(define lc-eq (lambda (m n) (lc-and (lc-leq m n) (lc-leq n m))))

; Helper functions for comparison
(define lc-pred 
  (lambda (n)
    (lambda (f)
      (lambda (x)
        ((n (lambda (g) (lambda (h) (h (g f)))))
         (lambda (u) x)
         (lambda (u) u))))))

(define lc-sub
  (lambda (m n)
    ((n lc-pred) m)))

(define lc-and
  (lambda (p q)
    ((p q) p)))

; Step 9: Implement Higher-Order List Operations
(define lc-map
  (lambda (f l)
    ((l (lambda (x acc) (lc-cons (f x) acc))) lc-nil)))

(define lc-filter
  (lambda (pred l)
    ((l (lambda (x acc)
          ((pred x)
           (lc-cons x acc)
           acc)))
     lc-nil)))

(define lc-fold
  (lambda (f acc l)
    ((l (lambda (x g) (f x (g acc)))) (lambda (x) x))))

; Step 10: Explore Recursion and Fixed-Point Combinators
(define Y
  (lambda (f)
    ((lambda (x) (f (lambda (y) ((x x) y))))
     (lambda (x) (f (lambda (y) ((x x) y)))))))

; Example: Factorial using Y combinator
(define factorial
  (Y (lambda (f)
       (lambda (n)
         ((lc-is-zero? n)
          lc-one
          (lc-mult n (f (lc-pred n))))))))

; Test factorial
; (display (church-to-int (factorial (lc-succ (lc-succ (lc-succ lc-zero))))))
; This should output 6 (3!)
