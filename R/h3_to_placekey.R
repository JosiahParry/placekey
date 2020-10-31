#' Convert h3 string to placekey
#'
#' Given an h3 string identify the where portion of a placekey.
#'
#' @export
h3_to_placekey <- function(h3_string) {

  h3_integer <- h3r::h3_string_to_int(h3_string)
  short_h3_int <- shorten_h3_integer(h3_integer)

  encoded_short_int <- encode_short_int(short_h3_int)

  cleaned_encoded <- clean_string(encoded_short_int)

  index_start <- seq(1, nchar(cleaned_encoded), by = TUPLE_LENGTH)
  index_stop <- index_start + TUPLE_LENGTH -1

  encoded_splits <- purrr::map2_chr(.x = index_start,
                                    .y = index_stop,
                                    .f = ~substr(cleaned_encoded, .x, .y))

  paste0("@", paste0(encoded_splits, collapse = "-"))
}
