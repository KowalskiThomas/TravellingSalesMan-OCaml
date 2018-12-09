module Optimizer : sig
    module MLLPath = IMLLPath.MLLPath
    module Carte = ICarte.CompleteCarte

    type mins_list = (Carte.node * (MLLPath.path_entry * float) option) list

    type builder = Carte.carte -> MLLPath.path -> MLLPath.path

    val repositionnement_noeud : MLLPath.path_entry -> MLLPath.path -> Carte.carte -> MLLPath.path
    val inversion_locale : MLLPath.path_entry -> MLLPath.path -> Carte.carte -> MLLPath.path

    (* val build_solution : 
        mins_list -> MLLPath.node * (MLLPath.path_entry * 'a) option * (Carte.node * MLLPath.path_entry * float) list -> Carte.carte -> MLLPath.path -> MLLPath.path *)
    
    val rebuild_mins_list : 
        mins_list -> 
        MLLPath.path_entry -> Carte.carte -> 
        mins_list
    val find_optimal : 
        (float -> float -> bool) -> 
        mins_list -> 
        ((Carte.node * MLLPath.path_entry * float) option) * mins_list

    val find_solution_nearest : Carte.carte -> MLLPath.path
    val find_solution_farthest : Carte.carte -> MLLPath.path
    val find_solution_random : Carte.carte -> MLLPath.path

    val build_solution_random : builder
    val build_solution_nearest : builder
    val build_solution_farthest : builder

end