let is_terminator char =
  let c = int_of_char char in
  (c >= 0x40 && c <= 0x5a) || (c >= 0x61 && c <= 0x7a)

let walk_text f initial_acc text =
  let result (r, _) = r in
  let acc_graphemes (acc, inside_ansi_seq) grapheme =
    let apply inside_ansi = f inside_ansi grapheme acc in
    match grapheme.[0] with
    | '\x1B' -> (apply true, true)
    | c when inside_ansi_seq && is_terminator c -> (apply true, false)
    | _ -> (apply inside_ansi_seq, inside_ansi_seq)
  in
  Uuseg_string.fold_utf_8 `Grapheme_cluster acc_graphemes (initial_acc, false)
    text
  |> result

let width text =
  let calc_width inside_ansi_seq _ acc =
    if inside_ansi_seq then acc else acc + 1
  in
  walk_text calc_width 0 text

let wrap width text =
  let result (r, _) = r in
  let add_newline inside_ansi_seq grapheme (wrapped_text, len) =
    match inside_ansi_seq with
    | false when len >= width -> (wrapped_text ^ "\n" ^ grapheme, 1)
    | false -> (wrapped_text ^ grapheme, len + 1)
    | true -> (wrapped_text ^ grapheme, len)
  in
  walk_text add_newline ("", 0) text |> result
