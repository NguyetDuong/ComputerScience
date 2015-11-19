;; ADV.SCM
;; This file contains the definitions for the objects in the adventure
;; game and some utility procedures.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; PERSON A: Hao Ran Raymond Lin
;;; PERSON B: Nguyet Minh Duong


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Question B4 part 1: Implementation of basic-object by Person B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-class (basic-object)
	(instance-vars 
		(traits-table (make-table))
		(traits '()))
	(method (put key number)
		(begin (set! traits (cons key traits)) (insert! key number traits-table)))
	(default-method (if (not (eq? (memq message traits) #f))
							(lookup message traits-table)
							#f))

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-class (place name)
  (parent (basic-object)) ;; Person B: inherit basic-object
  (instance-vars
   (directions-and-neighbors '())
   (things '())
   (people '())
   (entry-procs '())
   (exit-procs '()))
  (initialize
	(ask self 'put 'place? #t)) ;; Person B: Question B4 part 2 -- added place? property
  (method (type) 'place)
  (method (neighbors) (map cdr directions-and-neighbors))
  (method (exits) (map car directions-and-neighbors))
  (method (look-in direction)
    (let ((pair (assoc direction directions-and-neighbors)))
      (if (not pair)
	  '()                     ;; nothing in that direction
	  (cdr pair))))           ;; return the place object
  (method (appear new-thing)
    (if (memq new-thing things)
	(error "Thing already in this place" (list name new-thing)))
    (set! things (cons new-thing things))
    'appeared)
  (method (enter new-person) ;; Person A: A4 Part 2 -- changes to enter
    (if (memq new-person people)
  (error "Person already in this place" (list name new-person)))
    (set! people (cons new-person people))
    (for-each (lambda (proc) (proc)) entry-procs)
  (for-each (lambda (person) (ask person 'notice new-person)) (cdr people))
    'appeared)
  (method (may-enter? person) #t) ;; Person A: A4 part 2 -- may-enter?
  (method (gone thing)
    (if (not (memq thing things))
	(error "Disappearing thing not here" (list name thing)))
    (set! things (delete thing things)) 
    'disappeared)
  (method (exit person)
    (for-each (lambda (proc) (proc)) exit-procs)
    (if (not (memq person people))
	(error "Disappearing person not here" (list name person)))
    (set! people (delete person people)) 
    'disappeared)

  (method (new-neighbor direction neighbor)
    (if (assoc direction directions-and-neighbors)
	(error "Direction already assigned a neighbor" (list name direction)))
    (set! directions-and-neighbors
	  (cons (cons direction neighbor) directions-and-neighbors))
    'connected)

  (method (add-entry-procedure proc)
    (set! entry-procs (cons proc entry-procs)))
  (method (add-exit-procedure proc)
    (set! exit-procs (cons proc exit-procs)))
  (method (remove-entry-procedure proc)
    (set! entry-procs (delete proc entry-procs)))
  (method (remove-exit-procedure proc)
    (set! exit-procs (delete proc exit-procs)))
  (method (clear-all-procs)
    (set! exit-procs '())
    (set! entry-procs '())
    'cleared) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; A4 Part 2: Implementation of locked-place by Person A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-class (locked-place name)
	(parent (place name))
	(instance-vars (locked #t))
	(method (may-enter? person)
		(if (eq? locked #t)
			#f
			#t))
	(method (unlock)
		(set! locked #f)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	

(define-class (person name place)  
  (parent (basic-object)) ;; Person B: inherit basic-object
  (instance-vars
   (possessions '())
   (money 100) ;; Person A: Question A7 part 1 -- added initial amount of money
   (saying ""))
  (initialize
   (ask place 'enter self)
   (ask self 'put 'strength 100) ;; Person B: Question B4 part 1 -- setting an initial value for strength
   (ask self 'put 'person? #t)) ;; Person B: Question B4 part 2-- added person? property 
  (method (type) 'person)
  (method (look-around)
    (map (lambda (obj) (ask obj 'name))
	 (filter (lambda (thing) (not (eq? thing self)))
		 (append (ask place 'things) (ask place 'people)))))
  (method (take thing) ;; Person B: Question B8 -- Revising take
    (cond ((not (ask thing 'thing?)) (error "Not a thing" thing))
	  ((not (memq thing (ask place 'things)))
	   (error "Thing taken not at this place"
		  (list ask place 'name thing)))
	  ((memq thing possessions) (error "You already have it!"))
	  ((not (ask thing 'may-take? self))
		(display "You're not strong enough to take from owner."))
	  (else
	   (announce-take name thing)
	   (set! possessions (cons thing possessions))
	       
	   ;; If somebody already has this object...
	   (for-each
	    (lambda (pers)
	      (if (and (not (eq? pers self)) ; ignore myself
		       (memq thing (ask pers 'possessions)))
		  (begin
		   (ask pers 'lose thing)
		   (have-fit pers))))
	    (ask place 'people))
	       
	   (ask thing 'change-possessor self)
	   'taken)))
	   
	(method (take-all) ;; Person B: Question B3 -- added take-all method
		(define items-within-place (ask (ask self 'place) 'things))
		;;(define free-items '())
		#|(define (free-item-helper items) -- method coded previously, thought we cannot take items from people
			(if (null? (cdr items))
				(if (eq? 'no-one (ask (car items) 'possessor))
					(set! free-items (cons (car items) free-items)))
				(if (eq? 'no-one (ask (car items) 'possessor))
					(begin (set! free-items (cons (car items) free-items)) (free-item-helper (cdr items)))
					(free-item-helper (cdr items)))))
		(free-item-helper items-within-place)|#
		
		(for-each (lambda (x) (ask self 'take x)) items-within-place)
		
		
	  )

  (method (lose thing)
    (set! possessions (delete thing possessions))
    (ask thing 'change-possessor 'no-one)
    'lost)
  (method (talk) (print saying))
  (method (set-talk string) (set! saying string))
  (method (exits) (ask place 'exits))
  (method (notice person) (ask self 'talk))
  (method (go direction) ;; Person A: A4 part 2 -- revision of method go.
    (let ((new-place (ask place 'look-in direction)))
      (cond ((null? new-place)
	     (error "Can't go" direction))
	    (else
			(if (eq? (ask new-place 'may-enter? person) #t)
				(begin
				(ask place 'exit self)
				 (announce-move name place new-place)
				 (for-each
				  (lambda (p)
				(ask place 'gone p)
				(ask new-place 'appear p))
				  possessions)
				 (set! place new-place)
				 (ask new-place 'enter self))
				(error "This place is locked"))))))
	(method (eat) ;; Person B: B6 -- added eat method
		(define can-eat '())
		(define (eat-helper items)
			(if (not (null? items))
				(if (null? (cdr items))
					(if (ask (car items) 'edible?)
						(set! can-eat (cons (car items) can-eat)))
					(if (ask (car items) 'edible?)
						(begin (set! can-eat (cons (car items) can-eat)) (eat-helper (cdr items)))
						(eat-helper (cdr items))))
				(error "No food to eat.")))
		(eat-helper possessions)
		(for-each (lambda (i) (begin (ask self 'put 'strength (+ (ask i 'calories) (ask self 'strength)))
									(ask self 'lose i) (ask (ask self 'place) 'gone i))) can-eat)
		(display "strength: ") (ask self 'strength))
	(method (go-directly-to next-place) ;; Person A: Question A6 part 1 -- added go-directly-to method
				(ask place 'exit self)
				(announce-move name place next-place)
				(for-each
				  (lambda (p)
				(ask place 'gone p)
				(ask next-place 'appear p))
				  possessions)
				 (set! place next-place)
				 (ask next-place 'enter self))
	(method (get-money number) ;; Person A: Question A7 part 1 -- added get-money method
		(set! money (+ money number)))
	(method (pay-money number) ;; Person A: Question A7 part 1 -- added pay-money method
		(if (>= money number)
			(begin
				#t
				(set! money (- money number)))
				#f))
	(method (buy food) ;; Person A: Question A8 -- added buy method
		(if (not (equal? #f (ask place 'sell self food)))
			(set! possessions (cons food possessions))
			(error "The food is not available")))
)

#|(define thing
  (let ()
    (lambda (class-message)
      (cond
       ((eq? class-message 'instantiate)
	(lambda (name)
	  (let ((self '()) (possessor 'no-one))
	    (define (dispatch message)
	      (cond
	       ((eq? message 'initialize)
		(lambda (value-for-self)
		  (set! self value-for-self)))
	       ((eq? message 'send-usual-to-parent)
		(error "Can't use USUAL without a parent." 'thing))
	       ((eq? message 'name) (lambda () name))
	       ((eq? message 'possessor) (lambda () possessor))
	       ((eq? message 'type) (lambda () 'thing))
	       ((eq? message 'change-possessor)
		(lambda (new-possessor)
		  (set! possessor new-possessor)))
	       (else (no-method 'thing))))
	    dispatch)))
       (else (error "Bad message to class" class-message))))))|#
	 
	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; New notation of thing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-class (thing name)
	(instance-vars 
		(possessor 'no-one))
  (parent (basic-object)) ;; Person B: inherit basic-object
  (initialize 
	(ask self 'put 'thing? #t)) ;; Person B: Question B4 part 2 -- added thing? property 
  (method (type) 'thing)
  (method (change-possessor new-possessor) (set! possessor new-possessor))
  (method (may-take? reciever) ;; Person B: Question B8 -- may-take? method
	(if (equal? (ask self 'possessor) 'no-one)
		self
		(if (> (ask reciever 'strength) (ask (ask self 'possessor) 'strength))
			self
			#f)))
)
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Question B5; hotspot class
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-class (hotspot name pass)
	(parent (place name))
	(instance-vars 
		(connected-laptops '()) ;; list of all laptops connected to this hotspot
	)
	(method (connect laptop try-pass)
		(if (and (eq? pass try-pass) (not (eq? #f (memq laptop (ask self 'things)))))
			(begin (set! connected-laptops (cons laptop connected-laptops)) (display "connected "))
			(display "this laptop is either not in the area or wrong password "))
	)
	(method (gone laptop)
		(begin (set! connected-laptops (delete laptop connected-laptops))
			(usual 'gone laptop)))
	(method (surf laptop url)
		(if (not (eq? #f (memq laptop connected-laptops)))
			(system (string-append "lynx " url))
			"you are not connected to internet "))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Question B5; laptop class
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-class (laptop name)
	(parent (thing name))
	(method (connect attempt-password)
		(ask (ask (ask self 'possessor) 'place) 'connect self attempt-password))
	(method (surf url)
		(ask (ask (ask self 'possessor) 'place) 'surf self url))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Question B6; Food Class
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-class (food name calories)
	(parent (thing name))
	(initialize 
		(ask self 'put 'edible? #t)
		(ask self 'put 'calories calories)
	)
)

(define-class (bagel) 
	(class-vars (name 'bagel))
	(parent (food name 10))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Question B7; Police Class
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-class (police name initial-place jail) 
	(parent (person name initial-place))
	(instance-vars
		;;(thief-possessions '())
	)
	(initialize
		(ask self 'put 'strength 300)
	)
	(method (type) 'police)
	(method (notice person) 
		(if (and (> (ask self 'strength) (ask person 'strength)) (equal? (ask person 'type) 'thief))
			(begin (ask self 'set-talk "Crime Does Not Pay.") (ask self 'talk)
				;;(set! thief-possessions (ask person 'possessions))
				(map (lambda (item) (ask self 'take item)) (ask person 'possessions))
				(ask person 'go-directly-to jail))
				(display "Unable to beat the thief because he's too strong."))
				))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Question A5; Garage Class and Ticket Class
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-class (garage name)
	(parent (place name))
	(instance-vars (ticket-table (make-table)))
	(class-vars (serial-number 0))
	(method (park vehicle)
		(if (member vehicle (ask self 'things))
			(let ((this-ticket (instantiate ticket serial-number)))
				(begin
					(insert! serial-number vehicle ticket-table)
					(set! serial-number (+ serial-number 1))
					(ask self 'appear this-ticket)
					(ask (ask vehicle 'possessor) 'take this-ticket)
					(ask (ask vehicle 'possessor) 'lose vehicle)
					(ask self 'gone vehicle)))
			(error "Vehicle is not in garage")))
	(method (unpark ticket)
		(if (equal? (ask ticket 'name) 'ticket)
			(begin
				(ask self 'appear (lookup (ask ticket 'serial-number) ticket-table))
				(ask (ask ticket 'possessor) 'take (lookup (ask ticket 'serial-number) ticket-table))
				(ask (ask ticket 'possessor) 'lose ticket)
				(insert! (ask ticket 'serial-number) #f ticket-table)
				(ask self 'gone ticket))
			(error "Not a ticket!!!"))))

(define-class (ticket serial-number)
	(parent (thing 'ticket)))
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Question A7 part 2; Restaurant Class
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
(define-class (restaurant name food price)
	(parent (place name))
	(method (menu)
		(list (ask food 'name) price))
	(method (sell person ordered-food)
		(if (equal? (ask ordered-food 'name) (car (ask self 'menu)))
			(let ((cooked-food food))	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Person A: Question 9 -- added condition to give police free food
				(if (equal? (ask person 'type) 'police)
					cooked-food
					(begin
						(ask person 'pay-money price)
						cooked-food)))
			#f)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Implementation of thieves for part two
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define *foods* '(pizza potstickers coffee))

#|(define (edible? thing)
  (member? (ask thing 'name) *foods*))|#

(define-class (thief name initial-place)
  (parent (person name initial-place))
  (initialize 
	(ask self 'put 'strength 200)
  )
  (instance-vars
   (behavior 'steal))
  (method (type) 'thief)
  (method (notice person)
	(if (eq? behavior 'run)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Person A: Revised for Question A6 Part 2
		(if (null? (ask (usual 'place) 'exits))
			(error "No exits")
			(ask self 'go (pick-random (ask (usual 'place) 'exits))))
	(let ((food-things
		(filter (lambda (thing)
		(and (ask thing 'edible?)
			(not (eq? (ask thing 'possessor) self))))
				(ask (usual 'place) 'things))))
		  (if (not (null? food-things))
			  (begin
			   (ask self 'take (car food-things))
			   (set! behavior 'run)
			   (ask self 'notice person)) )))))



		   
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utility procedures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; this next procedure is useful for moving around

(define (move-loop who)
  (newline)
  (print (ask who 'exits))
  (display "?  > ")
  (let ((dir (read)))
    (if (equal? dir 'stop)
	(newline)
	(begin (print (ask who 'go dir))
	       (move-loop who)))))


;; One-way paths connect individual places.

(define (can-go from direction to)
  (ask from 'new-neighbor direction to))


(define (announce-take name thing)
  (newline)
  (display name)
  (display " took ")
  (display (ask thing 'name))
  (newline))

(define (announce-move name old-place new-place)
  (newline)
  (newline)
  (display name)
  (display " moved from ")
  (display (ask old-place 'name))
  (display " to ")
  (display (ask new-place 'name))
  (newline))

(define (have-fit p)
  (newline)
  (display "Yaaah! ")
  (display (ask p 'name))
  (display " is upset!")
  (newline))


(define (pick-random set)
  (nth (random (length set)) set))

(define (delete thing stuff)
  (cond ((null? stuff) '())
	((eq? thing (car stuff)) (cdr stuff))
	(else (cons (car stuff) (delete thing (cdr stuff)))) ))

#|(define (person? obj)
  (and (procedure? obj)
       (member? (ask obj 'type) '(person police thief))))

(define (thing? obj)
  (and (procedure? obj)
       (eq? (ask obj 'type) 'thing)))|#
