open Int_set_f

let test_with msg f e =
  let t0 = Sys.time () in
  let res = f e in
  let t1 = Sys.time () in
  (t1-.t0,res)


module Test(M:IntSet) =
  struct
    open M


    let do_test (test_name,test_function,wanted_anwser,print_anwser) =
      try
        let res = test_function () in (* on effectue le test *)
        if res = wanted_anwser
        then (* Si le test est valide on affiche le nom du test suivit de "Ok" *)
          Format.printf "%s : Ok@." test_name
        else
          (* Sinon : *)
          Format.printf
            "%s : Error : wanted:=%a obtained:=%a@."
            test_name print_anwser wanted_anwser print_anwser res
      with e ->
        Format.printf "%s : Uncaught exception %s@." test_name (Printexc.to_string e)

    (** [do_test (test_name,test_function,wanted_anwser,print_anwser)]
effectue un test, le vérifie et affiche le résultat
     *)


    (** Quelques fonctions d'affichage *)


    let fprintf_bool fmt b = Format.fprintf fmt "%b" b
    (** affichage pour les résultats booléen *)

    let fprintf_int fmt n = Format.fprintf fmt "%d" n
    (** affichage pour les résultats booléen *)

    let fprintf_set fmt s =
      Format.fprintf fmt "[%a]"
        (fun fmt s -> fold (fun e _ -> Format.fprintf fmt "%d; " e) s ())
        s
    (** affichage pour les résultats de type int_set *)

    let fprintf_exn fmt e = Format.fprintf fmt "%s" (Printexc.to_string e)
    (** affichage pour les résultats de type exn (exception) *)


    exception Error of string * exn
    (** Une exception pour les tests qui ne renvoient pas la bonne exception *)

    (** Les premiers tests *)
    let tests_bool =
      [ "empty_is_empty", (fun () -> (is_empty empty)), true, fprintf_bool;
        "empty_not_mem", (fun () -> mem 3 empty),false,fprintf_bool;
        "add_not_empty",(fun () -> is_empty (add 3 empty)),false,fprintf_bool;
        "add_mem_1",(fun () -> mem 3 (add 3 empty)),true,fprintf_bool;
        "add_mem_2",(fun () -> mem 3 (add 3 (add 2 empty))),true,fprintf_bool;
        "add_mem_3",(fun () -> mem 2 (add 3 (add 2 empty))),true,fprintf_bool;
        "remove_not_mem",(fun () -> mem 2 (remove 2 (add 2 (add 2 empty)))),false,fprintf_bool;
      ]

    let tests_exn =
      [
        "get_min_empty",(fun () ->
          try
            ignore(get_min empty);
            raise (Error ("Should raise",EmptySet))
          with e -> e
        ),EmptySet,fprintf_exn;
      ]


    let replay_tests random ordered =
      let replay l =
        List.fold_left
          (fun s (f,e)  ->
            let f =
              if f = "add"
              then add
              else if f = "remove"
              then remove
              else if f = "remove_min"
              then (fun _ s -> try remove (get_min s) s with EmptySet -> s)
              else assert false
            in f e s
          )  empty l
      in
      List.iter do_test tests_bool;
      List.iter do_test tests_exn;
      let t_random = test_with "random" replay random in
      let t_ordered = test_with "ordered" replay ordered in
      t_random,t_ordered
  end

let rec check l1 l2 l3 =
  match l1,l2,l3 with
  | [],[],[] -> ()
  | h1::l1',h2::l2',h3::l3' ->
     if h1=h2 && h1 = h3
     then check l1' l2' l3'
     else
       if h1 = h2
       then Format.printf "%d = %d <> %d@." h1 h2 h3
       else if h2 = h3
       then Format.printf "%d <> %d = %d@." h1 h2 h3
       else Format.printf "%d <> %d <> %d@." h1 h2 h3
  | h1::_,h2::_,[] ->
     if h1=h2
     then Format.printf "%d = %d <> ???@." h1 h2
     else Format.printf "%d <> %d <> ???@." h1 h2
  | h1::_,[],h3::_ -> Format.printf "%d <> ??? <> %d@." h1 h3
  | [],h2::_,h3::_ ->
     if h2=h3
     then Format.printf "??? <> %d = %d@." h2 h3
     else Format.printf "??? <> %d <> %d@." h2 h3
  | [],[],h3::_ -> Format.printf "??? <> ??? <> %d@." h3
  | [],h2::_,[] -> Format.printf "??? <> %d <> ???@." h2
  | h1::_,[],[] -> Format.printf "%d <> ??? = ???@." h1

let random_tests () =
  let test_add_remove nb val_max =
    let rec aux l n =
      if n = 0
      then List.rev l
      else
        let e = Random.int val_max in
        let fn = if Random.bool () then "add" else "remove" in
        aux ((fn,e)::l) (n-1)
    in
    aux [] nb
  in
  test_add_remove 1000000 1000

(* let main () = 
  let module TInt = Test(IntSetIntervals) in
  let random = random_tests () in
  let ordered = List.sort (fun (fn1,e1) (fn2,e2) ->
                    if fn1=fn2
                    then compare e1 e2
                    else if fn1 = "add" then 1 else -1
                  ) random in
  let ordered = List.rev_map (fun (f,e) -> if f = "remove" then ("remove_min",e) else (f,e)) ordered in
  let ((interval_time_random,interval_random), (interval_time_ordered,interval_ordered)) = TInt.replay_tests random ordered in
  let _ = Format.printf "Thomas!@"
  ()

let _ = main () *)

open IntSetAbr
let _ = 
  let s = 
  add 3 (
    remove 3 ( remove 2 (
    add 2 (
      add 5 (
        add 3 (
            add 5555 (
              add 1234 (
                empty
              )
          )
        ) )
      )
      )
    )
  ) 
  in
  print s

let main () =
  let module TList = Test(IntSetList) in
  let module TAbr = Test(IntSetAbr) in
  let module TInt = Test(IntSetIntervals) in
  let random = random_tests () in
  let ordered = List.sort (fun (fn1,e1) (fn2,e2) ->
                    if fn1=fn2
                    then compare e1 e2
                    else if fn1 = "add" then 1 else -1
                  ) random in
  let ordered = List.rev_map (fun (f,e) -> if f = "remove" then ("remove_min",e) else (f,e)) ordered
  in
  let _ = Format.printf "ABR :: @." in
  let ((abr_time_random,abr_random),(abr_time_ordered,abr_ordered)) = TAbr.replay_tests random ordered in
  let _ = Format.printf "@.Interval :: @." in
  let ((interval_time_random,interval_random),(interval_time_ordered,interval_ordered)) = TInt.replay_tests random ordered in
  let _ = Format.printf "@.List :: @." in
  let ((list_time_random,list_random),(list_time_ordered,list_ordered)) =   TList.replay_tests random ordered in
  Format.printf "%49s|%10s|%10s|%10s@." "" "LIST" "INTERVALS" "ABR";
  Format.printf "%s@." (String.make 82 '_');
  Format.printf
    "%49s|%10f|%10f|%10f@."
    "Random 1 000 000 add/remove between 0..9999"
    list_time_random
    interval_time_random
    abr_time_random
  ;
  Format.printf
    "Ordered 1 000 000 add between 0..9999 remove min |%10f|%10f|%10f@."
    list_time_ordered
    interval_time_ordered
    abr_time_ordered
  ;
    let labr_random = IntSetAbr.fold (fun e acc -> e::acc) abr_random []
    and lint_random = IntSetIntervals.fold (fun e acc -> e::acc) interval_random []
    and llist_random = IntSetList.fold (fun e acc -> e::acc) list_random []
    in
    check llist_random lint_random labr_random;
    let labr_ordered = IntSetAbr.fold (fun e acc -> e::acc) abr_ordered []
    and lint_ordered = IntSetIntervals.fold (fun e acc -> e::acc) interval_ordered []
    and llist_ordered = IntSetList.fold (fun e acc -> e::acc) list_ordered []
    in
    check llist_ordered lint_ordered labr_ordered;
    ()

let _ = main ()

