(*
    A map that represents a path
    Each element is a pair (last, next)
    So it is a kind of linked-list though the access to the elements is in a way better complexity
*)

module MLLPath : sig
    type node = int
    type value
    type path

    exception AlreadyInPath
    exception NotInPath

    val empty : path
    val is_empty : path -> bool

    val swap : node -> node -> path -> path

    (* val set_next : node -> node -> path -> path
    val set_last : node -> node -> path -> path *)

    val get_next : node -> path -> node
    val get_last : node -> path -> node

    val mem : node -> path -> bool

    (* Insert a new node in the path *)
    (* Example: insert u [after] last [in] g *)
    val insert : node -> node -> path -> path

    val remove : node -> path -> path

    val make : int -> path
end