(define (domain recharging-robots)
(:requirements :typing :adl :action-costs)
(:types
    location - object
    robot - object
    battery-level - object
    config - object
)

(:predicates
    ;; ?f1 is predecessor of ?f2 in the battery level, i.e., ?f2 = ?f1 + 1
    (BATTERY-PREDECESSOR ?dummy - battery-level ?f1 - battery-level ?f2 - battery-level)
    ;; Two locations are connected in the graph of locations
    (CONNECTED ?dummy - location ?l1 - location ?l2 - location)
    ;; Definition of a guarding configuration, i.e., one atom per location
    ;; in each configuration
    (GUARD-CONFIG ?dummy - config ?c - config ?l - location)
    ;; Robot is located at the given location
    (at ?dummy - robot ?r - robot ?l - location)
    ;; The remaining battery of the robot
    (battery ?dummy - robot ?r - robot ?f - battery-level)
    ;; Robot stopped and is guarding all locations connected to the
    ;; location where robot is located
    (stopped ?dummy - robot ?r - robot)
    ;; Location ?l is guarded by at least one robot
    (guarded ?dummy - location ?l - location)
    ;; Configuration is fullfilled, i.e., all of its locations were guarded
    ;; at some point.
    (config-fullfilled ?dummy - config ?c - config)
)

(:functions
    (move-cost) - number
    (recharge-cost) - number
    (total-cost) - number
)

;; Move the robot ?r from the location ?from to the location ?to while
;; consuming the battery -- it is decreased by one from ?fpre to ?fpost
(:action move
    :parameters (?r - robot ?from - location ?to - location
                 ?fpre - battery-level ?fpost - battery-level)
    :precondition
        (and
            (not (stopped ?r ?r))
            (at ?r ?r ?from)
            (battery ?r ?r ?fpre)
            (BATTERY-PREDECESSOR ?fpost ?fpost ?fpre)
            (or (CONNECTED ?from ?from ?to) (CONNECTED ?to ?to ?from))
        )
    :effect
        (and
            (not (at ?r ?r ?from))
            (at ?r ?r ?to)
            (not (battery ?r ?r ?fpre))
            (battery ?r ?r ?fpost)
            (increase (total-cost) (move-cost))
        )
)

;; Recharge robot ?rto at location ?loc by transfering one unit of battery
;; charge from the robot ?rfrom
(:action recharge
    :parameters (?rfrom - robot ?rto - robot ?loc - location
                 ?fpre-from - battery-level ?fpost-from - battery-level
                 ?fpre-to - battery-level ?fpost-to - battery-level)
    :precondition
        (and
            (not (= ?rfrom ?rto))
            (at ?rfrom ?rfrom ?loc)
            (at ?rto ?rto ?loc)
            (battery ?rfrom ?rfrom ?fpre-from)
            (battery ?rto ?rto ?fpre-to)
            (BATTERY-PREDECESSOR ?fpost-from ?fpost-from ?fpre-from)
            (BATTERY-PREDECESSOR ?fpre-to ?fpre-to ?fpost-to)
        )
    :effect
        (and
            (not (battery ?rfrom ?rfrom ?fpre-from))
            (battery ?rfrom ?rfrom ?fpost-from)
            (not (battery ?rto ?rto ?fpre-to))
            (battery ?rto ?rto ?fpost-to)
            (increase (total-cost) (recharge-cost))
        )
)

;; Stop the robot at its current location and guard the neighborhood.
;; Once the robot stopped it can move again only when the configuration is
;; fullfilled, i.e., stopping too early can result in a dead-end.
;; Note that the conditional effect can be compiled away without blow-up,
;; because it is conditioned on a static predicates.
(:action stop-and-guard
    :parameters (?r - robot ?l - location)
    :precondition
        (and
            (not (stopped ?r ?r))
            (at ?r ?r ?l)
        )
    :effect
        (and
            (stopped ?r ?r)
            (guarded ?l ?l)
            (forall (?l2 - location)
                (when (or (CONNECTED ?l ?l ?l2) (CONNECTED ?l2 ?l2 ?l))
                      (guarded ?l2 ?l2)
                )
            )
        )
)

;; Verify that the given configuration is fullfilled, i.e., robots guard
;; all locations from the configuration.
;; Note that this action unblocks all robots whether they participate in
;; guarding of the configuration or not. This simplifies the model because
;; otherwise, we would need to keep track of what location is guarded by
;; which robot (it can be guarded by multiple ones).
;; Also note the precondition does not have to inccur exponential blow-up
;; because the imply condition is conditioned on a static predicate.
(:action verify-guard-config
    :parameters (?c - config)
    :precondition
        (and
            (forall (?l - location)
                (imply (GUARD-CONFIG ?c ?c ?l) (guarded ?l ?l))
            )
        )
    :effect
        (and
            (forall (?r - robot) (not (stopped ?r ?r)))
            (forall (?l - location) (not (guarded ?l ?l)))
            (config-fullfilled ?c ?c)
        )
)

)
