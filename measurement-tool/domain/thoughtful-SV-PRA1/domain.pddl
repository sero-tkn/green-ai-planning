
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
			(on ?card ?oldcard)
			(faceup ?card)
			(clear ?newcard)
			(canstack ?card ?newcard))
		:effect(and
			(on ?card ?newcard)
			(clear ?oldcard)
			(faceup ?oldcard)
			(not (on ?card ?oldcard))
			(not (clear ?newcard))))

;; move card from one column to another - create an empty column

	(:action move-col-to-col-b
		:parameters (?card ?newcard - card ?cols ?ncols - colnum)
		:precondition (and
			(faceup ?card)
			(colsuccessor ?ncols ?cols)
			(colspace ?cols)
			(clear ?newcard)
			(canstack ?card ?newcard)
			(bottomcol ?card))
		:effect (and 
			(on ?card ?newcard)
			(colspace ?ncols)
			(not (bottomcol ?card))
			(not (clear ?newcard))
			(not (colspace ?cols))))

;; send a king to an empty column

	(:action move-col-to-col-c
		:parameters (?card ?oldcard - card ?cols ?ncols - colnum)
		:precondition (and
			(on ?card ?oldcard)
			(king ?card)
			(faceup ?card)
			(colsuccessor ?cols ?ncols)
			(colspace ?cols))
		:effect (and
			(bottomcol ?card)
			(clear ?oldcard)
			(faceup ?oldcard)
			(colspace ?ncols)
			(not (on ?card ?oldcard))
			(not (colspace ?cols))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Move card from column to home 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(:action col-to-home
		:parameters (?card ?oldcard - card ?suit - suittype ?vcard - num
				?homecard - card ?vhomecard - num)
		:precondition (and
			(value ?card ?vcard)
			(value ?homecard ?vhomecard)
			(suit ?card ?suit)
			(suit ?homecard ?suit)
			(successor ?vcard ?vhomecard)
			(on ?card ?oldcard)
			(home ?homecard)
			(clear ?card))
		:effect (and
			(home ?card)
			(clear ?oldcard)
			(faceup ?oldcard)
			(on ?card ?homecard)
			(not (on ?card ?oldcard))
			(not (home ?homecard))
			(not (faceup ?card))
			(not (clear ?card))))

;; Move card from column to home - create an empty column

	(:action col-to-home-b
		:parameters (?card ?homecard - card ?suit - suittype ?vcard - num 
			?vhomecard - num ?cols ?ncols - colnum)
		:precondition (and
			(value ?card ?vcard)
			(value ?homecard ?vhomecard)
			(suit ?card ?suit)
			(suit ?homecard ?suit)
			(successor ?vcard ?vhomecard)
			(home ?homecard)
			(colsuccessor ?ncols ?cols)
			(colspace ?cols)
			(clear ?card)
			(bottomcol ?card))
		:effect (and
			(home ?card)
			(colspace ?ncols)
			(not (home ?homecard))
			(not (faceup ?card))
			(not (clear ?card))
			(not (bottomcol ?card))
			(not (colspace ?cols))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Move card from talon to column 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(:action tal-to-col
		:parameters (?card ?oldcard ?newcard ?cardabove - card)
		:precondition (and
			(talonplayable ?card)
			(ontalon ?card ?oldcard)
			(ontalon ?cardabove ?card)
			(clear ?newcard)
			(canstack ?card ?newcard))
		:effect (and
			(clear ?card)
			(faceup ?card)
			(talonplayable ?oldcard)
			(on ?card ?newcard)
			(ontalon ?cardabove ?oldcard)
			(not (clear ?newcard))
			(not (talonplayable ?card))
			(not (ontalon ?card ?oldcard))
			(not (ontalon ?cardabove ?card))))

;; move card from talon to column - card is bottom card in talon

	(:action tal-to-col-b
		:parameters (?card ?newcard ?cardabove - card)
		:precondition (and
			(talonplayable ?card)
			(ontalon ?cardabove ?card)
			(clear ?newcard)
			(canstack ?card ?newcard)
			(bottomtalon ?card))
		:effect (and
			(clear ?card)
			(faceup ?card)
			(on ?card ?newcard)
			(bottomtalon ?cardabove)
			(talonplayable ?cardabove)
			(not (bottomtalon ?card))
			(not (talonplayable ?card))
			(not (clear ?newcard))
			(not (ontalon ?cardabove ?card))))

;; move card from talon to column - card is top card in talon

	(:action tal-to-col-c
		:parameters (?card ?newcard ?oldcard - card)
		:precondition (and
			(toptalon ?card)
			(talonplayable ?card)
			(ontalon ?card ?oldcard)
			(clear ?newcard)
			(canstack ?card ?newcard))
		:effect (and
			(clear ?card)
			(faceup ?card)
			(on ?card ?newcard)
			(toptalon ?oldcard)
			(talonplayable ?oldcard)
			(not (clear ?newcard))
			(not (toptalon ?card))
			(not (talonplayable ?card))
			(not (ontalon ?card ?oldcard))))

;; move card from talon to column - card is the only card in talon

	(:action tal-to-col-d
		:parameters (?card ?newcard - card)
		:precondition (and
			(toptalon ?card)
			(talonplayable ?card)
			(clear ?newcard)
			(canstack ?card ?newcard)
			(bottomtalon ?card))
		:effect (and
			(clear ?card)
			(faceup ?card)
			(on ?card ?newcard)
			(not (clear ?newcard))
			(not (toptalon ?card))
			(not (talonplayable ?card))
			(not (bottomtalon ?card))))

;; move king from talon to column

	(:action tal-to-col-e
		:parameters (?card ?oldcard ?cardabove - card ?cols ?ncols - colnum)
		:precondition (and
			(talonplayable ?card)
			(ontalon ?card ?oldcard)
			(ontalon ?cardabove ?card)
			(king ?card)
			(colsuccessor ?cols ?ncols)
			(colspace ?cols))
		:effect (and
			(clear ?card)
			(faceup ?card)
			(talonplayable ?oldcard)
			(ontalon ?cardabove ?oldcard)
			(bottomcol ?card)
			(colspace ?ncols)
			(not (colspace ?cols))
			(not (talonplayable ?card))
			(not (ontalon ?card ?oldcard))
			(not (ontalon ?cardabove ?card))))

;; move king from talon to column - king is bottom card in talon

	(:action tal-to-col-f
		:parameters (?card ?cardabove - card ?cols ?ncols - colnum)
		:precondition (and
			(talonplayable ?card)
			(ontalon ?cardabove ?card)
			(king ?card)
			(colsuccessor ?cols ?ncols)
			(colspace ?cols)
			(bottomtalon ?card))
		:effect (and
			(clear ?card)
			(faceup ?card)
			(bottomtalon ?cardabove)
			(talonplayable ?cardabove)
			(bottomcol ?card)
			(colspace ?ncols)
			(not (colspace ?cols))
			(not (bottomtalon ?card))
			(not (talonplayable ?card))
			(not (ontalon ?cardabove ?card))))

;; move king from talon to column - card is top card in talon

	(:action tal-to-col-g
		:parameters (?card ?oldcard - card ?cols ?ncols - colnum)
		:precondition (and
			(toptalon ?card)
			(talonplayable ?card)
			(ontalon ?card ?oldcard)
			(king ?card)
			(colsuccessor ?cols ?ncols)
			(colspace ?cols))
		:effect (and
			(clear ?card)
			(faceup ?card)
			(toptalon ?oldcard)
			(talonplayable ?oldcard)
			(bottomcol ?card)
			(colspace ?ncols)
			(not (colspace ?cols))
			(not (toptalon ?card))
			(not (talonplayable ?card))
			(not (ontalon ?card ?oldcard))))

;; move king from talon to column - card is the only card in talon

	(:action tal-to-col-h
		:parameters (?card - card ?cols ?ncols - colnum)
		:precondition (and
			(toptalon ?card)
			(talonplayable ?card)
			(king ?card)
			(colsuccessor ?cols ?ncols)
			(colspace ?cols)
			(bottomtalon ?card))
		:effect (and
			(clear ?card)
			(faceup ?card)
			(bottomcol ?card)
			(colspace ?ncols)
			(not (colspace ?cols))
			(not (toptalon ?card))
			(not (talonplayable ?card))
			(not (bottomtalon ?card))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Move card from talon to home 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; move card from talon to home

	(:action tal-to-home
		:parameters (?card ?cardabove ?cardbelow ?homecard - card ?cardsuit - suittype
			?vcard ?vhomecard - num)
		:precondition (and
			(value ?card ?vcard)
			(value ?homecard ?vhomecard)
			(talonplayable ?card)
			(suit ?card ?cardsuit)
			(suit ?homecard ?cardsuit)
			(successor ?vcard ?vhomecard)
			(ontalon ?cardabove ?card)
			(ontalon ?card ?cardbelow)
			(home ?homecard))
		:effect (and
			(talonplayable ?cardbelow)
			(not (talonplayable ?card))
			(ontalon ?cardabove ?cardbelow)
			(not (ontalon ?cardabove ?card))
			(not (ontalon ?card ?cardbelow))
			(home ?card)
			(not (home ?homecard))))

;; move card from talon to home - card is bottom card in talon

	(:action tal-to-home-b
		:parameters (?card ?cardabove ?homecard  - card ?cardsuit - suittype
			?vcard ?vhomecard - num)
		:precondition (and
			(value ?card ?vcard)
			(value ?homecard ?vhomecard)
			(talonplayable ?card)
			(suit ?card ?cardsuit)
			(suit ?homecard ?cardsuit)
			(successor ?vcard ?vhomecard)
			(ontalon ?cardabove ?card)
			(home ?homecard)
			(bottomtalon ?card))
		:effect (and
			(bottomtalon ?cardabove)
			(talonplayable ?cardabove)
			(home ?card)
			(not (bottomtalon ?card))
			(not (talonplayable ?card))
			(not (ontalon ?cardabove ?card))
			(not (home ?homecard))))

;; move card from talon to home - card is top card in talon

	(:action tal-to-home-c
		:parameters (?card ?cardbelow ?homecard - card ?cardsuit - suittype
			?vcard ?vhomecard - num)
		:precondition (and
			(value ?card ?vcard)
			(value ?homecard ?vhomecard)
			(toptalon ?card)
			(talonplayable ?card)
			(suit ?card ?cardsuit)
			(suit ?homecard ?cardsuit)
			(successor ?vcard ?vhomecard)
			(ontalon ?card ?cardbelow)
			(home ?homecard))
		:effect (and
			(toptalon ?cardbelow)
			(talonplayable ?cardbelow)
			(home ?card)
			(not (home ?homecard))
			(not (toptalon ?card))
			(not (talonplayable ?card))
			(not (ontalon ?card ?cardbelow))))

;; move card from talon to home - card is the only card in talon

	(:action tal-to-home-d
		:parameters (?card ?homecard - card ?cardsuit - suittype
			?vcard ?vhomecard - num)
		:precondition (and
			(value ?card ?vcard)
			(value ?homecard ?vhomecard)
			(toptalon ?card)
			(talonplayable ?card)
			(suit ?card ?cardsuit)
			(suit ?homecard ?cardsuit)
			(successor ?vcard ?vhomecard)
			(home ?homecard)
			(bottomtalon ?card))
		:effect (and
			(home ?card)
			(not (home ?homecard))
			(not (toptalon ?card))
			(not (talonplayable ?card))
			(not (bottomtalon ?card))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Move card from home to column (pointless to move aces from home)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; move card from home to column
	
	(:action home-to-col
		:parameters (?card ?cardbelow ?newcard - card ?cardsuit - suittype
			?vcard ?vcardbelow - num)
		:precondition (and
			(value ?card ?vcard)
			(value ?cardbelow ?vcardbelow)
			(suit ?card ?cardsuit)
			(suit ?cardbelow ?cardsuit)
			(successor ?vcard ?vcardbelow)
			(home ?card)
			(clear ?newcard)
			(canstack ?card ?newcard))
		:effect (and
			(clear ?card)
			(faceup ?card)
			(home ?cardbelow)
			(on ?card ?newcard)
			(not (home ?card))
			(not (clear ?newcard))))

;; move king from home to column
	
	(:action home-to-col-a
		:parameters (?card ?cardbelow - card ?cardsuit - suittype
			?vcard ?vcardbelow - num ?cols ?ncols - colnum)
		:precondition (and
			(value ?card ?vcard)
			(value ?cardbelow ?vcardbelow)
			(suit ?card ?cardsuit)
			(suit ?cardbelow ?cardsuit)
			(successor ?vcard ?vcardbelow)
			(king ?card)
			(home ?card)
			(colsuccessor ?cols ?ncols)
			(colspace ?cols))
		:effect (and
			(home ?cardbelow)
			(bottomcol ?card)
			(clear ?card)
			(faceup ?card)
			(colspace ?ncols)
			(not (colspace ?cols))
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
			(toptalon ?card)
			(talonplayable ?card)
			(bottomtalon ?c1))
		:effect (and
			(talonplayable ?c1)
			(not (talonplayable ?card)))))
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



