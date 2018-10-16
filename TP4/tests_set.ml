
module StringSet = EnsembleAVL.MakeEnsembleAVL(String)

let test =
  let test = StringSet.add "1" StringSet.empty in
  let test = StringSet.add "2" test in
  let test = StringSet.add "3" test in
  let resultat1 = StringSet.mem test "1" in
  let resultat2 = StringSet.mem test "2" in
  let resultat3 = StringSet.mem test "3" in

  if resultat1 && resultat2 && resultat3  then
    Printf.printf "OK: 1, 2, 3\n"
  else
    Printf.printf "NOK: 1, 2, 3\n"

let test =
  let test = StringSet.add "2" StringSet.empty in
  let test = StringSet.add "1" test in
  let test = StringSet.add "3" test in
  let resultat1 = StringSet.mem test "2" in
  let resultat2 = StringSet.mem test "1" in
  let resultat3 = StringSet.mem test "3" in

  if resultat1 && resultat2 && resultat3 then
    Printf.printf "OK: 2, 1, 3\n"
  else
    Printf.printf "NOK: 2, 1, 3 %b %b %b\n" resultat1 resultat2 resultat3

let test =
  let rec insert x =
    if x = 0 then StringSet.empty
    else StringSet.add (string_of_int x) (insert (x - 1)) in

  let test = insert 999 in
  let resultat20 = StringSet.mem test "20" in

  if resultat20 then
    Printf.printf "OK: 1 - 999\n"
  else
    Printf.printf "NOK: 1 - 999 => %b \n" resultat20

let test =
  let test = StringSet.add "1" StringSet.empty in
  let test = StringSet.add "2" test in
  let test = StringSet.add "3" test in
  let test = StringSet.remove "2" test in
  if not (StringSet.mem test "2")
  then Printf.printf "OK: Pair removed\n"
  else Printf.printf "NOK: Item not removed\n"

let test =
  let test = StringSet.add "1" StringSet.empty in
  let test = StringSet.add "2" test in
  let test = StringSet.add "3" test in
  let test = StringSet.remove "2" test in
  let test = StringSet.remove "1" test in
  let test = StringSet.remove "3" test in
  let result = StringSet.is_empty test in
  if result
  then Printf.printf "OK: Empty Map\n"
  else Printf.printf "NOK: Map is not empty\n"

let test =
  let empty = StringSet.empty in
  let result = StringSet.is_empty empty in
  if result
  then Printf.printf "OK: StringSet.empty is empty\n"
  else Printf.printf "NOK: StringSet.empty is not empty\n"

let test =
  let f v acc = v ^ acc in
  let test = StringSet.add "1" StringSet.empty in
  let test = StringSet.add "2" test in
  let test = StringSet.add "3" test in
  let result = StringSet.fold f test "" in
  if result = "321"
  then Printf.printf "OK: StringSet.fold\n"
  else Printf.printf "NOK: StringSet.fold = %s\n" result