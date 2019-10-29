module type Graph = sig
  type node
  module NodeSet : Ensemble.Ensemble with type elt = node
  type graph

  val empty : graph
  val is_empty : graph -> bool
  val add_vertex : node -> graph -> graph
  val add_edge : node -> node -> graph -> graph

  val succs : node -> graph -> NodeSet.set
  val fold : (node -> 'a -> 'a) -> graph -> 'a -> 'a
end

module Graph(X : Ordered) = struct
  type node = X.t
  module NodeSet = EnsembleAVL.MakeEnsembleAVL(X)
  module NodeMap = AVLMap.AVLMap(X)
  type graph = NodeSet.set NodeMap.pmap

  let empty = NodeMap.empty
  
  let is_empty g = NodeMap.is_empty g

  let add_vertex x g = NodeMap.add x NodeSet.empty g

  let add_edge u v g = 
    let voisins_u = NodeMap.find u g in
    let voisins_v = NodeMap.find v g in 
    let voisins_u' = NodeSet.add voisins_u' v in 
    let voisins_v' = NodeSet.add voisins_v' u in 
    NodeMap.add u voisins_u' (NodeMap.add v voisins_v')

  let succs u g = NodeMap.find u g 

  let fold_nodes f g acc = (* TODO *)
end