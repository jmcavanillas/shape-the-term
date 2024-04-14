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

let walk_words f initial_acc text =
  let result (r, _) = r in
  let acc_graphemes (acc, inside_ansi_seq) word =
    let apply inside_ansi = f inside_ansi word acc in
    let contains_terminator = String.exists is_terminator word in
    match word with
    | w when w.[0] = '\x1B' -> (apply true, true)
    | _ when inside_ansi_seq && contains_terminator -> (apply true, false)
    | _ -> (apply inside_ansi_seq, inside_ansi_seq)
  in
  Uuseg_string.fold_utf_8 `Word acc_graphemes (initial_acc, false) text
  |> result

let number_of_graphemes text =
  let calc_width inside_ansi_seq _ acc =
    if inside_ansi_seq then acc else acc + 1
  in
  walk_text calc_width 0 text

let grapheme_tty_width grapheme =
  String.get_utf_8_uchar grapheme 0
  |> Uchar.utf_decode_uchar |> Uucp.Break.tty_width_hint

let width text =
  let calc_width inside_ansi_seq grapheme acc =
    let width = grapheme_tty_width grapheme in
    if inside_ansi_seq then acc else acc + width
  in
  walk_text calc_width 0 text

let is_white_space grapheme =
  String.get_utf_8_uchar grapheme 0
  |> Uchar.utf_decode_uchar |> Uucp.White.is_white_space

let wrap_by_word to_width text =
  let get_result (r, _) = r in
  let new_line_delimiter = "\n" in
  let acc_words inside_ansi_seq word (acc, acc_length) =
    let word_width word =
      if inside_ansi_seq then width ("\x1B[" ^ word) else width word
    in
    match acc_length + word_width word with
    | _ when acc_length = 0 && is_white_space word -> (acc, 0)
    | length when length > to_width ->
        if is_white_space word then (acc ^ new_line_delimiter, 0)
        else (acc ^ new_line_delimiter ^ word, word_width word)
    | length -> (acc ^ word, if word = new_line_delimiter then 0 else length)
  in
  walk_words acc_words ("", 0) text |> get_result

let wrap to_width text =
  let result (r, _) = r in
  let new_line_delimiter = "\n" in
  let add_newline inside_ansi_seq grapheme (wrapped_text, len) =
    let grapheme_width = grapheme_tty_width grapheme in
    let next_grapheme = if is_white_space grapheme then "" else grapheme in
    let next_grapheme_width =
      if next_grapheme = "" then 0 else grapheme_width
    in
    match inside_ansi_seq with
    | false when grapheme = new_line_delimiter -> (wrapped_text ^ grapheme, 0)
    | false when len + grapheme_width > to_width ->
        (wrapped_text ^ new_line_delimiter ^ next_grapheme, next_grapheme_width)
    | false -> (wrapped_text ^ grapheme, len + grapheme_width)
    | true -> (wrapped_text ^ grapheme, len)
  in
  walk_text add_newline ("", 0) text |> result
