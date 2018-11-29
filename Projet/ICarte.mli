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
        val compare : t -> t -> int
    end
    (* Le type des indices, pour nous des entiers *)
    type node = Node.t
    (* Le module Ensemble de Noeuds (à savoir ensemble d'entiers)) *)
    module NodeSet : Set.S with type elt = node
    (* Le type des ensembles de noeuds *)
    type node_set = NodeSet.t
    
    module BrokenRoad : sig 
        type t = node * node
        val compare : t -> t -> int
    end
    type broken_road = BrokenRoad.t
    module BrokenRoadSet : Set.S with type elt = broken_road
    type broken_road_set = BrokenRoadSet.t

    (* Le type des données des villes (nom, coordonnées) *)
    type pair = string * (float * float)

    (* Le type final de la carte *)
    type carte

    (* Exception levée si un élément supposé présent est absent *)
    exception NotInCarte

    val add_broken_road : broken_road -> carte -> carte
    val mem_broken_road : broken_road -> carte -> bool
    val remove_broken_road : broken_road -> carte -> carte

    (* Renvoie la Carte vide *)
    val empty : carte

    (* Vérifie si une carte est vide *)
    val is_empty : carte -> bool

    (* Trouve les données d'une ville à partir de son indice *)
    val find : node -> carte -> pair

    (* Ajoute un noeud à la carte grâce à ses quatre données (indice, nom, x, y) *)
    val add_node : int -> string -> float -> float -> carte -> carte

    (* Applique fold à la Carte *)
    val fold : (node -> pair -> 'a -> 'a) -> carte -> 'a -> 'a

    (* Renvoie le nombre de villes d'une carte *)
    val card : carte -> int

    (* Renvoie les données de la carte sous la forme d'une liste de couples (indice, données) *)
    val bindings : carte -> (node * pair) list

    (* Renvoie un élément aléatoire de la carte qui n'appartienne pas à un ensemble donné *)
    val get_random : carte -> node_set -> (node * pair)

    (* Renvoie un élément aléatoire de la carte *)
    val get_random_any : carte -> (node * pair)

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

    (* A FINS DE TESTS *)
    val get_index : string -> carte -> node
    val get_name : node -> carte -> string
    val get_coordinates : node -> carte -> (float * float)
end