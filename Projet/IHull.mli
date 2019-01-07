module ConvexHull : sig
  (* Le module des Crtes *)
  module Carte = ICarte.Carte
  (* Le type des Cartes *)
  type carte = Carte.carte
  (* Le type des noeuds de la carte (indices de villes) *)
  type node = Carte.node
  (* Le type des éléments de listes de villes, à savoir Indice * (Nom * (Coordonnée X, Coordonnée Y)) *)
  type city_list_entry = Carte.node * Carte.pair
  (* Le type de l'enveloppe convexe : une liste d'éléments de liste de villes *)
  type hull = city_list_entry list 

  (*
    @requires Rien
    @ensures Renvoie l'enveloppe convexe de la carte donnée en paramètre sous forme d'une liste
    @raises Rien
  *)
  val convex_hull : carte -> hull

  (*
    @requires Rien
    @ensures Imprime une enveloppe convexe donnée en paramètre
    @raises Rien
  *)
  val print_hull : hull -> unit
  
  (*
    @requires Rien
    @ensures Vérifie si une ville est présente dans l'enveloppe
    @raises Rien
  *)
  val in_hull : hull -> string -> bool

  (*
    @requires Rien
    @ensures Renvoie la liste des indices des villes d'une enveloppe convexe. L'ordre est conservé.
    @raises
  *)
  val to_indices : hull -> Carte.node list 
end