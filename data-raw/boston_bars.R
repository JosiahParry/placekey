## code to prepare `DATASET` dataset goes here
boston_bars <- readr::read_rds("/Users/josiah/github/boston_bars.rds") %>%
  select(location_name = name, street_number, route, city = locality,
         region = administrative_area_level_1,
         postal_code) %>%
  unite(street_address, street_number, route, sep = " ") %>%
  mutate(iso_country_code = "US")

usethis::use_data(boston_bars, overwrite = TRUE)
