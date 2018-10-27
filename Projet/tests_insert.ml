module MLLPath = IMLLPath.MLLPath
module Carte = ICarte.CompleteCarte

let _ = Printf.printf "Tests insertion optimale\n"

let cities = [
    ("Paris", 1.0, 0.0);
    ("Londres", 2.0, 1.0);
    ("Helsinki", 3.0, 4.0);
    ("Berlin", 2.0, 0.0)
]

let add_cities villes carte =
    let rec aux i villes carte = 
        match villes with
        | [] -> carte
        | (n, x, y)::t -> Carte.add_node i n x y (aux (i + 1) t carte)
    in aux 0 villes carte

let make_carte_from_cities cities = 
    add_cities cities Carte.empty

let carte = make_carte_from_cities cities
let chemin = MLLPath.insert 2 1 (MLLPath.insert 1 0 (MLLPath.make 0))

let _ = 
    let length = MLLPath.length 0 chemin carte in 
        Printf.printf "Longueur chemin initial : %f\n" length

let chemin_avec_3 = MLLPath.insert_minimize_length 1 3 chemin carte 

let _ =
    let length = MLLPath.length 0 chemin_avec_3 carte in 
        Printf.printf "Longueur chemin modifié : %f\n" length
