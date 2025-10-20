(define (domain gripper-typed)
   (:requirements :typing)
   (:types room ball gripper)
   (:constants left right - gripper)
   (:predicates (at-robby ?r - room)
		(at ?b - ball ?r - room)
		(free ?g - gripper)
		(carry ?o - ball ?g - gripper))

   (:action move
       :parameters  (?from ?to - room)
       :precondition (at-robby ?from)
       :effect (and (not (at-robby ?from))
		     (at-robby ?to)))



   (:action pick
       :parameters (?obj - ball ?room - room ?gripper - gripper)
       :precondition  (and  (at ?obj ?room) (at-robby ?room) (free ?gripper))
       :effect (and (not (free ?gripper))
            (not (at ?obj ?room))
            (carry ?obj ?gripper)))


   (:action drop
       :parameters  (?obj - ball ?room - room ?gripper - gripper)
       :precondition  (and  (carry ?obj ?gripper) (at-robby ?room))
       :effect (and (not (carry ?obj ?gripper))
            (free ?gripper)
            (at ?obj ?room))))



