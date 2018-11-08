module MLLPath = IMLLPath.MLLPath
module Carte = ICarte.CompleteCarte
module Optimizer = IOptimizer.Optimizer

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

let monde = Carte.make_carte_from_cities monde
let solution = Optimizer.find_solution_nearest monde 
let _ = MLLPath.print_with_names solution monde 