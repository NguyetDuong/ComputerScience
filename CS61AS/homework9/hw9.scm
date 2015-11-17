#|
Exercise 1. Why did the student get an error?
Because when we are using "set!", we are trying to change an actual number. A number. You can't change a number. There is nothing attached to the number -- no variables. In this attempt, the student is trying to *literally* change the number into something else, which doesn't work. Where as using "set-cdr!", we are changing the value at that position, not the value itself. And therefore it does not generate an error.


|#

; Exercise 2
; Exercise 2a. Fill in the ?? so that the calls produce the desired effect.

(define list1 (list (list 'a) 'b))
(define list2 (list (list 'x) 'y))
(set-cdr! (car list2) (cdr list1))
(set-cdr! (car list1) (car list2))
list1 ; Should output ((a x b) b)
list2 ; Should output ((x b) y)

;Exercise 2b.  Draw a box-and-pointer diagram that explains the effect 
;              of evaluating
;(set-car! (cdr list1) (cadr list2)).
;(Reminder:  You can use ASCII art or submit a jpg or pdf file.)


;Exercise 3. 
;SICP 3.13
;Draw the box-pointer diagram of z
(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define z (make-cycle (list 'a 'b 'c)))

;What happens if we try to compute (last-pair z)?
;; it doesn't work and the program breaks because z is an infinite loop due to the fact it keeps on pointing to the last pair -- however the last pair is always changing so it keeps on doing that. 

;SICP 3.14
(define (mystery x)
  (define (loop x y)
    (if (null? x)
        y
        (let ((temp (cdr x)))
          (set-cdr! x y)
          (loop temp x))))
  (loop x '()))
  
;What does mystery do in general?
;;It reverses the order of the list sent in. 


(define v (list 'a 'b 'c 'd))
(define w (mystery v))

;Draw the box-pointer diagram of v before the call to mystery, 
;v after the call to mystery, and w


;What would be printed as the values of v and w?
;; v is just (a b c d)
;; w will be (d c b a)



;Exercise 4.
;SICP 3.16 Draw the 4 box-and-pointer diagrams.
(define (count-pairs x)
  (if (not (pair? x))
      0
      (+ (count-pairs (car x))
         (count-pairs (cdr x))
         1)))
		 
 #|
a. Returns 3: (count-pairs '(1 2 3))

b. Returns 4: (define c (list 4)) (count-pairs (cons (cons 3 c) c))

c. Returns 7: (define l (cons 3 4)) (define m (cons l l)) (count-pairs (cons m m)

d. Never returns:  (define l (cons 3 m)) (define m (cons l l)) (count-pairs (cons m m))

|#

;SICP 3.17 Write a correct version of count-pairs.
(define (count-pairs x)
  (define items ())
  (define counter 0)
  (define (helper l)
    (cond ((or (empty? l) (not (pair? l))) 0)
	  ((and (pair? l) (not (memq l items)))
	  (begin (set! counter (+ counter 1))
		 (set! items (cons l items))
		 (helper (car l))
		 (helper (cdr l))
		 ))))
  (helper x)
  counter
  )


;SICP 3.21 Explain what Eva Lu Ator is talking about, and what happened with
;Ben's examples.  Then define print-queue.
(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item) (set-car! queue item))
(define (set-rear-ptr! queue item) (set-cdr! queue item))

(define (empty-queue? queue) (null? (front-ptr queue)))
(define (make-queue) (cons '() '()))

(define (front-queue queue)
  (if (empty-queue? queue)
      (error "FRONT called with an empty queue" queue)
      (car (front-ptr queue))))
	  
(define (insert-queue! queue item)
  (let ((new-pair (cons item '())))
    (cond ((empty-queue? queue)
           (set-front-ptr! queue new-pair)
           (set-rear-ptr! queue new-pair)
           queue)
          (else
           (set-cdr! (rear-ptr queue) new-pair)
           (set-rear-ptr! queue new-pair)
           queue)))) 

(define (delete-queue! queue)
  (cond ((empty-queue? queue)
         (error "DELETE! called with an empty queue" queue))
        (else
         (set-front-ptr! queue (cdr (front-ptr queue)))
         queue))) 
#| What happened with Ben's examples?
What happens is that there is a list within a list. The inner is is the actual queue for Ben, and the outerlist is just used to keep track of the last input. 


|#
; Implement the definition of print-queue
;Make sure you use display to print the queue.
(define (print-queue queue)
	(display (car queue)))


;SICP 3.25 Write lookup and insert!

(define (lookup keys table)
  (define position (assoc keys (cdr table)))
  (if position
      (cdr position)
      false)
	    
)

(define (insert! keys value table)
  (define position (assoc keys (cdr table)))
  (if position
      (set-cdr! position value)
      (set-cdr! table (cons (cons keys value) (cdr table))))
	
)

(define (make-table)
  (list '*table*))

#|
SICP 3.27

Explain why the number of steps is proportional to n (you may want to
include a trace to explain).
Because they go through every number only once and doesn't go backwards or forward a bit so therefore the program works in the number of steps proportional to n.

Would it still work (efficiently) if we define memo-fib as (memoize
fib)?  Why or why not?
No. Because it will work similiarly to fib(?).
|#

;Exercise 5. Write vector-append.
(define (vector-append v1 v2)
        (define newvec
	  (make-vector (+ (vector-length v1) (vector-length v2))))
	(define (loop v i k)
	  (if (>= i 0)
	      (begin (vector-set! newvec k (vector-ref v i))
		     (loop v (- i 1) (- k 1)))))
	(loop v1 (- (vector-length v1) 1) (- (vector-length v1) 1))
	(loop v2 (- (vector-length v2) 1) (- (+ (vector-length v1)
					     (vector-length v2)) 1))
	newvec
	      
)

;Exercise 6. Write vector-filter.
(define (vector-filter pred vec)
  (define (loop i items-amount)
    (if (< i 0)
	items-amount
	(if (pred (vector-ref vec i))
	    (loop (- i 1) (+ items-amount 1))
	    (loop (- i 1) items-amount))))
  (define newvec (make-vector (loop (- (vector-length vec) 1) 0)))
  (define (loop-hole i position)
    (if (< i 0)
	newvec
	(if (pred (vector-ref vec i))
	    (begin (vector-set! newvec position (vector-ref vec i))
		   (loop-hole (- i 1) (- position 1)))
	    (loop-hole (- i 1) position))))
  (loop-hole (- (vector-length vec) 1) (- (vector-length newvec) 1))
  
	
	  
	
)

;Exercise 7. Write bubble-sort!
(define (bubble-sort! vec)
	(define holder 0)
        (define (loop i)
	  (cond ((<= (vector-length vec) 1) vec)
	   ((> (vector-ref vec i) (vector-ref vec (- i 1)))
		 (begin (set! holder (vector-ref vec (- i 1)))
			(vector-set! vec (- i 1) (vector-ref vec i))
			(vector-set! vec i holder)
			(loop (- i 1))))
		(else (loop (- i 1)))))

      
	     
	      (loop (- (vector-length vec) 1))
		     
        
		
)

; The order of growth of the running time of bubble sort is Theta(??)
;;The run time is probbaly logerithmic. 
