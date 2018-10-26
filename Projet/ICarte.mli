(* module type Carte = sig
    type node
    (* module S : Map.S with type key = node *)
    type graph

    val distance : node -> node -> graph -> float
    val distance_path : node list -> graph -> float
    val empty : graph
end *)

module CompleteCarte : sig
    module Node : sig
        type t
        val compare : int -> int -> int
    end
    type node = int
    type pair
    type graph

    val distance_squared : node -> node -> graph -> float
    val distance : node -> node -> graph -> float

    val distance_path : node list -> graph -> float

    val empty : graph

    val add_node : int -> string -> float -> float -> graph -> graph
end