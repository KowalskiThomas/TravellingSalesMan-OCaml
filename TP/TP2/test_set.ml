(** Module de générique pour les emsembles d'entiers 
 *)
open Int_set

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

let _ =
  List.iter do_test tests_bool;
  List.iter do_test tests_exn
