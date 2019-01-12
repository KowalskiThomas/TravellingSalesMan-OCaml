module Optimizer : sig
    (* Le type des chemins *)
    module MLLPath = IMLLPath.MLLPath
    (* Le type des cartes *)
    module Carte = ICarte.Carte

    (* 
      Le type des listes utilisées lors de l'insertion au plus loin / plus près. 
      C'est une liste de node (repérant la ville absente du chemin) * path_entry option (repérant la ville la plus proche dans le chemin, si elle existe.)
    *)
    type mins_list = (Carte.node * (MLLPath.path_entry * float) option) list

    (* Le type des fonctions créatrices de solutions *)
    type builder = Carte.carte -> MLLPath.path -> MLLPath.path

    (* Le type des fonctions constructrices de chemin initial *)
    type initial_path_builder = Carte.carte -> MLLPath.path

    (* Le type des fonctions optimisatrices de chemins *)
    type optimizer = MLLPath.path -> 
    Carte.carte -> 
    MLLPath.path

    (* Repositionne un élément du chemin pour minimiser la distance totale *)
    val repositionnement_noeud : MLLPath.path_entry -> MLLPath.path -> Carte.carte -> MLLPath.path

    (* Applique l'inversion locale si on a A -> B -> ... -> C --> D *)
    val inversion_locale : MLLPath.path_entry -> MLLPath.path_entry  -> MLLPath.path -> Carte.carte -> MLLPath.path

    (* Applique le repositionnement un certain nombre de fois au chemin *)
    val repositionnement_n_fois : 
        MLLPath.path -> (* La solution initiale *) 
        Carte.carte ->  (* La carte *)
        MLLPath.path    (* La solution de sortie *)

    (* Application l'inversion locale un certain nombre de fois au chemin *)
    val inversion_n_fois : 
        MLLPath.path -> (* La solution initiale *)
        Carte.carte ->  (* La carte *)
        MLLPath.path    (* La solution de sortie *)

    (* Met à jour la liste des noeuds internes les plus proches aux noeuds externes 
       @requires la liste est valide, ie pour chaque élément (x, plus_proche, dist_x) de la liste, x est plus proche de plus_proche que de n'importe quelle autre entrée du chemin, excepté éventuellement le nouvel élément
       @ensures La liste des villes les plus proches de sortie est valide (voir définition au-dessus)
       @raises Rien
    *)
    val rebuild_mins_list : 
        mins_list -> (* L'ancienne liste *)
        MLLPath.path_entry -> (* L'élément qu'on vient d'ajouter au chemin *)
        Carte.carte -> 
        mins_list (* La liste mise à jour *)
    
    (* 
      @requires mins_list est une liste d'optimaux valide (voir définition dans rebuild_mins_list)
      @ensures Trouve l'élément de mins_list qui optimise la fonction objectif 
      @raises Rien
    *)
    val find_optimal : 
        (float -> float -> bool) -> (* Fonction objectif *)
        mins_list -> (* La liste des noeuds les plus proches ou les plus loins *)
        ((Carte.node * MLLPath.path_entry * float) option) * mins_list (* L'élément à rajouter au chemin s'il existe (l'optimal), et la liste privée de cet élément *)

    (* Constructeurs de solutions initiales avec les finders correspondants *)
    (*
      @requires Rien
      @ensures Le chemin de sortie est construit aléatoirement.
      @raises Rien
    *)
    val build_solution_random : builder

    (*
      @requires Rien
      @ensures Le chemin de sortie a été construit en insérant la ville la plus proche à chaque fois.
      @raises Rien
    *)
    val build_solution_nearest : builder

    (*
      @requires Rien
      @ensures Le chemin de sortie a été construit en insérant la ville la plus lointaine à chaque fois.
      @raises Rien
    *)
    val build_solution_farthest : builder

    (* Constructeurs de chemins initiaux (avec un point au hasard ou l'enveloppe convexe) *)

    (*
      @requires Rien
      @ensures Le chemin renvoyé est constitué d'un unique point choisi aléatoirement sur la carte
      @raises Rien
    *)
    val random_point_initial_path : Carte.carte -> MLLPath.path

    (*
      @requires Rien
      @ensures Le chemin renvoyé constitue l'enveloppe convexe de la carte passée en argument
      @raises Rien
    *)
    val hull_initial_path : Carte.carte -> MLLPath.path

    (* La solution de résolution principale : créé un chemin initial grâce au initial_path_builder passé, puis ajoute toutes les villes grâce au builder passé, puis l'optimise grâce à l'optimizer passé.
      @requires Rien
      @ensures Le chemin de sortie est respectivement construit avec les initial_path_builder, builder et optimizer donnés en paramètres.
      @raises Rien
    *)
    val find_solution : initial_path_builder -> builder -> optimizer -> Carte.carte -> MLLPath.path
end