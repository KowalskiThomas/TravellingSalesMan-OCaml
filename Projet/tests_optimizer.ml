module Optimizer = IOptimizer.Optimizer
module MLLPath = IMLLPath.MLLPath
module Carte = ICarte.CompleteCarte

let _ = Printf.printf "Tests Optimizer\n"

let test_inversion_locale =
    let cities = [
        ("A", 0.0, 0.0);
        ("B", 2.0, 2.0);
        ("C", 1.0, 0.0);
        ("D", 4.0, 2.0)
    ] in

    let carte = Carte.make_carte_from_cities cities in
    let u0, chemin = MLLPath.make 0 in 
    let u1, chemin = MLLPath.insert 1 u0 chemin in 
    let u2, chemin = MLLPath.insert 2 u1 chemin in 
    let u3, chemin = MLLPath.insert 3 u2 chemin in 

    let chemin_avec_inversion_en_a = Optimizer.inversion_locale u0 chemin carte in

    let _ = Printf.printf "Test inversion (avec inversion conservée).\n" in
    let _ = MLLPath.print_with_names chemin carte in
    let _ = Printf.printf "Expected: A C B D.\n" in
    let _ = MLLPath.print_with_names chemin_avec_inversion_en_a carte

    in ()

let test_inversion_locale_2 =
    let cities = [
        ("A", 0.0, 0.0);
        ("B", 1.0, 0.0);
        ("C", 2.0, 2.0);
        ("D", 4.0, 2.0)
    ] in

    let carte = Carte.make_carte_from_cities cities in
    let u0, chemin = MLLPath.make 0 in 
    let u1, chemin = MLLPath.insert 1 u0 chemin in 
    let u2, chemin = MLLPath.insert 2 u1 chemin in 
    let u3, chemin = MLLPath.insert 3 u2 chemin in 

    let chemin_avec_inversion_en_a = Optimizer.inversion_locale u0 chemin carte in

    let _ = Printf.printf "Test inversion (avec inversion annulée).\n" in
    let _ = Printf.printf "Expected: A B C D.\n" in
    (* Expected: A B C D *)
    let _ = MLLPath.print_with_names chemin_avec_inversion_en_a carte

    in ()

let test_repositionnement =
    let cities = [
        ("A", 0.0, 0.0); (* 0 *)
        ("B", 6.0, 5.0); (* 1 *)
        ("C", 3.0, 0.0); (* 2 *)
        ("D", 4.0, 2.0)  (* 3 *)
    ] in

    let carte = Carte.make_carte_from_cities cities in
    let u0, chemin = MLLPath.make 0 in 
    let u1, chemin = MLLPath.insert 1 u0 chemin in 
    let u2, chemin = MLLPath.insert 2 u1 chemin in 
    let u3, chemin = MLLPath.insert 3 u2 chemin in 

    let chemin_avec_repositionnement = Optimizer.repositionnement_noeud u2 chemin carte in

    let _ = Printf.printf "Test repositionnement.\n" in
    let _ = Printf.printf "Expected: A B D C.\n" in
    (* Expected: A B D C *)
    let _ = MLLPath.print_with_names chemin_avec_repositionnement carte

    in ()

let test_monde_simple = 
    let monde_simple = Carte.make_carte_from_cities [
        ("A", 0., 0.);
        ("B", 2., 0.);
        ("C", 3., 0.);
        ("D", 1.3, 2.)
    ] in 
    let _ =
        let s = Sys.time() in
        let _ = Optimizer.find_solution_nearest monde_simple in
        let e = Sys.time() in
        Printf.printf "Optimization nearest: %f\n" (e -. s)
    in ()

let test_repos_avec_br = 
    let p0 = ("P0", 0., 0.) in
    let p1 = ("P1", 0., 1.) in
    let p2 = ("P2", 0., 2.) in
    let p3 = ("P3", 0., 3.) in
    let monde = Carte.make_carte_from_cities [
        p0;
        p1;
        p2;
        p3
    ] in 
    let br = (0, 1) in 
    let monde = Carte.add_broken_road br monde in 
    
    let u0, p = MLLPath.make 0 in 
    let u2, p = MLLPath.insert 2 u0 p in 
    let u1, p = MLLPath.insert 1 u2 p in 
    let u3, p = MLLPath.insert 3 u1 p in 

    let p' = Optimizer.repositionnement_noeud u1 p monde in 

    let _ = Printf.printf "Test repositionnement avec broken road\n" in 
    let _ = Printf.printf "Expected: before = after\n" in 
    let _ = MLLPath.print p in 
    let _ = MLLPath.print p' in 
    ()

let test_repos_sans_br = 
    let p0 = ("P0", 0., 0.) in
    let p1 = ("P1", 0., 1.) in
    let p2 = ("P2", 0., 2.) in
    let p3 = ("P3", 0., 3.) in
    let monde = Carte.make_carte_from_cities [
        p0;
        p1;
        p2;
        p3
    ] in 
    
    let u0, p = MLLPath.make 0 in 
    let u2, p = MLLPath.insert 2 u0 p in 
    let u1, p = MLLPath.insert 1 u2 p in 
    let u3, p = MLLPath.insert 3 u1 p in 

    let p' = Optimizer.repositionnement_noeud u1 p monde in 

    let _ = Printf.printf "Tests Repositionnement (expected vs result)\n" in 
    let _ = Printf.printf "(0, _) (1, _) (2, _) (3, _)\n" in 
    let _ = MLLPath.print p' in
    exit 1