module type Ordered =
  sig
    type t

    val compare : t -> t -> int
  end

module type Ensemble =
  sig
    type set
    type elt

    val empty : set
    val is_empty : set -> bool
    val add : elt -> set -> set
    val mem : elt -> set -> bool
    val get_min : set -> elt
  end

module MakeEnsembleListe(X:Ordered) : Ensemble with type elt = X.t
module MakeEnsembleAVL(X:Ordered) : Ensemble with type elt = X.t