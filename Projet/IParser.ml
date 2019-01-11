module Carte = ICarte.Carte

module Parser = struct
  let rec parse_villes cin nb_villes =
    if nb_villes = 0
    then []
    else
      let l = input_line cin in 
      let idx1 = String.index l ' ' in 
      let idx2 = String.index_from l (idx1 + 1) ' ' in 
      let nom = String.sub l 0 idx1 in 
      let x = String.sub l (idx1 + 1) (idx2 - idx1 - 1) in 
      let x = float_of_string x in  
      let y = String.sub l (idx2 + 1) (String.length l - idx2 - 1) in 
      (* let y = String.trim y in  *)
      let y = float_of_string y in 
      (nom, x, y)::parse_villes cin (nb_villes -1)

  let rec split_space s = 
    if s = "" then Carte.WordSet.empty else
    try
      let idx = String.index s ' ' in 
      let elt = String.sub s 0 idx in 
      let reste = String.sub s (idx + 1) (String.length s - idx - 1) in
      (* let reste = String.trim reste in  *)
      Carte.WordSet.add elt (split_space reste)
    with Not_found -> Carte.WordSet.add s Carte.WordSet.empty

  let rec print_list l = 
    match l with
    | [] -> Printf.printf "\n"
    | t::q -> 
      let _ = Printf.printf "'%s', " t in
      print_list q 

  let rec parse_roads cin n = 
    if n = 0 then Carte.WordMap.empty
    else
      try
        let l = input_line cin in 
        let idx = String.index l ':' in 
        let nom = String.sub l 0 (idx - 1) in 
        let seq_length = String.length l - idx - 2 in 
        let reste = String.sub l (idx + 2) seq_length in
        (* let reste = String.trim reste in  *)
        let liste = (split_space reste) in 
        (* let _ = print_list liste in  *)
        let m = parse_roads cin (n - 1) in 
        Carte.WordMap.add nom liste m 
      with End_of_file -> Carte.WordMap.empty

  let parse_input cin =
    let l = input_line cin in 
    (* let l = String.trim l in  *)
    let nb_villes = int_of_string l in 
    let cities = List.rev (parse_villes cin nb_villes) in 
    let roads = parse_roads cin nb_villes in
    cities, roads

  exception FileNotFound of string
  exception SyntaxError of string*string  

  type config = {
    mode : string;
    insertion : string;
    optimization: string;
  }

  let parse_input_file file_name =
    try
      let cin = open_in file_name in
      try
        let l = parse_input cin in
        let _ = close_in cin in  (* parce qu'on est pas des porcs *)
        l
      with e -> close_in cin; raise e
    with
    | Sys_error _ -> (* fichier non trouvé *)
      raise (FileNotFound file_name)

  let parse_config_file file_name = 
    try
      let cin = open_in file_name in 
      try 
        let mode = input_line cin in 
        let insertion = input_line cin in 
        let optimisation = input_line cin in 
        { mode = mode; insertion = insertion; optimization = optimisation }
      with e -> close_in cin; raise e
    with
    | Sys_error _ -> (* fichier non trouvé *)
      raise (FileNotFound file_name)
  end