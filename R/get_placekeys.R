#' Get Placekeys using the bulk API
#'
#' @inheritParams get_placekey
#' @param longitude Longitude in decimal degrees.
#' @param latitude Latitude in decimal degrees.
#' @import httr
#' @import purrr
#' @export
#' @examples
#' \dontrun{
#' # include in a mutate statement
#' boston_bars %>%
#'   slice(1:100) %>%
#'   mutate(placekey = get_placekeys(
#'     location_name,
#'     street_address,
#'     city,
#'     region,
#'     postal_code,
#'     iso_country_code
#'   ))
#' }
get_placekeys <- function(
  location_name = NA,
  street_address = NA,
  city = NA,
  region = NA,
  postal_code = NA,
  iso_country_code = NA,
  latitude = NA,
  longitude = NA,
  strict_address_match = FALSE,
  strict_name_match = FALSE,
  key = Sys.getenv("PLACEKEY_SECRET"),
  ...
) {


  options_list <- list(
    strict_name_match = strict_name_match,
    strict_address_match = strict_address_match
  )

  # Chunking input for bulk API limits --------------------------------------

  query_id <- as.character(1:length(street_address))
  # only 100 queries can be posted at one time
  n <- 100

  # figure out how many batches need to be made
  n_chunks <- ceiling(length(street_address)/ n)

  # find the indexes of the chunks
  chunk_starts <- seq(1, n*n_chunks, by = n)
  chunk_end <- n * (1:n_chunks)

  # modify last element of the vector so there are not extra NAs
  # in the last chunk. The last chunk never is evenly split up.
  chunk_end[length(chunk_end)] <- length(street_address)


  bulk_queries <- map2(chunk_starts, chunk_end, .f = ~{
    list(
      query_id = query_id[.x:.y],
      location_name = location_name[.x:.y],
      street_address = street_address[.x:.y],
      city = city[.x:.y],
      region = region[.x:.y],
      postal_code = postal_code[.x:.y],
      iso_country_code = iso_country_code[.x:.y],
      latitude = latitude[.x:.y],
      longitude = longitude[.x:.y]) %>%
      # using purrr::transpose to get to nested json compatible list format
      # each sub-element is a named list with each query field named
      transpose()
  })


  # Batch sending w/ rate limiting ------------------------------------------

  # start counting. only 100 bulk requests a min.
  start <- Sys.time()
  resp <- imap(bulk_queries, .f = ~{

    # discard any NA values so that lat & long are included or removed as needed
    queries <- map(.x, discard, is.na)

    # if we reach the 101st we sleep the remainder of the minute (if any is left)
    if ((.y > 1) & (.y %% 100 == 1)) {

      remainder <- (.y + 100 %/% 100) * 60 - (Sys.time - start)

      if (remainder > 0) Sys.sleep(remainder)
    }

    # using retry thrice just in case
    query <- httr::RETRY("POST",
                     url = "https://api.placekey.io/v1/placekeys",
                     body = list(queries = queries, options = options_list),
                     httr::add_headers(apikey = key), encode = "json",
                     times = 3)
    print(content(query))
    # parse the bulk placekey response
    parse_bulk_pk(query)

  })

  # make into character vector
  unlist(resp)

}



#' Function for parsing bulk API responses
#' @keywords internal
parse_bulk_pk <- function(resp) {
  res <- content(resp)

  map_chr(res, pluck, "placekey", .default = NA_character_)
}



