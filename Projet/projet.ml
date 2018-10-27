module MLLPath = IMLLPath.MLLPath
module Carte = ICarte.CompleteCarte

let cities = [
    (0, "Paris", 1.0, 0.0);
    (1, "Londres", 2.0, 1.0);
    (2, "Berlin", 2.0, 0.0);
    (3, "Helsinki", 3.0, 4.0);
    (5, "Saint Denis", 3.0, 4.5)
]

let rec add_cities villes carte =
    match villes with
    | [] -> carte
    | (i, n, x, y)::t -> Carte.add_node i n x y (add_cities t carte)

let test = add_cities cities Carte.empty

let path = MLLPath.make 0

(*
Algorithme ajout du point au meilleur endroit, étant donné
cities CompleteCarte
path   MLLPath
city   int

*)