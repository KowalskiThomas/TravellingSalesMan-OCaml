module type Map =
  sig
    type key
    type 'a pmap

    val empty : 'a pmap
    val is_empty : 'a pmap -> bool
    val add : key -> 'a -> 'a pmap -> 'a pmap
    val find : key -> 'a pmap -> 'a
    val remove : key -> 'a pmap -> 'a
    val fold : (key -> 'a -> 'b) -> 'a pmap -> 'b -> 'b
  end