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
    module NodeSet = Set.Make(Node)
    type node_set = NodeSet.t
    type node = Node.t

    module Word = struct
        type t = String.t
        let compare x y = String.compare x y
    end
    type word = Word.t
    module WordMap = Map.Make(Word)
    module WordSet = Set.Make(Word)
    type word_set = WordSet.t
    type road_map = word_set WordMap.t
    
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

    type ind_road_map = node_set IntMap.t

    type carte = 
    {
        cities : pair IntMap.t;
        roads : ind_road_map;
    }

    exception NotInCarte

    let find u { cities = g } = IntMap.find u g

    let empty = {
        cities = IntMap.empty;
        roads = IntMap.empty;
    }

    let is_empty c = c = empty

    let add_node index name x y { roads = r; cities = g } =
    {
        cities = IntMap.add index (name, (x, y)) g;
        roads = r;
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

    let mem_broken_road (x, y) { roads = m } =
        not(NodeSet.mem x (IntMap.find y m))

    exception InSet
    let accessible_from_city city from { roads = r } =             
        try
            NodeSet.fold
            (
                fun accessible_city _ -> if accessible_city = city then raise InSet else false
            ) (IntMap.find from r) false
        with InSet -> true

    let accessible_from_cityset city set c = 
        try
            NodeSet.fold
            (
                fun excluded_city _ -> 
                    if accessible_from_city city excluded_city c 
                    then raise InSet
                    else false
            ) set false
        with InSet -> true

    let filter_accessible av ex c = 
        NodeSet.fold
        (
            (* Pour chaque ville dispo *)
            fun av_city s -> 
                (* Si la ville est accessible depuis ex *)
                if accessible_from_cityset av_city ex c 
                (* Alors on l'ajoute *)
                then let _ = Printf.printf "test ON AJOUTE\n" in NodeSet.add av_city s 
                (* Sinon on ne l'ajoute pas *)
                else s
        )
        av NodeSet.empty 

    let get_name idx c =
        try
            let (name, (_, _)) = find idx c in name
        with Not_found -> raise NotInCarte
        
    let print_roads c = 
        IntMap.fold
        (
            fun orig s _ ->
                let _ = Printf.printf "%s\n" (get_name orig c) in 
                NodeSet.fold
                (
                    fun elt _ -> let _ = Printf.printf "\t%s\n" (get_name elt c) in ()
                ) s ()
        ) c.roads ()


    let rec get_random ({ cities = g } as c) exclude =
        let all_cities_indices = keys c in
        let available = NodeSet.diff all_cities_indices exclude in
        let accessible = 
            if NodeSet.cardinal exclude = 0 
            then available
            else filter_accessible available exclude c 
        in
        let card = NodeSet.cardinal accessible in
        let _ = 
            if card = 0 
            then failwith "Impossible de trouver une ville accessible." 
            else () in
        let i = Random.int card in
        let idx = get_ith i accessible in
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

    let distance_from_coordinates xu yu xv yv =
        ((xu -. xv) *. (xu -. xv) +. (yu -. yv) *. (yu -. yv)) ** (1. /. 2.)

    let distance u v c =
        if u = v then 0.0 
        else if mem_broken_road (u, v) c 
        then
            let _ = 
                if Config.debug then
                    Printf.printf "Warning: Infinity between %d %s and %d %s\n" u (get_name u c) v (get_name v c) 
                else () 
            in infinity 
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
        let rec aux i villes carte indices =
            match villes with
            | [] -> carte, indices
            | (n, x, y)::t -> 
                let carte', indices' = aux (i + 1) t carte indices in
                add_node i n x y carte', WordMap.add n i indices'
            in aux 0 villes carte WordMap.empty

    let indices_destinations destinations indices : NodeSet.t = 
        WordSet.fold
        (
            fun destination s -> 
                let indice_dest = WordMap.find destination indices in 
                NodeSet.add indice_dest s
        ) 
        destinations NodeSet.empty

    let make_road_map (roads : word_set WordMap.t) (indices : int WordMap.t) : ind_road_map =
        WordMap.fold 
        (
            fun origine destinations acc ->
                let indice_origine : int = WordMap.find origine indices in 
                let ind_destinations = indices_destinations destinations indices in 
                let res = IntMap.add (indice_origine) (ind_destinations) acc in 
                res
        ) 
        roads IntMap.empty

    let make_carte_from_cities_and_roads cities roads =
        let c, indices = add_cities cities empty in 
        let road_map = make_road_map roads indices in 
        { 
            cities = c.cities;
            roads = road_map;
        }

    let make_carte_from_cities cities = make_carte_from_cities_and_roads cities WordMap.empty

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

    let get_coordinates idx c =
        try
            let (_, coord) = find idx c in coord
        with Not_found -> raise NotInCarte
end