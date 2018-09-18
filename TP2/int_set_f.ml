exception EmptySet
exception NotInSet
exception AlreadyInSet

module type IntSet =
  sig
    (** Ensembles d'entiers
    Ce module d?fini une structure d'ensembles d'entiers.
    *)

    (** exception lev?e si l'on tente de deconstruire un ensemble vide *)

    type int_set

    (** type ABSTRAIT (ne pas modifier cette ligne !) des ensemble d'entiers *)

    val is_empty : int_set -> bool
    (** [is_empty s] teste si  [s] est vide *)

    val print : int_set -> unit

    val empty : int_set
    (** L'ensemble vide.

        Rq:
        is_empty empty = true
    *)


    val mem : int -> int_set -> bool
    (**
      [mem e s] teste si [e] est un ?l?ment de [s]

      Rq:
        1- \forall n s, is_empty s -> mem n s = false.
        2- \forall n, mem n empty = false
    *)


    val add : int -> int_set -> int_set
    (** [add e s] retourne l'ensemble [s] augment? de l'?l?ment [e]

        Rq :
        1- \forall n s, is_empty (add n s) = false
        2- \forall n s, mem n (add n s) = true
        3- \forall n m s, mem m s = true -> mem m (add n s) = true
    *)


    val fold : (int -> 'a -> 'a) -> int_set -> 'a -> 'a
    (** [fold f s v0] calcule [(f xN ... (f x2 (f x1 v0)))] o? [x1 ... xN] sont les ?l?ments de [s] par ordre croissant *)

    val get_min : int_set -> int
    (** [get_min s] retourne le plus petit ?l?ment de [s]
    L?ve [EmptySet] si [s] est vide
    *)

    val equal : int_set -> int_set -> bool
    (** [equal s t] test si les ensembles [s] et [t] sont ?gaux (i.e. contiennent EXACTEMENT les m?mes ?l?ments)
    *)

    val remove : int -> int_set -> int_set
    (** [remove e s] retourne l'ensemble [s] dont on a retir? l'?l?ment [e]

    Rq:
    1- \forall n m s, mem m (remove n s) = true -> mem m s =true /\ m <> n
    2- \forall n s, mem n s = false -> equal s (remove n s)

    *)

    val union : int_set -> int_set -> int_set
    (** [union s t] retourne l'union des ensemble [s] et [t]

        Rq:
    1- \forall n s t, mem n (union s t) = true <-> (mem n s=true \/ me n t = true)
    2- \forall s, equal (union empty s) s /\ equal (union s empty) s
    *)
  end

module IntSetList =
  struct
    open List

    type int_set = int list

    let empty = []

    let is_empty s = s = []

    let rec print s = 
      match s with
      | [] -> Format.printf "\n"
      | h::t -> Format.printf " %d " h; print t

    let rec mem e s =
      match s with
        | [] -> false
        | h::t -> 
          if h = e
          then true
          else if e < h 
          then false 
          else mem e t

    let rec equal s t =
      match s, t with
        | [], [] -> true
        | [], _ -> false
        | _, [] -> false
        | (h1::t1), (h2::t2) ->
          if h1 = h2 then
            equal t1 t2
          else
            false

    let rec add e s =
      match s with
        | [] -> [e]
        | h::t ->
          if e = h then h::t
          else
            if e > h then h::(add e t)
            else e::(h::t)

    let union s1 s2 =
      let rec helper s1 s2 acc =
        match s1, s2 with
        | [], [] -> acc
        | [], s -> helper s [] acc
        | h::t, [] -> helper t [] (h::acc)
        | h1::t1, h2::t2 ->
          if h1 = h2
            then helper t1 t2 (h1::acc)
          else
            if h1 > h2 then
              helper t1 s2 (h1::acc)
            else
              helper s1 t2 (h2::acc)

      in helper s1 s2 []

    let rec remove e s =
        match s with
          | [] -> []
          | h::s' ->
            if e = h 
            then s'
            else if e > h
              then s
            else
              e::(remove e s')

    let fold f s a =
      let rec helper f s acc =
        match s with
        | [] -> acc
        | h::t -> helper f t (f h acc)
      in helper f s a

    let get_min s =
      if equal s empty then
        raise EmptySet
      else
        List.hd s
  end


module IntSetIntervals =
  struct
    type int_set = (int * int) list

    let empty = []

    let equal s s' = s = s'

    let is_empty s = equal s empty

    let rec print_between a b = 
      if a > b then () 
      else begin Format.printf " %d " a; print_between (a + 1) b end

    let rec print s = 
      match s with
      | [] -> Format.printf "\n"
      | (a, b)::s' -> begin print_between a b; print s' end

    let rec add_aux v s =
      match s with
      | [] -> [(v, v)]
      | (a, b)::s' ->
        if v < a - 1
        then (v, v)::(a, b)::s'
        else if v = a - 1
        then (v, b)::s'
        else if v >= a && v <= b
        then raise AlreadyInSet
        else if v > b + 1
        then add_aux v s'
        else (* v = b + 1 *)
          match s' with
            | [] -> (a, v)::s'
            | (a', b')::s'' ->
              if v = a'
              then (a, b')::s''
              else (a, v)::(a', b')::s''

    let add v s =
      try
        add_aux v s
      with AlreadyInSet -> s

    let rec fold_between f v a b  =
      if a > b
      then v
      else
        let v' = f a v in
        fold_between f v' (a + 1) b

    let fold f s v  =
      List.fold_left(fun acc(a, b) -> fold_between f acc a b) v s

    let union s1 s2 =
      fold (fun v s -> add v s) s1 s2

    let rec mem v s =
      match s with
      | [] -> false
      | (a, b)::s' ->
        if v < a then false
        else if v <= b then true
        else mem v s'

    let get_min s =
      match s with
      | [] -> raise EmptySet
      | (a, _)::_ -> a


    let rec remove_aux v s =
      match s with
      | [] -> raise NotInSet
      | (a, b)::s' ->
        if v < a then raise NotInSet
        else if v = a then (a + 1, b)::s'
        else if v < b then (a, v - 1)::(v + 1, b)::s'
        else if v = b then (a, b - 1)::s'
        else (* v > b *) remove_aux v s'

    let remove v s = 
      try
        remove_aux v s
      with NotInSet -> s

  end

module IntSetAbr =
  struct
    type 'a abr = Nil | ABR of 'a abr * 'a * 'a abr

    type int_set = int abr

    let empty = Nil

    let rec mem v s =
      match s with
      | Nil -> false
      | ABR(left, x, right) ->
      if v = x
      then true
      else if v > x then mem v right
      else (* v < x *)   mem v left

    let rec contains s s' = 
      match s with
      | Nil -> true
      | ABR(left, x, right) -> mem x s' && contains s left && contains s right

    let equal s s' = 
      match s, s' with
      | Nil, Nil -> true
      | Nil, _ -> false
      | _, Nil -> false
      | s, s' -> contains s s' && contains s' s

    let is_empty s = equal s empty

    let rec add_aux v s =
      match s with
      | Nil -> ABR(Nil, v, Nil)
      | ABR(left, x, right) ->
      if v = x then raise AlreadyInSet
      else if v > x then ABR(left, x, add_aux v right)
      else (* v < x *) ABR(add_aux v left, x, right)

    let add v s =
      try
        add_aux v s
      with AlreadyInSet -> s

    let rec fold f s v =
      match s with
      | Nil -> v
      | ABR(left, x, right) -> fold f right (f x (fold f left v))

    let union s1 s2 =
      fold (fun v s -> add v s) s1 s2

    let rec merge s s' =
      match s with
      | Nil -> s'
      | ABR(left, x, right) -> merge (merge (add x s) left) right

    let rec union s s' =
      match s, s' with
      | Nil, Nil -> Nil
      | Nil, _ -> union s' s
      | _, Nil -> s
      | s, s' -> merge s s'

    let rec get_min s =
      match s with
      | Nil -> raise EmptySet
      | ABR(Nil, x, Nil) -> x
      | ABR(Nil, _, right) -> get_min right
      | ABR(left, _, _) -> get_min left

    let rec remove_aux v s =
      match s with
      | Nil -> raise NotInSet
      | ABR(left, x, right) ->
        if x = v then
          match right with
          | Nil -> left
          | _ ->
            let m = get_min right in
            ABR(left, m, remove_aux m right)
        else
          if x > v then ABR(remove_aux v left, x, right)
          else (* x < v *) ABR(left, x, remove_aux v right)

    let rec remove v s =
      try
        remove_aux v s
      with NotInSet -> s

    let rec print s = 
      match s with 
      | Nil -> ()
      | ABR(left, x, right) -> print left; Format.printf " %d " x; print right;

  end