open List

type int_set = int list

exception EmptySet

let empty = []

let is_empty s = s = []

let rec mem e s =
  match s with
    | [] -> false
    | h::t -> s = t || if e < h then false else mem e t

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
      | h::t ->
        if e > h
          then s
        else
          e::(remove e t)

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