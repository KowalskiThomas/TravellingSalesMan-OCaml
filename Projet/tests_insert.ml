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

let carte = Carte.make_carte_from_cities cities

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

let _ = Printf.printf "\n\nTests find_nearest\n"

let cities = [
    ("Paris", 1.0, 0.0);
    ("Londres", 2.0, 0.0);
    ("NearestFromParis", 1.0, 2.0);
    ("FarthestFromParis", 1.0, 3.0)
]

let cities = Carte.make_carte_from_cities cities
let chemin = MLLPath.insert 0 1 (MLLPath.make 1)

let _ =
    let idx = 0 in 
    let nearest, distance_n = Carte.find_nearest idx (MLLPath.to_set chemin) cities in 
    let farthest, distance_f = Carte.find_farthest idx (MLLPath.to_set chemin) cities in 
    let name_idx, (_, _) = Carte.find idx cities in 
    let name_nearest, (_, _) = Carte.find nearest cities in 
    let name_farthest, (_, _) = Carte.find farthest cities in 
    let _ = Printf.printf "Nearest from %s : %s (dist = %f)\n" name_idx name_nearest distance_n in 
    let _ = Printf.printf "Farthest from %s : %s (dist = %f)\n" name_idx name_farthest distance_f in ()

let _ = 
    let _ = Printf.printf "Inserting nearest in following path: " in 
    let _ = MLLPath.print chemin in 
    let chemin_avec_plus_proche = MLLPath.insert_nearest_minimize_length chemin cities in 
    let _ = MLLPath.print chemin_avec_plus_proche in ()