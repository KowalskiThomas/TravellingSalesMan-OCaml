module type Carte = sig
    type node
    (* module S : Map.S with type key = node *)
    type graph 

    val distance : node -> node -> graph -> float
    val distance_path : node list -> graph -> float
    val empty : graph
end

module CompleteCarte = struct
    module Node = struct
        type t = int
        let compare x y = x - y
    end 
    type node = Node.t
    type pair = string * (float * float)

    module IntMap = Map.Make(Node)
    type graph = pair IntMap.t

    let distance u v g =
        let data_u = IntMap.find u g in
        let data_v = IntMap.find v g in 
        match data_u, data_v with
        | (_, (xu, yu)), (_, (xv, yv)) -> ((xu -. xv) *. (xu -. xv) +. (yu -. yv) *. (yu -. yv)) 

    let rec distance_path path g = match path with
    | [] -> 0.
    | h::t -> let data = IntMap.find h g in
        match data with
        | _, (x, y) -> x +. y +. (distance_path t g)

    let empty = IntMap.empty

    let add_node index name x y g = 
        IntMap.add index (name, (x, y)) g 
end