(** une séquence d'un fichier fasta *)
type t = string * string

(** [make n s] renvoie la séquence appelée [n] contenant la chaîne d'ADN [s]*)
val make : string -> string -> sequence
		      
(** [get_name seq] renvoie le nom de la séquence [seq]*)
val get_name : sequence -> string

(** [get_dna seq] renvoie la chaîne d'ADN de la séquence [seq]*)
val get_dna : sequence -> string

