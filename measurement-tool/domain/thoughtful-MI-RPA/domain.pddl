
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define (domain thoughtful-typed)
	(:requirements :typing)
	(:types card colnum num suittype)
	(:predicates (on ?dummy - card ?c1 - card ?c2 - card)
		(ace ?dummy - card ?c - card)
		(king ?dummy - card ?c - card)
		(clear ?dummy - card ?c - card)
		(colspace ?dummy - colnum ?n - colnum)
  		(bottomtalon ?dummy - card ?c - card)
		(toptalon ?dummy - card ?c - card)
		(ontalon ?dummy - card ?c1 - card ?c2 - card)
		(talonplayable ?dummy - card ?c - card)
		(instack ?dummy - card ?c - card)
		(home ?dummy - card ?c - card)
		(faceup ?dummy - card ?c - card)
		(bottomcol ?dummy - card ?c - card)
		(suit ?dummy - card ?c - card ?s - suittype)
		(value ?dummy - card ?c - card ?v - num)
		(successor ?dummy - num ?n1 - num ?n0 - num)
		(canstack ?dummy - card ?c1 - card ?c2 - card)
		(colsuccessor ?dummy - colnum ?n1 - colnum ?n0 - colnum)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Move card between columns.  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; move card from one column to another

	(:action move-col-to-col
		:parameters (?card ?oldcard ?newcard - card)
		:precondition (and 
			(faceup ?card ?card)
			(clear ?newcard ?newcard)
			(canstack ?card ?card ?newcard)
			(on ?card ?card ?oldcard))
		:effect(and
			(on ?card ?card ?newcard)
			(clear ?oldcard ?oldcard)
			(faceup ?oldcard ?oldcard)
			(not (on ?card ?card ?oldcard))
			(not (clear ?newcard ?newcard))))

;; move card from one column to another - create an empty column

	(:action move-col-to-col-b
		:parameters (?card ?newcard - card ?cols ?ncols - colnum)
		:precondition (and 
				(faceup ?card ?card)
				(bottomcol ?card ?card)
				(clear ?newcard ?newcard)
				(canstack ?card ?card ?newcard)
				(colspace ?cols ?cols)
				(colsuccessor ?ncols ?ncols ?cols))
		:effect (and 
			(on ?card ?card ?newcard)
			(colspace ?ncols ?ncols)
			(not (bottomcol ?card ?card))
			(not (clear ?newcard ?newcard))
			(not (colspace ?cols ?cols))))

;; send a king to an empty column

	(:action move-col-to-col-c
		:parameters (?card ?oldcard - card ?cols ?ncols - colnum)
		:precondition (and
			(faceup ?card ?card)
			(king ?card ?card)
			(colspace ?cols ?cols)
			(colsuccessor ?cols ?cols ?ncols)
			(on ?card ?card ?oldcard))
		:effect (and
			(bottomcol ?card ?card)
			(clear ?oldcard ?oldcard)
			(faceup ?oldcard ?oldcard)
			(colspace ?ncols ?ncols)
			(not (on ?card ?card ?oldcard))
			(not (colspace ?cols ?cols))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Move card from column to home 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(:action col-to-home
		:parameters (?card ?oldcard - card ?suit - suittype ?vcard - num
				?homecard - card ?vhomecard - num)
		:precondition (and
			(clear ?card ?card)
			(on ?card ?card ?oldcard)
			(home ?homecard ?homecard)
			(suit ?card ?card ?suit)
			(suit ?homecard ?homecard ?suit)
			(value ?card ?card ?vcard)
			(value ?homecard ?homecard ?vhomecard)
			(successor ?vcard ?vcard ?vhomecard))
		:effect (and
			(home ?card ?card)
			(clear ?oldcard ?oldcard)
			(faceup ?oldcard ?oldcard)
			(on ?card ?card ?homecard)
			(not (on ?card ?card ?oldcard))
			(not (home ?homecard ?homecard))
			(not (faceup ?card ?card))
			(not (clear ?card ?card))))

;; Move card from column to home - create an empty column

	(:action col-to-home-b
		:parameters (?card ?homecard - card ?suit - suittype ?vcard - num 
			?vhomecard - num ?cols ?ncols - colnum)
		:precondition (and
			(clear ?card ?card)
			(bottomcol ?card ?card)
			(home ?homecard ?homecard)
			(suit ?card ?card ?suit)
			(suit ?homecard ?homecard ?suit)
			(value ?card ?card ?vcard)
			(value ?homecard ?homecard ?vhomecard)
			(successor ?vcard ?vcard ?vhomecard)
			(colspace ?cols ?cols)
			(colsuccessor ?ncols ?ncols ?cols))
		:effect (and
			(home ?card ?card)
			(colspace ?ncols ?ncols)
			(not (home ?homecard ?homecard))
			(not (faceup ?card ?card))
			(not (clear ?card ?card))
			(not (bottomcol ?card ?card))
			(not (colspace ?cols ?cols))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Move card from talon to column 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(:action tal-to-col
		:parameters (?card ?oldcard ?newcard ?cardabove - card)
		:precondition (and
			(clear ?newcard ?newcard)
			(ontalon ?card ?card ?oldcard)
			(ontalon ?cardabove ?cardabove ?card)
			(talonplayable ?card ?card)
			(canstack ?card ?card ?newcard))
		:effect (and
			(clear ?card ?card)
			(faceup ?card ?card)
			(talonplayable ?oldcard ?oldcard)
			(on ?card ?card ?newcard)
			(ontalon ?cardabove ?cardabove ?oldcard)
			(not (clear ?newcard ?newcard))
			(not (talonplayable ?card ?card))
			(not (ontalon ?card ?card ?oldcard))
			(not (ontalon ?cardabove ?cardabove ?card))))

;; move card from talon to column - card is bottom card in talon

	(:action tal-to-col-b
		:parameters (?card ?newcard ?cardabove - card)
		:precondition (and
			(clear ?newcard ?newcard)
			(ontalon ?cardabove ?cardabove ?card)
			(talonplayable ?card ?card)
			(bottomtalon ?card ?card)
			(canstack ?card ?card ?newcard))
		:effect (and
			(clear ?card ?card)
			(faceup ?card ?card)
			(on ?card ?card ?newcard)
			(bottomtalon ?cardabove ?cardabove)
			(talonplayable ?cardabove ?cardabove)
			(not (bottomtalon ?card ?card))
			(not (talonplayable ?card ?card))
			(not (clear ?newcard ?newcard))
			(not (ontalon ?cardabove ?cardabove ?card))))

;; move card from talon to column - card is top card in talon

	(:action tal-to-col-c
		:parameters (?card ?newcard ?oldcard - card)
		:precondition (and
			(clear ?newcard ?newcard)
			(ontalon ?card ?card ?oldcard)
			(canstack ?card ?card ?newcard)
			(talonplayable ?card ?card)
			(toptalon ?card ?card))
		:effect (and
			(clear ?card ?card)
			(faceup ?card ?card)
			(on ?card ?card ?newcard)
			(toptalon ?oldcard ?oldcard)
			(talonplayable ?oldcard ?oldcard)
			(not (clear ?newcard ?newcard))
			(not (toptalon ?card ?card))
			(not (talonplayable ?card ?card))
			(not (ontalon ?card ?card ?oldcard))))

;; move card from talon to column - card is the only card in talon

	(:action tal-to-col-d
		:parameters (?card ?newcard - card)
		:precondition (and
			(clear ?newcard ?newcard)
			(canstack ?card ?card ?newcard)
			(bottomtalon ?card ?card)
			(toptalon ?card ?card)
			(talonplayable ?card ?card))
		:effect (and
			(clear ?card ?card)
			(faceup ?card ?card)
			(on ?card ?card ?newcard)
			(not (clear ?newcard ?newcard))
			(not (toptalon ?card ?card))
			(not (talonplayable ?card ?card))
			(not (bottomtalon ?card ?card))))

;; move king from talon to column

	(:action tal-to-col-e
		:parameters (?card ?oldcard ?cardabove - card ?cols ?ncols - colnum)
		:precondition (and
			(king ?card ?card)
			(ontalon ?card ?card ?oldcard)
			(ontalon ?cardabove ?cardabove ?card)
			(talonplayable ?card ?card)
			(colspace ?cols ?cols)
			(colsuccessor ?cols ?cols ?ncols))
		:effect (and
			(clear ?card ?card)
			(faceup ?card ?card)
			(talonplayable ?oldcard ?oldcard)
			(ontalon ?cardabove ?cardabove ?oldcard)
			(bottomcol ?card ?card)
			(colspace ?ncols ?ncols)
			(not (colspace ?cols ?cols))
			(not (talonplayable ?card ?card))
			(not (ontalon ?card ?card ?oldcard))
			(not (ontalon ?cardabove ?cardabove ?card))))

;; move king from talon to column - king is bottom card in talon

	(:action tal-to-col-f
		:parameters (?card ?cardabove - card ?cols ?ncols - colnum)
		:precondition (and
			(king ?card ?card)
			(ontalon ?cardabove ?cardabove ?card)
			(talonplayable ?card ?card)
			(bottomtalon ?card ?card)
			(colspace ?cols ?cols)
			(colsuccessor ?cols ?cols ?ncols))
		:effect (and
			(clear ?card ?card)
			(faceup ?card ?card)
			(bottomtalon ?cardabove ?cardabove)
			(talonplayable  ?cardabove ?cardabove)
			(bottomcol ?card ?card)
			(colspace ?ncols ?ncols)
			(not (colspace ?cols ?cols))
			(not (bottomtalon ?card ?card))
			(not (talonplayable ?card ?card))
			(not (ontalon ?cardabove ?cardabove ?card))))

;; move king from talon to column - card is top card in talon

	(:action tal-to-col-g
		:parameters (?card ?oldcard - card ?cols ?ncols - colnum)
		:precondition (and
			(king ?card ?card)
			(ontalon ?card ?card ?oldcard)
			(talonplayable ?card ?card)
			(colspace ?cols ?cols)
			(colsuccessor ?cols ?cols ?ncols)
			(toptalon ?card ?card))
		:effect (and
			(clear ?card ?card)
			(faceup ?card ?card)
			(toptalon ?oldcard ?oldcard)
			(talonplayable ?oldcard ?oldcard)
			(bottomcol ?card ?card)
			(colspace ?ncols ?ncols)
			(not (colspace ?cols ?cols))
			(not (toptalon ?card ?card))
			(not (talonplayable ?card ?card))
			(not (ontalon ?card ?card ?oldcard))))

;; move king from talon to column - card is the only card in talon

	(:action tal-to-col-h
		:parameters (?card - card ?cols ?ncols - colnum)
		:precondition (and
			(king ?card ?card)
			(bottomtalon ?card ?card)
			(toptalon ?card ?card)
			(colspace ?cols ?cols)
			(colsuccessor ?cols ?cols ?ncols)
			(talonplayable ?card ?card))
		:effect (and
			(clear ?card ?card)
			(faceup ?card ?card)
			(bottomcol ?card ?card)
			(colspace ?ncols ?ncols)
			(not (colspace ?cols ?cols))
			(not (toptalon ?card ?card))
			(not (talonplayable ?card ?card))
			(not (bottomtalon ?card ?card))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Move card from talon to home 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; move card from talon to home

	(:action tal-to-home
		:parameters (?card ?cardabove ?cardbelow ?homecard - card ?cardsuit - suittype
			?vcard ?vhomecard - num)
		:precondition (and
			(talonplayable ?card ?card)
			(ontalon ?cardabove ?cardabove ?card)
			(ontalon ?card ?card ?cardbelow)
			(suit ?card ?card ?cardsuit)
			(suit ?homecard ?homecard ?cardsuit)
			(home ?homecard ?homecard)
			(value ?card ?card ?vcard)
			(value ?homecard ?homecard ?vhomecard)
			(successor ?vcard ?vcard ?vhomecard))
		:effect (and
			(talonplayable ?cardbelow ?cardbelow)
			(not (talonplayable ?card ?card))
			(ontalon ?cardabove ?cardabove ?cardbelow)
			(not (ontalon ?cardabove ?cardabove ?card))
			(not (ontalon ?card ?card ?cardbelow))
			(home ?card ?card)
			(not (home ?homecard ?homecard))))

;; move card from talon to home - card is bottom card in talon

	(:action tal-to-home-b
		:parameters (?card ?cardabove ?homecard  - card ?cardsuit - suittype
			?vcard ?vhomecard - num)
		:precondition (and
			(talonplayable ?card ?card)
			(ontalon ?cardabove ?cardabove ?card)
			(bottomtalon ?card ?card)
			(home ?homecard ?homecard)
			(suit ?card ?card ?cardsuit)
			(suit ?homecard ?homecard ?cardsuit)
			(value ?card ?card ?vcard)
			(value ?homecard ?homecard ?vhomecard)
			(successor ?vcard ?vcard ?vhomecard))
		:effect (and
			(bottomtalon ?cardabove ?cardabove)
			(talonplayable ?cardabove ?cardabove)
			(home ?card ?card)
			(not (bottomtalon ?card ?card))
			(not (talonplayable ?card ?card))
			(not (ontalon ?cardabove ?cardabove ?card))
			(not (home ?homecard ?homecard))))

;; move card from talon to home - card is top card in talon

	(:action tal-to-home-c
		:parameters (?card ?cardbelow ?homecard - card ?cardsuit - suittype
			?vcard ?vhomecard - num)
		:precondition (and
			(ontalon ?card ?card ?cardbelow)
			(talonplayable ?card ?card)
			(toptalon ?card ?card)
			(home ?homecard ?homecard)
			(suit ?card ?card ?cardsuit)
			(suit ?homecard ?homecard ?cardsuit)
			(value ?card ?card ?vcard)
			(value ?homecard ?homecard ?vhomecard)
			(successor ?vcard ?vcard ?vhomecard))
		:effect (and
			(toptalon ?cardbelow ?cardbelow)
			(talonplayable ?cardbelow ?cardbelow)
			(home ?card ?card)
			(not (home ?homecard ?homecard))
			(not (toptalon ?card ?card))
			(not (talonplayable ?card ?card))
			(not (ontalon ?card ?card ?cardbelow))))

;; move card from talon to home - card is the only card in talon

	(:action tal-to-home-d
		:parameters (?card ?homecard - card ?cardsuit - suittype
			?vcard ?vhomecard - num)
		:precondition (and
			(bottomtalon ?card ?card)
			(toptalon ?card ?card)
			(talonplayable ?card ?card)
			(home ?homecard ?homecard)
			(suit ?card ?card ?cardsuit)
			(suit ?homecard ?homecard ?cardsuit)
			(value ?card ?card ?vcard)
			(value ?homecard ?homecard ?vhomecard)
			(successor ?vcard ?vcard ?vhomecard))
		:effect (and
			(home ?card ?card)
			(not (home ?homecard ?homecard))
			(not (toptalon ?card ?card))
			(not (talonplayable ?card ?card))
			(not (bottomtalon ?card ?card))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Move card from home to column (pointless to move aces from home)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; move card from home to column
	
	(:action home-to-col
		:parameters (?card ?cardbelow ?newcard - card ?cardsuit - suittype
			?vcard ?vcardbelow - num)
		:precondition (and
			(home ?card ?card)
			(suit ?card ?card ?cardsuit)
			(suit ?cardbelow ?cardbelow ?cardsuit)
			(value ?card ?card ?vcard)
			(value ?cardbelow ?cardbelow ?vcardbelow)
			(successor ?vcard ?vcard ?vcardbelow)
			(canstack ?card ?card ?newcard)
			(clear ?newcard ?newcard))
		:effect (and
			(clear ?card ?card)
			(faceup ?card ?card)
			(home ?cardbelow ?cardbelow)
			(on ?card ?card ?newcard)
			(not (home ?card ?card))
			(not (clear ?newcard ?newcard))))

;; move king from home to column
	
	(:action home-to-col-a
		:parameters (?card ?cardbelow - card ?cardsuit - suittype
			?vcard ?vcardbelow - num ?cols ?ncols - colnum)
		:precondition (and
			(home ?card ?card)
			(king ?card ?card)
			(suit ?card ?card ?cardsuit)
			(suit ?cardbelow ?cardbelow ?cardsuit)
			(value ?card ?card ?vcard)
			(value ?cardbelow ?cardbelow ?vcardbelow)
			(successor ?vcard ?vcard ?vcardbelow)
			(colspace ?cols ?cols)
			(colsuccessor ?cols ?cols ?ncols))
		:effect (and
			(home ?cardbelow ?cardbelow)
			(bottomcol ?card ?card)
			(clear ?card ?card)
			(faceup ?card ?card)
			(colspace ?ncols ?ncols)
			(not (colspace ?cols ?cols))
			(not (home ?card ?card))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Turn Deck
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
;; turn deck

	(:action turn-deck
		:parameters (?card ?c1 - card)
		:precondition (and
			(talonplayable ?card ?card)
			(ontalon ?c1 ?c1 ?card))
		:effect (and
			(talonplayable ?c1 ?c1)
			(not (talonplayable ?card ?card))))

;; turn deck - top talon card is currently talon playable	- at least 4 cards in talon

	(:action turn-deck-a
		:parameters (?card ?c1 - card)
		:precondition (and
			(talonplayable ?card ?card)
			(toptalon ?card ?card)
			(bottomtalon ?c1 ?c1))
		:effect (and
			(talonplayable ?c1 ?c1)
			(not (talonplayable ?card ?card)))))
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



