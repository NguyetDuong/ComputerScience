(define (twenty-one strategy)
  (define (play-dealer customer-hand dealer-hand-so-far rest-of-deck)
    (cond ((> (best-total dealer-hand-so-far) 21) 1)
	  ((< (best-total dealer-hand-so-far) 17)
	   (play-dealer customer-hand
			(se dealer-hand-so-far (first rest-of-deck))
			(bf rest-of-deck)))
	  ((< (best-total customer-hand) (best-total dealer-hand-so-far)) -1)
	  ((= (best-total customer-hand) (best-total dealer-hand-so-far)) 0)
	  (else 1)))

  (define (play-customer customer-hand-so-far dealer-up-card rest-of-deck)
    (cond ((> (best-total customer-hand-so-far) 21) -1)
	  ((strategy customer-hand-so-far dealer-up-card)
	   (play-customer (se customer-hand-so-far (first rest-of-deck))
			  dealer-up-card
			  (bf rest-of-deck)))
	  (else
	   (play-dealer customer-hand-so-far
			(se dealer-up-card (first rest-of-deck))
			(bf rest-of-deck)))))

  (let ((deck (make-deck)))
    (play-customer (se (first deck) (first (bf deck)))
		   (first (bf (bf deck)))
		   (bf (bf (bf deck))))) )

(define (make-ordered-deck)
  (define (make-suit s)
    (every (lambda (rank) (word rank s)) '(A 2 3 4 5 6 7 8 9 10 J Q K)) )
  (se (make-suit 'H) (make-suit 'S) (make-suit 'D) (make-suit 'C)) )

(define (make-deck)
  (define (shuffle deck size)
    (define (move-card in out which)
      (if (= which 0)
	  (se (first in) (shuffle (se (bf in) out) (- size 1)))
	  (move-card (bf in) (se (first in) out) (- which 1)) ))
    (if (= size 0)
	deck
    	(move-card deck '() (random size)) ))
  (shuffle (make-ordered-deck) 52) )

(define (best-total cards)
	(define (addup c pt totalA) ;; +'s pts in the cards
		(cond ((empty? c)
				(if (= totalA 0)
					pt
					(if (< pt 11)
						(addup c (+ pt 11) (- totalA 1))
						(addup c (+ pt 1) (- totalA 1))
					)))
				((equal? (first (first c)) 'a)
				(addup (bf c) pt (+ totalA 1)))
				((member? (first (first c)) 'jkq)
					(addup (bf c) (+ pt 10) totalA)
				)
				((number? (first (first c)))
					(if (= 1 (first (first c)))
						(addup (bf c) (+ pt 10) totalA)
						(addup (bf c) (+ pt (first (first c))) totalA)
					))
				(else 0)
		)
	)	
	 (define (number? n)
		(or (= n 1) (= n 2) (= n 3) (= n 4) (= n 5) (= n 6) (= n 7)
		(= n 8) (= n 9))
	)
	 (addup cards 0 0)	
)

(define (stop-at-17 currentCards dealerSeenCards)
	(< (best-total currentCards) 17)
)

(define (play-n strategy n)
	(define (count-pts strat times points) ;; plays the game n times, and adds up all the pts received
		(if (= times 0)
			points
			(count-pts strat (- times 1) (+ points (twenty-one strat))))
	)
	(count-pts strategy n 0)
)

(define (dealer-sensitive current-cards dealer-up-card)	
	(define (checker-less-17 c) ;;checks if its true for half of the first bullet 
		(or (member? (first (first c)) 'akjq) (>= (first (first c)) 7)
		(= (first (first c)) 1))
	)

	(define (checker-less-12 c) ;;checks if its true for half of the first bullet
		(if (member? (first (first c)) 'akqj)
			#f
			(and (< 1 (first (first c))) (>= 6 (first (first c)))))
	)

	(or (and (checker-less-17 dealer-up-card) (< (best-total current-cards) 17))
		(and (checker-less-12 dealer-up-card) (< (best-total current-cards) 12)))


)

(define (stop-at n)
	(lambda (current-cards dealer-up-card) (< (best-total current-cards) n))
)

(define (valentine current-cards dealer-up-card)
	(define (check-hearts hand)
		(if (empty? hand)
			#f
			(if (equal? 'h (last (first hand)))
				#t
			(check-hearts (bf hand)))
		)
	)
	(if (check-hearts current-cards)
		(< (best-total current-cards) 19)
		(stop-at-17 current-cards dealer-up-card)
	)

)

(define (suit-strategy suit strat-no-suit strat-yes-suit)
  (define (check-suit) ;; checks if the suit is in the players hand
    (define (get-players-suits hand) ;; gets a sentence of ONLY the suits in the player's hand
      (if (empty? hand)
	  '()
	  (se (last (first hand)) (get-players-suits (bf hand)))
     ))

    (lambda (playerscards dealercard) (if (member? suit (get-players-suits playerscards))
			    (strat-yes-suit playerscards dealercard)
			    (strat-no-suit playerscards dealercard)))

    )
  (check-suit)
    
 )

(define (new-valentine current-cards dealer-up-card)
  ((suit-strategy 'h stop-at-17 (stop-at 19)) current-cards dealer-up-card)
)
  
(define (majority strata stratb stratc)
  (lambda (playerscards dealercard) (or (and (strata playerscards dealercard) (stratb playerscards dealercard))
					(and (strata playerscards dealercard) (stratc playerscards dealercard))
					(and (stratb playerscards dealercard) (stratc playerscards dealercard)))))

(define (reckless strat)
  (lambda (playerscards dealercard) (strat (bl playerscards) dealercard)))
					





