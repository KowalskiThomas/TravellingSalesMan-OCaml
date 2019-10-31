Programmation fonctionnelle: projet 2018
========================================

  

### Dates et principe

Cette page peut être mise à jour, avec informations complémentaires, précisions, etc. Pensez à y revenir souvent.  

* * *

Projet à rendre pour le vendredi **11/01/2019** à **23h59**, aucun retard ne sera toléré.  
Des soutenances pourront être organisées ensuite.  
  
Lire tout le sujet (tout ? tout).  
  
Un rendu de projet comprend :

*   Un rapport précisant et justifiant vos choix (de structures, etc.), les problèmes techniques qui se posent et les solutions trouvées ; il donne en conclusion les limites de votre programme. Le rapport sera de préférence composé avec LaTeX. Le soin apporté à la grammaire et à l'orthographe est largement pris en compte.
*   Un manuel d'utilisation, même minimal.
*   Un code _abondamment_ commenté ; la première partie des commentaires comportera systématiquement les lignes :  
    

1.  @requires décrivant les pré-conditions : c'est-à-dire conditions sur les paramètres pour une bonne utilisation (**pas de typage ici**),
2.  @ensures décrivant la propriété vraie à la sortie de la fonction lorsque les pré-conditions sont respectées, le cas échéant avec mention des comportements en cas de succès et en cas d'échec,
3.  @raises énumérant les exceptions éventuellement levées (et précisant dans quel(s) cas elles le sont).

On pourra préciser des informations additionnelles si des techniques particulières méritent d'être mentionnées.  
  
Le code doit enfin **compiler** sans erreur (évidemment) et sans warning sur les machines des salles de TP.

Avez-vous lu tout le sujet ?

* * *

#### Protocole de dépôt

Vous devez rendre :

*   votre rapport au format pdf
*   vos fichiers de code.
*   vos tests.

rassemblés dans une archive tar gzippée identifiée comme _votre\_prénom\_votre\_nom_.tgz.  
La commande devrait ressembler à :  
tar cvfz randolph\_carter.tgz rapport.pdf fichiers.ml autres\_truc\_éventuels…

**Lisez le man** et testez le contenu de votre archive. Une commande comme par exemple :  
tar tvf randolph\_carter.tgz  
doit lister les fichiers et donner leur taille.  
Une archive qui ne contient pas les fichiers demandés ne sera pas excusable. Une archive qui n'est pas au bon format ne sera pas considérée.

**Procédure de dépôt**  
Vous devez enregistrer votre archive tar dans le dépôt dédié au cours IPF (ipf-s3-projet-2018) en vous connectant à http://exam.ensiie.fr. Ce dépôt sera ouvert jusqu'au 11 janvier inclus.

* * *

### Contexte

Le but de ce projet est de créer un planificateur de tournées efficace.

Dans le monde moderne, il est important de pouvoir planifier rapidement des tournées efficaces. Vous avez été choisis pour proposer et développer un tel planificateur permettant de relier un grand nombre de villes (de l'ordre du millier) entre elles.

Notre projet se développera en deux étapes :

1.  dans un premier temps, afin de faciliter votre tâche, toutes les villes seront **directement** accessibles depuis toutes les autres villes,
2.  dans un second temps, certaines routes directes seront coupées.

Votre programme devra trouver une tournée aussi optimale que possible répondant aux contraintes suivantes :

*   la ville de départ et la ville d'arrivée de la tournée doivent être les mêmes;
*   toutes les villes doivent être visitées au moins une fois (il est possible de visiter plusisieurs fois la même ville);
*   la distance totale parcourue doit être aussi réduite que possible;
*   si une ville A est reliée directement à une ville B, alors la ville B est reliée directement à la ville A par un trajet de même longueur (les routes sont toutes à double sens).

La distance de parcours entre deux villes sera toujours la distance euclidienne entre leurs coordonnées.

Étonnamment, ce problème est particulièrement complexe à résoudre de manière optimale. On ne connaît pas (et il est peu probable que l'on connaisse un jour) d'algorithme exact (qui trouve une tournée optimale) fondamentalement plus efficace que d'énumérer toutes les tournées possibles pour sélectionner la meilleure. Votre planificateur devant répondre avant la mort thermique de l'univers, il ne vous est pas demandé de donner une solution optimale mais une approximation raisonnable de cette solution.

Une assez bonne approximation (de l'ordre de quelques fois la distance minimale) peut être trouvée en un temps raisonnable de la manière suivante :

1.  on commence par choisir une première tournée sur un petit nombre de villes;
2.  on incorpore petit à petit les villes manquantes de manière à ne pas trop augmenter la longueur totale de la tournée;
3.  on applique enfin un certain nombre d'heuristiques locales permettant de diminuer encore la longueur de la tournée.

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
