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

## See also

[`toa_quota()`](https://oddsapiR.sportsdataverse.org/reference/toa_quota.md)
to read cached usage from the most recent call without a network
round-trip,
[`toa_key()`](https://oddsapiR.sportsdataverse.org/reference/register_toa.md)
/
[register_toa](https://oddsapiR.sportsdataverse.org/reference/register_toa.md)
to configure your API key, and
[`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md)
to start pulling data. Part of the
[SportsDataverse](https://sportsdataverse.org/).

Other The Odds API: Account & Usage:
[`register_toa`](https://oddsapiR.sportsdataverse.org/reference/register_toa.md),
[`toa_quota()`](https://oddsapiR.sportsdataverse.org/reference/toa_quota.md)

## Examples

``` r
# \donttest{
  try(toa_requests())
#> ── API Key Usage data from the-odds-api.com ────────── oddsapiR 1.0.0 ──
#> ℹ Data updated: 2026-06-13 00:49:16 UTC
#> ℹ Odds API quota: 1265 used, 18735 remaining (last call cost 0)
#> # A tibble: 1 × 2
#>   requests_remaining requests_used
#>                <int>         <int>
#> 1              18735          1265
# }
```
