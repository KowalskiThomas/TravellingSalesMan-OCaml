(*
    Représente un "monde", c'est à dire un ensemble de villes toutes caractérisées par :
    - Un indice
    - Un nom
    - Des coordonnées cartésiennes
    Ces données sont stockées sous la forme d'une Map (int -> (nom, (x, y)))
*)
module CompleteCarte : sig
    (* Le type ordonné des indices *)
    module Node : sig
        type t = int
        val compare : int -> int -> int
    end

    (* Le type des indices, pour nous des entiers *)
    type node = int
    (* Le module Ensemble de Noeuds (à savoir ensemble d'entiers)) *)
    module NodeSet : Set.S with type elt = node
    (* Le type des ensembles de noeuds *)
    type node_set = NodeSet.t

    (* Le type des données des villes (nom, coordonnées) *)
    type pair = string * (float * float)
    (* Le type final de la carte *)
    type carte


    (* Renvoie la Carte vide *)
    val empty : carte

    (* Trouve les données d'une ville à partir de son indice *)
    val find : node -> carte -> pair

    (* Ajoute un noeud à la carte grâce à ses quatre données (indice, nom, x, y) *)
    val add_node : int -> string -> float -> float -> carte -> carte

    (* Applique fold à la Carte *)
    val fold : (node -> pair -> 'a -> 'a) -> carte -> 'a -> 'a

    (* Renvoie les données de la carte sous la forme d'une liste de couples (indice, données) *)
    val bindings : carte -> (node * pair) list

    (* Renvoie un indice aléatoire de la carte *)
    val get_random : carte -> (node * pair)

    (* Affiche la carte sous la forme 
        Villes:
        - [1] Ville 1 (x1, y1)
        - [2] Ville 2 (x2, y2)
        ...
    *)
    val print : carte -> unit


    (* Ajoute toutes les villes d'une liste de triplets (nom, x, y) à une carte *)
    val add_cities : (string * float * float) list -> carte -> carte

    (* Génère une carte à partir d'une liste de triplets (nom, x, y) *)
    val make_carte_from_cities : (string * float * float) list -> carte

    (* Calcule la distance entre deux couples de coordonnées *)
    val distance_from_coordinates : float -> float -> float -> float -> float

    (* Calcule la distance entre deux villes repérées par leurs indices *)
    val distance : node -> node -> carte -> float

    (* Calcule la longueur d'un chemin donné sous la forme d'une liste de noeuds *)    
    val distance_path : node list -> carte -> float

    (* Détermine l'indice et la distance de la ville la plus proche d'un noeud et absente d'un ensemble de noeuds donnés. 
    Utilisation: find_nearest noeud noeuds_a_exclude carte *)
    val find_nearest : node -> node_set -> carte -> (node * float) 

    (* Comme find_nearest, mais avec la ville la plus éloignée. *)
    val find_farthest : node -> node_set -> carte -> (node * float) 
end