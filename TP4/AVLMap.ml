open Map
open Set

module AVLMap(X : Ordered, Y) : Map with type key = X.t with type elt = Y =
  struct
    type key
    type 'a pmap

    type 'a pmap =
        Empty
      | Node of ('a pmap * (X.t * 'a) * 'a pmap * int)

    exception EmptyAVL

    let empty = Empty

    let is_empty a = a = empty

    let height a = match a with
      | Empty -> 0
      | Node(_, _, _, h) -> h

    let node l k v r = Node(l, (k, v), r, (max (height l) (height r))

    exception AlreadyInSet

    let add_aux a k v = match a with
      | Empty -> node empty x empty
      | Node(l, (x1, x2), r) ->
        let c = X.compare x m in
        if c = 0 then
          raise AlreadyInSet
        else if c < 0 then
          balance (add_aux l k v)
        else balance (add_aux r k v)

      exception NotInSet

      let rec find a k = match a with
        | Empty -> raise NotInSet
        | Node(l, (x, v), r) =
          let c = X.compare x k
          if c = 0
          then v
          else if c < 0
          then find left k
          else find right k


    let add a x =
      try
        add_aux a x
      with AlreadyInSet -> a


  end