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

Pour chacune des trois phases, on peut trouver plusieurs alternatives crédibles.

1.  la recherche d'une tournée sur un petit nombre de ville peut être ainsi :
    1.  on se restreint à une tournée de départ sur une seule ville,
    2.  ou bien on part d'une tournée sur l'[enveloppe convexe](https://en.wikipedia.org/wiki/Convex_hull) de l'ensemble des villes;
  
3.  l'incorporation peut se faire systématiquement d'une des manières suivantes :
    1.  insertion d'une ville aléatoire : on choisit une ville non encore présente sur la tournée de manière quelconque, on incorpore cette ville à la tournée partielle de manière à réduire le plus possible la distance totale parcourue pour la nouvelle tournée;
    2.  insertion de la ville la plus proche : on choisit une (souvent la) ville dont la distance minimale aux villes de la tournée partielle est minimale et on incorpore cette ville à la tournée partielle de manière à réduire le plus possible la distance totale parcourue pour la nouvelle tournée;
    3.  insertion de la ville la plus lointaine : on choisit une (souvent la) ville dont la distance minimale aux villes de la tournée partielle est maximale et on incorpore cette ville à la tournée partielle de manière à réduire le plus possible la distance totale parcourue pour la nouvelle tournée;
  
5.  plusieurs algorithme d'optimisation sont mis à votre disposition :
    1.  la méthode de repositionnement de noeud :
        1.  on sélectionne un trajet A-B-C (les liaisons entre les villes A et B et B et C étant directes) tel qu'il existe un trajet direct entre A et C;
        2.  retire la ville B de la tournée;
        3.  on cherche à insérer la ville B dans la tournée de manière à minimiser la longueur totale de la tournée.On conserve la nouvelle tournée si sa longueur totale est plus courte que l'ancienne tournée.
      
    3.  la méthode de l'inversion locale consiste :
        
        Supposons que notre tournée se décompose comme suit :
        
        1.  une liaison directe entre les ville A et B;
        2.  une liaison indirecte entre les villes B et C;
        3.  une liaison directe entre les ville C et D.
        
        la méthode de l'inversion locale sur ce trajet consiste à prendre en considération le chemin suivant (dans la mesure où il existe des liaisons directes entre A et C et B et D)
        
        1.  une liaison directe entre les ville A et C;
        2.  une liaison indirecte entre les villes C et B (dont l'existence est garanti par le fait que les chemins sont inversibles);
        3.  une liaison directe entre les ville B et D.
        
        On remplace l'ancien trajet par le nouveau si la distance totale parcourue est plus courte. Cette inversion est **locale** dans le sens où elle n'intervient que sur la partie de la tournée située entre A et D
        
        On ne conserve le nouveau chemin que si il est localement meilleur que l'ancien.

* * *

### Travail à effectuer

Vous devrez produire une bibliothèque implantant les différents algorithmes definis ci-dessus. Vous serez évalués, en particulier, sur les critères suivants :

*   la **qualité** de vos interfaces et de votre documentation;
*   la **pertinance** des structures de données employées;
*   la **modularité** de votre code: éviter autant que possible les répétitions de code (y compris entre les différentes phases du projet);
*   la **présence** de tests et une analyse critique des résultats obtenus.

Vous devrez également produire, pour chaque phase, un programme principal fournissant une recherche de tournée efficace avec les contraintes fixées.

* * *

### Phase 1: graphe complet

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
