(** Ensembles d'entiers

Ce module défini une structure d'ensembles d'entiers. 

 *)


exception EmptySet
(** exception levée si l'on tente de deconstruire un ensemble vide *)

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
   [mem e s] teste si [e] est un élément de [s]

   Rq: 
    1- \forall n s, is_empty s -> mem n s = false. 
    2- \forall n, mem n empty = false
 *)

  
val add : int -> int_set -> int_set
(** [add e s] retourne l'ensemble [s] augmenté de l'élément [e]
    
    Rq : 
     1- \forall n s, is_empty (add n s) = false
     2- \forall n s, mem n (add n s) = true 
     3- \forall n m s, mem m s = true -> mem m (add n s) = true
 *)


val fold : (int -> 'a -> 'a) -> int_set -> 'a -> 'a
(** [fold f s v0] calcule [(f xN ... (f x2 (f x1 v0)))] où [x1 ... xN] sont les éléments de [s] par ordre croissant

 *)

                              
(** À PARTIR DE CE POINT VOUS DEVEZ DONNER LES PROFILS DES FONCTIONS *)

(** [get_min s] retourne le plus petit élément de [s]

    Lève [EmptySet] si [s] est vide
 *)
                              
(** [equal s t] test si les ensembles [s] et [t] sont égaux (i.e. contiennent EXACTEMENT les mêmes éléments)
 *)
                              
(** [remove e s] retourne l'ensemble [s] dont on a retiré l'élément [e]

Rq: 
1- \forall n m s, mem m (remove n s) = true -> mem m s =true /\ m <> n
2- \forall n s, mem n s = false -> equal s (remove n s)

*)

 
(** [union s t] retourne l'union des ensemble [s] et [t] 
    
    Rq: 
1- \forall n s t, mem n (union s t) = true <-> (mem n s=true \/ me n t = true)
2- \forall s, equal (union empty s) s /\ equal (union s empty) s
 *)
                              
