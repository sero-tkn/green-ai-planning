(define (domain gripper-typed)
   (:requirements :typing)
   (:types room ball gripper)
   (:constants left right - gripper)
   (:predicates (at-robby ?dummy - room ?r - room)
		(at ?dummy - ball ?b - ball ?r - room)
		(free ?dummy - gripper ?g - gripper)
		(carry ?dummy - ball ?o - ball ?g - gripper))

   (:action move
       :parameters  (?from ?to - room)
       :precondition (at-robby ?from ?from)
       :effect (and  (at-robby ?to ?to)
		     (not (at-robby ?from ?from))))



   (:action pick
       :parameters (?obj - ball ?room - room ?gripper - gripper)
       :precondition  (and  (at ?obj ?obj ?room) (at-robby ?room ?room) (free ?gripper ?gripper))
       :effect (and (carry ?obj ?obj ?gripper)
		    (not (at ?obj ?obj ?room))
		    (not (free ?gripper ?gripper))))


   (:action drop
       :parameters  (?obj - ball ?room - room ?gripper - gripper)
       :precondition  (and  (carry ?obj ?obj ?gripper) (at-robby ?room ?room))
       :effect (and (at ?obj ?obj ?room)
		    (free ?gripper ?gripper)
		    (not (carry ?obj ?obj ?gripper)))))



