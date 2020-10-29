
<!-- README.md is generated from README.Rmd. Please edit that file -->

# placekey

An R package to create [Placekeys](https://www.placekey.io/). Interacts
with Uber’s H3 and the placekey API

  - This relies on my fork of Scott Jackson’s `h3r` package
    (<https://github.com/josiahparry/h3r>).
      - h3r and [h3](https://github.com/crazycapivara/h3-r) do not
        return raw `H3` value.
      - I’ll have to take scotts code and include it in mine.
  - 
  - I notice that <https://github.com/uber/h3-py/tree/master/src/h3>
    includes the entirey of the c library in the src file. this r
    package requires h3 to be installed on your own.

<!-- end list -->

``` terminal
brew install h3
```

``` r
devtools("josiahparry/placekey")
```
