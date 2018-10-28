merlin:
	ocamlbuild merlin.ml

tests_complete_carte:
	ocamlbuild tests_complete_carte.native
	./tests_complete_carte.native

tests_mll_path:
	ocamlbuild tests_mll_path.native
	./tests_mll_path.native

tests_insert:
	ocamlbuild tests_insert.native
	./tests_insert.native

all_tests: tests_complete_carte tests_mll_path

projet:
	ocamlbuild projet.native
	./projet.native