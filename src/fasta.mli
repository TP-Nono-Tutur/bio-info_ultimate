(** représentation d'un fichier fasta *)
type t = Sequence.t list

(** [iter f fasta] applique la fonction [f] sur chaque séquence de la structure [fasta]*)
val iter : (Sequence.t -> unit) -> fasta -> unit

(** pli sur un fasta *)
val fold_left : ('a -> Sequence.t -> 'a) -> 'a -> fasta -> 'a
					    
(** [of_file fichier] renvoie une structure fasta extraite à partir du fichier [fichier]. La complexité de cette fonction est O(n)*)
val of_file : string -> fasta

(** [seq_random_mutation n seq] renvoie une nouvelle séquence avec [n] mutation aléatoire. La complexité de cette fonction est O(1)*)
val seq_random_mutation : int -> Sequence.t -> Sequence.t

(** [random_mutation n fasta] Fait muter la première séquence de la structure [fasta] avec [n] mutation aléatoire. La complexité de cette fonction est O(1)*)
val random_mutation : int -> fasta -> fasta

(** [print fasta] affiche le contenue de la structure [fasta]. La complexité de cette fonction est O(n)*)
val print : fasta -> unit

(** [extract_first_seq fasta] extraie la première sequence d'un fasta*)
val extract_first_seq : fasta -> Sequence.t

				   
