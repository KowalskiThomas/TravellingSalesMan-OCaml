module Carte = ICarte.Carte
module Parser = IParser.Parser

let test_load_carte = 
  let s = Sys.time () in
  let villes, routes = Parser.parse_input_file "villes.short.txt" in
  let _ = Carte.make_carte_from_cities_and_roads villes routes in 
  let e = Sys.time () in 
  let city_load_time = e -. s in
  let _ = Printf.printf "Chargement villes: %f\n" city_load_time in
  ()