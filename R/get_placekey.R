# TO DO
# Create s3 methods.
# below is default different
# one to accept a list object and another to accept dataframe
# dataframe will use pmap

#' Query the Placekey API
#'
#' Queries the Placekey API and, if successful, returns a placekey.
#'
#' @importFrom httr add_headers POST content
#' @importFrom purrr discard
#' @importFrom magrittr %>%
#' @export
get_placekey <- function(location_name = NULL, street_address = NULL,
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
