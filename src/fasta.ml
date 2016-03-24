exception NoSequence

type t = Sequence.t list
		      
(* retire le chevron du nom d'une séquence *)
let remove_begin ligne =
  String.sub ligne 1 ((String.length ligne) - 1)

let of_file file =
  let input = open_in file
  in let rec aux fasta_acc seq_name dna_acc =
       try
	 match input_line input with
	 | "" -> aux fasta_acc seq_name dna_acc
	 | "\n" -> aux fasta_acc seq_name dna_acc
	 | ligne when ligne.[0] = '>' ->
	    let seq_name2 = remove_begin ligne in
	    let fasta_acc2 = 
	      match seq_name with 
		"" -> fasta_acc
	      | _ -> 
		 let seq = Sequence.make seq_name dna_acc in
		 (seq::fasta_acc)
	    in
	    aux fasta_acc2 seq_name2 ""
	 | ligne when ligne.[0] = 'N' -> aux fasta_acc seq_name dna_acc
	 | ligne when ligne.[(String.length ligne) - 1] = 'N' -> aux fasta_acc seq_name dna_acc
	 | ligne ->
	    aux fasta_acc seq_name (dna_acc ^ (String.uppercase ligne))
       with
       | End_of_file ->
	  let seq = Sequence.make seq_name dna_acc
	  in List.rev (seq::fasta_acc)
     in aux [] "" ""

let iter = List.iter
let fold_left = List.fold_left


(* Prend un liste d'élément unique et un élement en argument, si cette élement n'appartient pas a la liste, on renvoit la liste, sinon on renvoit la liste privé de cette élément *)
let rec except liste element =
  match liste with
  | [] -> []
  | tete::queue -> if (tete==element) then queue
                   else tete::(except queue element)

(* mutation prend un nucleotide en entrée (char) et renvoit ce nucléotique apres une mutation*)
let mutation nucleotide =
  let liste = ['A';'C';'G';'T'] in
  let liste_2 = except liste nucleotide in
  List.nth liste_2 (Random.int(3))
           

(* mutation prend une chaine de nucléotide et un nombre de mutation à effectuer, renvoit la chaine des nucléotides apres ces mutations *)
let dna_random_mutation nombre_mutations genome =
  let taille = String.length genome in
  for i = 0 to (nombre_mutations - 1) do
    let indice = (Random.int(taille-1)) in       
    genome.[indice] <- mutation genome.[indice]
  done;
    genome

let seq_random_mutation n seq =
  let name, dna = (Sequence.get_name seq, Sequence.get_dna seq) in
  let dna_mutated = dna_random_mutation n dna 
  in (name ^ "-mutated", dna_mutated)

let random_mutation n = function
  | [] -> []
  | seq::tail -> (seq_random_mutation n seq)::tail
(* print_endline (Sequence.get_dna seq) in *)
let print fasta =

  let p seq =
    let name, dna = (Sequence.get_name seq, Sequence.get_dna seq) in
    Printf.printf ">%s\n%s\n" name dna
  in  iter p fasta


let extract_first_seq fasta =
  try 
    List.hd fasta
  with
    _ -> raise NoSequence
