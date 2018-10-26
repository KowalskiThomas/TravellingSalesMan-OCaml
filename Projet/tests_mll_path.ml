module MLLPath = IMLLPath.MLLPath

let test_empty =
    let path = MLLPath.empty in
    let test = MLLPath.is_empty path in
    if test then
        Printf.printf "OK Test Empty\n"
    else
        Printf.printf "XX Test Empty\n"

let test_insert =
    let path = MLLPath.make 1 in
    let test = MLLPath.mem 1 path in
    if test then
        Printf.printf "OK Test Insert 1\n"
    else
        Printf.printf "XX Test Insert 1\n"

let test_insert_2 =
    let path = MLLPath.insert 3 2 (MLLPath.insert 2 1 (MLLPath.make 1)) in
    let test = MLLPath.mem 1 path && MLLPath.mem 2 path && MLLPath.mem 3 path in
    if test then
        Printf.printf "OK Test Insert 2\n"
    else
        Printf.printf "XX Test Insert 2\n"

let test_insert_after_non_existent =
    let test =
        try
            let _ = MLLPath.insert 2 1 (MLLPath.make 3) in false
        with Not_found -> true
    in
    if test then
        Printf.printf "OK Test Insertion Après Absent\n"
    else
        Printf.printf "XX Test Insertion Après Absent\n"

let test_insert_already_in_path =
    let test =
        try
            let _ = MLLPath.insert 2 1 (MLLPath.make 2) in false
        with MLLPath.AlreadyInPath -> true
    in
    if test then
        Printf.printf "OK Test Insertion Déjà Dans Chemin\n"
    else
        Printf.printf "XX Test Insertion Déjà Dans Chemin\n"

