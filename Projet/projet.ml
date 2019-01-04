module Carte = ICarte.CompleteCarte
module Optimizer = IOptimizer.Optimizer
module Parser = IParser.Parser
open Parser (* Pour éviter les warnings liés aux records *)
module MLLPath = IMLLPath.MLLPath

type config = Parser.config

let villes = Parser.parse_input_file "villes.txt"
let config = Parser.parse_config_file "config.txt"
let carte = Carte.make_carte_from_cities villes

let mode, insertion, optimization = 
  match config with
  {
    mode = m;
    insertion = i;
    optimization = o;
  } -> m, i, o

let _ = 
  Printf.printf "Mode: %s, Insertion: %s, Optimization: %s\n" mode insertion optimization

let insertion_function = 
  if insertion = "FARTHEST"
  then Optimizer.build_solution_farthest
  else if insertion = "NEAREST"
  then Optimizer.build_solution_nearest
  else if insertion = "RANDOM"
  then Optimizer.build_solution_random
  else failwith "Invalid option"

let initial_path_function = 
  if mode = "ONE"
  then Optimizer.random_point_initial_path
  else if mode = "HULL"
  then Optimizer.hull_initial_path
  else failwith "Invalid option"

let optimizer =
  if optimization = "INVERSION"
  then Optimizer.inversion_n_fois
  else if optimization = "REPOSITIONNEMENT"
  then Optimizer.repositionnement_n_fois
  else failwith "Invalid option"

let solution = Optimizer.find_solution initial_path_function insertion_function optimizer carte

let _ = 
  MLLPath.print_with_names solution carte