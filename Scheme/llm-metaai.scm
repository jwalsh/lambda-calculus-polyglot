; Meta AI Lambda Calculus Implementation in Scheme
; Model: Meta AI, Date: 2024-07-29

; Step 1: Understand Lambda Expressions
(define identity (lambda (x) x))
(display (identity 5)) ; Should output 5

; Step 2: Implement Church Booleans
(define lc-true (lambda (x y) x))
(define lc-false (lambda (x y) y))
(define lc-if (lambda (condition then else) (condition then else)))
(display (lc-if lc-true 'yes 'no)) ; Should output 'yes

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

; Step 5: Implement Basic Arithmetic
(define lc-add (lambda (m n) (lambda (f x) (m f (n f x)))))
(define lc-mult (lambda (m n) (lambda (f) (m (n f)))))
(define lc-one (lc-succ lc-zero))
(define lc-two (lc-succ lc-one))
(display (church-to-int (lc-add lc-one lc-two))) ; Should output 3

; Step 6: Implement Pairs
(define lc-pair (lambda (x y) (lambda (f) (f x y))))
(define lc-first (lambda (p) (p (lambda (x y) x))))
(define lc-second (lambda (p) (p (lambda (x y) y))))
(define my-pair (lc-pair 'hello 'world))
(display (lc-first my-pair)) ; Should output 'hello

; Step 7: Build Lists Using Pairs
(define lc-nil (lambda (f) (f)))
(define lc-cons (lambda (x y) (lambda (f) (f x y))))
(define lc-is-nil? (lambda (l) (l (lambda (x y) #f))))
(define lc-head (lambda (l) (l (lambda (x y) x))))
(define lc-tail (lambda (l) (l (lambda (x y) y))))

; Step 8: Implement Comparison Operations
(define lc-is-zero? (lambda (n) (n (lambda (x) #f) #t)))
(define lc-less-than (lambda (m n) (n (lambda (f) (m (lambda (x) #f) #t)) #f)))
(define lc-equal (lambda (m n) (lc-and (lc-less-than m n) (lc-less-than n m))))

; Step 9: Implement Higher-Order List Operations
(define lc-map (lambda (f l) (l (lambda (x y) (lc-cons (f x) y)))))
(define lc-filter (lambda (p l) (l (lambda (x y) (if (p x) (lc-cons x y) y)))))
(define lc-fold (lambda (f acc l) (l (lambda (x y) (f x y)) acc)))

; Step 10: Explore Recursion and Fixed-Point Combinators
(define Y (lambda (f) ((lambda (x) (f (x x))) (lambda (x) (f (x x))))))
(define lc-factorial (Y (lambda (f) (lambda (n) (if (lc-is-zero? n) lc-one (lc-mult n (f (lc-succ n))))))))
