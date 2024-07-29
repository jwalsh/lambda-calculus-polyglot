;; File: lambda-calculus-examples.scm

;; Load the lambda calculus implementation and utilities
(load "lc.scm")
(load "lc-utils.scm")

;; Example 1: Basic arithmetic
(display "Example 1: Basic arithmetic\n")
(define result1 (lc-to-int (lc-add (lc-from-int 3) (lc-from-int 4))))
(display "3 + 4 = ")
(display result1)
(newline)

;; Example 2: Comparison
(display "\nExample 2: Comparison\n")
(define result2 (lc-to-bool (lc-less-than? (lc-from-int 5) (lc-from-int 10))))
(display "5 < 10 is ")
(display (if result2 "true" "false"))
(newline)

;; Example 3: List operations
(display "\nExample 3: List operations\n")
(define my-list (lc-list (lc-from-int 1) (lc-from-int 2) (lc-from-int 3)))
(define squared-list (lc-list-map (lambda (x) (lc-mul x x)) my-list))
(display "Original list: ")
(display (map lc-to-int (lc-to-list my-list)))
(newline)
(display "Squared list: ")
(display (map lc-to-int (lc-to-list squared-list)))
(newline)

;; Example 4: Set operations
(display "\nExample 4: Set operations\n")
(define set1 (lc-set-insert (lc-set-insert lc-set-empty (lc-from-int 1)) (lc-from-int 2)))
(define set2 (lc-set-insert (lc-set-insert lc-set-empty (lc-from-int 2)) (lc-from-int 3)))
(define union-set (lc-set-union set1 set2))
(display "Set 1 contains 1: ")
(display (lc-to-bool (lc-set-member? set1 (lc-from-int 1))))
(newline)
(display "Union set contains 3: ")
(display (lc-to-bool (lc-set-member? union-set (lc-from-int 3))))
(newline)

;; Example 5: Tree operations
(display "\nExample 5: Tree operations\n")
(define my-tree (lc-tree-insert (lc-tree-insert (lc-tree-insert lc-tree-empty (lc-from-int 2)) (lc-from-int 1)) (lc-from-int 3)))
(display "Tree contains 2: ")
(display (lc-to-bool (lc-tree-contains? my-tree (lc-from-int 2))))
(newline)
(display "Inorder traversal: ")
(display (map lc-to-int (lc-to-list (lc-tree-inorder my-tree))))
(newline)