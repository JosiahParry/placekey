
<!-- README.md is generated from README.Rmd. Please edit that file -->

# placekey

An R package to create [Placekeys](https://www.placekey.io/). Interacts
with Uber’s H3 and the placekey API

This package implements coordinate lookup to h3 index look up to
generate a placekey. Avoids using the API. This allows offline use and
saves API queries.

``` terminal
brew install h3
```

``` r
devtools("josiahparry/h3r")
devtools("josiahparry/placekey")
```

``` r
library(placekey)

(x <- coord_to_placekey(10,10))
#> [1] "@b9f-q4k-d7r"

placekey_to_h3(x)
#> [1] "8a58e0682d70180"

h3_to_placekey(placekey_to_h3(x))
#> [1] "@b9f-q4k-d7r"

pk <- get_placekey(
  street_address = "1543 Mission Street, Floor 3",
  city = "San Francisco",
  region  ="CA",
  postal_code = 94105,
  iso_country_code = "US"
  )

pk
#> [1] "226@5vg-7gq-5mk"
```

  - to do:
      - create a `is_placekey()` function
      - get\_placekey() s3 methods
      - move h3r fork into this package
  - This relies on my fork of Scott Jackson’s `h3r` package
    (<https://github.com/josiahparry/h3r>).
      - h3r and [h3](https://github.com/crazycapivara/h3-r) do not
        return raw `H3` value.
      - I’ll have to take scotts code and include it in mine.
  - 
  - I notice that <https://github.com/uber/h3-py/tree/master/src/h3>
    includes the entirey of the c library in the src file. this r
    package requires h3 to be installed on your own.
