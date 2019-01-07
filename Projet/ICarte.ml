(* 
Quelle stratégie utilise t-on pour stocker les routes inexistantes ?
Première possibilité : quand on ajoute (x, y), on ajoute à l'ensemble (x, y) et (y, x)
Deuxième possibilité : on ajoute (x, y) et sur le mem, on cherche (x, y) et (y, x)
La première possibilité réduit la complexité globalement, mais est plus demandeuse sur l'insertion et la suppression.
La deuxième possibilité est plus gourmande en recherche :
    2log(n) >= log(2n) vrai dès n = 1.
*)
let strategy_insert_both_couples = true

module Carte = struct
    module Node = struct
        type t = int
        let compare x y = x - y
    end
    type node = Node.t

    module NodeSet = Set.Make(Node)
    type node_set = NodeSet.t

    module BrokenRoad = struct 
        type t = node * node
        let compare (x, y) (z, t) =
            if x = z 
            then Node.compare y t 
            else Node.compare x z
    end
    type broken_road = BrokenRoad.t
    module BrokenRoadSet = Set.Make(BrokenRoad)
    type broken_road_set = BrokenRoadSet.t

    type pair = string * (float * float)

    module IntMap = Map.Make(Node)
    type carte = 
    {
        cities : pair IntMap.t;
        broken_roads : broken_road_set; 
    }

    exception NotInCarte

    let find u { cities = g } = IntMap.find u g

    let empty = {
        cities = IntMap.empty;
        broken_roads = BrokenRoadSet.empty
    }

    let is_empty c = c = empty

    let add_node index name x y { broken_roads = br; cities = g } =
    {
        cities = IntMap.add index (name, (x, y)) g;
        broken_roads = br
    }

    let fold f { cities = g } acc = IntMap.fold f g acc

    let card { cities = g } = IntMap.cardinal g

    let bindings { cities = g } = IntMap.bindings g

    let keys { cities = g } = IntMap.fold (fun key _ acc -> NodeSet.add key acc) g NodeSet.empty

    exception Found of int
    exception IndexError

    let get_ith i s =
        try
            let _ = NodeSet.fold (fun x acc -> if acc = i then raise (Found(x)) else acc + 1) s 0 in
            raise IndexError
        with Found(x) -> x

    let rec get_random ({ cities = g } as c) exclude =
        let all_cities_indices = keys c in
        let available = NodeSet.diff all_cities_indices exclude in
        let card = NodeSet.cardinal available in
        let i = Random.int card in
        let idx = get_ith i available in
        (idx, find idx c)

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
            in print_from_bindings (bindings c)

    let add_broken_road (x, y) { broken_roads = s; cities = g } = {
        broken_roads = 
            if strategy_insert_both_couples 
            then BrokenRoadSet.add (y, x) (BrokenRoadSet.add (x, y) s)
            else BrokenRoadSet.add (x, y) s;
        cities = g
    }

    let mem_broken_road (x, y) { broken_roads = s } = 
        if strategy_insert_both_couples
        then BrokenRoadSet.mem (x, y) s
        else BrokenRoadSet.mem (x, y) s || BrokenRoadSet.mem (y, x) s

    let remove_broken_road (x, y) { broken_roads = s; cities = g } = {
        broken_roads = 
            if strategy_insert_both_couples 
            then BrokenRoadSet.remove (y, x) (BrokenRoadSet.remove (x, y) s)
            else BrokenRoadSet.remove (x, y) s;
        cities = g
    }

    let distance_from_coordinates xu yu xv yv =
        ((xu -. xv) *. (xu -. xv) +. (yu -. yv) *. (yu -. yv)) ** (1. /. 2.)

    (* let distance_from_city_coordinates city_index x y g =
        let (_, (xcity, ycity)) = find city_index g in
            distance_from_coordinates xcity ycity x y *)

    let distance u v c =
        if mem_broken_road (u, v) c 
        then infinity 
        else 
        try
            let data_u = find u c in
            let data_v = find v c in
            match data_u, data_v with
            | (_, (xu, yu)), (_, (xv, yv)) -> distance_from_coordinates xu yu xv yv
        with Not_found -> raise NotInCarte

    let rec distance_path path g = 
        match path with 
        | [] -> 0.
        | [e] -> 0.
        | [a;b] -> 2. *. (distance a b g)
        | t::q ->
            let first_city = t in 
            let rec aux p = match p with
            | [] -> failwith "Unexpected empty list" 
            | [e] -> distance first_city e g 
            | a::(b::t) ->
                (distance a b g) +.
                (aux (b::t)) 
            in aux path

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
            let (name, (_, _)) = find idx c in name
        with Not_found -> raise NotInCarte

    let get_coordinates idx c =
        try
            let (_, coord) = find idx c in coord
        with Not_found -> raise NotInCarte
end