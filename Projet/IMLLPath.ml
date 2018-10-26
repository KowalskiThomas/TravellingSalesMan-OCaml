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

    let swap u v p =
        if u = v
        then p
        else
            (* TODO: Possible optimization (if u -> v or v -> u *)
            let (last_u, next_u) = IntMap.find u p in
            let (last_v, next_v) = IntMap.find v p in
            let (last_last_u, _) = IntMap.find last_u p in
            let (_, next_next_u) = IntMap.find next_u p in
            let (last_last_v, _) = IntMap.find last_v p in
            let (_, next_next_v) = IntMap.find next_v p in
            IntMap.add v (last_u, next_u)
            (IntMap.add last_u (last_last_u, v)
            (IntMap.add next_u (v, next_next_u)
            (IntMap.add u (last_v, next_v)
            (IntMap.add last_v (last_last_v, u)
            (IntMap.add next_v (u, next_next_v) p)))))

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
    exception NotInPath
    (* Insert a new node in the path *)
    (* Example: insert u [after] last [in] p *)
    
    let insert_in_unary u last p = 
        IntMap.add u (last, last) (IntMap.add last (u, u) IntMap.empty)

    let insert_in_binary u last p = 
        let (v, _) = IntMap.find last p in 
        IntMap.add last (v, u) 
        (IntMap.add u (last, v) 
        (IntMap.add v (u, last) IntMap.empty))

    let insert u last p =
        if mem u p
        then raise AlreadyInPath
        else
            let (last_last, last_next) = IntMap.find last p in
            if last_last = last then
                insert_in_unary u last p
            else if last_last = last_next then
                insert_in_binary u last p 
            else 
                let (_, last_next_next) = IntMap.find last_next p in
                IntMap.add
                    last (last_last, u)
                    (IntMap.add u (last, last_next)
                    (IntMap.add last_next (u, last_next_next) p))

    let remove_standard u p =
        let (last, next) = IntMap.find u p in
        let (last_last, _) = IntMap.find last p in
        let (_, next_next) = IntMap.find next p in
        IntMap.add last (last_last, next)
        (IntMap.add next (last, next_next)
        (IntMap.remove u p))

    let make u =
        IntMap.add u (u, u) empty

    let remove_two u p =
        (*
         * Seulement deux éléments dans le chemin
         * On veut enlever 1
         * Si on part de 1 -> 2 -> 1
         * On renvoie 2
         *)
        let (last, next) = IntMap.find u p in
            (* let _ = Printf.printf "last : %d next : %d u : %d\n" last next u in  *)
            make last

    let remove u p =
        if not (mem u p)
        then raise NotInPath
        else
            let (last, next) = IntMap.find u p in
            (* let _ = Printf.printf "u = %d last = %d next = %d\n" u last next in  *)
            if last = u && next = u then
                empty
            else if last = next then
                remove_two u p
            else
                remove_standard u p
end