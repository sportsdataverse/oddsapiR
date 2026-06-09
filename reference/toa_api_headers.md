# **Perform a GET request and return the quota usage headers**

**Perform a GET request and return the quota usage headers**

## Usage

``` r
toa_api_headers(url, query = NULL, ...)
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

A data.frame of `requests_remaining` / `requests_used`.
