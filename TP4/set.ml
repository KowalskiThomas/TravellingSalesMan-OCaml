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