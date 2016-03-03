type t = string * string

let make name dna_string =
  (name, dna_string)

let get_name seq =
  let (name, _) = seq in name

let get_dna seq =
  let (_, dna) = seq in dna



(* renvoi la liste de l'ensemble des couples (i, s) avec s la sous chaine commençant à l'indice i de la chaine [string] (pour tout i allant de 0 à |string|*)
let extract_suffixes string =
  let length = String.length string in
  let rec aux acc = function
    | i when i = length -> acc
    | i ->
       let substring = String.sub string i (length - i)
       in aux ((i, substring)::acc) (i + 1)
  in List.rev (aux [] 0)
			  
let extract_suffix_array seq =
  let dna_string = get_dna seq in
  let suffix_list = extract_suffixes (dna_string^"$") in
  (*trie de la liste des suffixe*)
  let f (_, s1) (_, s2) = compare s1 s2 in
  let sorted_suffix_list = List.sort f suffix_list in
  let i_list = List.map (fun (i, _) -> i) sorted_suffix_list in
  Array.of_list i_list
