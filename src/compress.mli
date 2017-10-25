type compressed_fasta : bytes


(** [to_normal_file file_name  fasta ]ecris l'ensemble des sequence de [fasta] dans le fichier [file_name]*)
val to_normal_file : out_channel -> Fasta.t ->  unit

val compress : Fasta.t
