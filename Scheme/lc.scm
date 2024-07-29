;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CORE LAMBDA CALCULUS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Combinators (Fundamental Functions)

(define lc-identity (lambda (x) x))
(define lc-kestrel (lambda (x) (lambda (y) x)))
(define lc-kite (lambda (x) (lambda (y) y)))
(define lc-bluebird (lambda (x) (lambda (y) (lambda (z) (x (y z))))))

;; Fundamental Selector (Building Block)
(define lc-select (lambda (x) (lambda (y) (lambda (selector) ((selector x) y)))))

;; Pairs, First, and Rest (Building upon the Selector)
(define lc-pair (lambda (x) (lambda (y) (lambda (f) (((f x) y)))))
(define lc-first (lambda (p) (p lc-true)))
(define lc-second (lambda (p) (p lc-false)))
(define lc-nil (lambda (x) lc-true))
(define lc-cons lc-pair)
(define lc-is-nil? (lambda (l) (l (lambda (h) (lambda (t) lc-false)))))

;; Booleans and Logic (Building upon Pairs and the Selector)
(define lc-true (lambda (x) (lambda (y) x)))
(define lc-false (lambda (x) (lambda (y) y)))
(define lc-if (lambda (c) (lambda (t) (lambda (e) (((c t) e)))))
(define lc-and (lambda (x) (lambda (y) (((x y) lc-false))))
(define lc-or (lambda (x) (lambda (y) (((x lc-true) y))))
(define lc-not (lambda (x) (((x lc-false) lc-true))))
(define lc-xor (lambda (x) (lambda (y) (((x (lc-not y)) y))))

;; Church Numerals and Arithmetic (Building upon Pairs and Booleans)
(define lc-zero (lambda (f) (lambda (x) x)))
(define lc-inc (lambda (n) (lambda (f) (lambda (x) (f (((n f) x))))))
(define lc-add (lambda (m) (lambda (n) (lambda (f) (lambda (x) (((m f) ((n f) x)))))))
(define lc-sub (lambda (m) (lambda (n) (((n lc-dec) m))))
(define lc-mul (lambda (m) (lambda (n) (lambda (f) (lambda (x) ((m (n f)) x)))))
(define lc-pow (lambda (m) (lambda (n) (n m)))
(define lc-dec 
  (lambda (n)
    (lambda (f) (lambda (x) 
      ((((n (lambda (g) (lambda (h) (h (g f)))))
       (lambda (u) x))
       (lambda (u) u))))))
(define lc-is-zero? (lambda (n) (((n (lambda (x) lc-false)) lc-true)))

;; Comparison Operations
(define lc-equal? 
  (lambda (m) 
    (lambda (n) 
      (((lc-and (lc-is-zero? (lc-sub m n))) 
            (lc-is-zero? (lc-sub n m))))))
(define lc-less-than?
  (lambda (m) (lambda (n) (lc-not (lc-is-zero? (lc-sub n m)))))
(define lc-greater-than?
  (lambda (m) (lambda (n) (lc-less-than? n m)))
(define lc-less-than-or-equal?
  (lambda (m) (lambda (n) (lc-or (lc-less-than? m n) (lc-equal? m n))))
(define lc-greater-than-or-equal?
  (lambda (m) (lambda (n) (lc-or (lc-greater-than? m n) (lc-equal? m n))))

;; Additional Arithmetic Operations
(define lc-div
  (lambda (m) (lambda (n)
    (((lc-if (lc-is-zero? n))
           (error "Division by zero")
           (lc-if (lc-less-than? m n)
                  lc-zero
                  (lc-inc (lc-div (lc-sub m n) n)))))))
(define lc-mod
  (lambda (m) (lambda (n)
    (((lc-if (lc-is-zero? n))
           (error "Modulo by zero")
           (lc-if (lc-less-than? m n)
                  m
                  (lc-mod (lc-sub m n) n))))))
(define lc-abs
  (lambda (n)
    (((lc-if (lc-less-than? n lc-zero))
           (lc-sub lc-zero n)
           n))))

(define lc-max
  (lambda (m) (lambda (n)
    (((lc-if (lc-less-than? m n)) n m))))
(define lc-min
  (lambda (m) (lambda (n)
    (((lc-if (lc-less-than? m n)) m n))))

;; Characters (A-Z)
(define lc-char-A (lambda (x) x))
(define lc-char-B (lambda (x) (x lc-char-A)))
(define lc-char-C (lambda (x) (x lc-char-B)))
(define lc-char-D (lambda (x) (x lc-char-C)))
(define lc-char-E (lambda (x) (x lc-char-D)))
(define lc-char-F (lambda (x) (x lc-char-E)))
(define lc-char-G (lambda (x) (x lc-char-F)))
(define lc-char-H (lambda (x) (x lc-char-G)))
(define lc-char-I (lambda (x) (x lc-char-H)))
(define lc-char-J (lambda (x) (x lc-char-I)))
(define lc-char-K (lambda (x) (x lc-char-J)))
(define lc-char-L (lambda (x) (x lc-char-K)))
(define lc-char-M (lambda (x) (x lc-char-L)))
(define lc-char-N (lambda (x) (x lc-char-M)))
(define lc-char-O (lambda (x) (x lc-char-N)))
(define lc-char-P (lambda (x) (x lc-char-O)))
(define lc-char-Q (lambda (x) (x lc-char-P)))
(define lc-char-R (lambda (x) (x lc-char-Q)))
(define lc-char-S (lambda (x) (x lc-char-R)))
(define lc-char-T (lambda (x) (x lc-char-S)))
(define lc-char-U (lambda (x) (x lc-char-T)))
(define lc-char-V (lambda (x) (x lc-char-U)))
(define lc-char-W (lambda (x) (x lc-char-V)))
(define lc-char-X (lambda (x) (x lc-char-W)))
(define lc-char-Y (lambda (x) (x lc-char-X)))
(define lc-char-Z (lambda (x) (x lc-char-Y)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA STRUCTURES (Building upon Pairs and Other Concepts)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Lists and Vectors

(define lc-list
  (lambda (args)
    (if (null? args)
        lc-nil
        (lc-cons (car args) (apply lc-list (cdr args))))))

(define lc-list-length 
  (lambda (l)
    (((lc-if (lc-is-nil? l))
           lc-zero
           (lc-inc (lc-list-length (lc-second l)))))))

(define lc-list-append 
  (lambda (l1) (lambda (l2)
    (((lc-if (lc-is-nil? l1))
           l2
           (lc-cons (lc-first l1) (lc-list-append (lc-second l1) l2)))))))

(define lc-list-map
  (lambda (f) (lambda (l)
    (((lc-if (lc-is-nil? l))
           lc-nil
           (lc-cons (f (lc-first l))
                    (lc-list-map f (lc-second l))))))))

(define lc-list-filter
  (lambda (pred) (lambda (l)
    (((lc-if (lc-is-nil? l))
           lc-nil
           (lc-if (pred (lc-first l))
                  (lc-cons (lc-first l) (lc-list-filter pred (lc-second l)))
                  (lc-list-filter pred (lc-second l))))))))

(define lc-list-foldl
  (lambda (f) (lambda (acc) (lambda (l)
    (((lc-if (lc-is-nil? l))
           acc
           (lc-list-foldl f (f acc (lc-first l)) (lc-second l))))))))

(define lc-list-foldr
  (lambda (f) (lambda (acc) (lambda (l)
    (((lc-if (lc-is-nil? l))
           acc
           (f (lc-first l) (lc-list-foldr f acc (lc-second l))))))))

(define lc-list-reverse
  (lambda (l)
    (lc-list-foldl (lambda (acc) (lambda (x) (lc-cons x acc))) lc-nil l)))

(define lc-list-at
  (lambda (l) (lambda (n)
    (((lc-if (lc-is-zero? n))
           (lc-first l)
           (lc-list-at (lc-second l) (lc-dec n)))))))

(define lc-list-slice
  (lambda (l) (lambda (start) (lambda (end)
    (lc-list-take (lc-list-drop l start) (lc-sub end start))))))

(define lc-list-take
  (lambda (l) (lambda (n)
    (((lc-if (lc-or (lc-is-nil? l) (lc-is-zero? n)))
           lc-nil
           (lc-cons (lc-first l) (lc-list-take (lc-second l) (lc-dec n))))))))

(define lc-list-drop
  (lambda (l) (lambda (n)
    (((lc-if (lc-or (lc-is-nil? l) (lc-is-zero? n)))
           l
           (lc-list-drop (lc-second l) (lc-dec n)))))))

;; Trees 
(define lc-tree-empty lc-nil)
(define lc-tree-make (lambda (value) (lambda (left) (lambda (right) (lc-list value left right)))))
(define lc-tree-value (lambda (t) (lc-first t)))
(define lc-tree-left  (lambda (t) (lc-second t)))
(define lc-tree-right (lambda (t) (lc-second (lc-second t))))
(define lc-tree-is-empty? lc-is-nil?)

;; Graphs (Adjacency Lists Representation)
(define lc-graph-empty lc-nil)
(define lc-graph-add-vertex (lambda (g) (lambda (vertex) (lc-cons (lc-pair vertex lc-nil) g))))
(define lc-graph-add-edge (lambda (g) (lambda (v1) (lambda (v2)
  (((lc-if (lc-is-nil? g))
         lc-graph-empty
         (lc-cons 
           (lc-if (lc-equal? v1 (lc-first (lc-first g)))
                  (lc-pair (lc-first (lc-first g)) (lc-cons v2 (lc-second (lc-first g))))
                  (lc-first g))
           (lc-graph-add-edge (lc-second g) v1 v2))))))))

;; Dictionaries
(define lc-dict-empty (lambda (k) lc-false))        
(define lc-dict-insert (lambda (d) (lambda (k) (lambda (v) (lambda (k') (lc-if (lc-equal? k k') v (d k')))))))
(define lc-dict-lookup (lambda (d) (lambda (k) (d k))))
(define lc-dict-update (lambda (d) (lambda (k) (lambda (v) (lc-dict-insert d k v)))))
(define lc-dict-remove (lambda (d) (lambda (k) (lambda (k') (lc-if (lc-equal? k k') lc-false (d k')))))

(define lc-equal?  ; Equality check for keys (assuming they're integers)
  (lambda (m) (lambda (n)
    (((lc-and (lc-is-zero? (lc-sub m n))) (lc-is-zero? (lc-sub n m))))))

;; Sets (Using Dictionaries)
(define lc-set-empty lc-dict-empty)
(define lc-set-insert lc-dict-insert)
(define lc-set-member? (lambda (s) (lambda (x) (lc-not (lc-is-nil? (s x)))))
(define lc-set-remove lc-dict-remove)
(define lc-set-union
  (lambda (s1) (lambda (s2)
    (lambda (x) (lc-or (s1 x) (s2 x))))))
(define lc-set-intersection
  (lambda (s1) (lambda (s2)
    (lambda (x) (lc-and (s1 x) (s2 x))))))
(define lc-set-difference
  (lambda (s1) (lambda (s2)
    (lambda (x) (lc-and (s1 x) (lc-not (s2 x)))))))
(define lc-set-equal?
  (lambda (s1) (lambda (s2)
    (((lc-and (lc-set-subset? s1 s2)) (lc-set-subset? s2 s1)))))
(define lc-set-subset?
  (lambda (s1) (lambda (s2)
    (lc-list-foldl (lambda (acc) (lambda (x) (lc-and acc (s2 x)))) lc-true s1))))

;; Optional type (Maybe monad)
(define lc-maybe-some
  (lambda (x)
    (lc-pair lc-true x)))

(define lc-maybe-none
  (lc-pair lc-false lc-nil))

(define lc-maybe-is-some?
  (lambda (m)
    (lc-first m)))

(define lc-maybe-is-none?
  (lambda (m)
    (lc-not (lc-maybe-is-some? m))))

(define lc-maybe-map
  (lambda (f) (lambda (m)
    (((lc-if (lc-maybe-is-some? m))
           (lc-maybe-some (f (lc-second m)))
           lc-maybe-none))))

; Identity and Combinators 
(define lc-i (lambda (x) x))               ; Identity combinator
(define lc-k (lambda (x) (lambda (y) x)))             ; Constant combinator
(define lc-ki (lambda (x) (lambda (y) y)))            ; Kestrel combinator (flipped K)
(define lc-s (lambda (x) (lambda (y) (lambda (z) ((x z) (y z)))))) ; S combinator
(define lc-b (lambda (x) (lambda (y) (lambda (z) (x (y z))))))   ; B combinator
(define lc-c (lambda (x) (lambda (y) (lambda (z) (x z y)))))     ; C combinator
