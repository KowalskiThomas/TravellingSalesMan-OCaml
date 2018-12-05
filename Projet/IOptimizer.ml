module Optimizer = struct
    module MLLPath = IMLLPath.MLLPath
    module Carte = ICarte.CompleteCarte
    type mins_list = (Carte.node * (MLLPath.path_entry * float) option) list

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
        let rec aux l = match l with
        | [] -> []
        | (u, None)::t -> 
            let dist_new = Carte.distance u new_city carte in 
            if dist_new < infinity
            then (u, Some(new_element, dist_new))::(aux t)
            else (u, None)::(aux t)
        | (u, Some(current_closest, dist))::t -> 
            (* On calcule la distance entre u et le nouvel élément du chemin,
                Si elle est inférieure à la distance minimale actuelle, on change l'élément le plus proche. *)
            let dist_new = Carte.distance u new_city carte in 
            if dist_new < dist 
            then (u, Some(new_element, dist_new))::(aux t)
            else (u, Some(current_closest, dist))::(aux t)
        in aux l

    let rec find_optimal_aux f 
        (l : (Carte.node * (MLLPath.path_entry * float) option) list) : 
        (Carte.node * (MLLPath.path_entry * float) option) * (Carte.node * (MLLPath.path_entry * float) option) list = 
        match l with
        | [] -> failwith "find_optimal: empty list"
        | [elt] -> elt, []
        | (u, None)::t ->
            let best_next, l' = find_optimal_aux f t in 
            best_next, (u, None)::l'
        | (u, Some(closest_u, dist))::t -> 
            let closest_next, l' = find_optimal_aux f t in 
            match closest_next with
            | (next, None) -> (u, Some(closest_u, dist)), (next, None)::l'
            | (next, Some(closest_next, dist_next)) ->
                if f dist_next dist 
                then (next, Some(closest_next, dist_next)), (u, Some(closest_u, dist))::l'
                else (u, Some(closest_u, dist)), (next, Some(closest_next, dist_next))::l'

    let find_optimal f l = 
        let result_aux = find_optimal_aux f l in 
        match result_aux with
        | (u, None), l' -> None, l'
        | (u, Some(closest_u, dist)), l' -> Some(u, closest_u, dist), l'
    
    let find_nearest = find_optimal (fun x y -> x < y)
    let find_farthest = find_optimal (fun x y -> x > y)
    
    let rec print_mins_list l = match l with
    | [] -> ()
    | (idx, None)::t -> 
        let _ = Printf.printf "%d [None]\n" idx in
        print_mins_list t 
    | (idx, Some((closest_city, closest_uid), dist))::t -> 
        let _ = Printf.printf "%d (%d, %d) (%f)\n" idx closest_city closest_uid dist in
        print_mins_list t

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
            (* 1205 *)
            (* let _ = Printf.printf "Current is %d %d\n" current_city current_idx in 
            let _ = Printf.printf "Next is    %d %d\n" next_city next_idx in  *)
            (* Compute the distance between current path entry and out-of-path node *)
            let current_distance = Carte.distance current_city city carte in
            (* Stop condition *)
            let current_result = 
                if current_distance = infinity 
                then 
                    (* let _ = Printf.printf "Result from %d to (%d, %d) is inf\n" city current_city current_idx in  *)
                    None
                else 
                    (* let _ = Printf.printf "Result from %d to (%d, %d) is %f\n" city current_city current_idx current_distance in *)
                    Some(current, current_distance) 
            in
            if next = initial
            then
                (* let _ = Printf.printf "(%d, %d) is initial, exiting.\n" next_city next_idx in  *)
                current_result
            else 
                (* Compare this distance with the distance computed by calling recursively on the end of the path *)
                let next_result = find_closest_in_path next city in
                match next_result with
                | None -> current_result
                | Some(closest_next, distance_next) -> 
                    if current_result = None 
                    then next_result
                    else if distance_next < current_distance 
                    then next_result
                    else current_result
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
                (* 1205 *)
                (* let _ = Printf.printf "Finding closest to %d\n" idx in  *)
                (* Otherwise, find the closest in path *)
                let closest = find_closest_in_path initial idx in 
                (idx, closest)::(construct_list_from_bindings t)
                (* match closest with
                | None -> failwith "construct_list_from_bindings: No node accessible."
                | Some(closest, dist) -> 
                    let cc, ci = closest in 
                    let _ = Printf.printf "Closest to %d: (%d, %d)\n" idx cc ci in  *)
                    (* And cons it to the recursive call *)
        in 
        (* Call the aux function *)
        construct_list_from_bindings (Carte.bindings carte)

    let rec build_solution 
        (finder : (Carte.node * (MLLPath.path_entry * float) option) list ->
        (MLLPath.node * MLLPath.path_entry * 'a) option *
        (Carte.node * (MLLPath.path_entry * float) option) list) 
        carte initial_path = 
        (* Construction de la liste initiale des villes les plus proches *)
        let initial_mins_list = build_initial_mins_list carte initial_path in 
        (* let _ = print_mins_list initial_mins_list in  *)
        (* Construit un chemin à partir d'un chemin initial p en utilisant la liste des noeuds les plus proches *)
        let rec build_path l p = 
            (* On trouve l'élément qui maximise la distance minimale au chemin *)
            (* 
                new_element -> le noeud à ajouter
                closest_in_path -> à côté de quel élément l'ajouter (None ou Some(path_entry * float))
                l' -> la liste des mins sans new_element
            *)
            let new_element_option, l' = finder l in
            (* On l'insère après closest_in_path pour minimiser la distance totale *)
            let new_entry, p' = match new_element_option with
            | None -> failwith "Nothing to add"
            | Some(new_element, closest_in_path, dist) -> 
                (* 1205 *)
                (* let _ = print_mins_list l in  *)
                (* let _ = Printf.printf "Inserting %d\n" new_element in  *)
                MLLPath.insert_in_path new_element closest_in_path p carte 
            in 
            (* let _ = MLLPath.print p' in  *)
            let l'' = match new_element_option with
            | None -> failwith "Nothing to add"
            | Some(new_element, closest_in_path, dist) -> rebuild_mins_list l' new_entry carte
            in
            (* let _ = print_mins_list l' in   *)
            (* let _ = Printf.printf "New distance: %f\n" (Carte.distance_path (MLLPath.cities_list p') carte) in  *)
            (* let _ = Printf.printf "\n" in  *)
            match l' with
            | [] -> p'
            | l' -> build_path l'' p'
        
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

        (* let s = Sys.time() in
        let solution = inversion_n_fois solution 200 carte in
        let e = Sys.time() in *)
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