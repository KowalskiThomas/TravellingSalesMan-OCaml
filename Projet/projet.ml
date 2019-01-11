module Carte = ICarte.Carte
module Optimizer = IOptimizer.Optimizer
module Parser = IParser.Parser
open Parser (* Pour éviter les warnings liés aux records *)
module MLLPath = IMLLPath.MLLPath

type config = Parser.config

(* On charge les villes *)
let villes, routes = Parser.parse_input_file "villes.complete.txt"
(* On charge la configuration *)
let config = Parser.parse_config_file "config.txt"
(* On créé la carte à partir de la liste d'infos *)
let carte = Carte.make_carte_from_cities_and_roads villes routes

(* On unpack la configuration *)
let mode, insertion, optimization = 
  match config with
  {
    mode = m;
    insertion = i;
    optimization = o;
  } -> m, i, o

(* On affiche la configuration si en mode debug *)
let _ = 
  if Config.debug then
    Printf.printf "Mode: %s, Insertion: %s, Optimization: %s\n" mode insertion optimization
  else ()

(* On choisit la fonction d'insertion *)
let insertion_function = 
  if insertion = "FARTHEST"
  then Optimizer.build_solution_farthest
  else if insertion = "NEAREST"
  then Optimizer.build_solution_nearest
  else if insertion = "RANDOM"
  then Optimizer.build_solution_random
  else failwith "Invalid insertion mode option"

(* On choisit la fonction de chemin initial *)
let initial_path_function = 
  if mode = "ONE"
  then Optimizer.random_point_initial_path
  else if mode = "HULL"
  then Optimizer.hull_initial_path
  else failwith "Invalid initial path option"

(* On choisit la fonction d'optimisation *)
let optimizer =
  if optimization = "INVERSION"
  then Optimizer.inversion_n_fois
  else if optimization = "REPOSITIONNEMENT"
  then Optimizer.repositionnement_n_fois
  else failwith "Invalid optimizer option"

(* On construit la solution *)
let solution = Optimizer.find_solution initial_path_function insertion_function optimizer carte

(* On affiche la solution *)
let _ = MLLPath.print_distance_names solution carte