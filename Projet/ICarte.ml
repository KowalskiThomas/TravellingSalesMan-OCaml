module CompleteCarte = struct
    module Node = struct
        type t = int
        let compare x y = x - y
    end
    type node = Node.t

    module NodeSet = Set.Make(Node)
    type node_set = NodeSet.t

    type pair = string * (float * float)

    module IntMap = Map.Make(Node)
    type carte = pair IntMap.t

    exception NotInCarte

    let find u g = IntMap.find u g

    let empty = IntMap.empty

    let is_empty c = c = empty

    let add_node index name x y g =
        IntMap.add index (name, (x, y)) g

    let fold f c acc = IntMap.fold f c acc

    let card g = IntMap.cardinal g

    let bindings g = IntMap.bindings g

    let keys g = IntMap.fold (fun key _ acc -> NodeSet.add key acc) g NodeSet.empty

    exception Found of int
    exception IndexError
    let get_ith i s =
        try
            let _ = NodeSet.fold (fun x acc -> if acc = i then raise (Found(x)) else acc + 1) s 0 in
            raise IndexError
        with Found(x) -> x

    let rec get_random g exclude =
        let all_cities_indices = keys g in
        let available = NodeSet.diff all_cities_indices exclude in
        let c = NodeSet.cardinal available in
        let i = Random.int c in
        let idx = get_ith i available in
        (* let _ = Printf.printf "%d %d\n" i idx in  *)
        (idx, IntMap.find idx g)

    let get_random_any g = get_random g NodeSet.empty

    let print c =
        if is_empty c then
            Printf.printf "< Carte vide >"
        else
            let rec print_from_bindings b = match b with
                | [] -> Printf.printf "\n"
                | (idx, (name, (x, y)))::t ->
                    let _ = Printf.printf "\t[%d]. %s (%f, %f)\n" idx name x y in
                    print_from_bindings t

            in let _ = Printf.printf "Cities in map:\n"
            in print_from_bindings (IntMap.bindings c)


    let distance_from_coordinates xu yu xv yv =
        (* let _ = Printf.printf "xu %f xv %f yu %f yv %f\n" xu xv yu yv in *)
        (((xu -. xv) *. (xu -. xv) +. (yu -. yv) *. (yu -. yv))) ** (1. /. 2.)

    let distance_from_city_coordinates city_index x y g =
        let (_, (xcity, ycity)) = IntMap.find city_index g in
            distance_from_coordinates xcity ycity x y

    let distance u v c =
        try
            let data_u = IntMap.find u c in
            let data_v = IntMap.find v c in
            match data_u, data_v with
            | (_, (xu, yu)), (_, (xv, yv)) -> distance_from_coordinates xu yu xv yv
        with Not_found -> raise NotInCarte

    (* let rec print_list l = match l with
        | [] -> Printf.printf "\n"
        | t::q -> let _ = Printf.printf "%d " t in print_list q *)

    let find_optimal f from exclude cities =
        let (name_from, (x_from, y_from)) = IntMap.find from cities in
        let rec aux bindings = match bindings with
            | [] -> failwith "No city found"
            | [index, (name, (x, y))] -> index, distance_from_coordinates x_from y_from x y
            | (index, (name, (x, y)))::t ->
                (* Si la ville en cours est à exlure *)
                if NodeSet.mem index exclude || index = from
                then aux t
                else
                    let dist = distance_from_coordinates x_from y_from x y in
                    let (best_next, dist_next) = aux t in
                    if f dist_next dist || NodeSet.mem best_next exclude
                    then index, dist
                    else best_next, dist_next
        in aux (bindings cities)

    let find_nearest from exclude cities =
        let operator = (fun x y -> y < x) in
        find_optimal operator from exclude cities

    let find_farthest from exclude cities =
        let operator = (fun x y -> x < y) in
        find_optimal operator from exclude cities

    let rec find_nearest_not_in_path cities_list cities_set carte =
        let rec aux cities = match cities with
        | [] -> failwith "insert_nearest_minimize_length: Nothing left to add."
            | [u] ->
                let nearest, dist = find_nearest u cities_set carte in
                u, nearest, dist
            | u::t ->
                let nearest_u, dist_u = find_nearest u cities_set carte in
                let insert_after_next, nearest_next, dist_next = find_nearest_not_in_path t cities_set carte in
                if dist_u < dist_next
                then u, nearest_u, dist_u
                else insert_after_next, nearest_next, dist_next
        in aux cities_list

    let rec find_farthest_not_in_path cities_list cities_set carte = 
        1, 1, 1.
        (* let rec aux cities = match cities with
        | [] -> failwith "find_farthest_minimize_length: No city to add" 
        | [u] -> 
            let farthest_u, dist_u = find_farthest u cities_set carte in
            let nearest_farthest, dist_nearest_farthest = find_nearest farthest_u cities_set carte in
            u, farthest_u, dist_u, dist_nearest_farthest 
        | u::t -> 
            let farthest_u, dist_u = find_farthest u cities_set carte in 
            let nearest_farthest, dist_nearest_farthest = find_nearest farthest_u cities_set carte in
            let insert_after_next, farthest_next, dist_next = aux t in 
            if dist_u > dist_next
            then u, farthest_u, dist_u 
            else insert_after_next, farthest_next, dist_next 
        in aux cities_list *)
    
    let rec distance_path path g = match path with
    | [] -> 0.
    | [_] -> 0. (* A path with only one point has no length *)
    | a::(b::t) ->
        (distance a b g) +.
        (distance_path (b::t) g) (* TODO: Possible optimization here *)

    let add_cities villes carte =
        let rec aux i villes carte =
            match villes with
            | [] -> carte
            | (n, x, y)::t -> add_node i n x y (aux (i + 1) t carte)
        in aux 0 villes carte

    let make_carte_from_cities cities =
        add_cities cities empty

    let get_index target c =
        let rec find_from_bindings l = match l with
            | [] -> failwith (target ^ " non trouvé dans la Carte")
            | (idx, (name, (_, _)))::t ->
                if name = target
                then idx
                else find_from_bindings t
            in
            let b = bindings c in
            find_from_bindings b

    let get_name idx c =
        try
            let (name, (_, _)) = IntMap.find idx c in name
        with Not_found -> raise NotInCarte

    let get_coordinates idx c =
        try
            let (_, coord) = IntMap.find idx c in coord
        with Not_found -> raise NotInCarte
end