open Ensemble
open Graph
open AVLMap

module Entier : Ordered = struct
  type t = int

  let compare x y = x - y
end

module IntMap = AVLMap(Entier)

let test = IntMap.empty

let _ =
  Printf.printf "Fini %d\n" 1