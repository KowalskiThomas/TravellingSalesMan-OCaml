module MLLPath = IMLLPath.MLLPath
module Carte = ICarte.CompleteCarte

let _ = Printf.printf "Tests insertion optimale\n"

let cities = [
    ("Londres", 0.0, 0.0);
    ("Paris", 2.0, 0.0);
    ("Helsinki", 4.0, 0.0);
    ("Budapest", 6.0, 1.0);
    ("Berlin", 1.0, 0.0)
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

let _ =
    Carte.print carte

let chemin = MLLPath.insert 3 2 (MLLPath.insert 2 1 (MLLPath.insert 1 0 (MLLPath.make 0)))

let _ = 
    let _ = Printf.printf "Chemin initial: " in 
    MLLPath.print chemin

let _ = 
    let length = MLLPath.length chemin carte in 
        Printf.printf "Longueur chemin initial : %f\n" length

let chemin_avec_3 = MLLPath.insert_minimize_length 4 chemin carte 

let _ = MLLPath.print chemin_avec_3

let _ =
    let length = MLLPath.length chemin_avec_3 carte in 
        Printf.printf "Longueur chemin modifié : %f\n" length

let _ = Printf.printf "\n\n\nTests find_nearest"

let cities = [
    ("Paris", 1.0, 0.0);
    ("Londres", 2.0, 0.0);
    ("Nearest", 1.0, 2.0);
    ("Farthest", 1.0, 3.0)
]

let cities = make_carte_from_cities cities
let chemin = MLLPath.insert 0 1 (MLLPath.make 1)
(* 
let _ =
    let nearest = Carte.find_nearest 0 (MLLPath.to_set chemin) cities in 
    Printf.printf "fini\n" *)