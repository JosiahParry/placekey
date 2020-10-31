# shorten h3 integer
#' @keywords internal
shorten_h3_integer <- function(h3_integer) {
  out <- (h3_integer + BASE_CELL_SHIFT) %% (2 ** 52)

  floor(out / 2^(3 *(15 - BASE_RESOLUTION)))
}


#' Encode a shortened h3 integer into the placekey alphabet
#' @keywords internal
encode_short_int <- function(short_h3_int) {
  # if short_h3_int == 0:
  #   return(substr(ALPHABET,1,1))
  # else:
  res = character()
  remainder <- integer()

  while(short_h3_int > 0) {
    remainder = short_h3_int %% ALPHABET_LENGTH + 1
    res = append(res, substr(ALPHABET, remainder , remainder))
    short_h3_int = floor(short_h3_int / ALPHABET_LENGTH)
  }

  paste0(rev(res), collapse = "")

}

#' Clean and pad an encoded shortened h3 integer.
#'
#' This creates a placekey without formatting.
#' @keywords internal
clean_string <- function(encoded_short_int) {
  cleaned <- stringr::str_replace_all(encoded_short_int, REPLACEMENT_MAP)
  stringr::str_pad(cleaned, 9, "left", "a")
}
