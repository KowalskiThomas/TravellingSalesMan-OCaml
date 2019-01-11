module Carte = ICarte.Carte

module Parser : sig
  exception FileNotFound of string
  exception SyntaxError of string * string  
  
  (* Le type des configurations, chaque entrée peut prendre les différents modes de création / optimisation de chemin. *)
  type config = {
    (* Le chemin initial (ONE ou HULL) *)
    mode : string;
    (* Le mode d'insertion dans le chemin (CLOSEST ou FARTHEST ou RANDOM) *)
    insertion : string;
    (* Le mode d'optimisation *)
    optimization: string;
  }
  
  (* Ouvre un fichier dont le nom est passé en paramètre et renvoie une liste de noms et coordonnées de villes. 
    @requires Le fichier passé existe, le fichier est au format donné par l'énonce.
    @ensures La liste contient autant de villes que la première ligne du fichier l'indique
    @raises Sys_error si le fichier n'existe pas ou ne peut être ouvert, Scan_failure si le fichier n'est pas au format attendu.
  *)
  val parse_input_file : string -> (string * float * float) list * Carte.word_set Carte.WordMap.t
  
  (* Ouvre un fichier dont le nom est passé en paramètre et renvoie une configuration d'optimisation
    @requires Le fichier passé existe, le fichier est au format donné par le manuel.
    @ensures Les options renvoyées contiennent les informations brutes du fichier (pas de sanity check)
    @raises Sys_error si le fichier n'existe pas ou ne peut être ouvert, Scan_failure si le fichier n'est pas au format attendu.
  *)
  val parse_config_file : string -> config

end