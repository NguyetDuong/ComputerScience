; Exercise 1 - Define fast-expt-iter

(define (fast-expt-iter b n)
  (define (even? n)
    (= (remainder n 2) 0)
  )

  (define (fei n e num) 
    (if (= e 1)
      (* n num)
      (if (even? e)
        (fei (* n n) (/ e 2) num)
        (fei n (- e 1) (* num n))
      )
    )
  )
  (if (= n 0)
      1
      (fei b n 1)
   )
)

; Exericse 2 - Define phi

(define (phi)
  (fixed-point (lambda (x) (+ 1 (/ 1 x))) 1)
)

(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

; Exercise 3 - Define cont-frac

;; Recursive version
(define (cont-frac n d k)
  (define (loop n d k count)
    (if (= count 1)
      (/ (n count) (loop n d k (+ count 1)))
      (if (= count k)
        (+ (d (- count 1)) (/ (n count) (d count)))
        (+ (d (- count 1)) (/ (n count) (loop n d k (+ count 1))))
      )
    )
  )
  (if (= k 1)
      (/ (n 1) (d 1))
      (loop n d k 1)
  )
)

;; Iterative version
(define (cont-frac-iter n d k)
    
  (define (cft n d k a) 
    (if (= k 2) 
      (/ (n 1) (+ (d 1) a))
      (cft n d (- k 1) (/ (n (- k 1)) (+ (d (- k 1)) a)))
      
    )
  )
  (if (= k 1)
      (/ (n 1) (d 1))
      (cft n d k (/ (n k) (d k)))
  )
)

(define (e k)
  (+ 2 (cont-frac-iter (lambda (x) 1)
		       (lambda (x) 
			       (if (= (remainder x 3) 2)
					(if (= x 2)
					    2
					    (* 2 (round (/ x 3))))
			       	1))
		       k)))


; Exercise 4 - Define next-perf

(define (next-perf n)
  (define (sum-of-factors counter a)
      (if (= counter a)
        0
        (if (= (remainder a counter) 0)
          (+ counter (sum-of-factors (+ 1 counter) a))
          (sum-of-factors (+ 1 counter) a))))

  (if (= n 0)
      (if (= (sum-of-factors 1 (+ 1 n)) (+ n 1))
	  n
	  (next-perf (+ 1 n)))
      (if (= (sum-of-factors 1 n) n)
	  n
	  (next-perf (+ 1 n)))
   )
)

; Exercise 5 - Explain what happens when the base cases are interchanged.

#|

Your explanation here
Nothing happens to the code, it works normally. It just changes when instances are checked because there isn't a time where I can't see kinds-of-coins = 0 before amount = 0, and as a result would affect the code.

|#

; Exercise 6 - Give a formula relating b, n, counter and product in expt and expt-iter.

#|

Formula for expt: expt of b n is equal to the product of b times itself n times 

Formula for expt-iter: the expt-it of b, counter, and product is the product multiplying b counter-amounts of time.

|#
