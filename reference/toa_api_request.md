# **Build and perform a GET request against The Odds API (httr2)**

Internal HTTP layer shared by every `toa_*()` wrapper. Builds an `httr2`
request from a base URL plus a named list of query parameters, applies
the standard user agent + transient-error retry policy, performs it, and
caches the `x-requests-*` usage-quota headers for
[`toa_quota()`](https://oddsapiR.sportsdataverse.org/reference/toa_quota.md).
`NULL` query values are dropped automatically by
[`httr2::req_url_query()`](https://httr2.r-lib.org/reference/req_url.html),
so optional parameters can be threaded through unconditionally.

## Usage

``` r
toa_api_request(url, query = NULL, ...)
```

## Arguments

- url:

  Base endpoint URL (without query string).

- query:

  Named list of query parameters. `NULL` elements are omitted.

- ...:

  Reserved for forward compatibility.

## Value

An `httr2_response` object.
