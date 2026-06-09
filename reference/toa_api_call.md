# **Perform a GET request and parse the JSON body**

**Perform a GET request and parse the JSON body**

## Usage

``` r
toa_api_call(url, query = NULL, ...)
```

## Arguments

- url:

  Base endpoint URL (without query string).

- query:

  Named list of query parameters. `NULL` elements are omitted.

- ...:

  Passed to
  [`toa_api_request()`](https://oddsapiR.sportsdataverse.org/reference/toa_api_request.md).

## Value

The parsed JSON body (list / data.frame via
[`jsonlite::fromJSON()`](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html)).
