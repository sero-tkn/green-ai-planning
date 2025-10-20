;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 4 Op-blocks world
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain BLOCKS)
  (:requirements :strips :typing)
  (:types block)
  (:predicates (on ?x - block ?y - block)
	       (ontable ?x - block)
	       (clear ?x - block)
	       (handempty)
	       (holding ?x - block)
	       )

  (:action pick-up
	     :parameters (?x - block)
	     :precondition (and (clear ?x) (ontable ?x) (handempty))
	     :effect
	     (and
		   (not (clear ?x))
		   (not (handempty))
		   (holding ?x)
		   (not (ontable ?x))))

  (:action put-down
	     :parameters (?x - block)
	     :precondition (holding ?x)
	     :effect
	     (and
		   (clear ?x)
		   (handempty)
		   (not (holding ?x))
		   (ontable ?x)))
  (:action stack
	     :parameters (?x - block ?y - block)
	     :precondition (and (holding ?x) (clear ?y))
	     :effect
	     (and
	       (not (clear ?y))
           (clear ?x)
           (handempty)
	       (not (holding ?x))
		   (on ?x ?y)))
  (:action unstack
	     :parameters (?x - block ?y - block)
	     :precondition (and (on ?x ?y) (clear ?x) (handempty))
	     :effect
	     (and
	        (clear ?y)
         	(not (clear ?x))
         	(not (handempty))
	        (holding ?x)
		    (not (on ?x ?y)))))