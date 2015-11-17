;; Exercise 0 - Introduce yourself
;; The TA should have the url for this

;; Exercise 1 - Define sum-of-squares
(define (square x) (* x x))
(define (sum-of-squares a b) (+ (square a) (square b)))


;; Exercise 2a - Define can-drive?
(define (can-drive a)
  (cond ((< a 16) '(not yet))
	(else '(Good to go))))


;; exercise 2b - Define fizzbuzz
(define (fizzbuzz a)
  (cond ((= 0 (remainder a 15)) 'fizzbuzz)
	((= 0 (remainder a 3)) 'fizz)
	((= 0 (remainder a 5)) 'buzz)
	(else a)))

;; Exercise 3 - Why did the Walrus cross the Serengeti?
#|
Your answer here
Because there were no chickens around.
|#

;; Exercise 4 - new-if vs if

#|
New-if reads, caluclates, and prepares all the input arguments. As a result, if one of the input arguments cannot be calculated or goes into a loop, it generates the error before the if statements can even run. In comparison to if, it only run or calculate when the statement is true. 
|#
