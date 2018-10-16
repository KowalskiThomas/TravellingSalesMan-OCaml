default: tests

module:
	ocamlc Ensemble.mli
	ocamlc -c -g Ensemble.ml
	ocamlc Map.mli
	ocamlc -c -g AVLMap.ml
	ocamlc Graph.mli
	ocamlc -c -g Graph.ml

tests: module
	ocamlc -g *.cmo tests.ml

clean:
	rm *.cmi *.cmo *.cmx

exec: tests
	./a.out
