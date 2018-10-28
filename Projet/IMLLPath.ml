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
    module IntMap = Map.Make(Node)

    type node = Node.t
    type value = int * int

    exception AlreadyInPath
    exception NotInPath

    type path = value IntMap.t

    let empty = IntMap.empty

    let is_empty p = IntMap.is_empty p

    let mem u p = IntMap.mem u p

    (* exception NotInPath
    let set_next u next p =
        let data_next = IntMap.find next path in
        let IntMap.update u  path *)

    let get_next u p =
        let (_, next) = IntMap.find u p in
        next

    let get_last u p =
        let (last, _) = IntMap.find u p in
        last

    let get_random path = 
        let (key, _) = IntMap.choose path in key
    
    let get_first path = 
        let (key, _) = IntMap.min_binding path in key


    let print p = 
        let u = get_first p in 
        let rec aux initial u p = 
            let next = get_next u p in 
            let _ = Printf.printf "%d " u in
            if initial = next then () else aux initial next p
        in 
            let _ = aux u u p in
            let _ = Printf.printf "\n" in ()

    let swap_touching_3 llu u v p = 
        (* We have lu u v *)
        (* We want lu v u *)
        IntMap.add llu (u, v)
        (IntMap.add v (llu, u) 
        (IntMap.add u (v, llu) IntMap.empty))

    let swap_touching u v p = 
        (* We have something like 1 2 u v 5 6 7 8 *)
        (* We want                1 2 v u 5 6 7 8 *)
        let last_u = get_last u p in
        let next_v = get_next v p in 
        let last_last_u = get_last last_u p in 
        let next_next_v = get_next next_v p in 
        if last_last_u = v then
            swap_touching_3 last_u u v p        
        else
            let result = 
                IntMap.add last_u (last_last_u, v)
                (IntMap.add next_v (u, next_next_v)
                (IntMap.add v (last_u, u) 
                (IntMap.add u (v, next_v) p))) in 
            result

    let swap u v p =
        let _ = print p in
        if not(mem u p) || not(mem v p) 
        then raise NotInPath 
        else if u = v
        then p
        else
            (* TODO: Possible optimization (if u -> v or v -> u *)
            let (last_u, next_u) = IntMap.find u p in
            if last_u = next_u 
            then p
            else
                let (last_v, next_v) = IntMap.find v p in
                if last_v = u || last_u = v then
                    swap_touching u v p 
                else
                    let (last_last_u, _) = IntMap.find last_u p in
                    let (_, next_next_u) = IntMap.find next_u p in
                    let (last_last_v, _) = IntMap.find last_v p in
                    let (_, next_next_v) = IntMap.find next_v p in
                    IntMap.add v (last_u, next_u)
                    (IntMap.add last_u (last_last_u, v)
                    (IntMap.add next_u (v, next_next_u)
                    (IntMap.add u (last_v, next_v)
                    (IntMap.add last_v (last_last_v, u)
                    (IntMap.add next_v (u, next_next_v) p)))))

    (* val set_last : key -> key -> path -> path *)

    (* let mem u p =
        let result = IntMap.find_opt u p in
        match result with
        | None -> false
        | Some _ -> true *)

    (* Insert a new node in the path *)
    (* Example: insert u [after] last [in] p *)
    
    let insert_in_unary u last p = 
        IntMap.add u (last, last) (IntMap.add last (u, u) IntMap.empty)

    let insert_in_binary u last p = 
        let (v, _) = IntMap.find last p in 
        IntMap.add last (v, u) 
        (IntMap.add u (last, v) 
        (IntMap.add v (u, last) IntMap.empty))

    let insert u last p =
        if mem u p
        then raise AlreadyInPath
        else
            let (last_last, last_next) = IntMap.find last p in
            if last_last = last then
                insert_in_unary u last p
            else if last_last = last_next then
                insert_in_binary u last p 
            else 
                let (_, last_next_next) = IntMap.find last_next p in
                IntMap.add
                    last (last_last, u)
                    (IntMap.add u (last, last_next)
                    (IntMap.add last_next (u, last_next_next) p))

    let remove_standard u p =
        let (last, next) = IntMap.find u p in
        let (last_last, _) = IntMap.find last p in
        let (_, next_next) = IntMap.find next p in
        IntMap.add last (last_last, next)
        (IntMap.add next (last, next_next)
        (IntMap.remove u p))

    let make u =
        IntMap.add u (u, u) empty

    let remove_two u p =
        (*
         * Seulement deux éléments dans le chemin
         * On veut enlever 1
         * Si on part de 1 -> 2 -> 1
         * On renvoie 2
         *)
        let (last, next) = IntMap.find u p in
            (* let _ = Printf.printf "last : %d next : %d u : %d\n" last next u in  *)
            make last

    let remove u p =
        if not (mem u p)
        then raise NotInPath
        else
            let (last, next) = IntMap.find u p in
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
            (* On détermine la distance entre u et la ville suivante *)
            let distance = Carte.distance u next c in 
            (* Si la ville suivante est la ville de départ, on a fini de calculer *)
            if next = start
            then distance
            (* Sinon, on renvoie la distance entre u et la suivante + la distance sur la fin de la tournée *)
            else distance +. aux next
        (* Appel à aux (de u à u) *)
        in aux start

    (* let to_set path = 
        let start = get_first path in
        let rec to_set_from u = 
            let next = get_next u path in 
            if next = start
            then Carte.NodeSet.add u (Carte.NodeSet.empty)
            else Carte.NodeSet.add u (to_set_from next)
        in to_set_from start *)

    (* 
    Insère une ville au bon endroit pour minimiser la longueur totale 
    to_insert : Indice dans la carte de la ville à insérer    
    p : Chemin dans lequel insérer la ville
    c : Carte
    Revoie: p avec to_insert dedans
    *)
    let insert_minimize_length to_insert p c =
        (*
        rec trouve où insérer la ville
        u : Ville en cours d'évaluation
        *)
        let start = get_first p in
        let rec aux u =
            (* Calcul du successeur de u dans p *)
            let next = get_next u p in 
            (* Calcul de la différence de distance en cas d'insertion après u *)
            let distance_u_next = Carte.distance u next c in 
            let somme_distances = Carte.distance u to_insert c +. Carte.distance to_insert next c in 
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
        insert to_insert after p 

    (* let rec find_nearest_from_city u cities = 
        let (_, (xu, yu)) = Carte.find u cities in
        let rec aux u l = match l with
            | [] -> failwith "empty list for find_nearest_city"
            | [index, (name, (x, y))] -> index, (Carte.distance_from_coordinates xu yu x y)
            | (index, (name, (x, y)))::t -> 
                let dist = Carte.distance_from_coordinates xu yu x y in
                let (index_next, dist_next) = aux u t in 
                if dist < dist_next 
                then index, dist
                else index_next, dist_next
        in aux u (Carte.bindings cities) *)

    let find_nearest_from_city u cities = let b = Carte.bindings cities in  u + 1, 0.0

(* let (nearest_distance, nearest) = 
    Carte.fold 
    (fun index (name, (x, y)) (best_distance, best_city) -> 
        let test = x *. y in 
        let dist = Carte.distance u index in
        if dist < best_distance 
        then dist, elt
        else best_distance, best_city)
    c (9999999, "") in *)

    let insert_random_minimize p c = 
        let (random_city_index, _) = Carte.get_random c in 
        insert_minimize_length random_city_index p c 

end