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
        with MLLPath.NotInPath -> true
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


let test_swap_not_in_path =
    let initial = MLLPath.insert 3 1 (MLLPath.make 1) in
    let success =
        try
            let _ = MLLPath.swap 1 2 initial in false
        with MLLPath.NotInPath -> true
    in
    if success then
        Printf.printf "OK Test Swap Not In Path\n"
    else
        Printf.printf "XX Test Swap Not In Path\n"

let test_swap_touching =
    (* Go from 1 2 3 4 5 6 7 *)
    (* TO      1 2 4 3 5 6 7 *)
    let initial = MLLPath.insert 7 6 (MLLPath.insert 6 5 (MLLPath.insert 5 4 (MLLPath.insert 4 3 (MLLPath.insert 3 2 (MLLPath.insert 2 1 (MLLPath.make 1)))))) in
    let swapped = MLLPath.swap 3 4 initial in
    let next_2 = MLLPath.get_next 2 swapped in
    let next_3 = MLLPath.get_next 3 swapped in
    let next_4 = MLLPath.get_next 4 swapped in
    let last_5 = MLLPath.get_last 5 swapped in
    let last_3 = MLLPath.get_last 3 swapped in
    let last_4 = MLLPath.get_last 4 swapped in
    let test_1 = next_2 = 4 in
    let test_2 = next_3 = 5 in
    let test_3 = next_4 = 3 in
    let _ =
        if test_1 && test_2 && test_3 then
            Printf.printf "OK touching next\n"
        else
            let _ = MLLPath.print swapped in
            Printf.printf "XX touching next\n"
    in
    let test_1 = last_4 = 2 in
    let test_2 = last_3 = 4 in
    let test_3 = last_5 = 3 in
    let _ =
        if test_1 && test_2 && test_3 then
            Printf.printf "OK touching last\n"
        else
            let _ = MLLPath.print swapped in
            Printf.printf "XX touching last\n" in ()

let test_swap_touching_3 =
    let _ = Printf.printf "Testing swap touching 3\n" in
    (* From 1 2 3 *)
    (* To   1 3 2 *)
    let initial = MLLPath.insert 3 2 (MLLPath.insert 2 1 (MLLPath.make 1)) in
    let swapped = MLLPath.swap 2 3 initial in
    let next_1 = MLLPath.get_next 1 swapped in
    let next_2 = MLLPath.get_next 2 swapped in
    let next_3 = MLLPath.get_next 3 swapped in
    let last_1 = MLLPath.get_last 1 swapped in
    let last_2 = MLLPath.get_last 2 swapped in
    let last_3 = MLLPath.get_last 3 swapped in
    let test_1 = next_1 = 3 in
    let test_2 = next_3 = 2 in
    let test_3 = next_2 = 1 in
    let _ =
        if test_1 && test_2 && test_3 then
            Printf.printf "OK Touching 3 Next\n"
        else
            let _ = MLLPath.print swapped in
            Printf.printf "XX Touching 3 Next\n"
    in
    let test_1 = last_1 = 2 in
    let test_2 = last_2 = 3 in
    let test_3 = last_3 = 1 in
    let _ =
        if test_1 && test_2 && test_3 then
            Printf.printf "OK Touching 3 Last\n"
        else
            let _ = MLLPath.print swapped in
            Printf.printf "XX Touching 3 Last\n" in ()



let test_swap_unary =
    let initial = MLLPath.make 1 in
    let swapped = MLLPath.swap 1 1 initial in
    if swapped = initial then
        Printf.printf "OK Test Swap Unary\n"
    else
        Printf.printf "XX Test Swap Unary\n"

let test_swap_binary =
    let initial = MLLPath.insert 2 1 (MLLPath.make 1) in
    let swapped = MLLPath.swap 1 2 initial in
    if swapped = initial then
        Printf.printf "OK Test Swap Binary\n"
    else
        Printf.printf "XX Test Swap Binary\n"

let test_swap_binary_permutation =
    let initial = MLLPath.insert 2 1 (MLLPath.make 1) in
    let swapped_1 = MLLPath.swap 1 2 initial in
    let swapped_2 = MLLPath.swap 2 1 initial in
    if swapped_1 = swapped_2 then
        Printf.printf "OK Test Swap Binary Permutation\n"
    else
        Printf.printf "XX Test Swap Binary Permutation\n"

let test_swap_3 =
    (* Before: 1 2 3 *)
    (* After:  2 1 3 *)
    let initial = MLLPath.insert 3 2 (MLLPath.insert 2 1 (MLLPath.make 1)) in
    let swapped = MLLPath.swap 2 1 initial in
    let next_2 = MLLPath.get_next 2 swapped in
    let next_1 = MLLPath.get_next 1 swapped in
    let next_3 = MLLPath.get_next 3 swapped in
    let test_1 = next_2 = 1 in
    let test_2 = next_1 = 3 in
    let test_3 = next_3 = 2 in
    if test_1 && test_2 && test_3 then
        Printf.printf "OK Test Swap 3\n"
    else
        let _ = MLLPath.print swapped  in
        Printf.printf "XX Test Swap 3\n\tNext 1 = %d\n\tNext 2 = %d\n\tNext 3 = %d" next_1 next_2 next_3

let test_swap =
    (* Initial : 1 2 3 4 5 6 7 *)
    let initial = MLLPath.insert 7 6 (MLLPath.insert 6 5 (MLLPath.insert 5 4 (MLLPath.insert 4 3 (MLLPath.insert 3 2 (MLLPath.insert 2 1 (MLLPath.make 1)))))) in
    (* Swapped : 1 2 3 6 5 4 7 *)
    let swapped = MLLPath.swap 6 4 initial in
    let swapped_2 = MLLPath.swap 4 6 initial in
    let next_1 = MLLPath.get_next 1 swapped in
    let next_2 = MLLPath.get_next 2 swapped in
    let next_3 = MLLPath.get_next 3 swapped in
    let next_4 = MLLPath.get_next 4 swapped in
    let next_5 = MLLPath.get_next 5 swapped in
    let next_6 = MLLPath.get_next 6 swapped in
    let next_7 = MLLPath.get_next 7 swapped in
    let last_1 = MLLPath.get_last 1 swapped in
    let last_2 = MLLPath.get_last 2 swapped in
    let last_3 = MLLPath.get_last 3 swapped in
    let last_4 = MLLPath.get_last 4 swapped in
    let last_5 = MLLPath.get_last 5 swapped in
    let last_6 = MLLPath.get_last 6 swapped in
    let last_7 = MLLPath.get_last 7 swapped in
    let test_1 = next_1 = 2 && last_1 = 7 in
    let test_2 = next_2 = 3 && last_2 = 1 in
    let test_3 = next_3 = 6 && last_3 = 2 in
    let test_4 = next_4 = 7 && last_4 = 5 in
    let test_5 = next_5 = 4 && last_5 = 6 in
    let test_6 = next_6 = 5 && last_6 = 3 in
    let test_7 = next_7 = 1 && last_7 = 4 in
    if test_1 && test_2 && test_3 && test_4 && test_5 && test_6 && test_7 then
        let _ = MLLPath.print swapped in
        let _ = MLLPath.print swapped_2 in
        Printf.printf "OK Test Swap One Between\n"
    else
        let _ = Printf.printf "Initial\n\t" in
        let _ = MLLPath.print initial in
        let _ = Printf.printf "Swapped\n\t" in
        let _ = MLLPath.print swapped in
        Printf.printf "XX Test Swap One Between\n"