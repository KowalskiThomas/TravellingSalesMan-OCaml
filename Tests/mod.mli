module Liste :
    sig
        type liste

        val nieme : liste -> int -> int

        val tete : liste -> int

        val queue : liste -> liste

        val mem : liste -> int -> bool

    end