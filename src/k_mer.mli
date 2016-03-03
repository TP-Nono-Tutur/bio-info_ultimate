type t = string

(** [list n fasta] renvoie la liste de tout les k_mers de taille [n] du fasta [fasta]. Sa complexité est [O(n)] avec [n], le nombre de nucléotide présentes dans la structure [fasta] *)
val list : int -> Fasta.fasta -> t list

(** Comme [list] mais utilise une window au lieu d'un fasta *)
val list_of_window : int -> Window.t -> t list
				       
(** [list_spaced seed fasta] renvoie la liste de tout les k_mers correspondant au format décris par la graine [seed]. Sa complexité est [O(n)] avec [n], le nombre de nucléotides présentes dans la structure [fasta] *)
val list_spaced : string -> Fasta.t -> t list

(** Comme [list_spaced] mais utilise une window au lieu d'un fasta *)
val list_spaced_of_window : string -> Window.t -> t list
						 
(** [common l1 l2] renvoie la liste des K_mers de la liste [l1] présents dans la liste [l2]. Sa complexité est de [O(n * log(n))] avec [n], le nombre de nucléotide présentes dans la structure [fasta]*)
val common : t list -> t list -> t list

val list_spaced_multiple : string -> Fasta.t -> (string * t list) list 
