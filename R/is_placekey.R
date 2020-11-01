#' Check if a placekey is valid
#'
#' @param placekey A Placekey.
#' @importFrom stringr str_detect
#' @export
#' @examples
#' is_placekey("@b9f-q4k-d7r")
#' is_placekey("123@b9f-q4k-d7r")

is_placekey <- function(placekey) {
  # split into what and where
  pk_split <- strsplit(placekey, "@")[[1]]

  what <- pk_split[[1]]
  where <- pk_split[[2]]

  if (what == "") what <- "zzz"
  what_valid <- stringr::str_detect(what, WHAT_REGEX)
  where_valid <- stringr::str_detect(where, WHERE_REGEX)

  # both portions need to be valid
  all(what_valid, where_valid)

}
