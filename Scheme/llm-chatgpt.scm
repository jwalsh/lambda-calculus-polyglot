; Lambda Calculus Implementation in Scheme
; Created by ChatGPT, OpenAI's GPT-4 model
; For more information, visit: https://www.openai.com/

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

(display (K 'a 'b)) ; Should output 'a
(display (KI 'a 'b)) ; Should output 'b

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
(display (lc-first my-pear)) ; Should output 'hello

; Step 7: Build Lists Using Pairs
(define lc-nil lc-false)
(define lc-cons (lambda (h t) (lc-pair lc-true (lc-pair h t))))
(define lc-is-nil? lc-first)
(define lc-head (lambda (z) (lc-first (lc-second z))))
(define lc-tail (lambda (z) (lc-second (lc-second z))))

(define my-list (lc-cons 1 (lc-cons 2 lc-nil)))
(display (lc-head my-list)) ; Should output 1
(display (lc-head (lc-tail my-list))) ; Should output 2

; Step 8: Implement Comparison Operations
(define lc-is-zero (lambda (n) ((n (lambda (x) lc-false)) lc-true)))
(define lc-leq (lambda (m n) (lc-is-zero (lc-sub m n))))
(define lc-eq (lambda (m n) (lc-and (lc-leq m n) (lc-leq n m))))

(display (lc-if (lc-eq lc-one lc-one) 'equal 'not-equal)) ; Should output 'equal

; Step 9: Implement Higher-Order List Operations
(define lc-map
  (lambda (f lst)
    (lc-if (lc-is-nil? lst)
           lc-nil
           (lc-cons (f (lc-head lst))
                    (lc-map f (lc-tail lst))))))

(define lc-filter
  (lambda (pred lst)
    (lc-if (lc-is-nil? lst)
           lc-nil
           (lc-if (pred (lc-head lst))
                  (lc-cons (lc-head lst) (lc-filter pred (lc-tail lst)))
                  (lc-filter pred (lc-tail lst))))))

(define lc-fold
  (lambda (op init lst)
    (lc-if (lc-is-nil? lst)
           init
           (lc-fold op (op init (lc-head lst)) (lc-tail lst)))))

(define add (lambda (x y) (+ x y)))
(display (lc-fold add 0 my-list)) ; Should output 3

; Step 10: Explore Recursion and Fixed-Point Combinators
(define Y
  (lambda (f)
    ((lambda (x) (f (lambda (v) ((x x) v))))
     (lambda (x) (f (lambda (v) ((x x) v)))))))

(define factorial
  (Y (lambda (fac)
       (lambda (n)
         (if (zero? n)
             1
             (* n (fac (- n 1))))))))

(display (factorial 5)) ; Should output 120

