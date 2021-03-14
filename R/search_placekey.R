#' Fetch place attributes by placekey
#'
#' Use the SafeGraph [Places API](https://docs.safegraph.com/reference#places-api) to fetch POI attributes for a given placekey.
#' @placekey A vector of placekeys. Must not exceed 100 values.
#' @key Your SafeGraph API key. Recommend to be stored as an environment variable called `SAFEKEY_SECRET`.
#'
#' @details The SafeGraph places API will only return up to 4000 rows. This utilize your $200 credit. Each subsequent placekey will cost $0.05. You will not be charged if you have not set up payment.
#'
#' Currently pagination and rate limiting for this API endpoint are not implemented.
#'
#' If you do not have an API key, generate one on SafeGraph's [website](https://shop.safegraph.com/api/).
#'
#'
#' @export
search_placekey <- function(placekey, key = Sys.getenv("SAFEGRAPH_SECRET")) {

  if (length(placekey) > 100) rlang::abort("Too many placekeys. Provide 100 or fewer.")

  q <- httr::POST("https://api.safegraph.com/v1/graphql",
                  body = list(query = construct_sg_query(placekey)),
                  httr::add_headers(apikey = Sys.getenv("SAFEGRAPH_SECRET")),
                  encode = "json")

  res <- httr::content(q, as = "text", encoding = "utf-8") %>%
    jsonlite::fromJSON()

  if (!is.null(purrr::pluck(res, "errors"))) {
    rlang::inform(purrr::pluck(res, "errors", "message"))
    rlang::abort("Query failed. Malformed or incomplete placekey likelly.")
  }

  purrr::pluck(res, "data", "places", "safegraph_core") %>%
    tibble::as_tibble() %>%
    dplyr::mutate(placekey = purrr::pluck(res, "data", "places", "placekey"))

}


#' Construct GraphQL query from vector of placekeys
#'
#' @keywords internal
construct_sg_query <- function(placekeys) {
  glue_skeleton <- 'query {
  places(placekeys: [pks]) {
    placekey
    safegraph_core {
      location_name
      street_address
      city
      region
      iso_country_code
    }
  }
}'

  pks <- glue::glue('"{placekeys}"') %>%
    glue::glue_collapse(sep = ", ")


  glue::glue_data(c("pks" = paste0("[", pks, "]")), glue_skeleton, .open = "[", .close = "]")
}

