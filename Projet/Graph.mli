module type Graph = sig
    type node
    (* module S : Map.S with type key = node *)
    type graph 

    val distance : node -> node -> graph -> float
    val distance_path : node list -> graph -> float
    val empty : graph
end