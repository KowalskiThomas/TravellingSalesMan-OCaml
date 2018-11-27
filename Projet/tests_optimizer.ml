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
    let chemin = MLLPath.insert 3 2 (MLLPath.insert 2 1 (MLLPath.insert 1 0 (MLLPath.make 0))) in

    let chemin_avec_inversion_en_a = Optimizer.inversion_locale 0 chemin carte in

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
    let chemin = MLLPath.insert 3 2 (MLLPath.insert 2 1 (MLLPath.insert 1 0 (MLLPath.make 0))) in

    let chemin_avec_inversion_en_a = Optimizer.inversion_locale 0 chemin carte in

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
    let chemin = MLLPath.insert 3 2 (MLLPath.insert 2 1 (MLLPath.insert 1 0 (MLLPath.make 0))) in

    let chemin_avec_repositionnement = Optimizer.repositionnement_noeud 2 chemin carte in

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