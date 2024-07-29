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