# TravelingSalesMan - OCaml

*This repository is currently undergoing an English translation.*

This repository contains the OCaml code I wrote during my Functional Programming class :
* Data structures (sets and maps, mainly) in `TP`, used mainly in the project
* An implementation of an approximate solver for the Traveling Salesman Problem (TSP) in `Project`. 

This implementation has been designed to run quickly on high-cardinality inputs (the success criterion was to run in less than five seconds on a 1000 cities input, giving "good" results - meaning at least as good as the professor - on a *modern* computer). No threading or parallelisation was to be used.

The full specification can be seen in *spec_fr.html* (to be translated in English soon). 

Compiling the project requires:
* `ocaml` 
* `ocamlbuild`
* `make`

Typing `make` will output a list of possible actions.
