(** une séquence d'un fichier fasta *)
type t = string * string

(** [make n s] renvoie la séquence appelée [n] contenant la chaîne d'ADN [s]*)
val make : string -> string -> t
		      
(** [get_name seq] renvoie le nom de la séquence [seq]*)
val get_name : t -> string

(** [get_dna seq] renvoie la chaîne d'ADN de la séquence [seq]*)
val get_dna : t -> string

(** [to_suffix_array seq] extrait le tableau des suffixe de la sequence [seq]*)
val extract_suffix_array : t -> int array
			       
