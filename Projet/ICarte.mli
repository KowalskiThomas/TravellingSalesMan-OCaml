module CompleteCarte : sig
    module Node : sig
        type t = int
        val compare : int -> int -> int
    end

    type node = int
    module NodeSet : Set.S with type elt = node
    type node_set = NodeSet.t

    type pair = string * (float * float)
    type carte

    val find : node -> carte -> pair

    val distance_from_coordinates : float -> float -> float -> float -> float
    val distance : node -> node -> carte -> float
    val distance_rooted : node -> node -> carte -> float
    val distance_path : node list -> carte -> float

    val find_nearest : node -> node_set -> carte -> (node * float) 
    val find_farthest : node -> node_set -> carte -> (node * float) 

    val empty : carte

    val add_node : int -> string -> float -> float -> carte -> carte

    val fold : (node -> pair -> 'a -> 'a) -> carte -> 'a -> 'a
    val bindings : carte -> (node * pair) list
    val get_random : carte -> (node * pair)

    val print : carte -> unit
end