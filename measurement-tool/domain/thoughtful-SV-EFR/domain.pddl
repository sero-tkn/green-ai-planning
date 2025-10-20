
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define (domain thoughtful-typed)
	(:requirements :typing)
	(:types card colnum num suittype)
	(:predicates (on ?c1 - card ?c2 - card)
		(ace ?c - card)
		(king ?c - card)
		(clear ?c - card)
		(colspace ?n - colnum)
  		(bottomtalon ?c - card)
		(toptalon ?c - card)
		(ontalon ?c1 - card ?c2 - card)
		(talonplayable ?c - card)
		(instack ?c - card)
		(home ?c - card)
		(faceup ?c - card)
		(bottomcol ?c - card)
		(suit ?c - card ?s - suittype)
		(value ?c - card ?v - num)
		(successor ?n1 - num ?n0 - num)
		(canstack ?c1 - card ?c2 - card)
		(colsuccessor ?n1 - colnum ?n0 - colnum)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Move card between columns.  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; move card from one column to another

	(:action move-col-to-col
		:parameters (?card ?oldcard ?newcard - card)
		:precondition (and 
			(faceup ?card)
			(clear ?newcard)
			(canstack ?card ?newcard)
			(on ?card ?oldcard))
		:effect(and
			(not (clear ?newcard))
			(not (on ?card ?oldcard))
			(faceup ?oldcard)
			(clear ?oldcard)
			(on ?card ?newcard)))

;; move card from one column to another - create an empty column

	(:action move-col-to-col-b
		:parameters (?card ?newcard - card ?cols ?ncols - colnum)
		:precondition (and 
				(faceup ?card)
				(bottomcol ?card)
				(clear ?newcard)
				(canstack ?card ?newcard)
				(colspace ?cols)
				(colsuccessor ?ncols ?cols))
		:effect (and
			(not (colspace ?cols))
			(not (clear ?newcard))
			(not (bottomcol ?card))
			(colspace ?ncols)
			(on ?card ?newcard)))

;; send a king to an empty column

	(:action move-col-to-col-c
		:parameters (?card ?oldcard - card ?cols ?ncols - colnum)
		:precondition (and
			(faceup ?card)
			(king ?card)
			(colspace ?cols)
			(colsuccessor ?cols ?ncols)
			(on ?card ?oldcard))
		:effect (and
			(not (colspace ?cols))
			(not (on ?card ?oldcard))
			(colspace ?ncols)
			(faceup ?oldcard)
			(clear ?oldcard)
			(bottomcol ?card)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Move card from column to home 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(:action col-to-home
		:parameters (?card ?oldcard - card ?suit - suittype ?vcard - num
				?homecard - card ?vhomecard - num)
		:precondition (and
			(clear ?card)
			(on ?card ?oldcard)
			(home ?homecard)
			(suit ?card ?suit)
			(suit ?homecard ?suit)
			(value ?card ?vcard)
			(value ?homecard ?vhomecard)
			(successor ?vcard ?vhomecard))
		:effect (and
			(not (clear ?card))
			(not (faceup ?card))
			(not (home ?homecard))
			(not (on ?card ?oldcard))
			(on ?card ?homecard)
			(faceup ?oldcard)
			(clear ?oldcard)
			(home ?card)))

;; Move card from column to home - create an empty column

	(:action col-to-home-b
		:parameters (?card ?homecard - card ?suit - suittype ?vcard - num 
			?vhomecard - num ?cols ?ncols - colnum)
		:precondition (and
			(clear ?card)
			(bottomcol ?card)
			(home ?homecard)
			(suit ?card ?suit)
			(suit ?homecard ?suit)
			(value ?card ?vcard)
			(value ?homecard ?vhomecard)
			(successor ?vcard ?vhomecard)
			(colspace ?cols)
			(colsuccessor ?ncols ?cols))
		:effect (and
			(not (colspace ?cols))
			(not (bottomcol ?card))
			(not (clear ?card))
			(not (faceup ?card))
			(not (home ?homecard))
			(colspace ?ncols)
			(home ?card)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Move card from talon to column 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(:action tal-to-col
		:parameters (?card ?oldcard ?newcard ?cardabove - card)
		:precondition (and
			(clear ?newcard)
			(ontalon ?card ?oldcard)
			(ontalon ?cardabove ?card)
			(talonplayable ?card)
			(canstack ?card ?newcard))
		:effect (and
			(not (ontalon ?cardabove ?card))
			(not (ontalon ?card ?oldcard))
			(not (talonplayable ?card))
			(not (clear ?newcard))
			(ontalon ?cardabove ?oldcard)
			(on ?card ?newcard)
			(talonplayable ?oldcard)
			(faceup ?card)
			(clear ?card)))

;; move card from talon to column - card is bottom card in talon

	(:action tal-to-col-b
		:parameters (?card ?newcard ?cardabove - card)
		:precondition (and
			(clear ?newcard)
			(ontalon ?cardabove ?card)
			(talonplayable ?card)
			(bottomtalon ?card)
			(canstack ?card ?newcard))
		:effect (and
			(not (ontalon ?cardabove ?card))
			(not (clear ?newcard))
			(not (talonplayable ?card))
			(not (bottomtalon ?card))
			(talonplayable ?cardabove)
			(bottomtalon ?cardabove)
			(on ?card ?newcard)
			(faceup ?card)
			(clear ?card)))

;; move card from talon to column - card is top card in talon

	(:action tal-to-col-c
		:parameters (?card ?newcard ?oldcard - card)
		:precondition (and
			(clear ?newcard)
			(ontalon ?card ?oldcard)
			(canstack ?card ?newcard)
			(talonplayable ?card)
			(toptalon ?card))
		:effect (and
			(not (ontalon ?card ?oldcard))
			(not (talonplayable ?card))
			(not (toptalon ?card))
			(not (clear ?newcard))
			(talonplayable ?oldcard)
			(toptalon ?oldcard)
			(on ?card ?newcard)
			(faceup ?card)
			(clear ?card)))

;; move card from talon to column - card is the only card in talon

	(:action tal-to-col-d
		:parameters (?card ?newcard - card)
		:precondition (and
			(clear ?newcard)
			(canstack ?card ?newcard)
			(bottomtalon ?card)
			(toptalon ?card)
			(talonplayable ?card))
		:effect (and
			(not (bottomtalon ?card))
			(not (talonplayable ?card))
			(not (toptalon ?card))
			(not (clear ?newcard))
			(on ?card ?newcard)
			(faceup ?card)
			(clear ?card)))

;; move king from talon to column

	(:action tal-to-col-e
		:parameters (?card ?oldcard ?cardabove - card ?cols ?ncols - colnum)
		:precondition (and
			(king ?card)
			(ontalon ?card ?oldcard)
			(ontalon ?cardabove ?card)
			(talonplayable ?card)
			(colspace ?cols)
			(colsuccessor ?cols ?ncols))
		:effect (and
			(not (ontalon ?cardabove ?card))
			(not (ontalon ?card ?oldcard))
			(not (talonplayable ?card))
			(not (colspace ?cols))
			(colspace ?ncols)
			(bottomcol ?card)
			(ontalon ?cardabove ?oldcard)
			(talonplayable ?oldcard)
			(faceup ?card)
			(clear ?card)))

;; move king from talon to column - king is bottom card in talon

	(:action tal-to-col-f
		:parameters (?card ?cardabove - card ?cols ?ncols - colnum)
		:precondition (and
			(king ?card)
			(ontalon ?cardabove ?card)
			(talonplayable ?card)
			(bottomtalon ?card)
			(colspace ?cols)
			(colsuccessor ?cols ?ncols))
		:effect (and
			(not (ontalon ?cardabove ?card))
			(not (talonplayable ?card))
			(not (bottomtalon ?card))
			(not (colspace ?cols))
			(colspace ?ncols)
			(bottomcol ?card)
			(talonplayable ?cardabove)
			(bottomtalon ?cardabove)
			(faceup ?card)
			(clear ?card)))

;; move king from talon to column - card is top card in talon

	(:action tal-to-col-g
		:parameters (?card ?oldcard - card ?cols ?ncols - colnum)
		:precondition (and
			(king ?card)
			(ontalon ?card ?oldcard)
			(talonplayable ?card)
			(colspace ?cols)
			(colsuccessor ?cols ?ncols)
			(toptalon ?card))
		:effect (and
			(not (ontalon ?card ?oldcard))
			(not (talonplayable ?card))
			(not (toptalon ?card))
			(not (colspace ?cols))
			(colspace ?ncols)
			(bottomcol ?card)
			(talonplayable ?oldcard)
			(toptalon ?oldcard)
			(faceup ?card)
			(clear ?card)))

;; move king from talon to column - card is the only card in talon

	(:action tal-to-col-h
		:parameters (?card - card ?cols ?ncols - colnum)
		:precondition (and
			(king ?card)
			(bottomtalon ?card)
			(toptalon ?card)
			(colspace ?cols)
			(colsuccessor ?cols ?ncols)
			(talonplayable ?card))
		:effect (and
			(not (bottomtalon ?card))
			(not (talonplayable ?card))
			(not (toptalon ?card))
			(not (colspace ?cols))
			(colspace ?ncols)
			(bottomcol ?card)
			(faceup ?card)
			(clear ?card)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Move card from talon to home 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; move card from talon to home

	(:action tal-to-home
		:parameters (?card ?cardabove ?cardbelow ?homecard - card ?cardsuit - suittype
			?vcard ?vhomecard - num)
		:precondition (and
			(talonplayable ?card)
			(ontalon ?cardabove ?card)
			(ontalon ?card ?cardbelow)
			(suit ?card ?cardsuit)
			(suit ?homecard ?cardsuit)
			(home ?homecard)
			(value ?card ?vcard)
			(value ?homecard ?vhomecard)
			(successor ?vcard ?vhomecard))
		:effect (and
			(not (home ?homecard))
			(home ?card)
			(not (ontalon ?card ?cardbelow))
			(not (ontalon ?cardabove ?card))
			(ontalon ?cardabove ?cardbelow)
			(not (talonplayable ?card))
			(talonplayable ?cardbelow)))

;; move card from talon to home - card is bottom card in talon

	(:action tal-to-home-b
		:parameters (?card ?cardabove ?homecard  - card ?cardsuit - suittype
			?vcard ?vhomecard - num)
		:precondition (and
			(talonplayable ?card)
			(ontalon ?cardabove ?card)
			(bottomtalon ?card)
			(home ?homecard)
			(suit ?card ?cardsuit)
			(suit ?homecard ?cardsuit)
			(value ?card ?vcard)
			(value ?homecard ?vhomecard)
			(successor ?vcard ?vhomecard))
		:effect (and
			(not (home ?homecard))
			(not (ontalon ?cardabove ?card))
			(not (talonplayable ?card))
			(not (bottomtalon ?card))
			(home ?card)
			(talonplayable ?cardabove)
			(bottomtalon ?cardabove)))

;; move card from talon to home - card is top card in talon

	(:action tal-to-home-c
		:parameters (?card ?cardbelow ?homecard - card ?cardsuit - suittype
			?vcard ?vhomecard - num)
		:precondition (and
			(ontalon ?card ?cardbelow)
			(talonplayable ?card)
			(toptalon ?card)
			(home ?homecard)
			(suit ?card ?cardsuit)
			(suit ?homecard ?cardsuit)
			(value ?card ?vcard)
			(value ?homecard ?vhomecard)
			(successor ?vcard ?vhomecard))
		:effect (and
			(not (ontalon ?card ?cardbelow))
			(not (talonplayable ?card))
			(not (toptalon ?card))
			(not (home ?homecard))
			(home ?card)
			(talonplayable ?cardbelow)
			(toptalon ?cardbelow)))

;; move card from talon to home - card is the only card in talon

	(:action tal-to-home-d
		:parameters (?card ?homecard - card ?cardsuit - suittype
			?vcard ?vhomecard - num)
		:precondition (and
			(bottomtalon ?card)
			(toptalon ?card)
			(talonplayable ?card)
			(home ?homecard)
			(suit ?card ?cardsuit)
			(suit ?homecard ?cardsuit)
			(value ?card ?vcard)
			(value ?homecard ?vhomecard)
			(successor ?vcard ?vhomecard))
		:effect (and
			(not (bottomtalon ?card))
			(not (talonplayable ?card))
			(not (toptalon ?card))
			(not (home ?homecard))
			(home ?card)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Move card from home to column (pointless to move aces from home)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; move card from home to column
	
	(:action home-to-col
		:parameters (?card ?cardbelow ?newcard - card ?cardsuit - suittype
			?vcard ?vcardbelow - num)
		:precondition (and
			(home ?card)
			(suit ?card ?cardsuit)
			(suit ?cardbelow ?cardsuit)
			(value ?card ?vcard)
			(value ?cardbelow ?vcardbelow)
			(successor ?vcard ?vcardbelow)
			(canstack ?card ?newcard)
			(clear ?newcard))
		:effect (and
			(not (clear ?newcard))
			(not (home ?card))
			(on ?card ?newcard)
			(home ?cardbelow)
			(faceup ?card)
			(clear ?card)))

;; move king from home to column
	
	(:action home-to-col-a
		:parameters (?card ?cardbelow - card ?cardsuit - suittype
			?vcard ?vcardbelow - num ?cols ?ncols - colnum)
		:precondition (and
			(home ?card)
			(king ?card)
			(suit ?card ?cardsuit)
			(suit ?cardbelow ?cardsuit)
			(value ?card ?vcard)
			(value ?cardbelow ?vcardbelow)
			(successor ?vcard ?vcardbelow)
			(colspace ?cols)
			(colsuccessor ?cols ?ncols))
		:effect (and
			(not (home ?card))
			(not (colspace ?cols))
			(colspace ?ncols)
			(faceup ?card)
			(clear ?card)
			(bottomcol ?card)
			(home ?cardbelow)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Turn Deck
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
;; turn deck

	(:action turn-deck
		:parameters (?card ?c1 - card)
		:precondition (and
			(talonplayable ?card)
			(ontalon ?c1 ?card))
		:effect (and
			(not (talonplayable ?card))
			(talonplayable ?c1)))

;; turn deck - top talon card is currently talon playable	- at least 4 cards in talon

	(:action turn-deck-a
		:parameters (?card ?c1 - card)
		:precondition (and
			(talonplayable ?card)
			(toptalon ?card)
			(bottomtalon ?c1))
		:effect (and
			(not (talonplayable ?card))
			(talonplayable ?c1))))
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



