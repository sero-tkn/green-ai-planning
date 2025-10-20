
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
			(clear ?oldcard)
			(not (clear ?newcard))
			(faceup ?oldcard)
			(on ?card ?newcard)
			(not (on ?card ?oldcard))))

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
			(not (bottomcol ?card))
			(not (clear ?newcard))
			(colspace ?ncols)
			(not (colspace ?cols))
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
			(bottomcol ?card)
			(clear ?oldcard)
			(colspace ?ncols)
			(not (colspace ?cols))
			(faceup ?oldcard)
			(not (on ?card ?oldcard))))

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
			(clear ?oldcard)
			(not (clear ?card))
			(faceup ?oldcard)
			(not (faceup ?card))
			(home ?card)
			(not (home ?homecard))
			(on ?card ?homecard)
			(not (on ?card ?oldcard))))

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
			(not (bottomcol ?card))
			(not (clear ?card))
			(colspace ?ncols)
			(not (colspace ?cols))
			(not (faceup ?card))
			(home ?card)
			(not (home ?homecard))))


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
			(clear ?card)
			(not (clear ?newcard))
			(faceup ?card)
			(on ?card ?newcard)
			(ontalon ?cardabove ?oldcard)
			(not (ontalon ?card ?oldcard))
			(not (ontalon ?cardabove ?card))
			(talonplayable ?oldcard)
			(not (talonplayable ?card))))

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
			(bottomtalon ?cardabove)
			(not (bottomtalon ?card))
			(clear ?card)
			(not (clear ?newcard))
			(faceup ?card)
			(on ?card ?newcard)
			(not (ontalon ?cardabove ?card))
			(talonplayable ?cardabove)
			(not (talonplayable ?card))))

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
			(clear ?card)
			(not (clear ?newcard))
			(faceup ?card)
			(on ?card ?newcard)
			(not (ontalon ?card ?oldcard))
			(talonplayable ?oldcard)
			(not (talonplayable ?card))
			(toptalon ?oldcard)
			(not (toptalon ?card))))

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
			(clear ?card)
			(not (clear ?newcard))
			(faceup ?card)
			(on ?card ?newcard)
			(not (talonplayable ?card))
			(not (toptalon ?card))))

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
			(bottomcol ?card)
			(clear ?card)
			(colspace ?ncols)
			(not (colspace ?cols))
			(faceup ?card)
			(ontalon ?cardabove ?oldcard)
			(not (ontalon ?cardabove ?card))
			(not (ontalon ?card ?oldcard))
			(talonplayable ?oldcard)
			(not (talonplayable ?card))))

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
			(bottomcol ?card)
			(bottomtalon ?cardabove)
			(not (bottomtalon ?card))
			(clear ?card)
			(colspace ?ncols)
			(not (colspace ?cols))
			(faceup ?card)
			(not (ontalon ?cardabove ?card))
			(talonplayable ?cardabove)
			(not (talonplayable ?card))))

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
			(bottomcol ?card)
			(clear ?card)
			(colspace ?ncols)
			(not (colspace ?cols))
			(faceup ?card)
			(not (ontalon ?card ?oldcard))
			(talonplayable ?oldcard)
			(not (talonplayable ?card))
			(toptalon ?oldcard)
			(not (toptalon ?card))))

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
			(bottomcol ?card)
			(not (bottomtalon ?card))
			(clear ?card)
			(colspace ?ncols)
			(not (colspace ?cols))
			(faceup ?card)
			(not (talonplayable ?card))
			(not (toptalon ?card))))

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
			(home ?card)
			(not (home ?homecard))
			(ontalon ?cardabove ?cardbelow)
			(not (ontalon ?cardabove ?card))
			(not (ontalon ?card ?cardbelow))
			(talonplayable ?cardbelow)
			(not (talonplayable ?card))))

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
			(bottomtalon ?cardabove)
			(not (bottomtalon ?card))
			(home ?card)
			(not (home ?homecard))
			(not (ontalon ?cardabove ?card))
			(talonplayable ?cardabove)
			(not (talonplayable ?card))))

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
			(home ?card)
			(not (home ?homecard))
			(not (ontalon ?card ?cardbelow))
			(talonplayable ?cardbelow)
			(not (talonplayable ?card))
			(toptalon ?cardbelow)
			(not (toptalon ?card))))

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
			(home ?card)
			(not (home ?homecard))
			(not (talonplayable ?card))
			(not (toptalon ?card))))


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
			(clear ?card)
			(not (clear ?newcard))
			(faceup ?card)
			(home ?cardbelow)
			(not (home ?card))
			(on ?card ?newcard)))

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
			(bottomcol ?card)
			(clear ?card)
			(colspace ?ncols)
			(not (colspace ?cols))
			(faceup ?card)
			(home ?cardbelow)
			(not (home ?card))))

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
			(talonplayable ?c1)
			(not (talonplayable ?card))))

;; turn deck - top talon card is currently talon playable	- at least 4 cards in talon

	(:action turn-deck-a
		:parameters (?card ?c1 - card)
		:precondition (and
			(talonplayable ?card)
			(toptalon ?card)
			(bottomtalon ?c1))
		:effect (and
			(talonplayable ?c1)
			(not (talonplayable ?card)))))
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



