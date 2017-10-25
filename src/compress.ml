let rec to_normal_file file = function
  | [] -> close_out file;
	  ()
  | seq::tail -> let dna = Sequence.get_dna seq
		 in output_string file (dna ^ "\n");
		    to_normal_file file tail
    
  
