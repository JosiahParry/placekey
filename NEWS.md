# placekey 0.1.0

* 2021-03-13: 
  - Add function `search_placekey()` which uses SafeGraph beta [Places API](https://docs.safegraph.com/reference). Needs a safegraph API key stored in the environment variable `SAFEGRAPH_SECRET`.
  - `get_placekeys()` function added to assist with bulk queries. 
  - `Makevars` modified in [PR#15](https://github.com/JosiahParry/placekey/pull/15) to make installation better. h/t [\@jannes-m](https://github.com/jannes-m). 
* 2020-11-22: `get_placekey()` modified to only return placekeys as a character vector as opposed to adding them to the provided data. 
