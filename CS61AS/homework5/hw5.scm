;Exercise 1
;What are the result of the expressions? Make sure to comment your answer out
;; (append x y) returns: (1 2 3 4 5 6)
;; (cons x y) returns: ((1 2 3) 4 5 6)
;; (list x y) returns: ((1 2 3) (4 5 6))

; Exercise 2 Mobile
(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

; a. Define left-branch, right-branch, branch-length, and
; branch-structure.
(define (left-branch branch)
  (car branch))
(define (right-branch branch)
  (cdr branch))
(define (branch-length branch) ;; take in a branch and returns len of the branch
  (left-branch branch))
(define (branch-structure branch)
  (right-branch branch)) ;; takes in a branch and returns the structure of the branch

; b. Define total-weight.
(define (branch? s)
  (pair? s))

(define (total-weight mobile)
  (cond ((and (branch? (left-branch mobile)) (branch? (right-branch mobile)))
    (+ (total-weight (left-branch mobile)) (total-weight (right-branch mobile))))
    ((branch? (right-branch mobile))
    (total-weight (right-branch mobile)))
    (else (right-branch mobile)))
    
  
)
; c. Define balanced?
(define (balanced? mobile)
  (if (and (not (branch? (right-branch (left-branch mobile)))) 
    (not (branch? (right-branch (right-branch mobile))))
    (eq? (* (left-branch (right-branch mobile)) (total-weight (right-branch mobile)))
    (* (left-branch (left-branch mobile)) (total-weight (left-branch mobile)))))
    #t
    (if (and (not (branch? (right-branch (right-branch mobile)))) 
    (branch? (right-branch (left-branch mobile))))
    (balanced? (right-branch (left-branch mobile)))
    #f
    )
  )

)
; d. Redefine all the necessary procedures to work with the new
; constructors given below.

(define (make-mobile left right)
  (cons left right))
(define (make-branch length structure)
  (cons length structure))


;Exercise 3a - Define square-tree
(define (square-tree nums)
  (cond ((empty? nums)
    '())
    ((list? (left-branch nums))
    (cons (square-tree (left-branch nums)) (square-tree (right-branch nums))))
    (else (cons (square (left-branch nums)) (square-tree (right-branch nums))))

  )

)

(define (square x) (* x x)) 

;Exercise 3b - Define tree-map
(define (tree-map proc items)
  (cond ((empty? items)
    '())
    ((list? (left-branch items))
    (cons (tree-map proc (left-branch items)) (tree-map proc (right-branch items))))
  (else (cons (proc (left-branch items)) (tree-map proc (right-branch items)))))
)


;Exercise 4 -  Complete the definition of accumulate-n
(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (getFirsts seqs)) ;; get the first item of each list
      (accumulate-n op init (removeFirsts seqs)))) ;; new list that is everything but the first
) 
(define (getFirsts seqs)
  (if (null? seqs)
    nil
    (cons (left-branch (left-branch seqs)) (getFirsts (right-branch seqs)))))
(define (removeFirsts seqs)
  (if (null? seqs)
    nil
    (cons (right-branch (left-branch seqs)) (removeFirsts (right-branch seqs)))
  )
)

;Exercise 5 - Complete the definitions of matrix-*-vector, transpose,
; and matrix-*-matrix.

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
  (map (lambda (y) (dot-product v y)) m))

(define (transpose mat)
  (accumulate-n cons nil mat))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (y) (matrix-*-vector cols y)) m)))


;Exercise 6 - Give the property that op should satisfy:
#|
Multiplicate, and addition. 
|#

;Exercise 7 - Define equal?
(define (equal? j k)
  (cond ((null? j)
    #t)
  ((and (list? j) (not (list? k)))
  #f)
  ((and (not (list? j)) (list? k))
  #f)
  ((and (not (list? j)) (not (list? k)))
  (eq? j k))
  ((and (list? j) (list? k) (= (length k) (length j)))
  (and (equal? (car j) (car k)) (equal? (cdr j) (cdr k))))
  (else #f)


)
)


;Exercise 8 - Complete the definition of subsets
(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map 
      (lambda (y) (cons (car s) y)) rest)))))


;Exercuse 9 - Modify the calc program

;; Scheme calculator -- evaluate simple expressions

; The read-eval-print loop:

(define (calc)
  (display "calc: ")
  (flush)
  (print (calc-eval (read)))
  (calc))

; Evaluate an expression:

(define (calc-eval exp)
  (cond ((number? exp) exp)
  ((and (list? exp)) (calc-apply (car exp) (map calc-eval (cdr exp))))
  ((word? exp) exp)
  (else (error "Calc: bad expression:" exp))))

; Apply a function to arguments:

(define (calc-apply fn args)
  (cond ((eq? fn '+) (accumulate + 0 args))
  ((eq? fn '-) (cond ((null? args) (error "Calc: no args to -"))
         ((= (length args) 1) (- (car args)))
         (else (- (car args) (accumulate + 0 (cdr args))))))
  ((eq? fn '*) (accumulate * 1 args))
  ((eq? fn '/) (cond ((null? args) (error "Calc: no args to /"))
         ((= (length args) 1) (/ (car args)))
         (else (/ (car args) (accumulate * 1 (cdr args))))))
  ((eq? fn 'first) (first args))
  ((or (eq? fn 'butfirst) (eq? fn 'bf)) (bf (car args)))
  (else (error "Calc: bad operator:" fn))))
