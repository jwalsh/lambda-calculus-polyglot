(define Y
  (lambda (f)
    ((lambda (x) (f (lambda (y) ((x x) y))))
     (lambda (x) (f (lambda (y) ((x x) y)))))))

(define factorial
  (Y (lambda (f)
       (lambda (n)
         (if (= n 0)
             1
             (* n (f (- n 1))))))))

(display (factorial 5))  ; Output: 120
(newline)

;; (define Y (lambda (f) ((lambda (x) (f (lambda (v) ((x x) v)))) (lambda (x) (f (lambda (v) ((x x) v)))))))
;; (define lc-factorial (Y (lambda (rec n) (if (lc-is-zero? n) lc-one (lc-mult n (rec (lc-succ n)))))))
