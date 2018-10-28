module Optimizer : sig
    module MLLPath = IMLLPath.MLLPath
    module Carte = ICarte.CompleteCarte

    val repositionnement_noeud : MLLPath.node -> MLLPath.path -> Carte.carte -> MLLPath.path
end