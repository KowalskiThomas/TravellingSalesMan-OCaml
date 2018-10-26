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

let test_insert_two = 
    let path = MLLPath.insert 2 1 (MLLPath.make 1) in 
    let next_1 = MLLPath.get_next 1 path in
    let next_2 = MLLPath.get_next 2 path in 
    let last_1 = MLLPath.get_last 1 path in 
    let last_2 = MLLPath.get_last 2 path in 
    if next_1 = 2 && next_2 = 1 && last_1 = 2 && last_2 = 1 then
        Printf.printf "OK Test Insertion Deux Elements\n"
    else
        Printf.printf "XX Test Insertion Deux Elements\n\tNext 1 %d\n\tNext 2 %d\n\tLast 1 %d\n\tLast 2 %d\n" next_1 next_2 last_1 last_2

let test_insert_next =
    let path = MLLPath.insert 3 2 (MLLPath.insert 2 1 (MLLPath.make 1)) in
    let next_3 = MLLPath.get_next 3 path in
    let next_2 = MLLPath.get_next 2 path in
    let next_1 = MLLPath.get_next 1 path in
    let test = next_1 = 2 && next_2 = 3 && next_3 = 1 in
    if test then
        Printf.printf "OK Test Insertion Next\n"
    else
        Printf.printf "XX Test Cycle\n\tNext 1 = %d (expected 2)\n\tNext 2 = %d (expected 3)\n\tNext 3 = %d (expected 1)\n" next_1 next_2 next_3

let test_insert_last =
    let path = MLLPath.insert 3 2 (MLLPath.insert 2 1 (MLLPath.make 1)) in
    let last_3 = MLLPath.get_last 3 path in
    let last_2 = MLLPath.get_last 2 path in
    let last_1 = MLLPath.get_last 1 path in
    let test = last_1 = 3 && last_2 = 1 && last_3 = 2 in
    if test then
        Printf.printf "OK Test Insertion Last\n"
    else
        Printf.printf "XX Test Cycle\n\tLast 1 = %d (expected 3)\n\tLast 2 = %d (expected 1)\n\tLast 3 = %d (expected 2)\n" last_1 last_2 last_3

let test_remove_1 = 
    let path = MLLPath.make 1 in 
    let removed = MLLPath.remove 1 path in
    let test_1 = not (MLLPath.mem 1 removed) in 
    let test_2 = MLLPath.is_empty removed in 
    if test_1 && test_2 then
        Printf.printf "OK Test Remove avec 1 élément\n"
    else
        Printf.printf "XX Test Remove avec 1 élément\n\tRemoved: %b\n\tEmpty: %b\n" test_1 test_2

let test_remove_2 =
    let path = MLLPath.insert 2 1 (MLLPath.make 1) in
    let removed = MLLPath.remove 1 path in 
    let test_1 = not (MLLPath.mem 1 removed) in
    let next_2 = MLLPath.get_next 2 removed in
    let last_2 = MLLPath.get_last 2 removed in
    let test_2 = next_2 = 2 in
    let test_3 = last_2 = 2 in
    if test_1 && test_2 && test_3 then
        Printf.printf "OK Test Suppression avec 2 éléments\n"
    else
        Printf.printf "XX Test suppression avec 2 éléments\n\t1 Removed: %b\n\tNext(2) = %d\n\tLast(2) = %d\n" test_1 next_2 last_2

let test_remove =
    let path = MLLPath.insert 3 2 (MLLPath.insert 2 1 (MLLPath.make 1)) in
    let removed = MLLPath.remove 2 path in
    let test_1 = not(MLLPath.mem 2 removed) in
    if test_1 then
        Printf.printf "OK Test Suppression\n"
    else
        Printf.printf "XX Test suppression\n"

let test_remove_next = 
    let path = MLLPath.insert 3 2 (MLLPath.insert 2 1 (MLLPath.make 1)) in
    let removed = MLLPath.remove 2 path in
    let next_3 = MLLPath.get_next 3 removed in 
    let next_1 = MLLPath.get_next 1 removed in 
    let test_1 = next_3 = 1 in 
    let test_2 = next_1 = 3 in 
    if test_1 && test_2 then
        Printf.printf "OK Test Suppression Next\n"
    else
        Printf.printf "XX Test Suppression Next\n\tNext 3 : %d\n\tNext 1 : %d\n" next_3 next_1

let test_remove_last = 
    let path = MLLPath.insert 3 2 (MLLPath.insert 2 1 (MLLPath.make 1)) in
    let removed = MLLPath.remove 2 path in
    let last_3 = MLLPath.get_last 3 removed in 
    let last_1 = MLLPath.get_last 1 removed in 
    let test_1 = last_3 = 1 in 
    let test_2 = last_1 = 3 in 
    if test_1 && test_2 then
        Printf.printf "OK Test Suppression Last\n"
    else
        Printf.printf "XX Test Suppression Last\n\tLast 3 : %d\n\tLast 1 : %d\n" last_3 last_1

let test_remove_absent =
    let path = MLLPath.make 1 in
    let test =
        try
            let _ = MLLPath.remove 2 path in false
        with MLLPath.NotInPath -> true
    in
    if test then
        Printf.printf "OK Test Remove Absent\n"
    else
        Printf.printf "XX Test Remove Absent\n"


(*
let test_swap =
    (* Initial : 1 2 3 4 5 6 7*)
    let initial = MLLPath.insert 7 6 (MLLPath.insert 6 5 (MLLPath.insert 5 4 (MLLPath.insert 4 3 (MLLPath.insert 3 2 (MLLPath.insert 2 1 (MLLPath.make 1)))))) in
    let swapped
    let test = next_2 = 4 && next_3 = 2 in
    if test then
        Printf.printf "OK Test Swap\n"
    else
        Printf.printf "XX Test Swap\n\tNext of 2 = %d\n\tNext of 3 = %d\n" next_2 next_3
*)


(*
    (* Swapped : 1 3 2 4 *)
    let swapped = MLLPath.swap 2 3 initial in
    (* Next of 2 should be 4 *)
    let next_2 = MLLPath.get_next 2 swapped in
    (* Next of 3 should be 2 *)
    let next_3 = MLLPath.get_next 3 swapped in
    (* Last of 4 should be 2 *)
    let last_4 = MLLPath.get_last 4 swapped in
    (* Next of 1 should be 3 *)
    let next_1 = MLLPath.get_next 1 swapped in
*)