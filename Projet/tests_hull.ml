module Hull = IHull.ConvexHull
module Carte = ICarte.CompleteCarte

let _ = Random.self_init()

let test_facile = 
  let a = ("A", -1., 0.) in
  let b = ("B", 0., 1.) in
  let c = ("C", 1., 0.) in
  let d = ("D", 0., -1.) in 
  let cities = [a; b; c; d] in  
  let carte = Carte.make_carte_from_cities cities in 
  let hull = Hull.convex_hull carte in 
  let _ = Carte.print carte in 
  let _ =   Hull.print_hull hull in
  let verif = Hull.in_hull hull in
  let test_a = verif "A" in 
  let test_b = verif "B" in 
  let test_c = verif "C" in 
  let test_d = verif "D" in 
  if test_a && test_b && test_c && test_d then
    Printf.printf "OK Test facile\n" 
  else
    let _ = Printf.printf "XX Test facile\n" in
    let _ = exit 1 in
    ()

let test_un_point = 
  let a = ("A", -1., 0.) in
  let b = ("B", 0., 1.) in
  let c = ("C", 1., 0.) in
  let d = ("D", 0., -1.) in 
  let e = ("E", 0., 0.) in 
  let cities = [a; b; c; d; e] in  
  let carte = Carte.make_carte_from_cities cities in 
  let hull = Hull.convex_hull carte in 
  let _ = Carte.print carte in 
  let _ =   Hull.print_hull hull in
  let verif = Hull.in_hull hull in
  let test_a = verif "A" in 
  let test_b = verif "B" in 
  let test_c = verif "C" in 
  let test_d = verif "D" in 
  let test_e = not (verif "E") in 
  if test_a && test_b && test_c && test_d && test_e then
    Printf.printf "OK Test un point\n" 
  else
    let _ = Printf.printf "XX Test un point\n" in 
    let _ = exit 1 in
    ()

let test_plusieurs_points = 
  let a = ("A", -5., 0.) in
  let b = ("B", 2.5, 4.) in
  let c = ("C", 7., 0.) in
  let d = ("D", 4., -2.) in 
  let e = ("E", 0., 0.) in 
  let f = ("F", 2., 1.) in 
  let g = ("G", -2., 1.) in 
  let h = ("H", 3., -1.) in 
  let cities = [e; a; b; d; g; c; f; h] in  
  let carte = Carte.make_carte_from_cities cities in 
  let hull = Hull.convex_hull carte in 
  let _ = Carte.print carte in 
  let _ =   Hull.print_hull hull in
  let verif = Hull.in_hull hull in
  let test_a = verif "A" in 
  let test_b = verif "B" in 
  let test_c = verif "C" in 
  let test_d = verif "D" in 
  let test_e = not (verif "E") in 
  let test_f = not (verif "F") in 
  let test_g = not (verif "G") in 
  let test_h = not (verif "H") in 
  if test_a && test_b && test_c && test_d && test_e && test_f && test_g && test_h then
    Printf.printf "OK Test plusieurs points\n" 
  else
    let _ = Printf.printf "XX Test plusieurs points\n" in 
    let _ = exit 1 in
    ()


let rec monde_aleatoire n =
  if n = 0
  then []
  else ("City", (Random.float 100.), (Random.float 100.))::(monde_aleatoire (n - 1))

let test_rapidite = 
  let n = 10000 in
  let s = Sys.time() in 
  let monde = monde_aleatoire n in 
  let e = Sys.time() in
  let _ = Printf.printf "Génération monde: %f\n" (e -. s) in 
  
  let s = Sys.time() in 
  let monde = Carte.make_carte_from_cities monde in 
  let e = Sys.time() in 
  let _ = Printf.printf "Construction carte: %f\n" (e -. s) in 

  let s = Sys.time() in 
  let hull = Hull.convex_hull monde in 
  let e = Sys.time() in
  let _ = Printf.printf "Construction enveloppe convexe pour %d villes: %f\n" n (e -. s) in 
  ()