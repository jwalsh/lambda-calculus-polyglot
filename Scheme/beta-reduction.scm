(define (beta-reduce func arg)
  (func arg))

; Example
(define add-one (lambda (x) (+ x 1)))
(display (beta-reduce add-one 5))  ; Output: 6
(newline)
