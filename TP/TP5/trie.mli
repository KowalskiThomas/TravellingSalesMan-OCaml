module type Trie = sig
    type key
    type word
    module M : Map.S

    type 'a t

    val cardinal : 'a t -> int

    val nb_lettres : 'a t -> int

    val longest_word : 'a t -> int

    val add : word -> 'a t -> 'a t

    val union : 'a t -> 'a t -> 'a t

    val terminaisons : word -> 'a t -> word list

    val liste_mots : 'a t -> word list
end