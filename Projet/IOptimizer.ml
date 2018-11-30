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
    let repositionnement_noeud u p c = p (* TODO FIX IT *)
        (* if MLLPath.cardinal p <= 3
        then p
        else
            let _, chemin = MLLPath.insert_minimize_length u (MLLPath.remove u p) c
            in chemin *)

    let inversion_locale a path carte =
        (* From ... -> A -> B -> C -> D -> ... *)
        (* To   ... -> A -> C -> B -> D -> ... *)
        let (ca, ia) = a in 
        let (cb, ib) as b = MLLPath.get_next a path in
        let (cc, ic) as c = MLLPath.get_next b path in
        let (cd, id) as d = MLLPath.get_next c path in
        (* let _ = Printf.printf "%d %d %d %d\n" a b c d in  *)
        let swapped = MLLPath.swap b c path in
        let distance_before = Carte.distance ca cb carte +. Carte.distance cb cc carte +. Carte.distance cc cd carte in
        let distance_after = Carte.distance ca cc carte +. Carte.distance cc cb carte +. Carte.distance cb cd carte in
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
            let entry = MLLPath.get_random solution in
            let swapped = inversion_locale entry solution c in
            inversion_n_fois swapped (n - 1) c

    let rebuild_mins_list l new_element carte = 
        let new_city, new_index = new_element in 
        let rec aux l new_element = match l with
        | [] -> []
        | (u, current_closest, dist)::t -> 
            (* On calcule la distance entre u et le nouvel élément du chemin,
                Si elle est inférieure à la distance minimale actuelle, on change l'élément le plus proche. *)
            let dist_new = Carte.distance u new_city carte in 
            if dist_new < dist 
            then (u, new_element, dist_new)::(aux t new_element)
            else (u, current_closest, dist)::(aux t new_element)
        in aux l new_element

    let rec find_optimal f l = 
        let rec aux l = match l with
        | [] -> failwith "find_optimal: empty list"
        | [(u, closest_u, dist)] -> u, closest_u, dist, []
        | (u, closest_u, dist)::t -> 
            let best_u, best_closest, best_dist, l' = aux t in 
            if f best_dist dist 
            then best_u, best_closest, best_dist, (u, closest_u, dist)::l'
            else u, closest_u, dist, (best_u, best_closest, best_dist)::l'
        in aux l
    
    let find_nearest = find_optimal (fun x y -> x < y)
    let find_farthest = find_optimal (fun x y -> x > y)
    
    (* 
        Builds a list of the following form for cities that aren't in the path:
        [(first_city_out_of_path, closest_city_in_path, distance), (second_city_out_of_path, ...), ...]
    *)
    let build_initial_mins_list carte path = 
        (* Get the first city of the path. We need that since we're cycling in it. *)
        let (initial_city, initial_idx) as initial = MLLPath.get_first path in 
        (* Construct a set with all the cities in the path (in order to skip cities from the Carte that already are in the path *)
        let cities_set = MLLPath.cities_set path in 
        (* If x is not in path, then find the closest city to x in the path. *)
        let rec find_closest_in_path current city = 
            (* Get next city in the path (it's our stop condition) *)
            let (next_city, next_idx) as next = MLLPath.get_next current path in
            (* Unpack our current path entry *)
            let current_city, current_idx = current in 
            (* Compute the distance between current path entry and out-of-path node *)
            let current_distance = Carte.distance current_city city carte in
            (* Stop condition *)
            if next = initial
            then current, current_distance
            else 
                (* Compare this distance with the distance computed by calling recursively on the end of the path *)
                let closest_next, distance_next = find_closest_in_path next city in
                if distance_next < current_distance 
                then current, current_distance
                else closest_next, distance_next
        in
        (* 
            The main auxiliary function. 
            Constructs the said list from the bindings of the Carte.
        *)
        let rec construct_list_from_bindings l = match l with
        | [] -> []
        | (idx, _)::t -> 
            (* The binding is in the form (city_id, (...)) but we're not interested in the rest. *)
            (* Verify if the city is already in path *)
            if Carte.NodeSet.mem idx cities_set
            (* If so, skip it *)
            then construct_list_from_bindings t
            else
                (* Otherwise, find the closest in path *)
                let closest, dist = find_closest_in_path initial idx in 
                (* And cons it to the recursive call *)
                (idx, closest, dist)::(construct_list_from_bindings t)
        in 
        (* Call the aux function *)
        construct_list_from_bindings (Carte.bindings carte)

    let rec build_solution finder carte initial_path = 
        (* Construction de la liste initiale des villes les plus proches *)
        let initial_mins_list = build_initial_mins_list carte initial_path in 
        (* Construit un chemin à partir d'un chemin initial p en utilisant la liste des noeuds les plus proches *)
        let rec build_path l p = 
            (* On trouve l'élément qui maximise la distance minimale au chemin *)
            let new_element, closest_in_path, dist, l' = finder l in
            (* On l'insère après closest_in_path pour minimiser la distance totale *)
            let (new_city, new_uid) as new_entry, p' = MLLPath.insert_before_or_after new_element closest_in_path p carte in 
            match l' with
            | [] -> p'
            | l' ->
                let l'' = rebuild_mins_list l' new_entry carte in 
                build_path l'' p'
        in build_path initial_mins_list initial_path

    let build_solution_nearest = build_solution find_nearest
    let build_solution_farthest = build_solution find_farthest

    let rec build_solution_random carte initial_path =
        let initial_set = MLLPath.cities_set initial_path in 
        let target_card = Carte.card carte in 
        let rec aux card cities_set path = 
            if card = target_card 
            then path
            else
                let new_element, _ = Carte.get_random carte cities_set in 
                let cities_set' = Carte.NodeSet.add new_element cities_set in 
                let new_elt, path' = MLLPath.insert_minimize_length new_element path carte in 
                let card' = card + 1 in 
                aux card' cities_set' path'
        in aux 1 initial_set initial_path

    let find_solution builder carte =
        let city_start, _ = Carte.get_random_any carte in
        let (city_start, idx_start), initial_path = MLLPath.make city_start in

        let _ = Printf.printf "Construction sol initiale\n" in 
        let s = Sys.time() in
        let solution = builder carte initial_path in
        let e = Sys.time() in
        let _ = Printf.printf "Temps construction sol initiale: %f\n" (e -. s) in
        (* let _ = Printf.printf "Before: " in *)
        (* let _ = MLLPath.print_with_names solution carte in  *)

        let s = Sys.time() in
        let solution = inversion_n_fois solution 200 carte in
        let e = Sys.time() in
        let _ = Printf.printf "Temps repos: %f\n" (e -. s) in
        let l = MLLPath.cities_list solution in 
        let dist = Carte.distance_path l carte in 
        let _ = Printf.printf "Distance: %f\n" dist in 
        (* let _ = Printf.printf "After: " in  *)
        (* let _ = MLLPath.print_with_names solution carte in  *)
        solution

    let find_solution_nearest = find_solution build_solution_nearest
    let find_solution_farthest = find_solution build_solution_farthest
    let find_solution_random = find_solution build_solution_random
end