module MLLPath = IMLLPath.MLLPath
module Carte = ICarte.CompleteCarte
module Optimizer = IOptimizer.Optimizer

let _ = Printf.printf "Tests insertion optimale\n"

let test_insert_minimize =
    let cities = [
        ("Londres", 0.0, 0.0);
        ("Paris", 2.0, 0.0);
        ("Helsinki", 4.0, 0.0);
        ("Budapest", 6.0, 1.0);
        ("Berlin", 1.0, 0.0)
    ] in

    let carte = Carte.make_carte_from_cities cities in
    let u0, chemin = MLLPath.make 0 in
    let u1, chemin = MLLPath.insert 1 u0 chemin in 
    let u2, chemin = MLLPath.insert 2 u1 chemin in 
    let u3, chemin = MLLPath.insert 3 u2 chemin in 
    
    let _ = Printf.printf "Chemin initial: " in
    let _ = MLLPath.print chemin in

    let length = MLLPath.length chemin carte in
    let _ = Printf.printf "Longueur chemin initial : %f\n" length in

    let u4, chemin_avec_3 = MLLPath.insert_minimize_length 4 chemin carte  in

    let _ = MLLPath.print chemin_avec_3 in

    let length = MLLPath.length chemin_avec_3 carte in
    let _ = Printf.printf "Longueur chemin modifié : %f\n" length
    in ()

let _ = 
    let cities = [
        ("0", 0.0, 0.0);
        ("1", 1.0, 1.0);
        ("2", 2.0, 1.0);
        ("3", 3.0, 0.0);
        ("4", 2.0, -1.0);
        ("5", -1.0, -1.0)
    ] in

    let br1 = (0, 1) in 
    let br5 = (0, 5) in
    
    let carte = Carte.make_carte_from_cities cities in
    let carte = Carte.add_broken_road br1 carte in 
    let carte = Carte.add_broken_road br5 carte in 

    let chemin = Optimizer.find_solution_nearest carte in 
    
    MLLPath.print chemin 