module Carte = ICarte.Carte
module Optimizer = IOptimizer.Optimizer
module Parser = IParser.Parser
open Parser (* Pour éviter les warnings liés aux records *)
module MLLPath = IMLLPath.MLLPath

let executer mode insertion optimization carte = 
  (* On affiche la configuration si en mode debug *)
  let _ = 
    if Config.debug then
      Printf.printf "Mode: %s, Insertion: %s, Optimization: %s\n" mode insertion optimization
    else () in 

  (* On choisit la fonction d'insertion *)
  let insertion_function = 
    if insertion = "FARTHEST"
    then Optimizer.build_solution_farthest
    else if insertion = "NEAREST"
    then Optimizer.build_solution_nearest
    else if insertion = "RANDOM"
    then Optimizer.build_solution_random
    else failwith "Invalid insertion mode option" in

  (* On choisit la fonction de chemin initial *)
  let initial_path_function = 
    if mode = "ONE"
    then Optimizer.random_point_initial_path
    else if mode = "HULL"
    then Optimizer.hull_initial_path
    else failwith "Invalid initial path option" in

  (* On choisit la fonction d'optimisation *)
  let optimizer =
    if optimization = "INVERSION"
    then Optimizer.inversion_n_fois
    else if optimization = "REPOSITIONNEMENT"
    then Optimizer.repositionnement_n_fois
    else failwith "Invalid optimizer option" in

  (* On construit la solution *)
  let solution = Optimizer.find_solution initial_path_function insertion_function optimizer carte in

  (* On affiche la solution *)
  let _ = MLLPath.print_distance_names solution carte in
  ()
