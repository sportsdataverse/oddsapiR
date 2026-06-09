# **Find out your usage and remaining calls for your key from The Odds API**

**Get your usage and remaining calls for your key from The Odds API.**

The values are read from the `x-requests-remaining` and
`x-requests-used` response headers returned with every API call. This
check is performed against the free `/v4/sports` endpoint, so it does
not consume any quota.

**Usage quota cost:** Free.

## Usage

``` r
toa_requests()
```

## Value

A tibble of The Odds API key usage with the following columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| requests_remaining | integer | Usage credits remaining until the monthly quota resets. |
| requests_used | integer | Usage credits consumed since the last quota reset. |

## Examples

``` r
# \donttest{
  try(toa_requests())
#> ── API Key Usage data from the-odds-api.com ────────── oddsapiR 1.0.0 ──
#> ℹ Data updated: 2026-06-09 08:16:24 UTC
#> ℹ Odds API quota: 39 used, 461 remaining (last call cost 0)
#> # A tibble: 1 × 2
#>   requests_remaining requests_used
#>                <int>         <int>
#> 1                461            39
# }
```
