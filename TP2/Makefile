module:
	ocamlc int_set_f.mli
	ocamlc  -c -g int_set_f.ml

tests: module
	ocamlc -g int_set_f.cmo test_set_f.ml
	./a.out
