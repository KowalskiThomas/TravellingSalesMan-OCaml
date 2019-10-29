open Set

module Entier =
  struct
    type t = int

    let compare a b = a - b
  end

module E = MakeEnsembleAVL(Entier)

let _ =
  let s = E.empty in
  let s = E.add 2 s in
  let s = E.add 3 s in
  let s = E.add 4 s in
  let resultat = (E.mem 3 s) && (E.mem 4 s) && (E.mem 2 s) in
  Format.printf "OK : %b\n" resultat
