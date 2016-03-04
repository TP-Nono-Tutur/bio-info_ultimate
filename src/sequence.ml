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
  List.iter (fun (a,b) -> Printf.printf "%d,%s\n" a b) sorted_suffix_list;
  let i_list = List.map (fun (i, _) -> i) sorted_suffix_list in
  Array.of_list i_list



(* let search_naive next borne_cond suffix_array milieu read_seq dna_string = *)
(*   let length = String.length dna_string *)
(*   and read_length = String.length read_seq in *)
(*   let rec aux acc = function *)
(*     | i when borne_cond suffix_array.(i) read_length -> acc *)
(*     | i -> if (String.sub dna_string suffix_array.(i) read_length) = read_seq *)
(* 	   then aux (suffix_array.(i)::acc) (next i 1) *)

	      
								     
(* regarde si la sous chaine commençant à l'indice i de la chaine [s1] commance par la chaine [s2]*)
let compareBegining i s1 s2 =
  let length1 = String.length s1
  and length2 = String.length s2
  in let substring = if i + length2 >= length1
		     then String.sub s1 i (length1 - i)
		     else String.sub s1 i length2
     in compare substring s2
		    

		
let search read_seq seq = 
  let dna_string = get_dna seq
  and suffix_array = extract_suffix_array seq
  and read_length = String.length read_seq in
  let array_length = Array.length suffix_array in
  let rec dicho debut fin =
    if debut > fin then
      None
    else
      let milieu = (debut + fin) / 2 in
      match compareBegining suffix_array.(milieu) dna_string read_seq with
  	0 -> Some suffix_array.(milieu)
      | -1 -> dicho (milieu + 1) fin
      | _ -> dicho debut (milieu - 1)
  in match dicho 0 array_length with
       Some i -> [i]
     | None -> []


		 
      (* let substring = String.sub dna_string suffix_array.(milieu) read_length   *)
      (* in match compare substring read_seq with *)
