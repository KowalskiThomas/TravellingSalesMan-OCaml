(*
    A map that represents a path
    Each element is a pair (last, next)
    So it is a kind of linked-list though the access to the elements is in a way better complexity
*)

(*
    A map that represents a path
    Each element is a pair (last, next)
    So it is a kind of linked-list though the access to the elements is in a way better complexity
*)

module MLLPath = struct
    module Node = struct
        type t = int
        let compare x y = x - y
    end

    type node = Node.t
    type value = int * int

    module IntMap = Map.Make(Node)

    type path = value IntMap.t

    let empty = IntMap.empty

    let is_empty p = IntMap.is_empty p

    (* exception NotInPath
    let set_next u next p =
        let data_next = IntMap.find next path in
        let IntMap.update u  path *)


    (* val set_last : key -> key -> path -> path *)

    let get_next u p =
        let (_, next) = IntMap.find u p in
        next

    let get_last u p =
        let (last, _) = IntMap.find u p in
        last

    (* let mem u p =
        let result = IntMap.find_opt u p in
        match result with
        | None -> false
        | Some _ -> true *)

    let mem u p = IntMap.mem u p

    exception AlreadyInPath
    (* Insert a new node in the path *)
    (* Example: insert u [after] last [in] p *)
    let insert u last p =
        if mem u p then raise AlreadyInPath else
        let (last_last, last_next) = IntMap.find last p in
        IntMap.add
            last (last_last, u)
            (IntMap.add u (last, last_next) p)

    let make u =
        IntMap.add u (u, u) empty
end