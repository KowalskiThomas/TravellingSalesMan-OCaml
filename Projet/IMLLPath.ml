(*
    A map that represents a path
    Each element is a pair (last, next)
    So it is a kind of linked-list though the access to the elements is in a way better complexity
*)

(*
    A map that represents a path
    Each element is a pair (last, next)
    So it is a kind of linked-list though the access to the elements is in a way better complexity
*)

module MLLPath = struct
    module Carte = ICarte.CompleteCarte

    module Node = Carte.Node
    type node = Node.t

    module PathEntry : Map.OrderedType with type t = Node.t * int = struct
        type t = Node.t * int
        let compare x y = 
            match x, y with
            | (node_x, idx_x), (node_y, idx_y) ->
                let node_comparison = Node.compare node_x node_y in 
                if node_comparison = 0 
                then idx_x - idx_y
                else node_comparison
    end
    type path_entry = PathEntry.t

    module PathEntrySet = Set.Make(PathEntry)
    type path_entry_set = PathEntrySet.t

    module PathMap = Map.Make(PathEntry)

    type value = path_entry * path_entry

    exception AlreadyInPath
    exception NotInPath
    exception EmptyPath

    type path = value PathMap.t

    let empty = PathMap.empty

    let is_empty p = PathMap.is_empty p

    let cardinal p = PathMap.cardinal p

    let get_next (u : path_entry) (p : path) =
        try
            let (_, next) = PathMap.find u p in
            next
        with Not_found -> raise NotInPath

    let get_last u p =
        try
            let (last, _) = PathMap.find u p in
            last
        with Not_found -> raise NotInPath

    let get_first path =
        try
            let (key, _) = PathMap.min_binding path in key
        with Not_found -> raise EmptyPath

        let rec find_first_occurrence city path = 
            let initial = get_first path in 
            let rec aux current =
                let city_cur, _ = current in 
                if city_cur = city 
                then current
                else if current = initial 
                then raise NotInPath
                else aux (get_next current path)
            in aux (get_next initial path)
    
    let mem_city u p = 
        try
            let _ = find_first_occurrence u p in
            true
        with NotInPath -> false    

    let print p =
        if is_empty p then
            Printf.printf "< Empty path >"
        else
            let start = get_first p in
            let rec aux u =
                let (city, idx) = u in 
                let next = get_next u p in
                let _ = Printf.printf "(%d, %d) " city idx in
                if next = start then () else aux next
            in
                let _ = aux start in
                let _ = Printf.printf "\n" in ()

    let print_with_names p c =
        if is_empty p then
            print p
        else
            let start = get_first p in
            let rec aux u =
                let next = get_next u p in
                let city, idx = u in 
                let name, (_, _) = Carte.find city c in
                let _ = Printf.printf "%s " name in
                if next = start then () else aux next
            in
            let _ = aux start in
            let _ = Printf.printf "\n" in ()

    let swap_touching_3 lu u v p =
        (* We have lu u v *)
        (* We want lu v u *)
        PathMap.add lu (u, v)
        (PathMap.add v (lu, u)
        (PathMap.add u (v, lu) empty))

    let swap_touching_4 lu u v nv p =
        (* We have lu u v nv *)
        (* We want lu v u nv *)
        PathMap.add lu (nv, u)
        (PathMap.add v (lu, u)
        (PathMap.add u (v, nv)
        (PathMap.add nv (u, lu) empty)))

    let swap_touching (u : path_entry) (v : path_entry) (p : path) =
        (* We have something like 1 2 u v 5 6 7 8 *)
        (* We want                1 2 v u 5 6 7 8 *)
        let last_u = get_last u p in
        let last_v = get_last v p in
        let next_v = get_next v p in
        let last_last_u = get_last last_u p in
        let last_last_v = get_last last_v p in
        let next_next_v = get_next next_v p in
        if last_last_u = v
        then swap_touching_3 last_u u v p
        else if last_last_v = u
        then swap_touching_3 last_v v u p
        else
            let result =
            PathMap.add last_u (last_last_u, v)
            (PathMap.add next_v (u, next_next_v)
            (PathMap.add v (last_u, u)
            (PathMap.add u (v, next_v) p))) in
            result

    let swap_one_between last_last_u last_u u next_u last_v v next_v next_next_v p =
        (* Au milieu, on a next_u = last_v *)
        (* Avant: llu lu u nu v nv nnv *)
        (* Après: llu lu v nu u nv nnv *)
        PathMap.add last_u (last_last_u, v)
        (PathMap.add v (last_u, next_u)
        (PathMap.add next_u (v, u)
        (PathMap.add u (next_u, next_v)
        (PathMap.add next_v (u, next_next_v) p))))

    let swap u v p =
        (* let _ = print p in *)
        let city_u, idx_u = u in 
        let city_v, idx_v = v in 
        if not(mem_city city_u p) || not(mem_city city_v p)
        then raise NotInPath
        else if u = v
        (* Cas où on souhaite échanger u et u, pas très intéressant *)
        then p
        else
            let (last_u, next_u) = PathMap.find u p in
            if last_u = next_u
            (* Cas où le suivant et le précédent de u sont les mêmes (et sont v, d'ailleurs), échanger ne ferait rien *)
            then p
            else
                let (last_v, next_v) = PathMap.find v p in
                if last_v = u || last_u = v
                (* Cas où on a ... -> u -> v -> ... *)
                then swap_touching u v p
                else
                    (* Before: llu lu u nu nnu ... llv lv v nv nnv*)
                    let (last_last_u, _) = PathMap.find last_u p in
                    let (_, next_next_u) = PathMap.find next_u p in
                    let (last_last_v, _) = PathMap.find last_v p in
                    let (_, next_next_v) = PathMap.find next_v p in
                    if next_next_u = v then
                        swap_one_between last_last_u last_u u next_u last_v v next_v next_next_v p
                    else if next_next_v = u then
                        swap_one_between last_last_v last_v v next_v last_u u next_u next_next_u p
                    else
                        PathMap.add v (last_u, next_u)
                        (PathMap.add last_u (last_last_u, v)
                        (PathMap.add next_u (v, next_next_u)
                        (PathMap.add u (last_v, next_v)
                        (PathMap.add last_v (last_last_v, u)
                        (PathMap.add next_v (u, next_next_v) p)))))

    let insert_in_unary u last p =
        PathMap.add u (last, last) (PathMap.add last (u, u) empty)

    let insert_in_binary u last p =
        let (v, _) = PathMap.find last p in
        PathMap.add last (v, u)
        (PathMap.add u (last, v)
        (PathMap.add v (u, last) empty))

    let insert u last p =
        let city_u, idx_u = u in 
        if mem_city city_u p
        then raise AlreadyInPath
        else
            try
                let (last_last, last_next) = PathMap.find last p in
                if last_last = last then
                    insert_in_unary u last p
                else if last_last = last_next then
                    insert_in_binary u last p
                else
                    let (_, last_next_next) = PathMap.find last_next p in
                    PathMap.add
                        last (last_last, u)
                        (PathMap.add u (last, last_next)
                        (PathMap.add last_next (u, last_next_next) p))
            with Not_found -> raise NotInPath

    let insert_before_or_after u other p _ = insert u other p

    let remove_standard u p =
        let (last, next) = PathMap.find u p in
        let (last_last, _) = PathMap.find last p in
        let (_, next_next) = PathMap.find next p in
        PathMap.add last (last_last, next)
        (PathMap.add next (last, next_next)
        (PathMap.remove u p))

    let make u =
        PathMap.add (u, 0) ((u, 0), (u, 0)) empty

    let remove_two u p =
        (*
         * Seulement deux éléments dans le chemin
         * On veut enlever 1
         * Si on part de 1 -> 2 -> 1
         * On renvoie 2
         *)
        let (last, next) = PathMap.find u p in
            (* let _ = Printf.printf "last : %d next : %d u : %d\n" last next u in  *)
            let city_last, _ = last in 
            make city_last

    let remove u p =
        let city_u, idx_u = u in 
        if not (mem_city city_u p)
        then raise NotInPath
        else
            let (last, next) = PathMap.find u p in
            (* let _ = Printf.printf "u = %d last = %d next = %d\n" u last next in  *)
            if last = u && next = u then
                empty
            else if last = next then
                remove_two u p
            else
                remove_standard u p

    (*
    Calcule la longueur d'un chemin
    p : Chemin dont on veut la longueur
    c : Carte
    *)
    let length p c =
        let start = get_first p in
        (*
        rec calcule la longueur de la fin de la tournée
        u : Ville en cours d'évaluation
        *)
        let rec aux u =
            (* On détermine la ville après u *)
            let next = get_next u p in
            let city_u, idx_u = u in
            let city_next, idx_next = next in 
            (* On détermine la distance entre u et la ville suivante *)
            let distance = Carte.distance city_u city_next c in
            (* Si la ville suivante est la ville de départ, on a fini de calculer *)
            if next = start
            then distance
            (* Sinon, on renvoie la distance entre u et la suivante + la distance sur la fin de la tournée *)
            else distance +. aux next
        (* Appel à aux (de u à u) *)
        in aux start

    let to_set (path : path) =
        let start = get_first path in
        let rec to_set_from u =
            let next = get_next u path in
            if next = start
            then PathEntrySet.add u (PathEntrySet.empty)
            else PathEntrySet.add u (to_set_from next)
        in to_set_from start

    let to_list (path : path) =
        let start = get_first path in
        let rec to_list_from u =
            let next = get_next u path in
            if next = start
            then [u]
            else u::(to_list_from next)
        in to_list_from start

    (*
    Insère une ville au bon endroit pour minimiser la longueur totale
    to_insert : Indice dans la carte de la ville à insérer
    p : Chemin dans lequel insérer la ville
    c : Carte
    Revoie: p avec to_insert dedans
    *)
    let insert_minimize_length to_insert new_index p c =
        (*
        rec trouve où insérer la ville
        u : Ville en cours d'évaluation
        *)
        let start = get_first p in
        let rec aux u =
            (* Calcul du successeur de u dans p *)
            let next = get_next u p in
            (* Calcul de la différence de distance en cas d'insertion après u *)
            let city_u, idx_u = u in 
            let city_next, idx_next = next in 
            let distance_u_next = Carte.distance city_u city_next c in
            let somme_distances = Carte.distance city_u to_insert c +. Carte.distance to_insert city_next c in
            let delta =  somme_distances -. distance_u_next in
            (* let _ = Printf.printf "Distance de %d à %d : %f\n" u next distance_u_next in
            let _ = Printf.printf "Delta avec %d après %d : %f\n" to_insert u delta in
            let _ = Printf.printf "Distance %d à %d : %f, %d à %d : %f\n" u to_insert (Carte.distance u to_insert c) to_insert next (Carte.distance next to_insert c) in
            let _ = Printf.printf "\n" in *)
            (* Si on a fait le tour, on n'a plus d'appel récursif à faire *)
            if next = start
            then (delta, u)
            else
                (* On appelle récursivement pour obtenir le meilleur endroit où insérer la ville dans la fin de la tournée *)
                let delta_next, after_next = aux next in
                (* Si insérer dans la fin de la tournée offre un meilleur delta *)
                if delta_next < delta
                then (delta_next, after_next)
                else (delta, u)
        in
        (* On détermine après quelle ville insérer la nouvelle ville *)
        let _, after = aux start in
        (* Débogage *)
        (* let _ = Printf.printf "u = %d should be inserted after %d\n" to_insert after in *)
        (* On renvoie p avec to_insert insérée au bon endroit *)
        insert (to_insert, new_index) after p

    let insert_nearest_minimize_length p cities cities_list cities_set new_index =
        let insert_after, nearest, dist = Carte.find_nearest_not_in_path cities_list cities_set cities in
        let insert_after = find_first_occurrence insert_after p in
        (nearest, new_index), (insert (nearest, new_index) insert_after p)

    let insert_farthest_minimize_length p cities cities_list cities_set new_index = 
        let insert_after, farthest, dist = Carte.find_farthest_not_in_path cities_list cities_set cities in 
        let insert_after = find_first_occurrence insert_after p in 
        (farthest, new_index), (insert (farthest, new_index) insert_after p)

    let insert_random_minimize p c _ cities_set new_index =
        let (random_city_index, _) = Carte.get_random c cities_set in
        (random_city_index, new_index), (insert_minimize_length random_city_index new_index p c)

    let get_next_by_name name p c =
        let index = Carte.get_index name c in
        let entry = find_first_occurrence index p in 
        get_next entry p

    let get_last_by_name name p c =
        let index = Carte.get_index name c in
        let entry = find_first_occurrence index p in 
        get_last entry p

end