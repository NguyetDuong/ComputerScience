; SICP 3.3, 3.4 - Modify make-password-account to make it generate
; password-protected accounts.
; Also, if an incorrect password is given 7 times consecutively, you
; should say (call-the-cops).
; Note: In the case of a wrong password, you should return the string
; "Incorrect password".  Do not use display or print or error.

(define (make-password-account balance password)
  (define joint-p nil)
  (define (protected request)
    (cond ((eq? request 'withdraw) withdraw)
	  ((eq? request 'deposit) deposit)
	  ((eq? request 'join-password) join-password)
	  (else (error "Unknown request -- MAKE-ACCOUNT " request))))

  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (join-password pass-two)
    (set! joint-p pass-two)
    joint-p)
 
  (define wrong-password 0)
  (define (dispatch p r)
      (if (or (eq? p joint-p) (eq? p password))
	  (begin (set! wrong-password 0) (protected r))
	  (lambda (x) (begin (set! wrong-password (+ 1 wrong-password))
		       (if (> wrong-password 7)
			   (call-the-cops)
			   "Incorrect password")))))
    
    
  
  dispatch)


; SICP 3.7 - Define make-joint.
; You may want to modify make-password-account, but you shouldn't
; remove any of its previous functionality.
(define (make-joint acc original-p new-p)
 ;; ((acc original-p 'join-password) new-p)
 ;; acc
  (define (dispatch input-password request)
    (if (eq? input-password new-p)
	(acc original-p request)
        (lambda (x) "Incorrect password")))
  dispatch
  )


; SICP 3.8 - Define reset-f!
; This is a function that defines the function f that the exercise
; asks for.

(define f #f)
(define order 0)
;; 0 means left to right, 1 means right to left

(define (reset-f!)
  (set! f
	(if (= order 0)
	    (begin (set! order 1) (lambda (x) 0))
	    (begin (set! order 0) (lambda (x) 0.5)))))

; For example, if you think that f should be the square function, you
; would say:
; (define (reset-f!)
;   (set! f (lambda (x) (* x x))))

; SICP 3.10 - Answer in the comment block.
#|
You have two options:
1) Draw the environment diagram here using ASCII art
2) Submit a .jpg or .pdf file containing your environment diagram (for
example, you could scan a paper drawing), in which case you should
write the filename here.

Environment diagram here

Q. How do the environment structures differ for the two versions?
A. In the environment diagram, there is two args for the first version rather than the second one. The second one, its balance is actually within its body and will only print when called on.

Q. Show that the two versions of make-withdraw create objects with the
same behavior.
A. In the end, balance is still input the same way. The object created can hold an amount called balance. And therefore works when we create one -- seeing that it is necessary for both version that we input a number for balance. 

|#

; SICP 3.11 - Answer in the comment block.
#|
Same options as in 3.10

Environment diagram here

Q. Where is the local state for acc kept?
A. In the global environment

Q. How are the local states for the two accounts kept distinct?
A. They have their own frame outside directed to it.

Q. Which parts of the environment structure are shared?
A. Make-account only. 

|#
