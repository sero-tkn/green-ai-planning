;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 4 Op-blocks world
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain BLOCKS)
  (:requirements :strips :typing)
  (:types block)
  (:predicates (on ?dummy - block ?x - block ?y - block)
	       (ontable ?dummy - block ?x - block)
	       (clear ?dummy - block ?x - block)
	       (handempty)
	       (holding ?dummy - block ?x - block)
	       )

  (:action pick-up
	     :parameters (?x - block)
	     :precondition (and (clear ?x ?x) (ontable ?x ?x) (handempty))
	     :effect
	     (and (not (ontable ?x ?x))
		   (not (clear ?x ?x))
		   (not (handempty))
		   (holding ?x ?x)))

  (:action put-down
	     :parameters (?x - block)
	     :precondition (holding ?x ?x)
	     :effect
	     (and (not (holding ?x ?x))
		   (clear ?x ?x)
		   (handempty)
		   (ontable ?x ?x)))
  (:action stack
	     :parameters (?x - block ?y - block)
	     :precondition (and (holding ?x ?x) (clear ?y ?y))
	     :effect
	     (and (not (holding ?x ?x))
		   (not (clear ?y ?y))
		   (clear ?x ?x)
		   (handempty)
		   (on ?x ?x ?y)))
  (:action unstack
	     :parameters (?x - block ?y - block)
	     :precondition (and (on ?x ?x ?y) (clear ?x ?x) (handempty))
	     :effect
	     (and (holding ?x ?x)
		   (clear ?y ?y)
		   (not (clear ?x ?x))
		   (not (handempty))
		   (not (on ?x ?x ?y)))))
