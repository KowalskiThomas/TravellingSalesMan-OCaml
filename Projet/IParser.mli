module Parser : sig
  exception FileNotFound of string
  exception SyntaxError of string * string  
  
  type config = {
    mode : string;
    insertion : string;
    optimization: string;
  }
  
  val parse_input_file : string -> (string * float * float) list
  val parse_config_file : string -> config

end