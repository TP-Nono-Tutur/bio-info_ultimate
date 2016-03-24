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

(** [to_suffix_array seq] extrait le tableau des suffixe de la sequence  [seq] (algorithme non performant)*)
val extract_suffix_array_naive : t -> int array

(** [search read_seq seq] recherche dans la sequence [seq] la chaine [read_seq] et renvoi la liste des indice de début de chaque sous chaine correspondante dans la sequence *)
val search : string -> t -> int list


(** [search_with_array read_seq seq suffix_array] recherche dans la sequence [seq] la chaine [read_seq] à l'aide du tableau des suffix [suffix_array] et renvoi la liste des indice de début de chaque sous chaine correspondante dans la sequence *)
val search_with_array : string -> t -> int array -> int list

(** [bwt s] renvoi la bwt de la chaine [s]*)
val bwt : t -> string

(** [bwt_naive s] renvoi la bwt de la chaine [s]*)
val bwt_naive : t -> string

(** [unbwt s_bwt] renvoi la chaine original à partir de sa bwt [s]*)
val unbwt : string -> string
