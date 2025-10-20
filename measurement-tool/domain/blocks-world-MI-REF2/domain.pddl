;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 4 Op-blocks world
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain BLOCKS)
  (:requirements :strips :typing)
  (:types block)
  (:predicates (DUMMY-FLAG)
           (on ?x - block ?y - block)
	       (ontable ?x - block)
	       (clear ?x - block)
	       (handempty)
	       (holding ?x - block)
	       )

  (:action pick-up
	     :parameters (?x - block)
	     :precondition (and (clear ?x) (ontable ?x) (handempty))
	     :effect
	     (and (DUMMY-FLAG) (not (DUMMY-FLAG)) (not (ontable ?x))
		   (not (clear ?x))
		   (not (handempty))
		   (holding ?x)))

  (:action put-down
	     :parameters (?x - block)
	     :precondition (holding ?x)
	     :effect
	     (and (DUMMY-FLAG) (not (DUMMY-FLAG)) (not (holding ?x))
		   (clear ?x)
		   (handempty)
		   (ontable ?x)))
  (:action stack
	     :parameters (?x - block ?y - block)
	     :precondition (and (holding ?x) (clear ?y))
	     :effect
	     (and (DUMMY-FLAG) (not (DUMMY-FLAG)) (not (holding ?x))
		   (not (clear ?y))
		   (clear ?x)
		   (handempty)
		   (on ?x ?y)))
  (:action unstack
	     :parameters (?x - block ?y - block)
	     :precondition (and (on ?x ?y) (clear ?x) (handempty))
	     :effect
	     (and (DUMMY-FLAG) (not (DUMMY-FLAG)) (holding ?x)
		   (clear ?y)
		   (not (clear ?x))
		   (not (handempty))
		   (not (on ?x ?y)))))
