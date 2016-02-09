(** rerpésentation d'une fenêtre : (coordonée de la 1ere nucléotide, coordonée de la 2éme nucléotide, chaine de nucléotide) *)
type window = int * int * string

(** [extract_from_fasta l s fichier] renvoi la liste de toutes les fenêtres de taille [l] en commençant par le premier nucléotide et en se déplaçant de [s] nucléotides à chaque fenêtre*)
val extract_from_fasta : int -> int -> Fasta.fasta -> (string * window list) list

val make : int -> int -> string -> window

val get_first_i : window -> int

val get_second_i : window -> int

val get_string : window -> string
