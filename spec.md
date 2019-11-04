The goal of this project is to create an **efficient** tour planner, for inputs of high cardinality (> 1000 cities).

The project will be split in two stages:

1. In a first time, all cities will be accessible from one to the other;
2. In a second time, only certain cities will be linked by roads.

Your programme will need to determine a tour as optimal as possible, with the following constraints:

* The first city shall be the same as the last city;
* All cities need to be visited at least once (it is possible to visit a city more than once);
* All roads are two-way (if city A is connected to city B with distance *d*, then city B is connected to city A with the same distance *d*);
* The goal is to minimise the overall distance.

We define the distance between two cities by the Euclidian distance between their coordinates (we will ignore Earth's curvature and will admit we are in Cartesian coordinates).

Since solving this problem exactly is hard and we do not know an algorithm of satisfactory complexity to do it, we will have to give approximate results :

1. Create a tour on a small number of cities;
2. Add one by one the other cities, trying to minimise the overall distance at every insertion;
3. Apply (local) heuristics to shrink distance.

Each of these three steps can be done using different techniques:

1. Creating a tour can be done
  1. Using a 1-city tour from a random city;
  2. Using the convex hull of the set of all cities.
2. Adding new cities can be done
  1. By choosing a random city and adding it where the overall distance is minised;
  2. By choosing the city closest to the current tour and adding it where the overall distance is minised;
  3. By choosing the city furthest to the current tour and adding it where the overall distance is minised.
3. Several algorithms are proposed:
  1. Node repositioning
     * Three connex (in the path) cities A-B-C are chosen. Assuming that a direct path exists between A and C;
     * City B is removd from the path
     * City B is reinserted in the path, minimising the overall distance. The new path is only kept if the overall distance has decreased.
  2. Local inversion
     * If the path is `A -> B -> ... -> C -> D`
     * If A and C are connex, B and D are connexion
     * We consider the path `A -> C -> ... -> B -> D`. The new path is only kept if the local distance has decreased (between A and D).

### Your task

Produce a library implementing the proposed algorithms. Will be assessed:
* **Quality** of interfaces and their documentation;
* **Pertinence** of chosen data structures;
* **Modularity** of your code (avoid at all costs code duplication; as much as possible, use the same code for different stages);
* The **tests** you provide and an critical analysis of your results.

You will also need to provide, for each stage, a main binary searching an efficient path with all defined constraints.

### Stage 1: Complete Graph 

Lors de cette phase, toutes les villes seront deux à deux reliées directement. Votre programme devra prendre deux noms de fichiers en argument :

1.  le premier fichier contiendra des informations relative au paramétrage de votre programme (cf [paramétrage](#params));
2.  le second fichier contiendra les informations utiles sur les villes (cf [format d'entrée](#format-entree)).

il devra (dans le temps autorisé qui sera de l'ordre de quelques secondes), trouver une tournée et l'afficher sur la sortie standard (cf [format de sortie](#format-sortie))

#### paramétrage :

le format du fichier de paramétres sera le suivant :

*   une ligne contenant un mot (soit "ONE" soit "HULL") décrivant le type de recherche souhaitée pour la première phase. "ONE" désignera la recherche initiale d'une ville unique et "HULL" désignera la recherche initiale à l'aide de l'enveloppe convexe. ([infos](#phase-1))
*   une ligne contenant un mot (soit "RANDOM", soit "NEAREST" soit "FARTHEST") décrivant le type de recherche souhaitée pour la complétion de la tournée. "RANDOM" désignera la méthode de d'incorporation aléatoire, "NEAREST" l'insertion de la ville la plus proche, et "FARTHEST" l'insertion de la ville la plus lointaine ([infos](#phase-2))
*   une ligne contenant un mots (soit "REPOSITIONNEMENT" soit "INVERSION") décrivant le type d'optimisation souhaitée. "REPOSITIONNEMENT" désignera la méthode de repositionnement et "INVERSION" la méthode d'inversion locales ([infos](#phase-3))

#### format d'entrée :

*   Une première ligne contenant un unique entier n.
*   n lignes comprenant chacune la description d'une ville au format :
    
    <nom de la ville> <longitude > < lattitude>
    
    les noms sont des chaînes de caractères, les coordonnées sont des flottant.

#### format de sortie :

Votre code devra écrire sur la sortie standard de votre programme le parcours trouvé au format suivant:

<distance> : <ville\_1> ... <ville\_k> <ville\_1>

où <distance> est la distance totale parcourue sur la tournée et le reste est la description de la tournée.

* * *

### Phase 2 : graphes non orientés connexes

Pour cette phase votre progamme devra travailler sur un graphe où certaines routes seront fermées (inaccessible). On garantira que le graphe des villes reste connexe et symétrique. Votre travail devra reprendre le travail de la partie 1 en prenant ces contraintes.

#### format d'entrée :

*   Une première ligne contenant un unique entier n.
*   n lignes comprenant chacune la description d'une ville au format :
    
    <nom de la ville> <longitude > < lattitude>
    
    les noms sont des chaîes de caractères, les coordonnées sont des flottant.
*   n lignes décrivant les routes. Chaque ligne sera au format :
    
    <départ> : <arrivée\_1> ... <arrivée\_k>
    
    Chaque ville apparaîtra exactement une fois comme ville de départ.

* * *

### Merci pour ce sujet...

Vous pouvez remercier (comme moi) M. Mouilleron à qui je n'ai servi que de rédacteur final et qui a corrigé de la plupart des pheauthes.
