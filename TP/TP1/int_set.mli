(** Ensembles d'entiers

Ce module d?fini une structure d'ensembles d'entiers.

 *)


exception EmptySet
(** exception lev?e si l'on tente de deconstruire un ensemble vide *)

type int_set
(** type ABSTRAIT (ne pas modifier cette ligne !) des ensemble d'entiers *)

val is_empty : int_set -> bool
(** [is_empty s] teste si  [s] est vide *)


val empty : int_set
(** L'ensemble vide.

    Rq:
     is_empty empty = true
 *)

val mem : int -> int_set -> bool
(**
   [mem e s] teste si [e] est un ?l?ment de [s]

   Rq:
    1- \forall n s, is_empty s -> mem n s = false.
    2- \forall n, mem n empty = false
 *)


val add : int -> int_set -> int_set
(** [add e s] retourne l'ensemble [s] augment? de l'?l?ment [e]

    Rq :
     1- \forall n s, is_empty (add n s) = false
     2- \forall n s, mem n (add n s) = true
     3- \forall n m s, mem m s = true -> mem m (add n s) = true
 *)


val fold : (int -> 'a -> 'a) -> int_set -> 'a -> 'a
(** [fold f s v0] calcule [(f xN ... (f x2 (f x1 v0)))] o? [x1 ... xN] sont les ?l?ments de [s] par ordre croissant *)

val get_min : int_set -> int
(** [get_min s] retourne le plus petit ?l?ment de [s]
L?ve [EmptySet] si [s] est vide
*)

val equal : int_set -> int_set -> bool
(** [equal s t] test si les ensembles [s] et [t] sont ?gaux (i.e. contiennent EXACTEMENT les m?mes ?l?ments)
 *)

val remove : int -> int_set -> int_set
(** [remove e s] retourne l'ensemble [s] dont on a retir? l'?l?ment [e]

Rq:
1- \forall n m s, mem m (remove n s) = true -> mem m s =true /\ m <> n
2- \forall n s, mem n s = false -> equal s (remove n s)

*)

val union : int_set -> int_set -> int_set
(** [union s t] retourne l'union des ensemble [s] et [t]

    Rq:
1- \forall n s t, mem n (union s t) = true <-> (mem n s=true \/ me n t = true)
2- \forall s, equal (union empty s) s /\ equal (union s empty) s
 *)

