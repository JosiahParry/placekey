# shorten h3 integer
#' @keywords internal
shorten_h3_integer <- function(h3_integer) {
  out <- (h3_integer + BASE_CELL_SHIFT) %% (2 ** 52)

  floor(out / 2^(3 *(15 - BASE_RESOLUTION)))
}


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

#' @keywords internal
clean_string <- function(encoded_short_int) {
  cleaned <- stringr::str_replace_all(encoded_short_int, REPLACEMENT_MAP)
  stringr::str_pad(cleaned, 9, "left", "a")
}

#' Generate Placekey from a coordinate
#'
#' @param lat Latitude in decimal degrees.
#' @param lon Longitude in decimal degrees.
#' @export
#' @examples
#' coord_to_placekey(29.76328, -95.36327)
#' #> "@675-9z6-5nw-m2"
coord_to_placekey <- function(lat, long) {
  h3_integer <- h3r::getCIndexFromCoords(lat, long, res = RESOLUTION)

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

Houston <- list(lat = 29.7632836, lon = -95.3632715)
geo_to_placekey(Houston$lat, Houston$lon)
