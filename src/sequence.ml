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
			  
let extract_suffix_array_naive seq =
  let dna_string = get_dna seq in
  let suffix_list = extract_suffixes (dna_string^"$") in
  (*trie de la liste des suffixe*)
  let f (_, s1) (_, s2) = compare s1 s2 in
  let sorted_suffix_list = List.sort f suffix_list in
  List.iter (fun (a,b) -> Printf.printf "%d,%s\n" a b) sorted_suffix_list;
  let i_list = List.map (fun (i, _) -> i) sorted_suffix_list in
  Array.of_list i_list

(* compare deux sous chaine présent dans la chaine [s] commençant respectivement au caractére d'indice i1 et i2*)
let compare_sub s i1 i2 =
  let max = (String.length s) - 1 in
  let rec aux i j =
    if (i = max) || (j = max)
    then compare i2 i1
    else match compare s.[i] s.[j] with
	 | 0 -> aux (i+1) (j+1)
	 | n -> n
  in aux i1 i2

let extract_suffix_array seq =
  let dna_string = (get_dna seq)^"$" in
  let suffix_list = List_mp.seq 1 (String.length dna_string) in
  (*trie de la liste des suffixe*)
  let f i1 i2 = compare_sub dna_string (i1 - 1) (i2 - 1) in
  let sorted_suffix_list = List.sort f suffix_list in
  Array.of_list sorted_suffix_list

	 
(* let extract_suffix_array seq = *)
(*   let dna_string = (get_dna seq)^"$" in *)
(*   let suffix_list = List_mp.seq 1 (String.length dna_string) in *)
(*   (\*trie de la liste des suffixe*\) *)
(*   let f i1 i2 =  *)
(*     let s1 = String.sub dna_string (i1 - 1) ((String.length dna_string) - i1 + 1) *)
(*     and s2 = String.sub dna_string (i2 - 1) ((String.length dna_string) - i2 + 1) *)
(*     in compare s1 s2 in *)
(*   let sorted_suffix_list = List.sort f suffix_list in *)
(*   (\* List.iter print_int sorted_suffix_list; *\) *)
(*   (\* let i_list = List.map (fun (i, _) -> i) sorted_suffix_list in *\) *)
(*   Array.of_list sorted_suffix_list *)



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
		    


let search_with_array read_seq seq suffix_array = 
  let dna_string = get_dna seq
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

let bwt_naive seq =
  let dna_string = (get_dna seq) ^ "$" in
  let length = String.length dna_string in
  let rec aux acc string = function
    | i when i = length -> acc
    | i -> let new_string = String_mp.rotate string
	   in aux (new_string::acc) new_string (i+1)
  in let bwt_list = List.sort compare (aux [] dna_string 0) in
     let p acc string = (string.[length - 1]::acc)
     in String_mp.of_list(List.rev (List.fold_left p [] bwt_list))


let bwt seq = 
  let fake_dna_string = "$" ^ (get_dna seq) in
  let array_suffix = extract_suffix_array seq in
  let p acc i = fake_dna_string.[i - 1]::acc
  in String_mp.of_list (List.rev (Array.fold_left p [] array_suffix))
			 
let rec distribution l1 l2 =
  match (l1,l2) with
    ([],l2) -> []
   |(l1,[]) -> []
   |(x::r1,y::r2) -> (x^y) ::distribution r1 r2

let rec distribution l1 l2 =
  match (l1,l2) with
    ([],l2) -> []
   |(l1,[]) -> []
   |(x::r1,y::r2) -> (x::y) ::distribution r1 r2
					  
let rec extract_real_string = function 
  | [] -> None
  | (c::s)::_ when c = '$' -> Some s
  | _::tl -> extract_real_string tl

					   
let unbwt s =
  let t = String_mp.to_list s
  and length = String.length s in
  let rec aux acc = function
    | i when i = length - 1 -> acc
    | i -> let acc2 = List.sort compare acc in
	   aux (distribution t acc2) (i+1)
  in let result_list = aux (List.map (fun x -> [x]) t) 0 
     (* List_mp.display print_endline list; *)
     in match extract_real_string result_list with
	  None -> ""
	| Some real_string -> String_mp.of_list real_string
