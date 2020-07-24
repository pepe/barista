(declare-project
  :name "barista"
  :description "Place for tahani"
  :dependencies ["https://github.com/andrewchambers/janet-sh"])

(declare-executable
  :name "barista"
  :entry "barista.janet"
  :install true)
