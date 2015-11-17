;; hw12
;; I really have no idea what I'm doing...
;; modifications will be put in 4.3 eval, and any additional code will be at the very bottom 
;; and all commented
(define apply-in-underlying-scheme apply)

;;;SECTION 4.1.1

(define (mc-eval exp env)
  (cond ((self-evaluating? exp) exp)
  ((variable? exp) (lookup-variable-value exp env))
  ((quoted? exp) (text-of-quotation exp))
  ((assignment? exp) (eval-assignment exp env))
  ((definition? exp) (eval-definition exp env))
  ((if? exp) (eval-if exp env))
  ((lambda? exp)
   (make-procedure (lambda-parameters exp)
       (lambda-body exp)
       env))
  ((begin? exp) 
   (eval-sequence (begin-actions exp) env))
  ((cond? exp) (mc-eval (cond->if exp) env))
  ((application? exp)
   (mc-apply (mc-eval (operator exp) env)
       (list-of-values (operands exp) env)))
  (else
   (error "Unknown expression type -- EVAL" exp))))

(define (mc-apply procedure arguments)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
         (eval-sequence
           (procedure-body procedure)
           (extend-environment
             (procedure-parameters procedure)
             arguments
             (procedure-environment procedure))))
        (else
         (error
          "Unknown procedure type -- APPLY" procedure))))


(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (mc-eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))

(define (eval-if exp env)
  (if (true? (mc-eval (if-predicate exp) env))
      (mc-eval (if-consequent exp) env)
      (mc-eval (if-alternative exp) env)))

(define (eval-sequence exps env)
  (cond ((last-exp? exps) (mc-eval (first-exp exps) env))
        (else (mc-eval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))

(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
                       (mc-eval (assignment-value exp) env)
                       env)
  'ok)

(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
                    (mc-eval (definition-value exp) env)
                    env)
  'ok)

;;;SECTION 4.1.2

(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
  ((boolean? exp) true)
  (else false)))

(define (quoted? exp)
  (tagged-list? exp 'quote))

(define (text-of-quotation exp) (cadr exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (variable? exp) (symbol? exp))

(define (assignment? exp)
  (tagged-list? exp 'set!))

(define (assignment-variable exp) (cadr exp))

(define (assignment-value exp) (caddr exp))


(define (definition? exp)
  (tagged-list? exp 'define))

(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))

(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp)
                   (cddr exp))))

(define (lambda? exp) (tagged-list? exp 'lambda))

(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))


(define (if? exp) (tagged-list? exp 'if))

(define (if-predicate exp) (cadr exp))

(define (if-consequent exp) (caddr exp))

(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))


(define (begin? exp) (tagged-list? exp 'begin))

(define (begin-actions exp) (cdr exp))

(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

(define (make-begin seq) (cons 'begin seq))


(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))


(define (cond? exp) (tagged-list? exp 'cond))

(define (cond-clauses exp) (cdr exp))

(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))

(define (cond-predicate clause) (car clause))

(define (cond-actions clause) (cdr clause))

(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))

(define (expand-clauses clauses)
  (if (null? clauses)
      'false                          ; no else clause
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (if (cond-else-clause? first)
            (if (null? rest)
                (sequence->exp (cond-actions first))
                (error "ELSE clause isn't last -- COND->IF"
                       clauses))
            (make-if (cond-predicate first)
                     (sequence->exp (cond-actions first))
                     (expand-clauses rest))))))

;;;SECTION 4.1.3

(define (true? x)
  (not (eq? x false)))

(define (false? x)
  (eq? x false))


(define (make-procedure parameters body env)
  (list 'procedure parameters body env))

(define (compound-procedure? p)
  (tagged-list? p 'procedure))


(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))


(define (enclosing-environment env) (cdr env))

(define (first-frame env) (car env))

(define the-empty-environment '())

(define (make-frame variables values)
  (cons variables values))

(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))

(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "Too many arguments supplied" vars vals)
          (error "Too few arguments supplied" vars vals))))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (car vals))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- SET!" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
             (add-binding-to-frame! var val frame))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame)
          (frame-values frame))))

;;;SECTION 4.1.4

(define (setup-environment)
  (let ((initial-env
         (extend-environment (primitive-procedure-names)
                             (primitive-procedure-objects)
                             the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    (define-variable! 'import
                      (list 'primitive
          (lambda (name)
            (define-variable! name
                        (list 'primitive (eval name))
                        the-global-environment)))
                      initial-env)
    initial-env))

;[do later] (define the-global-environment (setup-environment))

(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))

(define (primitive-implementation proc) (cadr proc))

(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
  (list '+ +)
  (list '- -)
  (list '* *)
  (list '/ /)
  (list '= =)
  (list 'list list)
  (list 'append append)
  (list 'equal? equal?)
  (list 'integer? integer?)
  (list 'number? number?)
  (list 'list? list?)
  (list 'pair? pair?)
  (list 'not not)
  (list 'list-ref list-ref)
;;      more primitives
        ))

(define (primitive-procedure-names)
  (map car
       primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
   (primitive-implementation proc) args))



(define input-prompt ";;; M-Eval input:")
(define output-prompt ";;; M-Eval value:")

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (mc-eval input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))

(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))

(define (announce-output string)
  (newline) (display string) (newline))

(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedure
                     (procedure-parameters object)
                     (procedure-body object)
                     '<procedure-env>))
      (display object)))

;;;Following are commented out so as not to be evaluated when
;;; the file is loaded.
;;(define the-global-environment (setup-environment))
;;(driver-loop)

;; Added at Berkeley:
(define the-global-environment '())

(define (mce)
  (set! the-global-environment (setup-environment))
  (driver-loop))

; SICP 4.3
; Rewrite eval in data-directed style.
(define (dispatch-eval exp env)
  (put 'type 'quote text-of-quotation)
  (put 'type 'define eval-definition)
  (put 'type 'set! eval-assignment)
  (put 'type 'if eval-if)
  (put 'type 'begin)
  (put 'type 'let->combination let-combination)
  (define (type-tag x) (car x))

  (cond ((self-evaluating? exp) exp)
        ((variable? exp) lookup-variable-value exp env)
        ((get 'type (type-tag exp)) ((get 'type (type-tag exp)) exp))
        ((application? exp) 
          (mc-apply (mc-eval (operator exp) env)
          (list-of-values (operands exp) env)))
        ((lambda? exp)
          (make-procedure (lambda-parameters exp)
          (lambda-body exp)
          env))
        ((cond? ex)
         (mc-eval (cond->if exp) env))
        ;; SICP 4.22, adding a let? statement
        ((let? exp)
          (let->combination exp))
        ((application? exp)
          (mc-apply (mc-eval (operator exp) env)
            (list-of-values (operands exp) env)))
        (else (error "Unknown expression type -- EVAL " exp)))
)

; SICP 4.6
; Write let->combination and install let in the original evaluator.
; You can also implement it for dispatch-eval.
; how lambda looks like: ((lambda (x y z) (do this this this)) 1 2 3)
; how let looks like: (let ((x 1) (y 2) (z 3)) (do this this this))

;; This will give us all the numbers being input
(define (vars-and-num whole) 
  (car (cdr whole)))

(define (get-variables aftercut) 
  (if (null? aftercut)
    '()
    (cons (caar aftercut) (get-variables (cdr aftercut)))))
(define (get-numbers aftercut) 
  (if (null? aftercut)
    '()
    (cons (cdar aftercut) (get-numbers (cdr aftercut)))))
(define (get-body whole)
  (caddr whole))


(define (let->combination exp)
  (cons (make-lambda (get-variables (vars-and-num exp)) (get-body exp))
        (get-numbers (vars-and-num exp))))

;;;;;;;;;;;;;;;;;;;;;;;;; HW 12 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; SICP 4.22
;; creating a method let? to see if the input is a let statement

(define (let? a) 
  (eq? 'let (caadr a))
)

;; SICP 4.23
;; Alyssa's differs from analyze.scm is by the fact she uses execute-sequence as part
;; of a recursive method. When doing this, it will only be called once it gets there, as
;; part of Scheme's applicative order. However the analyze.scm version forces all of them to run 
;; through the sequentially code, where it tries to run both procedures at once on the same
;; environment. 

;; SICP 4.27
(define w (id (id 10)))
;;; L-Eval input:
;; count
;;; L-Eval value:
;; 1, because lazy evaluator is sort of like streams, it will only try to calculate the outside
;; only and will only calculate the inside when it is needed.
;;; L-Eval input:
;; w
;;; L-Eval value:
;; 10, because what ID does is just take whatever we input and return it (with some motifications
;; to other things but doesn't effect the input). So even if it's called twice, it will return the same thing.
;;; L-Eval input:
;; count
;;; L-Eval value:
;; 2, because after us calling w, the evaluator actually had to go through two sets of
;; ID, which will increment count twice. And as a result, count is actually 2 now unlike
;; the first time it was called

;; SICP 4.29
(define (square x)
  (* x x))
;;; L-Eval input:
(square (id 10))
;;; L-Eval value:
;; 100, simply because it does what it square normally does. Identify what (id 10) is, which is 10,
;; and then multiplies it by itself -- so the answer is 100.
;;; L-Eval input:
count
;;; L-Eval value:
;; memoize: 1, because it remembers what "x" (aka (id 10)) is
;; without memoize will be: 2 because it does not remember what "x" is, and will have to do method id twice,
;; which will cause the count value to increment twice

;; SICP 4.25
(define (factorial n)
  (unless (= n 1)
          (* n (factorial (- n 1)))
          1))

;; When we call (factorial 5), with unless, scheme will still look over everything and will keep on trying
;; to run (factorial (- n 1)). Where as in normal order it will not bother to look at factorial, it will
;; just have accepted there is a factorial there and move on.

;; SICP 4.26
;; To be honest, I'm not sure. But we'll have to create an unless? method, which allows us to see
;; if what the user input has the word unless. And then figure out what they were putting in.
;; From there, we can make an if statement instead which will cause the program to be in 
;; applicative order. However I don't know under what condition will make it better to be a procedure...
;; is it for when something is required to be read first in order to figure out when to be ran?

;; SICP 4.28
;; Certain problems will have two functions that will not follow through. And as a result, you will need
;; to force at least one to pass through in order for it to work.

;; SICP 4.30
;; a. Because for this specific instance, we used the method display, which is a primative procedure,
;; which will cause it to be ran regardless of whether or not it forces the code not to run.
;; b. With the lazy ones, it will only be 1 and 2 simply because it gets stuck and does not run.
;; However with the other proposed changes, it will both print out 1 and 2 for both.
;; c. This is true because of primative procedures which will follow its own rules
;; regardless of any forcings
;; d. For sequences in lazy evaluator, I think Cy's way is fine because he can just hold
;; onto what he needs to and read the rest when it is required. Which is good because it decreases
;; the amount of memory required to read through everything because things are not forced

;; SICP 4.32
;; It's because car and cdr can be lazy and not be interpreted unless asked now. As a result, we can
;; create a huge list, and we can look in either the car or cdr without actually going through car
;; because before it's only cdr that is "lazy" and car is autoran.

;; SICP 4.33
;; You would revise quote, and then create a list when something is input with quote. And then we make a
;; method that creates lists themselves. From this, it will not force it to be run, and as a result,
;; it is a only ran when we use car or cdr and as a result, it is an actual lazy method. 


