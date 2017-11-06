(** représentation d'un fichier fastq de façon optimiser*)
type t

(** pli sur un fasta *)
val fold_left : ('a -> Sequence.t -> 'a) -> 'a -> t -> 'a

							 
(** [of_fastq fichier] renvoie une structure fastq extraite à partir du fichier [fichier] au format fastq. La complexité de cette fonction est O(n)*)
val of_fastq : string -> t

