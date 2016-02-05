(** une séquence d'un fichier fasta *)
type sequence = string * string
		  
(** représentation d'un fichier fasta *)
type fasta = sequence list

(** [make_sequence n s] renvoie la séquence appelée [n] contenant la chaîne d'ADN [s]*)
val make_sequence : string -> string -> sequence
		      
(** [get_name seq] renvoie le nom de la séquence [seq]*)
val get_name : sequence -> string

(** [get_dna seq] renvoie la chaîne d'ADN de la séquence [seq]*)
val get_dna : sequence -> string

(** [iter f fasta] applique la fonction [f] sur chaque séquence de la structure [fasta]*)
val iter : (sequence -> unit) -> fasta -> unit

(** pli sur un fasta *)
val fold_left : ('a -> sequence -> 'a) -> 'a -> fasta -> 'a
					    
(** [of_file fichier] renvoie une structure fasta extraite à partir du fichier [fichier]. La complexité de cette fonction est O(n)*)
val of_file : string -> fasta

(** [seq_random_mutation n seq] renvoie une nouvelle séquence avec [n] mutation aléatoire. La complexité de cette fonction est O(1)*)
val seq_random_mutation : int -> sequence -> sequence

(** [random_mutation n fasta] Fait muter la première séquence de la structure [fasta] avec [n] mutation aléatoire. La complexité de cette fonction est O(1)*)
val random_mutation : int -> fasta -> fasta

(** [print fasta] affiche le contenue de la structure [fasta]. La complexité de cette fonction est O(n)*)
val print : fasta -> unit
