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

let rec test_n_fois n = 
    if n = 0 then () else
        let monde = Carte.make_carte_from_cities monde in
        
        let solution_nearest = Optimizer.find_solution_nearest monde in
        let _ = MLLPath.print_with_names solution_nearest monde in

        let solution_random = Optimizer.find_solution_random monde in
        let _ = MLLPath.print_with_names solution_random monde 

        in test_n_fois (n-1)

let _ = test_n_fois 100000