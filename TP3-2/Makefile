default: tests

modulec:
	ocamlc set.mli
	ocamlc -c -g set.ml

moduleopt:
	ocamlopt set.mli
	ocamlopt -c -g set.ml

testsc: modulec
	ocamlc -g set.cmo tests.ml
	./a.out

testsopt: moduleopt
	ocamlopt -g set.cmx tests.ml
	./a.out

tests: testsopt