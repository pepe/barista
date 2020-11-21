(declare-project
  :name "barista"
  :description "Sway bar helper"
  :dependencies ["https://git.sr.ht/~pepe/neil"
                 "https://github.com/janet-lang/path"
                 "https://github.com/janet-lang/json"
                 "https://github.com/sepisoad/jurl"])

(declare-binscript :main "barista" :install true)
