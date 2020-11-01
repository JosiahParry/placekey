
<!-- README.md is generated from README.Rmd. Please edit that file -->

# placekey

{placekey} is an R package to interact with the
[Placekey](https://www.placekey.io/) API.

## Installing

Some functionality of placekey requires the utilizing of the C library
[H3](https://h3geo.org/) from Uber. Ensure that you have H3 installed
prior to installing placekey. The instructions to install h3 can be
found on the H3 [GitHub repository](https://github.com/uber/H3). If you
are using macOS, I recommend installing from
[Homebrew](https://brew.sh/).

If you do not have homebrew installed, go to brew.sh and follow the
installation instructions. Open up spotlight search and open up the
terminal application. Run `brew --version` to see if you have Homebrew
installed. If that command doesn’t return anything un `/bin/bash -c
"$(curl -fsSL
https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`
to install Homebrew. Then use Homebrew to install H3.

``` terminal
brew install h3
```

Once H3 is installed, you can install placekey.

``` r
devtools("josiahparry/placekey")
```

## Getting placekeys from an address

To get the placekey for a place of interest (POI) you will use the
`get_placekey()` function. To search for a placekey from an address, the
arguments `street_address`, `city`, `region`, `postal_code`, and
`iso_country_code` are required. You can optionally provide the argument
`location_name` and `strict_address_match` as well as
`strict_name_match`.

``` r
library(placekey)
library(magrittr)

get_placekey(
  street_address = "1543 Mission Street, Floor 3",
  city = "San Francisco",
  region  ="CA",
  postal_code = 94105,
  iso_country_code = "US"
  )
#> [1] "226@5vg-7gq-5mk"
```

Alternatively, you can pass in a dataframe with column names that match
required arguments. The built in dataset `boston_bars` is formatted as
such. This method adds a new column to the provided dataframe containing
the placekey.

``` r
get_placekey(placekey::boston_bars[2:5,])
#> # A tibble: 4 x 7
#>   location_name street_address city  region postal_code iso_country_code
#>   <chr>         <chr>          <chr> <chr>  <chr>       <chr>           
#> 1 Studio 3      670 Legacy Bo… Dedh… Massa… 02026       US              
#> 2 Showcase Cin… 200 Elm Street Dedh… Massa… 02026       US              
#> 3 Victory Gril… 233 Elm Street Dedh… Massa… 02026       US              
#> 4 Aquitaine De… 500 Legacy Pl… Dedh… Massa… 02026       US              
#> # … with 1 more variable: placekey <chr>
```

Alternatively, you can provide a named list. Doing so will create a new
element called `placekey` which contains the placekey for the provided
place. The length of the list can be greater than one.

``` r
list(
  street_address = "1543 Mission Street, Floor 3",
  city = "San Francisco",
  region  ="CA",
  postal_code = 94105,
  iso_country_code = "US"
  ) %>% 
  get_placekey()
#> $street_address
#> [1] "1543 Mission Street, Floor 3"
#> 
#> $city
#> [1] "San Francisco"
#> 
#> $region
#> [1] "CA"
#> 
#> $postal_code
#> [1] 94105
#> 
#> $iso_country_code
#> [1] "US"
#> 
#> $placekey
#> [1] "226@5vg-7gq-5mk"
#> 
#> attr(,"row.names")
#> [1] 1
```

## Additional usage

You can get a placekey from a coordinate.

``` r
# Get a placekey from a coordinate
(origin <- coord_to_placekey(10,10))
#> [1] "@b9f-q4k-d7r"
```

Placekeys can be converted to and from the H3 index.

``` r
# convert placekey to h3 index
(origin_h3 <- placekey_to_h3(origin))
#> [1] "8a58e0682d70180"

# convet h3 index back to a placekey 
h3_to_placekey(origin_h3)
#> [1] "@b9f-q4k-d7r"
```

Validate placekeys with `is_placekey()`

``` r
# Validate placekeys 
is_placekey("@b9f-q4k-d7r")
#> [1] TRUE

is_placekey("123@b9f-q4k-d7r")
#> [1] FALSE
```

## Notes

This package does not support querying latitude and longitude to the
placekey API. The same functionality is provided by the
`coord_to_placekey()` function.

The spatial capabilities are supported by H3 are limited as the two
packages to interact with H3, `h3r` and `h3`, are not released on CRAN.
This package adapts and limits Scott Jackson’s `h3r` package
(<https://github.com/scottmmjackson/h3r>). Without his concise code,
this package couldn’t exist. Thank you Scott\!
