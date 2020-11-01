# TO DO
# Create s3 methods.
# below is default different
# one to accept a list object and another to accept dataframe
# dataframe will use pmap

#' Query the Placekey API
#'
#' Queries the Placekey API and, if successful, returns a placekey. See https://docs.placekey.io/ for more information.
#'
#' @param location_name The name of the place.
#' @param street_address The streed address of the place.
#' @param city The city where the place is located.
#' @param region The second-level administrative region below nation for the place. In the US, this is the state.
#' @param postal_code The postal code for the place.
#' @param iso_country_code The ISO 2-letter Country Code for the place. Currently may only be US.
#' @param strict_address_match If set to `TRUE`, a Placekey is only returned if all fields identify the place as being at the exact address specified. If set to `FALSE`, the Placekey returned may ignore unit/apartment/floor information. Optional. Default `FALSE`.
#' @param strict_name_match If set to `TRUE`, a Placekey is only returned if all fields identify the POI as having the exact name specified. Optional. Default `FALSE`.
#' @importFrom httr add_headers POST content
#' @importFrom purrr discard
#' @importFrom magrittr %>%
#' @export
#'
get_placekey <- function(location_name = NULL, street_address = NULL,
                         city = NULL, region = NULL, postal_code = NULL,
                         iso_country_code = NULL,
                         strict_address_match = FALSE,
                         strict_name_match = FALSE,
                         key = Sys.getenv("PLACEKEY_SECRET")) {

  UseMethod("get_placekey")

}

#' @method get_placekey default
#' @export
get_placekey.default <- function(location_name = NULL, street_address = NULL,
                         city = NULL, region = NULL, postal_code = NULL,
                         iso_country_code = NULL,
                         strict_address_match = FALSE,
                         strict_name_match = FALSE,
                         key = Sys.getenv("PLACEKEY_SECRET")) {


  # cast postal_code to character just incase it is not.
  # the api requires it
  postal_code = as.character(postal_code)

  query_list <- list(location_name = location_name,
                     street_address = street_address,
                     city = city,
                     region = region,
                     postal_code = postal_code,
                     iso_country_code = iso_country_code) %>%
    purrr::discard(is.null)

  options_list <- list(
    strict_name_match = strict_name_match,
    strict_address_match = strict_address_match
  )

  q <- httr::POST("https://api.placekey.io/v1/placekey",
             body = list(query = query_list, options = options_list),
             httr::add_headers(apikey = key), encode = "json")

  res <- content(q)

  if (is.null(res$placekey)) {
    return(res$error)
  }

  res$placekey

}


#' Query the Placekey API
#' @param .data A dataframe containing the columns `street_address`, `city`, `region`, `postal_code`, and `iso_country_code`.
#' @importFrom glue glue glue_collapse
#' @importFrom rlang has_name
#' @importFrom dplyr mutate
#' @importFrom purrr pmap_chr
#' @method get_placekey data.frame
#' @rdname get_placekey
#' @export
get_placekey.data.frame <- function(.data, strict_name_match, strict_address_match) {

  # validate the provide data frame
  pk_names <- c("street_address", "city", "region", "postal_code", "iso_country_code")
  missing_pks <- rlang::has_name(.data, pk_names)

  if (any(!missing_pks)) {
    missing_cols <- glue::glue_collapse(pk_names[!missing_pks], ", ", last = " and ")
    stop(glue::glue("Missing column(s): {missing_cols}"))
  }

  if (missing(strict_name_match)) {
    name_match <- FALSE
  }

  if (missing(strict_address_match)) {
    address_match <- FALSE
  }
  # create vector of names to check against
  .data_names <- names(boston_bars)

  # create missing columns if needed.
  .data_filled <- .data %>%
    mutate(
      location_name = ifelse("location_name" %in% .data_names, location_name, NA_character_),
      strict_name_match = ifelse("strict_name_match" %in% .data_names, strict_name_match, name_match),
      strict_address_match = ifelse("strict_name_match" %in% .data_names, strict_address_match, address_match)
    )

  .data_pks <- pmap_chr(.data_filled, get_placekey)

  mutate(.data, placekey = .data_pks)

}

#' @rdname get_placekey
#' @method get_placekey list
#' @param .list A named list elements named `street_address`, `city`, `region`, `postal_code`, and `iso_country_code`.
#' @export
get_placekey.list <- function(.list, strict_name_match, strict_address_match) {
  # validate the provide data frame
  pk_names <- c("street_address", "city", "region", "postal_code", "iso_country_code")
  missing_pks <- rlang::has_name(.list, pk_names)

  if (any(!missing_pks)) {
    missing_cols <- glue::glue_collapse(pk_names[!missing_pks], ", ", last = " and ")
    stop(glue::glue("Missing list element(s): {missing_cols}"))
  }

  .data <- data.frame(.list, stringsAsFactors = FALSE)

  get_placekey.data.frame(.data)
}



