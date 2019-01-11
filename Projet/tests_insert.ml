module MLLPath = IMLLPath.MLLPath
module Carte = ICarte.Carte
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
    
    let carte = Carte.make_carte_from_cities cities in
    let carte = Carte.add_road 0 1 carte in 
    let carte = Carte.add_road 2 1 carte in 
    let carte = Carte.add_road 3 2 carte in 
    let carte = Carte.add_road 3 4 carte in 
    let carte = Carte.add_road 5 3 carte in 

    let chemin = Optimizer.find_solution Optimizer.random_point_initial_path Optimizer.build_solution_nearest Optimizer.inversion_n_fois carte in 
    let chemin2 = Optimizer.find_solution Optimizer.random_point_initial_path Optimizer.build_solution_farthest Optimizer.inversion_n_fois carte in 
    let chemin3 = Optimizer.find_solution Optimizer.random_point_initial_path Optimizer.build_solution_random Optimizer.inversion_n_fois carte in 

    let _ = MLLPath.print chemin in
    let _ = MLLPath.print chemin2 in
    let _ = MLLPath.print chemin3 in
    ()

let rec print_list l = match l with
    | [] -> Printf.printf "\n"
    | t::q -> 
        let _ = Printf.printf "%d " t in
        print_list q 

let test_builder = 
    let cities = [
        ("BG", 0., 0.);
        ("BD", 3., 0.); 
        ("HG", 3., 0.); 
        ("HD", 3., 3.); 
        ("T", 1.5, 5.)
    ] in
    let monde = Carte.make_carte_from_cities cities in  
    let u0, path = MLLPath.make 0 in 
    let u1, path = MLLPath.insert 1 u0 path in 
    let u2, path = MLLPath.insert 2 u1 path in 
    let u3, path = MLLPath.insert 3 u2 path in 
    let ut, path_after = MLLPath.insert_minimize_length 4 path monde in 
    let cities = MLLPath.cities_list path_after in 
    let expected = [1; 2; 3; 4; 0] in
    let test = cities = expected in 
    if test then    
        Printf.printf "OK Test insertion à la fin\n"
    else
        Printf.printf "XX Test insertion à la fin\n"
