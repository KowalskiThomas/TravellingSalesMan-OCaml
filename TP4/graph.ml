open Set

module type Graph =
  sig
    type node
    module NodeSet : Ensemble with type elt = node
    type graph

    val empty : graph
    val is_empty : graph -> bool
    val add_vertex : node -> graph -> graph
    val add_edge : node -> node -> graph -> graph

    val succs : node -> graph -> NodeSet.set
    val fold : (node -> 'a -> 'a) -> graph -> 'a -> 'a
  end

(* module Graph =
  struct
    type node
    module NodeSet : Ensemble with type elt = node
    type graph

    val empty : graph
    val is_empty : graph -> bool
    val add_vertex : node -> graph -> graph
    val add_edge : node -> node -> graph -> graph

    val succs : node -> graph -> NodeSet.set
    val fold : (node -> 'a -> 'a) -> graph -> 'a -> 'a
  end *)