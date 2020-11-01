#' Generate Placekey from a coordinate
#'
#' @param lat Latitude in decimal degrees.
#' @param lon Longitude in decimal degrees.
#' @export
#' @examples
#' coord_to_placekey(29.76328, -95.36327)
#' #> "@675-9z6-5nw-m2"
coord_to_placekey <- function(lat, long) {
  h3_integer <- coord_to_h3_int(lat, long, res = RESOLUTION)

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
