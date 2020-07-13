#!/bin/env janet
(import sh)

(def t (os/date (os/time) true))

(defn capt [label]
  ~(* (some (if-not ,label 1)) ,label :s+ '(some (if-not "\n" 1))))

(defn pad2 [i]
  (if (< 9 i) (string i) (string "0" i)))

(def ts (string/format "%i-%s-%s %s:%s:%s"
                       (t :year)
                       (pad2 (inc (t :month)))
                       (pad2 (inc (t :month-day)))
                       (pad2 (t :hours))
                       (pad2 (t :minutes))
                       (pad2 (t :seconds))))

(defn main [argv]
  (try
    (let [b (sh/$< upower -i /org/freedesktop/UPower/devices/battery_BAT0)
          d (sh/$< light)
          batt (match (peg/match ~(* ,(capt "state:") ,(capt "energy-rate:")
                                     (? ,(capt '(* "time to " (<- (+ "empty" "full")) ":")))
                                     ,(capt "percentage:")) b)
                 [(s (= s "fully-charged")) e p] "✔"
                 [s e w t p] (string p " " e " " s " to " w " in " t))]
      (print (string/slice d 0 -5) "% | " batt " | " ts))
    ([e] (print "Loading"))))
