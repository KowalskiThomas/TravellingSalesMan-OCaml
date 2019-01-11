(*
    Représente un "monde", c'est à dire un ensemble de villes toutes caractérisées par :
    - Un indice
    - Un nom
    - Des coordonnées cartésiennes
    Ces données sont stockées sous la forme d'une Map (indice (int) -> (nom (str), (x (float), y (float))))
    Une Carte stocke également un ensemble de "routes inexistantes" à savoir des couples (ville, ville) tels que ces villes ne sont pas reliées par un chemin direct.
*)
module Carte : sig
    (* Le type ordonné des indices *)
    module Node : sig
        type t = int
        val compare : t -> t -> int
    end
    module Word : sig
        type t = String.t
        val compare : t -> t -> int
    end
    type word = Word.t
    module WordMap : Map.S with type key = word
    module WordSet : Set.S with type elt = word
    type word_set = WordSet.t
    type road_map = word_set WordMap.t

    (* Le type des indices, pour nous des entiers *)
    type node = Node.t
    (* Le module Ensemble de Noeuds (à savoir ensemble d'entiers)) *)
    module NodeSet : Set.S with type elt = node
    (* Le type des ensembles de noeuds *)
    type node_set = NodeSet.t

    module IntMap : Map.S with type key = int
    
    (* Le module des "Arcs rompus" *)
    (* Ils sont implémentés avec des couples d'indices *)
    module BrokenRoad : sig 
        type t = node * node
        (* Comparaison lexicographique *)
        val compare : t -> t -> int
    end
    type broken_road = BrokenRoad.t
    (* Ensemble d'arcs rompus, pour stocker tous les arcs inexistants *)
    module BrokenRoadSet : Set.S with type elt = broken_road
    type broken_road_set = BrokenRoadSet.t

    (* Le type des données des villes (nom, coordonnées) *)
    type pair = string * (float * float)

    (* Le type final de la carte *)
    type carte

    (* Exception levée si un élément supposé présent est absent *)
    exception NotInCarte

    (* Vérifie si un arc est rompu dans le graphe *)
    val mem_broken_road : broken_road -> carte -> bool

    (* Ajoute une route *)
    val add_road : node -> node -> carte -> carte

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
    val add_cities : (string * float * float) list -> carte -> carte * IntMap.key WordMap.t

    (* Génère une carte à partir d'une liste de triplets (nom, x, y) *)
    val make_carte_from_cities_and_roads : (string * float * float) list -> road_map -> carte

    val make_carte_from_cities : (string * float * float) list -> carte

    (* Calcule la distance entre deux couples de coordonnées *)
    val distance_from_coordinates : float -> float -> float -> float -> float

    (* 
      @requires Les deux villes données sont dans le chemin
      @ensures Calcule la distance entre deux villes repérées par leurs indices 
      @raises NotInCarte si l'une des deux villes est absente du chemin
    *)
    val distance : node -> node -> carte -> float

    (* Calcule la longueur d'un chemin donné sous la forme d'une liste de noeuds *)
    val distance_path : node list -> carte -> float

    (* ------------- A FINS DE TESTS ------------- *)
    (* Trouve l'indice correspondant à un nom de ville *)
    val get_index : string -> carte -> node

    (* Trouve le nom de la ville à partir de son indice *)
    (* Lève NotInCarte si la ville n'est pas dans la carte *)
    val get_name : node -> carte -> string

    (* Trouve les coordonnées d'une ville à partir de son indice *)
    (* Lève NotInCarte si la ville n'est pas dans la carte *)
    val get_coordinates : node -> carte -> (float * float)

    val accessible_from_city : node -> node -> carte -> bool
    val accessible_from_cityset : node -> node_set -> carte -> bool
end