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

    let rec build_solution_aux carte initial_path initial_mins_list =
        (* Vérifie que la liste des noeuds les plus proches est toujours valable (et la modifie au besoin) *)
        let rec rebuild_mins_list l new_element = match l with
        | [] -> []
        | (u, current_closest, dist)::t -> 
            (* On calcule la distance entre u et le nouvel élément du chemin,
               Si elle est inférieure à la distance minimale actuelle, on change l'élément le plus proche. *)
            let dist_new = Carte.distance u new_element carte in 
            if dist_new < dist 
            then (u, new_element, dist_new)::(rebuild_mins_list t new_element)
            else (u, current_closest, dist)::(rebuild_mins_list t new_element)
        in
        (* Construit un chemin à partir d'un chemin initial p en utilisant la liste des noeuds les plus proches *)
        let rec build_path l p = 
            match l with
            | [] -> p
            | (u, closest_u, dist)::t ->
                (* On insère u dans le chemin, avant ou après closest_u (en fonction d'où ça donne le chemin le plus court) *)
                let p' = MLLPath.insert_before_or_after u closest_u p carte in 
                (* On a inséré u dans le chemin, on vérifie qu'il n'est pas devenu le plus proche dans le chemin d'un noeud hors chemin *)
                let l' = rebuild_mins_list t u in 
                build_path l' p'
        in 
        build_path initial_mins_list initial_path
    
    let build_initial_mins_list carte initial = 
        let xi, yi = Carte.get_coordinates initial carte in 
        let rec aux l = match l with
        | [] -> []
        | (idx, (_, (x, y)))::t -> 
            if idx = initial 
            then aux t
            else
                let dist = Carte.distance_from_coordinates xi yi x y in 
                (idx, initial, dist)::(aux t)
        in 
        aux (Carte.bindings carte)

    let build_solution inserter carte initial =
        build_solution_aux
            carte
            (MLLPath.make initial)
            (build_initial_mins_list carte initial)

    let rec build_solution_nearest = build_solution MLLPath.insert_nearest_minimize_length
    let rec build_solution_farthest = build_solution MLLPath.insert_farthest_minimize_length
    let rec build_solution_random = build_solution MLLPath.insert_random_minimize

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
        let l = MLLPath.to_list solution in 
        let dist = Carte.distance_path l carte in 
        let _ = Printf.printf "Distance: %f\n" dist in 
        (* let _ = Printf.printf "After: " in  *)
        (* let _ = MLLPath.print_with_names solution carte in  *)
        solution

    let find_solution_nearest = find_solution build_solution_nearest
    let find_solution_random = find_solution build_solution_random
end