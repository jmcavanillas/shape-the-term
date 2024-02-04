(lang dune 3.12)

(name shape-the-term)

(generate_opam_files true)

(source
 (github jmcavanillas/shape-the-term))

(authors "Javier Martínez Cavanillas")

(maintainers "Javier Martínez Cavanillas")

(license MIT)

(documentation https://github.com/jmcavanillas/shape-the-term)

(package
 (name shape-the-term)
 (synopsis "A collection of ANSI-aware methods helping you to transform blocks of text in OCaml")
 (description "A collection of ANSI-aware methods helping you to transform blocks of text in OCaml. This means you can still style your terminal output with ANSI escape sequences without them affecting operations & algorithms. Inspired by https://github.com/muesli/reflow")
 (depends ocaml dune uuseg (alcotest :with-test))
 (tags
  (wrap ansi terminal tty)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
