let () = 
  let original_string = "\x1B[38;2;249;38;114mWe\x1B[0m\x1B[38;2;248;248;242m 🧡 \x1B[38;2;249;38;114mocaml\x1B[0m\x1B[38;2;248;248;242m 🐫" in
  let width = Shape_the_term.width original_string in
  print_endline ("Original Text: " ^ original_string);
  print_endline ("TTY Width: " ^ string_of_int width ^" cols");
  for i = 2 to width do
    print_endline ("Wrapped -> " ^ string_of_int i ^ " cols:\n" ^ Shape_the_term.wrap i original_string);
  done
