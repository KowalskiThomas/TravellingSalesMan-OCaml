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

tests_optimizer:
	ocamlbuild tests_optimizer.native
	./tests_optimizer.native

tests_hull:
	ocamlbuild tests_hull.native
	./tests_hull.native

tests_parser:
	ocamlbuild tests_parser.native
	./tests_parser.native

all_tests: tests_carte tests_mll_path tests_insert tests_optimizer tests_hull tests_parser

optimizers:
	ocamlbuild tests_all_optimizers.native
	./tests_all_optimizers.native

projet:
	ocamlbuild projet.native

run: projet
	./projet.native

clean:
	rm -rf *.cmo *.cmi *.cmx *.native *.out *.byte _build log *.tgz *.tar.gz

tar: clean
	tar -cvzf Thomas_Kowalski.tgz *
