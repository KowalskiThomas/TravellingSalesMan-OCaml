module MLLPath = IMLLPath.MLLPath
module Carte = ICarte.CompleteCarte

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
        let chemin = MLLPath.insert 3 2 (MLLPath.insert 2 1 (MLLPath.insert 1 0 (MLLPath.make 0))) in

        let _ = Printf.printf "Chemin initial: " in 
        let _ = MLLPath.print chemin in 

        let length = MLLPath.length chemin carte in 
        let _ = Printf.printf "Longueur chemin initial : %f\n" length in

        let chemin_avec_3 = MLLPath.insert_minimize_length 4 chemin carte  in 

        let _ = MLLPath.print chemin_avec_3 in 

        let length = MLLPath.length chemin_avec_3 carte in 
        let _ = Printf.printf "Longueur chemin modifié : %f\n" length 
        in ()

let test_nearest_farthest = 
        let cities = [
                ("Paris", 1.0, 0.0);
                ("Londres", 2.0, 0.0);
                ("NearestFromParis", 1.0, 2.0);
                ("FarthestFromParis", 1.0, 3.0)
        ] in

        let cities = Carte.make_carte_from_cities cities in 
        let chemin = MLLPath.insert 0 1 (MLLPath.make 1) in

        let idx = 0 in 
        let nearest, distance_n = Carte.find_nearest idx (MLLPath.to_set chemin) cities in 
        let farthest, distance_f = Carte.find_farthest idx (MLLPath.to_set chemin) cities in 
        let name_idx, (_, _) = Carte.find idx cities in 
        let name_nearest, (_, _) = Carte.find nearest cities in 
        let name_farthest, (_, _) = Carte.find farthest cities in 
        let _ = Printf.printf "Nearest from %s : %s (dist = %f)\n" name_idx name_nearest distance_n in 
        let _ = Printf.printf "Farthest from %s : %s (dist = %f)\n" name_idx name_farthest distance_f in ()

let test_insert_nearest = 
    let cities = [
            ("Paris", 1., 1.);
            ("Londres", 5., 2.);
            ("Berlin", 10., 3.);
            ("Nearest", 7., 2.);
            ("Mid", 2., 4.);
            ("Budapest", 9., 6.);
            ("Farthest", 4., -2.);
    ] in
    let carte = Carte.make_carte_from_cities cities in 
    (* On créé un chemin Paris -> Londres -> Berlin *)
    let chemin = MLLPath.insert 5 2 (MLLPath.insert 2 1 (MLLPath.insert 1 0 (MLLPath.make 0))) in
    (* On ajoute au chemin le point le plus proche en minimisant la distance totale *)
    let chemin_avec_plus_proche = MLLPath.insert_nearest_minimize_length chemin carte in
    (* On affiche le chemin. Normalement, ça donne Paris -> Londres -> Nearest -> Berlin -> Budapest *)
    MLLPath.print_with_names chemin_avec_plus_proche carte