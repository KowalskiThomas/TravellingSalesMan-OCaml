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
        type t = int
        val compare : int -> int -> int
    end

    type node = int
    module NodeSet : Set.S with type elt = node
    type node_set = NodeSet.t

    type pair = string * (float * float)
    type graph

    val find : node -> graph -> pair

    val distance_from_coordinates : float -> float -> float -> float -> float
    val distance : node -> node -> graph -> float
    val distance_rooted : node -> node -> graph -> float
    val distance_path : node list -> graph -> float

    val find_nearest : node -> node_set -> graph -> (node * float) 

    val empty : graph

    val add_node : int -> string -> float -> float -> graph -> graph

    val fold : (node -> pair -> 'a -> 'a) -> graph -> 'a -> 'a
    val bindings : graph -> (node * pair) list
    val get_random : graph -> (node * pair)

    val print : graph -> unit
end