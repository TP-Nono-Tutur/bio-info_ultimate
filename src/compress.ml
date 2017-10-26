open Monade_pack

(* ocaml -I ~/Programation/MOCAD/SV/deps/Module_perso/ -I ~/Programation/MOCAD/SV/deps/bio-info_ultimate *)

(* compression *)
let add_bit_to_bytes bit (bytes_list, buffer, i) =
  let buffer2 = Byte.set buffer i bit
  in if (i - 1) >= 0
     then (output, buffer2, i - 1)
     else let c = Byte.char_of_byte buffer2
	  in output_char c output;
	     (output, Byte.zero, 7)
				   
let add_nucl_to_bytes (output, buffer, i) nucl  =
  let msb = if nucl = 'A' || nucl = 'T' then 0 else 1
  and lsb = if nucl = 'A' || nucl = 'C' then 0 else 1 in
  let output2, buffer2, i2 = add_bit_to_bytes msb (output, buffer, i)
  in add_bit_to_bytes lsb (output2, buffer2, i2)
				   
let simple_compress sequence (output, buffer, i) =
  let dna = Sequence.get_dna sequence in
  String_mp.fold_left add_nucl_to_bytes dna (output, buffer, i)

let simple_compress_with_len state sequence =
  let len = String.length (Sequence.get_dna sequence) in
  let msb_len = Byte.of_int ((len lsr 8) land 255)
  and lsb_len = Byte.of_int (len land 255)
  in let rec aux byte state n =
       (* ajoute byte à l'état*)
       if n = -1
       then state
       else let state2 = add_bit_to_bytes (Byte.get byte n) state
	    in aux byte state2 (n - 1)
     in let state1 = aux msb_len state 7
	in let state2 = aux lsb_len state1 7
	   in simple_compress sequence state2

		      
(* decompression *)
let get_bit_of_bytes (Sinput, buffer, i) =
  let Some input = Sinput in
  let bit = Byte.get buffer i
  in if (i - 1) >= 0
     then bit, (input, buffer, i - 1)
     else let acc = match safe input_char input with
	    | None -> (None, Byte.zero, 7)
	    | Some c -> (Some input, Byte.of_char c, 7)
	  in bit, acc

let get_nucl_of_bytes (input, buffer, i) =
  let msb, (input, buffer2, i2)  = get_bit_of_bytes (input, buffer, i)
  in let lsb, acc = get_bit_of_bytes (input, buffer2, i2)
     in let c = match msb,lsb with
	    0,0 -> 'A'
	  | 0,1 -> 'T'
	  | 1,0 -> 'C'
	  | 1,1 -> 'G'
	in c, acc

let simple_decompress state sequence_len output=
  let rec aux n state =
    if n = 0
    then state
    else let nucl, state2 = get_nucl_of_bytes state
	 in output_char nucl output;
	    aux (n - 1) state2
  in aux [] sequence_len state

let simple_decompress_with_len output state =
  let rec aux state n acc =
    (* lit un byte depuis l'état*)
    if n = -1
    then Byte.to_int acc, state
    else let bit, state2 = get_bit_of_bytes state
	 in let acc2 = Byte.set acc n bit
	    in aux state2 (n - 1) acc2
		   
  in let msb_len, state1 = aux state 7 Byte.zero
     in let lsb_len, state2 = aux state1 7 Byte.zero
	in let seq_len = (msb_len lsl 8) + lsb_len
	   in simple_decompress state2 seq_len output

(* public function *)
let compress fasta output =
  let init_state = (output, Byte.zero, 7)
  in let (output2, buffer, i) = Fasta.fold_left simple_compress_with_len init_state fasta
     in () 

let decompress input output =
  let init_state = (input, Byte.zero, 7)
  in let rec aux = function
       | (None, buffer, i) -> ()
       | state -> let state2 = simple_decompress_with_len output state
		  in aux state2
     in aux init_state

let rec to_normal_file file = function
  | [] -> close_out file;
	  ()
  | seq::tail -> let dna = Sequence.get_dna seq
		 in output_string file (dna ^ "\n");
		    to_normal_file file tail
