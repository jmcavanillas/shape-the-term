# Shape the term

A collection of ANSI-aware methods helping you to transform blocks of text in OCaml. This means you can still style your terminal output with ANSI escape sequences without them affecting operations & algorithms. Inspired by https://github.com/muesli/reflow.

## Width

Gets the number of glyphs a string has, without taking into account ANSI escape sequences.

```ocaml
  let () = 
  "\x1B[38;2;249;38;114mWe\x1B[0m\x1B[38;2;248;248;242m 🧡 \x1B[38;2;249;38;114mocaml\x1B[0m\x1B[38;2;248;248;242m 🐫"
  |> Shape_the_term.width
  |> string_of_int
  |> print_endline
```

```sh
12 
```

## Wrap

Wraps the input string to a given width.

```ocaml
  let () = 
  "\x1B[38;2;249;38;114mWe\x1B[0m\x1B[38;2;248;248;242m 🧡 \x1B[38;2;249;38;114mocaml\x1B[0m\x1B[38;2;248;248;242m 🐫"
  |> (Shape_the_term.wrap 4)
  |> print_endline
```

```sh
We 🧡
 oca
ml 🐫 
```