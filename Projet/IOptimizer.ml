module Optimizer = struct
    module MLLPath = IMLLPath.MLLPath
    module Carte = ICarte.CompleteCarte

    (*
      Cas card <= 3:
      - Si il n'y a qu'une ville, on ne peut tout simplement pas faire de repositionnement
      - S'il y a deux villes, on obtient le même résultat en repositionnant
      - S'il y a trois villes aussi, puisque c'est "un triangle"
      Sinon, on retire u du chemin et on le rajoute en minimisant la distance totale.
    *)
    let repositionnement_noeud u p c = 
        if MLLPath.cardinal p <= 3 
        then p 
        else
            MLLPath.insert_minimize_length u (MLLPath.remove u p) c

    let inversion_locale a b c d p c = 
        (* TODO: Implémenter ça *)
        p
end