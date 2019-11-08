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

During this first stage, all cities will be connected. The programme will take two arguments:

1. The first file will contain the configuration of the optimiser;
2. The second file wlil contain the cities data.

The output will be issued to the standard output.

### Optimiser configuration

The file format for configuration will be as follows.

* One word, `ONE` or `HULL`, describing the kind of search to use for the first stage. `ONE` will designate a unique city in the initial path, `HULL` will designate that the convex hull of the cities set should be used as the initial path;
* A line with a word among `RANDOM`, `NEAREST` and `FARTHEST`, describing what kind of insertion should be done to add new cities into the path. 
* A line with a word among `REPOSITIONING` or `INVERSION`, describing what kind of optimisation should be done once the path is full.

### Input format for Stage 1

* The first line will consist of a unique integer *n*;
* The *n* other lines will describe a city in the format `<city name> <longitude> <latitude>` (one string and two floats).

### Output format

Your programme should output the final path in the following format 

```
<distance> : <city 1> ... <city n> <city 1>
```

With `<distance>` the total distance for the path.


### Stage 2: Incomplete Non-Oriented Graph

For this second stage, your code will need to work on a graph where some roads have been removed. The graph will stay connex and symmetric. 

### Input format for stage 2

* The first line will consist of a unique integer *n*;
* The *n* following lines will each contain a city in the format `<city name> <longitude> <latitude>` (one string and two floats); 
* The *n* following lines will describe the existing roads. Each line will be in the format `<from>: <to 1> <to 2> ... <to k>`. Each city will have a line.
