module Optimizer = struct
    module MLLPath = IMLLPath.MLLPath
    module Carte = ICarte.CompleteCarte

    (*
      Cas card <= 3:
      - Si il n'y a qu'une ville, on ne peut tout simplement pas faire de repositionnement
      - S'il y a deux villes, on obtient le même résultat en repositionnant
      - S'il y a trois villes aussi, puisque c'est "un triangle"
      Sinon, on retire u du chemin et on le rajoute en minimisant la distance totale.
    *)
    let repositionnement_noeud u p c =
        if MLLPath.cardinal p <= 3
        then p
        else
            MLLPath.insert_minimize_length u (MLLPath.remove u p) c

    let inversion_locale a path carte =
        (* From ... -> A -> B -> C -> D -> ... *)
        (* To   ... -> A -> C -> B -> D -> ... *)
        let b = MLLPath.get_next a path in
        let c = MLLPath.get_next b path in
        let d = MLLPath.get_next c path in
        (* let _ = Printf.printf "%d %d %d %d\n" a b c d in  *)
        let swapped = MLLPath.swap b c path in
        let distance_before = Carte.distance a b carte +. Carte.distance b c carte +. Carte.distance c d carte in
        let distance_after = Carte.distance a c carte +. Carte.distance c b carte +. Carte.distance b d carte in
        if distance_after < distance_before
        then
            (* let _ = Printf.printf "S A: %f B: %f\n" distance_after distance_before in  *)
            swapped
        else
            (* let _ = Printf.printf "N A: %f B: %f\n" distance_after distance_before in  *)
            path

    let rec inversion_n_fois solution n c =
        if n = 0
        then solution
        else
            let city, _ = Carte.get_random_any c in
            let swapped = inversion_locale city solution c in
            inversion_n_fois swapped (n - 1) c

    let rec build_solution_aux inserter carte count max_cities path cities_list cities_set =
        if count = max_cities
        then path
        else
            let new_element, new_path = inserter path carte cities_list cities_set in
            let new_cities_set = Carte.NodeSet.add new_element cities_set in
            let new_cities_list = new_element::cities_list in
            build_solution_aux inserter carte (count + 1) max_cities new_path new_cities_list new_cities_set

    let build_solution inserter carte initial =
        let max_cities = Carte.card carte in
        let count = 1 in
        build_solution_aux
            inserter
            carte
            count
            max_cities
            (MLLPath.make initial)
            [initial]
            (Carte.NodeSet.add initial Carte.NodeSet.empty)


    let rec build_solution_nearest = build_solution MLLPath.insert_nearest_minimize_length
    let rec build_solution_random = build_solution MLLPath.insert_random_minimize
    (* let rec build_solution_farthest = build_solution MLLPath.insert_nearest_minimize_length *)

    let find_solution builder carte =
        let idx_start, _ = Carte.get_random_any carte in

        let s = Sys.time() in
        let solution = builder carte idx_start in
        let e = Sys.time() in
        let _ = Printf.printf "Temps construction sol initiale: %f\n" (e -. s) in
        (* let _ = Printf.printf "Before: " in *)
        (* let _ = MLLPath.print_with_names solution carte in  *)

        let s = Sys.time() in
        let solution = inversion_n_fois solution 200 carte in
        let e = Sys.time() in
        let _ = Printf.printf "Temps repos: %f\n" (e -. s) in
        (* let _ = Printf.printf "After: " in  *)
        (* let _ = MLLPath.print_with_names solution carte in  *)
        solution

    let find_solution_nearest = find_solution build_solution_nearest
    let find_solution_random = find_solution build_solution_random
end