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

    let find u g = IntMap.find u g 
    
        let empty = IntMap.empty

    let add_node index name x y g =
        IntMap.add index (name, (x, y)) g

    let fold f c acc = IntMap.fold f c acc

    let bindings g = IntMap.bindings g

    let get_random g = IntMap.choose g 

    let print c = 
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

    let distance u v g =
        let data_u = IntMap.find u g in
        let data_v = IntMap.find v g in
        match data_u, data_v with
        | (_, (xu, yu)), (_, (xv, yv)) -> distance_from_coordinates xu yu xv yv

    let find_optimal f from exclude cities = 
        let (name_from, (x_from, y_from)) = IntMap.find from cities in 
        let rec aux bindings = match bindings with
            | [] -> failwith "No city found"
            | [index, (name, (x, y))] -> index, distance_from_coordinates x_from y_from x y 
            | (index, (name, (x, y)))::t -> 
                (* Si la ville en cours est à exlure *)
                if NodeSet.mem index exclude
                then aux t
                else 
                    let dist = distance_from_coordinates x_from y_from x y in
                    let (best_next, dist_next) = aux t in
                    if f dist_next dist
                    then index, dist
                    else best_next, dist_next
        in aux (bindings cities)

    let find_nearest from exclude cities = 
        let operator = (fun x y -> y < x) in 
        find_optimal operator from exclude cities

    let find_farthest from exclude cities = 
        let operator = (fun x y -> x < y) in 
        find_optimal operator from exclude cities

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

end