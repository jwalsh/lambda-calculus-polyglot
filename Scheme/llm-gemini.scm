;; Step 1: Understand Lambda Expressions
(define identity (lambda (x) x))

;; Step 2: Implement Church Booleans
(define lc-true (lambda (x y) x))
(define lc-false (lambda (x y) y))
(define lc-if (lambda (condition then else) (condition then else)))

;; Step 3: Implement Basic Combinators
(define lc-I identity)
(define lc-K (lambda (x y) x))
(define lc-KI (lambda (x y) y))

;; Step 4: Create Church Numerals
(define lc-zero (lambda (f x) x))
(define lc-succ (lambda (n) (lambda (f x) (f (n f x)))))
(define (church-to-int n) (n (lambda (x) (+ x 1)) 0))

;; Step 5: Implement Basic Arithmetic
(define lc-add (lambda (m n) (lambda (f x) (m f (n f x)))))
(define lc-mult (lambda (m n) (lambda (f) (m (n f)))))
(define lc-one (lc-succ lc-zero))
(define lc-two (lc-succ lc-one))

;; Step 6: Implement Pairs
(define lc-pair (lambda (x y) (lambda (f) (f x y))))
(define lc-first (lambda (p) (p (lambda (x y) x))))
(define lc-second (lambda (p) (p (lambda (x y) y))))

;; Step 7: Build Lists Using Pairs
(define lc-nil (lambda (x) lc-true))
(define lc-cons (lambda (h t) (lambda (x) (x h t))))
(define lc-is-nil? (lambda (l) (l (lambda (h t) lc-false))))
(define lc-head (lambda (l) (l (lambda (h t) h))))
(define lc-tail (lambda (l) (l (lambda (h t) t))))

;; Step 8: Implement Comparison Operations
(define lc-is-zero? (lambda (n) (n (lambda (x) lc-false) lc-true)))
(define lc-less-than (lambda (m n) (lc-is-zero? (lc-pred m n))))
(define lc-equal? (lambda (m n)
  (lc-and (lc-less-than-equal? m n) (lc-less-than-equal? n m))))

;; Step 9: Implement Higher-Order List Operations
(define lc-map (lambda (f l)
  (lc-if (lc-is-nil? l)
         lc-nil
         (lc-cons (f (lc-head l)) (lc-map f (lc-tail l))))))

(define lc-filter (lambda (pred l)
  (lc-if (lc-is-nil? l)
         lc-nil
         (lc-if (pred (lc-head l))
                (lc-cons (lc-head l) (lc-filter pred (lc-tail l)))
                (lc-filter pred (lc-tail l))))))

(define lc-fold (lambda (f acc l)
  (lc-if (lc-is-nil? l)
         acc
         (lc-fold f (f acc (lc-head l)) (lc-tail l)))))

;; Step 10: Explore Recursion and Fixed-Point Combinators
(define Y
  (lambda (f)
    ((lambda (x) (f (lambda (y) ((x x) y))))
     (lambda (x) (f (lambda (y) ((x x) y)))))))
