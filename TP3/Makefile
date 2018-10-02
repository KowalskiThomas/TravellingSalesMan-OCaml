default: tests

modulec:
	ocamlc set.mli
	ocamlc -c -g set.ml

moduleopt:
	ocamlopt set.mli
	ocamlopt -c -g set.ml

testsc: modulec
	ocamlc -g set.cmo tests.ml

testsopt: moduleopt
	ocamlopt -g set.cmx tests.ml

exec: testsc
	./a.out

tests: exec