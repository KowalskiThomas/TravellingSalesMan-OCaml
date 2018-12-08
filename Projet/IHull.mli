module ConvexHull : sig
  module Carte = ICarte.CompleteCarte
  type carte = Carte.carte
  type node = Carte.node
  type city_list_entry = Carte.node * Carte.pair

  val convex_hull : carte -> city_list_entry list 
end