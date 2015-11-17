;;Lesson 10

;;Exercise 1
;;SICP 3.5.1
#| Explain
When you have delay without force, it does returns the type of a promise. It does not affect anything and 
not run the expression. Force with delay will return a number. 


|#

;;Exercise 2
;;SICP 3.5.1
#| Explain
This produces an error because the stream-cdr forces the cdr to be evaluated. However when they ask for stream-car,
it is expected the car is a type of stream. However '(2 3) is a list not a stream. Therefore you cannot use
stream-car on it.   

|#

;;Exercise 3
#| Explain
The one with delay does not do anything, at all. There is nothing there besides a "promise". Where as 
stream-enumerate-interval will do the very first case, which is the low. So it will have stored at least
one item in its memory. 

|#

;;Exercise 4
;a.
(define (num-seq n)
  (if (even? n)
  (cons-stream n (num-seq (/ n 2)))
  (cons-stream n (num-seq (+ 1 (* n 3)))))
)


;b.
(define (seq-length stream)
  (define (helper s n)
  (if (= 1 (stream-car s))
    n
    (helper (stream-cdr s) (+ n 1))))
  (helper stream 1)
  
)

;;Exercise 5
;;3.50
(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))))

;;3.51
(define x (stream-map show (stream-enumerate-interval 0 10)))
(stream-ref x 5)
#| Returns:
At first, I assumed it was five but it was not.
Stream-ref will make the stream-map keep using the procedure show 
until it reaches the fifth position, because it doesn't know what's
at the fifth position yet. As a result, it will print out:
1 2 3 4 5. 

|#
(stream-ref x 7)
#| Returns:
6 7 because from 1 to 5, everything is already evaluated. 

|#


;;3.52
(define sum 0)
(define (accum x)
  (set! sum (+ x sum))
  sum)
(define seq (stream-map accum (stream-enumerate-interval 1 20)))
(define y (stream-filter even? seq))
(define z (stream-filter (lambda (x) (= (remainder x 5) 0))
                         seq))
(stream-ref y 7)
(display-stream z)

#| What is the value for 'sum'?
210 because (stream-ref y) forced seq to go through 20 times and add all the numbers to sum.

|#

#| What is the printed response to evaluating the stream-ref and display-stream?
stream-ref: 136
display-stream: 10 15 45 55 105 120 190 210 because it goes through seq, and picks out all the 
ones that are multiples of 5. 

|#

#| Will it be diffferent if we implemented (delay <exp>) as (lambda () <exp>)
It should not be because display-stream forces it to be evaluated regardless.

|#
;;3.53
#|Describe the elements of the stream 
The stream only has 1 and the rest are not calculated. 
So it only has 1 as an element, the second element is a promise to 
evaluate that procedure -- but doesn't actually do anything.

|#

;;3.54
(define ones (cons-stream 1 ones))
(define integers (cons-stream 1 (add-streams ones integers)))
(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (mul-streams s1 s2)
  (if (stream-null? s1)
    the-empty-stream
    (stream-map * s1 s2))
  )

(define factorials
  (cons-stream 1 (mul-streams integers factorials))
)

;;3.55
(define (partial-sums stream)
  (cons-stream (stream-car stream) (add-streams (stream-cdr stream) (partial-sums stream)))
)

;;3.56
(define (merge s1 s2)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
         (let ((s1car (stream-car s1))
               (s2car (stream-car s2)))
           (cond ((< s1car s2car)
                  (cons-stream s1car (merge (stream-cdr s1) s2)))
                 ((> s1car s2car)
                  (cons-stream s2car (merge s1 (stream-cdr s2))))
                 (else
                  (cons-stream s1car
                               (merge (stream-cdr s1)
                                      (stream-cdr s2)))))))))

#| Uncomment this after you defined it |#
 (define (helper x)
    (lambda (number) 
      (cond ((> x (sqrt number)) #f)
        ((= 0 (remainder number x)) #t) 
        (else ((helper (+ x 1)) number))))
  )
(define is-not-prime?
  (helper 2)
)
(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))
(define after-8 (integers-starting-from 8))

(define S (cons-stream 1 (merge (scale-stream S 2) 
  (merge (scale-stream S 3) (scale-stream S 5)))))


;;3.64
(define (stream-limit stream tolerance)
  (let ((pos1 (stream-car stream))
  (pos2 (stream-car (stream-cdr stream))))
  (if (< (abs (- pos2 pos1)) tolerance)
    pos2
    (stream-limit (stream-cdr stream) tolerance)
  )

  )
)

;;3.66
#| Explain
For the pair (1,100) -- there should have been at least 99 pairs before that on the same row. Such as
(1,99) or (1,15) or (1, 42) before that with all numbers up to 100, which is the position this question is
asking. However I think that there are (+ 1 2 3 4 5 ... 99) in addition to the 99 pairs I accounted for earlier
because of the pairs going vertically.
For (99,100), they pretty much have all the pairs mentioned above, and the additional 100 pairs
going down veritically.
(100,100) is probably just one more than the above. 

|#

;;3.68
#| Explain
I think it should if my understanding of interleave is correct. Because he is entertwining the first row
with the second row in the correct manner (I think). Where after it finishes its stream line, it goes to the next
stream line and again after that. Though I'm not definitely sure if the positions will be correct. 


|#


;;Exercise 6
(define zeros (cons-stream 0 zeros))
(define (fract-stream lst)
  (define deci (/ (car lst) (cadr lst)))
  (define after-deci-point (bf (bf deci)))

  (define (helper nums)
  (if (empty? nums)
    zeros
    (cons-stream (first nums) (helper (bf nums)))))
  (helper after-deci-point)
    

)

(define (approximation fs num)
  (if (= num 0)
    nil
    (cons (stream-car fs) (approximation (stream-cdr fs) (- num 1)))
  )

)

