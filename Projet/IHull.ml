module ConvexHull = struct
  module Carte = ICarte.CompleteCarte
  type carte = Carte.carte
  type node = Carte.node
  type city_list_entry = Carte.node * Carte.pair

  let ccw (_, (_, (x1, y1))) (_, (_, (x2, y2))) (_, (_, (x3, y3))) = 
    (x2 -. x1) *. (y3 -. y1) -. (y2 -. y1) *. (x3 -. x1)

  let transform_list (l : city_list_entry list) : (city_list_entry list) = 
    let rec aux (l : city_list_entry list) (m : city_list_entry) : (city_list_entry list * city_list_entry) = 
    let min_idx, (min_name, (min_x, min_y)) = m in  
    match l with
    | [] -> [], m
    | ((_, (_, (x, y))) as elt)::q -> 
      let new_min, back_in_list = 
        if y < min_y 
        then elt, m
        else m, elt 
      in
      let sorted_end, min_end = aux q new_min in
      m::sorted_end, min_end
    in 
    let l, m = aux l (-1, ("", (infinity, infinity))) in 
    m::l
      
  let orient (x1, y1) (x2, y2) (x3, y3) = 
    let test = (y2 -. y1) *. (x3 -. x2) -. (x2 -. x1) *. (y3 -. y2) in 
    if test = 0. 
    then 0
    else if test > 0.
    then 1 
    else 2

  let squared_dist (x1, y1) (x2, y2) = 
    (x1 -. x2) *. (x1 -. x2) +. (y1 -. y2) *. (y1 -. y2)

  let compare orig p1 p2 = 
    let _, (_, pair_orig) = orig in 
    let _, (_, pair1) = p1 in 
    let _, (_, pair2) = p2 in 
    let o = orient pair_orig pair1 pair2 in 
    if o = 0 
    then 
      if squared_dist pair_orig pair2 >= squared_dist pair_orig pair1
      then -1
      else 1
    else if o == 2 
    then -1
    else 1

  let sort_list_by_angle (orig : city_list_entry) (l : city_list_entry list) = 
    match l with
    | [] -> []
    | [e] -> [e]
    | p0::l' -> 
      List.sort 
        (fun x y -> compare p0 x y) l 

  let rec pop_stack (stack : city_list_entry list) (point : city_list_entry) : (city_list_entry list) = 
    match stack with
    | [] -> []
    | [e] -> [e]
    | e1::e2::t -> 
      if ccw e2 e1 point <= 0.
      then pop_stack (e2::t) point
      else stack

  let rec build_hull l stack = 
    match l with
    | [] -> stack
    | h::t -> 
      let stack' = pop_stack stack h in 
      build_hull t (h::stack')

  let rec convex_hull c =
    let cities_list = Carte.bindings c in 
    let cities_list = transform_list cities_list in 
    match cities_list with
    | [] -> []
    | [e] -> [e]
    | orig::p::[] -> cities_list
    | orig::p1::l' ->
      let l'' = sort_list_by_angle orig l' in 
      let stack = p1::orig::[] in 
      build_hull l'' stack       
end