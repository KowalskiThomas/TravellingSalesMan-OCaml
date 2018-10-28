(*
    A map that represents a path
    Each element is a pair (last, next)
    So it is a kind of linked-list though the access to the elements is in a way better complexity
*)

module MLLPath : sig
    module Carte = ICarte.CompleteCarte
    module NodeSet : Set.S
    type node = int
    type value
    type path

    exception AlreadyInPath
    exception NotInPath

    val empty : path
    val is_empty : path -> bool

    val swap : node -> node -> path -> path

    val get_next : node -> path -> node
    val get_last : node -> path -> node

    val print : path -> unit

    val mem : node -> path -> bool

    (* Insert a new node in the path *)
    (* Example: insert u [after] last [in] g *)
    val insert : node -> node -> path -> path

    (* Remove a node from the path *)
    val remove : node -> path -> path

    (* Constructs a path with only one city *)
    val make : node -> path

    (* Determines the length of a path *)
    val length : path -> Carte.carte -> float
    val to_set : path -> Carte.node_set
    val get_first : path -> node
    val insert_minimize_length : node -> path -> Carte.carte -> path
    val insert_random_minimize : path -> Carte.carte -> path

    val insert_nearest_minimize_length : path -> Carte.carte -> path
end