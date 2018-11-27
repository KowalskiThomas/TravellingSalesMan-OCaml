module MLLPath = IMLLPath.MLLPath
module Carte = ICarte.CompleteCarte
module Optimizer = IOptimizer.Optimizer

let _ = Random.self_init()

let _ = Printf.printf "Détermination d'une tournée\n"

let monde = [
    ("Paris", 0., 0.);
    ("Londres", -3., 4.);
    ("Berlin", 8., 2.);
    ("Luxembourg", 6., 3.);
    ("Strasbourg", 5., 1.);
    ("Evry", 1., -2.);
    ("Toulouse", -2., -6.);
    ("NewYork", -22., 4.);
    ("Pekin", 26., -2.);
    ("Belgrade", 16., 4.);
    ("Lima", -22., -6.);
    ("Montreal", -18., 8.);
    ("Dublin", -4., 6.);
    ("CapeTown", 10., -14.);
    ("Reunion", 4., -16.);
]

let rec monde_aleatoire n =
  if n = 0
  then []
  else ("City", 1.0, 2.0)::(monde_aleatoire (n - 1))

let s = Sys.time()
let monde = monde_aleatoire 1000
let e = Sys.time()
let _ = Printf.printf "Génération monde: %f\n" (e -. s)

let s = Sys.time()
let monde = Carte.make_carte_from_cities monde
let e = Sys.time()
let _ = Printf.printf "Construction carte: %f\n" (e -. s)

let rec test_n_fois f n = 
    if n = 0 then () else
        let _ = f n monde in
        test_n_fois f (n-1)

let _ =
  let s = Sys.time() in
  let _ = Optimizer.find_solution_nearest monde in
  let e = Sys.time() in
  Printf.printf "Optimization nearest: %f\n" (e -. s)

let _ =
  let s = Sys.time() in
  let _ = Optimizer.find_solution_random monde in
  let e = Sys.time() in
  Printf.printf "Optimization random: %f\n" (e -. s)