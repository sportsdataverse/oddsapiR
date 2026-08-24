# **Inspect your Odds API usage quota**

Returns the usage-quota headers reported by The Odds API on the **most
recent** `toa_*()` call made in this R session. The Odds API returns
three headers with every response:

- `x-requests-remaining` – usage credits remaining until the quota
  resets

- `x-requests-used` – usage credits used since the last quota reset

- `x-requests-last` – the usage cost of the last API call

These same values are attached as attributes
(`oddsapiR_requests_remaining`, `oddsapiR_requests_used`,
`oddsapiR_requests_last`) to every tibble returned by a `toa_*()`
function, and are echoed when the tibble is printed.

## Usage

``` r
toa_quota()
```

## Value

A one-row tibble with columns `requests_remaining`, `requests_used` and
`requests_last`, or `NULL` if no API call has been made yet this
session.

## See also

[`toa_requests()`](https://oddsapiR.sportsdataverse.org/reference/toa_requests.md)
to explicitly query usage via an API round-trip,
[`toa_key()`](https://oddsapiR.sportsdataverse.org/reference/register_toa.md)
/
[register_toa](https://oddsapiR.sportsdataverse.org/reference/register_toa.md)
to set up your API key, and
[`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md)
for your first data call. Part of the
[SportsDataverse](https://sportsdataverse.org/).

Other The Odds API: Account & Usage:
[`register_toa`](https://oddsapiR.sportsdataverse.org/reference/register_toa.md),
[`toa_requests()`](https://oddsapiR.sportsdataverse.org/reference/toa_requests.md)

## Examples

``` r
# \donttest{
  try(toa_sports())
#> ── Sports coverage data from the-odds-api.com ──────── oddsapiR 1.0.0 ──
#> ℹ Data updated: 2026-08-24 07:15:14 UTC
#> ℹ Odds API quota: 8905 used, 4991095 remaining (last call cost 0)
#> # A tibble: 176 × 6
#>    key                      group title description active has_outrights
#>    <chr>                    <chr> <chr> <chr>       <lgl>  <lgl>        
#>  1 americanfootball_cfl     Amer… CFL   Canadian F… TRUE   FALSE        
#>  2 americanfootball_ncaaf   Amer… NCAAF US College… TRUE   FALSE        
#>  3 americanfootball_ncaaf_… Amer… NCAA… US College… TRUE   TRUE         
#>  4 americanfootball_nfl     Amer… NFL   US Football TRUE   FALSE        
#>  5 americanfootball_nfl_pr… Amer… NFL … US Football FALSE  FALSE        
#>  6 americanfootball_nfl_su… Amer… NFL … Super Bowl… TRUE   TRUE         
#>  7 americanfootball_ufl     Amer… UFL   United Foo… FALSE  FALSE        
#>  8 aussierules_afl          Auss… AFL   Aussie Foo… TRUE   FALSE        
#>  9 aussierules_aflw         Auss… AFL … Aussie Foo… TRUE   FALSE        
#> 10 baseball_kbo             Base… KBO   KBO League  FALSE  FALSE        
#> # ℹ 166 more rows
  try(toa_quota())
#> # A tibble: 1 × 3
#>   requests_remaining requests_used requests_last
#>                <int>         <int>         <int>
#> 1            4991095          8905             0
# }
```
