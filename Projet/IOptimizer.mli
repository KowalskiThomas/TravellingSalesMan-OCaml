module Optimizer : sig
    module MLLPath = IMLLPath.MLLPath
    module Carte = ICarte.CompleteCarte

    val repositionnement_noeud : MLLPath.node -> MLLPath.path -> Carte.carte -> MLLPath.path
    val inversion_locale : MLLPath.node -> MLLPath.path -> Carte.carte -> MLLPath.path
    
    val find_solution_nearest : Carte.carte -> MLLPath.path
    val find_solution_random : Carte.carte -> MLLPath.path

end