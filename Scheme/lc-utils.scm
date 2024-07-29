;; Conversion Utilities

(define lc-to-str
  (lambda (x)
    (cond [(lc-number? x) (number->string (lc-to-int x))]
          [(lc-boolean? x) (if (lc-to-bool x) "True" "False")]
          [(lc-char? x) (lc-char-to-str x)]
          [(lc-pair? x) (string-append "(" (lc-to-str (lc-first x)) ", " (lc-to-str (lc-second x)) ")")]
          [(lc-nil? x) "[]"]
          [else "UnknownType"])))

(define lc-to-int
  (lambda (n)
    ((n (lambda (x) (+ x 1))) 0)))

(define lc-to-bool
  (lambda (b)
    ((b #t) #f)))

(define lc-from-int
  (lambda (n)
    (if (zero? n)
        lc-zero
        (lc-inc (lc-from-int (- n 1))))))

(define lc-from-bool
  (lambda (b)
    (if b lc-true lc-false)))


;; Character Conversions

(define lc-char-to-int
  (lambda (c)
    (- ((c (lambda (x) (+ x 1))) 0) 1)))

(define lc-int-to-char
  (lambda (n)
    (list-ref (list lc-char-A lc-char-B lc-char-C lc-char-D lc-char-E lc-char-F lc-char-G lc-char-H lc-char-I lc-char-J
                    lc-char-K lc-char-L lc-char-M lc-char-N lc-char-O lc-char-P lc-char-Q lc-char-R lc-char-S lc-char-T
                    lc-char-U lc-char-V lc-char-W lc-char-X lc-char-Y lc-char-Z)
              n)))

(define lc-char-to-str
  (lambda (c)
    (string (integer->char (+ (lc-char-to-int c) 65)))))

;; Type Checking

(define lc-number?
  (lambda (x)
    (and (procedure? x)
         (procedure? (x lc-inc))
         (procedure? ((x lc-inc) lc-zero)))))

(define lc-boolean?
  (lambda (x)
    (or (eq? x lc-true) (eq? x lc-false))))

(define lc-pair?
  (lambda (x)
    (and (procedure? x)
         (procedure? (x lc-true))
         (procedure? (x lc-false)))))

(define lc-nil?
  (lambda (x)
    (eq? x lc-nil)))

(define lc-char?
  (lambda (x)
    (and (procedure? x)
         (procedure? (x lc-char-A)))))