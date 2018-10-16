
module StringMap = AVLMap.AVLMap(String)

let test_1 =
  let test = StringMap.add "1" 1 StringMap.empty in
  let test = StringMap.add "2" 2 test in
  let test = StringMap.add "3" 3 test in
  let resultat1 = StringMap.find test "1" in
  let resultat2 = StringMap.find test "2" in
  let resultat3 = StringMap.find test "3" in

  if resultat1 = 1 && resultat2 = 2 && resultat3 = 3 then
    Printf.printf "1, 2, 3 OK\n"
  else
    Printf.printf "1, 2, 3 NOK\n"

let test_2 =
  let test = StringMap.add "2" 1 StringMap.empty in
  let test = StringMap.add "1" 2 test in
  let test = StringMap.add "3" 3 test in
  let resultat1 = StringMap.find test "2" in
  let resultat2 = StringMap.find test "1" in
  let resultat3 = StringMap.find test "3" in

  if resultat1 = 1 && resultat2 = 2 && resultat3 = 3 then
    Printf.printf "2, 1, 3 OK\n"
  else
    Printf.printf "2, 1, 3 NOK %d %d %d\n" resultat1 resultat2 resultat3

let test_2 =
  let rec insert x =
    if x = 0 then StringMap.empty
    else StringMap.add (string_of_int x) x (insert (x - 1)) in

  let test = insert 999 in
  let resultat20 = StringMap.find test "20" in

  if resultat20 = 20 then
    Printf.printf "1 - 999 OK\n"
  else
    Printf.printf "1 - 999 NOK %d \n" resultat20