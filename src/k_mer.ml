type t = string
	       
exception IvalidSeed

(* Extrait tout les k_mers de longueur `length` de la chaine `dna` *)
(* Sa complexité est O(n) avec n, le nombre de nucléotide dans la chaine `dna`*)
let sub_seq dna length =
  let max = (String.length dna) - length in
  let rec aux acc i = 
    match i with
      i when i > max -> List.rev acc
    | _ -> let k_mer = String.sub dna i length  in
	   aux (k_mer::acc) (i + 1)
      in aux [] 0
	       
let list length fasta =
  let p acc seq =
    let dna = Sequence.get_dna seq in
    let k_mers = sub_seq dna length in
    (acc @ k_mers)
  in Fasta.fold_left p [] fasta

let list_of_window length window =
  let dna = Window.get_string window
  in sub_seq dna length
     
let common list1 list2 =
  let sorted_list2 =  Array.of_list (List.sort compare list2) in
  let member_of_list2 k_mer = Array_mp.dicho_member k_mer compare sorted_list2 
  in let rec aux acc = function
       | [] -> acc
       | k_mer::tail when (member_of_list2 k_mer) -> aux (k_mer::acc) tail
       | _::tail -> aux acc tail
     in aux [] list1

(* Renvoi la liste des index à ignorer dans le k_mer à extraire*)
let get_ignored_index seed =
  let p i acc = function
    | '#' -> acc
    | '-' -> i::acc
    | _ -> raise IvalidSeed
  in String_mp.fold_left_i p seed []

(* Renvoi la valeur du k_mers, une fois que les nucléotides à ignoré ont été enlevé *)
let get_real_length seed =
  let p acc = function
    | '#' -> acc
    | '-' -> acc + 1
    | _ -> raise IvalidSeed
  in String_mp.fold_left p seed 0

(* Extrait les nucléotide à ignoré d'un k_mer et renvoi un k_mer correspondant au bon shema *)
let extract_ignored_nucl real_length ignored_index_list k_mer =
  let p i acc carac =
    match acc with
      (j::tail,list) when i = j -> (tail, list)
    | (ignored_index_list, list) -> (ignored_index_list, carac::list)
  in let _,result = String_mp.fold_left_i p k_mer (ignored_index_list,[])
     in String_mp.of_list (List.rev result)


let list_spaced_from_string seed string =
  let length = String.length seed
  and real_length = get_real_length seed
  and ignored_index = get_ignored_index seed in
  let full_k_mers = sub_seq string length in
  let full_k_mers = sub_seq string length
  in List.map (extract_ignored_nucl real_length ignored_index) full_k_mers
  
let list_spaced seed fasta =
  let p acc seq = 
    let dna = Sequence.get_dna seq
    in acc ^ dna
  in let full_dna = Fasta.fold_left p "" fasta
     in list_spaced_from_string seed full_dna

let list_spaced_multiple seed fasta =
  let p acc seq = 
    let dna = Sequence.get_dna seq
    in  (Sequence.get_name seq, list_spaced_from_string seed dna)::acc
  in List.rev (Fasta.fold_left p [] fasta)

let list_spaced_of_window seed window =
  let window_string = Window.get_string window
  in list_spaced_from_string seed window_string

	    
(* let list_spaced seed fasta = *)
(*   let length = String.length seed *)
(*   and real_length = get_real_length seed *)
(*   and ignored_index = get_ignored_index seed in *)
(*   let p acc seq = *)
(*     let dna = Fasta.get_dna seq in *)
(*     (\* On extrait la liste des K_mers de la taille de la graine *\) *)
(*     let full_k_mers = sub_seq dna length in *)
(*     (\* Puis on enlève les nucléotides à ignoré pour que le K_mer corresponde au shéma de la graine*\) *)
(*     let k_mers = List.map (extract_ignored_nucl real_length ignored_index) full_k_mers *)
(*     in acc @ k_mers *)
(*   in Fasta.fold_left p [] fasta *)
