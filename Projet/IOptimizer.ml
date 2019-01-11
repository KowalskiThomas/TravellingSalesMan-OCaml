module Optimizer = struct
    module MLLPath = IMLLPath.MLLPath
    module Carte = ICarte.Carte
    module Hull = IHull.ConvexHull
    type mins_list = (Carte.node * (MLLPath.path_entry * float) option) list
    type builder = Carte.carte -> MLLPath.path -> MLLPath.path
    type initial_path_builder = Carte.carte -> MLLPath.path
    type optimizer = MLLPath.path -> 
    int -> (* Le nombre de fois à appliquer *)
    Carte.carte -> 
    MLLPath.path

    let n_opt = 5000

    (*
      Cas card <= 3:
      - Si il n'y a qu'une ville, on ne peut tout simplement pas faire de repositionnement
      - S'il y a deux villes, on obtient le même résultat en repositionnant
      - S'il y a trois villes aussi, puisque c'est "un triangle"
      Sinon, si on a x -> u -> y, alors 
      - On vérifie que la route de x vers y existe (sinon on renvoie le chemin initial)
      - On retire u de p 
      - On réinsère u dans p 
    *)
    let repositionnement_noeud u p c = 
        let d_before = Carte.distance_path (MLLPath.cities_list p) c in 
        if MLLPath.cardinal p <= 3
        then p
        else
            let city_prev, _ = MLLPath.get_last u p in 
            let city_next, _ = MLLPath.get_next u p in 
            if Carte.mem_broken_road (city_prev, city_next) c
            then p
            else
                let city, idx = u in
                let solution_without_u = MLLPath.remove u p in 
                let _, chemin = MLLPath.insert_minimize_length city solution_without_u c in
                let d_after = Carte.distance_path (MLLPath.cities_list chemin) c in 
                let _ = assert (d_after <= d_before)
                in
                chemin

    let rec repositionnement_n_fois solution n carte =
        if n = 0
        then solution
        else
            let entry = MLLPath.get_random solution in
            let new_solution = repositionnement_noeud entry solution carte in
            repositionnement_n_fois new_solution (n - 1) carte
            
    let inversion_locale a c path carte =
        (* From ... -> A -> B -> ... -> C -> D -> ... *)
        (* To   ... -> A -> C -> ... -> B -> D -> ... *)
        let (ca, ia) as a = a in 
        let (cb, ib) as b = MLLPath.get_next a path in
        let (cc, ic) as c = c in
        let (cd, id) as d = MLLPath.get_next c path in
        if Carte.mem_broken_road (ca, cc) carte
        then path
        else if Carte.mem_broken_road (cb, cd) carte 
        then path
        else
        let reverted = MLLPath.reverted path c b in
        let distance_before = Carte.distance_path (MLLPath.cities_list path) carte in
        let distance_after = Carte.distance_path (MLLPath.cities_list reverted) carte in
        if distance_after < distance_before
        then
            reverted
        else
            path

    let rec inversion_n_fois solution n carte =
        if n = 0
        then solution
        else
            let a = MLLPath.get_random solution in
            let c = MLLPath.get_random solution in 
            let swapped = inversion_locale a c solution carte in
            inversion_n_fois swapped (n - 1) carte

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

    (* Fonction auxiliaire pour find_optimal. Trouve l'élément optimal tout en reconstruisant la liste, en ne perdant pas d'information. *)
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

    (* Trouve l'élément maximisant f dans l. Renvoie None si f n'est pas satisfiable (ex: ville infiniment loin) *)
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
            (* Compute the distance between current path entry and out-of-path node *)
            let current_distance = Carte.distance current_city city carte in
            (* Stop condition *)
            let current_result = 
                if current_distance = infinity 
                then 
                    None
                else 
                    Some(current, current_distance) 
            in
            if next = initial
            then
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
                (* Otherwise, find the closest in path *)
                let closest = find_closest_in_path initial idx in 
                (idx, closest)::(construct_list_from_bindings t)
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
        (* Construit un chemin à partir d'un chemin initial p en utilisant la liste des noeuds les plus proches *)
        let rec build_path l p calls : MLLPath.path = 
            let _ = 
                if calls = 10 
                then failwith "Recursion error"
                else () in
            (* On trouve l'élément qui maximise la distance minimale au chemin *)
            (* 
                new_element -> le noeud à ajouter
                closest_in_path -> à côté de quel élément l'ajouter (None ou Some(path_entry * float))
                l' -> la liste des mins sans new_element
            *)
            let new_element_option, l' = finder l in
            (* On l'insère après closest_in_path pour minimiser la distance totale *)
            if new_element_option = None 
            then build_path (build_initial_mins_list carte p) p (calls + 1) else
            let new_entry, p' = match new_element_option with
            | None -> failwith "Nothing to add"
            | Some(new_element, closest_in_path, dist) -> 
                MLLPath.insert_in_path new_element closest_in_path p carte 
            in 
            (* let _ = MLLPath.print p' in  *)
            let l'' = match new_element_option with
            | None -> failwith "Nothing to add 2"
            | Some(new_element, closest_in_path, dist) -> rebuild_mins_list l' new_entry carte
            in
            (* let _ = print_mins_list l' in   *)
            (* let _ = Printf.printf "New distance: %f\n" (Carte.distance_path (MLLPath.cities_list p') carte) in  *)
            (* let _ = Printf.printf "\n" in  *)
            match l' with
            | [] -> p'
            | l' -> build_path l'' p' calls
        
        in build_path initial_mins_list initial_path 0

    (* Construit une solution initiale en prenant la ville la plus proche *)
    let build_solution_nearest = build_solution find_nearest

    (* Construit une solution initiale en prenant la ville la plus lointaine *)
    let build_solution_farthest = build_solution find_farthest

    (* Construit une solution initiale en prenant des villes au hasard *)
    let build_solution_random carte initial_path =
        let initial_set = MLLPath.cities_set initial_path in 
        let initial_card = MLLPath.NodeSet.cardinal initial_set in 
        let target_card = Carte.card carte in 
        let rec aux card cities_set path = 
            if card = target_card 
            then path
            else
                let new_element, _ = Carte.get_random carte cities_set in 
                let cities_set' = Carte.NodeSet.add new_element cities_set in 
                (* let _ = Printf.printf "Inserting %s\n" (Carte.get_name new_element carte) in *)
                let new_elt, path' = MLLPath.insert_minimize_length new_element path carte in 
                let card' = card + 1 in 
                aux card' cities_set' path'
        in aux initial_card initial_set initial_path

    let hull_initial_path carte = 
        let hull : Hull.hull = Hull.convex_hull carte in 
        let hull_indices : Carte.node list = Hull.to_indices hull in 
        let initial_path : MLLPath.path = MLLPath.from_list hull_indices carte in 
        initial_path

    let random_point_initial_path carte =
        let city_start, _ = Carte.get_random_any carte in
        let (city_start, idx_start), initial_path = MLLPath.make city_start in
        initial_path

    (* Construit une solution grâce à un builder et à une carte fournis. *)
    let find_solution initial_path_builder builder optimizer carte =
        let initial_path = initial_path_builder carte in

        let s = Sys.time() in
        let solution = builder carte initial_path in
        let e = Sys.time() in
        let distance = Carte.distance_path (MLLPath.cities_list solution) carte in 
        let _ = 
            if Config.debug then
                let _ = Printf.printf "Construction sol initiale\n" in 
                let _ = Printf.printf "Temps construction sol initiale: %f\n" (e -. s) in
                let _ = MLLPath.print solution in 
                let _ = Printf.printf "Distance initiale: %f\n" distance in 
                ()
            else () 
        in
            
        let s = Sys.time() in
        let solution_optimisee = optimizer solution n_opt carte in
        let e = Sys.time() in 
        let distance_opt = Carte.distance_path (MLLPath.cities_list solution_optimisee) carte in 
        let _ = 
            if Config.debug then
                let _ = Printf.printf "Temps optimisation: %f\n" (e -. s) in
                let _ = Printf.printf "Distance: %f\n" distance_opt in 
                ()
            else ()
        in

        solution
end 