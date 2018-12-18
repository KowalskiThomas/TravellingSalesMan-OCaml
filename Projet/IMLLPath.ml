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
    module NodeSet = Carte.NodeSet
    type node = Carte.Node.t
    type node_set = NodeSet.t

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

    exception NotInPath
    exception EmptyPath

    type path = {
        map : value PathMap.t;
        last_index : int;
        cardinal : int;
    }

    let empty = { 
        map = PathMap.empty;
        last_index = -1;
        cardinal = 0;
    }

    let is_empty { map = m; cardinal = n } = 
        if m = PathMap.empty && n = 0 
        then true
        else if m <> PathMap.empty && n > 0 
        then false
        else failwith "Inconsistent state"

    let cardinal { cardinal = n } = n

    let find u { map = m } = PathMap.find u m 

    let min_binding { map = m } = PathMap.min_binding m

    let get_last_index { last_index = k } = k

    let get_next_index { last_index = k } = k + 1 

    let add entry value { map = m; cardinal = n; last_index = k } = {
        map = PathMap.add entry value m;
        cardinal = n + 1;
        last_index = k + 1;
    }

    let make u =
        (u, 0), add (u, 0) ((u, 0), (u, 0)) empty

    let make_with_index u idx = 
        (u, idx), 
        {
            cardinal = 1;
            last_index = idx;
            map = PathMap.add (u, idx) ((u, idx), (u, idx)) PathMap.empty
        }

    let path_remove entry { map = m; cardinal = n; last_index = k } = 
        let result = {
            map = PathMap.remove entry m;
            cardinal = n - 1;
            last_index = k;
        }
        in result

    let get_first path =
        try
            let (key, _) = min_binding path in key
        with Not_found -> raise EmptyPath

    let get_random path = get_first path (* TODO: Fix this *)
    
    let mem u { map = m } = PathMap.mem u m
        
    let get_next (u : path_entry) (p : path) =
        try
            let (_, next) = find u p in
            next
        with Not_found -> raise NotInPath

    let get_last u p =
        try
            let (last, _) = find u p in
            last
        with Not_found -> raise NotInPath

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
            try
                let _ = find_first_occurrence u p in
                true
            with NotInPath -> false
        with EmptyPath -> false
        
    let print p =
        if is_empty p then
            Printf.printf "< Empty path >\n"
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
        add lu (u, v)
        (add v (lu, u)
        (add u (v, lu) empty))

    let swap_touching_4 lu u v nv p =
        (* We have lu u v nv *)
        (* We want lu v u nv *)
        add lu (nv, u)
        (add v (lu, u)
        (add u (v, nv)
        (add nv (u, lu) empty)))

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
            add last_u (last_last_u, v)
            (add next_v (u, next_next_v)
            (add v (last_u, u)
            (add u (v, next_v) p))) in
            result

    let swap_one_between last_last_u last_u u next_u last_v v next_v next_next_v p =
        (* Au milieu, on a next_u = last_v *)
        (* Avant: llu lu u nu v nv nnv *)
        (* Après: llu lu v nu u nv nnv *)
        add last_u (last_last_u, v)
        (add v (last_u, next_u)
        (add next_u (v, u)
        (add u (next_u, next_v)
        (add next_v (u, next_next_v) p))))

    let swap u v p =
        (* let _ = print p in *)
        (* let city_u, idx_u = u in  *)
        (* let city_v, idx_v = v in  *)
        if not(mem u p) || not(mem v p)
        then raise NotInPath
        else if u = v
        (* Cas où on souhaite échanger u et u, pas très intéressant *)
        then p
        else
            let (last_u, next_u) = find u p in
            if last_u = next_u
            (* Cas où le suivant et le précédent de u sont les mêmes (et sont v, d'ailleurs), échanger ne ferait rien *)
            then p
            else
                let (last_v, next_v) = find v p in
                if last_v = u || last_u = v
                (* Cas où on a ... -> u -> v -> ... *)
                then swap_touching u v p
                else
                    (* Before: llu lu u nu nnu ... llv lv v nv nnv*)
                    let (last_last_u, _) = find last_u p in
                    let (_, next_next_u) = find next_u p in
                    let (last_last_v, _) = find last_v p in
                    let (_, next_next_v) = find next_v p in
                    if next_next_u = v then
                        swap_one_between last_last_u last_u u next_u last_v v next_v next_next_v p
                    else if next_next_v = u then
                        swap_one_between last_last_v last_v v next_v last_u u next_u next_next_u p
                    else
                        add v (last_u, next_u)
                        (add last_u (last_last_u, v)
                        (add next_u (v, next_next_u)
                        (add u (last_v, next_v)
                        (add last_v (last_last_v, u)
                        (add next_v (u, next_next_v) p)))))

    let insert_in_unary u last p =
        add u (last, last) (add last (u, u) empty)

    let insert_in_binary u last p =
        let (v, _) = find last p in
        add last (v, u)
        (add u (last, v)
        (add v (u, last) empty))

    let insert u last p =
        (* if mem_city u p then failwith "test" else *)
        try
        let (last_last, last_next) = find last p in
            let next_index = get_next_index p in 
            let u = (u, next_index) in 
            if last_last = last then
                u, insert_in_unary u last p
            else if last_last = last_next then
                u, insert_in_binary u last p
            else
                let (_, last_next_next) = find last_next p in
                u, (add last (last_last, u) (add u (last, last_next) (add last_next (u, last_next_next) p)))
        with Not_found -> raise NotInPath

    let insert_in_path u other p c = 
        let c_other, _ = other in 
        let (c_prev_other, _) as prev_other = get_last other p in 
        let (c_next_other, _) as next_other = get_next other p in 
        let broken_prev = Carte.mem_broken_road (c_prev_other, u) c in
        let broken_next = Carte.mem_broken_road (c_next_other, u) c in
        if  broken_prev && not broken_next 
        then insert u other p 
        else if not broken_prev && broken_next
        then insert u prev_other p 
        else if broken_prev && broken_next 
        then 
            let (u, u_uid) as entry_u, path_with_new = insert u other p in 
            insert c_other entry_u path_with_new
        else (* Both are available *)
            insert u other p 

    let remove_standard u p =
        (* 
         * Cas normal pour la suppression d'un élément
         * A savoir A -> B -> C -> D -> E
         * Donne    A -> B -> D -> E
         *)
        let (last, next) = find u p in
        let (last_last, _) = find last p in
        let (_, next_next) = find next p in
        add last (last_last, next)
        (add next (last, next_next)
        (path_remove u p))

    let remove_two u p =
        (*
         * Seulement deux éléments dans le chemin
         * On veut enlever 1
         * Si on part de 1 -> 2 -> 1
         * On renvoie 2
         *)
        let (last, next) = find u p in
            (* let _ = Printf.printf "last : %d next : %d u : %d\n" last next u in  *)
            let city_last, index_last = last in 
            let _ , p = make_with_index city_last index_last
            in p 

    let remove u p =
        if not (mem u p)
        then raise NotInPath
        else
            let (last, next) = find u p in
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

    let rec entries_between (p : path) (u : path_entry) v = 
        let next_u = get_next u p in
        if next_u = v 
        then u::v::[]
        else 
            u :: (entries_between p next_u v)

    let rec remove_entries_from (l : path_entry list) (p : path) = 
        match l with
        | [] -> p
        | h::t -> 
            let p' = remove h p in 
            remove_entries_from t p'

    let rec add_all_after (l : path_entry list) (u : path_entry) (p : path) = 
        match l with
        | [] -> p
        | (c, _)::q -> 
            let new_entry, p' = insert c u p in
            add_all_after q new_entry p'

    let rec print_list (l : path_entry list) = match l with
        | [] -> ()
        | (c, i)::q -> 
            let _ = Printf.printf "(%d, %d) " c i in 
            let _ = print_list q in 
            ()

    let reverted p u v = 
        let prev_u = get_last u p in
        (* let _ = print p in  *)
        let entries = entries_between p u v in
        (* let _ = print_list entries in let _ = Printf.printf "\n" in  *)
        let without_path_between_u_and_v = remove_entries_from entries p in 
        (* let _ = print without_path_between_u_and_v in *)
        let entries_reverted = List.rev entries in 
        (* let _ = print_list entries_reverted in let _ = Printf.printf "\n" in  *)
        let new_path = 
            try
                add_all_after entries_reverted prev_u without_path_between_u_and_v 
            with NotInPath ->
                match entries_reverted with
                | [] -> without_path_between_u_and_v
                | (first_city, _)::entries_reverted' -> 
                    let first_entry, new_path = make first_city in 
                    add_all_after entries_reverted' first_entry new_path
        in
        (* let _ = print new_path in *)
        new_path

    let cities_set (path : path) =
        let start = get_first path in
        let rec to_set_from u =
            let next = get_next u path in
            let city, _ = next in 
            if next = start
            then NodeSet.add city (NodeSet.empty)
            else NodeSet.add city (to_set_from next)
        in to_set_from start

    let entries_list (path : path) =
        let start = get_first path in
        let rec to_list_from u =
            let next = get_next u path in
            if next = start
            then [u]
            else u::(to_list_from next)
        in to_list_from start

    let cities_list (path : path) =
        let start = get_first path in
        let rec to_list_from u =
            let next = get_next u path in
            let city, _ = next in 
            if next = start
            then [city]
            else city::(to_list_from next)
        in to_list_from start

    (*
    Insère une ville au bon endroit pour minimiser la longueur totale
    to_insert : Indice dans la carte de la ville à insérer
    p : Chemin dans lequel insérer la ville
    c : Carte
    Revoie: p avec to_insert dedans
    *)
    let insert_minimize_length to_insert p c =
        (* TESTER LA MAISON *)
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
            let delta = somme_distances -. distance_u_next in
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
        (* On renvoie p avec to_insert insérée au bon endroit *)
        insert to_insert after p

    let rec from_list (l : node list) (c : Carte.carte) : path = 
        match l with
        | [] -> empty
        | [e] -> 
            let _, p = make e in p
        | h::t ->
            let p = from_list t c in 
            let _, p' = insert_minimize_length h p c in 
            p'

    let insert_random_minimize p c _ cities_set =
        let (random_city_index, _) = Carte.get_random c cities_set in
        insert_minimize_length random_city_index p c

    let get_next_by_name name p c =
        let index = Carte.get_index name c in
        let entry = find_first_occurrence index p in 
        get_next entry p

    let get_last_by_name name p c =
        let index = Carte.get_index name c in
        let entry = find_first_occurrence index p in 
        get_last entry p

end