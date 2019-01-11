module Carte = ICarte.Carte

module Parser = struct
  let rec parse_route cin res prev =
    try
      let v = Scanf.fscanf cin "%s " (fun x -> x)
      in if v = ":" then
           res,prev
         else
           parse_route cin (prev::res) v
    with
      _ -> [],"fin"
  
  
  let rec accord cin pv =
    let n,nv =parse_route cin [] (Scanf.fscanf cin "%s " (fun x -> x))
    in if nv = "fin" then [] else (pv,n)::accord cin nv
     
  let rec parse_routes cin nb_villes =
    if nb_villes = 0
    then []
    else
      try
        let fv = Scanf.fscanf cin "%s " (fun x -> x) in
        let _ = Scanf.fscanf cin "%s " (fun x -> if x<> ":" then (print_string ("pk x="^x^" ?");print_newline()) else ()) in
        accord cin fv
      with _ -> []

  let rec parse_villes cin nb_villes =
    if nb_villes = 0
    then []
    else
      let v = Scanf.fscanf cin "%s %f %f " (fun na x y -> na,x,y) in
      v::parse_villes cin (nb_villes -1)

  let rec split_on_char c s = 
    if s = "" then Carte.WordSet.empty else
    try
      let idx = String.index s c in 
      let elt = String.sub s 0 idx in 
      let reste = String.sub s (idx + 1) (String.length s - idx - 1) in
      (* let reste = String.trim reste in  *)
      Carte.WordSet.add elt (split_on_char c reste)
    with Not_found -> Carte.WordSet.add s Carte.WordSet.empty    

  let rec parse_routes cin nb_villes =
    if nb_villes = 0
    then []
    else
      try 
        let ligne = input_line cin
        in match split_on_char ' ' (String.sub ligne 0 (String.length ligne -1)) with
            | h::":"::l -> (h,l)::parse_routes cin (nb_villes-1)
            | _ -> failwith "fichier mal formé"      
      with
        _ -> []

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