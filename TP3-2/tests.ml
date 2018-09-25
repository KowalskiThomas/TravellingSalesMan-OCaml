open Set

module Entier =
  struct
    type t = int

    let compare a b = a - b
  end

module EntierEnsemble = MakeEnsembleAVL(Entier)