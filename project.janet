(declare-project
  :name "barista"
  :description "Place for tahani"
  :dependencies ["https://github.com/andrewchambers/janet-sh"
                 "https://github.com/good-place/neil"])

(declare-binscript :main "barista" :install true)
