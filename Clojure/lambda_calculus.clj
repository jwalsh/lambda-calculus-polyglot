;; Lambda Calculus Implementation in Clojure
;; Created by Claude 3.5 Sonnet (Anthropic, PBC 2024)
;; Recommended filename: lambda_calculus.clj
;; Usage: Load this file into a Clojure REPL and evaluate the expressions

;; Step 1: Understand Lambda Expressions
(def identity-fn (fn [x] x))
(comment
  (identity-fn 5) ; => 5
)

;; Step 2: Implement Church Booleans
(def lc-true (fn [x y] x))
(def lc-false (fn [x y] y))
(def lc-if (fn [condition then else] (condition then else)))

(comment
  (lc-if lc-true :yes :no) ; => :yes
)

;; Step 3: Implement Basic Combinators
(def I identity-fn)
(def K (fn [x] (fn [y] x)))
(def KI (fn [x] (fn [y] y)))

;; Step 4: Create Church Numerals
(def lc-zero (fn [f x] x))
(def lc-succ (fn [n] (fn [f x] (f (n f x)))))

(defn church-to-int [n]
  ((n (fn [x] (inc x))) 0))

(comment
  (church-to-int (lc-succ lc-zero)) ; => 1
)

;; Step 5: Implement Basic Arithmetic
(def lc-add (fn [m n] (fn [f x] (m f (n f x)))))
(def lc-mult (fn [m n] (fn [f] (m (n f)))))

(def lc-one (lc-succ lc-zero))
(def lc-two (lc-succ lc-one))

(comment
  (church-to-int (lc-add lc-one lc-two)) ; => 3
)

;; Step 6: Implement Pairs
(def lc-pair (fn [x y] (fn [f] (f x y))))
(def lc-first (fn [p] (p (fn [x y] x))))
(def lc-second (fn [p] (p (fn [x y] y))))

(comment
  (def my-pair (lc-pair :hello :world))
  (lc-first my-pair) ; => :hello
)

;; Step 7: Build Lists Using Pairs
(def lc-nil (lc-pair lc-true lc-true))
(def lc-cons (fn [h t] (lc-pair lc-false (lc-pair h t))))
(def lc-is-nil? lc-first)
(def lc-head (fn [l] (lc-first (lc-second l))))
(def lc-tail (fn [l] (lc-second (lc-second l))))

;; Step 8: Implement Comparison Operations
(def lc-is-zero? (fn [n] (n (fn [_] lc-false) lc-true)))

(def lc-leq
  (fn [m n]
    ((n lc-succ) (fn [_] lc-false) m)))

(def lc-eq
  (fn [m n]
    (lc-and (lc-leq m n) (lc-leq n m))))

(def lc-and
  (fn [p q]
    (lc-if p q lc-false)))

;; Step 9: Implement Higher-Order List Operations
(def lc-map
  (fn [f l]
    ((lc-is-nil? l)
     lc-nil
     (lc-cons (f (lc-head l))
              ((lc-map f) (lc-tail l))))))

(def lc-filter
  (fn [pred l]
    ((lc-is-nil? l)
     lc-nil
     (lc-if (pred (lc-head l))
            (lc-cons (lc-head l) ((lc-filter pred) (lc-tail l)))
            ((lc-filter pred) (lc-tail l))))))

(def lc-fold
  (fn [f acc l]
    ((lc-is-nil? l)
     acc
     (f (lc-head l)
        ((lc-fold f) acc (lc-tail l))))))

;; Step 10: Explore Recursion and Fixed-Point Combinators
(def Y
  (fn [f]
    ((fn [x] (x x))
     (fn [x]
       (f (fn [y] ((x x) y)))))))

(def factorial
  (Y (fn [f]
       (fn [n]
         ((lc-is-zero? n)
          lc-one
          (lc-mult n (f (lc-succ n))))))))

(comment
  (church-to-int (factorial lc-two)) ; => 2
)
