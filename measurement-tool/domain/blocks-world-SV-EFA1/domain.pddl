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
	        (not (ontable ?x))
		    (holding ?x)
		    (not (handempty))
		    (not (clear ?x))))

  (:action put-down
	     :parameters (?x - block)
	     :precondition (holding ?x)
	     :effect
	     (and
	       (ontable ?x)
		   (not (holding ?x))
		   (handempty)
		   (clear ?x)))
  (:action stack
	     :parameters (?x - block ?y - block)
	     :precondition (and (holding ?x) (clear ?y))
	     :effect
	     (and
	       (on ?x ?y)
	       (not (holding ?x))
		   (handempty)
		   (not (clear ?y))
           (clear ?x)))
  (:action unstack
	     :parameters (?x - block ?y - block)
	     :precondition (and (on ?x ?y) (clear ?x) (handempty))
	     :effect
	     (and
	       (not (on ?x ?y))
	       (holding ?x)
		   (not (handempty))
		   (clear ?y)
           (not (clear ?x)))))