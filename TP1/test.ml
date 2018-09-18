open Int_set

let s = Int_set.add 3 (Int_set.add 5 (Int_set.add 1 Int_set.empty))

let printset l p = List.map p l; print_string "\n"

let printint x = print_int x and print_string " "

printset s printint

let _ =
  Printf.printf "test %d\n" 34
