(** rerpésentation d'une fenêtre : (coordonée de la 1ere nucléotide, coordonée de la 2éme nucléotide, chaine de nucléotide) *)
type t = int * int * string

(** [extract_from_fasta l s fichier] renvoi la liste de toutes les fenêtres de taille [l] en commençant par le premier nucléotide et en se déplaçant de [s] nucléotides à chaque fenêtre*)
val extract_from_fasta : int -> int -> Fasta.t -> (string * Window.t list) list

val make : int -> int -> string -> Window.t

val get_first_i : Window.t -> int

val get_second_i : Window.t -> int

val get_string : Window.t -> string

val print : Window.t -> unit
