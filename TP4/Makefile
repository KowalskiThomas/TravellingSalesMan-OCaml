default: tests

module:
	ocamlc set.mli
	ocamlc S.mli
	ocamlc graph.mli
	# ocamlc AVLMap.mli
	ocamlc -c -g set.ml
	# ocamlc -c -g S.ml
	ocamlc -c -g graph.ml
	ocamlc -c -g AVLMap.ml

tests: module
	ocamlc -g S.cmo set.cmo graph.cmo tests.ml

exec: tests
	./a.out
