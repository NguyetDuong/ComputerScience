;; Lesson 6

;; Exercise 1

#|
2.74  Note there is no need to write code here - this is a thought exercise.
a. Explain.
All of the divisions are placed into a table and the invidividual's files should be put as data inside 
each division, and the files themselves should act like a table and have the information within the file's table. 

b. Explain.
get-salary should be a general function that just returns the salary of an individual,
that looks through the table of all the individual and matches the individual's name in the specific
division and then return the salary information.

c. Explain.
The procedure will get the employee's name and every division and use the procedure get. If it matches the
input in get, it will return whatever was put inside the employee's name and their division. 

d. Explain.
Add the new employees' names into the system with the appropriate division. Therefore the company need to
create new divisions inside the company's system. 

|#

;; 2.75 Define make-from-mag-ang-mp.

(define (make-from-real-imag-mp x y)
  (define (dispatch op)
    (cond ((eq? op 'real-part) x)
          ((eq? op 'imag-part) y)
          ((eq? op 'magnitude)
           (sqrt (+ (square x) (square y))))
          ((eq? op 'angle) (atan y x))
          (else
           (error "Unknown op -- MAKE-FROM-REAL-IMAG" op))))
  dispatch)

(define (apply-generic-message-passing op arg) (arg op))

(define (real-part-mp z) (apply-generic-message-passing 'real-part z))
(define (imag-part-mp z) (apply-generic-message-passing 'imag-part z))
(define (magnitude-mp z) (apply-generic-message-passing 'magnitude z))
(define (angle-mp z) (apply-generic-message-passing 'angle z))

(define (make-from-mag-ang-mp r a)
  (define (dispatch op)
    (cond ((eq? op 'real-part) (* r (cos a)))
	  ((eq? op 'imag-part) (* r (sin a)))
	  ((eq? op 'angle) a)
	  ((eq? op 'magnitude) r)
	  (else
	   (error "Unknonw op -- MAKE-FROM-MAG-ANG-MP" op))))
  dispatch
   
  
)

#|
2.76 Describe the changes.
Generic Operators will take up a lot of space because for every type, there is an operator for it. So if a 
new type is added, multiple operators are needed to be constructed for it to do all the processes.
Data-directed creates a specific constructor for a procedure (such as area) and will be applicable to all types
as long as we add in the type inside of the constructor and what to do when it is that specific type.
Message passing will have a constructor that can be excuted on many different types, so as more types are
being input, the only revision that needs to be made is inside the constructors. 

Message passing will be the best for a system that adds new types often. And Data-directed will be best for
a system that adds new operators often. 
|#

#|
2.77 Explain.
Apply-generic should be invoked twice. If done only once on the first time, the list of the tags would not
have returned the right thing, which should be retangular/polar. Instead, when it is invoked twice, the
apply-generic will go execute in a deeper layer, and as a result will get the type/tag retangular/polar. 
And thus will give him the answer because that type/tag actually exists in the system. 
|#

;; The packages for dealing with different types of numbers.

(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))

(define (install-scheme-number-package)
  (define (tag x)
    (attach-tag 'scheme-number x))
  (put 'add '(scheme-number scheme-number)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(scheme-number scheme-number)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(scheme-number scheme-number)
       (lambda (x y) (tag (* x y))))
  (put 'div '(scheme-number scheme-number)
       (lambda (x y) (tag (/ x y))))
  (put 'make 'scheme-number
       (lambda (x) (tag x)))
  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y) (= x y)))
  (put '=zero? '(scheme-number)
       (lambda (x) (= 0 x)))
  (put 'exp '(scheme-number scheme-number)
     (lambda (x y) (tag (expt x y))))
  (put 'raise '(scheme-number)
    (lambda (x) (make-complex-from-real-imag x 0)))
  'done)

(install-scheme-number-package)

(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

(define (install-rational-package)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (let ((g (gcd n d)))
      (cons (/ n g) (/ d g))))
  (define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (- (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (* (numer x) (numer y))
              (* (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (* (numer x) (denom y))
              (* (denom x) (numer y))))
  (define (eq-rat x y)
    (= (/ (numer x) (denom x)) (/ (numer y) (denom y))))
   ;; interface to rest of the system
  (define (tag x) (attach-tag 'rational x))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))
  (put 'equ? '(rational rational)
       (lambda (x y) (eq-rat x y)))
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))
  (put '=zero? '(rational)
       (lambda (x) (or (= (denom x) 0) (= (numer x) 0))))
  (put 'raise '(rational)
      (lambda (x) (make-scheme-number (/ (numer x) (denom x)))))
  'done)

(define (make-rational n d)
  ((get 'make 'rational) n d))

(define (install-rectangular-package)
  ;; internal procedures
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (magnitude z)
    (sqrt (+ (square (real-part z))
             (square (imag-part z)))))
  (define (angle z)
    (atan (imag-part z) (real-part z)))
  (define (make-from-mag-ang r a) 
    (cons (* r (cos a)) (* r (sin a))))

  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude '(rectangular) magnitude)
  (put 'angle '(rectangular) angle)
  (put 'make-from-real-imag 'rectangular
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

(define (install-polar-package)
  ;; internal procedures
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z)
    (* (magnitude z) (cos (angle z))))
  (define (imag-part z)
    (* (magnitude z) (sin (angle z))))
  (define (make-from-real-imag x y) 
    (cons (sqrt (+ (square x) (square y)))
          (atan y x)))

  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude '(polar) magnitude)
  (put 'angle '(polar) angle)
  (put 'make-from-real-imag 'polar
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z) (apply-generic 'angle z))

(define (install-complex-package)
  ;; imported procedures from rectangular and polar packages
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))
  ;; internal procedures
  (define (add-complex z1 z2)
    (make-from-real-imag (+ (real-part z1) (real-part z2))
                         (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2))
                         (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (* (magnitude z1) (magnitude z2))
                       (+ (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (/ (magnitude z1) (magnitude z2))
                       (- (angle z1) (angle z2))))

  ;; interface to rest of the system
  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
       (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) (tag (div-complex z1 z2))))
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))
  (put 'equ? '(complex complex)
       (lambda (x y) (and (= (real-part x) (real-part y)) (= (imag-part x) (imag-part y)))))
  (put '=zero? '(complex)
      (lambda (x) (and (= 0 (real-part x)) (= 0 (imag-part x)))))

  'done)

(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))

(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))

(define put-coercion put)
(define get-coercion get)

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (let ((t1->t2 (get-coercion type1 type2))
                      (t2->t1 (get-coercion type2 type1)))
                  (cond (t1->t2
                         (apply-generic op (t1->t2 a1) a2))
                        (t2->t1
                         (apply-generic op a1 (t2->t1 a2)))
                        (else
                         (error "No method for these types"
                                (list op type-tags))))))
              (error "No method for these types"
                     (list op type-tags)))))))

;; 2.79 Define equ? for scheme-number, rational, and complex packages.
;; You will need to use put to install equ? in each of the packages.

(define (equ? a b)
  (apply-generic 'equ? a b))

;; 2.80 Define =zero? for scheme-number, rational, and complex packages.

(define (=zero? num)
  (apply-generic '=zero? num))
#|
2.81
a. Explain.
There will be a infinite loop because apply generic calls itself and never actually apply a procedure upon anything(?).
b. Explain.
Apply generic's logic works correctly. Therefore Louis is wrong.
|#

;; c. Modify apply-generic.
;; You may want to change the name to "apply-generic" for testing.
;; However, on submitting it should be apply-generic-better-coercion.

(define (apply-generic-better-coercion op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (let ((t1->t2 (get-coercion type1 type2))
                      (t2->t1 (get-coercion type2 type1)))
                  (cond (t1->t2
                         (apply-generic op (t1->t2 a1) a2))
                        (t2->t1
                         (apply-generic op a1 (t2->t1 a2)))
                        (else
                         (error "No method for these types"
                                (list op type-tags)))))) 
              (error "No method for these types"
                     (list op type-tags)))))))

;; 2.83 Install a raise procedure for every type except complex
;; Types: Integer -> Rational -> Real (scheme number) -> Complex

(define (make-integer n)
  (attach-tag 'integer n))
(put 'raise '(integer) (lambda (x) (make-rational x 1)))

(define (raise num)
  (apply-generic 'raise num))


(define (scheme-1)
  (display "Scheme-1: ")
  (flush)
  (print (eval-1 (read)))
  (scheme-1))

(define (eval-1 exp)
  (cond ((constant? exp) exp)
  ((symbol? exp) (eval exp))  ; use underlying Scheme's EVAL
  ((quote-exp? exp) (cadr exp))
  ((if-exp? exp)
   (if (eval-1 (cadr exp))
       (eval-1 (caddr exp))
       (eval-1 (cadddr exp))))
  ((lambda-exp? exp) exp)
  ((pair? exp) (apply-1 (eval-1 (car exp))      ; eval the operator
            (map eval-1 (cdr exp))))
  (else (error "bad expr: " exp))))

(define (apply-1 proc args)
  (cond ((procedure? proc)  ; use underlying Scheme's APPLY
   (apply proc args))
  ((lambda-exp? proc)
   (eval-1 (substitute (caddr proc)   ; the body
           (cadr proc)    ; the formal parameters
           args           ; the actual arguments
           '())))     ; bound-vars, see below
  (else (error "bad proc: " proc))))


(define (constant? exp)
  (or (number? exp) (boolean? exp) (string? exp) (procedure? exp)))

(define (exp-checker type)
  (lambda (exp) (and (pair? exp) (eq? (car exp) type))))

(define quote-exp? (exp-checker 'quote))
(define if-exp? (exp-checker 'if))
(define lambda-exp? (exp-checker 'lambda))

(define (substitute exp params args bound)
  (cond ((constant? exp) exp)
  ((symbol? exp)
   (if (memq exp bound)
       exp
       (lookup exp params args)))
  ((quote-exp? exp) exp)
  ((lambda-exp? exp)
   (list 'lambda
         (cadr exp)
         (substitute (caddr exp) params args (append bound (cadr exp)))))
  (else (map (lambda (subexp) (substitute subexp params args bound))
       exp))))

(define (lookup name params args)
  (cond ((null? params) name)
  ((eq? name (car params)) (maybe-quote (car args)))
  (else (lookup name (cdr params) (cdr args)))))

(define (maybe-quote value)
  (cond ((lambda-exp? value) value)
  ((constant? value) value)
  ((procedure? value) value)  ; real Scheme primitive procedure
  (else (list 'quote value))))

;; Exercise 2 - Add map-1 to Scheme-1.
;; Make sure you understand why plain old map does not work (see lab exercise).
 (define (map-1 proc items)
	 (if (empty? (cdr items))
	 (list (apply-1 proc items))
	 (cons (apply-1 proc (cons (car items) '())) (map-1 proc (cdr items))))
)
;; Exercise 3 - Add let to scheme-1.

;; Ordered list representation of sets
(define (element-of-ordered-set? x set)
  (cond ((null? set) false)
        ((= x (car set)) true)
        ((< x (car set)) false)
        (else (element-of-set? x (cdr set)))))

(define (intersection-ordered-set set1 set2)
  (if (or (null? set1) (null? set2))
      '()    
      (let ((x1 (car set1)) (x2 (car set2)))
        (cond ((= x1 x2)
               (cons x1
                     (intersection-set (cdr set1)
                                       (cdr set2))))
              ((< x1 x2)
               (intersection-set (cdr set1) set2))
              ((< x2 x1)
               (intersection-set set1 (cdr set2)))))))

;; Exercise 4 - 2.62 Define union-set for the ordered list representation given above
(define (union-set s1 s2)
  (cond ((empty? s1) s2)
  ((empty? s2) s1)
  ((and (empty? s1) (empty? s2)) '())
  ((= (car s1) (car s2))
  (cons (car s1) (union-set (cdr s1) (cdr s2))))
  ((> (car s1) (car s2))
  (cons (car s2) (union-set s1 (cdr s2))))
  ((< (car s1) (car s2))
  (cons (car s1) (union-set (cdr s1) s2)))
  )
  

)

;; Binary search tree representation of sets

(define (entry tree) (car tree))

(define (left-branch tree) (cadr tree))

(define (right-branch tree) (caddr tree))

(define (make-tree entry left right)
  (list entry left right))

(define (element-of-set? x set)
  (cond ((null? set) #f)
	((= x (entry set)) #t)
	((< x (entry set))
	 (element-of-set? x (left-branch set)))
	((> x (entry set))
	 (element-of-set? x (right-branch set)))))

(define (adjoin-set x set)
  (cond ((null? set) (make-tree x '() '()))
	((= x (entry set)) set)
	((< x (entry set))
	 (make-tree (entry set)
		    (adjoin-set x (left-branch set))
		    (right-branch set)))
	((> x (entry set))
	 (make-tree (entry set)
		    (left-branch set)
		    (adjoin-set x (right-branch set))))))

;; Exercise 5 - Replace the zeros below with appropriate numbers to construct the trees

(define tree1  ; Left tree
  (adjoin-set 11
    (adjoin-set 9
      (adjoin-set 5
        (adjoin-set 1
          (adjoin-set 3
            (adjoin-set 7 '())))))))

(define tree2  ; Middle tree
  (adjoin-set 11
    (adjoin-set 9
      (adjoin-set 5
        (adjoin-set 7
          (adjoin-set 1
            (adjoin-set 3 '())))))))

(define tree3  ; Right tree
  (adjoin-set 11
    (adjoin-set 7
      (adjoin-set 9
        (adjoin-set 1
          (adjoin-set 3
            (adjoin-set 5 '())))))))


(install-scheme-number-package)
(install-rational-package)
(install-rectangular-package)
(install-polar-package)
(install-complex-package)
