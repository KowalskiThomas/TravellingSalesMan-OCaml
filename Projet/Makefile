all: default

default: 
	@echo "-- Utilisez make help pour l'utilisation détaillée des exécutables. --"
	@echo "all_tests: Lance tous les tests"
	@echo "compile:   Compile les exécutables finaux"
	@echo "run:       Lance l'optimisation avec les réglages de config.txt pour le fichier par défaut."
	@echo "run_all:   Lance l'optimisation avec tous les réglages possibles pour le fichier par défaut."

help:
	@echo "Options de compilation avec make: lancez make pour avoir la liste."
	@echo "Utilisation des livrables compilés:"
	@echo "    ./all.native <fichier de villes>:    Teste toutes les optimisations pour le fichier."
	@echo "    ./projet.native <fichier de villes>: Utilise config.txt pour appliquer une optimisation pour le fichier."
	@echo "REMARQUE: Si vous ne donnez pas de nom de fichier, le fichier villes.complete.txt sera utilisé."

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
