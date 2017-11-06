open Monade_pack
       
type t = in_channel

let of_fastq file =
  let input = open_in file
  in input

(* retire le chevron du nom d'une séquence *)
let remove_begin ligne =
  String.sub ligne 1 ((String.length ligne) - 1)
       
let next fastq =
  let rec read4line seq seq_name i =
	 match Option.safe input_line fastq with
	   Some line ->
	   begin 
	     match i with
	       0 -> read4line seq (remove_begin line) 1
	     | 1 -> read4line line seq_name 2
	     | 2 -> read4line seq seq_name 3
	     | 3 -> Some (Sequence.make seq_name seq)
	   end
	 | None -> None
       in read4line "" "" 0
       
let fold_left f acc fastq =
  let rec aux acc = function
    | None -> acc
    | Some seq -> aux (f acc seq) (next fastq)
  in aux acc (next fastq)
       

  
