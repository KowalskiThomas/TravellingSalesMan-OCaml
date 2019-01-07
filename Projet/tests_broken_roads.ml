module Carte = ICarte.Carte

let _ = Random.self_init()

let cities = [
    ("Paris", 1.0, 0.0);
    ("Londres", 2.0, 1.0);
    ("Berlin", 2.0, 0.0);
    ("Helsinki", 3.0, 4.0)
]

let _ = 
  let br = 