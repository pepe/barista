#!/bin/env janet
(import sh)

(defn capt [label]
  ~(* (some (if-not ,label 1)) ,label :s+ '(some (if-not "\n" 1))))

(defn main [_ &opt ntb]
  (default ntb false)
  (forever
    (try
      (do
        (def ts (string/trim (sh/$< date)))
        (def task (protect (string/trim (sh/$< show-running))))
        (def ut (string/trim (sh/$< uptime)))
        (if ntb
          (let [light (string/slice (sh/$< light) 0 -5)
                batt (match (peg/match ~(* ,(capt "state:") ,(capt "energy-rate:")
                                           (? ,(capt '(* "time to " (<- (+ "empty" "full")) ":")))
                                           ,(capt "percentage:")) (sh/$< upower -i /org/freedesktop/UPower/devices/battery_BAT0))
                       [(s (= s "fully-charged")) e p] "✔"
                       [s e w t p] (string p " " e " " s " to " w " in " t))]
            (prin (if (task 0) (task 1) "Neil is not running?") " | " light "% | " batt " | " ts))
          (prin (if (task 0) (task 1) "Neil is not running?") " | " ut " | " ts))
        (flush)
        (os/sleep 1))
      ([e] (tracev e) (print "Loading")))))
