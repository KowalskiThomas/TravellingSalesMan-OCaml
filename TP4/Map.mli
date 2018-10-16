module type Map =
  sig
    type key
    type 'a pmap

    val empty : 'a pmap
    val is_empty : 'a pmap -> bool
    val add : key -> 'a -> 'a pmap -> 'a pmap
    val find : 'a pmap -> key -> 'a
    val remove : key -> 'a pmap -> 'a pmap
    val fold : (key -> 'a -> 'b -> 'b) -> 'a pmap -> 'b -> 'b
  end