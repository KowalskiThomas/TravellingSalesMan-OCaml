default: all_tests

merlin:
	ocamlbuild merlin.ml

tests_carte:
	ocamlbuild tests_carte.native
	./tests_carte.native

tests_mll_path:
	ocamlbuild tests_mll_path.native
	./tests_mll_path.native

tests_insert:
	ocamlbuild tests_insert.native
	./tests_insert.native

all_tests: tests_carte tests_mll_path tests_insert

projet:
	ocamlbuild projet.native
	./projet.native