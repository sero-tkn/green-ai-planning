(define (domain barman)
  (:requirements :strips :typing)
  (:types hand level beverage dispenser container - object
  	  ingredient cocktail - beverage
          shot shaker - container)
  (:predicates  (ontable ?c - container)
                (holding ?h - hand ?c - container)
		(handempty ?h - hand)
		(empty ?c - container)
                (contains ?c - container ?b - beverage)
		(clean ?c - container)
                (used ?c - container ?b - beverage)
                (dispenses ?d - dispenser ?i - ingredient)
		(shaker-empty-level ?s - shaker ?l - level)
		(shaker-level ?s - shaker ?l - level)
		(next ?l1 ?l2 - level)
		(unshaked ?s - shaker)
		(shaked ?s - shaker)
                (cocktail-part1 ?c - cocktail ?i - ingredient)
                (cocktail-part2 ?c - cocktail ?i - ingredient))
		
  (:action grasp
             :parameters (?h - hand ?c - container)
             :precondition (and (ontable ?c) (handempty ?h))
             :effect (and
                (holding ?h ?c)
	     	    (not (handempty ?h))
			    (not (ontable ?c))))

  (:action leave
             :parameters (?h - hand ?c - container)
             :precondition (holding ?h ?c)
             :effect (and
                (ontable ?c)
	     	    (handempty ?h)
			    (not (holding ?h ?c))))
  
  (:action fill-shot
           :parameters (?s - shot ?i - ingredient ?h1 ?h2 - hand ?d - dispenser)
           :precondition (and (holding ?h1 ?s)
                              (handempty ?h2)
	   		      (dispenses ?d ?i)
                              (empty ?s)
			      (clean ?s))
           :effect (and
                (used ?s ?i)
                (not (clean ?s))
                (contains ?s ?i)
                (not (empty ?s))))


  (:action refill-shot
           :parameters (?s - shot ?i - ingredient ?h1 ?h2 - hand ?d - dispenser)
           :precondition (and (holding ?h1 ?s)	   		      
                              (handempty ?h2)
	   		      (dispenses ?d ?i)
                              (empty ?s)
			      (used ?s ?i))
           :effect (and
                (contains ?s ?i)
                (not (empty ?s))))

  (:action empty-shot
           :parameters (?h - hand ?p - shot ?b - beverage)
           :precondition (and (holding ?h ?p)
                              (contains ?p ?b))
           :effect (and
                (empty ?p)
                (not (contains ?p ?b))))

  (:action clean-shot
  	   :parameters (?s - shot ?b - beverage ?h1 ?h2 - hand)
           :precondition (and (holding ?h1 ?s)
                              (handempty ?h2)	   		      
			      (empty ?s)
                              (used ?s ?b))
           :effect (and
                (clean ?s)
                (not (used ?s ?b))))

  (:action pour-shot-to-clean-shaker
           :parameters (?s - shot ?i - ingredient ?d - shaker ?h1 - hand ?l ?l1 - level)
           :precondition (and (holding ?h1 ?s)
			      (contains ?s ?i)
                              (empty ?d)
	   		      (clean ?d)                              
                              (shaker-level ?d ?l)
                              (next ?l ?l1))
           :effect (and
                (shaker-level ?d ?l1)
           	    (not (shaker-level ?d ?l))
           	    (unshaked ?d)
           	    (not (clean ?d))
           	    (not (empty ?d))
           	    (contains ?d ?i)
           	    (empty ?s)
                (not (contains ?s ?i))))


  (:action pour-shot-to-used-shaker
           :parameters (?s - shot ?i - ingredient ?d - shaker ?h1 - hand ?l ?l1 - level)
           :precondition (and (holding ?h1 ?s)
			      (contains ?s ?i)
                              (unshaked ?d)
                              (shaker-level ?d ?l)
                              (next ?l ?l1))
           :effect (and
                (shaker-level ?d ?l1)
                (not (shaker-level ?d ?l))
                (empty ?s)
                (contains ?d ?i)
                (not (contains ?s ?i))))

  (:action empty-shaker
           :parameters (?h - hand ?s - shaker ?b - cocktail ?l ?l1 - level)
           :precondition (and (holding ?h ?s)
                              (contains ?s ?b)
			      (shaked ?s)
			      (shaker-level ?s ?l)
			      (shaker-empty-level ?s ?l1))
           :effect (and
                (empty ?s)
                (not (contains ?s ?b))
            	(shaker-level ?s ?l1)
           	    (not (shaker-level ?s ?l))
                (not (shaked ?s))))

  (:action clean-shaker
  	   :parameters (?h1 ?h2 - hand ?s - shaker)
           :precondition (and (holding ?h1 ?s)
                              (handempty ?h2)
                              (empty ?s))
           :effect (and
                (clean ?s)))
  
  (:action shake
  	   :parameters (?b - cocktail ?d1 ?d2 - ingredient ?s - shaker ?h1 ?h2 - hand)
           :precondition (and (holding ?h1 ?s)
                              (handempty ?h2)
			      (contains ?s ?d1)
                              (contains ?s ?d2)
                              (cocktail-part1 ?b ?d1)
			      (cocktail-part2 ?b ?d2)
			      (unshaked ?s))			      
           :effect (and
                (contains ?s ?b)
                (shaked ?s)
                (not (contains ?s ?d2))
                (not (contains ?s ?d1))
                (not (unshaked ?s))))

  (:action pour-shaker-to-shot
           :parameters (?b - beverage ?d - shot ?h - hand ?s - shaker ?l ?l1 - level)
           :precondition (and (holding ?h ?s)
			      (shaked ?s)
			      (empty ?d)
			      (clean ?d)
			      (contains ?s ?b)
                              (shaker-level ?s ?l)
                              (next ?l1 ?l))
           :effect (and
                (not (shaker-level ?s ?l))
                (shaker-level ?s ?l1)
                (contains ?d ?b)
                (not (empty ?d))
                (not (clean ?d))))
 )