module ConvexHull = struct
  module Carte = ICarte.CompleteCarte
  type carte = Carte.carte
  type node = Carte.node
  type city_list_entry = Carte.node * Carte.pair
  type hull = city_list_entry list 

  let rec print_hull h = match h with
    | [] -> Printf.printf "[Empty Hull]\n"
    | [(_, (name, _))] -> Printf.printf "%s\n" name 
    | (_, (name, _))::t -> 
      let _ = Printf.printf "%s, " name in
      print_hull t

  let rec in_hull h city_name = match h with
    | [] -> false
    | (_, (name, _))::t -> 
      if name = city_name 
      then true
      else in_hull t city_name

  let ccw (_, (_, (x1, y1))) (_, (_, (x2, y2))) (_, (_, (x3, y3))) = 
    (x2 -. x1) *. (y3 -. y1) -. (y2 -. y1) *. (x3 -. x1)

  let transform_list (l : city_list_entry list) : (city_list_entry list) = 
    let rec aux 
      (l : city_list_entry list) 
      (m : city_list_entry) 
      : (city_list_entry list * city_list_entry) = 
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
      back_in_list::sorted_end, min_end
    in 
    let first_elt = List.hd l in 
    let l' = List.tl l in 
    let l, m = aux l' first_elt in 
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

  let sort_list_by_angle (orig : city_list_entry) (l : city_list_entry list) = List.sort 
        (fun x y -> compare orig x y) l 

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
    (* let _ = Printf.printf "Villes:\n" in  *)
    (* let _ = print_hull cities_list in  *)
    let cities_list = transform_list cities_list in 
    (* let _ = Printf.printf "After select first:\n" in  *)
    (* let _ = print_hull cities_list in  *)
    match cities_list with
    | [] -> 
      (* let _ = Printf.printf "Empty list\n" in  *)
      []
    | [e] -> 
      (* let _ = Printf.printf "Only one element!\n" in  *)
      [e]
    | orig::p::[] -> 
      (* let _ = Printf.printf "Only two elements!\n" in *)
      cities_list
    | orig::l' ->
      let idx, (name, (x, y)) = orig in 
      (* let _ = Printf.printf "Origin: %s\n" name in 
      let _ = Printf.printf "Villes qui restent:\n" in  *)
      (* let _ = print_hull l' in  *)
      let l'' = sort_list_by_angle orig l' in 
      (* let _ = Printf.printf "Après tri:\n" in        *)
      (* let _ = print_hull l'' in  *)
      match l'' with
      | [] -> l''
      | p1::l'' -> 
        let stack = p1::orig::[] in 
        build_hull l'' stack   
        
  let rec to_indices h = match h with
    | [] -> []
    | (idx, _)::t -> idx::(to_indices t)
end