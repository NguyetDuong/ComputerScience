(load "~cs61as/lib/obj.scm")

; 1 - Modify the person class.

(define-class (person name)
  (method (say stuff)
    (set! word stuff)
    stuff)
  (instance-vars (word '())) 
  (method (ask stuff) (ask self 'say (se '(would you please) stuff)))
  (method (repeat) word)
  (method (greet) (ask self 'say (se '(hello my name is) name))))


; 2 - Determine which definition works as intended.
; In particular, make sure the repeat method works.

(define-class (double-talker name)
  (parent (person name))
  (method (say stuff) (se (usual 'say stuff) (ask self 'repeat))) )

(define-class (double-talker name)
  (parent (person name))
  (method (say stuff) (se stuff stuff)) )

(define-class (double-talker name)
  (parent (person name))
  (method (say stuff) (usual 'say (se stuff stuff))) )

#|
Definition number ?? works as intended.
Your explanation here.
All three work as intended even though I thought they did not previous to testing out the code. For #1, we just overwrote the original parent method, and then asks for the parent method stuff and then repeat -- which is the same. #3 is similar but instead we input into the parent say method stuff twice. For #2, the reason it works because we are overwriting the method say in the parent file to return the words twice.  
|#


; 3 - Write the random-generator class.
(define-class (random-generator number)
  (instance-vars (num-random 0))
  (method (number)
    (set! num-random (+ 1 num-random))
    (random number))
  (method (count)
    num-random))


; 4 - Write the coke-machine class.
; For compatibility with the autograder, make sure that you display
; error messages.  That means you should say:
; (display "Not enough money") and
; (display "Machine empty") when appropriate.

(define-class (coke-machine hold cost)
  (instance-vars (total-dep 0)
		 (a 0)) 
  (method (deposit n)
    (set! total-dep (+ total-dep n))
    total-dep)
  (method (fill k)
	(set! a (+ a k)))
  (method (coke)
    (cond ((= a 0) (display "Machine empty"))
	  ((< total-dep cost) (display "Not enough money"))
	  (else (let ((re (- total-dep cost)))
		  (set! a (- a 1))
		  (set! total-dep 0)
		  re))))
    
  )
 
	       


; 5 - Write the deck class.

(define ordered-deck
  (accumulate append '()
	      (map (lambda (suit)
		     (map (lambda (value) (word value suit))
			  '(A 2 3 4 5 6 7 8 9 10 J Q K)))
		   '(s d c h))))

(define (shuffle deck)
  (if (null? deck)
      '()
      (let ((card (nth (random (length deck)) deck)))
	(cons card (shuffle (remove card deck))) )))

(define-class (deck)
  (instance-vars (shuffled-d (shuffle ordered-deck)))
  (method (empty?)
    (empty? shuffled-d))
  (method (deal)
    (if (empty? shuffled-d)
	'()
	(let ((x (car shuffled-d)))
	  (set! shuffled-d (cdr shuffled-d))
	  x)))
 )


; 6 - Write the miss-manners class.
(define-class (miss-manners name)
  (parent (person name))
  (method (say phrase)
    (error))
  (method (please a b)
    (usual a b)))
    
