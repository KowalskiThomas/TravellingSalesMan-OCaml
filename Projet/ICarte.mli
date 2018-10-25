(* module type Carte = sig
    type node
    (* module S : Map.S with type key = node *)
    type graph 

    val distance : node -> node -> graph -> float
    val distance_path : node list -> graph -> float
    val empty : graph
end *)

module CompleteCarte : sig
    type node
    type pair
    type graph 

    val distance : int -> int -> graph -> float

    val distance_path : int list -> graph -> float

    val empty : graph

    val add_node : int -> string -> float -> float -> graph -> graph
end