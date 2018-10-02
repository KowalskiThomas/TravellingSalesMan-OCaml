module type Ordered =
  sig
    type t

    val compare : t -> t -> int
  end

module type Ensemble =
  sig
    type set
    type elt

    val empty : set
    val is_empty : set -> bool
    val add : elt -> set -> set
    val mem : elt -> set -> bool
    val get_min : set -> elt
  end

module MakeEnsembleListe(X:Ordered) =
  struct
    type set = X.t list
    type elt = X.t

    let empty = []
    let is_empty s = s = empty
    let rec add x s = match s with
    | [] -> [x]
    | h::s' -> if x > h then add x s' else x::(h::s')
    let rec mem x s = match s with
    | [] -> false
    | h::s' -> let c = X.compare x h in
      if c < 0 then false else c = 0 || mem x s'
    let get_min s = match s with
    | [] -> raise Not_found
    | h::_ -> h
  end

module MakeEnsembleAVL(X:Ordered) =
  struct
    type 'a avl = Empty | Node of 'a avl * 'a * 'a avl * int
    type set = X.t avl
    type elt = X.t

    let empty = Empty
    let is_empty s = s = empty

    let height n = match n with
    | Empty -> 0
    | Node(_, _, _, h) -> h

    let node left middle right =
      let m = max (height left) (height right) in
      Node(left, middle, right, m + 1)

    exception InSet

    let equilibrer a = match a with
      | Empty -> Empty
      | Node(g, x, d, h) ->
        let hg = height g in
        let hd = height d in
        if hg > hd + 1 then
          match g with
            | Empty -> assert false
            | Node(gg, xg, gd, _) ->
              let hgg = height gg in
              let hgd = height gd in
              if hgg > hgd
              then (node gg xg (node gd x d))
              else
                match gd with
                  | Empty -> assert false (* hgd > 0 *)
                  | Node (gdg, xgd, gdd, _) ->
                    node (node gg xg gdg) xgd (node gdd x d)
        else if hd > hg + 1
        then failwith "todo"
        else node g x d

    (* let equilibrer a = match a with
      | Empty -> Empty
      | Node(l, v, r, _) ->
        (
          match l, r with
          | Empty, _ -> failwith "Unexpected Empty"
          | _, Empty -> failwith "Unexpected Empty"
          | Node(ll, lv, lr, _), Node(rl, rv, rr, _) ->
            (
              if height ll = height r + 1 then
                node ll lv (node lr v r)
              else if height rr = height l + 1 then
                node (node l v rl) rv rr
              else
                match lr with
                  | Empty -> failwith "Unexpected Empty"
                  | Node(lrl, lrv, lrr, _) ->
                    (
                      if height r = height lrl && height lrl = height ll then
                        node (node ll lv lrl) lrv (node lrr v r)
                      else match rl with
                        | Empty -> failwith "Unexpected Empty"
                        | Node(rll, rlv, rlr, _) ->
                          if height l = height rlr && height rlr = height rr then
                            node (node l v rll) rlv (node rlr rv rr)
                          else failwith "Unexpected Else"
                    )
            )
        ) *)

    let rec desequilibre left right = match left, right with
      | Empty, Empty -> false
      | Empty, Node(_, _, _, h) -> h >= 2
      | Node(_, _, _, _), Empty -> desequilibre right left
      | Node(_, _, _, hl), Node(_, _, _, hr) -> (max hr hl) - (min hr hl) >= 2

    let rec add_aux x s =
      match s with
      | Empty -> node Empty x Empty
      | Node(left, middle, right, _) ->
        let c = compare x middle in
        begin
          if c = 0 then raise InSet
          else if c < 0 then
            begin
              let resultat = add_aux x left in
                if desequilibre resultat right then
                  equilibrer (node right middle resultat)
                else
                  node right middle resultat
            end
          else (* c > 0 *)
            begin
              let resultat = add_aux x right in
              if desequilibre resultat left then
                equilibrer (node left middle resultat)
              else
                node left middle resultat
            end
        end

    let add x s =
      try
        add_aux x s
      with InSet -> s


    let rec mem x s = match s with
      | Empty -> false
      | Node(left, v, right, _) ->
        let c = X.compare x v in
          begin
            if c = 0
            then true
            else if c < 0
            then mem x left
            else mem x right
          end

    let rec get_min s = match s with
      | Empty -> raise Not_found
      | Node(Empty, v, _, _) -> v
      | Node(left, _, _, _) -> get_min left
  end