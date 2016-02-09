type window = int * int * string

let make i j s = (i,j,s)

let get_first_i window =
  let i,_,_ = window
  in i

let get_second_i window =
  let _,i,_ = window
  in i

let get_string window =
  let _,_,s = window
  in s
			    
let extract_window i length string =
  let string_length = String.length string in
  if i >= string_length
  then None
  else
    let j =
      match i with
      | i when (i + length) >= string_length -> string_length - i
      | i -> length
    in let window_string = String.sub string i j
       in Some (make i (i + j) window_string)
	   
let divise_chaine string length shift =
  let rec aux list i = 
    match extract_window i length string with
      None -> list
     | Some window -> aux (window::list) (i + shift)
  in List.rev (aux [] 0)

let rec extract_from_fasta longueur shift fasta =
  match fasta with
  | [] -> []
  | (a,b)::suite ->  (a, divise_chaine b longueur shift) :: (extract_from_fasta longueur shift suite)


let print window =
  let i = get_first_i window
  and j = get_second_i window
  and string = get_string window
  in Printf.printf "%d %s %d\n" (i+1) string (j+1)
