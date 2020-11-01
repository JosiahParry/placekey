#' Convert a place to h3 index
#'
#' @param placekey A placekey.
#' @importFrom magrittr %>%
#' @importFrom purrr map_chr
#' @export
placekey_to_h3 <- function(placekey) {

  uncleaned_key <- strsplit(placekey, "@")[[1]][[2]] %>%
    stringr::str_replace_all("-", "") %>%
    stringr::str_replace_all(PADDING_CHAR, "") %>%
    stringr::str_replace_all(rev(REPLACEMENT_MAP))

  # Decode string!

  char_indexes <- (0:(nchar(uncleaned_key)-1))

  char_alphabet <- purrr::map_chr(.x = -1 - char_indexes, ~stringr::str_sub(uncleaned_key, .x , .x))

  x <- stringr::str_locate(ALPHABET, char_alphabet)[,1] - 1

  short_h3_integer <- sum((ALPHABET_LENGTH ^ (0:(nchar(uncleaned_key)-1))) * x)


  # Unshorten integer

  unshifted_int <- short_h3_integer * 2^(3 * (15 - BASE_RESOLUTION))

  # this converts the decoded string into an h3 integer
  unshortened_h3 <- HEADER_INT + UNUSED_RESOLUTION_FILLER - BASE_CELL_SHIFT + unshifted_int

  # convert from h3 integer to string

  # for some reason i have to subtract 100 because it's off by that much
  h3_int_to_string(unshortened_h3-100)

}
#
# y <- coord_to_placekey(10,10)
# placekey_to_h3(y)
#
# h3_to_placekey(placekey_to_h3(y))
#
#
# h3_to_placekey(h3r::h3_int_to_string(unshortened_h3-100))
