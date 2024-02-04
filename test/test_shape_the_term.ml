let (-:) name f = Alcotest.test_case name `Quick f

let width_tests = "width", [ 
  "should count glyphs, not chars" -: begin fun () ->
    "Buy empanadas 🥟" 
    |> Shape_the_term.width 
    |> Alcotest.(check int) "same width" 15
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
    |> Alcotest.(check int) "same width" 17
  end;
]

let wrap_tests = "wrap", [ 
  "should wrap glyphs, not chars" -: begin fun () ->
    "We ❤️‍🔥 ocaml 🐫" 
    |> (Shape_the_term.wrap 4)
    |> Alcotest.(check string) "same as" 
    "We ❤️‍🔥\n oca\nml 🐫"
  end;
  "should not take into account scape sequences" -: begin fun () ->
    "\x1B[38;2;249;38;114mWe\x1B[0m\x1B[38;2;248;248;242m ❤️‍🔥 \x1B[0m\x1B[38;2;248;248;242mocaml\x1B[0m\x1B[38;2;248;248;242m 🐫" 
    |> (Shape_the_term.wrap 4)
    |> Alcotest.(check string) "same as" 
    "\x1B[38;2;249;38;114mWe\x1B[0m\x1B[38;2;248;248;242m ❤️‍🔥\n \x1B[0m\x1B[38;2;248;248;242moca\nml\x1B[0m\x1B[38;2;248;248;242m 🐫"
  end;
  "should take into account existing newlines" -: begin fun () ->
    "\x1B[38;2;249;38;114mWe\n\x1B[0m\x1B[38;2;248;248;242m ❤️‍🔥 \x1B[0m\x1B[38;2;248;248;242mocaml\x1B[0m\x1B[38;2;248;248;242m 🐫" 
    |> (Shape_the_term.wrap 4)
    |> Alcotest.(check string) "same as" 
    "\x1B[38;2;249;38;114mWe\n\x1B[0m\x1B[38;2;248;248;242m ❤️‍🔥 \x1B[0m\x1B[38;2;248;248;242mo\ncaml\x1B[0m\x1B[38;2;248;248;242m\n 🐫"
  end;
]

let () = Alcotest.run "shape-the-term" [ width_tests ; wrap_tests ]