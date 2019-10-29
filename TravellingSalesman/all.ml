module Carte = ICarte.Carte
module Optimizer = IOptimizer.Optimizer
module Parser = IParser.Parser
open Parser (* Pour éviter les warnings liés aux records *)
module MLLPath = IMLLPath.MLLPath
module Execution = IExecution

type config = Parser.config

let fichier = 
  if Array.length Sys.argv < 2
  then Config.default_file
  else Sys.argv.(1)

let _ = Printf.printf "Fichier de villes: '%s'\n" fichier

let b = Sys.time ()
(* On charge les villes *)
let villes, routes = Parser.parse_input_file fichier
(* On charge la configuration *)
let e = Sys.time () 
let _ = 
  if Config.debug then 
    Printf.printf "Chargement villes (%s) : %f\n" fichier (e -. b)
  else
    ()

(* On créé la carte à partir de la liste d'infos *)
let carte = Carte.make_carte_from_cities_and_roads villes routes

let optimizations = ["INVERSION"; "REPOSITIONNEMENT"] 
let builders = ["NEAREST"; "FARTHEST"; "RANDOM"]
let initial = ["ONE"; "HULL"]

let _ = 
  List.iter 
  (
    fun optimization -> List.iter 
    (
      fun builder -> List.iter  
      (
        fun init -> 
          let _ = Printf.printf "----------\n" in 
          let _ = Printf.printf "%s / %s / %s\n" init builder optimization in 
          let b = Sys.time () in 
          let _ = Execution.executer init builder optimization carte in
          let e = Sys.time () in
          let _ = Printf.printf "Temps: %f\n" (e -. b) in
          ()
      ) initial
    ) builders
  ) optimizations