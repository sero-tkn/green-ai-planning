;; Genearated with: generator.py covers 2 2 1 1 10 1.66 instances/problem_10.pddl instances/plan_10.plan
;; Random seed: 308
(define (problem recharging-robots-cover-robots2-areas1-308-8241)
(:domain recharging-robots)
(:objects
  location-0000 location-0001 location-0002 location-0003 location-0004 location-0005 location-0006 location-0007 location-0008 location-0009 location-0010 location-0011 location-0012 location-0013 - location
  robot-00 robot-01 - robot
  battery-0000 battery-0001 battery-0002 battery-0003 battery-0004 battery-0005 battery-0006 battery-0007 battery-0008 battery-0009 - battery-level
  config-00 - config
)
(:init
  (= (move-cost) 1)
  (= (recharge-cost) 1)
  (= (total-cost) 0)
  (CONNECTED location-0003 location-0003 location-0004)
  (CONNECTED location-0012 location-0012 location-0013)
  (CONNECTED location-0001 location-0001 location-0006)
  (CONNECTED location-0000 location-0000 location-0011)
  (CONNECTED location-0000 location-0000 location-0004)
  (CONNECTED location-0000 location-0000 location-0010)
  (CONNECTED location-0010 location-0010 location-0011)
  (CONNECTED location-0009 location-0009 location-0013)
  (CONNECTED location-0000 location-0000 location-0013)
  (CONNECTED location-0007 location-0007 location-0009)
  (CONNECTED location-0006 location-0006 location-0007)
  (CONNECTED location-0003 location-0003 location-0008)
  (CONNECTED location-0005 location-0005 location-0008)
  (CONNECTED location-0009 location-0009 location-0012)
  (CONNECTED location-0000 location-0000 location-0009)
  (CONNECTED location-0010 location-0010 location-0013)
  (CONNECTED location-0011 location-0011 location-0012)
  (CONNECTED location-0001 location-0001 location-0007)
  (CONNECTED location-0002 location-0002 location-0006)
  (CONNECTED location-0006 location-0006 location-0009)
  (CONNECTED location-0007 location-0007 location-0008)

  (BATTERY-PREDECESSOR battery-0000 battery-0000 battery-0001)
  (BATTERY-PREDECESSOR battery-0001 battery-0001 battery-0002)
  (BATTERY-PREDECESSOR battery-0002 battery-0002 battery-0003)
  (BATTERY-PREDECESSOR battery-0003 battery-0003 battery-0004)
  (BATTERY-PREDECESSOR battery-0004 battery-0004 battery-0005)
  (BATTERY-PREDECESSOR battery-0005 battery-0005 battery-0006)
  (BATTERY-PREDECESSOR battery-0006 battery-0006 battery-0007)
  (BATTERY-PREDECESSOR battery-0007 battery-0007 battery-0008)
  (BATTERY-PREDECESSOR battery-0008 battery-0008 battery-0009)

  (at robot-00 robot-00 location-0006)
  (battery robot-00 robot-00 battery-0001)
  (at robot-01 robot-01 location-0001)
  (battery robot-01 robot-01 battery-0008)

  (GUARD-CONFIG config-00 config-00 location-0000)
  (GUARD-CONFIG config-00 config-00 location-0003)
  (GUARD-CONFIG config-00 config-00 location-0004)
  (GUARD-CONFIG config-00 config-00 location-0005)
  (GUARD-CONFIG config-00 config-00 location-0008)
  (GUARD-CONFIG config-00 config-00 location-0009)
  (GUARD-CONFIG config-00 config-00 location-0010)
  (GUARD-CONFIG config-00 config-00 location-0011)
  (GUARD-CONFIG config-00 config-00 location-0013)

)
(:goal
  (and
    (config-fullfilled config-00 config-00)
  )
)
(:metric minimize (total-cost))
)

