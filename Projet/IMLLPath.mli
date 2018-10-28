(*
    A map that represents a path
    Each element is a pair (last, next)
    So it is a kind of linked-list though the access to the elements is in a way better complexity
*)

module MLLPath : sig
    (* Le module Carte utilisé pour calculer les distances *)
    module Carte = ICarte.CompleteCarte
    (* Un ensemble de villes d'une carte (<=> noeuds sur un graphe) *)
    module NodeSet : Set.S
    (* Une ville. Dans un chemin, elle est représentée par un entier qui est son "indice" dans la carte *)
    type node = int
    (* Le type des données contenues dans la Map. En pratique, c'est un couple (précédent, suivant) d'indices *)
    type value
    (* Le type des chemins *)
    type path

    (* Exception levée si on essaie d'insérer une ville déjà dans le chemin *)
    exception AlreadyInPath
    (* Exception levée si on essaie d'obtenir des informations ou d'insérer après une ville absente du chemin *)
    exception NotInPath

    (* Renvoie un chemin vide *)
    val empty : path

    (* Vérifie si un chemin est vide *)
    val is_empty : path -> bool

    (* Echange deux villes sur un chemin *)
    val swap : node -> node -> path -> path

    (* Trouve la ville suivante dans un chemin *)
    val get_next : node -> path -> node

    (* Trouve la ville précédente dans un chemin *)
    val get_last : node -> path -> node

    (* Affiche un chemin (comme suite d'indices) *)
    val print : path -> unit

    (* Affiche un chemin (comme suite de noms de villes) *)
    val print_with_names : path -> Carte.carte -> unit

    (* Vérifie si un indice appartient au chemin *)
    val mem : node -> path -> bool

    (* Ajoute un indice à un chemin
    Utilisant: insert [noeud] après [after] dans [chemin] *)
    val insert : node -> node -> path -> path

    (* Supprime un indice d'un chemin
    Lève NotInPath si l'indice n'y est pas. *)
    val remove : node -> path -> path

    (* Construit un chemin de base avec un seul indice. 
    Le chemin est alors de la forme indice -> (indice, indice) *)
    val make : node -> path

    (* Détermine la longueur totale d'un chemin *)
    val length : path -> Carte.carte -> float

    (* Renvoie un ensemble contenant tous les indices d'un chemin *)
    val to_set : path -> Carte.node_set

    (* Renvoie le premier indice du chemin (dans N) *)
    val get_first : path -> node

    (* Insère un indice dans un chemin en minimsant sa longueur *)
    val insert_minimize_length : node -> path -> Carte.carte -> path

    (* Insère un indice aléatoire de la Carte en minimisant la longueur du chemin *)
    val insert_random_minimize : path -> Carte.carte -> path

    (* Insère la ville la plus proche du chemin dans la Carte non-déjà présente en minimsant sa longueur *)
    val insert_nearest_minimize_length : path -> Carte.carte -> path

    (* Insère la ville qui est la plus lointaine de toutes les villes à la fois. 
        C'est à dire que si 
        - A -> X = 100km
        - A -> Y = 5km
        - B -> X = 20km
        - B -> Y = 25km
        Alors c'est B qu'on insère.
    *)
    (* val insert_farthest_minimize_length : path -> Carte.carte -> path *)

    (* A FINS DE TESTS
    Trouve la ville suivant une autre ville par son nom
    *)
    val get_next_by_name : string -> path -> Carte.carte -> node
    val get_last_by_name : string -> path -> Carte.carte -> node
end