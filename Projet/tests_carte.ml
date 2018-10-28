module Carte = ICarte.CompleteCarte

let cities = [
    ("Paris", 1.0, 0.0);
    ("Londres", 2.0, 1.0);
    ("Berlin", 2.0, 0.0);
    ("Helsinki", 3.0, 4.0)
]

let _ =
    let test = Carte.make_carte_from_cities cities
    in test

let cities_distance_1 = [
    ("Paris", 0.0, 1.0);
    ("Londres", 0.0, 2.0)
]
let test_distance_1 =
    let carte = Carte.make_carte_from_cities cities_distance_1 in
    let d = Carte.distance 0 1 carte in
    (* Expected: (2 - 1)² = 1 *)
    let test = d = 1.0 in
    if test then
        Printf.printf "OK Test Distance 1\n"
    else
        Printf.printf "XX Test Distance 1\n"

let cities_distance_2 = [
    ("Paris", 0.0, 1.0);
    ("Londres", 1.0, 0.0)
]
let test_distance_2 =
    let carte = Carte.make_carte_from_cities cities_distance_2 in
    let d = Carte.distance 0 1 carte in
    let expected = 2.0 in
    let test = d = expected in
    if test then
        Printf.printf "OK Test Distance 2\n"
    else
        Printf.printf "XX Test Distance 2 [Expected = %f, Returned = %f] \n" expected d

let cities_distance_3 = [
    ( "Paris", 2.0, 0.0);
    ("Londres", 1.0, 1.0);
    ("Berlin", 0.0, 1.0);
    ("Madrid", 0.0, 2.0)
]
let test_distance_3 =
    let carte = Carte.make_carte_from_cities cities_distance_3 in
    let distance_1 = Carte.distance 0 1 carte in
    let distance_2 = Carte.distance 1 2 carte in
    let distance_3 = Carte.distance 2 3 carte in
    let expected = distance_1 +. distance_2 +. distance_3 in
    let d = Carte.distance_path [0; 1; 2; 3] carte in
    let test = expected = d in
    if test then
        Printf.printf "OK Test Distance 3\n"
    else
        Printf.printf "XX Test Distance 3 [Expected = %f, Returned = %f] \n" expected d

(* Ajout de beaucoup de noeuds à la carte pour tester les performances de la structure de données. *)
(* TODO: Measure time *)
let test_add_many_nodes =
    let rec aux n g =
        if n = 1 then
            Carte.add_node n (string_of_int n) (float_of_int n) (float_of_int n) g
        else
            Carte.add_node n (string_of_int n) (float_of_int n) (float_of_int n) (aux (n - 1) g)
    in
    let _ = aux 150000 Carte.empty in
    Printf.printf "OK Test rapidité\n"