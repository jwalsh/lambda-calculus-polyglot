Here's a Scheme file implementing the 10-step guide for Lambda Calculus:

```scheme
;; Step 1: Understand Lambda Expressions

; Simple identity function
(define identity (lambda (x) x))

; Test identity function
(display (identity 5)) ; Should output 5
(newline)

;; Step 2: Implement Church Booleans

(define lc-true (lambda (x y) x))
(define lc-false (lambda (x y) y))
(define lc-if (lambda (condition then else) (condition then else)))

; Test Church booleans
(display (lc-if lc-true 'yes 'no)) ; Should output yes
(newline)

;; Step 3: Implement Basic Combinators

(define I (lambda (x) x))
(define K (lambda (x y) x))
(define KI (lambda (x y) y))

;; Step 4: Create Church Numerals

(define lc-zero (lambda (f x) x))
(define lc-succ (lambda (n) (lambda (f x) (f (n f x)))))

(define (church-to-int n)
  (n (lambda (x) (+ x 1)) 0))

(define (int-to-church n)
  (if (zero? n)
      lc-zero
      (lc-succ (int-to-church (- n 1)))))

; Test Church numerals
(display (church-to-int (lc-succ lc-zero))) ; Should output 1
(newline)

;; Step 5: Implement Basic Arithmetic

(define lc-add (lambda (m n) (lambda (f x) (m f (n f x)))))
(define lc-mult (lambda (m n) (lambda (f) (m (n f)))))

(define lc-one (lc-succ lc-zero))
(define lc-two (lc-succ lc-one))

; Test arithmetic
(display (church-to-int (lc-add lc-one lc-two))) ; Should output 3
(newline)

;; Step 6: Implement Pairs

(define lc-pair (lambda (x y) (lambda (f) (f x y))))
(define lc-first (lambda (p) (p (lambda (x y) x))))
(define lc-second (lambda (p) (p (lambda (x y) y))))

; Test pairs
(define my-pair (lc-pair 'hello 'world))
(display (lc-first my-pair)) ; Should output hello
(newline)

;; Step 7: Build Lists Using Pairs

(define lc-nil (lambda (x) lc-true))
(define lc-cons (lambda (h t) (lc-pair lc-false (lc-pair h t))))
(define lc-is-nil? (lambda (l) (l (lambda (x) lc-true))))
(define lc-head (lambda (l) (lc-first (lc-second l))))
(define lc-tail (lambda (l) (lc-second (lc-second l))))

; Test lists
(define my-list (lc-cons 1 (lc-cons 2 (lc-cons 3 lc-nil))))
(display (lc-head my-list)) ; Should output 1
(newline)

;; Step 8: Implement Comparison Operations

(define lc-is-zero? (lambda (n) (n (lambda (x) lc-false) lc-true)))

(define lc-leq (lambda (m n) 
  (lc-is-zero? (n lc-pred m))))

(define lc-eq (lambda (m n) 
  (lc-and (lc-leq m n) (lc-leq n m))))

(define lc-pred 
  (lambda (n)
    (lambda (f)
      (lambda (x)
        ((n (lambda (g) (lambda (h) (h (g f)))))
         (lambda (u) x)
         (lambda (u) u))))))

;; Step 9: Implement Higher-Order List Operations

(define lc-map
  (lambda (f l)
    ((l (lambda (h t) (lc-cons (f h) (lc-map f t))))
     lc-nil)))

(define lc-filter
  (lambda (pred l)
    ((l (lambda (h t) 
          ((pred h) 
           (lc-cons h (lc-filter pred t))
           (lc-filter pred t))))
     lc-nil)))

(define lc-fold
  (lambda (f acc l)
    ((l (lambda (h t) (lc-fold f (f acc h) t)))
     acc)))

;; Step 10: Explore Recursion and Fixed-Point Combinators

; Y combinator
(define Y
  (lambda (f)
    ((lambda (x) (f (lambda (y) ((x x) y))))
     (lambda (x) (f (lambda (y) ((x x) y)))))))

; Factorial using Y combinator
(define factorial
  (Y (lambda (f)
       (lambda (n)
         (if (zero? n)
             1
             (* n (f (- n 1))))))))

; Test factorial
(display (factorial 5)) ; Should output 120
(newline)
```
