all: default

default: 
	@echo "-- Use make help to get a detailed explanation of what binaries do --"
	@echo "all_tests: Executes all tests"
	@echo "compile:   Compiles all delivered (non-test) binaries"
	@echo "run:       Starts finding and optimising a solution using settings from config.txt and the default city file."
	@echo "run_all:   Starts finding and optimising solutions with all possible settings using the default city file."

help:
	@echo "-- Use make without an argument (or make default) to get a list of targets --"
	@echo "Use of binaries:"
	@echo "    ./all.native <city file>:    Finds and optimises solutions using all possible settings for the given file."
	@echo "    ./projet.native <city file>: Finds and optimises a solution for the given city file using the settings from config.txt"
	@echo "NOTE: Without a city file provided, the file villes.complete.txt will be used."

merlin:
	ocamlbuild merlin.native

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

all_opt:
	ocamlbuild all.native

run: projet
	./projet.native

run_all: all_opt
	./all.native

compile: all_opt projet

clean:
	rm -rf *.cmo *.cmi *.cmx *.native *.out *.byte _build log *.tgz *.tar.gz

tar: clean
	tar -cvzf Thomas_Kowalski.tgz *
