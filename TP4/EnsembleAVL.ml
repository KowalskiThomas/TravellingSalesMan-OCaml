open Ensemble

(* module type Ordered =
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
  end *)

module MakeEnsembleAVL(X: Ordered) : Ensemble with type elt = X.t = struct
  type key = X.t

  type set =
      Empty
    | Node of (set * X.t * set * int)

  exception EmptyAVL
  exception NotInSet
  exception AlreadyInSet

  let empty = Empty

  let rec mem s x = match s with
    | Empty -> false
    | Node(left, v, right, _) ->
      let c = X.compare x v in
      if c = 0
      then true
      else if c < 0
      then mem left x
      else mem right x

  let is_empty a = a = empty

  let height a = match a with
    | Empty -> 0
    | Node(_, _, _, h) -> h

  let node l v r = Node(l, v, r, (max (height l) (height r)))

  let balance l x r =
    let hl = match l with
      | Empty -> 0
      | Node (_, _, _, h) -> h in

  let hr = match r with
    | Empty -> 0
    | Node (_, _, _, h) -> h in

  if hl > hr + 2 then begin
    match l with
      Empty -> invalid_arg "Map.bal"
    | Node(ll, lv, lr, _) ->
        if height ll >= height lr then
          node ll lv (node lr x r)
        else begin
          match lr with
            Empty -> invalid_arg "Map.bal"
          | Node(lrl, lrv, lrr, _)->
              node (node ll lv lrl) lrv (node lrr x r)
        end
  end else if hr > hl + 2 then begin
    match r with
      Empty -> invalid_arg "Map.bal"
    | Node(rl, rv, rr, _) ->
        if height rr >= height rl then
          node (node l x rl) rv rr
        else begin
          match rl with
            Empty -> invalid_arg "Map.bal"
          | Node(rll, rlv, rlr, h) ->
              node (node l x rll) rlv (node rlr rv rr)
        end
  end
  else Node(l, x, r, (if hl >= hr then hl + 1 else hr + 1))

  let rec add x m = match m with
  | Empty ->
      Node(Empty, x, Empty, 1)
  | Node (l, v, r, h) ->
      let c = X.compare x v in
      if c = 0 then
        m
      else if c < 0 then
        let ll = add x l in
        if l == ll then m else balance ll v r
      else
        let rr = add x r in
        if r == rr then m else balance l v rr

  let rec min_key m = match m with
    | Empty -> raise EmptyAVL
    | Node(Empty, x, _, _) -> x
    | Node(l, _, _, _) -> min_key l

  let rec remove_min_key m = match m with
    | Empty -> raise EmptyAVL
    | Node(Empty, _, r, _) -> r
    | Node(l, v, r, _) -> balance (remove_min_key l) v r

  let fusion m1 m2 = match (m1, m2) with
    | Empty, t -> t
    | t, Empty -> t
    | (_, _) -> let x = min_key m2 in
      balance m1 x (remove_min_key m2)

  let rec remove x m = match m with
  | Empty -> Empty
  | Node(l, v, r, h) ->
    let c = X.compare x v in
    if c = 0 then fusion l r
    else if c < 0 then
      let ll = remove x l in
      if l == ll
      then m
      else balance ll v r
    else
      let rr = remove x r in
      if r == rr
      then m
      else balance l v rr

  let rec fold f m x = match m with
  | Empty -> x
  | Node(l, v, r, h) ->
    fold f r (f v (fold f l x))
end