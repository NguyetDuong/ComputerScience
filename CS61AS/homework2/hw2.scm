; Exercise 1 - Define substitute

(define (substitute sent old-word new-word)
  ; Your code here
  (if (empty? sent)
      '()
      (if (equal? old-word (first sent))
	  (se new-word (substitute (bf sent) old-word new-word))
	  (se (first sent) (substitute (bf sent) old-word new-word))))
)


; Exercise 2 - Try out the expressions!


(lambda (x) (+ x 3))
;-> returns: #[closure arglist=(x) 7f8a74d9f568]

((lambda (x) (+ x 3)) 7)
;-> returns: 10

(define (make-adder num)
  (lambda (x) (+ x num))) 
((make-adder 3) 7)
;-> returns: 10

(define plus3 (make-adder 3)) 
(plus3 7)
;-> returns: 10

(define (square x) (* x x)) 
(square 5)
;-> returns: 25

(define sq (lambda (x) (* x x))) 
(sq 5)
;-> returns: 25

(define (try f) (f 3 5)) 
(try +)
;-> returns: 8

(try word)
;-> returns: 35



; Exercise 3
#|

How many arguments g has: 1

Type of value returned by g: number

|#

; Exercise 4 - Define f1, f2, f3, f4, and f5

(define (f num)
  (lambda (x) (* x num)))

(define (f1)
  (f 1))
(define (f2)
  (f 2))
(define (f3 a)
  ((f a) a))
(define (f4)
  (lambda () (f 4)))
(define (f5)
  (lambda () (f 5)))

#| Result of Exercise 4
1. f1 returns: #[closure arglist=(x) 7f28c40a5688]
2. (f2) returns: #[closure arglist=(x) .....]
3. (f3 3) returns: 9
4. ((f4)) returns: #[closure arglist=(x) ....]
5. (((f5)) 3) returns: 15
|#


; Exercise 5 - Try out the expressions

(define (t f) 
  (lambda (x) (f (f (f x)))) )

#|
1. ((t 1+) 0) returns: 3

2. ((t (t 1+)) 0) returns: 9

3. (((t t) 1+) 0) returns: 27

|#

; Exercise 6 - Try out the expressions

(define (s x)
  (+ 1 x))

#|

1. ((t s) 0) returns: 3

2. ((t (t s)) 0) returns: 9

3. (((t t) s) 0) returns: 27

|#

; Exercise 7 - Define make-tester

(define (make-tester wd)
  ; Your code here
  (lambda (checkwd) (equal? wd checkwd))

)

; Exercise 8 - SICP exercises

; SICP 1.31a

(define (product term a next b)
  (if (> a b)
      1
      (* (term a) (product term (next a) next b)))
)

(define (factorial a)
  (product (lambda (x) x) 1 (lambda (x) (+ 1 x)) a)
 )

(define (estimate-pi)
  (/ (* 2 (* (product (lambda (x) (* 2 x)) 2 (lambda (x) (+ x 1)) 100)
	  (product (lambda (x) (* 2 x)) 2 (lambda (x) (+ x 1)) 100)))
     (* (product (lambda (x) (+ 1 (* 2 x))) 1 (lambda (x) (+ x 1)) 100)
	(product (lambda (x) (+ 1 (* 2 x))) 1 (lambda (x) (+ x 1)) 100)))


)

; SICP 1.32a

(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a)
		(accumulate combiner null-value term (next a) next b)))
)

#|

Write sum in terms of accumulate:
(accumulate + 0 (lambda (x) (+ 1 x)) 1 (lambda (x) (+ 1 x)) 4)

Write product in terms of accumulate:
(accumulate * 1 (lambda (x) (+ 1 x)) 1 (lambda (x) (+ 1 x)) 4)
|#

; SICP 1.33

(define (filtered-accumulate combiner null-value term a next b pred)
  (if (> a b)
      null-value
      (if (pred a)
	  (combiner (term a)
		 (filtered-accumulate combiner null-value term (next a) next b pred))
	  (filtered-accumulate combiner null-value term (next a) next b pred)))
)

(define (prime? n)
  (define (loop i)
    (cond ((= i n) #t)
          ((= (remainder n i) 0) #f)
          (else (loop (+ i 1)))))
  (if (<= n 1)
      #f
      (loop 2)))

(define (sum-sq-prime a b)
  (filtered-accumulate + 0 (lambda (x) (* x x)) a (lambda (x) (+ x 1)) b prime?)
)

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

(define (rel-prime? x y)
  (= (gcd x y) 1))

(define (prod-of-some-numbers n)
     (define (filtered-accumulate-2 combiner null-value a next b pred)
     (if (>= a b)
	 null-value
	 (if (pred a b)
	     (combiner  a
	     (filtered-accumulate-2 combiner null-value (next a) next b pred))
	     (filtered-accumulate-2 combiner null-value (next a) next b pred)))
     )
  (filtered-accumulate-2 * 1 1 (lambda (x) (+ x 1)) n rel-prime?)
   
)
  


; SICP 1.40 - Define cubic

(define (cubic a b c)
  (lambda (x) (+ (* x x x) (* a x x) (* b x) c))
)

; SICP 1.41 - Define double
(define (inc x) (+ 1 x))
(define (double proc)
  (lambda (x) ( proc ((lambda (x) (proc x))x) ))

)



  
; SICP 1.43 - Define repeated
 (define (compose f1 f2)
    (lambda (x) (f1 (f2 x))))


(define (repeated proc n)
  (if (= n 1)
      (lambda (x) (proc x))
      (compose proc (repeated proc (- n 1))))      
 )

; Exercise 9 - Define every

(define (every proc sent)
 (if (empty? sent)
     '()
     (se (proc (first sent)) (every proc (bf sent))))
 )

; Exercise 10 - Try out the expressions

#|

(every (lambda (letter) (word letter letter)) 'purple)
-> returns: (pp uu rr pp ll ee)

(every (lambda (number) (if (even? number) (word number number) number))
       '(781 5 76 909 24))
-> returns: (781 5 7676 2424)

(keep even? '(781 5 76 909 24))
-> returns: (76 24)

(keep (lambda (letter) (member? letter 'aeiou)) 'bookkeeper)
-> returns: ooeee

(keep (lambda (letter) (member? letter 'aeiou)) 'syzygy)
-> returns: ""

(keep (lambda (letter) (member? letter 'aeiou)) '(purple syzygy))
-> returns: error

(keep (lambda (wd) (member? 'e wd)) '(purple syzygy))
-> returns: purple
|#

