let (-:) name f = Alcotest.test_case name `Quick f

let width_tests = "width", [ 
  "should count glyphs, not chars" -: begin fun () ->
    "Buy empanadas 🥟" 
    |> Shape_the_term.width 
    |> Alcotest.(check int) "same width" 16
  end;
  "should not take into account scape sequences (calculated value)" -: begin fun () ->
    let expected_width = "(Buy empanadas 🥟)" |> Shape_the_term.width in
    "\x1B[38;2;249;38;114m(\x1B[0m\x1B[38;2;248;248;242mBuy empanadas 🥟\x1B[38;2;249;38;114m)\x1B[0m"
    |> Shape_the_term.width
    |> Alcotest.(check int) "same width" expected_width
  end;
  "should not take into account scape sequences" -: begin fun () ->
    "\x1B[38;2;249;38;114m(\x1B[0m\x1B[38;2;248;248;242mBuy empanadas 🥟\x1B[38;2;249;38;114m)\x1B[0m"
    |> Shape_the_term.width
    |> Alcotest.(check int) "same width" 18
  end;
]

let wrap_tests = "wrap", [ 
  "should wrap glyphs, not chars" -: begin fun () ->
    "We 🧡 ocaml 🐫" 
    |> (Shape_the_term.wrap 4)
    |> Alcotest.(check string) "same as" 
    "We \n🧡 o\ncaml\n🐫"
  end;
  "should not take into account scape sequences" -: begin fun () ->
    "\x1B[38;2;249;38;114mWe\x1B[0m\x1B[38;2;248;248;242m 🧡 \x1B[0m\x1B[38;2;248;248;242mocaml\x1B[0m\x1B[38;2;248;248;242m 🐫" 
    |> (Shape_the_term.wrap 4)
    |> Alcotest.(check string) "same as" 
    "\x1B[38;2;249;38;114mWe\x1B[0m\x1B[38;2;248;248;242m \n🧡 \x1B[0m\x1B[38;2;248;248;242mo\ncaml\x1B[0m\x1B[38;2;248;248;242m\n🐫"
  end;
  "should take into account existing newlines" -: begin fun () ->
    "\x1B[38;2;249;38;114mWe\n\x1B[0m\x1B[38;2;248;248;242m 🧡 \x1B[0m\x1B[38;2;248;248;242mocaml\x1B[0m\x1B[38;2;248;248;242m 🐫" 
    |> (Shape_the_term.wrap 4)
    |> Alcotest.(check string) "same as" 
    "\x1B[38;2;249;38;114mWe\n\x1B[0m\x1B[38;2;248;248;242m 🧡 \x1B[0m\x1B[38;2;248;248;242m\nocam\nl\x1B[0m\x1B[38;2;248;248;242m 🐫"
  end;
]

let wrap_by_word_tests = "wrap_by_word", [ 
  "should wrap words, not chars" -: begin fun () ->
    "We 🧡 ocaml 🐫" 
    |> (Shape_the_term.wrap_by_word 4)
    |> Alcotest.(check string) "same as" 
    "We \n🧡 \nocaml\n🐫"
  end;
  "should not take into account scape sequences" -: begin fun () ->
    "\x1B[38;2;249;38;114mWe\x1B[0m\x1B[38;2;248;248;242m 🧡 \x1B[0m\x1B[38;2;248;248;242mocaml\x1B[0m\x1B[38;2;248;248;242m 🐫" 
    |> (Shape_the_term.wrap_by_word 4)
    |> Alcotest.(check string) "same as" 
    "\x1B[38;2;249;38;114mWe\x1B[0m\x1B[38;2;248;248;242m \n🧡 \x1B[0m\x1B[\n38;2;248;248;242mocaml\n\x1B[0m\x1B[38;2;248;248;242m🐫"
  end;
  "should take into account existing newlines" -: begin fun () ->
    "\x1B[38;2;249;38;114mWe\n\x1B[0m\x1B[38;2;248;248;242m 🧡 \x1B[0m\x1B[38;2;248;248;242mocaml\x1B[0m\x1B[38;2;248;248;242m 🐫" 
    |> (Shape_the_term.wrap_by_word 4)
    |> Alcotest.(check string) "same as"
    "\x1B[38;2;249;38;114mWe\n\x1B[0m\x1B[38;2;248;248;242m🧡 \x1B[0m\x1B[\n38;2;248;248;242mocaml\n\x1B[0m\x1B[38;2;248;248;242m🐫"
  end;
]

let () = Alcotest.run "shape-the-term" [ width_tests ; wrap_tests ; wrap_by_word_tests ]
