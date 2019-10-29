module Char : Map.OrderedType = struct
    type t = Char.t
    let compare c1 c2 = Char.code c1 - Char.code c2
end

module type Word = sig
    module C : Map.OrderedType
    type c = C.t
    type w

    val is_empty : w -> bool
    val split : w -> c * w
end

module ListWord : Word = struct
    module C = Char
    type c = Char.t
    type w = c list

    exception EmptyWord

    let is_empty w = w = []

    let split w = match w with
    | [] -> raise EmptyWord
    | t::q -> t, q
end

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

module MakeTrie(T : Word) = struct  
    type key = T.c
    type word = T.w
    module M = Map.Make(T.C)

    type 'a t = Node of ('a * bool) option * 'a t M.t

    let empty = Node(None, M.empty)

    let rec cardinal t = 
        let f key value acc = acc + cardinal value in
        match t with
        | Node(None, _) -> 0
        | Node(Some(_, false), m) -> 
            M.fold f m 0
        | Node(Some(_, true), m) -> 
            M.fold f m 1
    
    let rec nb_lettres t = 
        let f key value acc = acc + nb_lettres value in 
        match t with
        | Node(None, _) -> 0
        | Node(Some(_, _), m) -> M.fold f m 1

    let rec longest_word t = 
        let f key value acc = 
            let longest_in_value = longest_word value in 
            max longest_in_value acc in
        match t with
        | Node(None, _) -> 0
        | Node(Some(_, b), m) -> M.fold f m (if b then 1 else 0)

    let rec add_aux w s = 
        let h, t = T.split w in 
        if T.is_empty t then 
        Node(Some(h, true), M.empty)
        else
    
    let add w s = 
        if T.is_empty w 
        then s 
        else add_aux w s


    let union a = failwith "Not implemented"
    let terminaisons a = failwith "Not implemented"
    let liste_mots a = failwith "Not implemented"

    (* let add (w : word) (t : 'a t) : 'a t = failwith "Not implemented"
    let union (t1 : 'a t) (t2 : 'a t) : 'a t = failwith "Not implemented"
    let terminaisons (pre : word) (t : 'a t) : word list = failwith "Not implemented"
    let liste_mots (t : 'a t) : word list = failwith "Not implemented" *)
end

module Trie = MakeTrie(ListWord)

let _ = 
    let vide = Trie.empty in
    let _ = Printf.printf "Cardinal: %d\n" (Trie.cardinal vide)  in 
    let _ = Printf.printf "Max mot: %d\n" (Trie.longest_word vide) in
    let _ = Printf.printf "Lettres: %d\n" (Trie.nb_lettres vide) in
    ()

let _ = 
    let vide = Trie.empty in 
    let s = Trie.add "thomas" vide in 
    let _ = Printf.printf "Cardinal: %d\n" (Trie.cardinal s)  in 
    let _ = Printf.printf "Max mot: %d\n" (Trie.longest_word s) in
    let _ = Printf.printf "Lettres: %d\n" (Trie.nb_lettres s) in
    ()
