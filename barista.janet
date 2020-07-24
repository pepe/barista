#!/bin/env janet
(import sh)

(defn capt [label]
  ~(* (some (if-not ,label 1)) ,label :s+ '(some (if-not "\n" 1))))

(defn main [argv]
  (try
    (let [b (sh/$< upower -i /org/freedesktop/UPower/devices/battery_BAT0)
          light (string/slice (sh/$< light) 0 -5)
          ts (string/trim (sh/$< date))
          batt (match (peg/match ~(* ,(capt "state:") ,(capt "energy-rate:")
                                     (? ,(capt '(* "time to " (<- (+ "empty" "full")) ":")))
                                     ,(capt "percentage:")) b)
                 [(s (= s "fully-charged")) e p] "✔"
                 [s e w t p] (string p " " e " " s " to " w " in " t))
          task (protect (string/trim (sh/$< show-running)))]
      (prin (if (task 0) (task 1) "Neil is not running?") " | " light "% | " batt " | " ts))
    ([e] (print "Loading"))))
