module Carte = ICarte.Carte

let _ = Random.self_init()

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
    let expected = 1.0 in 
    let test = d = expected in
    if test then
        Printf.printf "OK Test Distance 1\n"
    else
        Printf.printf "XX Test Distance 1 [Expected = %f, Returned = %f]\n" expected d

let cities_distance_2 = [
    ("Paris", 0.0, 1.0);
    ("Londres", 1.0, 0.0)
]
let test_distance_2 =
    let carte = Carte.make_carte_from_cities cities_distance_2 in
    let d = Carte.distance 0 1 carte in
    let expected = 2.0  ** (1. /. 2.) in
    let test = d = expected in
    if test then
        Printf.printf "OK Test Distance 2\n"
    else
        Printf.printf "XX Test Distance 2 [Expected = %f, Returned = %f]\n" expected d

let cities_distance_3 = [
    ("Paris", 2.0, 0.0);
    ("Londres", 1.0, 1.0);
    ("Berlin", 0.0, 1.0);
    ("Madrid", 0.0, 2.0)
]
let test_distance_3 =
    let carte = Carte.make_carte_from_cities cities_distance_3 in
    let distance_1 = Carte.distance 0 1 carte in
    let distance_2 = Carte.distance 1 2 carte in
    let distance_3 = Carte.distance 2 3 carte in
    let distance_4 = Carte.distance 3 0 carte in 
    let expected = distance_1 +. distance_2 +. distance_3 +. distance_4 in
    let d = Carte.distance_path [0; 1; 2; 3] carte in
    let test = (expected -. d) < 0.001 in
    if test then
        Printf.printf "OK Test Distance 3\n"
    else
        let _ = Printf.printf "XX Test Distance 3 [Expected = %f, Returned = %f] \n" expected d in
        exit 1

(* Ajout de beaucoup de noeuds à la carte pour tester les performances de la structure de données. *)
let test_add_many_nodes =
    let rec aux n g =
        if n = 1 then
            Carte.add_node n (string_of_int n) (Random.float 100.) (Random.float 100.) g
        else
            Carte.add_node n (string_of_int n) (Random.float 100.) (Random.float 100.) (aux (n - 1) g)
    in
    let _ = aux 150000 Carte.empty in
    Printf.printf "OK Test rapidité\n"

let test_add_many_many_nodes =
    let rec aux n =
        if n = 0 then ()
        else let _ = test_add_many_nodes in aux (n - 1)
    in
    let it = 100000000 in
    let b = Sys.time() in
    let _ = aux it in
    let e = Sys.time() in
    Printf.printf "Temps pour %d fois 150000 insertions: %fs\n" it (e -. b)

let cities_distance_3 = [
    ("Paris", 2.0, 0.0);
    ("Londres", 1.0, 1.0);
    ("Berlin", 0.0, 1.0);
    ("Madrid", 0.0, 2.0)
]

let cities = [
    ("A", 0., 0.);
    ("B", 1., 0.);
    ("C", 2., 0.);
    ("D", 2., 1.);
    ("E", 1., 1.);
    ("F", 0., 1.);
]
let monde = Carte.make_carte_from_cities cities 

let test_distance_empty = 
    let liste = [0] in 
    let dist = Carte.distance_path liste monde in 
    let test = dist = 0. in 
    if test then 
        Printf.printf "OK Test Empty Path\n"
    else
        let _ = Printf.printf "XX Test Empty Path\n" in 
        exit 1

let test_distance_one = 
    let liste = [0] in 
    let dist = Carte.distance_path liste monde in 
    let test = dist = 0. in 
    if test then 
        Printf.printf "OK Test Unary Path\n"
    else
        let _ = Printf.printf "XX Test Unary Path\n" in 
        exit 1

let test_distance_two = 
    let liste = [0; 1] in 
    let dist = Carte.distance_path liste monde in 
    let test = dist = 2. in 
    if test then 
        Printf.printf "OK Test Binary Path\n"
    else
        let _ = Printf.printf "XX Test Binary Path\n" in 
        exit 1

let test_distance_three = 
    let liste = [0; 1; 4] in 
    let dist = Carte.distance_path liste monde in 
    let test = dist = 2. +. (2. ** (1. /. 2.)) in 
    if test then 
        Printf.printf "OK Test 3-Path\n"
    else
        let _ = Printf.printf "XX Test 3-Path\n" in 
        let _ = Printf.printf "%f\n" dist in 
        exit 1

let test_distance_six = 
    let liste = [0; 1; 2; 3; 4; 5] in 
    let dist = Carte.distance_path liste monde in 
    let test = dist = 6. in 
    if test then 
        Printf.printf "OK Test 6-Path\n"
    else
        let _ = Printf.printf "XX Test 6-Path\n" in 
        exit 1