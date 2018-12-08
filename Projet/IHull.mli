module ConvexHull : sig
  module Carte = ICarte.CompleteCarte
  type carte = Carte.carte
  type node = Carte.node
  type city_list_entry = Carte.node * Carte.pair
  type hull = city_list_entry list 

  val convex_hull : carte -> hull

  val print_hull : hull -> unit
  
  val in_hull : hull -> string -> bool
end