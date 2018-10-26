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
    let test = MLLPath.meme 1 path in 
    if test then
        Printf.printf "thomas\n"
    else
        Printf.printf "errur\n"