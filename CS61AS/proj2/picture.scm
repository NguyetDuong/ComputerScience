;; Code for CS61A project 2 -- picture language

(define (flipped-pairs painter)
  (let ((painter2 (beside painter (flip-vert painter))))
    (below painter2 painter2)))

(define (right-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (right-split painter (- n 1))))
	(beside painter (below smaller smaller)))))

(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
	    (right (right-split painter (- n 1))))
	(let ((top-left (beside up up))
	      (bottom-right (below right right))
	      (corner (corner-split painter (- n 1))))
	  (beside (below painter top-left)
		  (below bottom-right corner))))))

(define (square-limit painter n)
  (let ((quarter (corner-split painter n)))
    (let ((half (beside (flip-horiz quarter) quarter)))
      (below (flip-vert half) half))))

(define (square-of-four tl tr bl br)
  (lambda (painter)
    (let ((top (beside (tl painter) (tr painter)))
	  (bottom (beside (bl painter) (br painter))))
      (below bottom top))))

(define (identity x) x)

(define (flipped-pairs painter)
  (let ((combine4 (square-of-four identity flip-vert
				  identity flip-vert)))
    (combine4 painter)))

;; or

; (define flipped-pairs
;   (square-of-four identity flip-vert identity flip-vert))

(define (square-limit painter n)
  (let ((combine4 (square-of-four rotate90cw rotate90
				  rotate90 rotate90cw)))
    (combine4 (corner-split painter n))))

(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
     (origin-frame frame)
     (add-vect (scale-vect (xcor-vect v)
			   (edge1-frame frame))
	       (scale-vect (ycor-vect v)
			   (edge2-frame frame))))))

(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
     (lambda (segment)
       (draw-line
	((frame-coord-map frame) (start-segment segment))
	((frame-coord-map frame) (end-segment segment))))
     segment-list)))

(define (draw-line v1 v2)
  (penup)
  (setxy (- (* (xcor-vect v1) 200) 100)
	 (- (* (ycor-vect v1) 200) 100))
  (pendown)
  (setxy (- (* (xcor-vect v2) 200) 100)
	 (- (* (ycor-vect v2) 200) 100)))

(define (transform-painter painter origin corner1 corner2)
  (lambda (frame)
    (let ((m (frame-coord-map frame)))
      (let ((new-origin (m origin)))
	(painter
	 (make-frame new-origin
		     (sub-vect (m corner1) new-origin)
		     (sub-vect (m corner2) new-origin)))))))

(define (flip-vert painter)
  (transform-painter painter
		     (make-vect 0.0 1.0)
		     (make-vect 1.0 1.0)
		     (make-vect 0.0 0.0)))

(define (shrink-to-upper-right painter)
  (transform-painter painter
		    (make-vect 0.5 0.5)
		    (make-vect 1.0 0.5)
		    (make-vect 0.5 1.0)))

(define (rotate90 painter)
  (transform-painter painter
		     (make-vect 1.0 0.0)
		     (make-vect 1.0 1.0)
		     (make-vect 0.0 0.0)))

(define (squash-inwards painter)
  (transform-painter painter
		     (make-vect 0.0 0.0)
		     (make-vect 0.65 0.35)
		     (make-vect 0.35 0.65)))

(define (beside painter1 painter2)
  (let ((split-point (make-vect 0.5 0.0)))
    (let ((paint-left
	   (transform-painter painter1
			      (make-vect 0.0 0.0)
			      split-point
			      (make-vect 0.0 1.0)))
	  (paint-right
	   (transform-painter painter2
			      split-point
			      (make-vect 1.0 0.0)
			      (make-vect 0.5 1.0))))
      (lambda (frame)
	(paint-left frame)
	(paint-right frame)))))

;;
;; Your code goes here
;;

;; [][]
;; [  ]
;; up-split
(define (up-split painter n) ;; looks like above
	(if (= n 0)
	painter
	(let ((smaller (up-split painter (- n 1))))
		(below painter (beside smaller smaller)))))

;; lambda statments...
;; first come, first serve type
;; split
(define (split proc1 proc2)
	(lambda (painter n)
		(if (= n 0) painter
		(let ((smaller ((split proc1 proc2) painter (- n 1)))
		(proc1 painter (proc2 smaller smaller)))))
	)
)

;;make-vect	-- selectors for the xcor-vect ycor-vect
(define (make-vect x y) (cons x y)) ;;WHY CAN'T I MAKE-VECT
(define (xcor-vect vec) (car vec))
(define (ycor-vect vec) (cdr vec))

;;procedures: add-vect, sub-vect, scale-vect
(define (add-vect v1 v2)
	(make-vect (+ (xcor-vect v1) (xcor-vect v2)) (+ (ycor-vect v1) (ycor-vect v2)))
)
(define (sub-vect v1 v2)
	(make-vect (- (xcor-vect v1) (xcor-vect v2)) (- (ycor-vect v1) (ycor-vect v2)))
)
(define (scale-vect s vect)
	(make-vect (* s (xcor-vect vect)) (* s (ycor-vect vect)))
)

;; if it's the second instance, it will return (x) which won't work when call xcor-vect
;; get stuff from frame
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (origin-frame f)
	(make-vect (xcor-vect (car f)) (ycor-vect (car f)))
) 
(define (edge1-frame f)
	(make-vect (xcor-vect (cadr f)) (ycor-vect (cadr f)))
)
;;this works for both instances
(define (edge2-frame f)
	(if (list? (cddr f)) (make-vect (xcor-vect (caddr f)) (ycor-vect (caddr f)))
		(make-vect (xcor-vect (cddr f)) (ycor-vect (cddr f))))
)

;;segments: have starting vector and ending vector
(define (make-segment start-vect end-vect)
	(cons start-vect end-vect)
)
(define (start-segment seg)
	(make-vect (xcor-vect (car seg)) (ycor-vect (car seg)))
)
(define (end-segment seg)
	(make-vect (xcor-vect (cdr seg)) (ycor-vect (cdr seg)))
)

;; painters
(define frame 
	(segments->painter 
		(list (make-segment (make-vect 0 0) (make-vect 0 1))
			(make-segment (make-vect 0 0) (make-vect 1 0))
			(make-segment (make-vect 1 0) (make-vect 1 1))
			(make-segment (make-vect 0 1) (make-vect 1 1))	
		)	
	)
)
(define x 
	(segments->painter
		(list (make-segment (make-vect 0 1) (make-vect 1 0))
			(make-segment (make-vect 0 0) (make-vect 1 1))
		)
	)
)
(define diamond 
	(segments->painter
		(list (make-segment (make-vect 0.5 0.0001) (make-vect 1 0.5))
			(make-segment (make-vect 0.5 0.0001) (make-vect 0.0001 0.5))
			(make-segment (make-vect 0.0001 0.5) (make-vect 0.5 1))
			(make-segment (make-vect 1 0.5) (make-vect 0.5 1))
		)
	)
)

;;incomplete atm
(define wave
	(segments->painter
		(list 
			;;head
			(make-segment (make-vect 0.406 1) (make-vect 0.375 0.833))
			(make-segment (make-vect 0.594 1) (make-vect 0.641 0.833))
			(make-segment (make-vect 0.406 0.641) (make-vect 0.375 0.833))
			(make-segment (make-vect 0.594 0.641) (make-vect 0.641 0.833))
			;;right body
			(make-segment (make-vect 0.406 0.641) (make-vect 0.325 0.641))
			(make-segment (make-vect 0.406 0) (make-vect 0.5 0.313))
			(make-segment (make-vect 0.263 0) (make-vect 0.375 0.519))
			(make-segment (make-vect 0.313 0.594) (make-vect 0.375 0.519))
			(make-segment (make-vect 0.313 0.594) (make-vect 0.156 0.406))
			(make-segment (make-vect 0 0.638) (make-vect 0.156 0.406))
			(make-segment (make-vect 0.188 0.594) (make-vect 0.325 0.641))
			(make-segment (make-vect 0.188 0.594) (make-vect 0 0.844))
			;;left body
			(make-segment (make-vect 0.594 0.641) (make-vect 0.75 0.641))
			(make-segment (make-vect 1 0.375) (make-vect 0.75 0.641))
			(make-segment (make-vect 0.594 0.438) (make-vect 1 0.181))
			(make-segment (make-vect 0.594 0.438) (make-vect 0.75 0))
			(make-segment (make-vect 0.594 0) (make-vect 0.5 0.313))
			;;add dull face for 9a
			(make-segment (make-vect 0.45 0.931) (make-vect 0.45 0.825))
			(make-segment (make-vect 0.563 0.931) (make-vect 0.563 0.825))
			(make-segment (make-vect 0.406 0.781) (make-vect 0.575 0.781))

		)
	)
)

;; flip-horizontal
(define (flip-horiz painter)
	(transform-painter painter 
		(make-vect 1.0 0.0) ;; origin
		(make-vect 0.0 0.0) ;; bottom
		(make-vect 1.0 1.0) ;; side
	)
)
;; below analogous to beside
(define (below bottom top)
	(let ((split-point (make-vect 0.0 0.5)))
		(let ((paint-bottom
			(transform-painter bottom
				(make-vect 0.0 0.0)
				(make-vect 1.0 0.0)
				split-point))
		(paint-top 
			(transform-painter top
				split-point
				(make-vect 1.0 0.5)
				(make-vect 0.0 1.0))))
			(lambda (frame)
		(paint-bottom frame) 
		(paint-top frame))))
)

;; below using beside and flips
(define (below-2 bottom top)
	(rotate90 (beside 
		(rotate90cw bottom)
		(rotate90cw top)))
)
;; rotate 90 degrees clockwise
(define (rotate90cw painter)
	(transform-painter painter
		(make-vect 0.0 1.0)
		(make-vect 0.0 0.0)
		(make-vect 1.0 1.0)
	)
)

;;revised corner-split
(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
	    (right (right-split painter (- n 1))))
	(let ((top-left up)
	      (bottom-right right)
	      (corner (corner-split painter (- n 1))))
	  (beside (below painter top-left)
		  (below bottom-right corner))))))



(define full-frame (make-frame (make-vect -0.5 -0.5)
			       (make-vect 2 0)
			       (make-vect 0 2)))
