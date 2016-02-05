type k_mer = string

(** [list n fasta] renvoie la liste de tout les k_mers de taille [n] du fasta [fasta]. Sa complexité est [O(n)] avec [n], le nombre de nucléotide présentes dans la structure [fasta] *)
val list : int -> Fasta.fasta -> k_mer list

(** [list_spaced seed fasta] renvoie la liste de tout les k_mers correspondant au format décris par la graine [seed]. Sa complexité est [O(n)] avec [n], le nombre de nucléotides présentes dans la structure [fasta] *)
val list_spaced : string -> Fasta.fasta -> k_mer list
				       
(** [common l1 l2] renvoie la liste des K_mers de la liste [l1] présents dans la liste [l2]. Sa complexité est de [O(n * log(n))] avec [n], le nombre de nucléotide présentes dans la structure [fasta]*)
val common : k_mer list -> k_mer list -> k_mer list
