module Optimizer : sig
    module MLLPath = IMLLPath.MLLPath
    module Carte = ICarte.CompleteCarte

    type mins_list = (Carte.node * (MLLPath.path_entry * float) option) list

    type builder = Carte.carte -> MLLPath.path -> MLLPath.path

    type initial_path_builder = Carte.carte -> MLLPath.path

    type optimizer = MLLPath.path -> 
    int -> (* Le nombre de fois à appliquer *)
    Carte.carte -> 
    MLLPath.path

    (* Repositionne un élément du chemin pour minimiser la distance totale *)
    val repositionnement_noeud : MLLPath.path_entry -> MLLPath.path -> Carte.carte -> MLLPath.path

    (* Applique l'inversion locale si on a A -> B -> ... -> C --> D *)
    val inversion_locale : MLLPath.path_entry -> MLLPath.path_entry  -> MLLPath.path -> Carte.carte -> MLLPath.path

    (* Applique le repositionnement un certain nombre de fois au chemin *)
    val repositionnement_n_fois : MLLPath.path -> int -> Carte.carte -> MLLPath.path

    (* Application l'inversion locale un certain nombre de fois au chemin *)
    val inversion_n_fois : 
        MLLPath.path -> (* La solution initiale *)
        int -> (* Le nombre de fois à appliquer *)
        Carte.carte -> 
        MLLPath.path (* La solution de sortie *)

    (* val build_solution : 
        mins_list -> MLLPath.node * (MLLPath.path_entry * 'a) option * (Carte.node * MLLPath.path_entry * float) list -> Carte.carte -> MLLPath.path -> MLLPath.path *)

    (* Met à jour la liste des noeuds internes les plus proches aux noeuds externes 
       @ requires la liste est valide, ie pour chaque élément (x, plus_proche, dist_x) de la liste, x est plus proche de plus_proche que de n'importe quelle autre entrée du chemin, excepté éventuellement le nouvel élément
    *)
    val rebuild_mins_list : 
        mins_list -> (* L'ancienne liste *)
        MLLPath.path_entry -> (* L'élément qu'on vient d'ajouter au chemin *)
        Carte.carte -> 
        mins_list (* La liste mise à jour *)
    
    (* Trouve l'élément de mins_list qui optimise la fonction objectif *)
    val find_optimal : 
        (float -> float -> bool) -> (* Fonction objectif *)
        mins_list -> (* La liste des noeuds les plus proches ou les plus loins *)
        ((Carte.node * MLLPath.path_entry * float) option) * mins_list (* L'élément à rajouter s'il existe, et la liste privée de cet élément *)

    (* Constructeurs de solutions initiales avec les finders correspondants *)
    val build_solution_random : builder
    val build_solution_nearest : builder
    val build_solution_farthest : builder

    (* Constructeurs de chemins initiaux (avec un point au hasard ou l'enveloppe convexe) *)
    val random_point_initial_path : Carte.carte -> MLLPath.path
    val hull_initial_path : Carte.carte -> MLLPath.path

    (* La solution de résolution principale *)
    val find_solution : initial_path_builder -> builder -> optimizer -> Carte.carte -> MLLPath.path
end