open Map
open Ensemble

module AVLMap(X : Ordered) : Map with type key = X.t =
  struct
    type key = X.t

    type 'a pmap =
        Empty
      | Node of ('a pmap * (X.t * 'a) * 'a pmap * int)

    exception EmptyAVL
    exception NotInSet
    exception AlreadyInSet

    let empty = Empty

    let is_empty a = a = empty

    let height a = match a with
      | Empty -> 0
      | Node(_, _, _, h) -> h

    let node l k v r = Node(l, (k, v), r, (max (height l) (height r)))


    let rec find a x = match a with
      | Empty -> raise NotInSet
      | Node(l, (v, d), r, h) ->
        let c = X.compare x v in
        if c = 0
        then d
        else if c < 0
        then find l x
        else find r x

    let balance l x d r =
      let hl = match l with
        | Empty -> 0
        | Node (_, _, _, h) -> h in

      let hr = match r with
        | Empty -> 0
        | Node (_, _, _, h) -> h in

      if hl > hr + 2 then begin
        match l with
          Empty -> invalid_arg "Map.bal"
        | Node(ll, (lv, ld), lr, _) ->
            if height ll >= height lr then
              node ll lv ld (node lr x d r)
            else begin
              match lr with
                Empty -> invalid_arg "Map.bal"
              | Node(lrl, (lrv, lrd), lrr, _)->
                  node (node ll lv ld lrl) lrv lrd (node lrr x d r)
            end
      end else if hr > hl + 2 then begin
        match r with
          Empty -> invalid_arg "Map.bal"
        | Node(rl, (rv, rd), rr, _) ->
            if height rr >= height rl then
              node (node l x d rl) rv rd rr
            else begin
              match rl with
                Empty -> invalid_arg "Map.bal"
              | Node(rll, (rlv, rld), rlr, h) ->
                  node (node l x d rll) rlv rld (node rlr rv rd rr)
            end
      end
      else Node(l, (x, d), r, (if hl >= hr then hl + 1 else hr + 1))

      let rec add x data m = match m with
      | Empty ->
          Node(Empty, (x, data), Empty, 1)
      | Node (l, (v, d), r, h) ->
          let c = X.compare x v in
          if c = 0 then
            if d == data then m else Node(l, (x, data), r, h)
          else if c < 0 then
            let ll = add x data l in
            if l == ll then m else balance ll v d r
          else
            let rr = add x data r in
            if r == rr then m else balance l v d rr

      let rec min_key m = match m with
        | Empty -> raise EmptyAVL
        | Node(Empty, x, _, _) -> x
        | Node(l, _, _, _) -> min_key l

      let rec remove_min_key m = match m with
        | Empty -> raise EmptyAVL
        | Node(Empty, _, r, _) -> r
        | Node(l, (v, d), r, _) -> balance (remove_min_key l) v d r

      let fusion m1 m2 = match (m1, m2) with
        | Empty, t -> t
        | t, Empty -> t
        | (_, _) -> let (x, d) = min_key m2 in
          balance m1 x d (remove_min_key m2)

      let rec remove x m = match m with
      | Empty -> Empty
      | Node(l, (v, d), r, h) ->
        let c = X.compare x v in
        if c = 0 then fusion l r
        else if c < 0 then
          let ll = remove x l in
          if l == ll
          then m
          else balance ll v d r
        else
          let rr = remove x r in
          if r == rr
          then m
          else balance l v d rr

      let rec fold f m x = match m with
      | Empty -> x
      | Node(l, (v, d), r, h) ->
        fold f r (f v d (fold f l x))

  end
(*
module MakeAVLMap(X:Ordered) : AVLMap with type key = X.t *)