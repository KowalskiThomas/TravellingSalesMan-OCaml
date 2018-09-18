default: tests

modulec:
	ocamlc int_set_f.mli
	ocamlc  -c -g int_set_f.ml

moduleopt:
	ocamlopt int_set_f.mli
	ocamlopt -c -g int_set_f.ml

testsc: modulec
	ocamlc -g int_set_f.cmo test_set_f.ml
	./a.out

testsopt: moduleopt
	ocamlopt -g int_set_f.cmx test_set_f.ml
	./a.out

tests: testsopt