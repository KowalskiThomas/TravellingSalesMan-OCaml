module type Ordered =
  sig
    type t

    val compare : t -> t -> int
  end

module type Map =
  sig
    type key
    type 'a pmap

    exception NotInSet

    val empty : 'a pmap
    val is_empty : 'a pmap -> bool
    val add : key -> 'a -> 'a pmap -> 'a pmap
    val find : 'a pmap -> key -> 'a
    val remove : key -> 'a pmap -> 'a pmap
    val fold : (key -> 'a -> 'b -> 'b) -> 'a pmap -> 'b -> 'b
  end

module AVLMap(X : Ordered) : Map with type key = X.t