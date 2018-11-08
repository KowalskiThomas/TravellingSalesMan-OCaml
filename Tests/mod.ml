module Liste : sig
        type liste

        val nieme : liste -> int -> int

        val tete : liste -> int

        val queue : liste -> liste

        val mem : liste -> int -> bool

    end

module type Liste_Entier : Liste =
    struct
        type liste = int list
 
        let rec nieme liste i = 
        match liste with
            | [] -> failwith "IndexError"
            | t::q -> if i = 0 then t else nieme q (i - 1)


        let tete liste = match liste with
            | [] -> failwith "Error No head"
            | t::q -> t

        let queue liste = match liste with
            | [] -> failwith "Error no tail"
            | t::q -> q

        let rec mem liste x = match liste with
            | [] -> false
            | t::q -> x = t || mem q x
    end
